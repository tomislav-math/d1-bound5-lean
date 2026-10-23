import D1Bound5.SmallPairLightAssembly21

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_21_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_21 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_1 smallPairLarge_21 PairGraphPrepared21.colors
    PairLightPrepared21.left_checked PairLightPrepared21.right_checked

end D1Bound5
