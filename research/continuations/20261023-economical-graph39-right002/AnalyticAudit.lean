import D1Bound5.SmallPairLightRight39Prefix002
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared39
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 236) (PairLightPrepared39.rightRows.drop 236) = true := right_prefix_002_part00_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 260) (PairLightPrepared39.rightRows.drop 260) = true := right_prefix_002_part01_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 284) (PairLightPrepared39.rightRows.drop 284) = true := right_prefix_002_part02_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 308) (PairLightPrepared39.rightRows.drop 308) = true := right_prefix_002_part03_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 332) (PairLightPrepared39.rightRows.drop 332) = true := right_prefix_002_part04_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 356) (PairLightPrepared39.rightRows.drop 356) = true := right_prefix_002_part05_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 380) (PairLightPrepared39.rightRows.drop 380) = true := right_prefix_002_part06_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 404) (PairLightPrepared39.rightRows.drop 404) = true := right_prefix_002_part07_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.rightCached.drop 428) (PairLightPrepared39.rightRows.drop 428) = true := right_prefix_002_part08_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 4
  (PairLightPrepared39.rightCached.drop 452) (PairLightPrepared39.rightRows.drop 452) = true := right_prefix_002_part09_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 220
  (PairLightPrepared39.rightCached.drop 236) (PairLightPrepared39.rightRows.drop 236) = true := right_prefix_002_direct_checked
end D1Bound5.PairLightAdaptivePrepared39
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared39.right_prefix_002_direct_checked, `D1Bound5.PairLightPrepared39.sieve, `D1Bound5.PairLightPrepared39.rightVertices, `D1Bound5.PairLightPrepared39.rightCached, `D1Bound5.PairLightPrepared39.rightRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
