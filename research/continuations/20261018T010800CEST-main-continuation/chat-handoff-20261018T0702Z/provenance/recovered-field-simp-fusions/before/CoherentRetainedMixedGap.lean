import D1Bound5.CoherentRetainedMixedForms
import D1Bound5.CoherentRetainedAnalyticData
import D1Bound5.RetainedMixedScalar

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The retained coefficient remains greater than one when the first
anchor has modulus only one, for either manuscript interpolation row. -/
theorem coherent_retained_mixed_coefficient_gt_one
    (A B R lam : ℝ) (hA : 1 ≤ A) (hB : 3 ≤ B) (hR : 0 < R) (hR8 : R ≤ 8)
    (hlam : 0 < lam) (hlam10 : lam ≤ 1/10) :
    1 < (9999/10000 : ℝ)/lam^2 *
      (1/R-(51051/400000 : ℝ)/(A^2*B^2))^2 := by
  have hAB : (9 : ℝ) ≤ A^2*B^2 := by
    calc
      (9 : ℝ) = 1^2*3^2 := by norm_num
      _ ≤ A^2*B^2 := by gcongr <;> first | assumption | norm_num
  have hAB0 : 0 < A^2*B^2 := lt_of_lt_of_le (by norm_num) hAB
  have hinv : (1/8 : ℝ) ≤ 1/R := by
    apply (div_le_div_iff₀ (by norm_num : (0 : ℝ) < 8) hR).2
    simpa using hR8
  have herr : (51051/400000 : ℝ)/(A^2*B^2) ≤ (51051/400000)/9 := by
    apply (div_le_div_iff₀ hAB0 (by norm_num : (0 : ℝ) < 9)).2
    nlinarith only [hAB]
  have hd : (11/100 : ℝ) < 1/R-(51051/400000 : ℝ)/(A^2*B^2) := by
    linarith only [hinv,herr]
  have hs : (11/100 : ℝ)^2 < (1/R-(51051/400000 : ℝ)/(A^2*B^2))^2 := by
    have hp := mul_pos (sub_pos.mpr hd)
      (show 0 < (1/R-(51051/400000 : ℝ)/(A^2*B^2))+(11/100) by linarith only [hd])
    nlinarith only [hp]
  have hlamsq : lam^2 ≤ (1/100 : ℝ) := by
    have hh := mul_nonneg (sub_nonneg.mpr hlam10)
      (show 0 ≤ 1/10+lam by positivity)
    nlinarith only [hh]
  have hc : (9999/100 : ℝ) ≤ (9999/10000)/lam^2 := by
    apply (le_div_iff₀ (pow_pos hlam 2)).2
    nlinarith only [hlamsq]
  have hh := mul_le_mul_of_nonneg_right hc
    (sq_nonneg (1/R-(51051/400000 : ℝ)/(A^2*B^2)))
  nlinarith only [hs,hh]

