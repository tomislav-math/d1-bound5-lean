import D1Bound5.SmallPairLightRight7Prefix001
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared7
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.rightCached.drop 106) (PairLightPrepared7.rightRows.drop 106) = true := right_prefix_001_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.rightCached.drop 130) (PairLightPrepared7.rightRows.drop 130) = true := right_prefix_001_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.rightCached.drop 154) (PairLightPrepared7.rightRows.drop 154) = true := right_prefix_001_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.rightCached.drop 178) (PairLightPrepared7.rightRows.drop 178) = true := right_prefix_001_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.rightCached.drop 202) (PairLightPrepared7.rightRows.drop 202) = true := right_prefix_001_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
  (PairLightPrepared7.rightCached.drop 226) (PairLightPrepared7.rightRows.drop 226) = true := right_prefix_001_part05_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 22
  (PairLightPrepared7.rightCached.drop 250) (PairLightPrepared7.rightRows.drop 250) = true := right_prefix_001_part06_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 166
  (PairLightPrepared7.rightCached.drop 106) (PairLightPrepared7.rightRows.drop 106) = true := right_prefix_001_direct_checked
end D1Bound5.PairLightAdaptivePrepared7
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared7.right_prefix_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared7.right_prefix_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared7.right_prefix_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared7.right_prefix_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared7.right_prefix_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared7.right_prefix_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared7.right_prefix_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared7.right_prefix_001_direct_checked, `D1Bound5.PairLightPrepared7.sieve, `D1Bound5.PairLightPrepared7.rightVertices, `D1Bound5.PairLightPrepared7.rightCached, `D1Bound5.PairLightPrepared7.rightRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
