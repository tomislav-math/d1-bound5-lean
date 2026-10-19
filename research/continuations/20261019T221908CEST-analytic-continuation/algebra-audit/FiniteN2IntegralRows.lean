import D1Bound5.FiniteN2Matrix
import D1Bound5.FullRingBridge

open scoped NumberField
open Module

namespace D1Bound5

variable {R S : Type*} [CommRing R] [CommRing S]

@[simp] theorem map_finiteN2Constant (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteN2Constant x y c i) = finiteN2Constant (f x) (f y) (f c) i := by
  fin_cases i <;> simp [finiteN2Constant, map_ofNat]

@[simp] theorem map_finiteN2Left (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteN2Left x y c i) = finiteN2Left (f x) (f y) (f c) i := by
  fin_cases i <;> simp [finiteN2Left, map_ofNat]

@[simp] theorem map_finiteN2Right (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteN2Right x y c i) = finiteN2Right (f x) (f y) (f c) i := by
  fin_cases i <;> simp [finiteN2Right, map_ofNat]

@[simp] theorem map_finiteN2DividedMatrix (f : R →+* S)
    (x y c : R) (i j : Fin 3) :
    f (finiteN2DividedMatrix x y c i j) =
      finiteN2DividedMatrix (f x) (f y) (f c) i j := by
  fin_cases j <;> simp [finiteN2DividedMatrix]

/-- The actual integral N2 form, using source-ring signed root products. -/
def finiteN2RowForm (x y c z sX sY : R) (i : Fin 3) : R :=
  (finiteN2DividedMatrix x y c).mulVec ![z,sX,sY] i

@[simp] theorem map_finiteN2RowForm (f : R →+* S)
    (x y c z sX sY : R) (i : Fin 3) :
    f (finiteN2RowForm x y c z sX sY i) =
      finiteN2RowForm (f x) (f y) (f c) (f z) (f sX) (f sY) i := by
  simp only [finiteN2RowForm, Matrix.mulVec, dotProduct, map_sum, map_mul,
    map_finiteN2DividedMatrix]
  apply Finset.sum_congr rfl
  intro j _
  congr 1
  fin_cases j <;> rfl

theorem finiteN2RowForm_exists_ne_zero
    {F : Type*} [Field F] [CharZero F]
    (x y c z sX sY : F) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, finiteN2RowForm x y c z sX sY i ≠ 0 := by
  classical
  let Q := finiteN2DividedMatrix x y c
  let v : Fin 3 → F := ![z,sX,sY]
  have hdet : Q.det ≠ 0 := finiteN2DividedMatrix_det_ne_zero x y c hxy
  have hunit : IsUnit Q := (Matrix.isUnit_iff_isUnit_det Q).2
    (isUnit_iff_ne_zero.mpr hdet)
  have hinj : Function.Injective Q.mulVec := Matrix.mulVec_injective_iff_isUnit.2 hunit
  by_contra h
  push_neg at h
  have hzero : Q.mulVec v = 0 := by funext i; exact h i
  have hv : v = 0 := hinj (by simpa using hzero)
  exact hz (by simpa [v] using congrFun hv (0 : Fin 3))

/-- One actual N2 integer row has modulus at least one. Both integrality
and nonvanishing are obtained from the displayed polynomial construction. -/
theorem full_ring_finiteN2RowForm_exists_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (x y c z sX sY : 𝓞 K) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, 1 ≤ ‖finiteN2RowForm (phi (x : K)) (phi (y : K))
      (phi (c : K)) (phi (z : K)) (phi (sX : K)) (phi (sY : K)) i‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro a b hab
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hab
  have hz' : f z ≠ 0 := by
    intro h
    apply hz
    apply hf
    simpa only [map_zero] using h
  obtain ⟨i, hi⟩ := finiteN2RowForm_exists_ne_zero
    (f x) (f y) (f c) (f z) (f sX) (f sY) (fun h => hxy (hf h)) hz'
  let L := finiteN2RowForm x y c z sX sY i
  have hL : f L = finiteN2RowForm (f x) (f y) (f c) (f z) (f sX) (f sY) i :=
    map_finiteN2RowForm f _ _ _ _ _ _ i
  have hL0 : L ≠ 0 := by
    intro hzero
    apply hi
    rw [← hL, hzero, map_zero]
  have hbound := one_le_norm_integer hK phi hL0
  change 1 ≤ ‖f L‖ at hbound
  rw [hL] at hbound
  exact ⟨i,hbound⟩

end D1Bound5
