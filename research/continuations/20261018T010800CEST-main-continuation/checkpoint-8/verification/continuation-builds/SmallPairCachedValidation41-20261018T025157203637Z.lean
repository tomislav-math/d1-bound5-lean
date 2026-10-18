import D1Bound5.SmallPairCachedData41

namespace D1Bound5.PairCachedPilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Exact left-color coverage, independent of every pair comparison. -/
theorem left_cached_coverage_checked :
    ((pairSplitByMask cachedVertices smallPairPilotColors_41).1.map
      PairResidueVertex.vertex) =
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).1 := by
  decide +kernel

/-- Every left-color signature is verified against its actual integral vertex. -/
theorem left_cached_signatures_checked :
    ((pairSplitByMask cachedVertices smallPairPilotColors_41).1.all fun x =>
      decide (x.signature = pairCoordinateSignature smallPairSieve_1_2 x.vertex)) = true := by
  decide +kernel

/-- Exact right-color coverage, independent of every pair comparison. -/
theorem right_cached_coverage_checked :
    ((pairSplitByMask cachedVertices smallPairPilotColors_41).2.map
      PairResidueVertex.vertex) =
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).2 := by
  decide +kernel

/-- Every right-color signature is verified against its actual integral vertex. -/
theorem right_cached_signatures_checked :
    ((pairSplitByMask cachedVertices smallPairPilotColors_41).2.all fun x =>
      decide (x.signature = pairCoordinateSignature smallPairSieve_1_2 x.vertex)) = true := by
  decide +kernel

end D1Bound5.PairCachedPilot41
