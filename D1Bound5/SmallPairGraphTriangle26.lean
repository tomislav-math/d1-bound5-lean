import D1Bound5.SmallPairGraphInputs26
import D1Bound5.SmallPairLightAssembly26


namespace D1Bound5
set_option maxRecDepth 100000

theorem smallPairNoTriangle_26_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_26 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_1 smallPairLarge_26 PairGraphPrepared26.colors
    PairLightPrepared26.left_checked PairLightPrepared26.right_checked

end D1Bound5

