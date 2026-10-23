import D1Bound5.SmallPairLightAssembly34
import D1Bound5.SmallPairLightRightAssembly34

namespace D1Bound5
set_option maxRecDepth 100000

open PairGraphPrepared34

theorem smallPairNoTriangle_34_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_34 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2 smallPairLarge_34 colors
    PairLightPilot34.left_checked PairLightRightPilot34.right_checked

end D1Bound5
