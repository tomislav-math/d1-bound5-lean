import D1Bound5.SmallPairLightLeft7Prefix002
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared7
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.leftCached.drop 268) (PairLightPrepared7.leftRows.drop 268) = true := left_prefix_002_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.leftCached.drop 292) (PairLightPrepared7.leftRows.drop 292) = true := left_prefix_002_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.leftCached.drop 316) (PairLightPrepared7.leftRows.drop 316) = true := left_prefix_002_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.leftCached.drop 340) (PairLightPrepared7.leftRows.drop 340) = true := left_prefix_002_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.leftCached.drop 364) (PairLightPrepared7.leftRows.drop 364) = true := left_prefix_002_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.leftCached.drop 388) (PairLightPrepared7.leftRows.drop 388) = true := left_prefix_002_part05_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 20
  (PairLightPrepared7.leftCached.drop 412) (PairLightPrepared7.leftRows.drop 412) = true := left_prefix_002_part06_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 164
  (PairLightPrepared7.leftCached.drop 268) (PairLightPrepared7.leftRows.drop 268) = true := left_prefix_002_direct_checked
end D1Bound5.PairLightAdaptivePrepared7
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared7.left_prefix_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared7.left_prefix_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared7.left_prefix_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared7.left_prefix_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared7.left_prefix_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared7.left_prefix_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared7.left_prefix_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared7.left_prefix_002_direct_checked, `D1Bound5.PairLightPrepared7.sieve, `D1Bound5.PairLightPrepared7.leftVertices, `D1Bound5.PairLightPrepared7.leftCached, `D1Bound5.PairLightPrepared7.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
