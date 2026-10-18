import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega

namespace D1Bound5

/-- The local radius 2u/5 gives the exact three-distance product used in the
two-anchor coefficient bound. -/
theorem bennett_two_local_radius_product (u v : ℝ) :
    (2 * u / 5) * (u - 2 * u / 5) * (v - 2 * u / 5) =
      (6 / 25 : ℝ) * u ^ 2 * (v - 2 * u / 5) := by ring

/-- The one extra pole in a residue row always pays for the coefficient
radius. This is the algebraic counterpart of cancellation of circle length
with the extra pole in the contour proof. -/
theorem bennett_two_row_radius_power_le
    (r D E : ℝ) (hr : 0 < r) (hD : r ≤ D) (hE : r ≤ E)
    (k d0 d1 d2 : ℕ) (hk : 1 ≤ k) (hd : d0 + d1 + d2 = 1) :
    (r * D * E) ^ k ≤ r ^ (k + d0 - 1) * D ^ (k + d1) * E ^ (k + d2) := by
  have hD0 : 0 ≤ D := hr.le.trans hD
  have hE0 : 0 ≤ E := hr.le.trans hE
  have hextra : r ≤ r ^ d0 * D ^ d1 * E ^ d2 := by
    calc
      r = r ^ (d0 + d1 + d2) := by rw [hd, pow_one]
      _ = r ^ d0 * r ^ d1 * r ^ d2 := by rw [pow_add, pow_add]
      _ ≤ r ^ d0 * D ^ d1 * E ^ d2 := by
        exact mul_le_mul
          (mul_le_mul_of_nonneg_left (pow_le_pow_left₀ hr.le hD d1) (pow_nonneg hr.le _))
          (pow_le_pow_left₀ hr.le hE d2) (pow_nonneg hr.le _)
          (mul_nonneg (pow_nonneg hr.le _) (pow_nonneg hD0 _))
  have ht : (k + d0 - 1) + 1 = k + d0 := by omega
  apply (mul_le_mul_iff_of_pos_right hr).mp
  calc
    (r * D * E) ^ k * r ≤ (r * D * E) ^ k *
        (r ^ d0 * D ^ d1 * E ^ d2) :=
      mul_le_mul_of_nonneg_left hextra
        (pow_nonneg (mul_nonneg (mul_nonneg hr.le hD0) hE0) _)
    _ = (r ^ (k + d0 - 1) * D ^ (k + d1) * E ^ (k + d2)) * r := by
      have hrpow : r ^ (k + d0 - 1) * r = r ^ k * r ^ d0 := by
        rw [← pow_succ, ht, pow_add]
      rw [pow_add, pow_add]
      simp only [mul_pow]
      calc
        _ = (r ^ k * r ^ d0) * (D ^ k * D ^ d1) * (E ^ k * E ^ d2) := by ring
        _ = _ := by rw [← hrpow]; ring

/-- Triangle geometry controls the same rational factor as in the paper.
The assumptions hold for u=min(A,delta), v=max(A,delta), and A≤B. -/
theorem bennett_two_distance_ratio_le (B u v : ℝ)
    (hB : 0 < B) (hu : 0 < u) (huB : u ≤ B)
    (huv : u ≤ v) (hvB : v ≤ u + B) :
    v ^ 2 / (v - 2 * u / 5) ≤ (5 / 2 : ℝ) * B := by
  have hd : 0 < v - 2 * u / 5 := by linarith
  apply (div_le_iff₀ hd).mpr
  have hprod : 0 ≤ (v - u) * (u + B - v) :=
    mul_nonneg (sub_nonneg.mpr huv) (sub_nonneg.mpr hvB)
  by_cases hsmall : u ≤ 3 * B / 4
  · have hp : 0 ≤ (3 * B / 2 - 2 * u) * v :=
      mul_nonneg (by linarith) (by linarith)
    nlinarith [sq_nonneg u]
  · have hp : 0 ≤ (2 * u - 3 * B / 2) * (u + B - v) :=
      mul_nonneg (by linarith) (sub_nonneg.mpr hvB)
    have hgap : 0 ≤ (B - u) * (3 * B + 2 * u) :=
      mul_nonneg (sub_nonneg.mpr huB) (by positivity)
    nlinarith

/-- The small loss from the degree-(k+1) numerator majorant fits strictly
inside the manuscript's rounding of the exponential base to 42. -/
theorem bennett_two_coefficient_rounding (T : ℝ) (hT : 1000 ≤ T) :
    ((1 + 7 / (5 * T)) / (1 - 1 / T)) *
      ((125 / 3 : ℝ) * (1 + 7 / (5 * T))) < 42 := by
  have hT0 : 0 < T := by linarith
  have hη : 0 < 1 - 1 / T := by
    have hdiv : 1 / T < 1 := (div_lt_one hT0).mpr (by linarith)
    linarith
  have hF0 : 0 ≤ 1 + 7 / (5 * T) := by positivity
  have hF : 1 + 7 / (5 * T) ≤ 5007 / 5000 := by
    have hdiv : 7 / (5 * T) ≤ 7 / 5000 := by
      apply (div_le_div_iff₀ (by positivity : 0 < 5 * T) (by norm_num : (0 : ℝ) < 5000)).mpr
      nlinarith
    linarith
  have hηlow : 999 / 1000 ≤ 1 - 1 / T := by
    have hdiv : 1 / T ≤ 1 / 1000 := by
      apply (div_le_div_iff₀ hT0 (by norm_num : (0 : ℝ) < 1000)).mpr
      nlinarith
    linarith
  have hratio : (1 + 7 / (5 * T)) / (1 - 1 / T) ≤ 1669 / 1665 := by
    apply (div_le_iff₀ hη).mpr
    nlinarith
  calc
    _ ≤ (1669 / 1665 : ℝ) * ((125 / 3) * (5007 / 5000)) := by
      apply mul_le_mul hratio
        (mul_le_mul_of_nonneg_left hF (by norm_num))
        (mul_nonneg (by norm_num) hF0) (by norm_num)
    _ < 42 := by norm_num

/-- A prefactor at least one can be absorbed into an exponential at every
positive order, allowing the preceding exact rational slack to be used. -/
theorem bennett_prefactor_absorb (M H : ℝ) (hM : 1 ≤ M) (hH : 0 ≤ H)
    (k : ℕ) (hk : 1 ≤ k) : M * H ^ k ≤ (M * H) ^ k := by
  have hM0 : 0 ≤ M := by linarith
  have hpow : ∀ n : ℕ, 1 ≤ M ^ n := by
    intro n
    induction n with
    | zero => simp
    | succ n ih =>
      rw [pow_succ]
      exact le_trans (by simpa using hM) (mul_le_mul_of_nonneg_right ih hM0)
  obtain ⟨n, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : k ≠ 0)
  have hself : M ≤ M ^ (n + 1) := by
    rw [pow_succ]
    simpa only [one_mul] using mul_le_mul_of_nonneg_right (hpow n) hM0
  rw [mul_pow]
  exact mul_le_mul_of_nonneg_right hself (pow_nonneg hH _)

end D1Bound5
