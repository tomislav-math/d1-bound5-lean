import D1Bound5.SmallPairLightRight7Pilot12
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared7
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 12
  (PairLightPrepared7.rightCached.drop 0) (PairLightPrepared7.rightRows.drop 0) = true := right_pilot12_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 12
  (PairLightPrepared7.rightCached.drop 0) (PairLightPrepared7.rightRows.drop 0) = true := right_pilot12_direct_checked
end D1Bound5.PairLightAdaptivePrepared7
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared7.right_pilot12_part00_checked, `D1Bound5.PairLightAdaptivePrepared7.right_pilot12_direct_checked, `D1Bound5.PairLightPrepared7.sieve, `D1Bound5.PairLightPrepared7.rightVertices, `D1Bound5.PairLightPrepared7.rightCached, `D1Bound5.PairLightPrepared7.rightRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
