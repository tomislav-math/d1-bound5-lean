import D1Bound5.FiniteN3ExactInterval
import D1Bound5.OneSmallN3BsFixedArithmetic
import D1Bound5.OneSmallFixedPairGeometry

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- The two squared certificates in the fixed table control the coupled
adaptive N3 residual without separately enlarging its two distances. -/
theorem fixed_n3_bs_adaptive_bound (B S delta F : ℝ)
    (hB : 0 ≤ B) (hS : 0 < S) (hd : 0 < delta) (hF : 0 ≤ F)
    (h6 : delta^12/S^12 ≤ F^2)
    (h5 : B^2*delta^10/S^12 ≤ F^2) :
    0 < F ∧ max (delta^6) (B*delta^5) ≤ F*S^6 := by
  have h6' := (div_le_iff₀ (pow_pos hS 12)).mp h6
  have h5' := (div_le_iff₀ (pow_pos hS 12)).mp h5
  have hp : 0 < F := by
    by_contra hn
    have hz : F=0 := le_antisymm (le_of_not_gt hn) hF
    rw [hz] at h6'
    have hh : 0 < delta^12 := pow_pos hd 12
    nlinarith only [h6',hh]
  refine ⟨hp,max_le ?_ ?_⟩
  · apply (sq_le_sq₀ (by positivity) (by positivity)).mp
    nlinarith only [h6']
  · apply (sq_le_sq₀ (by positivity) (by positivity)).mp
    nlinarith only [h5']

/-- The actual fixed-table N3bs interval. The numerator B⁸ in the upper
endpoint is retained, as required by the next overlap in the manuscript. -/
theorem full_ring_finiteN3Bs_fixed_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {U : Finset (𝓞 K)} (hU : IsD1 U) (b s c d : 𝓞 K)
    (hbU : b ∈ U) (hsU : s ∈ U) (hcU : c ∈ U) (hdU : d ∈ U)
    (hbs : b ≠ s) (hbc : b ≠ c) (hsc : s ≠ c)
    (hbd : b ≠ d) (hsd : s ≠ d) (hcd : c ≠ d)
    (hBS : ‖phi (b : K)‖ ≤ ‖phi (s : K)‖)
    (hC1000 : 1000 ≤ ‖phi (c : K)‖)
    (hCS : 200*‖phi (s : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (e : QuadInt r.triple.tau r.triple.nu ≃+* 𝓞 K)
    (sgn conj : Bool)
    (hb : smallExtensionSymmetry sgn conj (e.symm b) = r.triple.anchorB)
    (hs : smallExtensionSymmetry sgn conj (e.symm s) = r.triple.anchorS)
    (hleft : 4*(r.Mbs : ℝ)^2*‖phi (s : K)‖^14*‖phi (c : K)‖^7/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (b : K)‖^8*‖phi (c : K)‖^11/
      (4*(r.Rbs : ℝ)^2*‖phi (s : K)‖^6*(1+1/4000 : ℝ))) : False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let B := ‖f b‖
  let S := ‖f s‖
  let delta := ‖f b-f s‖
  have hB1 : 1 ≤ B := one_le_norm_integer hK phi (hU.1 b hbU)
  have hB : 0 < B := by linarith only [hB1]
  have hS : 0 < S := hB.trans_le hBS
  have hfi : Function.Injective f := by
    intro x y h
    apply NumberField.RingOfIntegers.ext
    exact phi.injective h
  have hd : 0 < delta := norm_pos_iff.mpr (sub_ne_zero.mpr (fun h => hbs (hfi h)))
  have hnorm (w : 𝓞 K) : ‖f w‖^2 =
      ((smallExtensionSymmetry sgn conj (e.symm w)).norm : ℝ) := by
    simpa only [smallExtensionSymmetry_norm,RingEquiv.apply_symm_apply] using
      norm_sq_full_ring_equiv e phi (e.symm w)
  have hBsq : B^2 = (r.b0 : ℝ) := by
    have hh := hnorm b
    rw [hb] at hh
    simpa [OneSmallCutoffRow.b0] using hh
  have hSsq : S^2 = (r.s0 : ℝ) := by
    have hh := hnorm s
    rw [hs] at hh
    simpa [OneSmallCutoffRow.s0] using hh
  have hdsq : delta^2 = (r.dbs : ℝ) := by
    have hh := hnorm (b-s)
    simp only [map_sub,smallExtensionSymmetry_sub,hb,hs] at hh
    simpa [delta,OneSmallCutoffRow.dbs] using hh
  obtain ⟨_,_,_,_,_,_,_,_,hphi,hphi6,hphi5,_,_,_,_,_,_,_,hMbs,_⟩ :=
    oneSmallCutoffRows_valid r hr
  have hF : 0 ≤ (r.phi1 : ℝ) := by exact_mod_cast hphi
  have h6 : delta^12/S^12 ≤ (r.phi1 : ℝ)^2 := by
    have hh : (r.dbs : ℝ)^6/(r.s0 : ℝ)^6 ≤ (r.phi1 : ℝ)^2 := by
      exact_mod_cast hphi6
    rw [←hdsq,←hSsq] at hh
    convert hh using 1 <;> ring
  have h5 : B^2*delta^10/S^12 ≤ (r.phi1 : ℝ)^2 := by
    have hh : (r.b0 : ℝ)*(r.dbs : ℝ)^5/(r.s0 : ℝ)^6 ≤ (r.phi1 : ℝ)^2 := by
      exact_mod_cast hphi5
    rw [←hBsq,←hdsq,←hSsq] at hh
    convert hh using 1 <;> ring
  obtain ⟨hFpos,hmax⟩ := fixed_n3_bs_adaptive_bound B S delta (r.phi1 : ℝ) hB.le hS hd hF h6 h5
  have hReq : (r.Rbs : ℝ) = (3535/409600 : ℝ)*(r.phi1 : ℝ) := by
    simp only [OneSmallCutoffRow.Rbs]
    push_cast
    <;> rfl
  have hRpos : 0 < (r.Rbs : ℝ) := by rw [hReq]; positivity
  have hR : (3535/409600 : ℝ)*max (delta^6) (B*delta^5) ≤ (r.Rbs : ℝ)*S^6 := by
    rw [hReq]
    have hh := mul_le_mul_of_nonneg_left hmax (by norm_num : (0 : ℝ) ≤ 3535/409600)
    simpa only [mul_assoc] using hh
  have hM : 0 < (r.Mbs : ℝ) := by exact_mod_cast hMbs
  obtain ⟨w,hw⟩ := oneSmallCutoffRows_finiteN3BsFixedBound r hr
  have hheight (i : Fin 3) := finiteN3_fixed_height phi r.triple.anchorB r.triple.anchorS
    r.Mbs w hw e sgn conj b s c hb hs (norm_pos_iff.mp hS) hC1000 hCS i
  exact full_ring_finiteN3_exact_interval_of_bounds hK phi hU b s c d
    hbU hsU hcU hdU hbs hbc hsc hbd hsd hcd hBS hC1000 hCS hCD
    (r.Mbs : ℝ) (r.Rbs : ℝ) hM hRpos hheight hR hleft hright

end D1Bound5
