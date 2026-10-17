#!/usr/bin/env python3
"""Read-only diagnostics for the author's single private D1Bound5 repository.

This does not stage, commit, push, modify files, grant permissions, or bypass
any approval. A successful report does not replace human/model diff review.
"""
from __future__ import annotations

import hashlib
import json
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPOSITORY = "tomislav-math/d1-bound5-lean"
GH = Path.home() / ".local/bin/gh"
TOKEN_PATTERNS = [
    r"gh[pousr]_[A-Za-z0-9]{20,}",
    r"github_pat_[A-Za-z0-9_]{30,}",
    r"-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----",
    r"sk-(?:proj-)?[A-Za-z0-9_-]{28,}",
    r"(?i)Bearer\s+[A-Za-z0-9_.-]{30,}",
    r"(?i)https?://[^\s/:]+:[^\s/@]+@",
]


def run(args: list[str]) -> bytes:
    result = subprocess.run(args, cwd=ROOT, capture_output=True, timeout=30)
    if result.returncode:
        # Do not dump credential-helper output or credential-bearing URLs.
        raise RuntimeError(f"Read-only command failed with exit {result.returncode}: {args[0]}")
    return result.stdout


def git(*args: str) -> str:
    return run(["git", *args]).decode("utf-8").strip()


def check(condition: bool, message: str) -> None:
    if not condition:
        raise RuntimeError(message)


def main() -> None:
    check(git("rev-parse", "--show-toplevel") == str(ROOT), "Wrong repository root")
    check(git("branch", "--show-current") == "main", "Review the non-main branch separately")
    origin = git("remote", "get-url", "origin")
    check(origin in {f"https://github.com/{REPOSITORY}.git", f"https://github.com/{REPOSITORY}",
                     f"git@github.com:{REPOSITORY}.git"}, "Unexpected origin; no mutation authorized")
    info = json.loads(run([str(GH), "repo", "view", REPOSITORY, "--json",
                           "nameWithOwner,visibility,viewerPermission"]))
    check(info["visibility"] == "PRIVATE", "Destination is not verified PRIVATE")
    check(info["viewerPermission"] in {"ADMIN", "MAINTAIN", "WRITE"}, "No provider write permission")
    check(git("config", "user.name") != "" and git("config", "user.email") != "", "Missing Git identity")
    check(not Path(git("rev-parse", "--git-path", "index.lock")).is_absolute() or
          not Path(git("rev-parse", "--git-path", "index.lock")).exists(), "Git index is locked")
    lock = Path(git("rev-parse", "--git-path", "index.lock"))
    check(not (ROOT / lock).exists(), "Git index is locked")
    manifest_counts = {}
    for name in ("records/proof-source-sha256.txt", "records/verification-tools-sha256.txt"):
        lines = (ROOT / name).read_text(encoding="utf-8").splitlines()
        for line in filter(str.strip, lines):
            digest, path = line.split(None, 1)
            candidate = ROOT / path.lstrip("*")
            check(candidate.is_file(), f"Missing manifest file: {path}")
            check(hashlib.sha256(candidate.read_bytes()).hexdigest() == digest,
                  f"Unmatched fingerprint: {path}; review the current build receipt")
        manifest_counts[name] = len(list(filter(str.strip, lines)))
    staged = [p for p in run(["git", "diff", "--cached", "--name-only", "-z"]).decode().split("\0") if p]
    for name in staged:
        check(name in {"D1Bound5.lean", "STATUS.md", "README.md", "GIT_SYNC_POLICY.md"}
              or name.startswith(("D1Bound5/", "records/", "scripts/", "research/")),
              f"Review unexpected staged path separately: {name}")
        data = run(["git", "show", ":" + name])
        check(len(data) <= 5 * 1024 * 1024, f"Review large staged file separately: {name}")
        check(not any(re.search(pattern, data.decode("utf-8")) for pattern in TOKEN_PATTERNS),
              f"Credential-shaped content needs review in {name}; value withheld")
    local = git("rev-parse", "HEAD")
    remote = git("ls-remote", "origin", "refs/heads/main").split()[0]
    ancestor = subprocess.run(["git", "merge-base", "--is-ancestor", remote, local],
                              cwd=ROOT, capture_output=True, timeout=30).returncode == 0
    check(ancestor, "Remote is not a known ancestor; reconcile without force-push")
    print(json.dumps({"status": "PREFLIGHT_PASS_REVIEW_STILL_REQUIRED", "read_only": True,
                      "utc": datetime.now(timezone.utc).isoformat(), "repository": REPOSITORY,
                      "visibility": info["visibility"], "permission": info["viewerPermission"],
                      "local_head": local, "remote_head": remote, "heads_match": local == remote,
                      "staged_count": len(staged), "manifest_counts": manifest_counts}, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError, ValueError, subprocess.TimeoutExpired) as error:
        print(json.dumps({"status": "PREFLIGHT_FAILED_NO_MUTATION", "detail": str(error)}))
        sys.exit(1)
