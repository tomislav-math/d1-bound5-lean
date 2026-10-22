"""Bounded continuation watcher; no compiler, Git mutation, or scheduler."""
from pathlib import Path
import json,subprocess,sys,time
R=Path('/Users/tp/Lean/D1Bound5');W=R/'research/continuations';O=W/sys.argv[1];limit=time.monotonic()+int(sys.argv[3]);assert 0<int(sys.argv[3])<=1800
while time.monotonic()<limit:
 if (O/'FAILURE.json').exists():raise RuntimeError((O/'FAILURE.json').read_text())
 if (O/'VERIFICATION_SUMMARY.json').exists() and not json.loads((O/'OWNER.json').read_text())['active']:break
 time.sleep(2)
else:raise TimeoutError('Proof worker still active; no publication changes performed')
subprocess.run(['/Users/tp/.local/bin/python3.12','-B',str(Path(__file__).with_name('prepare.py')),O.name,sys.argv[2]],check=True)
