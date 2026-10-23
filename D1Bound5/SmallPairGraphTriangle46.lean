import D1Bound5.SmallPairLightAssembly46

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_46_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_6 smallPairLarge_46 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_6 smallPairLarge_46 PairGraphPrepared46.colors
    PairLightPrepared46.left_checked PairLightPrepared46.right_checked

end D1Bound5
