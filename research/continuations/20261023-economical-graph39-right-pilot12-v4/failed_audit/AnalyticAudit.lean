import D1Bound5.SmallPairLightRight39Pilot12
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared39
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 12
  (PairLightPrepared39.rightCached.drop 0) (PairLightPrepared39.rightRows.drop 0) = true := right_pilot12_part00_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 12
  (PairLightPrepared39.rightCached.drop 0) (PairLightPrepared39.rightRows.drop 0) = true := right_pilot12_direct_checked
example : List PairLightCachedVertex := _root_.D1Bound5.PairLightPrepared39.rightCached
example : List PairLightCachedVertex := _root_.D1Bound5.PairLightPrepared39.rightCachedChunk00
example : List PairLightCachedVertex := _root_.D1Bound5.PairLightPrepared39.rightCachedChunk01
example : List PairLightCachedVertex := _root_.D1Bound5.PairLightPrepared39.rightCachedChunk02
example : List PairLightCachedVertex := _root_.D1Bound5.PairLightPrepared39.rightCachedChunk03
end D1Bound5.PairLightAdaptivePrepared39
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared39.right_pilot12_part00_checked, `D1Bound5.PairLightAdaptivePrepared39.right_pilot12_direct_checked, `D1Bound5.PairLightPrepared39.sieve, `D1Bound5.PairLightPrepared39.rightVertices, `D1Bound5.PairLightPrepared39.rightCached, `D1Bound5.PairLightPrepared39.rightRows, `D1Bound5.PairLightPrepared39.rightCachedChunk00, `D1Bound5.PairLightPrepared39.rightCachedChunk01, `D1Bound5.PairLightPrepared39.rightCachedChunk02, `D1Bound5.PairLightPrepared39.rightCachedChunk03] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
