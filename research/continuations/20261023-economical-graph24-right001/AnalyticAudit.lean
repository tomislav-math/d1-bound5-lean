import D1Bound5.SmallPairLightRight24Prefix001
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared24
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.rightCached.drop 101) (PairLightPrepared24.rightRows.drop 101) = true := right_prefix_001_part00_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.rightCached.drop 125) (PairLightPrepared24.rightRows.drop 125) = true := right_prefix_001_part01_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.rightCached.drop 149) (PairLightPrepared24.rightRows.drop 149) = true := right_prefix_001_part02_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.rightCached.drop 173) (PairLightPrepared24.rightRows.drop 173) = true := right_prefix_001_part03_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.rightCached.drop 197) (PairLightPrepared24.rightRows.drop 197) = true := right_prefix_001_part04_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
  (PairLightPrepared24.rightCached.drop 221) (PairLightPrepared24.rightRows.drop 221) = true := right_prefix_001_part05_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 3
  (PairLightPrepared24.rightCached.drop 245) (PairLightPrepared24.rightRows.drop 245) = true := right_prefix_001_part06_checked
example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 147
  (PairLightPrepared24.rightCached.drop 101) (PairLightPrepared24.rightRows.drop 101) = true := right_prefix_001_direct_checked
end D1Bound5.PairLightAdaptivePrepared24
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared24.right_prefix_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared24.right_prefix_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared24.right_prefix_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared24.right_prefix_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared24.right_prefix_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared24.right_prefix_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared24.right_prefix_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared24.right_prefix_001_direct_checked, `D1Bound5.PairLightPrepared24.sieve, `D1Bound5.PairLightPrepared24.rightVertices, `D1Bound5.PairLightPrepared24.rightCached, `D1Bound5.PairLightPrepared24.rightRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
