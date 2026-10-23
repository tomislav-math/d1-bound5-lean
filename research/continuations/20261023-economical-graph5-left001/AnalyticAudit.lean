import D1Bound5.SmallPairLightLeft5Prefix001
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared5
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 105) (PairLightPrepared5.leftRows.drop 105) = true := left_prefix_001_part00_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 129) (PairLightPrepared5.leftRows.drop 129) = true := left_prefix_001_part01_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 153) (PairLightPrepared5.leftRows.drop 153) = true := left_prefix_001_part02_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 177) (PairLightPrepared5.leftRows.drop 177) = true := left_prefix_001_part03_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 201) (PairLightPrepared5.leftRows.drop 201) = true := left_prefix_001_part04_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
  (PairLightPrepared5.leftCached.drop 225) (PairLightPrepared5.leftRows.drop 225) = true := left_prefix_001_part05_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 20
  (PairLightPrepared5.leftCached.drop 249) (PairLightPrepared5.leftRows.drop 249) = true := left_prefix_001_part06_checked
example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 164
  (PairLightPrepared5.leftCached.drop 105) (PairLightPrepared5.leftRows.drop 105) = true := left_prefix_001_direct_checked
end D1Bound5.PairLightAdaptivePrepared5
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared5.left_prefix_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared5.left_prefix_001_direct_checked, `D1Bound5.PairLightPrepared5.sieve, `D1Bound5.PairLightPrepared5.leftVertices, `D1Bound5.PairLightPrepared5.leftCached, `D1Bound5.PairLightPrepared5.leftRows] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
