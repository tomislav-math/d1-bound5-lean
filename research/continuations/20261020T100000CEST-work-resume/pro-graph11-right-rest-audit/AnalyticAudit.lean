import D1Bound5.SmallPairLightAdaptiveRight11_000Part01
import D1Bound5.SmallPairLightAdaptiveRight11_000Part02
import D1Bound5.SmallPairLightAdaptiveRight11_000Part03
import D1Bound5.SmallPairLightAdaptiveRight11_000Part04
import D1Bound5.SmallPairLightAdaptiveRight11_000Part05
import D1Bound5.SmallPairLightAdaptiveRight11_000
import D1Bound5.SmallPairLightAdaptiveRight11_001Part00
import D1Bound5.SmallPairLightAdaptiveRight11_001Part01
import D1Bound5.SmallPairLightAdaptiveRight11_001Part02
import D1Bound5.SmallPairLightAdaptiveRight11_001Part03
import D1Bound5.SmallPairLightAdaptiveRight11_001
import D1Bound5.SmallPairLightRight11
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part05_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_checked,
    `D1Bound5.PairLightPrepared11.right_coverage_checked,
    `D1Bound5.PairLightPrepared11.right_signatures_checked,
    `D1Bound5.PairLightPrepared11.right_independent_checked,
    `D1Bound5.PairLightPrepared11.right_certificate_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH11_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 20
      (rightCached000.drop 16) (rightRows000.drop 16) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part01_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 22
      (rightCached000.drop 36) (rightRows000.drop 36) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part02_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 24
      (rightCached000.drop 58) (rightRows000.drop 58) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part03_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 26
      (rightCached000.drop 82) (rightRows000.drop 82) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part04_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 30
      (rightCached000.drop 108) (rightRows000.drop 108) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part05_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 138
      rightCached000 rightRows000 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 34
      (rightCached001.drop 0) (rightRows001.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part00_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 42
      (rightCached001.drop 34) (rightRows001.drop 34) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part01_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 56
      (rightCached001.drop 76) (rightRows001.drop 76) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part02_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 89
      (rightCached001.drop 132) (rightRows001.drop 132) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part03_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 221
      rightCached001 rightRows001 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightPrepared11

example
:
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  _root_.D1Bound5.PairLightPrepared11.right_coverage_checked
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
:
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  _root_.D1Bound5.PairLightPrepared11.right_signatures_checked
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
:
    pairLightSelectedFloorIndependentBool 0 1 sieve rightCached rightRows = true :=
  _root_.D1Bound5.PairLightPrepared11.right_independent_checked
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
:
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      rightVertices rightCached rightRows = true :=
  _root_.D1Bound5.PairLightPrepared11.right_certificate_checked
end D1Bound5.PairLightPrepared11

#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part04_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part05_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_001_checked
#check @_root_.D1Bound5.PairLightPrepared11.right_coverage_checked
#check @_root_.D1Bound5.PairLightPrepared11.right_signatures_checked
#check @_root_.D1Bound5.PairLightPrepared11.right_independent_checked
#check @_root_.D1Bound5.PairLightPrepared11.right_certificate_checked
