import D1Bound5.SmallPairLightLeft17
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_checked,
    `D1Bound5.PairLightPrepared17.left_coverage_checked,
    `D1Bound5.PairLightPrepared17.left_signatures_checked,
    `D1Bound5.PairLightPrepared17.left_independent_checked,
    `D1Bound5.PairLightPrepared17.left_certificate_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH17_LEFT_COMPLETE_AXIOMS_PASS {name}: {ax}"
namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 50
      (leftCached001.drop 0) (leftRows001.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_part00_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 73
      (leftCached001.drop 50) (leftRows001.drop 50) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_part01_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 100
      (leftCached001.drop 123) (leftRows001.drop 123) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_part02_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 223
      leftCached001 leftRows001 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightPrepared17

example
:
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  _root_.D1Bound5.PairLightPrepared17.left_coverage_checked

example
:
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  _root_.D1Bound5.PairLightPrepared17.left_signatures_checked

example
:
    pairLightSelectedFloorIndependentBool 0 2 sieve leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared17.left_independent_checked

example
:
    pairLightSelectedFloorIndependentCertificateBool 0 2 sieve
      leftVertices leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared17.left_certificate_checked

end D1Bound5.PairLightPrepared17

#check @_root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_001_checked
#check @_root_.D1Bound5.PairLightPrepared17.left_coverage_checked
#check @_root_.D1Bound5.PairLightPrepared17.left_signatures_checked
#check @_root_.D1Bound5.PairLightPrepared17.left_independent_checked
#check @_root_.D1Bound5.PairLightPrepared17.left_certificate_checked
