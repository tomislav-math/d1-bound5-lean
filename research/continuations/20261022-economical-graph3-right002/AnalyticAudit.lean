import D1Bound5.SmallPairLightRight3Prefix002
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared3
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 306) (PairLightPrepared3.rightRows.drop 306) = true := right_prefix_002_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 330) (PairLightPrepared3.rightRows.drop 330) = true := right_prefix_002_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 354) (PairLightPrepared3.rightRows.drop 354) = true := right_prefix_002_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.rightCached.drop 378) (PairLightPrepared3.rightRows.drop 378) = true := right_prefix_002_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 12
  (PairLightPrepared3.rightCached.drop 402) (PairLightPrepared3.rightRows.drop 402) = true := right_prefix_002_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 108
  (PairLightPrepared3.rightCached.drop 306) (PairLightPrepared3.rightRows.drop 306) = true := right_prefix_002_direct_checked
end D1Bound5.PairLightAdaptivePrepared3
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared3.right_prefix_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared3.right_prefix_002_direct_checked, `D1Bound5.PairLightPrepared3.sieve, `D1Bound5.PairLightPrepared3.rightVertices, `D1Bound5.PairLightPrepared3.rightCached, `D1Bound5.PairLightPrepared3.rightRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
