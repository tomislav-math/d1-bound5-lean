"""Narrow, offline migration for confirmed resource-limited, unpublished definitions.

The global uploader must release its state lock first. Unchanged pending jobs
remain in the ledger and continue on the server; their requests are not retried.
Published nodes, submitted proofs and unresolved mutation intents are immutable.
Default execution validates and reports only. --apply commits one atomic state
replacement after durable archival of the old ledger and changed entries.
"""
from __future__ import annotations

import argparse
import copy
import datetime
import fcntl
import hashlib
import json
from pathlib import Path
import re
import uuid

from batch_uploader import Halt, Uploader, digest, validate
from global_uploader import ReceiptStore, atomic_bytes, encoded


SIGNATURE_FIELDS = ("kind", "payload", "solution_sha256", "explanation",
                    "publish_dependencies", "proof_dependencies")
SIZE_ERROR = re.compile(r"Source too large for token scanner:\s*(\d+)\s+bytes\s*\(max\s+(\d+)\)")
DEFAULT_SOURCE_LIMIT = 1048576
SCANNER_TIMEOUT = "could not lex the submitted code: Token scanner timed out after 10s"
DB_CONNECTION_ERROR = re.compile(r"DB error looking up import[\s\S]*<ConnectionTerminated\s+error_code:0(?:,|>)")
DB_CONNECTION_RETRY_NODES = {"D1Bound5_SmallPairPureClosureData10VerticesChunk01_Definitions"}
COMPILATION_TIMEOUT = (
    "Compilation timed out after 300s. Try breaking the statement or proof into smaller lemmas or definitions and checking each piece separately before retrying. "
    "If imports are heavy, prefer the specific Mathlib modules you need over `import Mathlib`."
)
COMPILATION_TIMEOUT_IMPORT_GUIDANCE = (
    "Compilation timed out after 300s. The most common cause is a heavy import — prefer the specific Mathlib modules you need over `import Mathlib`. "
    "Splitting a large definition into separate definitions also helps, since each is compiled and cached once."
)
COMPILATION_TIMEOUT_MESSAGES = (COMPILATION_TIMEOUT, COMPILATION_TIMEOUT_IMPORT_GUIDANCE)
CACHED_LITERAL_SHAPE = "exact-cached-literal-split-v1"
PELL_LITERAL_SHAPE = "exact-pell-literal-split-v1"


def signature(node):
    return digest({key: node.get(key) for key in SIGNATURE_FIELDS})


def load_json(path):
    path = Path(path)
    data = path.read_bytes()
    return json.loads(data), {"path": str(path.resolve()), "sha256": hashlib.sha256(data).hexdigest(),
                              "bytes": len(data)}


def existing_identities(items):
    return {name: (item["kind"], item["id"]) for name, item in items.items()}


def pending_entries(entries):
    return {name: copy.deepcopy(entry) for name, entry in entries.items() if Uploader.is_active(entry)}


def load_existing_receipt(state_path, reference):
    if not isinstance(reference, dict):
        raise Halt("Failed definition has no saved publication receipt")
    if set(reference) != {"path", "sha256", "bytes"}:
        # A copied legacy ledger may still embed the exact response directly.
        return reference
    state_path = Path(state_path)
    path = (state_path.parent / reference["path"]).resolve()
    allowed = (state_path.parent / (state_path.name + ".receipts")).resolve()
    if path.parent != allowed:
        raise Halt("Publication receipt escapes the ledger's receipt store")
    data = path.read_bytes()
    if len(data) != reference["bytes"] or hashlib.sha256(data).hexdigest() != reference["sha256"]:
        raise Halt("Publication receipt hash mismatch")
    return json.loads(data)


def failed_receipt(state_path, entry, name):
    receipt = load_existing_receipt(state_path, entry.get("publish_receipt"))
    if receipt.get("status") != "FAILED":
        raise Halt("Saved publication receipt does not confirm terminal FAILED")
    if receipt.get("id", receipt.get("job_id")) != entry.get("job_id"):
        raise Halt("Failure receipt belongs to a different publication job: " + name)
    if receipt.get("theorem_name", receipt.get("definition_name")) != name:
        raise Halt("Failure receipt belongs to a different definition: " + name)
    return receipt


