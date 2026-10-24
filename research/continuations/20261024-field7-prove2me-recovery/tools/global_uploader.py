"""Compact, resumable Prove2Me uploader for a complete project manifest.

Importing this module performs no authentication or network operations. Exact
API payloads and receipts are immutable content-addressed files; the frequently
checkpointed ledger contains only identifiers, statuses and receipt references.
The bounded scheduler and manifest validation come from batch_uploader.
"""
from __future__ import annotations

import argparse
from collections import deque
import fcntl
import hashlib
import importlib
import json
import os
from pathlib import Path
import signal
import tempfile
import time
import uuid

from batch_uploader import (
    Halt, Uploader, MAX_ACTIVE_JOBS, PUBLISH_PENDING, PROOF_PENDING, PROOF_SUCCESS, PROOF_TERMINAL,
)


def encoded(value):
    return (json.dumps(value, sort_keys=True, ensure_ascii=False, separators=(",", ":")) + "\n").encode()


def sync_directory(path):
    descriptor = os.open(path, os.O_RDONLY)
    try:
        os.fsync(descriptor)
    finally:
        os.close(descriptor)


def atomic_bytes(path, data):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temporary = tempfile.mkstemp(prefix=path.name + ".", suffix=".tmp", dir=path.parent)
    try:
        with os.fdopen(descriptor, "wb") as stream:
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
        sync_directory(path.parent)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


class ReceiptStore:
    def __init__(self, state_path):
        state_path = Path(state_path)
        self.base = state_path.parent
        self.directory = self.base / (state_path.name + ".receipts")
        self.directory.mkdir(parents=True, exist_ok=True)

    def put(self, value):
        data = encoded(value)
        sha = hashlib.sha256(data).hexdigest()
        path = self.directory / (sha + ".json")
        if path.exists():
            if hashlib.sha256(path.read_bytes()).hexdigest() != sha:
                raise Halt("Immutable receipt content has changed: " + str(path))
        else:
            # A single locked coordinator owns writes. Atomic replacement keeps
            # incomplete files invisible; existing receipts are never rewritten.
            atomic_bytes(path, data)
        return {"path": str(path.relative_to(self.base)), "sha256": sha, "bytes": len(data)}

    def get(self, reference):
        path = (self.base / reference["path"]).resolve()
        if path.parent != self.directory.resolve():
            raise Halt("Receipt reference escapes its store")
        try:
            data = path.read_bytes()
        except OSError as error:
            raise Halt("Recorded receipt is unavailable: " + str(path)) from error
        if len(data) != reference["bytes"] or hashlib.sha256(data).hexdigest() != reference["sha256"]:
            raise Halt("Recorded receipt hash mismatch: " + str(path))
        return json.loads(data)


