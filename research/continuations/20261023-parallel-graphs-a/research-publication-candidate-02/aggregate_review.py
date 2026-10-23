#!/usr/bin/env python3
"""Prepare one reviewed research-only publication candidate; never stage or compile."""
import ast
import collections
import datetime
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import subprocess

ROOT = Path("/Users/tp/Lean/D1Bound5")
OUT = ROOT / "research/continuations/20261023-parallel-graphs-a/research-publication-candidate-02"
BASE = "1fe0adf1028af0e41ea578660c8d48875cde6588"
INDEX_LIST = "4964eff33829ea307976c7b13c7ea8ffa54370b43e9c8c8fbc54569919914999"
INDEX_RAW = "d75b00a8655571a1dbfb84f9c25793f4730b9e545f5bf9b59feec75745ecd484"
POLICY_SHA = "f9be79625f5ba7387e5165b46cd4d0175c24f64ccc8d9f0bea01f611e3a8652b"
PREFLIGHT_SHA = "7f07b1a6d3974c02840538af4900b25036c63b8d5945fd047b48cbcaefd6407f"
PACKET = "research/continuations/20261023-parallel-target-audit/post1fe-root-review-packet/"
INSTALL = "research/continuations/20261023-parallel-graphs-b/final-installation-plan-02/"
READY = "research/continuations/20261023-parallel-graphs-b/canonical-launch-readiness-01/"
MAX_BYTES = 5 * 1024 * 1024

def check(condition, message):
    if not condition:
        raise RuntimeError(message)

def sha(data):
    return hashlib.sha256(data).hexdigest()

def run_git(*args):
    p = subprocess.run(["git", "-C", str(ROOT), *args], capture_output=True, timeout=60)
    check(p.returncode == 0, "Read-only Git command failed; diagnostics withheld")
    return p.stdout

def checkpoint():
    check(not (ROOT / ".git/index.lock").exists(), "Git index lock is present")
    return {
        "head": run_git("rev-parse", "HEAD").decode().strip(),
        "branch": run_git("branch", "--show-current").decode().strip(),
        "index_listing_sha256": sha(run_git("ls-files", "--stage", "-z")),
        "raw_index_sha256": sha((ROOT / ".git/index").read_bytes()),
        "staged_diff_empty": not run_git("diff", "--cached", "--name-only", "-z"),
        "policy_sha256": sha((ROOT / "GIT_SYNC_POLICY.md").read_bytes()),
        "preflight_sha256": sha((ROOT / "scripts/git_sync_preflight.py").read_bytes()),
    }

def validate_checkpoint(c):
    check(c["head"] == BASE and c["branch"] == "main", "HEAD/branch differs from reviewed base")
    check(c["index_listing_sha256"] == INDEX_LIST and c["raw_index_sha256"] == INDEX_RAW,
          "Index differs from reviewed checkpoint")
    check(c["staged_diff_empty"], "Staged diff is not empty")
    check(c["policy_sha256"] == POLICY_SHA and c["preflight_sha256"] == PREFLIGHT_SHA,
          "Policy or preflight source changed")

def checked_path(relative):
    p = PurePosixPath(relative)
    check(not p.is_absolute() and all(x not in ("", ".", "..") for x in p.parts),
          "Unsafe selected path")
    check(relative.startswith("research/") and "\\" not in relative and
          not any(c in relative for c in "\r\n\t\0"), "Path outside explicit research scope")
    check(p.name != "CURRENT_PROGRESS.json" or relative == "research/continuations/20261023-parallel-resume/CURRENT_PROGRESS.json", "Unapproved live progress path selected")
    check(not relative.endswith((".b64", ".part", ".olean", ".ir", ".tar", ".gz", ".zip")),
          "Transport or binary artifact selected")
    q = ROOT
    for part in p.parts:
        q = q / part
        check(not q.is_symlink(), "Symlink in selected path")
    check(q.is_file() and stat.S_ISREG(q.stat().st_mode), "Selected path is not a regular file")
    return q

def fingerprint(p):
    s = p.stat()
    return (s.st_dev, s.st_ino, s.st_mode, s.st_size, s.st_mtime_ns, s.st_ctime_ns)

