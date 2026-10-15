"""Run the focused review checks. Requires Python 3, standard library only."""
from pathlib import Path
import hashlib
import json
import subprocess
import sys

here = Path(__file__).resolve().parent
checks = ['review_controls.py', 'small_checks.py', 'structure_exact.py',
          'constructions_check.py', 'f3_exact.py', 'vandermonde24_cross.py']
records = []
for name in checks:
    script = here / 'checks' / name
    result = subprocess.run([sys.executable,str(script)],cwd=here.parent,
                            capture_output=True,text=True)
    script.with_suffix('.log').write_text(result.stdout+result.stderr)
    records.append({'script':name,'exit_code':result.returncode,
                    'script_sha256':hashlib.sha256(script.read_bytes()).hexdigest()})
    print(('PASS' if result.returncode==0 else 'FAIL')+': '+name,flush=True)
    if result.returncode:
        print(result.stderr)
        break
(here/'run_results.json').write_text(json.dumps(records,indent=2)+'\n')
if len(records)!=len(checks) or any(r['exit_code'] for r in records):
    raise SystemExit(1)
print('All six focused check programs passed. Large graph enumerations were not rerun.')