def failed_adaptation_kind(state_path, entry, name, cached_literal_verified=False):
    receipt = failed_receipt(state_path, entry, name)
    messages = [receipt.get(key) for key in ("error_message", "error", "message")]
    for message in messages:
        if isinstance(message, str) and (match := SIZE_ERROR.search(message)):
            measured, maximum = map(int, match.groups())
            if measured > maximum > 0:
                return "failed_source_size", maximum
    if any(isinstance(message, str) and SCANNER_TIMEOUT in message for message in messages):
        return "failed_scanner_timeout", DEFAULT_SOURCE_LIMIT
    if cached_literal_verified and any(message in COMPILATION_TIMEOUT_MESSAGES for message in messages):
        return "failed_compilation_timeout", DEFAULT_SOURCE_LIMIT
    raise Halt("Failed publication is not the approved scanner or verified cached-literal compilation-timeout error: " + name)


def verify_cached_literal_change(old_node, new_node, new_nodes, declared):
    provenance = declared.get("adaptation_provenance")
    if provenance is None:
        return None
    if not isinstance(provenance, dict) or provenance.get("shape") not in {CACHED_LITERAL_SHAPE, PELL_LITERAL_SHAPE}:
        raise Halt("Unknown cached-literal adaptation provenance: " + old_node["name"])
    for key, node in (("old_source_sha256", old_node), ("new_source_sha256", new_node)):
        if provenance.get(key) != hashlib.sha256(node["payload"]["definition"].encode()).hexdigest():
            raise Halt("Cached-literal provenance source hash mismatch: " + old_node["name"] + " / " + key)
    # Reparse the actual old/new sources and each declared helper. Metadata alone
    # never authorizes changing a failed definition. This pure verifier performs
    # no file writes, authentication or API requests.
    if provenance["shape"] == PELL_LITERAL_SHAPE:
        from adapt_pell_literals_v5 import AdaptationError, verify_adaptation
    else:
        from adapt_cached_literals import AdaptationError, verify_adaptation
    try:
        verified = verify_adaptation(old_node, new_node, new_nodes, provenance)
    except (AdaptationError, KeyError, TypeError, ValueError) as error:
        raise Halt("Cached-literal adaptation verification failed: " + old_node["name"] + ": " + str(error)) from error
    if (not isinstance(verified, dict) or not isinstance(verified.get("helper_names"), list)
            or not verified["helper_names"] or any(not isinstance(name, str) for name in verified["helper_names"])
            or verified.get("exact_source_reconstruction") is not True
            or not isinstance(verified.get("declarations"), int) or verified["declarations"] < 1):
        raise Halt("Cached-literal verifier returned no exact helper set: " + old_node["name"])
    return {"provenance": copy.deepcopy(provenance), "verification": verified}


def confirmed_scanner_timeout(state_path, entry, name):
    receipt = failed_receipt(state_path, entry, name)
    return any(
        isinstance(receipt.get(key), str) and SCANNER_TIMEOUT in receipt[key]
        for key in ("error_message", "error", "message"))


def confirmed_db_connection_error(state_path, entry, name):
    receipt = failed_receipt(state_path, entry, name)
    return any(isinstance(receipt.get(key), str) and DB_CONNECTION_ERROR.search(receipt[key])
               for key in ("error_message", "error", "message"))


