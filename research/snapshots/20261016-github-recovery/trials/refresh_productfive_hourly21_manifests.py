from pathlib import Path
from hashlib import sha256

root = Path("/Users/tp/Lean/D1Bound5")
targets = {
    "records/proof-source-sha256.txt": [
        "D1Bound5/ProductFiveRankTwo.lean",
        "D1Bound5/ProductFiveBlockDet.lean",
        "D1Bound5/ProductFiveMatrixBridge.lean",
        "D1Bound5/ProductFiveExactIdentity.lean",
        "D1Bound5/ProductFiveArithmeticClosure.lean",
    ],
    "records/verification-tools-sha256.txt": [
        "scripts/ProductFiveRankTwoAudit.lean",
        "scripts/ProductFiveBlockDetAudit.lean",
        "scripts/ProductFiveMatrixBridgeAudit.lean",
        "scripts/ProductFiveExactIdentityAudit.lean",
        "scripts/ProductFiveArithmeticClosureAudit.lean",
    ],
}
for manifest, additions in targets.items():
    p = root / manifest
    previous = {
        line.split(maxsplit=1)[1]
        for line in p.read_text().splitlines() if line.strip()
    }
    names = sorted(previous.union(additions))
    missing = [name for name in names if not (root / name).is_file()]
    if missing:
        raise RuntimeError(f"Missing inputs for {manifest}: {missing}")
    data = "".join(
        f"{sha256((root / name).read_bytes()).hexdigest()}  {name}\n"
        for name in names
    )
    p.write_text(data)
    print(f"{manifest}: {len(names)} checked paths")
