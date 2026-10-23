import D1Bound5.FiniteHomogeneousTwo
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Convert

namespace D1Bound5

theorem finitePolynomial_norm_le (k : ℕ) (a : Fin (k+1) → ℂ) (c : ℂ) :
    ‖∑ ell, a ell*c^(ell : ℕ)‖ ≤ ∑ ell, ‖a ell‖*‖c‖^(ell : ℕ) := by
  apply (norm_sum_le _ _).trans
  apply Finset.sum_le_sum
  intro ell hell
  rw [norm_mul,norm_pow]

theorem finitePolynomial_two_columns_norm_le (k d0 : ℕ)
    (p : Fin 2 → Fin (k+1) → ℂ) (v : Fin (k+1) → ℝ) (c : ℂ) (Y : ℝ)
    (hcoeff : ∀ ell, ‖p 0 ell‖+‖p 1 ell‖ ≤ v ell*Y^(d0+(ell : ℕ))) :
    ‖∑ ell, p 0 ell*c^(ell : ℕ)‖+‖∑ ell, p 1 ell*c^(ell : ℕ)‖ ≤
      Y^d0*∑ ell, v ell*(Y*‖c‖)^(ell : ℕ) := by
  calc
    _ ≤ (∑ ell, ‖p 0 ell‖*‖c‖^(ell : ℕ))+
        ∑ ell, ‖p 1 ell‖*‖c‖^(ell : ℕ) :=
      add_le_add (finitePolynomial_norm_le k (p 0) c) (finitePolynomial_norm_le k (p 1) c)
    _ = ∑ ell, (‖p 0 ell‖+‖p 1 ell‖)*‖c‖^(ell : ℕ) := by
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro ell hell
      ring
    _ ≤ ∑ ell, (v ell*Y^(d0+(ell : ℕ)))*‖c‖^(ell : ℕ) := by
      apply Finset.sum_le_sum
      intro ell hell
      exact mul_le_mul_of_nonneg_right (hcoeff ell) (pow_nonneg (norm_nonneg c) _)
    _ = _ := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro ell hell
      rw [pow_add,mul_pow]
      ring

theorem finitePolynomial_power_majorization (T : ℝ) (hT : 1000 ≤ T)
    (k ell : ℕ) (hell : ell ≤ k) : T^ell ≤ T^k/(1000 : ℝ)^(k-ell) := by
  have hT0 : 0 ≤ T := by linarith only [hT]
  apply (le_div_iff₀ (by positivity)).mpr
  have hp : (1000 : ℝ)^(k-ell) ≤ T^(k-ell) := by gcongr
  calc
    T^ell*(1000 : ℝ)^(k-ell) ≤ T^ell*T^(k-ell) :=
      mul_le_mul_of_nonneg_left hp (pow_nonneg hT0 _)
    _ = T^k := by rw [← pow_add,Nat.add_sub_of_le hell]

/-- A rational computation on the actual coefficient vector supplies the
strict height margin for every T≥1000. This avoids weakening the constants
by combining coordinatewise maxima from different rows. -/
theorem finitePolynomial_height_scalar (k : ℕ) (v : Fin (k+1) → ℝ)
    (hv : ∀ ell, 0 ≤ v ell) (M T : ℝ) (hT : 1000 ≤ T)
    (hslack : (101/100 : ℝ)*(∑ ell, v ell/(1000 : ℝ)^(k-(ell : ℕ))) < M) :
    (101/100 : ℝ)*(∑ ell, v ell*T^(ell : ℕ)) < M*T^k := by
  have hT0 : 0 < T := by linarith only [hT]
  have hsum : (∑ ell, v ell*T^(ell : ℕ)) ≤
      ∑ ell, (v ell/(1000 : ℝ)^(k-(ell : ℕ)))*T^k := by
    apply Finset.sum_le_sum
    intro ell hell
    have hh := mul_le_mul_of_nonneg_left
      (finitePolynomial_power_majorization T hT k ell.val (by omega)) (hv ell)
    convert hh using 1 <;> ring
  calc
    _ ≤ (101/100 : ℝ)*(∑ ell, (v ell/(1000 : ℝ)^(k-(ell : ℕ)))*T^k) :=
      mul_le_mul_of_nonneg_left hsum (by norm_num)
    _ = ((101/100 : ℝ)*(∑ ell, v ell/(1000 : ℝ)^(k-(ell : ℕ))))*T^k := by
      rw [← Finset.sum_mul]
      ring
    _ < M*T^k := mul_lt_mul_of_pos_right hslack (pow_pos hT0 _)

end D1Bound5
