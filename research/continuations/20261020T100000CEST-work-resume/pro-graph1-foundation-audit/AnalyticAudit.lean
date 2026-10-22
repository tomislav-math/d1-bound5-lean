import D1Bound5.SmallPairLightData1Left
import D1Bound5.SmallPairLightData1LeftRows
import D1Bound5.SmallPairLightData1Right
import D1Bound5.SmallPairLightData1RightRows
import D1Bound5.SmallPairLightData1
import D1Bound5.SmallPairLightAdaptiveData1
import D1Bound5.SmallPairLightAdaptiveValidation1
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightPrepared1.sieve,
    `D1Bound5.PairLightPrepared1.leftVertices,
    `D1Bound5.PairLightPrepared1.leftCached,
    `D1Bound5.PairLightPrepared1.leftRows,
    `D1Bound5.PairLightPrepared1.rightVertices,
    `D1Bound5.PairLightPrepared1.rightCached,
    `D1Bound5.PairLightPrepared1.rightRows,
    `D1Bound5.PairLightAdaptivePrepared1.leftCached000,
    `D1Bound5.PairLightAdaptivePrepared1.leftRows000,
    `D1Bound5.PairLightAdaptivePrepared1.leftCached001,
    `D1Bound5.PairLightAdaptivePrepared1.leftRows001,
    `D1Bound5.PairLightAdaptivePrepared1.leftCached002,
    `D1Bound5.PairLightAdaptivePrepared1.leftRows002,
    `D1Bound5.PairLightAdaptivePrepared1.rightCached000,
    `D1Bound5.PairLightAdaptivePrepared1.rightRows000,
    `D1Bound5.PairLightAdaptivePrepared1.rightCached001,
    `D1Bound5.PairLightAdaptivePrepared1.rightRows001,
    `D1Bound5.PairLightAdaptivePrepared1.rightCached002,
    `D1Bound5.PairLightAdaptivePrepared1.rightRows002,
    `D1Bound5.PairLightAdaptivePrepared1.left_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared1.left_signatures_checked,
    `D1Bound5.PairLightAdaptivePrepared1.right_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared1.right_signatures_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH1_FOUNDATION_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightPrepared1

example
: List (Nat × Nat) :=
  _root_.D1Bound5.PairLightPrepared1.sieve
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared1.leftVertices
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared1.leftCached
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared1.leftRows
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared1.rightVertices
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared1.rightCached
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared1.rightRows
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.leftCached000
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.leftRows000
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.leftCached001
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.leftRows001
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.leftCached002
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.leftRows002
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.rightCached000
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.rightRows000
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.rightCached001
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.rightRows001
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.rightCached002
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.rightRows002
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    decide (PairLightPrepared1.leftCached.map Prod.fst = PairLightPrepared1.leftVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    (PairLightPrepared1.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared1.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    decide (PairLightPrepared1.rightCached.map Prod.fst = PairLightPrepared1.rightVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared1

namespace D1Bound5.PairLightAdaptivePrepared1

example
:
    (PairLightPrepared1.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared1.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared1.right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared1

#check @_root_.D1Bound5.PairLightPrepared1.sieve
#check @_root_.D1Bound5.PairLightPrepared1.leftVertices
#check @_root_.D1Bound5.PairLightPrepared1.leftCached
#check @_root_.D1Bound5.PairLightPrepared1.leftRows
#check @_root_.D1Bound5.PairLightPrepared1.rightVertices
#check @_root_.D1Bound5.PairLightPrepared1.rightCached
#check @_root_.D1Bound5.PairLightPrepared1.rightRows
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.leftCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.leftRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.leftCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.leftRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.leftCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.leftRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.rightCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.rightRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.rightCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.rightRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.rightCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.rightRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.left_signatures_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.right_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared1.right_signatures_checked
