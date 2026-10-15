#!/usr/bin/env python3
"""Run the shipped v4 checks without overwriting the shipped evidence."""
from pathlib import Path
from datetime import datetime, timezone
import argparse
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--results', type=Path, help='New destination for fresh logs/results')
args = parser.parse_args()
stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
dest = (args.results or ROOT / 'rerun_results' / stamp).resolve()
dest.mkdir(parents=True, exist_ok=False)
source = ROOT / 'revision_v4/D1_bound5-v4.tex'
digest = hashlib.sha256(source.read_bytes()).hexdigest()
assert digest == (ROOT / 'revision_v4/release_source.sha256').read_text().split()[0]
jobs = [
    ('math_review', ['revision_v4/checks/math_review_checks.py']),
    ('approximation', ['revision_v4/checks/approximation_local.py']),
    ('completion', ['revision_v4/checks/completion_v4.py']),
    ('interval_equivalence', ['revision_v4/checks/interval_equivalence.py',
                              'revision_v4/D1_bound5-v4.tex']),
    ('independent_interval_referee', ['revision_v4/reviews/interval_referee_independent.py']),
    ('final_controls', ['revision_v4/checks/final_controls.py']),
]
results = []
with tempfile.TemporaryDirectory(prefix='D1_bound5_v4_checks_') as directory:
    run = Path(directory)
    (run / 'output').mkdir()
    shutil.copy2(ROOT / 'output/D1_bound5-v3.tex', run / 'output/D1_bound5-v3.tex')
    shutil.copytree(ROOT / 'revision_v4', run / 'revision_v4',
                    ignore=shutil.ignore_patterns('render', '__pycache__', '*.pyc'))
    for name, command in jobs:
        completed = subprocess.run([sys.executable, *command], cwd=run,
                                   text=True, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)
        (dest / (name + '.log')).write_text(completed.stdout, encoding='utf-8')
        results.append({'check': name, 'exit_code': completed.returncode})
        print(name + ': ' + ('PASS' if completed.returncode == 0 else 'FAIL'), flush=True)
        if completed.returncode:
            print(completed.stdout, file=sys.stderr)
            break
    for item in (run / 'revision_v4/checks').glob('*.json'):
        shutil.copy2(item, dest / item.name)
success = len(results) == len(jobs) and all(x['exit_code'] == 0 for x in results)
(dest / 'run_summary.json').write_text(json.dumps({
    'status': 'PASS' if success else 'FAIL', 'source_sha256': digest,
    'checks': results,
    'scope': 'Fresh scoped v4 checks; historical large extension graphs are not rerun.'
}, indent=2) + '\n', encoding='utf-8')
print('Results: ' + str(dest), flush=True)
sys.exit(0 if success else 1)
