import D1Bound5.FiniteA5Matrix
import D1Bound5.FullRingBridge

open scoped NumberField
open Module

namespace D1Bound5

variable {R S : Type*} [CommRing R] [CommRing S]

@[simp] theorem map_finiteA5Constant (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteA5Constant x y c i) = finiteA5Constant (f x) (f y) (f c) i := by
  fin_cases i <;> simp [finiteA5Constant, map_ofNat]

@[simp] theorem map_finiteA5Left (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteA5Left x y c i) = finiteA5Left (f x) (f y) (f c) i := by
  fin_cases i <;> simp [finiteA5Left, map_ofNat]

@[simp] theorem map_finiteA5Right (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteA5Right x y c i) = finiteA5Right (f x) (f y) (f c) i := by
  fin_cases i <;> simp [finiteA5Right, map_ofNat]

@[simp] theorem map_finiteA5DividedMatrix (f : R →+* S)
    (x y c : R) (i j : Fin 3) :
    f (finiteA5DividedMatrix x y c i j) =
      finiteA5DividedMatrix (f x) (f y) (f c) i j := by
  fin_cases j <;> simp [finiteA5DividedMatrix]

/-- The actual integral A5 form, using source-ring signed root products. -/
def finiteA5RowForm (x y c z sX sY : R) (i : Fin 3) : R :=
  (finiteA5DividedMatrix x y c).mulVec ![z,sX,sY] i

@[simp] theorem map_finiteA5RowForm (f : R →+* S)
    (x y c z sX sY : R) (i : Fin 3) :
    f (finiteA5RowForm x y c z sX sY i) =
      finiteA5RowForm (f x) (f y) (f c) (f z) (f sX) (f sY) i := by
  simp only [finiteA5RowForm, Matrix.mulVec, dotProduct, map_sum, map_mul,
    map_finiteA5DividedMatrix]
  apply Finset.sum_congr rfl
  intro j _
  congr 1
  fin_cases j <;> rfl

theorem finiteA5RowForm_exists_ne_zero
    {F : Type*} [Field F] [CharZero F]
    (x y c z sX sY : F) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, finiteA5RowForm x y c z sX sY i ≠ 0 := by
  classical
  let Q := finiteA5DividedMatrix x y c
  let v : Fin 3 → F := ![z,sX,sY]
  have hdet : Q.det ≠ 0 := finiteA5DividedMatrix_det_ne_zero x y c hx hy hc hxy
  have hunit : IsUnit Q := (Matrix.isUnit_iff_isUnit_det Q).2
    (isUnit_iff_ne_zero.mpr hdet)
  have hinj : Function.Injective Q.mulVec := Matrix.mulVec_injective_iff_isUnit.2 hunit
  by_contra h
  push_neg at h
  have hzero : Q.mulVec v = 0 := by funext i; exact h i
  have hv : v = 0 := hinj (by simpa using hzero)
  exact hz (by simpa [v] using congrFun hv (0 : Fin 3))

/-- One actual A5 integer row has modulus at least one. Both integrality
and nonvanishing are obtained from the displayed polynomial construction. -/
theorem full_ring_finiteA5RowForm_exists_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (x y c z sX sY : 𝓞 K) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, 1 ≤ ‖finiteA5RowForm (phi (x : K)) (phi (y : K))
      (phi (c : K)) (phi (z : K)) (phi (sX : K)) (phi (sY : K)) i‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro a b hab
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hab
  have hnonzero (a : 𝓞 K) (ha : a ≠ 0) : f a ≠ 0 := by
    intro h
    apply ha
    apply hf
    simpa only [map_zero] using h
  have hz' : f z ≠ 0 := by
    intro h
    apply hz
    apply hf
    simpa only [map_zero] using h
  obtain ⟨i, hi⟩ := finiteA5RowForm_exists_ne_zero
    (f x) (f y) (f c) (f z) (f sX) (f sY) (hnonzero x hx) (hnonzero y hy) (hnonzero c hc) (fun h => hxy (hf h)) hz'
  let L := finiteA5RowForm x y c z sX sY i
  have hL : f L = finiteA5RowForm (f x) (f y) (f c) (f z) (f sX) (f sY) i :=
    map_finiteA5RowForm f _ _ _ _ _ _ i
  have hL0 : L ≠ 0 := by
    intro hzero
    apply hi
    rw [← hL, hzero, map_zero]
  have hbound := one_le_norm_integer hK phi hL0
  change 1 ≤ ‖f L‖ at hbound
  rw [hL] at hbound
  exact ⟨i,hbound⟩

end D1Bound5
