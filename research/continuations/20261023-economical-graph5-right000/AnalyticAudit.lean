import D1Bound5.SmallPairLightRight5Prefix000
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared5
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.rightCached.drop 12) (PairLightPrepared5.rightRows.drop 12) = true := right_prefix_000_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.rightCached.drop 24) (PairLightPrepared5.rightRows.drop 24) = true := right_prefix_000_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.rightCached.drop 36) (PairLightPrepared5.rightRows.drop 36) = true := right_prefix_000_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.rightCached.drop 48) (PairLightPrepared5.rightRows.drop 48) = true := right_prefix_000_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.rightCached.drop 60) (PairLightPrepared5.rightRows.drop 60) = true := right_prefix_000_part05_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.rightCached.drop 72) (PairLightPrepared5.rightRows.drop 72) = true := right_prefix_000_part06_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.rightCached.drop 84) (PairLightPrepared5.rightRows.drop 84) = true := right_prefix_000_part07_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 10
  (PairLightPrepared5.rightCached.drop 96) (PairLightPrepared5.rightRows.drop 96) = true := right_prefix_000_part08_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 106
  (PairLightPrepared5.rightCached.drop 0) (PairLightPrepared5.rightRows.drop 0) = true := right_prefix_000_direct_checked
end D1Bound5.PairLightAdaptivePrepared5
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared5.right_prefix_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_000_part08_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_000_direct_checked, `D1Bound5.PairLightPrepared5.sieve, `D1Bound5.PairLightPrepared5.rightVertices, `D1Bound5.PairLightPrepared5.rightCached, `D1Bound5.PairLightPrepared5.rightRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
