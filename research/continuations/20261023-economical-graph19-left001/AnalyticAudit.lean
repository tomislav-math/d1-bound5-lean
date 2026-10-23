import D1Bound5.SmallPairLightLeft19Prefix001
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared19
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 24
  (PairLightPrepared19.leftCached.drop 101) (PairLightPrepared19.leftRows.drop 101) = true := left_prefix_001_part00_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 24
  (PairLightPrepared19.leftCached.drop 125) (PairLightPrepared19.leftRows.drop 125) = true := left_prefix_001_part01_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 24
  (PairLightPrepared19.leftCached.drop 149) (PairLightPrepared19.leftRows.drop 149) = true := left_prefix_001_part02_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 24
  (PairLightPrepared19.leftCached.drop 173) (PairLightPrepared19.leftRows.drop 173) = true := left_prefix_001_part03_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 24
  (PairLightPrepared19.leftCached.drop 197) (PairLightPrepared19.leftRows.drop 197) = true := left_prefix_001_part04_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 24
  (PairLightPrepared19.leftCached.drop 221) (PairLightPrepared19.leftRows.drop 221) = true := left_prefix_001_part05_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 3
  (PairLightPrepared19.leftCached.drop 245) (PairLightPrepared19.leftRows.drop 245) = true := left_prefix_001_part06_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 147
  (PairLightPrepared19.leftCached.drop 101) (PairLightPrepared19.leftRows.drop 101) = true := left_prefix_001_direct_checked
end D1Bound5.PairLightAdaptivePrepared19
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared19.left_prefix_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared19.left_prefix_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared19.left_prefix_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared19.left_prefix_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared19.left_prefix_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared19.left_prefix_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared19.left_prefix_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared19.left_prefix_001_direct_checked, `D1Bound5.PairLightPrepared19.sieve, `D1Bound5.PairLightPrepared19.leftVertices, `D1Bound5.PairLightPrepared19.leftCached, `D1Bound5.PairLightPrepared19.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
