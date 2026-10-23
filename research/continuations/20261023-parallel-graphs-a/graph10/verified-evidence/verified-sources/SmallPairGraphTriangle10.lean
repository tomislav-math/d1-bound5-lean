import D1Bound5.SmallPairLightAssembly10

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_10_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_10 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_10 PairGraphPrepared10.colors
    PairLightPrepared10.left_checked PairLightPrepared10.right_checked

end D1Bound5
