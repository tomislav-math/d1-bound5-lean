import D1Bound5.SmallPairLightAssembly8

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_8_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_8 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_8 PairGraphPrepared8.colors
    PairLightPrepared8.left_checked PairLightPrepared8.right_checked

end D1Bound5
