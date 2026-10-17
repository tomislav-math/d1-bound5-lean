"""Refresh existing source/tool SHA256 inventories after verified mixed growth integration.
The lists remain otherwise unchanged; this script is not a mathematical proof.
"""
from pathlib import Path
import hashlib

new_entries = {
    "records/proof-source-sha256.txt": ["D1Bound5/MixedProductFourGrowth.lean"],
    "records/verification-tools-sha256.txt": ["scripts/MixedProductFourGrowthAudit.lean"],
}
for inventory, additions in new_entries.items():
    path = Path(inventory)
    prior = [row.split(maxsplit=1)[1].strip()
             for row in path.read_text().splitlines() if row.strip()]
    paths = sorted(set(prior + additions))
    rows = []
    for name in paths:
        fp = Path(name)
        if not fp.is_file():
            raise RuntimeError(f"Missing inventoried file: {name}")
        rows.append(f"{hashlib.sha256(fp.read_bytes()).hexdigest()}  {name}")
    path.write_text("\n".join(rows) + "\n")
    print(f"{inventory}: {len(rows)} entries")
