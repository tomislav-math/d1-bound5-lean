from pathlib import Path
from hashlib import sha256

root = Path(__file__).resolve().parents[1]
for manifest, new_file in [
    ('records/proof-source-sha256.txt', 'D1Bound5/ReferencePerturbation.lean'),
    ('records/verification-tools-sha256.txt', 'scripts/ReferencePerturbationAudit.lean'),
]:
    target = root / manifest
    original = target.read_text(encoding='utf-8').splitlines()
    paths = [line.split(None, 1)[1].strip() for line in original if line.strip()]
    if len(paths) != len(set(paths)):
        raise RuntimeError(f'Duplicate manifest entries in {manifest}')
    if new_file not in paths:
        paths.append(new_file)
    for path in paths:
        if Path(path).is_absolute() or '..' in Path(path).parts:
            raise RuntimeError(f'Nonlocal manifest path: {path}')
    entries = []
    for name in sorted(paths):
        source = root / name
        entries.append(f'{sha256(source.read_bytes()).hexdigest()}  {name}')
    target.write_text('\n'.join(entries) + '\n', encoding='utf-8')
    print(f'{manifest}: {len(entries)} verified paths')
