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
OUT = ROOT / "research/continuations/20261023-parallel-graphs-a/research-publication-candidate-01"
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
    check("CURRENT_PROGRESS" not in relative, "Mutable progress path selected")
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

packet_sha = "07b0d30a0b9c76fd1e05d6ae105d47433dee553ae4a1feb47ad378d5e5a0c70b"
packet = json.loads(read_pinned(PACKET + "ROOT_REVIEW_MANIFEST.json", packet_sha))
packet_list_sha = "b154773d4484ebd72d3e1790cb459a6d9356b36f823638548fe977d9e3066768"
packet_paths = read_pinned(PACKET + "STAGE_PATHS.txt", packet_list_sha).decode("utf-8").splitlines()
check(len(packet_paths) == 90 and len(set(packet_paths)) == 90 and set(packet_paths) == set(packet["files"]),
      "Root packet list/manifest mismatch")
check(packet["expected_head"] == BASE, "Root packet refers to a different base")
for relative in packet_paths:
    add(relative, packet["files"][relative]["sha256"], "reviewed_root_packet_90")
groups["reviewed_root_packet_90"] = 90
packet_own = {
    "prepare_root_packet.py": "0eb15ae44e586811cb3676df0456a7eeb0e123380401de7c244bee29c3445623",
    "ROOT_REVIEW_MANIFEST.json": packet_sha,
    "STAGE_PATHS.txt": packet_list_sha,
}
for name, expected in packet_own.items():
    read_pinned(PACKET + name, expected)
    add(PACKET + name, expected, "root_packet_metadata_3")
groups["root_packet_metadata_3"] = 3

install_sha = "385b716f89dd10c41dc739f19c741e17ccd21164e4c210a142c06d74bed56e40"
install = json.loads(read_pinned(INSTALL + "PACKAGE_MANIFEST.json", install_sha))
install_list_sha = "aef281107e712f7c59e6233277e1c49b835f1a4dbf9c022179c18499f4432061"
install_paths = read_pinned(INSTALL + "STAGE_PATHS.txt", install_list_sha).decode("utf-8").splitlines()
install_expected = {INSTALL + p: h for p, h in install["files"].items()}
install_expected[INSTALL + "PACKAGE_MANIFEST.json"] = install_sha
install_expected[INSTALL + "REMOTE_SYNC_VERIFIED.json"] = "4438bfe993892ee3ad053c2e16bd12baa3018ee696c3194ae7615be3850624f4"
check(len(install_paths) == 16 and len(set(install_paths)) == 16 and set(install_paths) == set(install_expected),
      "Installation plan list/manifest mismatch")
for relative in install_paths:
    add(relative, install_expected[relative], "installation_plan_02_16")
groups["installation_plan_02_16"] = 16

ready_expected = {
    "READINESS.json": "99c8b58d54175d50f853a2df8fc2ea0ad696385a0fbe8e7f552aba4ebc63616d",
    "READ_ONLY_COMMAND.py.txt": "b3eb3d3602c089236e87c559b5268049855917cdee2756c75771dca5732084ae",
    "RECEIPT_MANIFEST.json": "d9a2be1020686f4c56d6062c862c27caff6c505955fac437e5f2ed3bb6810a86",
}
ready_manifest = json.loads(read_pinned(READY + "RECEIPT_MANIFEST.json",
                                     ready_expected["RECEIPT_MANIFEST.json"]))
check(ready_manifest["files"] == {k: v for k, v in ready_expected.items() if k != "RECEIPT_MANIFEST.json"},
      "Readiness owner manifest mismatch")
for name, expected in ready_expected.items():
    add(READY + name, expected, "canonical_launch_readiness_01_3")
groups["canonical_launch_readiness_01_3"] = 3
check(len(selected) == 112, "Unexpected merged path count")

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
    "status": "112_PATH_RESEARCH_CANDIDATE_FOR_ROOT_REVIEW_ONLY",
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
        {"group": "broad_v2_preparation", "reason": "Owner's final durable preparation-only manifest unavailable after local file loss; no speculative remote paths included."},
        {"group": "capture_tool_preparation", "reason": "Not durably finalized before local file loss; excluded."},
        {"group": "actual_failed_broad_run_results", "reason": "Not present in the earlier root90 packet; this candidate does not claim those results were archived."},
        {"group": "current_docs_progress_final_capture_preservation", "reason": "Mutable, unfinished or outside this explicit reviewed research set."}
    ],
    "historical_preparation_bytes_preserved": True,
    "actual_failed_broad_result_archival_claim": False,
    "proof_gate_acceptance_claim": False,
    "canonical_source_or_tool_installation": False,
    "git_mutations": False,
    "lean_or_checker_launch": False,
    "new_files_created_only_in": str(OUT.relative_to(ROOT)),
    "candidate_own_metadata_not_in_112_paths": [
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
    "actual_failed_broad_result_archival_claim": False,
}, indent=2))
