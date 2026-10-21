import D1Bound5.SmallPairLightAdaptiveLeft48_000Part00
import D1Bound5.SmallPairLightAdaptiveLeft48_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft48_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft48_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft48_000Part04
import D1Bound5.SmallPairLightAdaptiveLeft48_000
import D1Bound5.SmallPairLightAdaptiveLeft48_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft48_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft48_001Part02
import D1Bound5.SmallPairLightAdaptiveLeft48_001
import D1Bound5.SmallPairLightLeft48
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_checked,
    `D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_checked,
    `D1Bound5.PairLightPrepared48.left_coverage_checked,
    `D1Bound5.PairLightPrepared48.left_signatures_checked,
    `D1Bound5.PairLightPrepared48.left_independent_checked,
    `D1Bound5.PairLightPrepared48.left_certificate_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH48_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightAdaptivePrepared48

example
:
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 28
      (leftCached000.drop 0) (leftRows000.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part00_checked
end D1Bound5.PairLightAdaptivePrepared48

namespace D1Bound5.PairLightAdaptivePrepared48

example
:
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 31
      (leftCached000.drop 28) (leftRows000.drop 28) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part01_checked
end D1Bound5.PairLightAdaptivePrepared48

namespace D1Bound5.PairLightAdaptivePrepared48

example
:
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 35
      (leftCached000.drop 59) (leftRows000.drop 59) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part02_checked
end D1Bound5.PairLightAdaptivePrepared48

namespace D1Bound5.PairLightAdaptivePrepared48

example
:
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 40
      (leftCached000.drop 94) (leftRows000.drop 94) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part03_checked
end D1Bound5.PairLightAdaptivePrepared48

namespace D1Bound5.PairLightAdaptivePrepared48

example
:
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 3
      (leftCached000.drop 134) (leftRows000.drop 134) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part04_checked
end D1Bound5.PairLightAdaptivePrepared48

namespace D1Bound5.PairLightAdaptivePrepared48

example
:
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 137
      leftCached000 leftRows000 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared48

namespace D1Bound5.PairLightAdaptivePrepared48

example
:
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 50
      (leftCached001.drop 0) (leftRows001.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_part00_checked
end D1Bound5.PairLightAdaptivePrepared48

namespace D1Bound5.PairLightAdaptivePrepared48

example
:
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 73
      (leftCached001.drop 50) (leftRows001.drop 50) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_part01_checked
end D1Bound5.PairLightAdaptivePrepared48

namespace D1Bound5.PairLightAdaptivePrepared48

example
:
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 100
      (leftCached001.drop 123) (leftRows001.drop 123) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_part02_checked
end D1Bound5.PairLightAdaptivePrepared48

namespace D1Bound5.PairLightAdaptivePrepared48

example
:
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 223
      leftCached001 leftRows001 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared48

namespace D1Bound5.PairLightPrepared48

example
:
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  _root_.D1Bound5.PairLightPrepared48.left_coverage_checked
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
:
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  _root_.D1Bound5.PairLightPrepared48.left_signatures_checked
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
:
    pairLightSelectedFloorIndependentBool 1 8 sieve leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared48.left_independent_checked
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
:
    pairLightSelectedFloorIndependentCertificateBool 1 8 sieve
      leftVertices leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared48.left_certificate_checked
end D1Bound5.PairLightPrepared48

#check @_root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_part04_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_000_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared48.left_prefix_001_checked
#check @_root_.D1Bound5.PairLightPrepared48.left_coverage_checked
#check @_root_.D1Bound5.PairLightPrepared48.left_signatures_checked
#check @_root_.D1Bound5.PairLightPrepared48.left_independent_checked
#check @_root_.D1Bound5.PairLightPrepared48.left_certificate_checked
