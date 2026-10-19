import D1Bound5.FiniteMBennettIdentity
import D1Bound5.FullRingBridge

open scoped NumberField
open Module

namespace D1Bound5

def finiteMRowForm {R : Type*} [CommRing R]
    (a b s c z rA rB rS : R) (i : Fin 4) : R :=
  (finiteMDividedMatrix a b s c).mulVec ![z,rA,rB,rS] i

@[simp] theorem map_finiteMRowForm {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a b s c z rA rB rS : R) (i : Fin 4) :
    f (finiteMRowForm a b s c z rA rB rS i) =
      finiteMRowForm (f a) (f b) (f s) (f c) (f z) (f rA) (f rB) (f rS) i := by
  simp only [finiteMRowForm,Matrix.mulVec,dotProduct,map_sum,map_mul,map_finiteMDividedMatrix]
  apply Finset.sum_congr rfl
  intro j _
  congr 1
  fin_cases j <;> rfl

theorem finiteMRowForm_exists_ne_zero
    {F : Type*} [Field F] [CharZero F]
    (a b s c z rA rB rS : F)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s) (hz : z ≠ 0) :
    ∃ i : Fin 4, finiteMRowForm a b s c z rA rB rS i ≠ 0 := by
  classical
  let M := finiteMDividedMatrix a b s c
  let v : Fin 4 → F := ![z,rA,rB,rS]
  have hdet : M.det ≠ 0 := finiteMDividedMatrix_det_ne_zero a b s c ha hb hs hab has hbs
  have hu : IsUnit M := (Matrix.isUnit_iff_isUnit_det M).2 (isUnit_iff_ne_zero.mpr hdet)
  have hi : Function.Injective M.mulVec := Matrix.mulVec_injective_iff_isUnit.2 hu
  by_contra h
  push_neg at h
  have hzero : M.mulVec v = 0 := by funext i; exact h i
  have hv : v = 0 := hi (by simpa using hzero)
  exact hz (by simpa [v] using congrFun hv (0 : Fin 4))

/-- An actual integral M row is nonzero because the proved divided
matrix determinant is nonzero. Arbitrary signed root products are
allowed, provided the terminal root is nonzero. -/
theorem full_ring_finiteMRowForm_exists_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b s c z rA rB rS : 𝓞 K)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s) (hz : z ≠ 0) :
    ∃ i : Fin 4, 1 ≤ ‖finiteMRowForm (phi (a : K)) (phi (b : K)) (phi (s : K))
      (phi (c : K)) (phi (z : K)) (phi (rA : K)) (phi (rB : K)) (phi (rS : K)) i‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hn (x : 𝓞 K) (hx : x ≠ 0) : f x ≠ 0 := by
    intro h
    apply hx
    apply hf
    simpa only [map_zero] using h
  obtain ⟨i,hi⟩ := finiteMRowForm_exists_ne_zero
    (f a) (f b) (f s) (f c) (f z) (f rA) (f rB) (f rS)
    (hn a ha) (hn b hb) (hn s hs) (fun h => hab (hf h))
    (fun h => has (hf h)) (fun h => hbs (hf h)) (hn z hz)
  let L := finiteMRowForm a b s c z rA rB rS i
  have hL : f L = finiteMRowForm (f a) (f b) (f s) (f c) (f z) (f rA) (f rB) (f rS) i :=
    map_finiteMRowForm f _ _ _ _ _ _ _ _ i
  have hL0 : L ≠ 0 := by
    intro hzero
    apply hi
    rw [← hL,hzero,map_zero]
  have hbnd := one_le_norm_integer hK phi hL0
  change 1 ≤ ‖f L‖ at hbnd
  rw [hL] at hbnd
  exact ⟨i,hbnd⟩

end D1Bound5
