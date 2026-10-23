import D1Bound5.PellUnitPairBounded
import D1Bound5.TwoSmallLargeSBound
import D1Bound5.TwoSmallLargeTBound

open scoped NumberField
open Module

namespace D1Bound5

/-- In the actual exceptional unit-pair sextuple, the first nonunit
extension has modulus at least eight. The fixed arithmetic model and its
Pell equation supply this lower bound in every imaginary quadratic field. -/
theorem IsD1Tuple.unit_pair_third_norm_ge_eight
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hm : t 0 = -1) (hp : t 1 = 1)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖)) :
    8 ≤ ‖phi (t 2 : K)‖ := by
  obtain ⟨M,hd,_,_,hreal⟩ := ht.unit_pair_finite_field_model hK phi t hm hp hmon
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hw : f M.w*f M.w = -(M.d : ℂ) := by
    simpa only [map_mul,map_neg,map_intCast] using congrArg f M.square
  have hPell : UnitPairPellDescription M.d M.w (t 2) := Or.inl (hreal 0)
  have hlower := UnitPairPellDescription.norm_lower M.d (f M.w) (f (t 2))
    M.positive hw (UnitPairPellDescription.map f M.d M.w (t 2) hPell)
  have hdR : (7 : ℝ) ≤ M.d := by exact_mod_cast hd
  change 8 ≤ ‖f (t 2)‖
  linarith only [hlower,hdR]

/-- The complete Pell graph lower bound and the two actual analytic
large-entry branches force the exceptional unit-pair case into the same
small-fourth/large-fifth region as the nondegenerate small pairs. -/
theorem IsD1Tuple.unit_pair_reduced_range
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hm : t 0 = -1) (hp : t 1 = 1)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖)) :
    8 ≤ ‖phi (t 2 : K)‖ ∧ ‖phi (t 3 : K)‖ < (10 : ℝ)^8 ∧
      (10 : ℝ)^550 < ‖phi (t 4 : K)‖ := by
  have hS8 := ht.unit_pair_third_norm_ge_eight hK phi t hm hp hmon
  have hS3 : 3 ≤ ‖phi (t 2 : K)‖ := by linarith only [hS8]
  have hB3 : ‖phi (t 1 : K)‖ < 3 := by norm_num [hp]
  have hC := ht.unit_pair_fifth_large hK phi t hm hp hmon
  have hCD := hmon (by decide : (4 : Fin 6) ≤ 5)
  have hS : ‖phi (t 2 : K)‖ < (10 : ℝ)^8 := by
    by_contra h
    have hD := (ht.two_small_large_third_bound hK phi t hmon hB3 (le_of_not_gt h)).2
    have hD' : ‖phi (t 5 : K)‖ < (10 : ℝ)^550 := hD.trans_le (pow_le_pow_right₀ (by norm_num : (1 : ℝ) ≤ 10) (by decide : 396 ≤ 550))
    exact (not_lt_of_ge hCD) (hD'.trans hC)
  refine ⟨hS8,?_,hC⟩
  by_contra h
  have hD := (ht.two_small_fourth_bound hK phi t hmon hB3 hS3 hS).2 (le_of_not_gt h)
  have hD' : ‖phi (t 5 : K)‖ < (10 : ℝ)^550 := hD.trans_le (pow_le_pow_right₀ (by norm_num : (1 : ℝ) ≤ 10) (by decide : 549 ≤ 550))
  exact (not_lt_of_ge hCD) (hD'.trans hC)

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.unit_pair_reduced_range
