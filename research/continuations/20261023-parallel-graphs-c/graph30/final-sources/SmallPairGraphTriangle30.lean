import D1Bound5.SmallPairLightAssembly30

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_30_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_30 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_1 smallPairLarge_30 PairGraphPrepared30.colors
    PairLightPrepared30.left_checked PairLightPrepared30.right_checked

end D1Bound5
