import D1Bound5.SmallPairRawSelectedLeft34
import D1Bound5.SmallPairRawSelectedRight34

namespace D1Bound5.PairRawSelectedPilot34
set_option maxRecDepth 100000

/-- The original triangle-free predicate, obtained from the two unchanged
color classes and the proved-equal natural-arithmetic certificate. -/
theorem triangle_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_34 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2 smallPairLarge_34
    PairGraphPrepared34.colors left_checked right_checked

end D1Bound5.PairRawSelectedPilot34