before = checkpoint()
validate_checkpoint(before)
for name in ("CANDIDATE_MANIFEST.json", "MERGED_STAGE_PATHS.txt", "NEW_OR_CHANGED_STAGE_PATHS.txt"):
    check(not (OUT / name).exists(), "Candidate output already exists; no overwrite")

preflight_source = (ROOT / "scripts/git_sync_preflight.py").read_bytes()
check(sha(preflight_source) == PREFLIGHT_SHA, "Preflight source pin changed")
patterns = None
for node in ast.parse(preflight_source.decode("utf-8")).body:
    if isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id == "TOKEN_PATTERNS"
                                          for t in node.targets):
        patterns = ast.literal_eval(node.value)
check(isinstance(patterns, list) and len(patterns) == 6 and all(isinstance(x, str) for x in patterns),
      "Unexpected canonical credential-pattern definition")
compiled_patterns = [re.compile(p) for p in patterns]

inputs = {}
selected = {}
groups = {}

def read_pinned(relative, expected):
    p = checked_path(relative)
    data = p.read_bytes()
    check(sha(data) == expected, "Pinned owner file changed: " + relative)
    inputs[relative] = expected
    return data

def add(relative, expected, group):
    if relative in selected:
        check(selected[relative]["expected_sha256"] == expected, "Conflicting owner hashes")
        selected[relative]["groups"].append(group)
    else:
        selected[relative] = {"expected_sha256": expected, "groups": [group]}

PRIOR = "research/continuations/20261023-parallel-graphs-a/research-publication-candidate-01/"
prior = json.loads(read_pinned(PRIOR + "CANDIDATE_MANIFEST.json",
    "718bcb6bb83a544bfe795a56b1b99d94a2ab79798e3c227d24e5ecbb352f0b09"))
check(prior["selected_path_count"] == 112 and prior["base_commit"] == BASE, "Prior candidate mismatch")
for relative, row in prior["files"].items():
    add(relative, row["sha256"], "prior_reviewed_112")
groups["prior_reviewed_112"] = 112
prior_own = {
    "aggregate_review.py": "30342dcef6044af68ca5aa0bfd583f55d04ba63a0fca2487f14e5d610db27eb9",
    "CANDIDATE_MANIFEST.json": "718bcb6bb83a544bfe795a56b1b99d94a2ab79798e3c227d24e5ecbb352f0b09",
    "MERGED_STAGE_PATHS.txt": "0272a58c39d3cfd0af846e3b07f647bcf15e614055041b0e68b61de3e0daaea2",
    "NEW_OR_CHANGED_STAGE_PATHS.txt": "0272a58c39d3cfd0af846e3b07f647bcf15e614055041b0e68b61de3e0daaea2",
}
for name, expected in prior_own.items():
    read_pinned(PRIOR + name, expected)
    add(PRIOR + name, expected, "prior_candidate_metadata_4")
groups["prior_candidate_metadata_4"] = 4

def owner_manifest(prefix, name, expected, count, group):
    obj = json.loads(read_pinned(prefix + name, expected))
    entries = obj["files"]
    entries = {x["path"]: x["sha256"] for x in entries} if isinstance(entries, list) else {
        p: (v["sha256"] if isinstance(v, dict) else v) for p, v in entries.items()}
    check(len(entries) == count and name not in entries, "Owner manifest count/self mismatch")
    for p, h in entries.items():
        add(prefix + p, h, group)
    add(prefix + name, expected, group)
    groups[group] = count + 1
    return obj

DOCS = "research/continuations/20261023-parallel-target-audit/current-docs-clean-build-draft-01/"
owner_manifest(DOCS, "SYNC_RECEIPT.json",
    "c308a96696b6233b74f3f265e3e5252809274c5d9a578a046f2ac55c38e236c4", 19, "durable_documentation_and_summaries_20")
read_pinned(DOCS + "PACKAGE_MANIFEST.json",
    "640ca355e5280987de04819c433dc4b4a074bf0e90e0063d8a7251a9895766e1")
owner_manifest("research/continuations/20261023-parallel-target-audit/environment-file-loss-incident-01/",
    "MANIFEST.final.json", "39cccf119d3e3812879c6d114a4011f0ea4edc71d633712536d6b640ee15b336",
    7, "target_audit_incident_8")
