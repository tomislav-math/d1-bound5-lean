import D1Bound5.SmallPairLightAssembly1

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_1_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_1 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_1 PairGraphPrepared1.colors
    PairLightPrepared1.left_checked PairLightPrepared1.right_checked

end D1Bound5
