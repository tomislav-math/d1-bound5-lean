import D1Bound5.SmallPairLightData25Left
import D1Bound5.SmallPairLightData25Right
import D1Bound5.SmallPairLightData25
import D1Bound5.SmallPairLightAdaptiveData25
import D1Bound5.SmallPairLightAdaptiveValidation25
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightPrepared25.sieve,
    `D1Bound5.PairLightPrepared25.leftVertices,
    `D1Bound5.PairLightPrepared25.leftCached,
    `D1Bound5.PairLightPrepared25.leftRows,
    `D1Bound5.PairLightPrepared25.rightVertices,
    `D1Bound5.PairLightPrepared25.rightCached,
    `D1Bound5.PairLightPrepared25.rightRows,
    `D1Bound5.PairLightAdaptivePrepared25.leftCached000,
    `D1Bound5.PairLightAdaptivePrepared25.leftRows000,
    `D1Bound5.PairLightAdaptivePrepared25.leftCached001,
    `D1Bound5.PairLightAdaptivePrepared25.leftRows001,
    `D1Bound5.PairLightAdaptivePrepared25.leftCached002,
    `D1Bound5.PairLightAdaptivePrepared25.leftRows002,
    `D1Bound5.PairLightAdaptivePrepared25.rightCached000,
    `D1Bound5.PairLightAdaptivePrepared25.rightRows000,
    `D1Bound5.PairLightAdaptivePrepared25.rightCached001,
    `D1Bound5.PairLightAdaptivePrepared25.rightRows001,
    `D1Bound5.PairLightAdaptivePrepared25.rightCached002,
    `D1Bound5.PairLightAdaptivePrepared25.rightRows002,
    `D1Bound5.PairLightAdaptivePrepared25.left_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared25.left_signatures_checked,
    `D1Bound5.PairLightAdaptivePrepared25.right_coverage_checked,
    `D1Bound5.PairLightAdaptivePrepared25.right_signatures_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH25_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightPrepared25

example
: List (Nat × Nat) :=
  _root_.D1Bound5.PairLightPrepared25.sieve
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared25.leftVertices
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared25.leftCached
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared25.leftRows
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
: List PairLightCoordinate :=
  _root_.D1Bound5.PairLightPrepared25.rightVertices
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightPrepared25.rightCached
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightPrepared25.rightRows
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.leftCached000
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.leftRows000
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.leftCached001
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.leftRows001
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.leftCached002
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.leftRows002
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.rightCached000
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.rightRows000
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.rightCached001
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.rightRows001
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List PairLightCachedVertex :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.rightCached002
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
: List (Nat × List Nat) :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.rightRows002
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    decide (PairLightPrepared25.leftCached.map Prod.fst = PairLightPrepared25.leftVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    (PairLightPrepared25.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared25.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    decide (PairLightPrepared25.rightCached.map Prod.fst = PairLightPrepared25.rightVertices) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared25

namespace D1Bound5.PairLightAdaptivePrepared25

example
:
    (PairLightPrepared25.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared25.sieve x.1)) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared25.right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared25

#check @_root_.D1Bound5.PairLightPrepared25.sieve
#check @_root_.D1Bound5.PairLightPrepared25.leftVertices
#check @_root_.D1Bound5.PairLightPrepared25.leftCached
#check @_root_.D1Bound5.PairLightPrepared25.leftRows
#check @_root_.D1Bound5.PairLightPrepared25.rightVertices
#check @_root_.D1Bound5.PairLightPrepared25.rightCached
#check @_root_.D1Bound5.PairLightPrepared25.rightRows
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.leftCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.leftRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.leftCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.leftRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.leftCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.leftRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.rightCached000
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.rightRows000
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.rightCached001
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.rightRows001
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.rightCached002
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.rightRows002
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.left_signatures_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.right_coverage_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared25.right_signatures_checked
