import D1Bound5.SmallPairLightAssembly19

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_19_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_19 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_1 smallPairLarge_19 PairGraphPrepared19.colors
    PairLightPrepared19.left_checked PairLightPrepared19.right_checked

end D1Bound5
