import D1Bound5.FiveRegionRetainedScalar
import D1Bound5.CoherentRetainedMixedTuple

open scoped NumberField
open Module

namespace D1Bound5

theorem fiveRegion_case_disjunction (r : Fin 5) (A B : ℝ) (h : FiveRegionCase r A B) :
    (A^2=1 ∧ 8 ≤ B) ∨ (A^2=2 ∧ 4 ≤ B) ∨ A^2=3 ∨ A^2=4 ∨ 5 ≤ A^2 := by
  fin_cases r <;> norm_num [FiveRegionCase,fiveRegionMinNorm,fiveRegionMinB] at h
  · exact Or.inl h
  · exact Or.inr (Or.inl h)
  · exact Or.inr (Or.inr (Or.inl h.1))
  · exact Or.inr (Or.inr (Or.inr (Or.inl h.1)))
  · exact Or.inr (Or.inr (Or.inr (Or.inr h.1)))

theorem phaseVandermondeRatio_le_ratio_triangle (a b s : ℂ) (r : ℝ)
    (hr : 0 ≤ r) (hB : 0 < ‖b‖) (hBS : ‖b‖ ≤ ‖s‖) (hAB : ‖a‖ ≤ r*‖b‖) :
    phaseVandermondeRatio a b s ≤ 2*(1+r)^2 := by
  have hS : 0 < ‖s‖ := hB.trans_le hBS
  have h01 : ‖a-b‖ ≤ (1+r)*‖b‖ := by
    have hh := norm_sub_le a b
    nlinarith only [hh,hAB]
  have h02 : ‖a-s‖ ≤ (1+r)*‖s‖ := by
    have hh := norm_sub_le a s
    have hh' := mul_le_mul_of_nonneg_left hBS hr
    nlinarith only [hh,hAB,hh']
  have h12 : ‖b-s‖ ≤ 2*‖s‖ := by
    have hh := norm_sub_le b s
    linarith only [hh,hBS]
  have hprod : ‖(a-b)*(a-s)*(b-s)‖ ≤ 2*(1+r)^2*(‖b‖*‖s‖^2) := by
    calc
      _ = ‖a-b‖*‖a-s‖*‖b-s‖ := by rw [norm_mul,norm_mul]
      _ ≤ ((1+r)*‖b‖)*((1+r)*‖s‖)*(2*‖s‖) := by gcongr
      _ = _ := by ring
  exact (div_le_iff₀ (by positivity : 0 < ‖b‖*‖s‖^2)).mpr hprod

/-- The actual five-entry retained form and coupled complex phase give
both monomial gaps for each unbounded first-pair region. -/
theorem IsD1Tuple.five_region_retained_gaps
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (r : Fin 5) (hN8 : ‖phi (a 0 : K)‖^2 ≤ 8)
    (hcase : FiveRegionCase r ‖phi (a 0 : K)‖ ‖phi (a 1 : K)‖) :
    let A := ‖phi (a 0 : K)‖
    let B := ‖phi (a 1 : K)‖
    let S := ‖phi (a 2 : K)‖
    let C := ‖phi (a 4 : K)‖
    fiveRegionGap r*(A^7*B^5*S^3) < C ∧
      (fiveRegionCoupledGap r*((3535/409600 : ℝ)*phasePhi
        (phi (a 1 : K)) (phi (a 2 : K))))*(A^7*B^5*S^3) < C := by
  classical
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f (a 0)‖
  let B := ‖f (a 1)‖
  let S := ‖f (a 2)‖
  let T := ‖f (a 3)‖
  let C := ‖f (a 4)‖
  let R := phaseVandermondeRatio (f (a 0)) (f (a 1)) (f (a 2))
  have hA : 1 ≤ A := one_le_norm_integer hK phi (ha.2.1 0)
  have hAB : A ≤ B := hmon (by decide : (0 : Fin 5) ≤ 1)
  have hBS : B ≤ S := hmon (by decide : (1 : Fin 5) ≤ 2)
  have hc := fiveRegion_case_bounds r A B (norm_nonneg _) hN8 hcase
  have hB : 0 < B := by linarith only [hc.2.2.2.1]
  have hS : 0 < S := hB.trans_le hBS
  let i4 : Fin 4 → Fin 5 := ![0,1,2,3]
  have hi4 : Function.Injective i4 := by decide
  have hm4 : Monotone i4 := by decide
  have h4 : IsD1Tuple (fun j => a (i4 j)) :=
    ⟨ha.1.comp hi4,fun j => ha.2.1 (i4 j),fun j k hjk => ha.2.2 (i4 j) (i4 k) (hi4.ne hjk)⟩
  have hrows := IsD1Tuple.frontier_small_norm_growth hK phi (fun j => a (i4 j))
    h4 (hmon.comp hm4) hN8
  have hfront : fiveRegionFrontier r*A*B*S < T := by
    fin_cases r <;> norm_num [FiveRegionCase,fiveRegionMinNorm,fiveRegionMinB] at hcase
    · exact hrows.1 hcase.1 hcase.2
    · exact hrows.2.1 hcase.1 hcase.2
    · exact hrows.2.2.1 hcase.1 hcase.2
    · exact hrows.2.2.2.1 hcase.1 hcase.2
    · exact hrows.2.2.2.2 hcase.1 hcase.2
  have hret := ha.small_norm_retained_gap hK phi a hmon hN8 hc.2.2.2.1
    (fiveRegion_case_disjunction r A B hcase) 48 (19/200) 15 (Or.inr ⟨rfl,rfl,rfl⟩)
  have hret' : (9999/10000 : ℝ)*(200/19)^2*
      (1/R-(51051/400000 : ℝ)/(A^2*B^2))^2*(A^2*T^5/S^2) < C := by
    convert hret.1 using 1 <;>
      dsimp [R,phaseVandermondeRatio,coherentVandermonde3,A,B,S,T,C,f] <;> ring
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hR : 0 < R := by
    dsimp [R,phaseVandermondeRatio]
    apply div_pos _ (by positivity)
    apply norm_pos_iff.mpr
    exact mul_ne_zero (mul_ne_zero
      (sub_ne_zero.mpr ((hf.comp ha.1).ne (by decide : (0 : Fin 5) ≠ 1)))
      (sub_ne_zero.mpr ((hf.comp ha.1).ne (by decide : (0 : Fin 5) ≠ 2))))
      (sub_ne_zero.mpr ((hf.comp ha.1).ne (by decide : (1 : Fin 5) ≠ 2)))
  have hRQ : R ≤ fiveRegionTriangle r := phaseVandermondeRatio_le_ratio_triangle
    (f (a 0)) (f (a 1)) (f (a 2)) (fiveRegionAnchorRatio r)
    (fiveRegionAnchorRatio_nonneg r) hB hBS hc.2.2.2.2.2
  have hphase := coupled_phase_row_bound (f (a 0)) (f (a 1)) (f (a 2))
    (fiveRegionQ r) (fiveRegionPhase r) (fiveRegion_parameters r).2.2.2.2.2.2.2.2.2.2.2.2.2
    hB hBS hc.2.2.2.2.1
  exact fiveRegion_retained_scalar r A B S T C R (phasePhi (f (a 1)) (f (a 2)))
    hA hc.2.2.1 hBS hR hRQ (by unfold phasePhi; positivity) hphase hfront hret'

end D1Bound5
