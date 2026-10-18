import D1Bound5.SmallPairBipartitePilotLeft41
import D1Bound5.SmallPairBipartitePilotRight41

namespace D1Bound5

theorem smallPairPilotNoTriangle_41_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairPilotLarge_41 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2
    smallPairPilotLarge_41 smallPairPilotColors_41
    smallPairPilotLeft_41_checked smallPairPilotRight_41_checked

end D1Bound5
