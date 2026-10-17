import D1Bound5.Coordinates
import Mathlib.NumberTheory.NumberField.Norm
import Mathlib.LinearAlgebra.Dimension.Free
import Mathlib.Data.Int.GCD
import Mathlib.Tactic.LinearCombination

open scoped NumberField
open Module

namespace D1Bound5

variable {K : Type*} [Field K] [NumberField K]

/-- The two coordinates of one in any integral basis are coprime. -/
theorem integral_basis_one_gcd (hK : finrank ℚ K = 2)
    (B : Basis (Fin 2) ℤ (𝓞 K)) :
    Int.gcd (B.repr 1 0) (B.repr 1 1) = 1 := by
  let a := B.repr 1 0
  let b := B.repr 1 1
  let d := Int.gcd a b
  obtain ⟨p, hp⟩ := Int.gcd_dvd_left a b
  obtain ⟨q, hq⟩ := Int.gcd_dvd_right a b
  let z : 𝓞 K := p • B 0 + q • B 1
  have hrep : a • B 0 + b • B 1 = 1 := by
    simpa [a, b, Fin.sum_univ_two] using B.sum_repr (1 : 𝓞 K)
  have hdz : (d : 𝓞 K) * z = 1 := by
    calc
      (d : 𝓞 K) * z = ((d : ℤ)*p) • B 0 + ((d : ℤ)*q) • B 1 := by
        simp only [z, zsmul_eq_mul, Int.cast_mul, Int.cast_natCast, mul_add, mul_assoc]
      _ = a • B 0 + b • B 1 :=
        congrArg₂ (· + ·) (congrArg (fun n : ℤ => n • B 0) hp.symm)
          (congrArg (fun n : ℤ => n • B 1) hq.symm)
      _ = 1 := hrep
  have hdim : finrank ℤ (𝓞 K) = 2 := (NumberField.RingOfIntegers.rank K).trans hK
  have hnorm : (d : ℤ)^2 * Algebra.norm ℤ z = 1 := by
    have h := congrArg (Algebra.norm ℤ) hdz
    simpa only [map_mul, Algebra.norm_natCast, hdim, map_one] using h
  have hdvd : (d : ℤ) ∣ 1 := ⟨(d : ℤ) * Algebra.norm ℤ z, by nlinarith [hnorm]⟩
  exact Nat.dvd_one.mp (Int.natCast_dvd_natCast.mp hdvd)


/-- A quadratic number ring has an integral basis of the form one, omega.
Bijectivity means that every algebraic integer, not just an order, has a
unique pair of integer coordinates in this basis. -/
theorem exists_integral_generator (hK : finrank ℚ K = 2) :
    ∃ w : 𝓞 K, Function.Bijective (fun p : ℤ × ℤ => (p.1 : 𝓞 K) + (p.2 : 𝓞 K)*w) := by
  classical
  let B := Module.finBasisOfFinrankEq ℤ (𝓞 K)
    ((NumberField.RingOfIntegers.rank K).trans hK)
  let a := B.repr 1 0
  let b := B.repr 1 1
  let u := Int.gcdA a b
  let v := Int.gcdB a b
  have hab : a*u+b*v = 1 := by
    have hg : Int.gcd a b = 1 := integral_basis_one_gcd hK B
    change a*Int.gcdA a b+b*Int.gcdB a b = 1
    rw [← Int.gcd_eq_gcd_ab, hg]
    rfl
  have hrep : (a : 𝓞 K)*B 0 + (b : 𝓞 K)*B 1 = 1 := by
    simpa [a, b, Fin.sum_univ_two, zsmul_eq_mul] using B.sum_repr (1 : 𝓞 K)
  let w : 𝓞 K := -v • B 0 + u • B 1
  have hform (n m : ℤ) :
      (n : 𝓞 K) + (m : 𝓞 K)*w =
        (a*n-v*m) • B 0 + (b*n+u*m) • B 1 := by
    calc
      _ = (n : 𝓞 K)*((a : 𝓞 K)*B 0 + (b : 𝓞 K)*B 1) + (m : 𝓞 K)*w := by
        rw [hrep, mul_one]
      _ = _ := by
        simp only [w, zsmul_eq_mul, Int.cast_add, Int.cast_sub, Int.cast_mul, Int.cast_neg]
        ring
  refine ⟨w, ?_, ?_⟩
  · intro p q hpq
    change (p.1 : 𝓞 K)+(p.2 : 𝓞 K)*w = (q.1 : 𝓞 K)+(q.2 : 𝓞 K)*w at hpq
    rw [hform, hform] at hpq
    have h0 : a*p.1-v*p.2 = a*q.1-v*q.2 := by
      have h := congrArg (fun z : 𝓞 K => B.repr z 0) hpq
      simp only [map_add, map_smul] at h
      simpa using h
    have h1 : b*p.1+u*p.2 = b*q.1+u*q.2 := by
      have h := congrArg (fun z : 𝓞 K => B.repr z 1) hpq
      simp only [map_add, map_smul] at h
      simpa using h
    apply Prod.ext
    · linear_combination u*h0+v*h1-(p.1-q.1)*hab
    · linear_combination -b*h0+a*h1-(p.2-q.2)*hab
  · intro z
    let x := B.repr z 0
    let y := B.repr z 1
    refine ⟨(u*x+v*y, -b*x+a*y), ?_⟩
    dsimp only
    rw [hform]
    have hx : a*(u*x+v*y)-v*(-b*x+a*y) = x := by linear_combination x*hab
    have hy : b*(u*x+v*y)+u*(-b*x+a*y) = y := by linear_combination y*hab
    rw [hx, hy]
    simpa [x, y, Fin.sum_univ_two] using B.sum_repr z

/-- Exact ring identification before normalizing the generator's trace. -/
theorem exists_quadratic_ring_equiv (hK : finrank ℚ K = 2) :
    ∃ tau nu : ℤ, Nonempty (QuadInt tau nu ≃+* 𝓞 K) := by
  obtain ⟨w, hw⟩ := exists_integral_generator hK
  obtain ⟨⟨x,y⟩, hxy⟩ := hw.2 (w*w)
  have hw2 : w*w = x • (1 : 𝓞 K) + y • w := by
    simpa only [zsmul_eq_mul, mul_one] using hxy.symm
  let f : QuadraticAlgebra ℤ x y →ₐ[ℤ] 𝓞 K := QuadraticAlgebra.lift ⟨w, hw2⟩
  have hf : Function.Bijective f := by
    have h := hw.comp (QuadraticAlgebra.equivProd x y).bijective
    change Function.Bijective (fun z : QuadraticAlgebra ℤ x y =>
      (z.re : 𝓞 K)+(z.im : 𝓞 K)*w) at h
    change Function.Bijective (fun z : QuadraticAlgebra ℤ x y => z.re • 1 + z.im • w)
    simpa only [zsmul_eq_mul, mul_one] using h
  refine ⟨y, -x, ?_⟩
  change Nonempty (QuadraticAlgebra ℤ (- -x) y ≃+* 𝓞 K)
  rw [neg_neg]
  exact ⟨(AlgEquiv.ofBijective f hf).toRingEquiv⟩

end D1Bound5
