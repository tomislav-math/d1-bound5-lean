import D1Bound5.PellFiniteFields
import D1Bound5.UnitPairFieldBound

open scoped NumberField
open Module

namespace D1Bound5

/-- The complete finite norm-two Pell exclusion in every eligible full ring.
All 1016 parameters and all ordinary convergents to radius 10^550 are
covered by the kernel-certified data imported above. -/
theorem full_ring_unit_pair_pell_no_three_bounded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (M : UnitPairArithmeticModel (𝓞 K))
    (hd : 7 ≤ M.d) (hupper : M.d < 10000) (hmod : M.d % 8 = 7)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hreal : ∀ i, UnitPairRealDescription M.d (t i))
    (hbound : ∀ i, ‖phi (t i : K)‖^2 ≤ (10 : ℝ)^1100) : False := by
  obtain ⟨C⟩ := pellFiniteCertificate_exists M.d hd hupper hmod M.squarefree
  apply C.full_ring_no_three hK phi M hd (by norm_num) t ht hreal
  intro i
  have hp : (((10 : ℤ)^275 : ℤ) : ℝ)^4 = (10 : ℝ)^1100 := by
    rw [Int.cast_pow]
    norm_num only [Int.cast_ofNat]
    rw [← pow_mul]
    rfl
  simpa only [hp] using hbound i

/-- Actual ordered sextuples containing {-1,1} have their fifth entry beyond
radius 10^550. The field restriction and the real-axis reduction are derived
from the sextuple itself; no field list or Pell-completeness assumption is
left at this endpoint. -/
theorem IsD1Tuple.unit_pair_fifth_large
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hm : t 0 = -1) (hp : t 1 = 1)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖)) :
    (10 : ℝ)^550 < ‖phi (t 4 : K)‖ := by
  by_contra hbig
  have hsmall : ‖phi (t 4 : K)‖ ≤ (10 : ℝ)^550 := le_of_not_gt hbig
  obtain ⟨M,hd,hupper,hmod,hreal⟩ := ht.unit_pair_finite_field_model hK phi t hm hp hmon
  let e : Fin 3 → Fin 6 := fun i => ⟨i.val+2,by omega⟩
  let s : Fin 3 → 𝓞 K := fun i => t (e i)
  have he : Function.Injective e := by
    intro i j hij
    apply Fin.ext
    have hv := congrArg Fin.val hij
    dsimp [e] at hv
    omega
  have hs : IsD1Tuple s := by
    refine ⟨ht.1.comp he,fun i => ht.2.1 (e i),?_⟩
    intro i j hij
    exact ht.2.2 (e i) (e j) (fun h => hij (he h))
  apply full_ring_unit_pair_pell_no_three_bounded hK phi M hd hupper hmod s hs
  · intro i
    simpa only [s,e] using hreal i.castSucc
  · intro i
    have hi : e i ≤ (4 : Fin 6) := by change i.val+2 ≤ 4; omega
    have hlo : ‖phi (s i : K)‖ ≤ (10 : ℝ)^550 :=
      (hmon hi).trans hsmall
    have hnorm := norm_nonneg (phi (s i : K))
    have hpow : 0 ≤ (10 : ℝ)^550 := by positivity
    have hprod := mul_nonneg (sub_nonneg.mpr hlo) (add_nonneg hpow hnorm)
    have heq : ((10 : ℝ)^550)^2 = (10 : ℝ)^1100 := by rw [← pow_mul]; rfl
    nlinarith only [hprod,heq]

end D1Bound5
