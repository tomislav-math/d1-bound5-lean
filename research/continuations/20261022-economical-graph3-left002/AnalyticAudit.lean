import D1Bound5.SmallPairLightLeft3Prefix002
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared3
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 311) (PairLightPrepared3.leftRows.drop 311) = true := left_prefix_002_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 335) (PairLightPrepared3.leftRows.drop 335) = true := left_prefix_002_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 359) (PairLightPrepared3.leftRows.drop 359) = true := left_prefix_002_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 383) (PairLightPrepared3.leftRows.drop 383) = true := left_prefix_002_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 6
  (PairLightPrepared3.leftCached.drop 407) (PairLightPrepared3.leftRows.drop 407) = true := left_prefix_002_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 102
  (PairLightPrepared3.leftCached.drop 311) (PairLightPrepared3.leftRows.drop 311) = true := left_prefix_002_direct_checked
end D1Bound5.PairLightAdaptivePrepared3
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared3.left_prefix_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_002_direct_checked, `D1Bound5.PairLightPrepared3.sieve, `D1Bound5.PairLightPrepared3.leftVertices, `D1Bound5.PairLightPrepared3.leftCached, `D1Bound5.PairLightPrepared3.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
