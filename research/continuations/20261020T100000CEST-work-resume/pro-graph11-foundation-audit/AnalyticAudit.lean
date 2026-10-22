import D1Bound5.SmallPairLightData11Left
import D1Bound5.SmallPairLightData11LeftRows
import D1Bound5.SmallPairLightData11Right
import D1Bound5.SmallPairLightData11RightRows
import D1Bound5.SmallPairLightData11
import D1Bound5.SmallPairLightAdaptiveData11
import D1Bound5.SmallPairLightAdaptiveValidation11
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightPrepared11.sieve,
    `D1Bound5.PairLightPrepared11.leftVertices,
    `D1Bound5.PairLightPrepared11.leftCached,
    `D1Bound5.PairLightPrepared11.leftRows,
    `D1Bound5.PairLightPrepared11.rightVertices,
    `D1Bound5.PairLightPrepared11.rightCached,
    `D1Bound5.PairLightPrepared11.rightRows,
    `D1Bound5.PairLightAdaptivePrepared11.leftCached000,
    `D1Bound5.PairLightAdaptivePrepared11.leftRows000,
    `D1Bound5.PairLightAdaptivePrepared11.leftCached001,
    `D1Bound5.PairLightAdaptivePrepared11.leftRows001,
    `D1Bound5.PairLightAdaptivePrepared11.leftCached002,
    `D1Bound5.PairLightAdaptivePrepared11.leftRows002,
    `D1Bound5.PairLightAdaptivePrepared11.rightCached000,
    `D1Bound5.PairLightAdaptivePrepared11.rightRows000,
    `D1Bound5.PairLightAdaptivePrepared11.rightCached001,
    `D1Bound5.PairLightAdaptivePrepared11.rightRows001,
    `D1Bound5.PairLightAdaptivePrepared11.rightCached002,
    `D1Bound5.PairLightAdaptivePrepared11.rightRows002,
    `D1Bound5.PairLightAdaptivePrepared11.left_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared11.left_signatures_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_signatures_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH11_FOUNDATION_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightPrepared11

example
: List (Nat × Nat) :=
  _root_.D1Bound5.PairLightPrepared11.sieve
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared11.leftVertices
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared11.leftCached
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared11.leftRows
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared11.rightVertices
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared11.rightCached
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared11.rightRows
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.leftCached000
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.leftRows000
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.leftCached001
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.leftRows001
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.leftCached002
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.leftRows002
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.rightCached000
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.rightRows000
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.rightCached001
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.rightRows001
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.rightCached002
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.rightRows002
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    decide (PairLightPrepared11.leftCached.map Prod.fst = PairLightPrepared11.leftVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    (PairLightPrepared11.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared11.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    decide (PairLightPrepared11.rightCached.map Prod.fst = PairLightPrepared11.rightVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    (PairLightPrepared11.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared11.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared11

#check @_root_.D1Bound5.PairLightPrepared11.sieve
#check @_root_.D1Bound5.PairLightPrepared11.leftVertices
#check @_root_.D1Bound5.PairLightPrepared11.leftCached
#check @_root_.D1Bound5.PairLightPrepared11.leftRows
#check @_root_.D1Bound5.PairLightPrepared11.rightVertices
#check @_root_.D1Bound5.PairLightPrepared11.rightCached
#check @_root_.D1Bound5.PairLightPrepared11.rightRows
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.leftCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.leftRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.leftCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.leftRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.leftCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.leftRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.rightCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.rightRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.rightCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.rightRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.rightCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.rightRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.left_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.left_signatures_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_signatures_checked