def seed_state(manifest, bindings, state_path, legacy_paths=()):
    """Create a new compact ledger from exact existing IDs and saved receipts.

    Existing files are not changed. Legacy ledgers are read-only; ambiguous or
    not-yet-applied mutation responses must be reconciled in their owning ledger
    before migration. A seeded state never claims a request was retried.
    """
    path = Path(state_path)
    if path.exists():
        saved = json.loads(path.read_text())
        if saved.get("env") != manifest.get("env") or saved.get("private") is not True:
            raise Halt("Existing global ledger has a different environment or visibility")
        return saved
    if manifest.get("private") is not True or not manifest.get("env"):
        raise Halt("Cannot seed an unpinned or non-private manifest")
    named = {item["name"]: item for item in manifest.get("existing", [])}
    allowed = {item["name"]: item["kind"] for item in manifest.get("nodes", [])}
    allowed.update({name: item["kind"] for name, item in named.items()})
    entries = {}
    source_to_platform = {}
    for source, binding in bindings.items():
        name = binding.get("platform_name", source)
        source_to_platform[source] = name
        if name not in allowed or binding.get("kind") != allowed[name]:
            raise Halt("Existing binding is absent or has a different kind: " + name)
        if name not in named or named[name]["id"] != binding["id"]:
            raise Halt("Manifest must retain the exact existing binding: " + name)
        entry = {"kind": binding["kind"], "theorem_id": binding["id"],
                 "existing": True, "publish_status": "PUBLISHED"}
        for key in ("job_id", "submission_id", "proof_status", "solution_sha256"):
            if binding.get(key) is not None:
                entry[key] = binding[key]
        if entry.get("proof_status") and not entry.get("submission_id"):
            raise Halt("A saved proof status needs its submission ID: " + name)
        entries[name] = entry
    provenance = []
    store = ReceiptStore(path)
    for legacy_path in legacy_paths:
        legacy_path = Path(legacy_path)
        raw = legacy_path.read_bytes()
        legacy = json.loads(raw)
        if legacy.get("env") != manifest["env"] or not (
            legacy.get("private") is True or legacy.get("visibility") == "private"
        ):
            raise Halt("Legacy ledger environment or visibility mismatch: " + str(legacy_path))
        if any(action.get("stage") != "recorded" for action in legacy.get("actions", {}).values()):
            raise Halt("Legacy ledger has an unresolved mutation; recover it before migration")
        provenance.append({"path": str(legacy_path), "sha256": hashlib.sha256(raw).hexdigest(),
                           "receipt": store.put(legacy)})
        for source, old in legacy.get("entries", {}).items():
            name = source_to_platform.get(source, source)
            if name not in entries:
                raise Halt("Legacy entry is absent from existing bindings: " + name)
            current = entries[name]
            if old.get("theorem_id") and old["theorem_id"] != current["theorem_id"]:
                raise Halt("Legacy theorem ID disagrees with binding: " + name)
            for key in ("job_id", "submission_id", "proof_status", "solution_sha256"):
                if old.get(key) is not None:
                    if current.get(key) not in (None, old[key]):
                        raise Halt("Legacy proof/publication receipt disagrees: " + name + " / " + key)
                    current[key] = old[key]
        # Older root-reduction ledgers stored the main submission separately.
        if legacy.get("root"):
            root = entries.get("D1Bound5.main_statement")
            if root is None:
                raise Halt("Legacy root proof is absent from global bindings")
            old = legacy["root"]
            for key, old_key in (("submission_id", "submission_id"), ("proof_status", "status"),
                                 ("solution_sha256", "solution_sha256")):
                if old.get(old_key) is not None:
                    if root.get(key) not in (None, old[old_key]):
                        raise Halt("Legacy root proof receipt disagrees: " + key)
                    root[key] = old[old_key]
    state = {"schema": "p2m-private-global-v2", "env": manifest["env"], "private": True,
             "entries": entries, "actions": {}, "max_active_observed": 0,
             "seeded_unix": time.time(), "seed_provenance": provenance,
             "bindings_receipt": store.put(bindings)}
    atomic_bytes(path, encoded(state))
    return state


