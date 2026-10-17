#!/usr/bin/env python3
"""Fresh replay using the installed pinned Lean kernel; not a clean-checkout audit."""
import hashlib, json, os, subprocess, sys, time
from datetime import datetime, timezone
from pathlib import Path
ROOT = Path("/Users/tp/Lean/D1Bound5")
RUN = ROOT / "research/continuations/20261017T234500CEST-agent-continuation"
checks = json.loads((RUN / "accepted-build-results.json").read_text())
if len(checks) != 11 or any(x["exit_code"] for x in checks):
    raise SystemExit("All eleven build/audit steps must pass first")
paths = [ROOT/"D1Bound5.lean"] + sorted((ROOT/"D1Bound5").glob("*.lean"))
before = {str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
command = ["/Users/tp/.elan/bin/lake","env","leanchecker","--fresh","--verbose","D1Bound5"]
started = datetime.now(timezone.utc).isoformat()
t0 = time.monotonic()
with (RUN/"whole-root-kernel-replay.log").open("w") as log:
    result = subprocess.run(command,cwd=ROOT,env=dict(os.environ,LEAN_NUM_THREADS="1"),
                            stdout=log,stderr=subprocess.STDOUT)
after = {str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
receipt = {"command":command,"exit_code":result.returncode,"seconds":round(time.monotonic()-t0,2),
           "utc_started":started,"utc_finished":datetime.now(timezone.utc).isoformat(),
           "same_installed_kernel":True,"clean_checkout":False,
           "source_unchanged":before==after,"source_sha256":after}
(RUN/"kernel-replay-result.json").write_text(json.dumps(receipt,indent=2)+"\n")
print(json.dumps({k:v for k,v in receipt.items() if k!="source_sha256"}),flush=True)
sys.exit(result.returncode if result.returncode else (0 if before==after else 1))
