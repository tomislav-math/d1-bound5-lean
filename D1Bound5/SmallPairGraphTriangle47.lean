import D1Bound5.SmallPairLightAssembly47

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_47_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_6 smallPairLarge_47 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_6 smallPairLarge_47 PairGraphPrepared47.colors
    PairLightPrepared47.left_checked PairLightPrepared47.right_checked

end D1Bound5
