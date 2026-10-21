import D1Bound5.SmallPairLightAssembly48

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_48_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_8 smallPairLarge_48 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_8 smallPairLarge_48 PairGraphPrepared48.colors
    PairLightPrepared48.left_checked PairLightPrepared48.right_checked

end D1Bound5
