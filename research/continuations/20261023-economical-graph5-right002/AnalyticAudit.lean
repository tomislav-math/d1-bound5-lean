import D1Bound5.SmallPairLightRight5Prefix002
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared5
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.rightCached.drop 272) (PairLightPrepared5.rightRows.drop 272) = true := right_prefix_002_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.rightCached.drop 296) (PairLightPrepared5.rightRows.drop 296) = true := right_prefix_002_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.rightCached.drop 320) (PairLightPrepared5.rightRows.drop 320) = true := right_prefix_002_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.rightCached.drop 344) (PairLightPrepared5.rightRows.drop 344) = true := right_prefix_002_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.rightCached.drop 368) (PairLightPrepared5.rightRows.drop 368) = true := right_prefix_002_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.rightCached.drop 392) (PairLightPrepared5.rightRows.drop 392) = true := right_prefix_002_part05_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 14
  (PairLightPrepared5.rightCached.drop 416) (PairLightPrepared5.rightRows.drop 416) = true := right_prefix_002_part06_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 158
  (PairLightPrepared5.rightCached.drop 272) (PairLightPrepared5.rightRows.drop 272) = true := right_prefix_002_direct_checked
end D1Bound5.PairLightAdaptivePrepared5
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared5.right_prefix_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared5.right_prefix_002_direct_checked, `D1Bound5.PairLightPrepared5.sieve, `D1Bound5.PairLightPrepared5.rightVertices, `D1Bound5.PairLightPrepared5.rightCached, `D1Bound5.PairLightPrepared5.rightRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
