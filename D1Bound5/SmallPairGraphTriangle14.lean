import D1Bound5.SmallPairLightAssembly14

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_14_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_2 smallPairLarge_14 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_2 smallPairLarge_14 PairGraphPrepared14.colors
    PairLightPrepared14.left_checked PairLightPrepared14.right_checked

end D1Bound5
