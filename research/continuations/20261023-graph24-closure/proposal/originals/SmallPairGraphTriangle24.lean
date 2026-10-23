import D1Bound5.SmallPairLightAssembly24

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_24_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_24 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_1 smallPairLarge_24 PairGraphPrepared24.colors
    PairLightPrepared24.left_checked PairLightPrepared24.right_checked

end D1Bound5
