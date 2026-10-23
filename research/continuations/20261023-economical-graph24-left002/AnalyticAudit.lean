import D1Bound5.SmallPairLightLeft24Prefix002
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared24
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.leftCached.drop 248) (PairLightPrepared24.leftRows.drop 248) = true := left_prefix_002_part00_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.leftCached.drop 272) (PairLightPrepared24.leftRows.drop 272) = true := left_prefix_002_part01_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.leftCached.drop 296) (PairLightPrepared24.leftRows.drop 296) = true := left_prefix_002_part02_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.leftCached.drop 320) (PairLightPrepared24.leftRows.drop 320) = true := left_prefix_002_part03_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.leftCached.drop 344) (PairLightPrepared24.leftRows.drop 344) = true := left_prefix_002_part04_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.leftCached.drop 368) (PairLightPrepared24.leftRows.drop 368) = true := left_prefix_002_part05_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.leftCached.drop 392) (PairLightPrepared24.leftRows.drop 392) = true := left_prefix_002_part06_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.leftCached.drop 416) (PairLightPrepared24.leftRows.drop 416) = true := left_prefix_002_part07_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 6
  (PairLightPrepared24.leftCached.drop 440) (PairLightPrepared24.leftRows.drop 440) = true := left_prefix_002_part08_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 198
  (PairLightPrepared24.leftCached.drop 248) (PairLightPrepared24.leftRows.drop 248) = true := left_prefix_002_direct_checked
end D1Bound5.PairLightAdaptivePrepared24
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared24.left_prefix_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared24.left_prefix_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared24.left_prefix_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared24.left_prefix_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared24.left_prefix_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared24.left_prefix_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared24.left_prefix_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared24.left_prefix_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared24.left_prefix_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared24.left_prefix_002_direct_checked, `D1Bound5.PairLightPrepared24.sieve, `D1Bound5.PairLightPrepared24.leftVertices, `D1Bound5.PairLightPrepared24.leftCached, `D1Bound5.PairLightPrepared24.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
