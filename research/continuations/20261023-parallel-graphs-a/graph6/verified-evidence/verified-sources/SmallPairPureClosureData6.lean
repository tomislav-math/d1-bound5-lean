import D1Bound5.SmallPairPureClosureData6Vertices
import D1Bound5.SmallPairPureClosureData6RootPairs
import D1Bound5.SmallPairPureClosureData6Destinations

namespace D1Bound5.PairLightClosurePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

noncomputable def a : PairLightCoordinate := (-2,-1)
noncomputable def b : PairLightCoordinate := (2,-1)
noncomputable def anchorRoot : PairLightCoordinate := (0, 2)

noncomputable def witnesses : List PairLightRootWitness :=
  List.zipWith (fun (z : PairLightCoordinate) (rs : PairLightCoordinate × PairLightCoordinate) =>
    ⟨z, rs.1, rs.2⟩) vertices rootPairs

end D1Bound5.PairLightClosurePrepared6
