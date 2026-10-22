import D1Bound5.SmallPairLightAssembly25

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_25_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_25 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_1 smallPairLarge_25 PairGraphPrepared25.colors
    PairLightPrepared25.left_checked PairLightPrepared25.right_checked

end D1Bound5
