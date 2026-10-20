import D1Bound5.ThreeAnchorDetailedAlternative
import D1Bound5.ThreeSmallPairAlternative
import D1Bound5.ThreeSmallLargeExtensions
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open Lean Elab Command

set_option maxRecDepth 32768

run_cmd do
  let names : List Name := [
    `D1Bound5.IsD1Tuple.three_anchor_general_detailed_alternative,
    `D1Bound5.three_small_pair_alternative_scalar,
    `D1Bound5.IsD1Tuple.three_small_pair_alternative,
    `D1Bound5.three_small_pair_growth,
    `D1Bound5.ordinary_height_power_upper,
    `D1Bound5.three_small_tenth_growth_impossible,
    `D1Bound5.three_small_three_large_impossible,
    `D1Bound5.IsD1Tuple.three_small_pair_at,
    `D1Bound5.IsD1Tuple.three_small_not_three_large_extensions]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.IsD1Tuple.three_anchor_general_detailed_alternative
#check @D1Bound5.three_small_pair_alternative_scalar
#check @D1Bound5.IsD1Tuple.three_small_pair_alternative
#check @D1Bound5.three_small_pair_growth
#check @D1Bound5.ordinary_height_power_upper
#check @D1Bound5.three_small_tenth_growth_impossible
#check @D1Bound5.three_small_three_large_impossible
#check @D1Bound5.IsD1Tuple.three_small_pair_at
#check @D1Bound5.IsD1Tuple.three_small_not_three_large_extensions

open scoped NumberField
open Module
namespace D1Bound5

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hP : 1000 ≤ ‖phi (a 3 : K)‖)
    (hSP : 4*‖phi (a 2 : K)‖ ≤ ‖phi (a 3 : K)‖),
    (5*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖^2 <
        ‖phi (a 4 : K)‖ ∧
      ‖phi (a 4 : K)‖ < 15*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖^2) ∨
    ‖phi (a 4 : K)‖ < 101*‖phi (a 1 : K)‖^2*‖phi (a 2 : K)‖^4/‖phi (a 3 : K)‖ ∨
    ‖phi (a 0 : K)‖^2*‖phi (a 3 : K)‖^5/(37*‖phi (a 2 : K)‖^2) < ‖phi (a 4 : K)‖ := @D1Bound5.IsD1Tuple.three_anchor_general_detailed_alternative

example : ∀ (A B S P Q : ℝ) (hA : 1 ≤ A) (hAB : A ≤ B) (hBS : B ≤ S) (hS : S < 3)
    (hP : 1000 ≤ P) (hPQ : P ≤ Q)
    (halt : (5*A*B*S*P^2 < Q ∧ Q < 15*A*B*S*P^2) ∨
      Q < 101*B^2*S^4/P ∨ A^2*P^5/(37*S^2) < Q),
    (5*P^2 < Q ∧ Q < 405*P^2) ∨ P^5/400 < Q := @D1Bound5.three_small_pair_alternative_scalar

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hS : ‖phi (a 2 : K)‖ < 3) (hP : 1000 ≤ ‖phi (a 3 : K)‖),
    (5*‖phi (a 3 : K)‖^2 < ‖phi (a 4 : K)‖ ∧
      ‖phi (a 4 : K)‖ < 405*‖phi (a 3 : K)‖^2) ∨
      ‖phi (a 3 : K)‖^5/400 < ‖phi (a 4 : K)‖ := @D1Bound5.IsD1Tuple.three_small_pair_alternative

example : ∀ (P Q : ℝ) (hP : 1000 ≤ P)
    (halt : (5*P^2 < Q ∧ Q < 405*P^2) ∨ P^5/400 < Q),
    5*P^2 < Q := @D1Bound5.three_small_pair_growth

example : ∀ (P Q : ℝ) (hP : (10 : ℝ)^40 ≤ P) (hQ : 0 < Q)
    (hh : ordinaryLog10 Q < twoSmallHeightEnvelope (ordinaryLog10 P)),
    Q < (10 : ℝ)^60*P^7 := @D1Bound5.ordinary_height_power_upper

example : ∀ (U W : ℝ) (hU : (10 : ℝ)^40 ≤ U)
    (hlow : U^10/32000 < W) (hhigh : W < (10 : ℝ)^60*U^7),
    False := @D1Bound5.three_small_tenth_growth_impossible

example : ∀ (U V W : ℝ) (hU : (10 : ℝ)^40 ≤ U)
    (hUV : (5*U^2 < V ∧ V < 405*U^2) ∨ U^5/400 < V)
    (hVW : (5*V^2 < W ∧ W < 405*V^2) ∨ V^5/400 < W)
    (hUW : (5*U^2 < W ∧ W < 405*U^2) ∨ U^5/400 < W)
    (hupper : W < (10 : ℝ)^60*U^7),
    False := @D1Bound5.three_small_three_large_impossible

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hS : ‖phi (a 2 : K)‖ < 3) (i j : Fin 6) (hi : 3 ≤ i) (hij : i < j)
    (hP : 1000 ≤ ‖phi (a i : K)‖),
    (5*‖phi (a i : K)‖^2 < ‖phi (a j : K)‖ ∧
      ‖phi (a j : K)‖ < 405*‖phi (a i : K)‖^2) ∨
      ‖phi (a i : K)‖^5/400 < ‖phi (a j : K)‖ := @D1Bound5.IsD1Tuple.three_small_pair_at

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hS : ‖phi (a 2 : K)‖ < 3) (hU : (10 : ℝ)^40 ≤ ‖phi (a 3 : K)‖),
    False := @D1Bound5.IsD1Tuple.three_small_not_three_large_extensions

end D1Bound5
