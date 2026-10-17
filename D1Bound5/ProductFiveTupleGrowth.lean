import D1Bound5.ProductFiveTupleSchur
import D1Bound5.ProductFivePrefixSizeCross

open scoped NumberField Matrix.Norms.L2Operator
open Matrix Module

namespace D1Bound5

/-- One compatible signed integral root matrix attached to an actual ordered
D(1) quintuple satisfies the sharp Schur determinant estimate. The size,
sign, inverse and bilinear hypotheses are derived from the tuple itself. -/
theorem IsD1Tuple.five_compatible_schur_det_small
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hB : 3 ≤ ‖phi (a 1 : K)‖)
    (u : Fin 5 → ℂ) (S : Matrix (Fin 5) (Fin 5) (𝓞 K))
    (hu : ∀ i, (u i)^2 = phi (a i : K))
    (hdiag : ∀ i, S i i = a i)
    (hSsym : ∀ i j, S i j = S j i)
    (hgood : ∀ i j, i ≠ j →
      FiveSignedEntryGood (phi.comp (algebraMap (𝓞 K) K)) a u i j (S i j)) :
    ‖(fiveNormalizedSchur (fun i => phi (a i : K)) u
      (S.map (phi.comp (algebraMap (𝓞 K) K)))).det‖ < (1/3 : ℝ) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let t : Fin 5 → ℂ := fun i => f (a i)
  let E := normalizedRootError t u (fun i j => f (S i j))
  let F := fivePrefixError E
  let v := fiveLastError E
  let w := fivePrefixValues t
  let d := fiveLastValue t
  have hu' : ∀ i, (u i)^2 = f (a i) := hu
  have hg : ∀ i j, i ≠ j → FiveSignedEntryGood f a u i j (S i j) := hgood
  have hF : ‖F - halfOffDiagonal‖ ≤ (11/96 : ℝ) :=
    five_compatible_prefix_operator_bound f a u S hu' hdiag hg
  have hFsmall : ‖F - halfOffDiagonal‖ < (1/8 : ℝ) :=
    lt_of_le_of_lt hF (by norm_num)
  have hFhalf : ‖F - halfOffDiagonal‖ < (1/2 : ℝ) :=
    lt_trans hFsmall (by norm_num)
  have hFdet : F.det ≠ 0 := five_schur_det_ne_zero_of_near F hFhalf
  have hMsym : (S.map f)ᵀ = S.map f := by
    ext i j
    change f (S j i) = f (S i j)
    rw [hSsym]
  have hFsym : Fᵀ = F :=
    five_prefix_symmetric E (five_normalized_error_symmetric t u (S.map f) hMsym)
  have h54 : (54 : ℝ) ≤ ‖d‖ := by
    have hh := ha.five_last_modulus_gt_fiftyfour hK phi a hmon hB
    exact hh.le
  have hd : d ≠ 0 := norm_pos_iff.mp (by linarith only [h54])
  let b : Fin 4 → 𝓞 K := fun i => a i.succ
  have hb : IsD1Tuple b := by
    refine ⟨?_, ?_, ?_⟩
    · intro i j h
      apply Fin.ext
      have h' := congrArg (fun k : Fin 5 => k.val) (ha.1 h)
      simpa using h'
    · intro i
      exact ha.2.1 i.succ
    · intro i j hij
      exact ha.2.2 i.succ j.succ (by
        intro h
        apply hij
        apply Fin.ext
        have h' := congrArg (fun k : Fin 5 => k.val) h
        simpa using h')
  have hbmon : Monotone (fun i => ‖phi (b i : K)‖) := by
    intro i j hij
    apply hmon
    change i.val+1 ≤ j.val+1
    change i.val ≤ j.val at hij
    omega
  have hlarge : 2 * ‖t 1‖ * ‖t 2‖ * ‖t 3‖ < ‖t 4‖ := by
    have hh := hb.productFour_large_growth hK phi b hbmon hB
    exact hh
  have hw : ‖(WithLp.toLp 2 w : EuclideanSpace ℂ (Fin 4))‖ < ‖d‖/9 :=
    productFive_prefix_l2_lt_last_div_nine t hmon hB hlarge
  have hIv : ‖(WithLp.toLp 2 (F⁻¹ *ᵥ v) :
      EuclideanSpace ℂ (Fin 4))‖ < (11/12 : ℝ) :=
    five_compatible_inverse_vector_bound f a u S hu' hdiag hg
  have hp : ‖v ⬝ᵥ (F⁻¹ *ᵥ v)‖ < (1 : ℝ) :=
    five_compatible_bilinear_p_bound f a u S hu' hdiag hg
  have hh : ‖(v ⬝ᵥ (F⁻¹ *ᵥ w))/d‖ < (11/108 : ℝ) :=
    productFive_cross_div_norm_lt_11_108 F v w d hd hFsym hw hIv
  have hq : ‖(w ⬝ᵥ (F⁻¹ *ᵥ w))/d^2‖ < (8/243 : ℝ) :=
    productFive_quadratic_q_div_norm_lt F w d hd hFsmall hw
  have hpd : ‖(v ⬝ᵥ (F⁻¹ *ᵥ v))/d^2‖ < (1/2916 : ℝ) :=
    productFive_p_div_sq_norm_lt _ d hp h54
  have hprefix : ‖F.det‖ < (33/128 : ℝ) :=
    five_prefix_det_upper_of_mixed_signed_entries f a u S
      hu' hdiag hSsym (fiveSignedEntryGood_prefix f a u S hg)
  change ‖(productFiveSchur F v w d).det‖ < (1/3 : ℝ)
  exact productFive_schur_det_upper_of_bilinear_bounds
    F v w d hFdet hd hFsym hprefix.le hh.le hp.le hq.le hpd.le

/-- The product-five growth lemma for an actual ordered D(1) quintuple in the
full ring of integers of every imaginary quadratic field. -/
theorem IsD1Tuple.productFive_growth
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hB : 3 ≤ ‖phi (a 1 : K)‖) :
    3 * (∏ i : Fin 4, ‖phi (a (Fin.castAdd 1 i) : K)‖) <
      ‖phi (a 4 : K)‖ := by
  have hA : 1 ≤ ‖phi (a 0 : K)‖ :=
    one_le_norm_integer hK phi (ha.2.1 0)
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  obtain ⟨u, S, hu, hdiag, hsym, _hsq, hgood, _hprefix, _hcol⟩ :=
    ha.exists_five_compatible_signed_matrix hK phi a hmon hA hB
  have hnear := ha.five_compatible_schur_near hK phi a hmon hB
    u S hu hdiag hgood
  have hsmall := ha.five_compatible_schur_det_small hK phi a hmon hB
    u S hu hdiag hsym hgood
  have h54 := ha.five_last_modulus_gt_fiftyfour hK phi a hmon hB
  have hd : fiveLastValue (fun i => phi (a i : K)) ≠ 0 := by
    apply norm_pos_iff.mp
    change (0 : ℝ) < ‖phi (a 4 : K)‖
    linarith only [h54]
  exact full_ring_productFive_growth_of_schur_estimates hK phi a S u
    hu hdiag hsym hd hnear hsmall

end D1Bound5
