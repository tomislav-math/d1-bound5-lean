import D1Bound5.SmallPairGraphInputs2
import D1Bound5.TwoSmallSeedDisks
import D1Bound5.PairClosureIndexedWitness
import D1Bound5.SmallPairGraphLeft2
import D1Bound5.SmallPairGraphRight2

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_2_checked :
    pairSeedsCoveredBool smallPairA_2 smallPairB_2
      seedRootDisk_0_1 smallPairClosure_2 = true := by
  decide +kernel

theorem smallPairFilter_2_checked :
    largePairVertices smallPairA_2 smallPairB_2 smallPairClosure_2 = smallPairLarge_2 := by
  decide +kernel

theorem smallPairLarge_2_count : smallPairLarge_2.length = 414 := by
  decide +kernel

end D1Bound5

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared2

theorem PairGraphPrepared2.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_2 smallPairB_2 anchorRoot
      (10^1100) smallPairClosure_2 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_2_checked :
    pairClosureBool smallPairA_2 smallPairB_2
      (10^1100) smallPairClosure_2 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_2 smallPairB_2 anchorRoot
    (10^1100) smallPairClosure_2 witnesses destinations PairGraphPrepared2.indexed_checked

end D1Bound5

namespace D1Bound5
set_option maxRecDepth 100000

open PairGraphPrepared2

theorem smallPairNoTriangle_2_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_2 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_2 colors
    PairGraphPrepared2.left_checked PairGraphPrepared2.right_checked

end D1Bound5
