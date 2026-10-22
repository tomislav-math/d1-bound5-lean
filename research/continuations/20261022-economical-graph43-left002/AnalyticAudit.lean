import D1Bound5.SmallPairLightLeft43Prefix002
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared43
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 212) (PairLightPrepared43.leftRows.drop 212) = true := left_prefix_002_part00_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 236) (PairLightPrepared43.leftRows.drop 236) = true := left_prefix_002_part01_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 260) (PairLightPrepared43.leftRows.drop 260) = true := left_prefix_002_part02_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 284) (PairLightPrepared43.leftRows.drop 284) = true := left_prefix_002_part03_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 308) (PairLightPrepared43.leftRows.drop 308) = true := left_prefix_002_part04_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 332) (PairLightPrepared43.leftRows.drop 332) = true := left_prefix_002_part05_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 356) (PairLightPrepared43.leftRows.drop 356) = true := left_prefix_002_part06_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 380) (PairLightPrepared43.leftRows.drop 380) = true := left_prefix_002_part07_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 404) (PairLightPrepared43.leftRows.drop 404) = true := left_prefix_002_part08_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 428) (PairLightPrepared43.leftRows.drop 428) = true := left_prefix_002_part09_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.leftCached.drop 452) (PairLightPrepared43.leftRows.drop 452) = true := left_prefix_002_part10_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 6
  (PairLightPrepared43.leftCached.drop 476) (PairLightPrepared43.leftRows.drop 476) = true := left_prefix_002_part11_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 270
  (PairLightPrepared43.leftCached.drop 212) (PairLightPrepared43.leftRows.drop 212) = true := left_prefix_002_direct_checked
end D1Bound5.PairLightAdaptivePrepared43
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_direct_checked, `D1Bound5.PairLightPrepared43.sieve, `D1Bound5.PairLightPrepared43.leftVertices, `D1Bound5.PairLightPrepared43.leftCached, `D1Bound5.PairLightPrepared43.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