owner_manifest("research/continuations/20261023-parallel-integration/local-loss-recovery-20261023/",
    "RECOVERY_MANIFEST.json", "60fef8473113accbdf242fd261710f86bc45897b03ab946a3311a0c2ac05e943",
    9, "integration_recovery_10")

explicit = {
    "graph39_recovery_review_2": {
        "research/continuations/20261023-parallel-graph39/recovery-review-20261023/RECONSTRUCTED_REVIEW_RECORD.json":
            "6fe5905963970d01d066f6534411df81509150057aebd1b24ad8c5a333450e4f",
        "research/continuations/20261023-parallel-graph39/recovery-review-20261023/BROAD_V2_EXACT_RECOVERY_REVIEW.json":
            "37572258279e9b2a602f0c422244eeff6ebe6b420f4e51bf16ac6e6c2f379928",
    },
    "offload_incident_2": {
        "research/continuations/20261023-parallel-offload/evidence/workspace-loss-20261023T1828Z/OBSERVATIONS.json":
            "4c625160799883a9bf0249f7c645d5aee50ebdeee068f3c376406b43a50d0d41",
        "research/continuations/20261023-parallel-offload/evidence/workspace-loss-20261023T1828Z/CORRECTIONS.json":
            "9128854452473272d1fbfe50306e40ecb4126c27dd2acf6566530b9dfcbdbe0c",
    },
    "root_frozen_current_progress_1": {
        "research/continuations/20261023-parallel-resume/CURRENT_PROGRESS.json":
            "056e3fa252d18c9bd1df56c0807048c9e78f1cd8ded995bd96798f3aeec53331",
    },
}
for group, files in explicit.items():
    for relative, expected in files.items():
        read_pinned(relative, expected)
        add(relative, expected, group)
    groups[group] = len(files)
check(len(selected) == 159, "Unexpected expanded path count")

paths = sorted(selected)
tree_data = run_git("ls-tree", "-r", "-z", "--full-tree", BASE, "--", *paths)
base_rows = {}
for raw in tree_data.split(b"\0"):
    if not raw:
        continue
    metadata, relative_bytes = raw.split(b"\t", 1)
    mode, kind, oid = metadata.decode().split()
    relative = relative_bytes.decode("utf-8")
    check(relative in selected and kind == "blob" and mode in ("100644", "100755"),
          "Unexpected base tree row")
    base_rows[relative] = {"git_blob": oid, "mode": mode}

rows = {}
snapshots = {}
for relative in paths:
    p = checked_path(relative)
    fp = fingerprint(p)
    data = p.read_bytes()
    check(fingerprint(p) == fp, "File changed during read: " + relative)
    check(len(data) <= MAX_BYTES, "File exceeds 5 MiB: " + relative)
    content = data.decode("utf-8")
    check("\0" not in content, "NUL byte in selected text")
    check(not any(pattern.search(content) for pattern in compiled_patterns),
          "Credential-shaped content needs review; value withheld: " + relative)
    current_sha = sha(data)
    check(current_sha == selected[relative]["expected_sha256"], "Owner-reviewed bytes changed: " + relative)
    base = base_rows.get(relative)
    base_sha = None
    classification = "NEW"
    if base is not None:
        base_sha = sha(run_git("cat-file", "blob", base["git_blob"]))
        classification = "BASE_IDENTICAL" if base_sha == current_sha else "CHANGED"
    rows[relative] = {
        "sha256": current_sha,
        "bytes": len(data),
        "mode": oct(stat.S_IMODE(p.stat().st_mode)),
        "classification_vs_1fe": classification,
        "base_git_blob": base["git_blob"] if base else None,
        "base_sha256": base_sha,
        "owner_groups": selected[relative]["groups"],
    }
    snapshots[relative] = fp

for relative, expected in inputs.items():
    check(sha(checked_path(relative).read_bytes()) == expected, "Owner input changed after scan")
for relative in paths:
    p = checked_path(relative)
    check(fingerprint(p) == snapshots[relative] and sha(p.read_bytes()) == rows[relative]["sha256"],
          "Selected file changed after scan: " + relative)
after = checkpoint()
validate_checkpoint(after)
check(before == after, "HEAD/index/policy changed during candidate review")