def checked_migration(old_path, new_path, state_path, changes_path, retry_terminal_scanner_timeouts=(),
                      retry_terminal_db_connections=()):
    old_raw, old_record = load_json(old_path)
    new_raw, new_record = load_json(new_path)
    state, state_record = load_json(state_path)
    changes, changes_record = load_json(changes_path)
    expected_new_hash = changes.get("final_manifest_sha256", changes.get("new_manifest_sha256"))
    if changes.get("old_manifest_sha256") != old_record["sha256"] or expected_new_hash != new_record["sha256"]:
        raise Halt("Changes document does not identify these exact old/new manifests")
    if "ready_for_upload" in new_raw and new_raw["ready_for_upload"] is not True:
        raise Halt("New manifest has not completed its export validation")
    reason = changes.get("reason")
    if not isinstance(reason, str) or not reason.strip():
        raise Halt("A concrete migration reason is required")
    if old_raw.get("env") != new_raw.get("env") or old_raw.get("env") != state.get("env"):
        raise Halt("Manifest/ledger environment mismatch")
    if any(value.get("private") is not True for value in (old_raw, new_raw, state)):
        raise Halt("All manifests and the ledger must remain private")
    old_nodes, old_existing = validate(old_raw, Path(old_path).parent)
    new_nodes, new_existing = validate(new_raw, Path(new_path).parent)
    if existing_identities(old_existing) != existing_identities(new_existing):
        raise Halt("Existing platform identifiers may not change during this migration")
    removed = set(old_nodes) - set(new_nodes)
    if removed:
        raise Halt("Manifest migration may not remove nodes: " + str(sorted(removed)))
    old_signatures = {name: signature(node) for name, node in old_nodes.items()}
    new_signatures = {name: signature(node) for name, node in new_nodes.items()}
    changed = {name for name in old_nodes if old_signatures[name] != new_signatures[name]}
    added = set(new_nodes) - set(old_nodes)
    declarations = changes.get("changed_nodes", [])
    if not isinstance(declarations, list) or any(not isinstance(item, dict) or not item.get("name") or not item.get("reason") for item in declarations):
        raise Halt("changed_nodes must list named nodes with individual reasons")
    declared_changed = [item["name"] for item in declarations]
    declared_added = changes.get("added_nodes", [])
    if not isinstance(declared_added, list) or any(not isinstance(name, str) for name in declared_added):
        raise Halt("added_nodes must be a list of names")
    if len(set(declared_changed)) != len(declared_changed) or len(set(declared_added)) != len(declared_added):
        raise Halt("Duplicate node in changes document")
    if set(declared_changed) != changed or set(declared_added) != added:
        raise Halt("Actual manifest changes differ from the declared changed/added node sets")
    retries = set(retry_terminal_scanner_timeouts)
    db_retries = set(retry_terminal_db_connections)
    if len(retries) != len(retry_terminal_scanner_timeouts):
        raise Halt("Duplicate requested scanner-timeout retry")
    if len(db_retries) != len(retry_terminal_db_connections):
        raise Halt("Duplicate requested DB connection retry")
    if not db_retries <= DB_CONNECTION_RETRY_NODES:
        raise Halt("DB connection retry is not authorized for these node names")
    if retries & db_retries:
        raise Halt("A node cannot request two different transient retries together")
    if not changed and not retries and not db_retries:
        raise Halt("No changed definition or authorized terminal retry was identified")
    if any(action.get("stage") != "recorded" for action in state.get("actions", {}).values()):
        raise Halt("Unresolved mutation intent/response must be reconciled before migration")
    entries = state["entries"]
    for name, entry in entries.items():
        if name in old_nodes and entry.get("manifest_sha256") not in (None, old_signatures[name]):
            raise Halt("Ledger signature differs from old manifest: " + name)
        if name not in old_nodes and name not in old_existing:
            raise Halt("Ledger contains a node absent from the old manifest: " + name)
    for name, binding in old_existing.items():
        if name in entries and entries[name].get("theorem_id", binding["id"]) != binding["id"]:
            raise Halt("Ledger identity differs from manifest binding: " + name)
    migration_id = uuid.uuid4().hex
    revised = copy.deepcopy(state)
    previous = {}
    previous_retries = {}
    previous_db_retries = {}
    classes = {}
    source_limits = {}
    source_lengths = {}
    cached_verifications = {}
    declared_details = {item["name"]: item for item in declarations}
    action_names = {name for action in state.get("actions", {}).values() for name in action.get("names", [])}
    for name in sorted(changed):
        if old_nodes[name]["kind"] != "definition" or new_nodes[name]["kind"] != "definition":
            raise Halt("This migration only adapts definition payloads: " + name)
        entry = entries.get(name, {"kind": "definition"})
        if name in old_existing or entry.get("theorem_id") or entry.get("existing") or entry.get("submission_id"):
            raise Halt("Published identities and submitted proofs are immutable: " + name)
        if Uploader.is_active(entry):
            raise Halt("Changed node still has an active server job: " + name)
        old_source = old_nodes[name]["payload"]["definition"]
        new_source = new_nodes[name]["payload"]["definition"]
        old_length, new_length = len(old_source.encode()), len(new_source.encode())
        for field, length in (("old_source_bytes", old_length), ("new_source_bytes", new_length)):
            if field in declared_details[name] and declared_details[name][field] != length:
                raise Halt("Changes document has an incorrect source byte count: " + name + " / " + field)
        if declared_details[name].get("adaptation_provenance") is not None and new_length >= old_length:
            raise Halt("Cached-literal adaptation must strictly reduce definition source bytes: " + name)
        cached_verification = verify_cached_literal_change(old_nodes[name], new_nodes[name], new_nodes,
                                                            declared_details[name])
        if cached_verification is not None:
            cached_verifications[name] = cached_verification
        elif changes.get("schema", "").startswith(("p2m-cached-literal-adaptation", "p2m-pell-literal-adaptation")):
            raise Halt("Cached-literal changes document lacks verified shape provenance: " + name)
        untouched = not entry.get("job_id") and name not in action_names and not entry.get("publish_status")
        if untouched:
            classes[name] = "never_submitted"
            maximum = DEFAULT_SOURCE_LIMIT
        elif entry.get("publish_status") == "FAILED" and entry.get("job_id"):
            classes[name], maximum = failed_adaptation_kind(state_path, entry, name, cached_verification is not None)
            if classes[name] in {"failed_scanner_timeout", "failed_compilation_timeout"} and new_length >= old_length:
                raise Halt("Timeout adaptation must strictly reduce definition source bytes: " + name)
        else:
            raise Halt("Changed node is neither never-submitted nor a confirmed resource failure: " + name)
        if new_length > maximum:
            raise Halt("Replacement definition still exceeds the recorded source limit: " + name)
        source_limits[name] = maximum
        source_lengths[name] = {"before": old_length, "after": new_length}
        previous[name] = copy.deepcopy(entries.get(name))
        updated = copy.deepcopy(entry)
        if classes[name] in {"failed_source_size", "failed_scanner_timeout", "failed_compilation_timeout"}:
            for key in ("job_id", "publish_status", "publish_receipt", "publish_error"):
                updated.pop(key, None)
        updated["manifest_sha256"] = new_signatures[name]
        updated["last_manifest_migration"] = migration_id
        revised["entries"][name] = updated
    if cached_verifications:
        verified_helpers = {helper for record in cached_verifications.values()
                            for helper in record["verification"]["helper_names"]}
        if not verified_helpers <= added:
            raise Halt("Cached-literal helpers must be newly declared immutable additions")
        if changes.get("schema", "").startswith(("p2m-cached-literal-adaptation", "p2m-pell-literal-adaptation")) and verified_helpers != added:
            raise Halt("Cached-literal changes include an unverified helper addition")
    for name in sorted(added):
        if name in entries or name in old_existing:
            raise Halt("Added helper would overwrite an existing ledger identity: " + name)
        if new_nodes[name]["kind"] != "definition":
            raise Halt("This migration only adds helper definitions: " + name)
        if len(new_nodes[name]["payload"]["definition"].encode()) > DEFAULT_SOURCE_LIMIT:
            raise Halt("Added helper itself exceeds the source limit: " + name)
        revised["entries"][name] = {"kind": "definition", "manifest_sha256": new_signatures[name],
                                    "created_by_manifest_migration": migration_id}
    for name in sorted(retries):
        if name not in old_nodes or name not in new_nodes or name in changed:
            raise Halt("Scanner-timeout retry requires an unchanged existing payload: " + name)
        entry = entries.get(name, {})
        if old_nodes[name]["kind"] != "definition" or name in old_existing or entry.get("existing") or entry.get("theorem_id") or entry.get("submission_id"):
            raise Halt("Scanner-timeout retry cannot reset published nodes or proofs: " + name)
        if entry.get("publish_status") != "FAILED" or not entry.get("job_id") or Uploader.is_active(entry):
            raise Halt("Scanner-timeout retry requires an unambiguous terminal FAILED job: " + name)
        if entry.get("scanner_timeout_retry_count", 0) != 0:
            raise Halt("Scanner-timeout retry has already been used once: " + name)
        if not confirmed_scanner_timeout(state_path, entry, name):
            raise Halt("Saved receipt does not confirm the exact scanner-timeout error: " + name)
        previous_retries[name] = copy.deepcopy(entry)
        updated = copy.deepcopy(entry)
        for key in ("job_id", "publish_status", "publish_receipt", "publish_error"):
            updated.pop(key, None)
        updated.update(scanner_timeout_retry_count=1, last_manifest_migration=migration_id,
                       manifest_sha256=new_signatures[name])
        revised["entries"][name] = updated
    for name in sorted(db_retries):
        if name not in old_nodes or name not in new_nodes or name in changed:
            raise Halt("DB connection retry requires an unchanged existing payload: " + name)
        entry = entries.get(name, {})
        if old_nodes[name]["kind"] != "definition" or name in old_existing or entry.get("existing") or entry.get("theorem_id") or entry.get("submission_id"):
            raise Halt("DB connection retry cannot reset published nodes or proofs: " + name)
        if entry.get("publish_status") != "FAILED" or not entry.get("job_id") or Uploader.is_active(entry):
            raise Halt("DB connection retry requires an unambiguous terminal FAILED job: " + name)
        if entry.get("db_connection_retry_count", 0) != 0:
            raise Halt("DB connection retry has already been used once: " + name)
        if not confirmed_db_connection_error(state_path, entry, name):
            raise Halt("Saved receipt does not confirm the exact DB connection-termination error: " + name)
        previous_db_retries[name] = copy.deepcopy(entry)
        updated = copy.deepcopy(entry)
        for key in ("job_id", "publish_status", "publish_receipt", "publish_error"):
            updated.pop(key, None)
        updated.update(db_connection_retry_count=1, last_manifest_migration=migration_id,
                       manifest_sha256=new_signatures[name])
        revised["entries"][name] = updated
    for name in set(entries) - changed - retries - db_retries:
        if revised["entries"][name] != entries[name]:
            raise Halt("Unchanged ledger entry was modified: " + name)
    if revised["actions"] != state["actions"] or pending_entries(revised["entries"]) != pending_entries(entries):
        raise Halt("Migration altered existing mutation history or pending jobs")
    report = {"schema": "p2m-manifest-migration-v1", "id": migration_id,
              "utc": datetime.datetime.now(datetime.timezone.utc).isoformat(), "reason": reason,
              "old_manifest": old_record, "new_manifest": new_record,
              "state_before": state_record, "changes_document": changes_record,
              "changed_nodes": {name: {"classification": classes[name], "old_signature": old_signatures[name],
                                        "new_signature": new_signatures[name], "previous_entry": previous[name],
                                        "source_limit": source_limits[name], "source_bytes": source_lengths[name],
                                        **({"cached_literal_verification": cached_verifications[name]}
                                           if name in cached_verifications else {})}
                                for name in sorted(changed)},
              "added_nodes": sorted(added), "unchanged_nodes_verified": len(old_nodes) - len(changed),
              "retried_scanner_timeouts": {name: {"previous_entry": previous_retries[name],
                  "unchanged_signature": new_signatures[name], "retry_count_before": 0,
                  "retry_count_after": 1} for name in sorted(retries)},
              "retried_db_connections": {name: {"previous_entry": previous_db_retries[name],
                  "unchanged_signature": new_signatures[name], "retry_count_before": 0,
                  "retry_count_after": 1} for name in sorted(db_retries)},
              "pending_jobs_preserved": len(pending_entries(entries)),
              "existing_actions_preserved": len(state["actions"])}
    return revised, report, state


