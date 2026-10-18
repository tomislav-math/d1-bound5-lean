import D1Bound5.BennettTwoIntegralMatrix
import D1Bound5.FullRingBridge
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

open scoped NumberField
open Module

namespace D1Bound5

/-- The actual two-anchor integral linear form. The powers in columns one
and two allow division by the anchors without leaving their integer ring. -/
noncomputable def bennettTwoRowForm {F : Type*} [Field F] [CharZero F]
    (a b c z sA sB : F) (k : ℕ) (i : Fin 3) : F :=
  bennettTwoClearedEntry a b c k i 0*z +
    bennettTwoClearedEntry a b c k i 1*(sA/a) +
      bennettTwoClearedEntry a b c k i 2*(sB/b)

/-- The constructed determinant supplies an actual nonzero row whenever
the terminal root is nonzero. No nonsingularity hypothesis is supplied. -/
theorem bennettTwoRowForm_exists_ne_zero
    {F : Type*} [Field F] [CharZero F]
    (a b c z sA sB : F) (ha : a ≠ 0) (hb : b ≠ 0)
    (hab : a ≠ b) (hz : z ≠ 0) (k : ℕ) (hk : 1 ≤ k) :
    ∃ i : Fin 3, bennettTwoRowForm a b c z sA sB k i ≠ 0 := by
  classical
  let Q := bennettTwoClearedMatrix a b c k
  let v : Fin 3 → F := ![z, sA/a, sB/b]
  have hdet : Q.det ≠ 0 := bennettTwoClearedMatrix_det_ne_zero a b c ha hb hab k hk
  have hunit : IsUnit Q := (Matrix.isUnit_iff_isUnit_det Q).2
    (isUnit_iff_ne_zero.mpr hdet)
  have hinj : Function.Injective Q.mulVec := Matrix.mulVec_injective_iff_isUnit.2 hunit
  by_contra h
  push_neg at h
  have hzero : Q.mulVec v = 0 := by
    funext i
    simpa [Matrix.mulVec, dotProduct, Fin.sum_univ_three, v, Q,
      bennettTwoClearedMatrix, bennettTwoRowForm] using h i
  have hv : v = 0 := hinj (by simpa using hzero)
  have hz' := congrFun hv (0 : Fin 3)
  exact hz (by simpa [v] using hz')

/-- The selected row is the image of an explicitly constructed ring
element. This uses the proved column divisibilities at every positive
order, including k=1. -/
theorem bennettTwoRowForm_lift
    {R F : Type*} [CommRing R] [Field F] [CharZero F]
    (f : R →+* F) (a b c z sA sB : R)
    (ha : f a ≠ 0) (hb : f b ≠ 0) (hab : f a ≠ f b)
    (k : ℕ) (hk : 1 ≤ k) (i : Fin 3) :
    ∃ L : R, f L = bennettTwoRowForm (f a) (f b) (f c) (f z) (f sA) (f sB) k i := by
  obtain ⟨q0, q1, q2, h0, h1, h2⟩ :=
    bennettTwoClearedEntry_row_lift f a b c ha hb hab k hk i
  refine ⟨q0*z + a^(k-1)*q1*sA + b^(k-1)*q2*sB, ?_⟩
  have hpow (x : F) : x^k = x^(k-1)*x := by
    rw [← pow_succ, Nat.sub_add_cancel hk]
  unfold bennettTwoRowForm
  rw [← h0, ← h1, ← h2]
  simp only [map_add, map_mul, map_pow]
  rw [hpow (f a), hpow (f b)]
  field_simp [ha, hb]
  <;> ring

/-- In the full ring of integers of an imaginary quadratic field, an
actual Bennett row has modulus at least one. The determinant and
integrality are both derived from the constructed entries. The root
arguments can be any signed integral lifts obtained from the tuple. -/
theorem full_ring_bennettTwoRowForm_exists_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b c z sA sB : 𝓞 K) (ha : a ≠ 0) (hb : b ≠ 0)
    (hab : a ≠ b) (hz : z ≠ 0) (k : ℕ) (hk : 1 ≤ k) :
    ∃ i : Fin 3, 1 ≤ ‖bennettTwoRowForm (phi (a : K)) (phi (b : K))
      (phi (c : K)) (phi (z : K)) (phi (sA : K)) (phi (sB : K)) k i‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hnonzero (x : 𝓞 K) (hx : x ≠ 0) : f x ≠ 0 := by
    intro h
    apply hx
    apply hf
    simpa only [map_zero] using h
  have hab' : f a ≠ f b := fun h => hab (hf h)
  obtain ⟨i, hi⟩ := bennettTwoRowForm_exists_ne_zero
    (f a) (f b) (f c) (f z) (f sA) (f sB)
    (hnonzero a ha) (hnonzero b hb) hab' (hnonzero z hz) k hk
  obtain ⟨L, hL⟩ := bennettTwoRowForm_lift f a b c z sA sB
    (hnonzero a ha) (hnonzero b hb) hab' k hk i
  have hL0 : L ≠ 0 := by
    intro hzero
    apply hi
    rw [← hL, hzero, map_zero]
  have hbound := one_le_norm_integer hK phi hL0
  change 1 ≤ ‖f L‖ at hbound
  rw [hL] at hbound
  exact ⟨i, hbound⟩

end D1Bound5
