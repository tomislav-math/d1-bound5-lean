"""Refresh existing checked-source manifests without dropping prior entries.
Only the new source and its audit script are added.
"""
from pathlib import Path
from hashlib import sha256

root = Path("/Users/tp/Lean/D1Bound5")
specs = (
    ("records/proof-source-sha256.txt", "D1Bound5/ProductFivePrefixDet.lean"),
    ("records/verification-tools-sha256.txt", "scripts/ProductFivePrefixDetAudit.lean"),
)
for record, addition in specs:
    p = root / record
    paths = {line.split(maxsplit=1)[1] for line in p.read_text().splitlines()}
    paths.add(addition)
    for relative in paths:
        if not (root / relative).is_file():
            raise FileNotFoundError(relative)
    data = "".join(
        f"{sha256((root / relative).read_bytes()).hexdigest()}  {relative}\n"
        for relative in sorted(paths)
    )
    p.write_text(data)
    print(f"MANIFEST_REFRESH {record}: {len(paths)} paths; includes {addition}")
