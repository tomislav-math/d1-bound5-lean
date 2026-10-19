import D1Bound5.CoherentRetainedTuple
import D1Bound5.RetainedFourScalar
import D1Bound5.CoherentRetainedBasicGap
import D1Bound5.CoherentRetainedFourSizes
import D1Bound5.CoherentRetainedStart
import D1Bound5.OrdinaryClosedIntervals
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.IsD1Tuple.all_large_retained_growth,
    `D1Bound5.retained_four_first_term_lt,
    `D1Bound5.retained_four_start_scalar_gap,
    `D1Bound5.coherent_retained_h48_coefficient_gt_one,
    `D1Bound5.full_ring_retained_three_basic_gap,
    `D1Bound5.IsD1Tuple.all_large_retained_power_gap,
    `D1Bound5.coherent_retained_first_terminal_large,
    `D1Bound5.coherent_retained_four_terminal_sizes,
    `D1Bound5.IsD1Tuple.all_large_retained_start,
    `D1Bound5.ordinaryWindowLower,
    `D1Bound5.ordinaryWindowUpper,
    `D1Bound5.IsD1Tuple.ordinary_closed_interval_excluded,
    `D1Bound5.ordinaryWindowLower_succ,
    `D1Bound5.ordinaryWindowUpper_succ,
    `D1Bound5.IsD1Tuple.ordinary_tail_incompatible]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.IsD1Tuple.all_large_retained_growth
#check @D1Bound5.retained_four_first_term_lt
#check @D1Bound5.retained_four_start_scalar_gap
#check @D1Bound5.coherent_retained_h48_coefficient_gt_one
#check @D1Bound5.full_ring_retained_three_basic_gap
#check @D1Bound5.IsD1Tuple.all_large_retained_power_gap
#check @D1Bound5.coherent_retained_first_terminal_large
#check @D1Bound5.coherent_retained_four_terminal_sizes
#check @D1Bound5.IsD1Tuple.all_large_retained_start
#check @D1Bound5.ordinaryWindowLower
#check @D1Bound5.ordinaryWindowUpper
#check @D1Bound5.IsD1Tuple.ordinary_closed_interval_excluded
#check @D1Bound5.ordinaryWindowLower_succ
#check @D1Bound5.ordinaryWindowUpper_succ
#check @D1Bound5.IsD1Tuple.ordinary_tail_incompatible

open Finset Polynomial
namespace D1Bound5
section


example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : 3 ≤ ‖phi (a 0 : K)‖) :
    400*(‖phi (a 0 : K)‖^7*‖phi (a 1 : K)‖^5*‖phi (a 2 : K)‖^3) <
      ‖phi (a 4 : K)‖ := by
  exact IsD1Tuple.all_large_retained_growth hK phi a ha hmon hA

end

section


example
    (A B S T C D Z : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B)
    (hS : 0 < S) (hT : 0 < T) (hZ : 0 < Z)
    (hC : 16*B*S*T < C)
    (hD : A^2*C^5/S^2 < D)
    (hroot : (3999/4000 : ℝ)*C*D < Z^2) :
    13*B*S^2*T^3/Z < (1/100 : ℝ) := by
  exact retained_four_first_term_lt A B S T C D Z hA hB hS hT hZ hC hD hroot

example
    (A B S T C D Z L : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B)
    (hS : 0 < S) (hT : 0 < T) (hSC : S ≤ C) (hTC : T ≤ C)
    (hC1000 : 1000 < C) (hZ : 0 < Z)
    (hC : 16*B*S*T < C)
    (hD : A^2*C^5/S^2 < D)
    (hrootlo : (3999/4000 : ℝ)*C*D < Z^2)
    (hroothi : Z^2 ≤ C*D+1)
    (hL : 1 ≤ L)
    (hupper : L < 13*B*S^2*T^3/Z + (49/50 : ℝ)*S*T^2*Z/(A*C^4)) :
    A^2*C^7/(S^2*T^4) < D := by
  exact retained_four_start_scalar_gap A B S T C D Z L hA hB hS hT hSC hTC hC1000 hZ hC hD hrootlo hroothi hL hupper

end

section


example
    (A B R : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B) (hR : 0 < R) (hR8 : R ≤ 8) :
    1 < ((9999/10000 : ℝ)*(200/19)^2)*
      (1/R-(51051/400000 : ℝ)/(A^2*B^2))^2 := by
  exact coherent_retained_h48_coefficient_gt_one A B R hA hB hR hR8

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {Tup : Finset (𝓞 K)} (hTup : IsD1 Tup)
    (a : Fin 5 → 𝓞 K) (hinj : Function.Injective a) (hmem : ∀ i, a i ∈ Tup)
    (hA : 3 ≤ ‖phi (a 0 : K)‖)
    (hAB : ‖phi (a 0 : K)‖ ≤ ‖phi (a 1 : K)‖)
    (hBS : ‖phi (a 1 : K)‖ ≤ ‖phi (a 2 : K)‖)
    (hfrontier : 2*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖ < ‖phi (a 3 : K)‖)
    (hproduct : 3*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ < ‖phi (a 4 : K)‖) :
    ‖phi (a 0 : K)‖^2*‖phi (a 3 : K)‖^5/‖phi (a 2 : K)‖^2 <
      ‖phi (a 4 : K)‖ := by
  exact full_ring_retained_three_basic_gap hK phi hTup a hinj hmem hA hAB hBS hfrontier hproduct

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : 3 ≤ ‖phi (a 0 : K)‖) :
    ‖phi (a 0 : K)‖^2*‖phi (a 3 : K)‖^5/‖phi (a 2 : K)‖^2 <
      ‖phi (a 4 : K)‖ := by
  exact IsD1Tuple.all_large_retained_power_gap hK phi a ha hmon hA

