import D1Bound5.SmallPairLightLeft5Prefix002
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared5
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 269) (PairLightPrepared5.leftRows.drop 269) = true := left_prefix_002_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 293) (PairLightPrepared5.leftRows.drop 293) = true := left_prefix_002_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 317) (PairLightPrepared5.leftRows.drop 317) = true := left_prefix_002_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 341) (PairLightPrepared5.leftRows.drop 341) = true := left_prefix_002_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 365) (PairLightPrepared5.leftRows.drop 365) = true := left_prefix_002_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 389) (PairLightPrepared5.leftRows.drop 389) = true := left_prefix_002_part05_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 18
  (PairLightPrepared5.leftCached.drop 413) (PairLightPrepared5.leftRows.drop 413) = true := left_prefix_002_part06_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 162
  (PairLightPrepared5.leftCached.drop 269) (PairLightPrepared5.leftRows.drop 269) = true := left_prefix_002_direct_checked
end D1Bound5.PairLightAdaptivePrepared5
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared5.left_prefix_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_002_direct_checked, `D1Bound5.PairLightPrepared5.sieve, `D1Bound5.PairLightPrepared5.leftVertices, `D1Bound5.PairLightPrepared5.leftCached, `D1Bound5.PairLightPrepared5.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
