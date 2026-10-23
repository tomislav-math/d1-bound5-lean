import D1Bound5.SmallPairLightAssembly6

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_6_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_6 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_6 PairGraphPrepared6.colors
    PairLightPrepared6.left_checked PairLightPrepared6.right_checked

end D1Bound5
