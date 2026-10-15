import D1Bound5.FullRingBridge
import Mathlib.LinearAlgebra.Matrix.SchurComplement
import Mathlib.Algebra.CharP.Frobenius
import Mathlib.Algebra.CharP.Two
import Mathlib.Data.ZMod.Basic

open scoped NumberField BigOperators
open Matrix Module

namespace D1Bound5

/-- Rank-two determinant formula over any commutative ring, including
rings with zero divisors. No inverse of I+J is required. -/
theorem det_identity_plus_two_rank_one {R n : Type*} [CommRing R]
    [Fintype n] [DecidableEq n] (v : n → R) :
    Matrix.det (fun i j => (if i=j then 1 else 0)+1+v i*v j) =
      (1+(Fintype.card n : R))*(1+∑ i, v i^2)-(∑ i, v i)^2 := by
  let A : Matrix n (Fin 2) R := fun i j => if j=0 then 1 else v i
  have haa (i j : n) : (A*A.transpose) i j = 1+v i*v j := by
    change (∑ k : Fin 2, A i k*A j k) = _
    simp [A,Fin.sum_univ_two]
  have h00 : (A.transpose*A) 0 0 = (Fintype.card n : R) := by
    change (∑ i : n, A i 0*A i 0) = _
    simp [A]
  have h01 : (A.transpose*A) 0 1 = ∑ i, v i := by
    change (∑ i : n, A i 0*A i 1) = _
    simp [A]
  have h10 : (A.transpose*A) 1 0 = ∑ i, v i := by
    change (∑ i : n, A i 1*A i 0) = _
    simp [A]
  have h11 : (A.transpose*A) 1 1 = ∑ i, v i^2 := by
    change (∑ i : n, A i 1*A i 1) = _
    simp [A,pow_two]
  calc
    _ = (1+A*A.transpose).det := by
      congr 1
      ext i j
      change (if i=j then 1 else 0)+1+v i*v j =
        (if i=j then 1 else 0)+(A*A.transpose) i j
      rw [haa]
      ring
    _ = (1+A.transpose*A).det := Matrix.det_one_add_mul_comm A A.transpose
    _ = _ := by
      rw [Matrix.det_fin_two]
      simp [Matrix.add_apply,Matrix.one_apply,h00,h01,h10,h11,pow_two]

/-- Entrywise square data force determinant square one in characteristic
two and even dimension. Symmetry of the matrix is unnecessary. -/
theorem even_root_matrix_det_sq_char_two {R n : Type*} [CommRing R]
    [CharP R 2] [Fintype n] [DecidableEq n]
    (hn : Even (Fintype.card n)) (v : n → R) (M : Matrix n n R)
    (hd : ∀ i, M i i = v i)
    (hs : ∀ i j, i ≠ j → (M i j)^2 = v i*v j+1) : M.det^2 = 1 := by
  let F : R →+* R := frobenius R 2
  have hcard : (Fintype.card n : R) = 0 := by
    rw [CharTwo.natCast_eq_ite,if_pos hn]
  have hsum : (∑ i, v i^2) = (∑ i, v i)^2 := by
    exact (map_sum F v Finset.univ).symm
  have hM : M.map F = (fun i j => (if i=j then 1 else 0)+1+v i*v j) := by
    ext i j
    by_cases hij : i=j
    · subst j
      simp [Matrix.map_apply,F,frobenius_def,hd,pow_two,CharTwo.add_self_eq_zero]
    · simp [Matrix.map_apply,F,frobenius_def,hs i j hij,hij,add_comm]
  have hdet := RingHom.map_det F M
  change M.det^2 = (M.map F).det at hdet
  rw [hdet,hM,det_identity_plus_two_rank_one,hcard,hsum]
  ring

/-- Coefficient reduction modulo two in every integral quadratic model.
Its target is a nontrivial rank-two algebra even when it has zero divisors. -/
def quadraticReductionTwo (tau nu : ℤ) :
    QuadInt tau nu →+* QuadraticAlgebra (ZMod 2) (-(nu : ZMod 2)) (tau : ZMod 2) where
  toFun z := ⟨(z.re : ZMod 2),(z.im : ZMod 2)⟩
  map_zero' := by ext <;> simp
  map_one' := by ext <;> simp [QuadraticAlgebra.re_one,QuadraticAlgebra.im_one]
  map_add' z w := by ext <;> simp
  map_mul' z w := by ext <;> simp

/-- The even-dimensional integral root matrix is nonsingular over the
full integer ring of every quadratic number field. No quotient properness
assumption is added: the explicit reduction has a nontrivial target. -/
theorem even_root_matrix_det_ne_zero {K n : Type*} [Field K] [NumberField K]
    [Fintype n] [DecidableEq n] (hK : finrank ℚ K = 2)
    (hn : Even (Fintype.card n)) (v : n → 𝓞 K) (M : Matrix n n (𝓞 K))
    (hd : ∀ i, M i i = v i)
    (hs : ∀ i j, i ≠ j → (M i j)^2 = v i*v j+1) : M.det ≠ 0 := by
  obtain ⟨tau,nu,_,⟨e⟩⟩ := exists_normalized_quadratic_ring_equiv hK
  let S := QuadraticAlgebra (ZMod 2) (-(nu : ZMod 2)) (tau : ZMod 2)
  letI : CharP S 2 := CharTwo.of_one_ne_zero_of_two_eq_zero one_ne_zero (by
    apply QuadraticAlgebra.ext
    · change (2 : ZMod 2) = 0
      exact CharTwo.two_eq_zero
    · rfl)
  let f : 𝓞 K →+* S := (quadraticReductionTwo tau nu).comp e.symm.toRingHom
  have hdiag (i : n) : (M.map f) i i = f (v i) := by simp [hd]
  have hsquare (i j : n) (hij : i ≠ j) :
      ((M.map f) i j)^2 = f (v i)*f (v j)+1 := by
    simpa only [Matrix.map_apply,map_pow,map_mul,map_add,map_one]
      using congrArg f (hs i j hij)
  have h := even_root_matrix_det_sq_char_two hn (fun i => f (v i)) (M.map f) hdiag hsquare
  change (f.mapMatrix M).det^2 = 1 at h
  rw [← RingHom.map_det f M] at h
  intro hzero
  rw [hzero,map_zero,zero_pow (by decide : 2 ≠ 0)] at h
  exact zero_ne_one h

/-- The arithmetic lower bound used by the structural determinant estimates. -/
theorem even_root_matrix_one_le_norm {K n : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K] [Fintype n] [DecidableEq n]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (hn : Even (Fintype.card n)) (v : n → 𝓞 K) (M : Matrix n n (𝓞 K))
    (hd : ∀ i, M i i = v i)
    (hs : ∀ i j, i ≠ j → (M i j)^2 = v i*v j+1) :
    1 ≤ ‖phi (M.det : K)‖ :=
  one_le_norm_integer hK phi (even_root_matrix_det_ne_zero hK hn v M hd hs)

end D1Bound5
