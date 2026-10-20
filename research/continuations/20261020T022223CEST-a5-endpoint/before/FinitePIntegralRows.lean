import D1Bound5.FinitePMatrix
import D1Bound5.FullRingBridge
import Mathlib.Tactic.LinearCombination

open scoped NumberField
open Module

namespace D1Bound5

def finitePLeadingFactor {R : Type*} [CommRing R] (a b s : R) : R :=
  3*s^2-(a+b)*s-a*b

def finitePLinearFactor {R : Type*} [CommRing R] (a b s : R) : R := 2*s-a-b

/-- The potential zero-leading-coefficient case has no hidden rank loss:
if both determinant factors vanish, the two first anchors coincide. -/
theorem finiteP_factor_identity {R : Type*} [CommRing R] (a b s : R) :
    (a-b)^2 = 4*finitePLeadingFactor a b s-(6*s+a+b)*finitePLinearFactor a b s := by
  dsimp [finitePLeadingFactor,finitePLinearFactor]
  ring

@[simp] theorem map_finitePLeadingFactor {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a b s : R) :
    f (finitePLeadingFactor a b s) = finitePLeadingFactor (f a) (f b) (f s) := by
  simp [finitePLeadingFactor]

@[simp] theorem map_finitePDividedMatrix {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a b s c : R) (i j : Fin 4) :
    f (finitePDividedMatrix a b s c i j) =
      finitePDividedMatrix (f a) (f b) (f s) (f c) i j := by
  fin_cases i <;> fin_cases j <;>
    simp [finitePDividedMatrix,finitePRConstant,finitePTConstant,
      finitePRLeft,finitePRRight,finitePTLeft,finitePTRight,finitePairQuadratic,
      finitePRLeftCoeff,finitePRRightCoeff,finitePTLeftCoeff,finitePTRightCoeff]

private theorem finitePLinearFactor_norm_le (a b s : ℂ)
    (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖) :
    ‖finitePLinearFactor a b s‖ ≤ 4*‖s‖ := by
  calc
    _ ≤ ‖2*s-a‖+‖b‖ := norm_sub_le _ _
    _ ≤ (‖2*s‖+‖a‖)+‖b‖ := add_le_add_right (norm_sub_le _ _) _
    _ = 2*‖s‖+‖a‖+‖b‖ := by norm_num [norm_mul]
    _ ≤ _ := by linarith only [hAB,hBS]

/-- Actual integral arithmetic rules out a zero determinant factor. A
nonzero leading factor is an algebraic integer of norm at least one; a
zero leading factor is excluded by the exact identity above. -/
theorem full_ring_finitePDetFactor_ne_zero
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ) (a b s c : 𝓞 K)
    (hs : s ≠ 0) (hab : a ≠ b)
    (hAB : ‖phi (a : K)‖ ≤ ‖phi (b : K)‖)
    (hBS : ‖phi (b : K)‖ ≤ ‖phi (s : K)‖)
    (hC : 200*‖phi (s : K)‖ ≤ ‖phi (c : K)‖) :
    finitePDetFactor (phi (a : K)) (phi (b : K)) (phi (s : K)) (phi (c : K)) ≠ 0 := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hs0 : f s ≠ 0 := by
    intro h
    apply hs
    exact hf (by simpa only [map_zero] using h)
  have hS : 0 < ‖f s‖ := norm_pos_iff.mpr hs0
  have hab0 : f a ≠ f b := fun h => hab (hf h)
  change ‖f a‖ ≤ ‖f b‖ at hAB
  change ‖f b‖ ≤ ‖f s‖ at hBS
  change 200*‖f s‖ ≤ ‖f c‖ at hC
  change finitePDetFactor (f a) (f b) (f s) (f c) ≠ 0
  intro hzero
  have hfactor : 7*finitePLinearFactor (f a) (f b) (f s)+
      6*f c*finitePLeadingFactor (f a) (f b) (f s) = 0 := by
    simpa only [finitePDetFactor,finitePLeadingFactor,finitePLinearFactor] using hzero
  by_cases hW : finitePLeadingFactor a b s = 0
  · have hW' : finitePLeadingFactor (f a) (f b) (f s) = 0 := by
      rw [← map_finitePLeadingFactor f a b s,hW,map_zero]
    have ht : finitePLinearFactor (f a) (f b) (f s) = 0 := by
      rw [hW',mul_zero,add_zero] at hfactor
      exact (mul_eq_zero.mp hfactor).resolve_left (by norm_num)
    have hid := finiteP_factor_identity (f a) (f b) (f s)
    rw [hW',ht,mul_zero,mul_zero,sub_zero] at hid
    have hd : f a-f b = 0 := by
      have hh : (f a-f b)*(f a-f b) = 0 := by simpa only [pow_two] using hid
      rcases mul_eq_zero.mp hh with h | h <;> exact h
    exact hab0 (sub_eq_zero.mp hd)
  · have hW1 : 1 ≤ ‖finitePLeadingFactor (f a) (f b) (f s)‖ := by
      have h := one_le_norm_integer hK phi hW
      change 1 ≤ ‖f (finitePLeadingFactor a b s)‖ at h
      simpa only [map_finitePLeadingFactor] using h
    have heq : 6*f c*finitePLeadingFactor (f a) (f b) (f s) =
        -(7*finitePLinearFactor (f a) (f b) (f s)) := by
      linear_combination hfactor
    have hnorm := congrArg norm heq
    norm_num only [norm_mul,norm_neg,norm_ofNat] at hnorm
    have ht := finitePLinearFactor_norm_le (f a) (f b) (f s) hAB hBS
    have hmul := mul_le_mul_of_nonneg_left hW1 (show 0 ≤ 6*‖f c‖ by positivity)
    nlinarith only [hnorm,ht,hmul,hC,hS]

theorem full_ring_finitePDividedMatrix_det_ne_zero
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ) (a b s c : 𝓞 K)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s)
    (hAB : ‖phi (a : K)‖ ≤ ‖phi (b : K)‖)
    (hBS : ‖phi (b : K)‖ ≤ ‖phi (s : K)‖)
    (hC : 200*‖phi (s : K)‖ ≤ ‖phi (c : K)‖) :
    (finitePDividedMatrix (phi (a : K)) (phi (b : K)) (phi (s : K)) (phi (c : K))).det ≠ 0 := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hn (x : 𝓞 K) (hx : x ≠ 0) : f x ≠ 0 := by
    intro h
    exact hx (hf (by simpa only [map_zero] using h))
  have hfac := full_ring_finitePDetFactor_ne_zero hK phi a b s c hs hab hAB hBS hC
  change (finitePDividedMatrix (f a) (f b) (f s) (f c)).det ≠ 0
  rw [finitePDividedMatrix_det]
  exact mul_ne_zero (mul_ne_zero (mul_ne_zero (mul_ne_zero (mul_ne_zero
    (mul_ne_zero (mul_ne_zero (by norm_num : (-78750 : ℂ) ≠ 0) (hn a ha)) (hn b hb))
      (hn s hs)) (pow_ne_zero _ (sub_ne_zero.mpr (fun h => hab (hf h)))))
        (sub_ne_zero.mpr (fun h => has (hf h))))
          (sub_ne_zero.mpr (fun h => hbs (hf h)))) hfac

