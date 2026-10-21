import D1Bound5.SmallPairLightAdaptiveLeft12_000Part00
import D1Bound5.SmallPairLightAdaptiveLeft12_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft12_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft12_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft12_000Part04
import D1Bound5.SmallPairLightAdaptiveLeft12_000
import D1Bound5.SmallPairLightAdaptiveLeft12_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft12_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft12_001Part02
import D1Bound5.SmallPairLightAdaptiveLeft12_001
import D1Bound5.SmallPairLightLeft12
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_checked,
    `D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_checked,
    `D1Bound5.PairLightPrepared12.left_coverage_checked,
    `D1Bound5.PairLightPrepared12.left_signatures_checked,
    `D1Bound5.PairLightPrepared12.left_independent_checked,
    `D1Bound5.PairLightPrepared12.left_certificate_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH12_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 29
      (leftCached000.drop 0) (leftRows000.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part00_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 31
      (leftCached000.drop 29) (leftRows000.drop 29) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part01_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 35
      (leftCached000.drop 60) (leftRows000.drop 60) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part02_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 41
      (leftCached000.drop 95) (leftRows000.drop 95) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part03_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 2
      (leftCached000.drop 136) (leftRows000.drop 136) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part04_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 138
      leftCached000 leftRows000 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 51
      (leftCached001.drop 0) (leftRows001.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_part00_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 76
      (leftCached001.drop 51) (leftRows001.drop 51) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_part01_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 94
      (leftCached001.drop 127) (leftRows001.drop 127) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_part02_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 221
      leftCached001 leftRows001 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightPrepared12

example
:
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  _root_.D1Bound5.PairLightPrepared12.left_coverage_checked
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
:
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  _root_.D1Bound5.PairLightPrepared12.left_signatures_checked
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
:
    pairLightSelectedFloorIndependentBool 0 1 sieve leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared12.left_independent_checked
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
:
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      leftVertices leftCached leftRows = true :=
  _root_.D1Bound5.PairLightPrepared12.left_certificate_checked
end D1Bound5.PairLightPrepared12

#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_part04_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_000_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_prefix_001_checked
#check @_root_.D1Bound5.PairLightPrepared12.left_coverage_checked
#check @_root_.D1Bound5.PairLightPrepared12.left_signatures_checked
#check @_root_.D1Bound5.PairLightPrepared12.left_independent_checked
#check @_root_.D1Bound5.PairLightPrepared12.left_certificate_checked
