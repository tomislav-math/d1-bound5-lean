import D1Bound5.SmallPairLightData10
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared10
set_option maxRecDepth 100000
set_option maxHeartbeats 0

noncomputable def leftCached000 : List PairLightCachedVertex := PairLightPrepared10.leftCached
noncomputable def leftRows000 : List (Nat × List Nat) := PairLightPrepared10.leftRows

noncomputable def leftCached001 : List PairLightCachedVertex := leftCached000.drop 71
noncomputable def leftRows001 : List (Nat × List Nat) := leftRows000.drop 71

noncomputable def leftCached002 : List PairLightCachedVertex := leftCached001.drop 82
noncomputable def leftRows002 : List (Nat × List Nat) := leftRows001.drop 82

noncomputable def leftCached003 : List PairLightCachedVertex := leftCached002.drop 102
noncomputable def leftRows003 : List (Nat × List Nat) := leftRows002.drop 102

noncomputable def leftCached004 : List PairLightCachedVertex := leftCached003.drop 150
noncomputable def leftRows004 : List (Nat × List Nat) := leftRows003.drop 150

noncomputable def leftCached005 : List PairLightCachedVertex := leftCached004.drop 191
noncomputable def leftRows005 : List (Nat × List Nat) := leftRows004.drop 191

noncomputable def rightCached000 : List PairLightCachedVertex := PairLightPrepared10.rightCached
noncomputable def rightRows000 : List (Nat × List Nat) := PairLightPrepared10.rightRows

noncomputable def rightCached001 : List PairLightCachedVertex := rightCached000.drop 71
noncomputable def rightRows001 : List (Nat × List Nat) := rightRows000.drop 71

noncomputable def rightCached002 : List PairLightCachedVertex := rightCached001.drop 82
noncomputable def rightRows002 : List (Nat × List Nat) := rightRows001.drop 82

noncomputable def rightCached003 : List PairLightCachedVertex := rightCached002.drop 102
noncomputable def rightRows003 : List (Nat × List Nat) := rightRows002.drop 102

noncomputable def rightCached004 : List PairLightCachedVertex := rightCached003.drop 150
noncomputable def rightRows004 : List (Nat × List Nat) := rightRows003.drop 150

noncomputable def rightCached005 : List PairLightCachedVertex := rightCached004.drop 191
noncomputable def rightRows005 : List (Nat × List Nat) := rightRows004.drop 191


end D1Bound5.PairLightAdaptivePrepared10
