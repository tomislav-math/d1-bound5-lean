import D1Bound5.SmallPairLightAdaptiveRight35_000Part00
import D1Bound5.SmallPairLightAdaptiveRight35_000Part01
import D1Bound5.SmallPairLightAdaptiveRight35_000Part02
import D1Bound5.SmallPairLightAdaptiveRight35_000Part03
import D1Bound5.SmallPairLightAdaptiveRight35_000Part04
import D1Bound5.SmallPairLightAdaptiveRight35_000
import D1Bound5.SmallPairLightAdaptiveRight35_001Part00
import D1Bound5.SmallPairLightAdaptiveRight35_001Part01
import D1Bound5.SmallPairLightAdaptiveRight35_001Part02
import D1Bound5.SmallPairLightAdaptiveRight35_001
import D1Bound5.SmallPairLightRight35
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_checked,
    `D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_checked,
    `D1Bound5.PairLightPrepared35.right_coverage_checked,
    `D1Bound5.PairLightPrepared35.right_signatures_checked,
    `D1Bound5.PairLightPrepared35.right_independent_checked,
    `D1Bound5.PairLightPrepared35.right_certificate_checked]
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
      (rightCached000.drop 0) (rightRows000.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part00_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 30
      (rightCached000.drop 28) (rightRows000.drop 28) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part01_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 34
      (rightCached000.drop 58) (rightRows000.drop 58) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part02_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 39
      (rightCached000.drop 92) (rightRows000.drop 92) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part03_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 1
      (rightCached000.drop 131) (rightRows000.drop 131) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part04_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 132
      rightCached000 rightRows000 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 47
      (rightCached001.drop 0) (rightRows001.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_part00_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 63
      (rightCached001.drop 47) (rightRows001.drop 47) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_part01_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 126
      (rightCached001.drop 110) (rightRows001.drop 110) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_part02_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightAdaptivePrepared35

example
:
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 236
      rightCached001 rightRows001 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  _root_.D1Bound5.PairLightPrepared35.right_coverage_checked
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  _root_.D1Bound5.PairLightPrepared35.right_signatures_checked
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    pairLightSelectedFloorIndependentBool 1 2 sieve rightCached rightRows = true :=
  _root_.D1Bound5.PairLightPrepared35.right_independent_checked
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      rightVertices rightCached rightRows = true :=
  _root_.D1Bound5.PairLightPrepared35.right_certificate_checked
end D1Bound5.PairLightPrepared35

#check @_root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_part04_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_000_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared35.right_prefix_001_checked
#check @_root_.D1Bound5.PairLightPrepared35.right_coverage_checked
#check @_root_.D1Bound5.PairLightPrepared35.right_signatures_checked
#check @_root_.D1Bound5.PairLightPrepared35.right_independent_checked
#check @_root_.D1Bound5.PairLightPrepared35.right_certificate_checked
