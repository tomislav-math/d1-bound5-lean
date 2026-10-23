import D1Bound5.SmallPairLightAssembly7

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_7_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_7 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_7 PairGraphPrepared7.colors
    PairLightPrepared7.left_checked PairLightPrepared7.right_checked

end D1Bound5
