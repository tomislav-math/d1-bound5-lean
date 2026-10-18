"""Emit only the optional indexed pilot, reusing already staged root data."""
from pathlib import Path
import hashlib
import json
from pair_staging import load_row, lean_option, HERE, ROOT

GENERIC = HERE / "PairClosureIndexedWitness.lean"
GENERIC_SHA = "396e39b992bc9611aabcfcda13356692e98676409381a756555e84104fe22420"
REVIEWED_PRIOR_GENERIC_SHA = "cf1974b83acff2e08dabccf8818b3a4f539024362890883b72209680ae904e55"
WITNESS_SHA = "38ab206ade22eb6de1a08e371b6d71713bc639bf68029e7c433f53babc6ff7fd"
sha = lambda b: hashlib.sha256(b).hexdigest()
assert sha(GENERIC.read_bytes()) == GENERIC_SHA
assert sha((HERE / "SmallPairWitnessData41.lean").read_bytes()) == WITNESS_SHA
row = load_row(41)
destinations = ",\n".join(f"  ({lean_option(p)}, {lean_option(m)})" for p, m in row["destinations"])
source = f'''import D1Bound5.PairClosureIndexedWitness
import D1Bound5.SmallPairWitnessData41

namespace D1Bound5.PairPhasePilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original-closure indices for both signed mutations; none means above bound. -/
def indexedClosureDestinations : List (Option ℕ × Option ℕ) := [
{destinations}
]

theorem closure_indexed_witness_checked :
    pairClosureIndexedWitnessBool anchorA anchorB anchorRootWitness (10^1100)
      closure closureWitnesses indexedClosureDestinations = true := by
  decide +kernel

theorem closure_checked_by_indexed_witness :
    pairClosureBool anchorA anchorB (10^1100) closure = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) anchorA anchorB anchorRootWitness
    (10^1100) closure closureWitnesses indexedClosureDestinations closure_indexed_witness_checked

end D1Bound5.PairPhasePilot41
'''
dest = HERE / "SmallPairIndexedClosure41.lean"
dest.write_text(source)
report = {"status": "Uncompiled optional indexed pilot; existing phase/root data reused",
          "generic_sha256": GENERIC_SHA, "root_data_sha256": WITNESS_SHA,
          "reviewed_prior_generic_sha256": REVIEWED_PRIOR_GENERIC_SHA,
          "vertices": len(row["vertices"]),
          "destination_digest": row["diagnostic"]["destination_indices_sha256"],
          "some_destinations": sum(i is not None for pair in row["destinations"] for i in pair),
          "none_destinations": sum(i is None for pair in row["destinations"] for i in pair),
          "file_sha256": sha(dest.read_bytes()), "bytes": dest.stat().st_size}
(HERE / "indexed_pilot41_manifest.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps(report, indent=2))
