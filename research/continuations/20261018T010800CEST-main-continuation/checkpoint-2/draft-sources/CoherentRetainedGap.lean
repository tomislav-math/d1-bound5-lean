import D1Bound5.CoherentRetainedAnalyticData
import D1Bound5.RetainedGapScalar
import D1Bound5.AllLargeOverlapConstants

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The retained H48 gap for actual five tuple entries in the
no-small-entry branch.  The analytic forms, nonvanishing, integrality,
terminal norm bounds and normalized Vandermonde bounds are all derived;
no root witness or retained-gap inequality is assumed. -/
theorem full_ring_retained_three_h48_gap
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {Tup : Finset (𝓞 K)} (hTup : IsD1 Tup)
    (a : Fin 5 → 𝓞 K) (hinj : Function.Injective a) (hmem : ∀ i, a i ∈ Tup)
    (hA : 3 ≤ ‖phi (a 0 : K)‖)
    (hAB : ‖phi (a 0 : K)‖ ≤ ‖phi (a 1 : K)‖)
    (hBS : ‖phi (a 1 : K)‖ ≤ ‖phi (a 2 : K)‖)
    (hfrontier : 2*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖ < ‖phi (a 3 : K)‖)
    (hproduct : 3*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ < ‖phi (a 4 : K)‖) :
    let v : Fin 3 → ℂ := fun i => phi (a (![0,1,2] i) : K)
    let R := ‖coherentVandermonde3 v‖/(‖phi (a 1 : K)‖*‖phi (a 2 : K)‖^2)
    ((9999/10000 : ℝ)*(200/19)^2) *
      (1/R-(51051/400000 : ℝ)/(‖phi (a 0 : K)‖^2*‖phi (a 1 : K)‖^2))^2 *
        (‖phi (a 0 : K)‖^2*‖phi (a 3 : K)‖^5/‖phi (a 2 : K)‖^2) < ‖phi (a 4 : K)‖ := by
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
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hv : Function.Injective v :=
    hf.comp (hinj.comp (by decide : Function.Injective (![0,1,2] : Fin 3 → Fin 5)))
  have hA0 : 0 < A := by change 0<‖phi (a 0 : K)‖; linarith only [hA]
  have hB3 : 3 ≤ B := hA.trans hAB
  have hS3 : 3 ≤ S := hB3.trans hBS
  have hB0 : 0 < B := by linarith
  have hS0 : 0 < S := by linarith
  have hparams := coherent_retained_h48_size_parameters A B S P C hA hAB hBS hfrontier hproduct
  have hP0 : 0 < P := by nlinarith only [hparams.1,hS3]
  have hC0 : 0 < C := by nlinarith only [hparams.2.2.2.1,hP0]
  have hSP : S ≤ P := by nlinarith only [hparams.1,hS0]
  have heta : eta^2 = f (a 3)*f (a 4) := coherent_cpow_half_sq _
  have hactual := full_ring_retained_three_h48_lower_upper hK phi hTup a hinj hmem
    hA hAB hBS hfrontier hproduct eta heta
  have hgap := full_ring_coherent_two_strong_gap_main hK phi hTup
    (hmem 1) (hmem 2) (hmem 3) (hmem 4)
    (hinj.ne (by decide)) (hinj.ne (by decide)) (hinj.ne (by decide))
    (hinj.ne (by decide)) (hinj.ne (by decide)) (hinj.ne (by decide))
    hBS hS3 hparams.1 hparams.2.1 (Or.inl hB3)
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
      (19/200 : ℝ)*(R*B*S^2)*Z/(A*B*S*P^3) := by
    rw [hdelta]
    exact hactual.2.2
  exact retained_three_h48_scalar_gap A B S P C Z R ‖L‖
    hA hB3 hS3 hSP hZ hratio.1 hratio.2 hfrontier hgap
    hroots.1 hroots.2 hactual.2.1 hupper

/-- With the sharpened four-entry frontier, the retained actual tuple
gap gives the coefficient 400 used in the no-small-entry overlap table. -/
theorem full_ring_all_large_retained_monomial
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {Tup : Finset (𝓞 K)} (hTup : IsD1 Tup)
    (a : Fin 5 → 𝓞 K) (hinj : Function.Injective a) (hmem : ∀ i, a i ∈ Tup)
    (hA : 3 ≤ ‖phi (a 0 : K)‖)
    (hAB : ‖phi (a 0 : K)‖ ≤ ‖phi (a 1 : K)‖)
    (hBS : ‖phi (a 1 : K)‖ ≤ ‖phi (a 2 : K)‖)
    (hfrontier : 3*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖ < ‖phi (a 3 : K)‖)
    (hproduct : 3*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ < ‖phi (a 4 : K)‖) :
    400*(‖phi (a 0 : K)‖^7*‖phi (a 1 : K)‖^5*‖phi (a 2 : K)‖^3) < ‖phi (a 4 : K)‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let v : Fin 3 → ℂ := fun i => f (a (![0,1,2] i))
  let A := ‖f (a 0)‖
  let B := ‖f (a 1)‖
  let S := ‖f (a 2)‖
  let P := ‖f (a 3)‖
  let C := ‖f (a 4)‖
  let R := ‖coherentVandermonde3 v‖/(B*S^2)
  have hA0 : 0 < A := by change 0<‖phi (a 0 : K)‖; linarith only [hA]
  have hB3 : 3 ≤ B := hA.trans hAB
  have hB0 : 0 < B := by linarith
  have hS0 : 0 < S := hB0.trans_le hBS
  have hprod0 : 0 < A*B*S := by positivity
  have hfront2 : 2*A*B*S < P := by nlinarith only [hfrontier,hprod0]
  have hret := full_ring_retained_three_h48_gap hK phi hTup a hinj hmem
    hA hAB hBS hfront2 hproduct
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hv : Function.Injective v :=
    hf.comp (hinj.comp (by decide : Function.Injective (![0,1,2] : Fin 3 → Fin 5)))
  have hratio := coherent_three_vandermonde_ratio_bounds v hv hA0 hAB hBS
  have hp5 : (3*A*B*S)^5 ≤ P^5 := by gcongr; exact hfrontier.le
  have hbase : 3^5*(A^7*B^5*S^3) ≤ A^2*P^5/S^2 := by
    calc
      _ = A^2*(3*A*B*S)^5/S^2 := by field_simp; ring
      _ ≤ _ := div_le_div_of_nonneg_right
        (mul_le_mul_of_nonneg_left hp5 (sq_nonneg A)) (sq_nonneg S)
  have hmon : 3^5*((9999/10000 : ℝ)*(200/19)^2)*
      (1/R-(51051/400000 : ℝ)/(A^2*B^2))^2*(A^7*B^5*S^3) < C := by
    have h := mul_le_mul_of_nonneg_left hbase
      (by positivity : 0 ≤ ((9999/10000 : ℝ)*(200/19)^2)*
        (1/R-(51051/400000 : ℝ)/(A^2*B^2))^2)
    have hc : ((9999/10000 : ℝ)*(200/19)^2)*
        (1/R-(51051/400000 : ℝ)/(A^2*B^2))^2*(A^2*P^5/S^2) < C := hret
    nlinarith only [h,hc]
  exact all_large_retained_gap_monomial A B S C R hA hB3 hS0 hratio.1 hratio.2 hmon

end D1Bound5

#print axioms D1Bound5.full_ring_retained_three_h48_gap
#print axioms D1Bound5.full_ring_all_large_retained_monomial
