import D1Bound5.CoherentQuotientForms
import Mathlib.LinearAlgebra.Lagrange
import Mathlib.Tactic.ComputeDegree

open Finset Polynomial

namespace D1Bound5

def coherentElementary2 {F : Type*} [CommRing F] (a : Fin 4 → F) : F :=
  a 0 * a 1 + a 0 * a 2 + a 0 * a 3 +
    a 1 * a 2 + a 1 * a 3 + a 2 * a 3

def coherentElementary3 {F : Type*} [CommRing F] (a : Fin 4 → F) : F :=
  a 0 * a 1 * a 2 + a 0 * a 1 * a 3 +
    a 0 * a 2 * a 3 + a 1 * a 2 * a 3

def coherentElementary4 {F : Type*} [CommRing F] (a : Fin 4 → F) : F :=
  a 0 * a 1 * a 2 * a 3

/-- Two vanishing coherent triple forms sharing their first two roots
produce one quadratic taking all four prescribed values.  Only the
difference of the two shared anchors is divided out. -/
theorem coherent_two_three_forms_common_quadratic
    {F : Type*} [Field F] (a R : Fin 4 → F) (z : F) (hab : a 0 ≠ a 1)
    (h2 : -(a 0-a 1)*(a 0-a 2)*(a 1-a 2)*z +
      a 0*(a 1-a 2)*R 0 - a 1*(a 0-a 2)*R 1 + a 2*(a 0-a 1)*R 2 = 0)
    (h3 : -(a 0-a 1)*(a 0-a 3)*(a 1-a 3)*z +
      a 0*(a 1-a 3)*R 0 - a 1*(a 0-a 3)*R 1 + a 3*(a 0-a 1)*R 3 = 0) :
    ∃ v w : F, ∀ i, z * (a i)^2 + v * a i + w = a i * R i := by
  let v := (a 0 * R 0 - a 1 * R 1) / (a 0-a 1) - z * (a 0+a 1)
  let w := a 0*a 1*z + a 0*a 1*(R 1-R 0)/(a 0-a 1)
  refine ⟨v, w, ?_⟩
  intro i
  have hd : a 0-a 1 ≠ 0 := sub_ne_zero.mpr hab
  fin_cases i
  · dsimp [v, w]
    field_simp [hd]
    ring
  · dsimp [v, w]
    field_simp [hd]
    ring
  · dsimp [v, w]
    field_simp [hd]
    linear_combination -h2
  · dsimp [v, w]
    field_simp [hd]
    linear_combination -h3

/-- Four distinct prescribed product-square values determine the
three lower coefficients of the monic quartic.  This is the algebraic
core of simultaneous triple-form nonvanishing. -/
theorem coherent_quadratic_four_value_coefficients
    {F : Type*} [Field F] (a R : Fin 4 → F) (hinj : Function.Injective a)
    (p q z v w : F) (hz : z^2 = p*q+1)
    (hR : ∀ i, (R i)^2 = (a i*p+1)*(a i*q+1))
    (hJ : ∀ i, z*(a i)^2+v*a i+w = a i*R i) :
    w^2 = coherentElementary4 a ∧
    2*v*w = -coherentElementary3 a ∧
    v^2+2*z*w-1 = coherentElementary2 a := by
  let e1 := a 0+a 1+a 2+a 3
  let e2 := coherentElementary2 a
  let e3 := coherentElementary3 a
  let e4 := coherentElementary4 a
  let G : F[X] := C (2*z*v-(p+q)+e1) * X^3 + C (v^2+2*z*w-1-e2) * X^2 +
    C (2*v*w+e3) * X + C (w^2-e4)
  have hexpand (x : F) : G.eval x =
      (z*x^2+v*x+w)^2 - x^2*(p*x+1)*(q*x+1) -
        (x-a 0)*(x-a 1)*(x-a 2)*(x-a 3) := by
    simp only [G, eval_add, eval_mul, eval_C, eval_pow, eval_X]
    dsimp [e1, e2, e3, e4, coherentElementary2, coherentElementary3, coherentElementary4]
    linear_combination -x^4 * hz
  have heval (i : Fin 4) : G.eval (a i) = 0 := by
    rw [hexpand, hJ i]
    have hprod : (a i-a 0)*(a i-a 1)*(a i-a 2)*(a i-a 3) = 0 := by
      fin_cases i <;> simp
    rw [hprod]
    linear_combination (a i)^2 * hR i
  have hdegree : G.degree < ((Finset.univ : Finset (Fin 4)).card : WithBot ℕ) := by
    norm_num only [Finset.card_univ, Fintype.card_fin]
    dsimp [G]
    compute_degree <;> norm_num
  have hzero : G = 0 :=
    Polynomial.eq_zero_of_degree_lt_of_eval_index_eq_zero Finset.univ
      hinj.injOn hdegree (fun i _ => heval i)
  have h0 := congrArg (fun g : F[X] => g.coeff 0) hzero
  have h1 := congrArg (fun g : F[X] => g.coeff 1) hzero
  have h2 := congrArg (fun g : F[X] => g.coeff 2) hzero
  simp only [G, Polynomial.coeff_add, Polynomial.coeff_C_mul_X_pow,
    Polynomial.coeff_C_mul_X, Polynomial.coeff_C, Polynomial.coeff_zero] at h0 h1 h2
  norm_num at h0 h1 h2
  dsimp only [e2, e3, e4] at h0 h1 h2
  exact ⟨by linear_combination h0, by linear_combination h1, by linear_combination h2⟩

