import D1Bound5.SmallPairLightAssembly11

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_11_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_11 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_0_1 smallPairLarge_11 PairGraphPrepared11.colors
    PairLightPrepared11.left_checked PairLightPrepared11.right_checked

end D1Bound5
