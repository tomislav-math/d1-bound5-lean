import D1Bound5.SmallPairLightAssembly39

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_39_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_39 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2 smallPairLarge_39 PairGraphPrepared39.colors
    PairLightPrepared39.left_checked PairLightPrepared39.right_checked

end D1Bound5
