import D1Bound5.SmallPairLightAssembly35

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_35_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_35 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2 smallPairLarge_35 PairGraphPrepared35.colors
    PairLightPrepared35.left_checked PairLightPrepared35.right_checked

end D1Bound5
