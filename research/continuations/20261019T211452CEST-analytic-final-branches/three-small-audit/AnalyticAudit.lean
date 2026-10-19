import D1Bound5.ThreeSmallFixedScalar
import D1Bound5.ThreeSmallFixedExtension
import D1Bound5.ThreeSmallExclusion
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [`D1Bound5.three_small_fixed_V_parameters, `D1Bound5.three_small_fixed_V_growth, `D1Bound5.three_small_fixed_upper_and_overlap, `D1Bound5.three_small_fixed_M_window_contains, `D1Bound5.three_small_fixed_Q_window_contains, `D1Bound5.IsD1Tuple.three_small_not_fixed_and_two_large, `D1Bound5.IsD1Tuple.not_three_small]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.three_small_fixed_V_parameters
#check @D1Bound5.three_small_fixed_V_growth
#check @D1Bound5.three_small_fixed_upper_and_overlap
#check @D1Bound5.three_small_fixed_M_window_contains
#check @D1Bound5.three_small_fixed_Q_window_contains
#check @D1Bound5.IsD1Tuple.three_small_not_fixed_and_two_large
#check @D1Bound5.IsD1Tuple.not_three_small
namespace D1Bound5
example (A B S T C D : ℝ) (hA : 1 ≤ A) (hB : 0 < B) (hB3 : B < 3)
    (hS : 0 < S) (hS3 : S < 3) (hT : 0 < T) (hT85 : T < 85)
    (hC : (10 : ℝ)^40 ≤ C) (hD : 5*C^2 < D) :
    1000 ≤ C ∧ 4*T ≤ C ∧ 4*C ≤ D ∧
      32*B*S*T/A^3 ≤ C^2 ∧ 101*B^2*T^4/C < D := by
  exact three_small_fixed_V_parameters A B S T C D hA hB hB3 hS hS3 hT hT85 hC hD

example (A T C D : ℝ) (hA : 1 ≤ A) (hT : 0 < T) (hT85 : T < 85)
    (hC : (10 : ℝ)^40 ≤ C) (hV : (2/5 : ℝ)*A^2*C^5/T^2 < D) :
    (10 : ℝ)^38*C^3 < D := by
  exact three_small_fixed_V_growth A T C D hA hT hT85 hC hV

example (C D : ℝ) (hC : (10 : ℝ)^40 ≤ C)
    (hD : D < (10 : ℝ)^60*C^7) :
    D < C^11/(10 : ℝ)^22 ∧ (10 : ℝ)^40*C^5 ≤ C^7/(10 : ℝ)^29 := by
  exact three_small_fixed_upper_and_overlap C D hC hD

example (A B S C : ℝ) (hA : 1 ≤ A) (hB : 0 < B) (hB3 : B < 3)
    (hS : 0 < S) (hS3 : S < 3) (hC : 0 < C) :
    4*((8/9 : ℝ)*608^2)^2*B^6*S^16*C^5/(1-1/4000 : ℝ) ≤ (10 : ℝ)^40*C^5 ∧
      C^11/(10 : ℝ)^22 ≤ A^6*C^11/(4*(3920/81 : ℝ)^2*B^4*S^10*(1+1/4000 : ℝ)) := by
  exact three_small_fixed_M_window_contains A B S C hA hB hB3 hS hS3 hC

example (C : ℝ) (hC : 0 < C) :
    4*55^2*85^6*C^3/(1-1/4000 : ℝ) ≤ (10 : ℝ)^38*C^3 ∧
      C^7/(10 : ℝ)^29 ≤ C^7/(9*85^2*(1+1/4000 : ℝ)) := by
  exact three_small_fixed_Q_window_contains C hC

example {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hS3 : ‖phi (a 2 : K)‖ < 3) (hT85 : ‖phi (a 3 : K)‖ < 85)
    (hCbig : (10 : ℝ)^40 ≤ ‖phi (a 4 : K)‖) : False := by
  exact IsD1Tuple.three_small_not_fixed_and_two_large hK phi a ha hmon hS3 hT85 hCbig

example {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hsmall : ‖phi (a 2 : K)‖ < 3) : False := by
  exact IsD1Tuple.not_three_small hK phi a ha hmon hsmall

end D1Bound5
