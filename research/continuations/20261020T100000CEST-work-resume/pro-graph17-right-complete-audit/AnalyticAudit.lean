import D1Bound5.SmallPairLightRight17
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_checked,
    `D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_checked,
    `D1Bound5.PairLightPrepared17.right_coverage_checked,
    `D1Bound5.PairLightPrepared17.right_signatures_checked,
    `D1Bound5.PairLightPrepared17.right_independent_checked,
    `D1Bound5.PairLightPrepared17.right_certificate_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH17_RIGHT_COMPLETE_AXIOMS_PASS {name}: {ax}"
namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 29
      (rightCached000.drop 0) (rightRows000.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part00_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 32
      (rightCached000.drop 29) (rightRows000.drop 29) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part01_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 35
      (rightCached000.drop 61) (rightRows000.drop 61) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part02_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 41
      (rightCached000.drop 96) (rightRows000.drop 96) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part03_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 1
      (rightCached000.drop 137) (rightRows000.drop 137) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part04_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 138
      rightCached000 rightRows000 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 51
      (rightCached001.drop 0) (rightRows001.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_part00_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 76
      (rightCached001.drop 51) (rightRows001.drop 51) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_part01_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 93
      (rightCached001.drop 127) (rightRows001.drop 127) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_part02_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 220
      rightCached001 rightRows001 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_checked

end D1Bound5.PairLightAdaptivePrepared17

namespace D1Bound5.PairLightPrepared17

example
:
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  _root_.D1Bound5.PairLightPrepared17.right_coverage_checked

example
:
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  _root_.D1Bound5.PairLightPrepared17.right_signatures_checked

example
:
    pairLightSelectedFloorIndependentBool 0 2 sieve rightCached rightRows = true :=
  _root_.D1Bound5.PairLightPrepared17.right_independent_checked

example
:
    pairLightSelectedFloorIndependentCertificateBool 0 2 sieve
      rightVertices rightCached rightRows = true :=
  _root_.D1Bound5.PairLightPrepared17.right_certificate_checked

end D1Bound5.PairLightPrepared17

#check @_root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_part04_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_000_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.right_prefix_001_checked
#check @_root_.D1Bound5.PairLightPrepared17.right_coverage_checked
#check @_root_.D1Bound5.PairLightPrepared17.right_signatures_checked
#check @_root_.D1Bound5.PairLightPrepared17.right_independent_checked
#check @_root_.D1Bound5.PairLightPrepared17.right_certificate_checked
