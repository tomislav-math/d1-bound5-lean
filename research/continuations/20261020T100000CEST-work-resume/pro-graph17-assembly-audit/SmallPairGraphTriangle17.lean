import D1Bound5.SmallPairLightAssembly17

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_17_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_2 smallPairLarge_17 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_2 smallPairLarge_17 PairGraphPrepared17.colors
    PairLightPrepared17.left_checked PairLightPrepared17.right_checked

end D1Bound5
