import D1Bound5.SmallPairLightLeft43Prefix000
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared43
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 0) (PairLightPrepared43.leftRows.drop 0) = true := left_prefix_000_part00_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 12) (PairLightPrepared43.leftRows.drop 12) = true := left_prefix_000_part01_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 24) (PairLightPrepared43.leftRows.drop 24) = true := left_prefix_000_part02_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 36) (PairLightPrepared43.leftRows.drop 36) = true := left_prefix_000_part03_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 48) (PairLightPrepared43.leftRows.drop 48) = true := left_prefix_000_part04_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 60) (PairLightPrepared43.leftRows.drop 60) = true := left_prefix_000_part05_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 72) (PairLightPrepared43.leftRows.drop 72) = true := left_prefix_000_part06_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 7
  (PairLightPrepared43.leftCached.drop 84) (PairLightPrepared43.leftRows.drop 84) = true := left_prefix_000_part07_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 91
  PairLightPrepared43.leftCached PairLightPrepared43.leftRows = true := left_prefix_000_direct_checked
end D1Bound5.PairLightAdaptivePrepared43
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared43.left_prefix_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_000_direct_checked, `D1Bound5.PairLightPrepared43.sieve, `D1Bound5.PairLightPrepared43.leftVertices, `D1Bound5.PairLightPrepared43.leftCached, `D1Bound5.PairLightPrepared43.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
