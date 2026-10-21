import D1Bound5.SmallPairLightData29Left
import D1Bound5.SmallPairLightData29Right
import D1Bound5.SmallPairLightData29
import D1Bound5.SmallPairLightAdaptiveData29
import D1Bound5.SmallPairLightAdaptiveValidation29
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightPrepared29.sieve,
    `D1Bound5.PairLightPrepared29.leftVertices,
    `D1Bound5.PairLightPrepared29.leftCached,
    `D1Bound5.PairLightPrepared29.leftRows,
    `D1Bound5.PairLightPrepared29.rightVertices,
    `D1Bound5.PairLightPrepared29.rightCached,
    `D1Bound5.PairLightPrepared29.rightRows,
    `D1Bound5.PairLightAdaptivePrepared29.leftCached000,
    `D1Bound5.PairLightAdaptivePrepared29.leftRows000,
    `D1Bound5.PairLightAdaptivePrepared29.leftCached001,
    `D1Bound5.PairLightAdaptivePrepared29.leftRows001,
    `D1Bound5.PairLightAdaptivePrepared29.leftCached002,
    `D1Bound5.PairLightAdaptivePrepared29.leftRows002,
    `D1Bound5.PairLightAdaptivePrepared29.rightCached000,
    `D1Bound5.PairLightAdaptivePrepared29.rightRows000,
    `D1Bound5.PairLightAdaptivePrepared29.rightCached001,
    `D1Bound5.PairLightAdaptivePrepared29.rightRows001,
    `D1Bound5.PairLightAdaptivePrepared29.rightCached002,
    `D1Bound5.PairLightAdaptivePrepared29.rightRows002,
    `D1Bound5.PairLightAdaptivePrepared29.left_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared29.left_signatures_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared29.right_signatures_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH29_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightPrepared29

example
: List (Nat × Nat) :=
  _root_.D1Bound5.PairLightPrepared29.sieve
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared29.leftVertices
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared29.leftCached
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared29.leftRows
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared29.rightVertices
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared29.rightCached
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared29.rightRows
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.leftCached000
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.leftRows000
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.leftCached001
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.leftRows001
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.leftCached002
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.leftRows002
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.rightCached000
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.rightRows000
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.rightCached001
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.rightRows001
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.rightCached002
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.rightRows002
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    decide (PairLightPrepared29.leftCached.map Prod.fst = PairLightPrepared29.leftVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    (PairLightPrepared29.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared29.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    decide (PairLightPrepared29.rightCached.map Prod.fst = PairLightPrepared29.rightVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared29

namespace D1Bound5.PairLightAdaptivePrepared29

example
:
    (PairLightPrepared29.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared29.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared29.right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared29

#check @_root_.D1Bound5.PairLightPrepared29.sieve
#check @_root_.D1Bound5.PairLightPrepared29.leftVertices
#check @_root_.D1Bound5.PairLightPrepared29.leftCached
#check @_root_.D1Bound5.PairLightPrepared29.leftRows
#check @_root_.D1Bound5.PairLightPrepared29.rightVertices
#check @_root_.D1Bound5.PairLightPrepared29.rightCached
#check @_root_.D1Bound5.PairLightPrepared29.rightRows
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.leftCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.leftRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.leftCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.leftRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.leftCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.leftRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.rightCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.rightRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.rightCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.rightRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.rightCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.rightRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.left_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.left_signatures_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared29.right_signatures_checked
