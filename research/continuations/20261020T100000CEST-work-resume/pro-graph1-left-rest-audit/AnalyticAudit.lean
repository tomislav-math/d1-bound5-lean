import D1Bound5.SmallPairLightAdaptiveLeft1_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft1_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft1_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft1_000Part04
import D1Bound5.SmallPairLightAdaptiveLeft1_000Part05
import D1Bound5.SmallPairLightAdaptiveLeft1_000
import D1Bound5.SmallPairLightAdaptiveLeft1_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft1_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft1_001Part02
import D1Bound5.SmallPairLightAdaptiveLeft1_001Part03
import D1Bound5.SmallPairLightAdaptiveLeft1_001
import D1Bound5.SmallPairLightLeft1
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part05_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_checked,
    `D1Bound5.PairLightPrepared1.left_coverage_checked,
    `D1Bound5.PairLightPrepared1.left_signatures_checked,
    `D1Bound5.PairLightPrepared1.left_independent_checked,
    `D1Bound5.PairLightPrepared1.left_certificate_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH1_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 20
      (leftCached000.drop 16) (leftRows000.drop 16) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part01_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 22
      (leftCached000.drop 36) (leftRows000.drop 36) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part02_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 24
      (leftCached000.drop 58) (leftRows000.drop 58) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part03_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 26
      (leftCached000.drop 82) (leftRows000.drop 82) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part04_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 29
      (leftCached000.drop 108) (leftRows000.drop 108) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part05_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 137
      leftCached000 leftRows000 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 34
      (leftCached001.drop 0) (leftRows001.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part00_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 42
      (leftCached001.drop 34) (leftRows001.drop 34) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part01_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 56
      (leftCached001.drop 76) (leftRows001.drop 76) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part02_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 91
      (leftCached001.drop 132) (leftRows001.drop 132) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part03_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 223
      leftCached001 leftRows001 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightPrepared1

example
:
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  _root_.D1Bound5.PairLightPrepared1.left_coverage_checked
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
:
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  _root_.D1Bound5.PairLightPrepared1.left_signatures_checked
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
:
    pairLightSelectedFloorIndependentBool 0 1 sieve leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared1.left_independent_checked
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
:
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      leftVertices leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared1.left_certificate_checked
end D1Bound5.PairLightPrepared1

#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part04_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_part05_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_000_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_prefix_001_checked
#check @_root_.D1Bound5.PairLightPrepared1.left_coverage_checked
#check @_root_.D1Bound5.PairLightPrepared1.left_signatures_checked
#check @_root_.D1Bound5.PairLightPrepared1.left_independent_checked
#check @_root_.D1Bound5.PairLightPrepared1.left_certificate_checked
