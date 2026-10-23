import D1Bound5.UnitPairRealReduction
import D1Bound5.UnitPairFirstExtensionBound

open scoped NumberField
open Module

namespace D1Bound5

/-- The exact finite-field reduction for the exceptional unit pair.
The field range, parity and real Pell alternatives are derived from the
actual sextuple; the retained model supplies the same parameter for all
negative integer-square tests in the later graph certificate. -/
theorem IsD1Tuple.unit_pair_finite_field_model
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hm : t 0 = -1) (hp : t 1 = 1)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖)) :
    ∃ M : UnitPairArithmeticModel (𝓞 K),
      7 ≤ M.d ∧ M.d < 10000 ∧ M.d % 8 = 7 ∧
      ∀ i : Fin 4, UnitPairRealDescription M.d (t ⟨i.val+2,by omega⟩) := by
  obtain ⟨M,hmod,hreal⟩ := full_ring_unit_pair_four_real_model hK phi t ht hm hp
  have hsmall := ht.unit_pair_first_extension_lt hK phi t hm hp hmon
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hw : f M.w*f M.w = -(M.d : ℂ) := by
    simpa only [map_mul,map_neg,map_intCast] using congrArg f M.square
  have hPell : UnitPairPellDescription M.d M.w (t 2) := Or.inl (hreal 0)
  have hlower := UnitPairPellDescription.norm_lower M.d (f M.w) (f (t 2))
    M.positive hw (UnitPairPellDescription.map f M.d M.w (t 2) hPell)
  change ‖f (t 2)‖ < 10000 at hsmall
  have hdR : (M.d : ℝ) < 10000 := by linarith only [hlower,hsmall]
  have hdmax : M.d < 10000 := by exact_mod_cast hdR
  have hdmin : 7 ≤ M.d := by have := M.positive; omega
  exact ⟨M,hdmin,hdmax,hmod,hreal⟩

end D1Bound5