class GlobalUploader(Uploader):
    def __init__(self, *args, **kwargs):
        self.graph_first_root = kwargs.pop("graph_first_root", None)
        total_limit = kwargs.get("limit", args[3] if len(args) > 3 else 15)
        requested_proof_limit = kwargs.pop("max_graph_proofs", None)
        self.max_graph_proofs = min(3, total_limit) if requested_proof_limit is None else requested_proof_limit
        if not 1 <= self.max_graph_proofs <= min(total_limit, MAX_ACTIVE_JOBS):
            raise Halt("Graph-first proof concurrency must be between one and the total queue limit (at most %d)" % MAX_ACTIVE_JOBS)
        path = kwargs.get("state_path", args[2] if len(args) > 2 else None)
        if path is None:
            raise TypeError("state_path is required")
        self.receipts = ReceiptStore(path)
        self._normalised = False
        super().__init__(*args, **kwargs)
        self.kinds = {name: node["kind"] for name, node in self.nodes.items()}
        self.kinds.update({name: binding["kind"] for name, binding in self.existing.items()})
        self.graph_depths = {}
        if self.graph_first_root:
            if self.publish_only:
                raise Halt("Graph-first and publish-only are mutually exclusive")
            if self.graph_first_root not in self.nodes or self.kinds[self.graph_first_root] != "theorem":
                raise Halt("Graph-first root must be a theorem node with dependency metadata")
            pending = deque([(self.graph_first_root, 0)])
            while pending:
                name, depth = pending.popleft()
                if name in self.graph_depths:
                    continue
                self.graph_depths[name] = depth
                for dependency in self.theorem_dependencies(name):
                    pending.append((dependency, depth + 1))
            self.state["scheduling"] = {"mode": "graph_first", "root": self.graph_first_root,
                                        "max_active_proofs": self.max_graph_proofs,
                                        "leaf_proofs_deferred": True}
        else:
            self.state["scheduling"] = {"mode": "publish_only" if self.publish_only else "all_proofs"}
        self.save()

    def theorem_dependencies(self, name):
        return [dependency for dependency in self.nodes.get(name, {}).get("proof_dependencies", [])
                if self.kinds.get(dependency) == "theorem"]

    def active_proofs(self):
        return sum(bool(entry.get("submission_id")) and entry.get("proof_status", "PENDING") in PROOF_PENDING
                   for entry in self.entries.values())

    def graph_frontier(self):
        """Unsubmitted reduction targets exposed by accepted/pending parents."""
        frontier, seen = [], set()
        pending = deque([self.graph_first_root])
        while pending:
            name = pending.popleft()
            if name in seen:
                continue
            seen.add(name)
            entry = self.entries.get(name, {})
            if entry.get("submission_id") and entry.get("proof_status", "PENDING") in PROOF_SUCCESS | PROOF_PENDING:
                pending.extend(self.theorem_dependencies(name))
            else:
                frontier.append(name)
        return frontier

    def frontier_publications(self, frontier):
        """Missing statements/definitions needed to submit frontier reductions.

        Recurse through publication dependencies only. Registering a child does
        not wait for that child's proof or its proof-only dependencies.
        """
        priorities = {}
        pending = deque()
        for name in frontier:
            node = self.nodes.get(name)
            if node is None or not self.theorem_dependencies(name):
                continue
            depth = self.graph_depths.get(name, 10**9)
            pending.append((name, depth))
            pending.extend((dependency, depth) for dependency in node["proof_dependencies"])
        while pending:
            name, depth = pending.popleft()
            if self.entries.get(name, {}).get("theorem_id"):
                continue
            if name in priorities and priorities[name] <= depth:
                continue
            priorities[name] = depth
            node = self.nodes.get(name)
            if node:
                pending.extend((dependency, depth) for dependency in node["publish_dependencies"])
        return priorities

    def event(self, event, **fields):
        if self.graph_first_root:
            fields.update(mode="graph_first", graph_root=self.graph_first_root,
                          active_proofs=self.active_proofs())
            if event == "COMPLETE":
                fields["completion_scope"] = "registrations_and_root_connected_reductions"
                fields["standalone_leaf_proofs_deferred"] = sum(
                    node.get("solution") is not None and not self.theorem_dependencies(name)
                    and not self.entries[name].get("submission_id")
                    for name, node in self.nodes.items() if node["kind"] == "theorem")
        super().event(event, **fields)

    def done(self, name):
        if not self.graph_first_root:
            return super().done(name)
        node, entry = self.nodes[name], self.entries[name]
        if entry.get("publish_status") in {"FAILED", "ERROR"}:
            return True
        if not entry.get("theorem_id"):
            return False
        # Previously submitted jobs remain owned and polled in every mode.
        if entry.get("submission_id") and entry.get("proof_status", "PENDING") in PROOF_PENDING:
            return False
        needs_reduction = (name in self.graph_depths and node.get("solution")
                           and self.theorem_dependencies(name))
        return not needs_reduction or entry.get("proof_status") in PROOF_TERMINAL

    def save(self):
        if not self._normalised:
            # Support a copied legacy checkpoint without retaining its bulky
            # embedded bodies in every subsequent state rewrite.
            for action in self.state["actions"].values():
                for key in ("request", "response"):
                    if key in action:
                        action[key + "_receipt"] = self.receipts.put(action.pop(key))
            for entry in self.state["entries"].values():
                for key in ("publish_receipt", "proof_receipt", "existing_receipt"):
                    value = entry.get(key)
                    if value is not None and not (isinstance(value, dict) and set(value) == {"path", "sha256", "bytes"}):
                        entry[key] = self.receipts.put(value)
                if entry.get("publish_error", {}).get("response") is not None:
                    error = entry["publish_error"]
                    error["response_receipt"] = self.receipts.put(error.pop("response"))
            self._normalised = True
        self.state["schema"] = "p2m-private-global-v2"
        self.state["updated_unix"] = time.time()
        atomic_bytes(self.path, encoded(self.state))

    def apply_response(self, action):
        if "response_receipt" in action:
            response = self.receipts.get(action["response_receipt"])
        elif "response" in action:
            response = action["response"]
            action["response_receipt"] = self.receipts.put(response)
        else:
            raise Halt("Received mutation lacks its recorded response")
        # Reuse validated response handling, then keep only the immutable link.
        action["response"] = response
        try:
            super().apply_response(action)
        finally:
            action.pop("response", None)
        for name in action["names"]:
            entry = self.entries[name]
            if entry.get("publish_error"):
                entry["publish_error"] = {"reason": "Not queued in batch response",
                                          "response_receipt": action["response_receipt"]}

    def mutate(self, kind, names, call, request_body=None):
        action_id = uuid.uuid4().hex
        action = {"kind": kind, "names": names, "stage": "intent", "started_unix": time.time(),
                  "request_receipt": self.receipts.put(request_body)}
        self.state["actions"][action_id] = action
        self.save()
        response = call()
        action.update(stage="received", response_receipt=self.receipts.put(response),
                      received_unix=time.time())
        self.save()
        self.apply_response(action)
        self.event("PROOFS_QUEUED" if kind == "proof" else "PUBLISH_QUEUED", names=names)

    def check_existing(self):
        for name, binding in self.existing.items():
            endpoint = "/definitions/" if binding["kind"] == "definition" else "/theorems/"
            item = self.api.request(endpoint + binding["id"])
            self.entries[name]["existing_receipt"] = self.receipts.put(item)
            self.save()
            if (item.get("visibility") != "private" or
                item.get("definition_name", item.get("theorem_name")) != name or
                item.get("mathlib_rev", item.get("env")) != self.state["env"]):
                raise Halt("Existing binding visibility/name/environment mismatch: " + name)

    def fill(self):
        """Fill free slots without starving ready theorem statements.

        When both publication kinds are ready, allow at most five consecutive
        definition requests, then batch theorem statements into the free slots.
        The streak is checkpointed with each mutation intent, so a restart does
        not continually reset priority to definitions. A lone ready category
        can use the whole queue. Existing proof scheduling remains unchanged.
        """
        changed = False
        while not self.paused() and self.active() < self.limit:
            frontier = self.graph_frontier() if self.graph_first_root else []
            ready_proofs = [] if self.publish_only else [
                name for name, node in self.nodes.items()
                if node.get("solution") and self.entries[name].get("theorem_id")
                and not self.entries[name].get("submission_id")
                and self.registered(node["proof_dependencies"])
            ]
            if self.graph_first_root:
                ready_proofs = [name for name in ready_proofs
                                if name in frontier and self.theorem_dependencies(name)]
                ready_proofs.sort(key=lambda name: self.graph_depths[name])
                if self.active_proofs() >= self.max_graph_proofs:
                    ready_proofs = []
            if ready_proofs:
                name = ready_proofs[0]
                node, entry = self.nodes[name], self.entries[name]
                if hashlib.sha256(Path(node["solution"]).read_bytes()).hexdigest() != node["solution_sha256"]:
                    raise Halt("Proof file changed before upload: " + name)
                self.mutate("proof", [name],
                            lambda: self.api.verify(entry["theorem_id"], node["solution"], node["explanation"]),
                            {"theorem_id": entry["theorem_id"], "solution": node["solution"],
                             "sha256": node["solution_sha256"], "explanation": node["explanation"]})
                changed = True
                continue
            ready = [name for name, node in self.nodes.items()
                     if not self.entries[name].get("theorem_id")
                     and not self.entries[name].get("job_id")
                     and self.entries[name].get("publish_status") not in {"FAILED", "ERROR"}
                     and self.registered(node["publish_dependencies"])]
            if self.graph_first_root:
                priorities = self.frontier_publications(frontier)
                preferred = [name for name in ready if name in priorities]
                if preferred:
                    depth = min(priorities[name] for name in preferred)
                    ready = [name for name in preferred if priorities[name] == depth]
            definitions = [name for name in ready if self.nodes[name]["kind"] == "definition"]
            theorems = [name for name in ready if self.nodes[name]["kind"] == "theorem"]
            streak = self.state.get("definition_publish_streak", 0)
            if definitions and (not theorems or streak < 5):
                name = definitions[0]
                payload = self.nodes[name]["payload"]
                self.state["definition_publish_streak"] = min(5, streak + 1)
                self.mutate("definition", [name],
                            lambda: self.api.request("/submit-definition", "POST", body=payload), payload)
                changed = True
                continue
            names = theorems[:self.limit - self.active()]
            if not names:
                break
            body = {"problems": [{k: v for k, v in self.nodes[name]["payload"].items()
                                  if k not in ("env", "private")} for name in names],
                    "env": self.state["env"], "private": True}
            self.state["definition_publish_streak"] = 0
            self.mutate("theorems", names,
                        lambda: self.api.request("/submit-problem", "POST", body=body), body)
            changed = True
        return changed

    def poll(self):
        # At most MAX_ACTIVE_JOBS active entries; completed entries need no receipt writes.
        for name, entry in [(n, e) for n, e in self.entries.items() if self.is_active(e)]:
            if self.paused():
                break
            if entry.get("job_id") and not entry.get("theorem_id") and entry.get("publish_status", "PENDING") in PUBLISH_PENDING:
                job = self.api.request("/publish-jobs/" + entry["job_id"])
                receipt = self.receipts.put(job)
                changed = entry.get("publish_receipt") != receipt
                entry["publish_receipt"] = receipt
                status, previous = job["status"], entry.get("publish_status", "PENDING")
                if status not in PUBLISH_PENDING | {"PUBLISHED", "FAILED", "ERROR"}:
                    self.save()
                    raise Halt("Unknown publish status: " + status)
                entry["publish_status"] = status
                if status == "PUBLISHED":
                    node = self.nodes[name]
                    expected = node["payload"]
                    if job.get("visibility") != "private" or job.get("theorem_name") != name:
                        self.save()
                        raise Halt("Published node visibility/name mismatch: " + name)
                    expected_body = expected.get("definition") if node["kind"] == "definition" else expected.get("preamble", "")
                    if job.get("definitions", "") != expected_body or (node["kind"] == "theorem" and job.get("formal_statement") != expected["formal_statement"]):
                        self.save()
                        raise Halt("Published Lean source differs from submitted payload: " + name)
                    entry["theorem_id"] = job["theorem_id"]
                if status != previous:
                    self.event("PUBLISH_STATUS", name=name, status=status)
                elif changed:
                    self.save()
            if entry.get("submission_id") and entry.get("proof_status", "PENDING") in PROOF_PENDING:
                verdict = self.api.request("/verify?submission_id=" + entry["submission_id"])
                receipt = self.receipts.put(verdict)
                changed = entry.get("proof_receipt") != receipt
                entry["proof_receipt"] = receipt
                status, previous = verdict["status"], entry.get("proof_status", "PENDING")
                if status not in PROOF_PENDING | PROOF_TERMINAL:
                    self.save()
                    raise Halt("Unknown proof status: " + status)
                entry["proof_status"] = status
                if status != previous:
                    self.event("PROOF_STATUS", name=name, status=status)
                elif changed:
                    self.save()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--state", type=Path, required=True)
    parser.add_argument("--bindings", type=Path)
    parser.add_argument("--legacy-ledger", type=Path, action="append", default=[])
    parser.add_argument("--seed-only", action="store_true")
    parser.add_argument("--limit", type=int, default=15)
    parser.add_argument("--max-seconds", type=float, default=3600)
    parser.add_argument("--poll-seconds", type=float, default=3)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--publish-only", action="store_true", help="Register nodes only (default)")
    mode.add_argument("--graph-first", action="store_true", help="Register the root frontier and submit its original reductions, deferring leaf proofs")
    mode.add_argument("--all-proofs", action="store_true", help="Submit all ready original proofs")
    parser.add_argument("--root-theorem", default="D1Bound5.main_statement")
    parser.add_argument("--max-graph-proofs", type=int, default=None, help="Proof concurrency within the total queue limit (default: min(3, limit))")
    args = parser.parse_args()
    args.state.parent.mkdir(parents=True, exist_ok=True)
    lock = open(str(args.state) + ".lock", "a+")
    try:
        fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        raise SystemExit("Another uploader owns this global ledger")
    manifest = json.loads(args.manifest.read_text())
    if args.bindings:
        seed_state(manifest, json.loads(args.bindings.read_text()), args.state, args.legacy_ledger)
    elif args.legacy_ledger or args.seed_only:
        raise SystemExit("--bindings is required for seeding or legacy migration")
    if args.seed_only:
        print(json.dumps({"event": "STATE_SEEDED", "state": str(args.state)}))
        return 0
    api = importlib.import_module("p2m_client")
    runner = GlobalUploader(api, manifest, args.state, args.limit, args.manifest.parent,
                            publish_only=not (args.graph_first or args.all_proofs),
                            graph_first_root=args.root_theorem if args.graph_first else None,
                            max_graph_proofs=args.max_graph_proofs)
    def stop(signum, frame):
        runner.stop = True
    signal.signal(signal.SIGINT, stop)
    signal.signal(signal.SIGTERM, stop)
    try:
        runner.check_existing()
        return runner.run(args.max_seconds, args.poll_seconds)
    finally:
        runner.save()
        lock.close()


if __name__ == "__main__":
    raise SystemExit(main())
