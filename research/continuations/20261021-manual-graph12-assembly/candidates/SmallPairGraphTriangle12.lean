import D1Bound5.SmallPairLightAssembly12

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_12_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_12 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_12 PairGraphPrepared12.colors
    PairLightPrepared12.left_checked PairLightPrepared12.right_checked

end D1Bound5
