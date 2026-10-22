import D1Bound5.SmallPairLightRight3Prefix001
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared3
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 111) (PairLightPrepared3.rightRows.drop 111) = true := right_prefix_001_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 135) (PairLightPrepared3.rightRows.drop 135) = true := right_prefix_001_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 159) (PairLightPrepared3.rightRows.drop 159) = true := right_prefix_001_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 183) (PairLightPrepared3.rightRows.drop 183) = true := right_prefix_001_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 207) (PairLightPrepared3.rightRows.drop 207) = true := right_prefix_001_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 231) (PairLightPrepared3.rightRows.drop 231) = true := right_prefix_001_part05_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 255) (PairLightPrepared3.rightRows.drop 255) = true := right_prefix_001_part06_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 279) (PairLightPrepared3.rightRows.drop 279) = true := right_prefix_001_part07_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 3
  (PairLightPrepared3.rightCached.drop 303) (PairLightPrepared3.rightRows.drop 303) = true := right_prefix_001_part08_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 195
  (PairLightPrepared3.rightCached.drop 111) (PairLightPrepared3.rightRows.drop 111) = true := right_prefix_001_direct_checked
end D1Bound5.PairLightAdaptivePrepared3
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared3.right_prefix_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_001_direct_checked, `D1Bound5.PairLightPrepared3.sieve, `D1Bound5.PairLightPrepared3.rightVertices, `D1Bound5.PairLightPrepared3.rightCached, `D1Bound5.PairLightPrepared3.rightRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