/-- Eliminating the two lower quadratic coefficients gives the exact
rational identity used in the four-anchor contradiction. -/
theorem coherent_quadratic_four_value_identity
    (a R : Fin 4 → ℂ) (hinj : Function.Injective a) (ha : ∀ i, a i ≠ 0)
    (p q z v w : ℂ) (hz : z^2 = p*q+1)
    (hR : ∀ i, (R i)^2 = (a i*p+1)*(a i*q+1))
    (hJ : ∀ i, z*(a i)^2+v*a i+w = a i*R i) :
    p*q+1 =
      (coherentElementary2 a + 1 -
        (coherentElementary3 a)^2 / (4*coherentElementary4 a))^2 /
          (4*coherentElementary4 a) := by
  obtain ⟨hw, hvw, hvz⟩ := coherent_quadratic_four_value_coefficients a R hinj p q z v w hz hR hJ
  have he4 : coherentElementary4 a ≠ 0 := by
    exact mul_ne_zero (mul_ne_zero (mul_ne_zero (ha 0) (ha 1)) (ha 2)) (ha 3)
  have h4e : 4*coherentElementary4 a ≠ 0 := mul_ne_zero (by norm_num) he4
  have hv : v^2 = (coherentElementary3 a)^2 / (4*coherentElementary4 a) := by
    apply (eq_div_iff h4e).2
    linear_combination (2*v*w-coherentElementary3 a) * hvw - 4*v^2 * hw
  rw [← hv, ← hz]
  apply (eq_div_iff h4e).2
  linear_combination
    (2*z*w + (coherentElementary2 a+1-v^2)) * hvz - 4*z^2 * hw

/-- Simultaneous vanishing forces the manuscript's exact rational
identity, without assuming an interpolating polynomial exists. -/
theorem coherent_two_three_forms_vanishing_identity
    (a R : Fin 4 → ℂ) (hinj : Function.Injective a) (ha : ∀ i, a i ≠ 0)
    (p q z : ℂ) (hz : z^2 = p*q+1)
    (hR : ∀ i, (R i)^2 = (a i*p+1)*(a i*q+1))
    (h2 : -(a 0-a 1)*(a 0-a 2)*(a 1-a 2)*z +
      a 0*(a 1-a 2)*R 0 - a 1*(a 0-a 2)*R 1 + a 2*(a 0-a 1)*R 2 = 0)
    (h3 : -(a 0-a 1)*(a 0-a 3)*(a 1-a 3)*z +
      a 0*(a 1-a 3)*R 0 - a 1*(a 0-a 3)*R 1 + a 3*(a 0-a 1)*R 3 = 0) :
    p*q+1 =
      (coherentElementary2 a + 1 -
        (coherentElementary3 a)^2 / (4*coherentElementary4 a))^2 /
          (4*coherentElementary4 a) := by
  obtain ⟨v,w,hJ⟩ := coherent_two_three_forms_common_quadratic a R z
    (hinj.ne (by decide)) h2 h3
  exact coherent_quadratic_four_value_identity a R hinj ha p q z v w hz hR hJ

/-- The quotient expression has exactly the integral polynomial
weights used in the common-quadratic argument. -/
theorem coherentQuotientForm_three_eq
    (a : Fin 3 → ℂ) (hinj : Function.Injective a) (p q eta : ℂ) :
    coherentQuotientForm a (coherentVandermonde3 a) p q eta =
      -(a 0-a 1)*(a 0-a 2)*(a 1-a 2)*coherentTerminalRoot p q eta +
        a 0*(a 1-a 2)*coherentAnchorRoot (a 0) p q eta -
        a 1*(a 0-a 2)*coherentAnchorRoot (a 1) p q eta +
        a 2*(a 0-a 1)*coherentAnchorRoot (a 2) p q eta := by
  have hw (i : Fin 3) :
      coherentVandermonde3 a * a i ^ (3 - 2) /
        (∏ j ∈ Finset.univ.erase i, (a i-a j)) = coherentWeights3 a i :=
    (coherentWeights3_eq_quotient a hinj i).symm
  unfold coherentQuotientForm
  simp_rw [hw]
  simp [Fin.sum_univ_succ, coherentWeights3, coherentVandermonde3]
  ring

end D1Bound5

#print axioms D1Bound5.coherent_two_three_forms_common_quadratic
#print axioms D1Bound5.coherent_quadratic_four_value_coefficients
#print axioms D1Bound5.coherent_quadratic_four_value_identity
#print axioms D1Bound5.coherent_two_three_forms_vanishing_identity
#print axioms D1Bound5.coherentQuotientForm_three_eq
