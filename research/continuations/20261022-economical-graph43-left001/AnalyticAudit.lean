import D1Bound5.SmallPairLightLeft43Prefix001
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared43
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 91) (PairLightPrepared43.leftRows.drop 91) = true := left_prefix_001_part00_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 103) (PairLightPrepared43.leftRows.drop 103) = true := left_prefix_001_part01_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 115) (PairLightPrepared43.leftRows.drop 115) = true := left_prefix_001_part02_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 127) (PairLightPrepared43.leftRows.drop 127) = true := left_prefix_001_part03_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 139) (PairLightPrepared43.leftRows.drop 139) = true := left_prefix_001_part04_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 151) (PairLightPrepared43.leftRows.drop 151) = true := left_prefix_001_part05_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 163) (PairLightPrepared43.leftRows.drop 163) = true := left_prefix_001_part06_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 175) (PairLightPrepared43.leftRows.drop 175) = true := left_prefix_001_part07_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 187) (PairLightPrepared43.leftRows.drop 187) = true := left_prefix_001_part08_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
  (PairLightPrepared43.leftCached.drop 199) (PairLightPrepared43.leftRows.drop 199) = true := left_prefix_001_part09_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 1
  (PairLightPrepared43.leftCached.drop 211) (PairLightPrepared43.leftRows.drop 211) = true := left_prefix_001_part10_checked
example : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 121
  (PairLightPrepared43.leftCached.drop 91) (PairLightPrepared43.leftRows.drop 91) = true := left_prefix_001_direct_checked
end D1Bound5.PairLightAdaptivePrepared43
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part09_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_part10_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_direct_checked, `D1Bound5.PairLightPrepared43.sieve, `D1Bound5.PairLightPrepared43.leftVertices, `D1Bound5.PairLightPrepared43.leftCached, `D1Bound5.PairLightPrepared43.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
