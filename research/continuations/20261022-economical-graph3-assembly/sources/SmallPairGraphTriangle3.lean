import D1Bound5.SmallPairLightAssembly3

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_3_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_3 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_3 PairGraphPrepared3.colors
    PairLightPrepared3.left_checked PairLightPrepared3.right_checked

end D1Bound5
