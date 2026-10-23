import D1Bound5.SmallPairPureClosureData36Vertices
import D1Bound5.SmallPairPureClosureData36RootPairs
import D1Bound5.SmallPairPureClosureData36Destinations

namespace D1Bound5.PairLightClosurePrepared36
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

noncomputable def a : PairLightCoordinate := (-2,-1)
noncomputable def b : PairLightCoordinate := (1,0)
noncomputable def anchorRoot : PairLightCoordinate := (1, -1)

noncomputable def witnesses : List PairLightRootWitness :=
  List.zipWith (fun (z : PairLightCoordinate) (rs : PairLightCoordinate × PairLightCoordinate) =>
    ⟨z, rs.1, rs.2⟩) vertices rootPairs

end D1Bound5.PairLightClosurePrepared36
