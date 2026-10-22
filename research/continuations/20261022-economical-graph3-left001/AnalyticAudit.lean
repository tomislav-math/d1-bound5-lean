import D1Bound5.SmallPairLightLeft3Prefix001
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared3
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 112) (PairLightPrepared3.leftRows.drop 112) = true := left_prefix_001_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 136) (PairLightPrepared3.leftRows.drop 136) = true := left_prefix_001_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 160) (PairLightPrepared3.leftRows.drop 160) = true := left_prefix_001_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 184) (PairLightPrepared3.leftRows.drop 184) = true := left_prefix_001_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 208) (PairLightPrepared3.leftRows.drop 208) = true := left_prefix_001_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 232) (PairLightPrepared3.leftRows.drop 232) = true := left_prefix_001_part05_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 256) (PairLightPrepared3.leftRows.drop 256) = true := left_prefix_001_part06_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
  (PairLightPrepared3.leftCached.drop 280) (PairLightPrepared3.leftRows.drop 280) = true := left_prefix_001_part07_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 7
  (PairLightPrepared3.leftCached.drop 304) (PairLightPrepared3.leftRows.drop 304) = true := left_prefix_001_part08_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 199
  (PairLightPrepared3.leftCached.drop 112) (PairLightPrepared3.leftRows.drop 112) = true := left_prefix_001_direct_checked
end D1Bound5.PairLightAdaptivePrepared3
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared3.left_prefix_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared3.left_prefix_001_direct_checked, `D1Bound5.PairLightPrepared3.sieve, `D1Bound5.PairLightPrepared3.leftVertices, `D1Bound5.PairLightPrepared3.leftCached, `D1Bound5.PairLightPrepared3.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
