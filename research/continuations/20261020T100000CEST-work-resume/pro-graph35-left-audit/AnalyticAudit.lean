import D1Bound5.SmallPairLightAdaptiveLeft35_000Part00
import D1Bound5.SmallPairLightAdaptiveLeft35_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft35_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft35_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft35_000Part04
import D1Bound5.SmallPairLightAdaptiveLeft35_000
import D1Bound5.SmallPairLightAdaptiveLeft35_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft35_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft35_001Part02
import D1Bound5.SmallPairLightAdaptiveLeft35_001
import D1Bound5.SmallPairLightLeft35
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_checked,
    `D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_checked,
    `D1Bound5.PairLightPrepared35.left_coverage_checked,
    `D1Bound5.PairLightPrepared35.left_signatures_checked,
    `D1Bound5.PairLightPrepared35.left_independent_checked,
    `D1Bound5.PairLightPrepared35.left_certificate_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH35_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 28
      (leftCached000.drop 0) (leftRows000.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part00_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 30
      (leftCached000.drop 28) (leftRows000.drop 28) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part01_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 34
      (leftCached000.drop 58) (leftRows000.drop 58) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part02_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 38
      (leftCached000.drop 92) (leftRows000.drop 92) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part03_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 2
      (leftCached000.drop 130) (leftRows000.drop 130) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part04_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 132
      leftCached000 leftRows000 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 46
      (leftCached001.drop 0) (leftRows001.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_part00_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 62
      (leftCached001.drop 46) (leftRows001.drop 46) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_part01_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 129
      (leftCached001.drop 108) (leftRows001.drop 108) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_part02_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 237
      leftCached001 leftRows001 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  _root_.D1Bound5.PairLightPrepared35.left_coverage_checked
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  _root_.D1Bound5.PairLightPrepared35.left_signatures_checked
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    pairLightSelectedFloorIndependentBool 1 2 sieve leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared35.left_independent_checked
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      leftVertices leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared35.left_certificate_checked
end D1Bound5.PairLightPrepared35

#check @_root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_part04_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_000_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.left_prefix_001_checked
#check @_root_.D1Bound5.PairLightPrepared35.left_coverage_checked
#check @_root_.D1Bound5.PairLightPrepared35.left_signatures_checked
#check @_root_.D1Bound5.PairLightPrepared35.left_independent_checked
#check @_root_.D1Bound5.PairLightPrepared35.left_certificate_checked
