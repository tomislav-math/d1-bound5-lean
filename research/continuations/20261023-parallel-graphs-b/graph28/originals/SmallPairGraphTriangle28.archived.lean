import D1Bound5.SmallPairLightAssembly28

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_28_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_28 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_1 smallPairLarge_28 PairGraphPrepared28.colors
    PairLightPrepared28.left_checked PairLightPrepared28.right_checked

end D1Bound5
