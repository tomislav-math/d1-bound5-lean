import D1Bound5.SmallPairLightAssembly23

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_23_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_23 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_1 smallPairLarge_23 PairGraphPrepared23.colors
    PairLightPrepared23.left_checked PairLightPrepared23.right_checked

end D1Bound5
