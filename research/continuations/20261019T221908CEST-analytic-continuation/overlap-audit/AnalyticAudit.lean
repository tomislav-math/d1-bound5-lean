import D1Bound5.AllLargeWindows
import D1Bound5.AllLargeWindowOverlaps
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.allLargeWindowQ,
    `D1Bound5.allLargeWindowN2,
    `D1Bound5.allLargeWindowP,
    `D1Bound5.allLargeWindowA3,
    `D1Bound5.allLargeWindowM,
    `D1Bound5.allLargeWindowN3,
    `D1Bound5.allLargeWindowA4,
    `D1Bound5.allLargeWindowA5,
    `D1Bound5.window_upper_lt_of_excluded,
    `D1Bound5.window_overlap_of_ratio,
    `D1Bound5.all_large_window_overlaps]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.allLargeWindowQ
#check @D1Bound5.allLargeWindowN2
#check @D1Bound5.allLargeWindowP
#check @D1Bound5.allLargeWindowA3
#check @D1Bound5.allLargeWindowM
#check @D1Bound5.allLargeWindowN3
#check @D1Bound5.allLargeWindowA4
#check @D1Bound5.allLargeWindowA5
#check @D1Bound5.window_upper_lt_of_excluded
#check @D1Bound5.window_overlap_of_ratio
#check @D1Bound5.all_large_window_overlaps

open Finset Polynomial
namespace D1Bound5
section


example (w : ℝ × ℝ) (D : ℝ)
    (hex : ¬ (w.1 ≤ D ∧ D ≤ w.2)) (hlo : w.1 ≤ D) : w.2 < D := by
  exact window_upper_lt_of_excluded w D hex hlo

example (l u q : ℝ) (hl : 0 < l)
    (heq : u/l=q) (hq : 1 < q) : l < u := by
  exact window_overlap_of_ratio l u q hl heq hq

end

section


example
    (A B S T C : ℝ) (hA : 3 ≤ A) (hAB : A ≤ B) (hBS : B ≤ S)
    (hT : 2*B*S < T) (hC : A^2*T^5/S^2 < C)
    (hgap : 400*(A^7*B^5*S^3) < C) :
    (allLargeWindowQ A T C).1 < A^2*C^7/(S^2*T^4) ∧
    (allLargeWindowN2 A B C).1 < (allLargeWindowQ A T C).2 ∧
    (allLargeWindowP A B S C).1 < (allLargeWindowN2 A B C).2 ∧
    (B^2 ≤ S → (allLargeWindowN3 A B C).1 < (allLargeWindowP A B S C).2) ∧
    (allLargeWindowA3 A B C).1 < (allLargeWindowP A B S C).2 ∧
    (S ≤ B^2 → (allLargeWindowM A B S C).1 < (allLargeWindowA3 A B C).2) ∧
    (allLargeWindowN3 A B C).1 < (allLargeWindowM A B S C).2 ∧
    (B^3 ≤ S → (allLargeWindowA4 A B C).1 < (allLargeWindowN3 A B C).2) ∧
    (S ≤ B^3 → (allLargeWindowN3 B S C).1 < (allLargeWindowN3 A B C).2) ∧
    (allLargeWindowA4 A B C).1 < (allLargeWindowN3 B S C).2 ∧
    ordinaryWindowLower B C 4 < (allLargeWindowA4 A B C).2 ∧
    (allLargeWindowA5 A B C).1 < ordinaryWindowUpper A B C 4 ∧
    ordinaryWindowLower B C 5 < (allLargeWindowA5 A B C).2 ∧
    ordinaryWindowLower B C 6 < ordinaryWindowUpper A B C 5 ∧
    42*B^3*C < 2*A*C^2/(5*B) := by
  exact all_large_window_overlaps A B S T C hA hAB hBS hT hC hgap

end

end D1Bound5
