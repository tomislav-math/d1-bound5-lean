import D1Bound5.SmallPairLightRight43Prefix002
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared43
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 214) (PairLightPrepared43.rightRows.drop 214) = true := right_prefix_002_part00_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 238) (PairLightPrepared43.rightRows.drop 238) = true := right_prefix_002_part01_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 262) (PairLightPrepared43.rightRows.drop 262) = true := right_prefix_002_part02_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 286) (PairLightPrepared43.rightRows.drop 286) = true := right_prefix_002_part03_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 310) (PairLightPrepared43.rightRows.drop 310) = true := right_prefix_002_part04_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 334) (PairLightPrepared43.rightRows.drop 334) = true := right_prefix_002_part05_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 358) (PairLightPrepared43.rightRows.drop 358) = true := right_prefix_002_part06_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 382) (PairLightPrepared43.rightRows.drop 382) = true := right_prefix_002_part07_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 406) (PairLightPrepared43.rightRows.drop 406) = true := right_prefix_002_part08_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 430) (PairLightPrepared43.rightRows.drop 430) = true := right_prefix_002_part09_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
  (PairLightPrepared43.rightCached.drop 454) (PairLightPrepared43.rightRows.drop 454) = true := right_prefix_002_part10_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 2
  (PairLightPrepared43.rightCached.drop 478) (PairLightPrepared43.rightRows.drop 478) = true := right_prefix_002_part11_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 266
  (PairLightPrepared43.rightCached.drop 214) (PairLightPrepared43.rightRows.drop 214) = true := right_prefix_002_direct_checked
end D1Bound5.PairLightAdaptivePrepared43
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_direct_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
