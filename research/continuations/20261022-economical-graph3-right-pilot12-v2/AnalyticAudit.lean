import D1Bound5.SmallPairLightRight3Pilot12
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared3
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 12
  (PairLightPrepared3.rightCached.drop 0) (PairLightPrepared3.rightRows.drop 0) = true := right_pilot12_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 12
  (PairLightPrepared3.rightCached.drop 0) (PairLightPrepared3.rightRows.drop 0) = true := right_pilot12_direct_checked
end D1Bound5.PairLightAdaptivePrepared3
namespace D1Bound5.PairLightPrepared3
example : List PairLightCoordinate := rightVertices
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightAdaptivePrepared3
end D1Bound5.PairLightAdaptivePrepared3
namespace D1Bound5.PairLightPrepared3
example : List PairLightCachedVertex := rightCached
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightAdaptivePrepared3
end D1Bound5.PairLightAdaptivePrepared3
namespace D1Bound5.PairLightPrepared3
example : List (Nat × List Nat) := rightRows
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightAdaptivePrepared3
end D1Bound5.PairLightAdaptivePrepared3
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared3.right_pilot12_part00_checked, `D1Bound5.PairLightAdaptivePrepared3.right_pilot12_direct_checked, `D1Bound5.PairLightPrepared3.sieve, `D1Bound5.PairLightPrepared3.rightVertices, `D1Bound5.PairLightPrepared3.rightCached, `D1Bound5.PairLightPrepared3.rightRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
