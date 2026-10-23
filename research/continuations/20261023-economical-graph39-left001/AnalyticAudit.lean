import D1Bound5.SmallPairLightLeft39Prefix001
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared39
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 97) (PairLightPrepared39.leftRows.drop 97) = true := left_prefix_001_part00_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 121) (PairLightPrepared39.leftRows.drop 121) = true := left_prefix_001_part01_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 145) (PairLightPrepared39.leftRows.drop 145) = true := left_prefix_001_part02_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 169) (PairLightPrepared39.leftRows.drop 169) = true := left_prefix_001_part03_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 193) (PairLightPrepared39.leftRows.drop 193) = true := left_prefix_001_part04_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 16
  (PairLightPrepared39.leftCached.drop 217) (PairLightPrepared39.leftRows.drop 217) = true := left_prefix_001_part05_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 136
  (PairLightPrepared39.leftCached.drop 97) (PairLightPrepared39.leftRows.drop 97) = true := left_prefix_001_direct_checked
end D1Bound5.PairLightAdaptivePrepared39
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared39.left_prefix_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_001_direct_checked, `D1Bound5.PairLightPrepared39.sieve, `D1Bound5.PairLightPrepared39.leftVertices, `D1Bound5.PairLightPrepared39.leftCached, `D1Bound5.PairLightPrepared39.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
