import D1Bound5.SmallPairLightRight39Prefix001
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared39
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 98) (PairLightPrepared39.rightRows.drop 98) = true := right_prefix_001_part00_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 122) (PairLightPrepared39.rightRows.drop 122) = true := right_prefix_001_part01_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 146) (PairLightPrepared39.rightRows.drop 146) = true := right_prefix_001_part02_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 170) (PairLightPrepared39.rightRows.drop 170) = true := right_prefix_001_part03_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 194) (PairLightPrepared39.rightRows.drop 194) = true := right_prefix_001_part04_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 18
  (PairLightPrepared39.rightCached.drop 218) (PairLightPrepared39.rightRows.drop 218) = true := right_prefix_001_part05_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 138
  (PairLightPrepared39.rightCached.drop 98) (PairLightPrepared39.rightRows.drop 98) = true := right_prefix_001_direct_checked
end D1Bound5.PairLightAdaptivePrepared39
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared39.right_prefix_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_001_direct_checked, `D1Bound5.PairLightPrepared39.sieve, `D1Bound5.PairLightPrepared39.rightVertices, `D1Bound5.PairLightPrepared39.rightCached, `D1Bound5.PairLightPrepared39.rightRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
