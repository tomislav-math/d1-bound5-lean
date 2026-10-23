import D1Bound5.SmallPairLightAssembly4

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_4_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_4 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_4 PairGraphPrepared4.colors
    PairLightPrepared4.left_checked PairLightPrepared4.right_checked

end D1Bound5
