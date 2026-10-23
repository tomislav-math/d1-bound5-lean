import D1Bound5.RationalCutoffHeights
import D1Bound5.FiniteN2HeightRefinement
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- The N2 closed window for the signed rational pair in any imaginary
quadratic full ring; no Gaussian coordinate model is postulated. -/
theorem full_ring_finiteN2_rational_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hC1000 : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (sgn : Bool) (hx : x = if sgn then -1 else 1)
    (hy : y = if sgn then -3 else 3)
    (hleft : 4*(oneSmallCutoffRow_56.M2 : ℝ)^2*‖phi (y : K)‖^8*‖phi (c : K)‖^5/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^7/
      (4*(oneSmallCutoffRow_56.R2 : ℝ)^2*‖phi (y : K)‖^4*(1+1/4000 : ℝ))) : False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f x‖
  let B := ‖f y‖
  let C := ‖f c‖
  let D := ‖f d‖
  let delta := ‖f x-f y‖
  obtain ⟨hAn,hBn,hdn⟩ := rationalCutoff_pair_geometry phi sgn x y hx hy
  change A=1 at hAn
  change B=3 at hBn
  change delta=2 at hdn
  have hA1 : 1 ≤ A := by rw [hAn]
  have hA : 0 < A := by rw [hAn]; norm_num
  have hB : 0 < B := by rw [hBn]; norm_num
  have hC : 0 < C := by change 1000 ≤ C at hC1000; linarith only [hC1000]
  have hXY : A ≤ B := by rw [hAn,hBn]; norm_num
  change 200*B ≤ C at hCY
  change C ≤ D at hCD
  have hXC : 1000 ≤ A*C := by rw [hAn,one_mul]; exact hC1000
  have hmax : max (delta^4) (A*delta^3) = delta^4 := by rw [hdn,hAn]; norm_num
  have hR2 : (oneSmallCutoffRow_56.R2 : ℝ) = (101/2560 : ℝ)*delta^4/B^4 := by
    rw [hdn,hBn]
    have hq : oneSmallCutoffRow_56.R2 = (101/2560 : ℚ)*2^4/3^4 := by decide +kernel
    have hreal := congrArg (fun q : ℚ => (q : ℝ)) hq
    push_cast at hreal
    exact hreal
  have hRpos : 0 < (oneSmallCutoffRow_56.R2 : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.R2 by decide +kernel)
  have hMpos : 0 < (oneSmallCutoffRow_56.M2 : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.M2 by decide +kernel)
  have hheight := finiteN2_rational_height phi sgn x y c hx hy hC1000 hCY
  obtain ⟨z,hz,_,hform⟩ := full_ring_finiteN2_inequalities_of_height hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hXC hCY hCD (oneSmallCutoffRow_56.M2 : ℝ) hheight
  let Z := ‖f z‖
  change 1 < (oneSmallCutoffRow_56.M2 : ℝ)*B^4*C^3/Z+(101/2560 : ℝ)*
    max (delta^4) (A*delta^3)*Z/(A^3*B^2*C^4) at hform
  rw [hmax] at hform
  have hZ : 0 < Z := by
    by_contra h
    have hz0 : Z=0 := le_antisymm (le_of_not_gt h) (norm_nonneg _)
    rw [hz0] at hform
    norm_num at hform
  have hform' : 1 < (oneSmallCutoffRow_56.M2 : ℝ)*B^4*C^3/Z+(oneSmallCutoffRow_56.R2 : ℝ)*B^2*Z/(A^3*C^4) := by
    rw [hR2]
    convert hform using 1 <;> field_simp [hA.ne',hB.ne',hC.ne',hZ.ne'] <;> ring
  have hAD : 4*A ≤ D := by linarith only [hXY,hCY,hCD,hB]
  have hCD4000 : 4000 ≤ C*D := by
    have hm := mul_le_mul_of_nonneg_left hAD hC.le
    nlinarith only [hm,hXC]
  have hzC : (f z)^2 = f c*f d+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz
  obtain ⟨hrootlo,hroothi⟩ := finite_tuple_root_relative_norm (f c) (f d) (f z) hzC hCD4000
  let U := (oneSmallCutoffRow_56.M2 : ℝ)*B^4*C^3
  let V := (oneSmallCutoffRow_56.R2 : ℝ)*B^2/(A^3*C^4)
  have hU : 0 < U := by dsimp [U]; positivity
  have hV : 0 < V := by dsimp [V]; positivity
  have hf : 1 < U/Z+V*Z := by convert hform' using 1 <;> dsimp [U,V] <;> ring
  have heqlo : 4*U^2/(C*(1-1/4000 : ℝ)) =
      4*(oneSmallCutoffRow_56.M2 : ℝ)^2*B^8*C^5/(1-1/4000 : ℝ) := by
    dsimp [U]
    field_simp [hC.ne']
    <;> ring
  have heqhi : 1/(4*V^2*C*(1+1/4000 : ℝ)) =
      A^6*C^7/(4*(oneSmallCutoffRow_56.R2 : ℝ)^2*B^4*(1+1/4000 : ℝ)) := by
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
    change C^7 ≤ A^6*C^7
    simpa only [one_mul] using mul_le_mul_of_nonneg_right hA6 (pow_nonneg hC.le 7)

end D1Bound5
