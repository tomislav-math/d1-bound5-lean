import D1Bound5.SmallPairLightLeft24Pilot12
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared24
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 12
  (PairLightPrepared24.leftCached.drop 0) (PairLightPrepared24.leftRows.drop 0) = true := left_pilot12_part00_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 12
  (PairLightPrepared24.leftCached.drop 0) (PairLightPrepared24.leftRows.drop 0) = true := left_pilot12_direct_checked
end D1Bound5.PairLightAdaptivePrepared24
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared24.left_pilot12_part00_checked, `D1Bound5.PairLightAdaptivePrepared24.left_pilot12_direct_checked, `D1Bound5.PairLightPrepared24.sieve, `D1Bound5.PairLightPrepared24.leftVertices, `D1Bound5.PairLightPrepared24.leftCached, `D1Bound5.PairLightPrepared24.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
