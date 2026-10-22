import D1Bound5.SmallPairLightRight43Prefix001
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared43
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.rightCached.drop 92) (PairLightPrepared43.rightRows.drop 92) = true := right_prefix_001_part00_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.rightCached.drop 104) (PairLightPrepared43.rightRows.drop 104) = true := right_prefix_001_part01_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.rightCached.drop 116) (PairLightPrepared43.rightRows.drop 116) = true := right_prefix_001_part02_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.rightCached.drop 128) (PairLightPrepared43.rightRows.drop 128) = true := right_prefix_001_part03_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.rightCached.drop 140) (PairLightPrepared43.rightRows.drop 140) = true := right_prefix_001_part04_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.rightCached.drop 152) (PairLightPrepared43.rightRows.drop 152) = true := right_prefix_001_part05_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.rightCached.drop 164) (PairLightPrepared43.rightRows.drop 164) = true := right_prefix_001_part06_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.rightCached.drop 176) (PairLightPrepared43.rightRows.drop 176) = true := right_prefix_001_part07_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.rightCached.drop 188) (PairLightPrepared43.rightRows.drop 188) = true := right_prefix_001_part08_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.rightCached.drop 200) (PairLightPrepared43.rightRows.drop 200) = true := right_prefix_001_part09_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 2
  (PairLightPrepared43.rightCached.drop 212) (PairLightPrepared43.rightRows.drop 212) = true := right_prefix_001_part10_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 122
  (PairLightPrepared43.rightCached.drop 92) (PairLightPrepared43.rightRows.drop 92) = true := right_prefix_001_direct_checked
end D1Bound5.PairLightAdaptivePrepared43
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part09_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_part10_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_direct_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
