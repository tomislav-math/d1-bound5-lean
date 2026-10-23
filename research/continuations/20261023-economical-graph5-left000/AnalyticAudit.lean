import D1Bound5.SmallPairLightLeft5Prefix000
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared5
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.leftCached.drop 12) (PairLightPrepared5.leftRows.drop 12) = true := left_prefix_000_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.leftCached.drop 24) (PairLightPrepared5.leftRows.drop 24) = true := left_prefix_000_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.leftCached.drop 36) (PairLightPrepared5.leftRows.drop 36) = true := left_prefix_000_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.leftCached.drop 48) (PairLightPrepared5.leftRows.drop 48) = true := left_prefix_000_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.leftCached.drop 60) (PairLightPrepared5.leftRows.drop 60) = true := left_prefix_000_part05_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.leftCached.drop 72) (PairLightPrepared5.leftRows.drop 72) = true := left_prefix_000_part06_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
  (PairLightPrepared5.leftCached.drop 84) (PairLightPrepared5.leftRows.drop 84) = true := left_prefix_000_part07_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 9
  (PairLightPrepared5.leftCached.drop 96) (PairLightPrepared5.leftRows.drop 96) = true := left_prefix_000_part08_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 105
  (PairLightPrepared5.leftCached.drop 0) (PairLightPrepared5.leftRows.drop 0) = true := left_prefix_000_direct_checked
end D1Bound5.PairLightAdaptivePrepared5
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared5.left_prefix_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_000_part08_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_000_direct_checked, `D1Bound5.PairLightPrepared5.sieve, `D1Bound5.PairLightPrepared5.leftVertices, `D1Bound5.PairLightPrepared5.leftCached, `D1Bound5.PairLightPrepared5.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
