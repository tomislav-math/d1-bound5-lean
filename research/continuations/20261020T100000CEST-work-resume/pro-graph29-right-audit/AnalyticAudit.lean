import D1Bound5.SmallPairLightAdaptiveRight29_000Part00
import D1Bound5.SmallPairLightAdaptiveRight29_000Part01
import D1Bound5.SmallPairLightAdaptiveRight29_000Part02
import D1Bound5.SmallPairLightAdaptiveRight29_000Part03
import D1Bound5.SmallPairLightAdaptiveRight29_000Part04
import D1Bound5.SmallPairLightAdaptiveRight29_000
import D1Bound5.SmallPairLightAdaptiveRight29_001Part00
import D1Bound5.SmallPairLightAdaptiveRight29_001Part01
import D1Bound5.SmallPairLightAdaptiveRight29_001Part02
import D1Bound5.SmallPairLightAdaptiveRight29_001Part03
import D1Bound5.SmallPairLightAdaptiveRight29_001
import D1Bound5.SmallPairLightRight29
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_checked,
    `D1Bound5.PairLightPrepared29.right_coverage_checked,
    `D1Bound5.PairLightPrepared29.right_signatures_checked,
    `D1Bound5.PairLightPrepared29.right_independent_checked,
    `D1Bound5.PairLightPrepared29.right_certificate_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH29_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 24
      (rightCached000.drop 0) (rightRows000.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part00_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 26
      (rightCached000.drop 24) (rightRows000.drop 24) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part01_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 28
      (rightCached000.drop 50) (rightRows000.drop 50) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part02_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 31
      (rightCached000.drop 78) (rightRows000.drop 78) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part03_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 16
      (rightCached000.drop 109) (rightRows000.drop 109) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part04_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 125
      rightCached000 rightRows000 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 38
      (rightCached001.drop 0) (rightRows001.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part00_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 46
      (rightCached001.drop 38) (rightRows001.drop 38) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part01_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 64
      (rightCached001.drop 84) (rightRows001.drop 84) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part02_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 108
      (rightCached001.drop 148) (rightRows001.drop 148) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part03_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 256
      rightCached001 rightRows001 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightPrepared29

example
:
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  _root_.D1Bound5.PairLightPrepared29.right_coverage_checked
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
:
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  _root_.D1Bound5.PairLightPrepared29.right_signatures_checked
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
:
    pairLightSelectedFloorIndependentBool 1 1 sieve rightCached rightRows = true :=
  _root_.D1Bound5.PairLightPrepared29.right_independent_checked
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
:
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      rightVertices rightCached rightRows = true :=
  _root_.D1Bound5.PairLightPrepared29.right_certificate_checked
end D1Bound5.PairLightPrepared29

#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_part04_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_000_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_prefix_001_checked
#check @_root_.D1Bound5.PairLightPrepared29.right_coverage_checked
#check @_root_.D1Bound5.PairLightPrepared29.right_signatures_checked
#check @_root_.D1Bound5.PairLightPrepared29.right_independent_checked
#check @_root_.D1Bound5.PairLightPrepared29.right_certificate_checked
