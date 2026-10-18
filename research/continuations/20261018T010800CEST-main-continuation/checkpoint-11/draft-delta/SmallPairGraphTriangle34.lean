import D1Bound5.SmallPairSelectedLeft34
import D1Bound5.SmallPairSelectedRight34

namespace D1Bound5
set_option maxRecDepth 100000

open PairGraphPrepared34

theorem smallPairNoTriangle_34_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_34 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2 smallPairLarge_34 colors
    PairSelectedPilot34.left_checked PairSelectedPilot34.right_checked

end D1Bound5
