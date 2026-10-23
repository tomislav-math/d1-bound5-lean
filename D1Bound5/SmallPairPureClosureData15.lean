import D1Bound5.SmallPairPureClosureData15Vertices
import D1Bound5.SmallPairPureClosureData15RootPairs
import D1Bound5.SmallPairPureClosureData15Destinations

namespace D1Bound5.PairLightClosurePrepared15
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

noncomputable def a : PairLightCoordinate := (-1,-1)
noncomputable def b : PairLightCoordinate := (-1,1)
noncomputable def anchorRoot : PairLightCoordinate := (2, 0)

noncomputable def witnesses : List PairLightRootWitness :=
  List.zipWith (fun (z : PairLightCoordinate) (rs : PairLightCoordinate × PairLightCoordinate) =>
    ⟨z, rs.1, rs.2⟩) vertices rootPairs

end D1Bound5.PairLightClosurePrepared15
