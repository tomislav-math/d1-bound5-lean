import D1Bound5.FiniteQMatrix
import D1Bound5.FullRingBridge
import Mathlib.Tactic.FinCases

open scoped NumberField
open Module

namespace D1Bound5

variable {R S : Type*} [CommRing R] [CommRing S]

@[simp] theorem map_finiteQLeft (f : R →+* S) (u v c : R) :
    f (finiteQLeft u v c) = finiteQLeft (f u) (f v) (f c) := by
  simp [finiteQLeft]

@[simp] theorem map_finiteQRight (f : R →+* S) (u v c : R) :
    f (finiteQRight u v c) = finiteQRight (f u) (f v) (f c) := by
  simp [finiteQRight]

@[simp] theorem map_finiteQConstant (f : R →+* S) (u v c : R) :
    f (finiteQConstant u v c) = finiteQConstant (f u) (f v) (f c) := by
  simp [finiteQConstant]

@[simp] theorem map_finiteQDividedMatrix (f : R →+* S)
    (a b s t c : R) (i j : Fin 5) :
    f (finiteQDividedMatrix a b s t c i j) =
      finiteQDividedMatrix (f a) (f b) (f s) (f t) (f c) i j := by
  fin_cases i <;> fin_cases j <;> simp [finiteQDividedMatrix]

/-- The actual integral form supplied by each row of the finite Q family.
The root products are inputs in the original ring, so integrality is
preserved without division by anchors. -/
def finiteQRowForm (a b s t c z rA rB rS rT : R) (i : Fin 5) : R :=
  (finiteQDividedMatrix a b s t c).mulVec ![z, rA, rB, rS, rT] i

@[simp] theorem map_finiteQRowForm (f : R →+* S)
    (a b s t c z rA rB rS rT : R) (i : Fin 5) :
    f (finiteQRowForm a b s t c z rA rB rS rT i) =
      finiteQRowForm (f a) (f b) (f s) (f t) (f c)
        (f z) (f rA) (f rB) (f rS) (f rT) i := by
  simp only [finiteQRowForm, Matrix.mulVec, dotProduct, map_sum, map_mul,
    map_finiteQDividedMatrix]
  apply Finset.sum_congr rfl
  intro j _
  congr 1
  fin_cases j <;> rfl

/-- The actual finite determinant selects a nonzero row from a nonzero
terminal root, independently of the choice of signed product roots. -/
theorem finiteQRowForm_exists_ne_zero
    {F : Type*} [Field F] [CharZero F]
    (a b s t c z rA rB rS rT : F)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (ht : t ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hat : a ≠ t)
    (hbs : b ≠ s) (hbt : b ≠ t) (hst : s ≠ t) (hz : z ≠ 0) :
    ∃ i : Fin 5, finiteQRowForm a b s t c z rA rB rS rT i ≠ 0 := by
  classical
  let Q := finiteQDividedMatrix a b s t c
  let v : Fin 5 → F := ![z, rA, rB, rS, rT]
  have hdet : Q.det ≠ 0 := finiteQDividedMatrix_det_ne_zero a b s t c
    ha hb hs ht hab has hat hbs hbt hst
  have hunit : IsUnit Q := (Matrix.isUnit_iff_isUnit_det Q).2
    (isUnit_iff_ne_zero.mpr hdet)
  have hinj : Function.Injective Q.mulVec := Matrix.mulVec_injective_iff_isUnit.2 hunit
  by_contra h
  push_neg at h
  have hzero : Q.mulVec v = 0 := by
    funext i
    exact h i
  have hv : v = 0 := hinj (by simpa using hzero)
  exact hz (by simpa [v] using congrFun hv (0 : Fin 5))

/-- Full-ring arithmetic lower bound for one actual finite Q row. The
selected row is an integer polynomial combination of the supplied roots,
and its nonvanishing comes from the explicit determinant above. -/
theorem full_ring_finiteQRowForm_exists_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b s t c z rA rB rS rT : 𝓞 K)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (ht : t ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hat : a ≠ t)
    (hbs : b ≠ s) (hbt : b ≠ t) (hst : s ≠ t) (hz : z ≠ 0) :
    ∃ i : Fin 5, 1 ≤ ‖finiteQRowForm
      (phi (a : K)) (phi (b : K)) (phi (s : K)) (phi (t : K)) (phi (c : K))
      (phi (z : K)) (phi (rA : K)) (phi (rB : K)) (phi (rS : K)) (phi (rT : K)) i‖ := by
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
  obtain ⟨i, hi⟩ := finiteQRowForm_exists_ne_zero
    (f a) (f b) (f s) (f t) (f c) (f z) (f rA) (f rB) (f rS) (f rT)
    (hnonzero a ha) (hnonzero b hb) (hnonzero s hs) (hnonzero t ht)
    (fun h => hab (hf h)) (fun h => has (hf h)) (fun h => hat (hf h))
    (fun h => hbs (hf h)) (fun h => hbt (hf h)) (fun h => hst (hf h)) (hnonzero z hz)
  let L := finiteQRowForm a b s t c z rA rB rS rT i
  have hL : f L = finiteQRowForm (f a) (f b) (f s) (f t) (f c)
      (f z) (f rA) (f rB) (f rS) (f rT) i := map_finiteQRowForm f _ _ _ _ _ _ _ _ _ _ i
  have hL0 : L ≠ 0 := by
    intro hzero
    apply hi
    rw [← hL, hzero, map_zero]
  have hbound := one_le_norm_integer hK phi hL0
  change 1 ≤ ‖f L‖ at hbound
  rw [hL] at hbound
  exact ⟨i, hbound⟩

end D1Bound5