end

section


example
    (A B S T C : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B) (hS : 0 < S)
    (hBS : B ≤ S) (hST : S ≤ T)
    (hfront : 2*A*B*S < T) (hgap : A^2*T^5/S^2 < C) :
    16*B*S*T < C := by
  exact coherent_retained_first_terminal_large A B S T C hA hB hS hBS hST hfront hgap

example
    (A B S T C D : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B)
    (hS : 0 < S) (hT : 0 < T) (hST : S ≤ T) (hSC : S ≤ C)
    (hC1000 : 1000 < C) (hC : 16*B*S*T < C)
    (hD : A^2*C^5/S^2 < D) :
    1000*C < D ∧ 17*A*B*S*T*C^3 < D := by
  exact coherent_retained_four_terminal_sizes A B S T C D hA hB hS hT hST hSC hC1000 hC hD

end

section


example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : 3 ≤ ‖phi (a 0 : K)‖) :
    let A := ‖phi (a 0 : K)‖
    let B := ‖phi (a 1 : K)‖
    let S := ‖phi (a 2 : K)‖
    let T := ‖phi (a 3 : K)‖
    let C := ‖phi (a 4 : K)‖
    let D := ‖phi (a 5 : K)‖
    A^2*T^5/S^2 < C ∧ A^2*C^5/S^2 < D ∧ A^2*C^7/(S^2*T^4) < D ∧
      1000 < C ∧ 16*B*S*T < C ∧ 1000*C < D := by
  exact IsD1Tuple.all_large_retained_start hK phi a ha hmon hA

end

section


example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hAB : ‖phi (t 0 : K)‖ ≤ ‖phi (t 1 : K)‖)
    (hAC : 1000 ≤ ‖phi (t 0 : K)‖*‖phi (t 2 : K)‖)
    (hC : 4*‖phi (t 1 : K)‖ < ‖phi (t 2 : K)‖)
    (hCD : ‖phi (t 2 : K)‖ ≤ ‖phi (t 3 : K)‖)
    (k : ℕ) (hk : 1 ≤ k)
    (hleft : ordinaryWindowLower ‖phi (t 1 : K)‖ ‖phi (t 2 : K)‖ k ≤
      ‖phi (t 3 : K)‖)
    (hright : ‖phi (t 3 : K)‖ ≤
      ordinaryWindowUpper ‖phi (t 0 : K)‖ ‖phi (t 1 : K)‖ ‖phi (t 2 : K)‖ k) :
    False := by
  exact IsD1Tuple.ordinary_closed_interval_excluded hK phi t ht hAB hAC hC hCD k hk hleft hright

example (B C : ℝ) (k : ℕ) :
    ordinaryWindowLower B C (k+1) = ordinaryWindowLower B C k*(42*B^3*C)^2 := by
  exact ordinaryWindowLower_succ B C k

example (A B C : ℝ) (k : ℕ) :
    ordinaryWindowUpper A B C (k+1) =
      ordinaryWindowUpper A B C k*(2*A*C^2/(5*B))^2 := by
  exact ordinaryWindowUpper_succ A B C k

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hAB : ‖phi (t 0 : K)‖ ≤ ‖phi (t 1 : K)‖)
    (hAC : 1000 ≤ ‖phi (t 0 : K)‖*‖phi (t 2 : K)‖)
    (hC : 4*‖phi (t 1 : K)‖ < ‖phi (t 2 : K)‖)
    (hCD : ‖phi (t 2 : K)‖ ≤ ‖phi (t 3 : K)‖)
    (hrate : 42*‖phi (t 1 : K)‖^3*‖phi (t 2 : K)‖ <
      2*‖phi (t 0 : K)‖*‖phi (t 2 : K)‖^2/(5*‖phi (t 1 : K)‖))
    (hoverlap : ordinaryWindowLower ‖phi (t 1 : K)‖ ‖phi (t 2 : K)‖ 6 ≤
      ordinaryWindowUpper ‖phi (t 0 : K)‖ ‖phi (t 1 : K)‖ ‖phi (t 2 : K)‖ 5)
    (hstart : ordinaryWindowLower ‖phi (t 1 : K)‖ ‖phi (t 2 : K)‖ 5 ≤
      ‖phi (t 3 : K)‖) : False := by
  exact IsD1Tuple.ordinary_tail_incompatible hK phi t ht hAB hAC hC hCD hrate hoverlap hstart

end

end D1Bound5
