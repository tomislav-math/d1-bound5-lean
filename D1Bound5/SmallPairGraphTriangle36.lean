import D1Bound5.SmallPairLightAssembly36

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_36_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_36 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2 smallPairLarge_36 PairGraphPrepared36.colors
    PairLightPrepared36.left_checked PairLightPrepared36.right_checked

end D1Bound5