def migrate(old_path, new_path, state_path, changes_path, apply=False, retry_terminal_scanner_timeouts=(),
            retry_terminal_db_connections=()):
    state_path = Path(state_path)
    # This is the exact lock used by both uploader entry points.
    with open(str(state_path) + ".lock", "a+") as lock:
        try:
            fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as error:
            raise Halt("Uploader still owns the ledger; wait for a controlled checkpoint") from error
        revised, report, old_state = checked_migration(old_path, new_path, state_path, changes_path,
                                                      retry_terminal_scanner_timeouts, retry_terminal_db_connections)
        if not apply:
            return {"mode": "DRY_RUN", **report}
        store = ReceiptStore(state_path)
        report["old_state_receipt"] = store.put(old_state)
        archive = store.put(report)
        revised.setdefault("manifest_migrations", []).append({"id": report["id"], "archive": archive,
            "old_manifest_sha256": report["old_manifest"]["sha256"],
            "new_manifest_sha256": report["new_manifest"]["sha256"],
            "changed_nodes": sorted(report["changed_nodes"]), "added_nodes": report["added_nodes"],
            "retried_scanner_timeouts": sorted(report["retried_scanner_timeouts"]),
            "retried_db_connections": sorted(report["retried_db_connections"])})
        # Lock ownership prevents a second coordinator writing between audit and
        # this replacement. A failed archival write leaves the old state intact.
        atomic_bytes(state_path, encoded(revised))
        return {"mode": "APPLIED", "archive": archive, **report}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--old-manifest", type=Path, required=True)
    parser.add_argument("--new-manifest", type=Path, required=True)
    parser.add_argument("--state", type=Path, required=True)
    parser.add_argument("--changes", type=Path, required=True)
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--retry-terminal-scanner-timeout", action="append", default=[], metavar="NAME",
                        help="Retry this unchanged definition once, only after its saved FAILED scanner-timeout receipt")
    parser.add_argument("--retry-terminal-db-connection", action="append", default=[], metavar="NAME",
                        help="Retry the explicitly allowed unchanged definition once after its saved FAILED DB connection-termination receipt")
    args = parser.parse_args()
    result = migrate(args.old_manifest, args.new_manifest, args.state, args.changes, args.apply,
                     args.retry_terminal_scanner_timeout, args.retry_terminal_db_connection)
    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
