import D1Bound5.SmallPairLightAssembly43

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_43_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_3 smallPairLarge_43 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_3 smallPairLarge_43 PairGraphPrepared43.colors
    PairLightPrepared43.left_checked PairLightPrepared43.right_checked

end D1Bound5
