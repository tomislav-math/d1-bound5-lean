import D1Bound5.SmallPairLightAssembly45

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_45_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_5 smallPairLarge_45 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_5 smallPairLarge_45 PairGraphPrepared45.colors
    PairLightPrepared45.left_checked PairLightPrepared45.right_checked

end D1Bound5
