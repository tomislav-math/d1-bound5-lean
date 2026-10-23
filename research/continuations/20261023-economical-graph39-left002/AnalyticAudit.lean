import D1Bound5.SmallPairLightLeft39Prefix002
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared39
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 233) (PairLightPrepared39.leftRows.drop 233) = true := left_prefix_002_part00_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 257) (PairLightPrepared39.leftRows.drop 257) = true := left_prefix_002_part01_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 281) (PairLightPrepared39.leftRows.drop 281) = true := left_prefix_002_part02_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 305) (PairLightPrepared39.leftRows.drop 305) = true := left_prefix_002_part03_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 329) (PairLightPrepared39.leftRows.drop 329) = true := left_prefix_002_part04_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 353) (PairLightPrepared39.leftRows.drop 353) = true := left_prefix_002_part05_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 377) (PairLightPrepared39.leftRows.drop 377) = true := left_prefix_002_part06_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 401) (PairLightPrepared39.leftRows.drop 401) = true := left_prefix_002_part07_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
  (PairLightPrepared39.leftCached.drop 425) (PairLightPrepared39.leftRows.drop 425) = true := left_prefix_002_part08_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 9
  (PairLightPrepared39.leftCached.drop 449) (PairLightPrepared39.leftRows.drop 449) = true := left_prefix_002_part09_checked
example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 225
  (PairLightPrepared39.leftCached.drop 233) (PairLightPrepared39.leftRows.drop 233) = true := left_prefix_002_direct_checked
end D1Bound5.PairLightAdaptivePrepared39
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared39.left_prefix_002_direct_checked, `D1Bound5.PairLightPrepared39.sieve, `D1Bound5.PairLightPrepared39.leftVertices, `D1Bound5.PairLightPrepared39.leftCached, `D1Bound5.PairLightPrepared39.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
