import D1Bound5.SmallPairLightAssembly40

namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_40_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_40 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2 smallPairLarge_40 PairGraphPrepared40.colors
    PairLightPrepared40.left_checked PairLightPrepared40.right_checked

end D1Bound5
