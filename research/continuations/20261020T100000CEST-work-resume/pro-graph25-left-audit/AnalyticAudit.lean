import D1Bound5.SmallPairLightAdaptiveLeft25_000Part00
import D1Bound5.SmallPairLightAdaptiveLeft25_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft25_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft25_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft25_000Part04
import D1Bound5.SmallPairLightAdaptiveLeft25_000
import D1Bound5.SmallPairLightAdaptiveLeft25_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft25_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft25_001Part02
import D1Bound5.SmallPairLightAdaptiveLeft25_001Part03
import D1Bound5.SmallPairLightAdaptiveLeft25_001
import D1Bound5.SmallPairLightLeft25
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_checked,
    `D1Bound5.PairLightPrepared25.left_coverage_checked,
    `D1Bound5.PairLightPrepared25.left_signatures_checked,
    `D1Bound5.PairLightPrepared25.left_independent_checked,
    `D1Bound5.PairLightPrepared25.left_certificate_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH25_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 24
      (leftCached000.drop 0) (leftRows000.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part00_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 26
      (leftCached000.drop 24) (leftRows000.drop 24) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part01_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 28
      (leftCached000.drop 50) (leftRows000.drop 50) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part02_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 31
      (leftCached000.drop 78) (leftRows000.drop 78) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part03_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 17
      (leftCached000.drop 109) (leftRows000.drop 109) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part04_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 126
      leftCached000 leftRows000 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 38
      (leftCached001.drop 0) (leftRows001.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part00_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 46
      (leftCached001.drop 38) (leftRows001.drop 38) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part01_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 65
      (leftCached001.drop 84) (leftRows001.drop 84) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part02_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 105
      (leftCached001.drop 149) (leftRows001.drop 149) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part03_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 254
      leftCached001 leftRows001 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightPrepared25

example
:
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  _root_.D1Bound5.PairLightPrepared25.left_coverage_checked
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
:
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  _root_.D1Bound5.PairLightPrepared25.left_signatures_checked
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
:
    pairLightSelectedFloorIndependentBool 1 1 sieve leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared25.left_independent_checked
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
:
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      leftVertices leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared25.left_certificate_checked
end D1Bound5.PairLightPrepared25

#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_part04_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_000_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_prefix_001_checked
#check @_root_.D1Bound5.PairLightPrepared25.left_coverage_checked
#check @_root_.D1Bound5.PairLightPrepared25.left_signatures_checked
#check @_root_.D1Bound5.PairLightPrepared25.left_independent_checked
#check @_root_.D1Bound5.PairLightPrepared25.left_certificate_checked