def finitePRowForm {R : Type*} [CommRing R]
    (a b s c z rA rB rS : R) (i : Fin 4) : R :=
  (finitePDividedMatrix a b s c).mulVec ![z,rA,rB,rS] i

@[simp] theorem map_finitePRowForm {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a b s c z rA rB rS : R) (i : Fin 4) :
    f (finitePRowForm a b s c z rA rB rS i) =
      finitePRowForm (f a) (f b) (f s) (f c) (f z) (f rA) (f rB) (f rS) i := by
  simp only [finitePRowForm,Matrix.mulVec,dotProduct,map_sum,map_mul,map_finitePDividedMatrix]
  apply Finset.sum_congr rfl
  intro j _
  congr 1
  fin_cases j <;> rfl

/-- A genuine full-ring integral row has norm at least one. Both the
nonsingularity and the integrality of this constructed P matrix are proved
here; they are not supplied as separate approximation certificates. -/
theorem full_ring_finitePRowForm_exists_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b s c z rA rB rS : 𝓞 K)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s) (hz : z ≠ 0)
    (hAB : ‖phi (a : K)‖ ≤ ‖phi (b : K)‖)
    (hBS : ‖phi (b : K)‖ ≤ ‖phi (s : K)‖)
    (hC : 200*‖phi (s : K)‖ ≤ ‖phi (c : K)‖) :
    ∃ i : Fin 4, 1 ≤ ‖finitePRowForm (phi (a : K)) (phi (b : K)) (phi (s : K))
      (phi (c : K)) (phi (z : K)) (phi (rA : K)) (phi (rB : K)) (phi (rS : K)) i‖ := by
  classical
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hz0 : f z ≠ 0 := by
    intro h
    exact hz (hf (by simpa only [map_zero] using h))
  let M := finitePDividedMatrix (f a) (f b) (f s) (f c)
  let v : Fin 4 → ℂ := ![f z,f rA,f rB,f rS]
  have hdet : M.det ≠ 0 := full_ring_finitePDividedMatrix_det_ne_zero hK phi a b s c
    ha hb hs hab has hbs hAB hBS hC
  have hu : IsUnit M := (Matrix.isUnit_iff_isUnit_det M).2 (isUnit_iff_ne_zero.mpr hdet)
  have hi : Function.Injective M.mulVec := Matrix.mulVec_injective_iff_isUnit.2 hu
  have hex : ∃ i : Fin 4, finitePRowForm (f a) (f b) (f s) (f c)
      (f z) (f rA) (f rB) (f rS) i ≠ 0 := by
    by_contra h
    push_neg at h
    have hzero : M.mulVec v = 0 := by funext i; exact h i
    have hv : v = 0 := hi (by simpa using hzero)
    exact hz0 (by simpa [v] using congrFun hv (0 : Fin 4))
  obtain ⟨i,hi⟩ := hex
  let L := finitePRowForm a b s c z rA rB rS i
  have hL : f L = finitePRowForm (f a) (f b) (f s) (f c) (f z) (f rA) (f rB) (f rS) i :=
    map_finitePRowForm f _ _ _ _ _ _ _ _ i
  have hL0 : L ≠ 0 := by
    intro hzero
    apply hi
    rw [← hL,hzero,map_zero]
  have hbnd := one_le_norm_integer hK phi hL0
  change 1 ≤ ‖f L‖ at hbnd
  rw [hL] at hbnd
  exact ⟨i,hbnd⟩

end D1Bound5
