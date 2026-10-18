import D1Bound5.FullRingUnitPairPell
import Mathlib.Algebra.Group.Int.Units
import Mathlib.Tactic.GCongr

namespace D1Bound5

theorem UnitPairPellDescription.map {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (d : ℤ) (w z : R) (h : UnitPairPellDescription d w z) :
    UnitPairPellDescription d (f w) (f z) := by
  rcases h with h | h
  · left
    obtain ⟨u,v,hv,hPell,hplus | hminus⟩ := h
    · exact ⟨u,v,hv,hPell,Or.inl (by rw [hplus,map_intCast])⟩
    · exact ⟨u,v,hv,hPell,Or.inr (by rw [hminus,map_neg,map_intCast])⟩
  · right
    obtain ⟨u,v,hv,hPell,hz⟩ := h
    exact ⟨u,v,hv,hPell,by rw [hz,map_mul,map_intCast]⟩

private theorem unit_pair_norm_two_d_ne_one (u v : ℤ) : u^2-v^2 ≠ 2 := by
  intro h
  have hm := congrArg (fun a : ℤ => a % 4) h
  have hu0 : 0 ≤ u % 4 := Int.emod_nonneg _ (by decide)
  have hu4 : u % 4 < 4 := Int.emod_lt_of_pos _ (by decide)
  have hv0 : 0 ≤ v % 4 := Int.emod_nonneg _ (by decide)
  have hv4 : v % 4 < 4 := Int.emod_lt_of_pos _ (by decide)
  interval_cases hu : u % 4 <;> interval_cases hv : v % 4 <;>
    norm_num [Int.sub_emod,pow_two,Int.mul_emod,hu,hv] at hm

private theorem unit_pair_norm_one_d_ne_one (u v : ℤ) (hv : v ≠ 0) : u^2-v^2 ≠ 1 := by
  intro h
  have hp : (u-v)*(u+v) = 1 := by nlinarith only [h]
  have hu : IsUnit (u-v) := isUnit_of_dvd_one ⟨u+v,hp.symm⟩
  have hcases : u-v = 1 ∨ u-v = -1 := Int.isUnit_iff.mp hu
  rcases hcases with hc | hc
  · have hu : u = v+1 := by omega
    rw [hu] at h
    have hzero : v = 0 := by nlinarith only [h]
    exact hv hzero
  · have hu : u = v-1 := by omega
    rw [hu] at h
    have hzero : v = 0 := by nlinarith only [h]
    exact hv hzero

/-- The Gaussian parameter admits no nonzero unit-pair extension in
either Pell branch. This is independent of any growth or finite search. -/
theorem UnitPairPellDescription.two_le_parameter
    {R : Type*} [Ring R] (d : ℤ) (w z : R) (hd : 0 < d)
    (h : UnitPairPellDescription d w z) : 2 ≤ d := by
  by_contra hh
  have hd1 : d = 1 := by omega
  subst d
  rcases h with ⟨u,v,_,hPell,_⟩ | ⟨u,v,hv,hPell,_⟩
  · exact unit_pair_norm_two_d_ne_one u v (by simpa only [one_mul] using hPell)
  · exact unit_pair_norm_one_d_ne_one u v hv (by simpa only [one_mul] using hPell)

/-- Both actual Pell alternatives have modulus at least d+1. The imaginary
case uses the identity |2uv sqrt(-d)|²=4dv²(dv²+1). -/
theorem UnitPairPellDescription.norm_lower
    (d : ℤ) (w z : ℂ) (hd : 0 < d) (hw : w*w = -(d : ℂ))
    (h : UnitPairPellDescription d w z) : (d : ℝ)+1 ≤ ‖z‖ := by
  have hdR : (0 : ℝ) < (d : ℝ) := by exact_mod_cast hd
  have hd1 : (1 : ℝ) ≤ (d : ℝ) := by exact_mod_cast (show (1:ℤ)≤d by omega)
  have hnormInt (n : ℤ) : ‖(n : ℂ)‖ = |(n : ℝ)| := by
    rw [← Complex.ofReal_intCast]
    simp only [Complex.norm_real,Real.norm_eq_abs]
  have hnw : ‖w‖^2 = (d : ℝ) := by
    have hh := congrArg norm hw
    rw [norm_mul,norm_neg,hnormInt,abs_of_pos hdR] at hh
    nlinarith only [hh]
  have hvone (v : ℤ) (hv : v ≠ 0) : (1 : ℝ) ≤ (v : ℝ)^2 := by
    have hh : (1 : ℤ) ≤ v^2 := by have := sq_pos_of_ne_zero hv; omega
    exact_mod_cast hh
  rcases h with hreal | himag
  · obtain ⟨u,v,hv,_,hplus | hminus⟩ := hreal
    all_goals
      have hprod : (d : ℝ) ≤ (d : ℝ)*(v : ℝ)^2 := by
        simpa only [mul_one] using mul_le_mul_of_nonneg_left (hvone v hv) hdR.le
      have hpos : 0 ≤ ((d*v^2+1 : ℤ) : ℝ) := by push_cast; linarith only [hprod,hdR]
    · rw [hplus,hnormInt,abs_of_nonneg hpos]
      push_cast
      linarith only [hprod]
    · rw [hminus,norm_neg,hnormInt,abs_of_nonneg hpos]
      push_cast
      linarith only [hprod]
  · obtain ⟨u,v,hv,hPell,hz⟩ := himag
    have hPellR : (u : ℝ)^2-(d : ℝ)*(v : ℝ)^2 = 1 := by exact_mod_cast hPell
    let t : ℝ := (d : ℝ)*(v : ℝ)^2
    have htd : (d : ℝ) ≤ t := by
      dsimp [t]
      simpa only [mul_one] using mul_le_mul_of_nonneg_left (hvone v hv) hdR.le
    have ht0 : 0 ≤ t := hdR.le.trans htd
    have hnz : ‖z‖^2 = 4*t*(t+1) := by
      rw [hz,norm_mul,mul_pow,hnormInt,sq_abs,hnw]
      push_cast
      dsimp [t]
      linear_combination 4*(d : ℝ)*(v : ℝ)^2*hPellR
    have hbase : ((d : ℝ)+1)^2 ≤ 4*(d : ℝ)*((d : ℝ)+1) := by
      nlinarith [sq_nonneg (d : ℝ)]
    have hmono : 4*(d : ℝ)*((d : ℝ)+1) ≤ 4*t*(t+1) := by gcongr
    apply (sq_le_sq₀ (by positivity : 0 ≤ (d : ℝ)+1) (norm_nonneg z)).mp
    rw [hnz]
    exact hbase.trans hmono

open scoped NumberField
open Module

/-- One fixed positive squarefree field parameter controls all nonzero
common extensions of {-1,1}; every such extension forces d≥2 and modulus≥d+1. -/
theorem full_ring_unit_pair_pell_model_bounds
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ) :
    ∃ d : ℤ, 0 < d ∧ Squarefree d ∧
      ∃ w : 𝓞 K, w*w = -(d : 𝓞 K) ∧
        ∀ z r s : 𝓞 K, z ≠ 0 → r*r = z+1 → s*s = 1-z →
          UnitPairPellDescription d w z ∧ 2 ≤ d ∧ (d : ℝ)+1 ≤ ‖phi (z : K)‖ := by
  obtain ⟨d,hd,hsq,w,hw,hmodel⟩ := full_ring_unit_pair_pell_model hK
  refine ⟨d,hd,hsq,w,hw,?_⟩
  intro z r s hz hr hs
  have h := hmodel z r s hz hr hs
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hw' : f w*f w = -(d : ℂ) := by
    simpa only [map_mul,map_neg,map_intCast] using congrArg f hw
  exact ⟨h,UnitPairPellDescription.two_le_parameter d w z hd h,
    UnitPairPellDescription.norm_lower d (f w) (f z) hd hw'
      (UnitPairPellDescription.map f d w z h)⟩

end D1Bound5
