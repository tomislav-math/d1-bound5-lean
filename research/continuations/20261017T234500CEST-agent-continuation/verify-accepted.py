#!/usr/bin/env python3
"""Serial pinned build of the reviewed continuation; stops at the first failure."""
import hashlib, json, os, subprocess, sys, time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path("/Users/tp/Lean/D1Bound5")
RUN = ROOT / "research/continuations/20261017T234500CEST-agent-continuation"
LAKE = "/Users/tp/.elan/bin/lake"
MODULES = ["CrossBlockDeterminant","CoherentAnalyticInterpolation","BennettResidualDeterminant","BennettResidueCoefficient","BennettFirstOrder","BennettFirstOrderResidues","BennettPoleSeries"]
env = dict(os.environ, LEAN_NUM_THREADS="1")
results = []
def run(label, command):
    start = time.monotonic()
    with (RUN / (label + ".log")).open("w") as log:
        result = subprocess.run(command, cwd=ROOT, env=env, stdout=log, stderr=subprocess.STDOUT)
    item = {"label": label, "command": command, "exit_code": result.returncode,
            "seconds": round(time.monotonic()-start,2),
            "utc_finished": datetime.now(timezone.utc).isoformat()}
    results.append(item)
    (RUN / "accepted-build-results.json").write_text(json.dumps(results, indent=2)+"\n")
    print(json.dumps(item), flush=True)
    if result.returncode:
        sys.exit(result.returncode)
for module in MODULES:
    run("build-" + module, [LAKE, "build", "D1Bound5." + module])
root = ROOT / "D1Bound5.lean"
text = root.read_text()
for module in MODULES:
    line = "import D1Bound5." + module
    if line not in text.splitlines():
        text += line + "\n"
root.write_text(text)
run("build-final-root", [LAKE, "build"])
run("continuation-axioms", [LAKE, "env", "lean", "-DautoImplicit=false", "scripts/AgentContinuationAudit.lean"])
run("whole-project-axioms", [LAKE, "env", "lean", "-DautoImplicit=false", "scripts/Audit.lean"])
run("final-source-audit", [sys.executable, "scripts/source_audit.py"])
print("CONTINUATION_BUILD_AND_AXIOMS_PASS", flush=True)
