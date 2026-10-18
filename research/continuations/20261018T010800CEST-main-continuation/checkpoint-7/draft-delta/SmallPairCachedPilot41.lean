import D1Bound5.SmallPairCachedLeft41
import D1Bound5.SmallPairCachedRight41

namespace D1Bound5.PairCachedPilot41

theorem triangle_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairPilotLarge_41 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2
    smallPairPilotLarge_41 smallPairPilotColors_41 left_checked right_checked

end D1Bound5.PairCachedPilot41
