#!/usr/bin/env python3
"""Check the release file manifest without modifying any evidence."""
from pathlib import Path
import hashlib

root = Path(__file__).resolve().parents[1]
manifest = Path(__file__).resolve().parent / 'FILES.sha256'
count = 0
for line in manifest.read_text().splitlines():
    wanted, name = line.split('  ', 1)
    path = (root / name).resolve()
    if root not in path.parents:
        raise SystemExit('FAIL: invalid manifest path')
    if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != wanted:
        raise SystemExit('FAIL: ' + name)
    count += 1
print('PASS: {} release files match their SHA-256 digests'.format(count))
