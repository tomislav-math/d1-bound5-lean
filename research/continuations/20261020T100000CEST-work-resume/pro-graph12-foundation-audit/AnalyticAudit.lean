import D1Bound5.SmallPairLightData12
import D1Bound5.SmallPairLightAdaptiveData12
import D1Bound5.SmallPairLightAdaptiveValidation12
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightPrepared12.sieve,
    `D1Bound5.PairLightPrepared12.leftVertices,
    `D1Bound5.PairLightPrepared12.leftCached,
    `D1Bound5.PairLightPrepared12.leftRows,
    `D1Bound5.PairLightPrepared12.rightVertices,
    `D1Bound5.PairLightPrepared12.rightCached,
    `D1Bound5.PairLightPrepared12.rightRows,
    `D1Bound5.PairLightAdaptivePrepared12.leftCached000,
    `D1Bound5.PairLightAdaptivePrepared12.leftRows000,
    `D1Bound5.PairLightAdaptivePrepared12.leftCached001,
    `D1Bound5.PairLightAdaptivePrepared12.leftRows001,
    `D1Bound5.PairLightAdaptivePrepared12.leftCached002,
    `D1Bound5.PairLightAdaptivePrepared12.leftRows002,
    `D1Bound5.PairLightAdaptivePrepared12.rightCached000,
    `D1Bound5.PairLightAdaptivePrepared12.rightRows000,
    `D1Bound5.PairLightAdaptivePrepared12.rightCached001,
    `D1Bound5.PairLightAdaptivePrepared12.rightRows001,
    `D1Bound5.PairLightAdaptivePrepared12.rightCached002,
    `D1Bound5.PairLightAdaptivePrepared12.rightRows002,
    `D1Bound5.PairLightAdaptivePrepared12.left_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared12.left_signatures_checked,
    `D1Bound5.PairLightAdaptivePrepared12.right_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared12.right_signatures_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH12_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightPrepared12

example
: List (Nat × Nat) :=
  _root_.D1Bound5.PairLightPrepared12.sieve
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared12.leftVertices
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared12.leftCached
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared12.leftRows
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared12.rightVertices
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared12.rightCached
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared12.rightRows
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.leftCached000
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.leftRows000
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.leftCached001
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.leftRows001
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.leftCached002
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.leftRows002
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.rightCached000
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.rightRows000
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.rightCached001
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.rightRows001
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.rightCached002
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.rightRows002
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    decide (PairLightPrepared12.leftCached.map Prod.fst = PairLightPrepared12.leftVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    (PairLightPrepared12.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared12.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    decide (PairLightPrepared12.rightCached.map Prod.fst = PairLightPrepared12.rightVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared12

namespace D1Bound5.PairLightAdaptivePrepared12

example
:
    (PairLightPrepared12.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared12.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared12.right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared12

#check @_root_.D1Bound5.PairLightPrepared12.sieve
#check @_root_.D1Bound5.PairLightPrepared12.leftVertices
#check @_root_.D1Bound5.PairLightPrepared12.leftCached
#check @_root_.D1Bound5.PairLightPrepared12.leftRows
#check @_root_.D1Bound5.PairLightPrepared12.rightVertices
#check @_root_.D1Bound5.PairLightPrepared12.rightCached
#check @_root_.D1Bound5.PairLightPrepared12.rightRows
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.leftCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.leftRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.leftCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.leftRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.leftCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.leftRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.rightCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.rightRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.rightCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.rightRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.rightCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.rightRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.left_signatures_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.right_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared12.right_signatures_checked
