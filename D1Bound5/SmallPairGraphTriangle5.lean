import D1Bound5.SmallPairLightAssembly5

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_5_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_5 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_5 PairGraphPrepared5.colors
    PairLightPrepared5.left_checked PairLightPrepared5.right_checked

end D1Bound5
