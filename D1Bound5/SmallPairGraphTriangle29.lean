import D1Bound5.SmallPairLightAssembly29

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_29_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_29 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_1 smallPairLarge_29 PairGraphPrepared29.colors
    PairLightPrepared29.left_checked PairLightPrepared29.right_checked

end D1Bound5
