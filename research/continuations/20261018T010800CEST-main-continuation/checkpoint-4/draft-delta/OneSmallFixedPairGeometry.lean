import D1Bound5.CoherentFixedCutoffGap

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Exact squared moduli and strict distance separation for a normalized
fixed pair in the one-small table. This uses the actual signed or
conjugated elements, so the difference norm keeps its phase information. -/
theorem oneSmall_fixed_pair_geometry
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (phi : K →+* ℂ) (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (e : QuadInt r.triple.tau r.triple.nu ≃+* 𝓞 K)
    (sgn conj : Bool) (x y : 𝓞 K)
    (hx : smallExtensionSymmetry sgn conj (e.symm x) = r.triple.anchorA)
    (hy : smallExtensionSymmetry sgn conj (e.symm y) = r.triple.anchorB) :
    ‖phi (x : K)‖^2 = (r.a0 : ℝ) ∧
    ‖phi (y : K)‖^2 = (r.b0 : ℝ) ∧
    ‖phi (x : K)-phi (y : K)‖^2 = (r.dab : ℝ) ∧
    ‖phi (x : K)‖ < ‖phi (x : K)-phi (y : K)‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f x‖
  let B := ‖f y‖
  let delta := ‖f x-f y‖
  have hnorm (w : 𝓞 K) : ‖f w‖^2 =
      ((smallExtensionSymmetry sgn conj (e.symm w)).norm : ℝ) := by
    simpa only [smallExtensionSymmetry_norm,RingEquiv.apply_symm_apply] using
      norm_sq_full_ring_equiv e phi (e.symm w)
  have hAsq : A^2 = (r.a0 : ℝ) := by
    have hh := hnorm x
    rw [hx] at hh
    simpa [OneSmallCutoffRow.a0] using hh
  have hBsq : B^2 = (r.b0 : ℝ) := by
    have hh := hnorm y
    rw [hy] at hh
    simpa [OneSmallCutoffRow.b0] using hh
  have hdsq : delta^2 = (r.dab : ℝ) := by
    have hh := hnorm (x-y)
    simp only [map_sub,smallExtensionSymmetry_sub,hx,hy] at hh
    simpa [delta,OneSmallCutoffRow.dab] using hh
  obtain ⟨_,hAN,hBN,_⟩ := oneSmallCutoffRows_valid r hr
  have hA2 : A^2 ≤ 2 := by
    rw [hAsq]
    rcases hAN with h | ⟨h,_⟩ <;> exact_mod_cast (show r.a0 ≤ 2 by linarith only [h])
  have hB9 : 9 ≤ B^2 := by rw [hBsq]; exact_mod_cast hBN
  have hAB2 : 2*A < B := by
    have ha : 0 ≤ A := norm_nonneg _
    have hb : 0 ≤ B := norm_nonneg _
    nlinarith only [hA2,hB9,ha,hb]
  have htriangle : B ≤ delta+A := by
    have hh := norm_add_le (f y-f x) (f x)
    rw [sub_add_cancel,norm_sub_rev] at hh
    exact hh
  exact ⟨hAsq,hBsq,hdsq,by linarith only [hAB2,htriangle]⟩

end D1Bound5