/-- Precise and basic retained gaps in the mixed regime for actual
five tuple entries. Both H32 and H48 are available. The frontier and
product hypotheses are explicit tuple growth estimates, subsequently
discharged by the actual small-norm frontier theorem. -/
theorem full_ring_retained_three_mixed_gap
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {Tup : Finset (𝓞 K)} (hTup : IsD1 Tup)
    (a : Fin 5 → 𝓞 K) (hinj : Function.Injective a) (hmem : ∀ i, a i ∈ Tup)
    (hA : 1 ≤ ‖phi (a 0 : K)‖) (hB : 3 ≤ ‖phi (a 1 : K)‖)
    (hAB : ‖phi (a 0 : K)‖ ≤ ‖phi (a 1 : K)‖)
    (hBS : ‖phi (a 1 : K)‖ ≤ ‖phi (a 2 : K)‖)
    (hfrontier : 2*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖ < ‖phi (a 3 : K)‖)
    (hproduct : 3*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ < ‖phi (a 4 : K)‖)
    (H lam U : ℝ) (hrow : CoherentRetainedRow H lam U)
    (hAT : H ≤ ‖phi (a 0 : K)‖*‖phi (a 3 : K)‖) :
    let v : Fin 3 → ℂ := fun i => phi (a (![0,1,2] i) : K)
    let R := ‖coherentVandermonde3 v‖/(‖phi (a 1 : K)‖*‖phi (a 2 : K)‖^2)
    (9999/10000 : ℝ)/lam^2 *
      (1/R-(51051/400000 : ℝ)/(‖phi (a 0 : K)‖^2*‖phi (a 1 : K)‖^2))^2 *
        (‖phi (a 0 : K)‖^2*‖phi (a 3 : K)‖^5/‖phi (a 2 : K)‖^2) < ‖phi (a 4 : K)‖ ∧
      ‖phi (a 0 : K)‖^2*‖phi (a 3 : K)‖^5/‖phi (a 2 : K)‖^2 < ‖phi (a 4 : K)‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let v : Fin 3 → ℂ := fun i => f (a (![0,1,2] i))
  let A := ‖f (a 0)‖
  let B := ‖f (a 1)‖
  let S := ‖f (a 2)‖
  let P := ‖f (a 3)‖
  let C := ‖f (a 4)‖
  let eta : ℂ := (f (a 3)*f (a 4))^(1/2 : ℂ)
  let Z := ‖coherentTerminalRoot (f (a 3)) (f (a 4)) eta‖
  let L := coherentQuotientForm v (coherentVandermonde3 v) (f (a 3)) (f (a 4)) eta
  let R := ‖coherentVandermonde3 v‖/(B*S^2)
  have hA0 : 0 < A := by change 0 < ‖phi (a 0 : K)‖; linarith only [hA]
  have hB0 : 0 < B := by change 0 < ‖phi (a 1 : K)‖; linarith only [hB]
  have hS3 : 3 ≤ S := hB.trans hBS
  have hS0 : 0 < S := by linarith only [hS3]
  have hP0 : 0 < P := lt_trans (by positivity : 0 < 2*A*B*S) hfrontier
  have hH32 : 32 ≤ H := by
    rcases hrow with ⟨rfl,rfl,rfl⟩ | ⟨rfl,rfl,rfl⟩ <;> norm_num
  have hparams := coherent_retained_mixed_size_parameters A B S P C
    hA hB hBS (hH32.trans hAT) hfrontier hproduct
  have hC0 : 0 < C := by nlinarith only [hparams.2.2.2.1,hP0]
  have hSP : S ≤ P := by nlinarith only [hparams.1,hS0]
  have heta : eta^2 = f (a 3)*f (a 4) := coherent_cpow_half_sq _
  have hactual := full_ring_retained_three_mixed_lower_upper hK phi hTup a hinj hmem
    hA hB hAB hBS hfrontier hproduct H lam U hrow hAT eta heta
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hv : Function.Injective v :=
    hf.comp (hinj.comp (by decide : Function.Injective (![0,1,2] : Fin 3 → Fin 5)))
  have hratio := coherent_three_vandermonde_ratio_bounds v hv hA0 hAB hBS
  have hroots := coherent_terminal_root_norm_sq_bounds (f (a 3)) (f (a 4)) eta
    (norm_pos_iff.mp hP0) (norm_pos_iff.mp hC0) heta
    (by linarith only [hparams.2.2.2.2.1])
  have hZ : 0 < Z := by
    have hz0 : 0 ≤ Z := norm_nonneg _
    have hpos : 0 < (3999/4000 : ℝ)*P*C := by positivity
    nlinarith only [hz0,hpos,hroots.1]
  have hdelta : R*B*S^2 = ‖coherentVandermonde3 v‖ := by
    dsimp [R]
    field_simp
    ring
  have hupper : ‖L‖ < 51*(R*B*S^2)/(100*Z) +
      lam*(R*B*S^2)*Z/(A*B*S*P^3) := by
    rw [hdelta]
    exact hactual.2.2.2
  have hlam : 0 < lam ∧ lam ≤ 1/10 := by
    rcases hrow with ⟨rfl,rfl,rfl⟩ | ⟨rfl,rfl,rfl⟩ <;> norm_num
  have hret := retained_three_mixed_scalar_gap A B S P C Z R ‖L‖ lam
    hA hB hS3 hSP hZ hratio.1 hratio.2 hlam.1 hlam.2 hfrontier hactual.1
    hroots.1 hroots.2 hactual.2.2.1 hupper
  have hc := coherent_retained_mixed_coefficient_gt_one A B R lam
    hA hB hratio.1 hratio.2 hlam.1 hlam.2
  have hbase : 0 < A^2*P^5/S^2 := by positivity
  have hh := mul_lt_mul_of_pos_right hc hbase
  exact ⟨hret,(by simpa only [one_mul] using hh).trans hret⟩

end D1Bound5

#print axioms D1Bound5.coherent_retained_mixed_coefficient_gt_one
#print axioms D1Bound5.full_ring_retained_three_mixed_gap