classifications = dict(collections.Counter(r["classification_vs_1fe"] for r in rows.values()))
changed = [p for p in paths if rows[p]["classification_vs_1fe"] != "BASE_IDENTICAL"]
manifest = {
    "schema": 1,
    "status": "159_PATH_RESEARCH_CHECKPOINT_CANDIDATE_FOR_ROOT_REVIEW_ONLY",
    "utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    "base_commit": BASE,
    "checkpoint_before": before,
    "checkpoint_after": after,
    "owner_inputs_sha256": inputs,
    "groups": groups,
    "selected_path_count": len(paths),
    "classification_counts": classifications,
    "total_bytes": sum(r["bytes"] for r in rows.values()),
    "files": rows,
    "policy_checks": {"strict_utf8": True, "max_file_bytes": MAX_BYTES,
                      "credential_pattern_count": len(patterns), "credential_matches": 0,
                      "regular_files_no_symlink_components": True,
                      "all_owner_hashes_match": True, "pre_post_selected_hashes_equal": True},
    "pending_or_excluded": [
        {"group": "capture_tool_and_future_final_capture", "reason": "Not durably finalized before local file loss; excluded."},
        {"group": "full_audit_logs_receipt_chain_artifacts_freeze_bodies", "reason": "Not present in these durable packages; hashes/references alone are not replacements for missing bodies."},
        {"group": "future_recovery_execution_and_canonical_preservation", "reason": "Not executed or not finalized in this frozen checkpoint."}
    ],
    "actual_failed_broad_summary_sha256": "3f59624818a3e49c1e2705de1182e33a86650aa45ae3dcf1f088ced8dd2a17f2",
    "actual_failed_broad_summary_scope": "Exact surviving SUMMARY bytes in docs and integration copies; actual failed-run logs are not included.",
    "frozen_current_progress_sha256": "056e3fa252d18c9bd1df56c0807048c9e78f1cd8ded995bd96798f3aeec53331",
    "fresh_replay_status": "INTERRUPTED_EXIT_130_AFTER_ENVIRONMENT_FILE_LOSS_NOT_PASS",
    "historical_drafts_and_reconstructed_reports": "Preserved with their original labels; historical in-progress wording is not current success.",
    "historical_preparation_bytes_preserved": True,
    "actual_failed_broad_summary_archived": True,
    "actual_failed_broad_logs_archived": False,
    "proof_gate_acceptance_claim": False,
    "canonical_source_or_tool_installation": False,
    "git_mutations": False,
    "lean_or_checker_launch": False,
    "new_files_created_only_in": str(OUT.relative_to(ROOT)),
    "candidate_own_metadata_not_in_159_paths": [
        "aggregate_review.py", "CANDIDATE_MANIFEST.json", "MERGED_STAGE_PATHS.txt",
        "NEW_OR_CHANGED_STAGE_PATHS.txt"
    ],
    "root_action_required": "Review the aggregate and any later additions, refresh live guards, stage only an explicit approved list, then run canonical exact-index review before a private commit/push.",
}
outputs = {
    "CANDIDATE_MANIFEST.json": (json.dumps(manifest, indent=2, sort_keys=True) + "\n").encode(),
    "MERGED_STAGE_PATHS.txt": ("\n".join(paths) + "\n").encode(),
    "NEW_OR_CHANGED_STAGE_PATHS.txt": ("\n".join(changed) + "\n").encode(),
}
for name, data in outputs.items():
    check(len(data) <= MAX_BYTES and not any(p.search(data.decode("utf-8")) for p in compiled_patterns),
          "Generated metadata does not pass text policy")
    with (OUT / name).open("xb") as f:
        f.write(data)
        f.flush()
        os.fsync(f.fileno())
final_checkpoint = checkpoint()
check(final_checkpoint == before, "HEAD/index/policy changed while saving research metadata")
print(json.dumps({
    "status": manifest["status"],
    "path_count": len(paths),
    "classification_counts": classifications,
    "total_bytes": manifest["total_bytes"],
    "output_directory": str(OUT),
    "output_sha256": {name: sha((OUT / name).read_bytes()) for name in
                      ["aggregate_review.py", *outputs]},
    "git_and_policy_guards_unchanged": True,
    "actual_failed_broad_summary_archived": True,
    "actual_failed_broad_logs_archived": False,
}, indent=2))
