import D1Bound5.SmallPairLightData46Left
import D1Bound5.SmallPairLightData46LeftRows
import D1Bound5.SmallPairLightData46Right
import D1Bound5.SmallPairLightData46RightRows
import D1Bound5.SmallPairLightData46
import D1Bound5.SmallPairLightAdaptiveData46
import D1Bound5.SmallPairLightAdaptiveValidation46
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightPrepared46.sieve,
    `D1Bound5.PairLightPrepared46.leftVertices,
    `D1Bound5.PairLightPrepared46.leftCached,
    `D1Bound5.PairLightPrepared46.leftRows,
    `D1Bound5.PairLightPrepared46.rightVertices,
    `D1Bound5.PairLightPrepared46.rightCached,
    `D1Bound5.PairLightPrepared46.rightRows,
    `D1Bound5.PairLightAdaptivePrepared46.leftCached000,
    `D1Bound5.PairLightAdaptivePrepared46.leftRows000,
    `D1Bound5.PairLightAdaptivePrepared46.leftCached001,
    `D1Bound5.PairLightAdaptivePrepared46.leftRows001,
    `D1Bound5.PairLightAdaptivePrepared46.leftCached002,
    `D1Bound5.PairLightAdaptivePrepared46.leftRows002,
    `D1Bound5.PairLightAdaptivePrepared46.rightCached000,
    `D1Bound5.PairLightAdaptivePrepared46.rightRows000,
    `D1Bound5.PairLightAdaptivePrepared46.rightCached001,
    `D1Bound5.PairLightAdaptivePrepared46.rightRows001,
    `D1Bound5.PairLightAdaptivePrepared46.rightCached002,
    `D1Bound5.PairLightAdaptivePrepared46.rightRows002,
    `D1Bound5.PairLightAdaptivePrepared46.left_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared46.left_signatures_checked,
    `D1Bound5.PairLightAdaptivePrepared46.right_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared46.right_signatures_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH46_FOUNDATION_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightPrepared46

example
: List (Nat × Nat) :=
  _root_.D1Bound5.PairLightPrepared46.sieve
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared46.leftVertices
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared46.leftCached
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared46.leftRows
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared46.rightVertices
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared46.rightCached
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared46.rightRows
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.leftCached000
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.leftRows000
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.leftCached001
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.leftRows001
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.leftCached002
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.leftRows002
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.rightCached000
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.rightRows000
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.rightCached001
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.rightRows001
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.rightCached002
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.rightRows002
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
:
    decide (PairLightPrepared46.leftCached.map Prod.fst = PairLightPrepared46.leftVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
:
    (PairLightPrepared46.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared46.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
:
    decide (PairLightPrepared46.rightCached.map Prod.fst = PairLightPrepared46.rightVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared46

namespace D1Bound5.PairLightAdaptivePrepared46

example
:
    (PairLightPrepared46.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared46.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared46.right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared46

#check @_root_.D1Bound5.PairLightPrepared46.sieve
#check @_root_.D1Bound5.PairLightPrepared46.leftVertices
#check @_root_.D1Bound5.PairLightPrepared46.leftCached
#check @_root_.D1Bound5.PairLightPrepared46.leftRows
#check @_root_.D1Bound5.PairLightPrepared46.rightVertices
#check @_root_.D1Bound5.PairLightPrepared46.rightCached
#check @_root_.D1Bound5.PairLightPrepared46.rightRows
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.leftCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.leftRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.leftCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.leftRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.leftCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.leftRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.rightCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.rightRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.rightCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.rightRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.rightCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.rightRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.left_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.left_signatures_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.right_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared46.right_signatures_checked
