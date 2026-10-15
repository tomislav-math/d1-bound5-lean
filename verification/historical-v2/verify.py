#!/usr/bin/env python3
"""Portable entry point for the delivered D1_bound5-v2 verification archive."""
from pathlib import Path
from hashlib import sha256
import argparse
import json
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent
SOURCE_SHA = '5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70'

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group(required=True)
    modes.add_argument('--integrity', action='store_true')
    modes.add_argument('--quick', action='store_true')
    modes.add_argument('--full', action='store_true')
    args = parser.parse_args()
    manifest = json.loads((ROOT / 'SHA256SUMS.json').read_text())
    for name, expected in manifest['files'].items():
        path = ROOT / name
        actual = sha256(path.read_bytes()).hexdigest()
        if actual != expected:
            raise SystemExit(f'Archive integrity failure: {name}. Use a fresh extraction if previous runs changed outputs.')
    print(f'PASS: {len(manifest["files"])} delivered-file hashes.', flush=True)
    checks = 'revision_v2/checks/'
    commands = []
    if not args.integrity:
        commands += [
            [checks+'structural_v2.py', '--expected-sha', SOURCE_SHA],
            [checks+'approximation_exact.py'],
            [checks+'completion_overlaps.py'],
            [checks+'one_small_v2.py'],
            [checks+'completion_exact.py'],
            [checks+'small_v2_constants.py'],
        ]
        if args.full:
            commands += [[checks+'small_v2_exact.py', mode] for mode in ('triples', 'pairs', 'pell')]
        commands += [
            [checks+'small_v2_source_check.py'],
            [checks+'completion_cross.py'],
            [checks+'one_small_cross_compare.py'],
            [checks+'literature_coverage.py'],
        ]
    commands.append([checks+'final_controls.py'])
    logs = ROOT / 'verification_run_logs'
    logs.mkdir(exist_ok=True)
    records = []
    for i, command in enumerate(commands, 1):
        name = Path(command[0]).stem + ('_'+command[1] if len(command)==2 else '')
        logfile = logs / f'{i:02d}_{name}.log'
        print('RUN', ' '.join(command), flush=True)
        start = time.perf_counter()
        with logfile.open('w') as stream:
            result = subprocess.run([sys.executable, '-u', *command], cwd=ROOT,
                                    stdout=stream, stderr=subprocess.STDOUT)
        records.append({'command': command, 'exit_code': result.returncode,
                        'seconds': time.perf_counter()-start,
                        'log': str(logfile.relative_to(ROOT))})
        (logs/'run.json').write_text(json.dumps(records, indent=2)+'\n')
        if result.returncode:
            print(logfile.read_text())
            raise SystemExit(result.returncode)
        print('PASS', name, flush=True)
    if args.integrity:
        print('PASS: archive and aggregate evidence integrity. Mathematical programs were not rerun.')
    elif args.quick:
        print('PASS: quick recomputation. Section 7 graph/closure outputs were checked but not recomputed.')
    else:
        print('PASS: full recomputation, including all Section 7 graphs and closures.')

if __name__ == '__main__':
    main()
