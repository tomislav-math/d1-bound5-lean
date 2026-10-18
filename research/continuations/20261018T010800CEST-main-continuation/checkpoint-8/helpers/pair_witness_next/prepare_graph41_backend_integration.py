"""Prepare, but do not install, the proof-only replacement of Graph41.

The original data declarations and all consumer theorem names/types are kept.
The isolated pilot certificate imports replace four monolithic computations.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument("--closure", choices=["membership", "indexed"], required=True)
parser.add_argument("--triangle", choices=["uncached", "cached"], required=True)
args = parser.parse_args()
OUT = Path(__file__).resolve().parent / f"integration_{args.closure}_{args.triangle}"
SOURCE = ROOT / "finite_next/two_small/D1Bound5/SmallPairGraphData41.lean"
FROZEN_SHA = "2fb18d40fa756d1fe49844454f5ddeff9c85122a82d47bf5c418699a95b879b1"
source = SOURCE.read_text()
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest() == FROZEN_SHA
closure_module, closure_proof = {
    "membership": ("SmallPairWitnessClosure41", "PairPhasePilot41.closure_checked_by_witness"),
    "indexed": ("SmallPairIndexedClosure41", "PairPhasePilot41.closure_checked_by_indexed_witness"),
}[args.closure]
triangle_module, triangle_proof = {
    "uncached": ("SmallPairBipartitePilot41", "smallPairPilotNoTriangle_41_checked"),
    "cached": ("SmallPairCachedPilot41", "PairCachedPilot41.triangle_checked"),
}[args.triangle]
imports = f'''import D1Bound5.SmallPairPhaseSeeds41
import D1Bound5.SmallPairPhaseFilter41
import D1Bound5.{closure_module}
import D1Bound5.{triangle_module}
'''
result = re.sub(r"\A(?:import [^\n]+\n)+", imports, source)
replacements = {
    "smallPairSeeds_41_checked": "PairPhasePilot41.seeds_checked",
    "smallPairClosure_41_checked": closure_proof,
    "smallPairFilter_41_checked": "PairPhasePilot41.filter_checked",
    "smallPairNoTriangle_41_checked": triangle_proof,
}
for theorem, proof in replacements.items():
    pattern = rf"(theorem {theorem}\b.*? :=) by\n  decide \+kernel"
    result, count = re.subn(pattern, lambda m: m.group(1) + "\n  " + proof, result, count=1, flags=re.S)
    assert count == 1, theorem

# Independently compare every declaration before the certificate theorems.
original_data = source[source.index("def smallPairA_41 "):source.index("theorem smallPairSeeds_41_checked")]
new_data = result[result.index("def smallPairA_41 "):result.index("theorem smallPairSeeds_41_checked")]
assert original_data == new_data, "Data declarations changed"
for theorem in replacements:
    pattern = rf"theorem {theorem}\b(.*?) :="
    assert re.search(pattern, source, re.S).group(1) == re.search(pattern, result, re.S).group(1)
assert source[source.index("theorem smallPairLarge_41_count"):] == result[result.index("theorem smallPairLarge_41_count"):]
OUT.mkdir(exist_ok=True)
dest = OUT / "SmallPairGraphData41.lean"
dest.write_text(result)
report = {
    "status": "Prepared replacement only; awaiting kernel acceptance of pilot dependencies",
    "closure_backend": args.closure,
    "triangle_backend": args.triangle,
    "original_source_sha256": FROZEN_SHA,
    "replacement_sha256": hashlib.sha256(dest.read_bytes()).hexdigest(),
    "unchanged_data_declarations_sha256": hashlib.sha256(original_data.encode()).hexdigest(),
    "replaced_proofs": replacements,
    "unchanged_count_theorem": "smallPairLarge_41_count",
    "new_imports": imports.strip().splitlines(),
    "bytes": dest.stat().st_size,
}
(OUT / "graph41_integration_manifest.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps(report, indent=2))
