"""Emit new proof wrappers reusing the accepted cached pilot data unchanged.

No vertices, signatures, or colors are copied. The original cached wrappers
and passed generic sources are preserved for comparison and provenance.
"""
from pathlib import Path
import hashlib
import json

HERE = Path(__file__).resolve().parent
OUT = HERE / "cached_integer_pilot41"
DATA = HERE / "cached_pilot41/SmallPairCachedData41.lean"
DATA_SHA = "8675170ee8dd4cc2f8b97a8045aab373693eeb10d3ad80f0d24e5d1dc549c779"
sha = lambda b: hashlib.sha256(b).hexdigest()
assert sha(DATA.read_bytes()) == DATA_SHA
OUT.mkdir(exist_ok=True)

for name, projection in [("Left", 1), ("Right", 2)]:
    lower = name.lower()
    source = f'''import D1Bound5.PairCachedIntegerObstruction
import D1Bound5.SmallPairCachedData41

namespace D1Bound5.PairCachedIntegerPilot41
open PairCachedPilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem {lower}_certificate_checked :
    pairCachedIntegerIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).{projection}
      (pairSplitByMask cachedVertices smallPairPilotColors_41).{projection} = true := by
  decide +kernel

/-- The unchanged original independent-class predicate. -/
theorem {lower}_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).{projection} = true :=
  pairIndependentBool_of_cached_integer_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).{projection}
    (pairSplitByMask cachedVertices smallPairPilotColors_41).{projection}
    {lower}_certificate_checked

end D1Bound5.PairCachedIntegerPilot41
'''
    (OUT / f"SmallPairCachedInteger{name}41.lean").write_text(source)

(OUT / "SmallPairCachedIntegerPilot41.lean").write_text('''import D1Bound5.SmallPairCachedIntegerLeft41
import D1Bound5.SmallPairCachedIntegerRight41

namespace D1Bound5.PairCachedIntegerPilot41

theorem triangle_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairPilotLarge_41 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2
    smallPairPilotLarge_41 smallPairPilotColors_41 left_checked right_checked

end D1Bound5.PairCachedIntegerPilot41
''')
report = {
    "status": "New uncompiled wrappers; no kernel acceptance claimed",
    "reused_accepted_data_sha256": DATA_SHA,
    "copied_vertices_or_signatures": False,
    "files": {p.name: {"sha256": sha(p.read_bytes()), "bytes": p.stat().st_size}
              for p in sorted(OUT.glob("*.lean"))},
}
(OUT / "cached_integer_pilot41_manifest.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps(report, indent=2))
