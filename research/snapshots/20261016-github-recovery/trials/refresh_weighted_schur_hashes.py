"""Refresh only the two D1Bound5 fingerprint manifests after the audited unit."""
from pathlib import Path
import hashlib

root = Path(__file__).resolve().parents[1]
updates = (
    ('records/proof-source-sha256.txt', 'D1Bound5/WeightedSchur.lean'),
    ('records/verification-tools-sha256.txt', 'scripts/WeightedSchurAudit.lean'),
)
for manifest, added in updates:
    path = root / manifest
    original = path.read_text(encoding='utf-8').splitlines()
    members = {line.split(None, 1)[1].strip() for line in original}
    members.add(added)
    assert all((root / p).is_file() for p in members)
    lines = [f'{hashlib.sha256((root / p).read_bytes()).hexdigest()}  {p}\n'
             for p in sorted(members)]
    tmp = path.with_name(path.name + '.new')
    tmp.write_text(''.join(lines), encoding='utf-8')
    tmp.replace(path)
    print(f'{manifest}: {len(lines)} verified file paths')
