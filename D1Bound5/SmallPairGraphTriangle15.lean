import D1Bound5.SmallPairLightAssembly15

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_15_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_2 smallPairLarge_15 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_2 smallPairLarge_15 PairGraphPrepared15.colors
    PairLightPrepared15.left_checked PairLightPrepared15.right_checked

end D1Bound5
