import D1Bound5.OneSmallN2FixedHeight
import D1Bound5.FiniteN2HeightRefinement
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- The actual fixed-pair N2 interval, using the printed evaluated
coefficient M2 and exact distance-sensitive residual R2. The upper
endpoint is weakened only by the proved integral inequality A≥1. -/
theorem full_ring_finiteN2_fixed_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hC1000 : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (e : QuadInt r.triple.tau r.triple.nu ≃+* 𝓞 K)
    (sgn conj : Bool)
    (hx : smallExtensionSymmetry sgn conj (e.symm x) = r.triple.anchorA)
    (hy : smallExtensionSymmetry sgn conj (e.symm y) = r.triple.anchorB)
    (hleft : 4*(r.M2 : ℝ)^2*‖phi (y : K)‖^8*‖phi (c : K)‖^5/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^7/
      (4*(r.R2 : ℝ)^2*‖phi (y : K)‖^4*(1+1/4000 : ℝ))) : False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f x‖
  let B := ‖f y‖
  let C := ‖f c‖
  let D := ‖f d‖
  let delta := ‖f x-f y‖
  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (hS.1 x hxS)
  have hA : 0 < A := by linarith only [hA1]
  have hB : 0 < B := hA.trans_le hXY
  have hC : 0 < C := by change 1000 ≤ C at hC1000; linarith only [hC1000]
  change A ≤ B at hXY
  change 200*B ≤ C at hCY
  change C ≤ D at hCD
  have hXC : 1000 ≤ A*C := by nlinarith only [hA1,hC1000]
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
  obtain ⟨hcut,hAN,hBN,hBSN,hq,hqle,hq1,hDq,hphi,hphi6,hphi5,hsep,hcoef,hM2,hrest⟩ :=
    oneSmallCutoffRows_valid r hr
  have hA2 : A^2 ≤ 2 := by
    rw [hAsq]
    rcases hAN with h | ⟨h,_⟩ <;> exact_mod_cast (show r.a0 ≤ 2 by linarith only [h])
  have hB9 : 9 ≤ B^2 := by rw [hBsq]; exact_mod_cast hBN
  have hAB2 : 2*A < B := by nlinarith only [hA2,hB9,hA,hB]
  have htriangle : B ≤ delta+A := by
    have hh := norm_add_le (f y-f x) (f x)
    rw [sub_add_cancel,norm_sub_rev] at hh
    exact hh
  have hdelta : A < delta := by linarith only [hAB2,htriangle]
  have hdpos : 0 < delta := hA.trans hdelta
  have hmax : max (delta^4) (A*delta^3) = delta^4 := by
    apply max_eq_left
    have hh := mul_le_mul_of_nonneg_right hdelta.le (pow_nonneg hdpos.le 3)
    nlinarith only [hh]
  have hR2 : (r.R2 : ℝ) = (101/2560 : ℝ)*delta^4/B^4 := by
    simp only [OneSmallCutoffRow.R2]
    push_cast
    rw [←hdsq,←hBsq]
    field_simp [hB.ne']
    <;> ring
  have hRpos : 0 < (r.R2 : ℝ) := by rw [hR2]; positivity
  have hMpos : 0 < (r.M2 : ℝ) := by exact_mod_cast hM2
  have hheight (i : Fin 3) := finiteN2_fixed_height phi r hr e sgn conj x y c hx hy
    (norm_pos_iff.mp hB) hC1000 hCY i
  obtain ⟨z,hz,_,hform⟩ := full_ring_finiteN2_inequalities_of_height hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hXC hCY hCD (r.M2 : ℝ) hheight
  let Z := ‖f z‖
  change 1 < (r.M2 : ℝ)*B^4*C^3/Z+(101/2560 : ℝ)*
    max (delta^4) (A*delta^3)*Z/(A^3*B^2*C^4) at hform
  rw [hmax] at hform
  have hZ : 0 < Z := by
    by_contra h
    have hz0 : Z=0 := le_antisymm (le_of_not_gt h) (norm_nonneg _)
    rw [hz0] at hform
    norm_num at hform
  have hform' : 1 < (r.M2 : ℝ)*B^4*C^3/Z+(r.R2 : ℝ)*B^2*Z/(A^3*C^4) := by
    rw [hR2]
    convert hform using 1 <;> field_simp [hA.ne',hB.ne',hC.ne',hZ.ne'] <;> ring
  have hAD : 4*A ≤ D := by linarith only [hXY,hCY,hCD,hB]
  have hCD4000 : 4000 ≤ C*D := by
    have hm := mul_le_mul_of_nonneg_left hAD hC.le
    nlinarith only [hm,hXC]
  have hzC : (f z)^2 = f c*f d+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz
  obtain ⟨hrootlo,hroothi⟩ := finite_tuple_root_relative_norm (f c) (f d) (f z) hzC hCD4000
  let U := (r.M2 : ℝ)*B^4*C^3
  let V := (r.R2 : ℝ)*B^2/(A^3*C^4)
  have hU : 0 < U := by dsimp [U]; positivity
  have hV : 0 < V := by dsimp [V]; positivity
  have hf : 1 < U/Z+V*Z := by convert hform' using 1 <;> dsimp [U,V] <;> ring
  have heqlo : 4*U^2/(C*(1-1/4000 : ℝ)) =
      4*(r.M2 : ℝ)^2*B^8*C^5/(1-1/4000 : ℝ) := by
    dsimp [U]
    field_simp [hC.ne']
    <;> ring
  have heqhi : 1/(4*V^2*C*(1+1/4000 : ℝ)) =
      A^6*C^7/(4*(r.R2 : ℝ)^2*B^4*(1+1/4000 : ℝ)) := by
    dsimp [V]
    field_simp [hA.ne',hB.ne',hC.ne',hRpos.ne']
    <;> ring
  apply finite_closed_window_incompatible C D Z U V (1/4000) hC hZ hU hV
    (by norm_num) (by norm_num) hrootlo hroothi hf
  · rw [heqlo]
    exact hleft
  · rw [heqhi]
    apply hright.trans
    have hA6 : 1 ≤ A^6 := by
      have hh : (1 : ℝ)^6 ≤ A^6 := by gcongr
      simpa using hh
    apply div_le_div_of_nonneg_right _ (by positivity)
    simpa only [one_mul] using mul_le_mul_of_nonneg_right hA6 (pow_nonneg hC.le 7)

end D1Bound5

#print axioms D1Bound5.full_ring_finiteN2_fixed_interval_excluded
