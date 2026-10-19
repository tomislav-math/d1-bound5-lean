import D1Bound5.CoherentRetainedTuple

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The H48 retained coefficient is strictly larger than one throughout
the no-small-entry range. -/
theorem coherent_retained_h48_coefficient_gt_one
    (A B R : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B) (hR : 0 < R) (hR8 : R ≤ 8) :
    1 < ((9999/10000 : ℝ)*(200/19)^2)*
      (1/R-(51051/400000 : ℝ)/(A^2*B^2))^2 := by
  have hAB : (81 : ℝ) ≤ A^2*B^2 := by
    calc
      (81 : ℝ) = 3^2*3^2 := by norm_num
      _ ≤ A^2*B^2 := by gcongr <;> first | assumption | norm_num
  have hAB0 : 0 < A^2*B^2 := lt_of_lt_of_le (by norm_num) hAB
  have hinv : (1/8 : ℝ) ≤ 1/R := by
    apply (div_le_div_iff₀ (by norm_num : (0 : ℝ) < 8) hR).2
    simpa using hR8
  have herr : (51051/400000 : ℝ)/(A^2*B^2) ≤ (51051/400000)/81 := by
    apply (div_le_div_iff₀ hAB0 (by norm_num : (0 : ℝ) < 81)).2
    nlinarith only [hAB]
  have hd : (1/10 : ℝ) < 1/R-(51051/400000 : ℝ)/(A^2*B^2) := by
    linarith only [hinv, herr]
  have hs : (1/10 : ℝ)^2 < (1/R-(51051/400000 : ℝ)/(A^2*B^2))^2 := by
    have hp := mul_pos (sub_pos.mpr hd)
      (show 0 < (1/R-(51051/400000 : ℝ)/(A^2*B^2))+(1/10) by linarith only [hd])
    nlinarith only [hp]
  nlinarith only [hs]

/-- The weaker power gap retained from the precise H48 bound, still
for actual full-ring entries and without any assumed analytic form. -/
theorem full_ring_retained_three_basic_gap
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
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let v : Fin 3 → ℂ := fun i => f (a (![0,1,2] i))
  let A := ‖f (a 0)‖
  let B := ‖f (a 1)‖
  let S := ‖f (a 2)‖
  let P := ‖f (a 3)‖
  let R := ‖coherentVandermonde3 v‖/(B*S^2)
  have hA0 : 0 < A := by change 0 < ‖phi (a 0 : K)‖; linarith only [hA]
  have hB3 : 3 ≤ B := hA.trans hAB
  have hB0 : 0 < B := by linarith only [hB3]
  have hS0 : 0 < S := hB0.trans_le hBS
  have hP0 : 0 < P := lt_trans (by positivity : 0 < 2*A*B*S) hfrontier
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hv : Function.Injective v :=
    hf.comp (hinj.comp (by decide : Function.Injective (![0,1,2] : Fin 3 → Fin 5)))
  have hratio := coherent_three_vandermonde_ratio_bounds v hv hA0 hAB hBS
  have hc := coherent_retained_h48_coefficient_gt_one A B R hA hB3 hratio.1 hratio.2
  have hret := full_ring_retained_three_h48_gap hK phi hTup a hinj hmem
    hA hAB hBS hfrontier hproduct
  have hbase : 0 < A^2*P^5/S^2 := by positivity
  have h := mul_lt_mul_of_pos_right hc hbase
  exact (by simpa only [one_mul] using h).trans hret

/-- The first retained power gap needs only an actual ordered quintuple
whose smallest modulus is at least three. -/
theorem IsD1Tuple.all_large_retained_power_gap
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : 3 ≤ ‖phi (a 0 : K)‖) :
    ‖phi (a 0 : K)‖^2*‖phi (a 3 : K)‖^5/‖phi (a 2 : K)‖^2 <
      ‖phi (a 4 : K)‖ := by
  classical
  let b : Fin 4 → 𝓞 K := fun i => a (Fin.castAdd 1 i)
  have hcast : Function.Injective (Fin.castAdd 1 : Fin 4 → Fin 5) := by
    intro i j hij
    apply Fin.ext
    exact congrArg (fun k : Fin 5 => k.val) hij
  have hb : IsD1Tuple b := by
    refine ⟨ha.1.comp hcast, ?_, ?_⟩
    · intro i
      exact ha.2.1 (Fin.castAdd 1 i)
    · intro i j hij
      exact ha.2.2 (Fin.castAdd 1 i) (Fin.castAdd 1 j) (hcast.ne hij)
  have hbmon : Monotone (fun i => ‖phi (b i : K)‖) := by
    intro i j hij
    exact hmon hij
  have hfrontier := IsD1Tuple.productFour_large_growth hK phi b hb hbmon hA
  have hB : 3 ≤ ‖phi (a 1 : K)‖ :=
    hA.trans (hmon (by decide : (0 : Fin 5) ≤ 1))
  have hproduct :
      3*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ <
        ‖phi (a 4 : K)‖ := by
    simpa only [Fin.prod_univ_four, mul_assoc] using
      (IsD1Tuple.productFive_growth hK phi a ha hmon hB)
  let Tup : Finset (𝓞 K) := Finset.univ.image a
  have hmem (i : Fin 5) : a i ∈ Tup :=
    Finset.mem_image.mpr ⟨i, Finset.mem_univ i, rfl⟩
  have hTup : IsD1 Tup := by
    constructor
    · intro x hx
      obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
      exact ha.2.1 i
    · intro x hx y hy hxy
      obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
      obtain ⟨j, _, rfl⟩ := Finset.mem_image.mp hy
      exact ha.2.2 i j (fun hij => hxy (congrArg a hij))
  exact full_ring_retained_three_basic_gap hK phi hTup a ha.1 hmem hA
    (hmon (by decide : (0 : Fin 5) ≤ 1))
    (hmon (by decide : (1 : Fin 5) ≤ 2)) hfrontier hproduct

end D1Bound5

