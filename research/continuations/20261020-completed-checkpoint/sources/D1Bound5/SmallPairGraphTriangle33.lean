import D1Bound5.SmallPairLightAssembly33

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_33_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_33 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2 smallPairLarge_33 PairGraphPrepared33.colors
    PairLightPrepared33.left_checked PairLightPrepared33.right_checked

end D1Bound5
