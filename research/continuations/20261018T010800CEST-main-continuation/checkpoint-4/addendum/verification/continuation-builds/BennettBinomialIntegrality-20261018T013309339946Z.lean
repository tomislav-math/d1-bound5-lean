import Mathlib.RingTheory.Binomial
import Mathlib.Combinatorics.Enumerative.Catalan.Basic
import Mathlib.Algebra.BigOperators.NatAntidiagonal
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum

open Finset

namespace D1Bound5

/-!
The integer denominator bounds used in the Bennett residue construction.
The rational half-binomial identity is proved from the actual Catalan and
central-binomial identities in mathlib, then transported to every
characteristic-zero field. No coefficient-integrality premise is assumed.
-/

/-- The Catalan recurrence in the form needed for half-binomial coefficients. -/
theorem bennett_catalan_rat_recurrence (n : ℕ) :
    ((n : ℚ) + 2) * (catalan (n + 1) : ℚ) =
      2 * (2 * (n : ℚ) + 1) * (catalan n : ℚ) := by
  have h := Nat.succ_mul_centralBinom_succ n
  rw [← succ_mul_catalan_eq_centralBinom (n + 1),
    ← succ_mul_catalan_eq_centralBinom n] at h
  have hQ : ((n : ℚ) + 1) * (((n : ℚ) + 2) * (catalan (n + 1) : ℚ)) =
      2 * (2 * (n : ℚ) + 1) * (((n : ℚ) + 1) * (catalan n : ℚ)) := by
    exact_mod_cast h
  apply mul_left_cancel₀ (show (n : ℚ) + 1 ≠ 0 by positivity)
  linear_combination hQ

/-- The generalized choose recurrence, specialized to one half. -/
theorem bennett_half_choose_rat_recurrence (n : ℕ) :
    ((n : ℚ) + 1) * Ring.choose (1 / 2 : ℚ) (n + 1) =
      ((1 / 2 : ℚ) - n) * Ring.choose (1 / 2 : ℚ) n := by
  have h := Ring.choose_smul_choose (r := (1 / 2 : ℚ))
    (n := n + 1) (k := n) (Nat.le_succ n)
  simpa [Nat.choose_succ_self_right, nsmul_eq_mul, Ring.choose_one_right,
    mul_comm, mul_left_comm, mul_assoc] using h

/-- Exact Catalan formula: multiplying the positive-degree half-binomial
coefficient by 4 to its degree gives twice a signed Catalan integer. -/
theorem bennett_half_choose_scaled_catalan (n : ℕ) :
    (4 : ℚ) ^ (n + 1) * Ring.choose (1 / 2 : ℚ) (n + 1) =
      (-1 : ℚ) ^ n * 2 * (catalan n : ℚ) := by
  induction n with
  | zero => norm_num [Ring.choose_one_right]
  | succ n ih =>
      have hrec : ((n : ℚ) + 2) * Ring.choose (1 / 2 : ℚ) (n + 2) =
          ((1 / 2 : ℚ) - ((n : ℚ) + 1)) *
            Ring.choose (1 / 2 : ℚ) (n + 1) := by
        convert bennett_half_choose_rat_recurrence (n + 1) using 1 <;>
          simp only [Nat.cast_add, Nat.cast_one] <;> ring
      have hcat := bennett_catalan_rat_recurrence n
      change (4 : ℚ) ^ (n + 2) * Ring.choose (1 / 2 : ℚ) (n + 2) =
        (-1 : ℚ) ^ (n + 1) * 2 * (catalan (n + 1) : ℚ)
      apply mul_left_cancel₀ (show (n : ℚ) + 2 ≠ 0 by positivity)
      calc
        ((n : ℚ) + 2) * ((4 : ℚ) ^ (n + 2) *
            Ring.choose (1 / 2 : ℚ) (n + 2)) =
            (4 : ℚ) ^ (n + 2) * (((n : ℚ) + 2) *
              Ring.choose (1 / 2 : ℚ) (n + 2)) := by ring
        _ = (4 : ℚ) ^ (n + 2) * (((1 / 2 : ℚ) - ((n : ℚ) + 1)) *
            Ring.choose (1 / 2 : ℚ) (n + 1)) := by rw [hrec]
        _ = (-2 * (2 * (n : ℚ) + 1)) *
            ((4 : ℚ) ^ (n + 1) * Ring.choose (1 / 2 : ℚ) (n + 1)) := by
          rw [show n + 2 = (n + 1) + 1 by omega, pow_succ]
          ring
        _ = ((n : ℚ) + 2) * ((-1 : ℚ) ^ (n + 1) * 2 *
            (catalan (n + 1) : ℚ)) := by
          rw [ih, pow_succ]
          linear_combination (2 * (-1 : ℚ) ^ n) * hcat

/-- The explicit integer obtained by clearing a half-binomial coefficient. -/
def bennettScaledHalfInt : ℕ → ℤ
  | 0 => 1
  | n + 1 => (-1) ^ n * 2 * (catalan n : ℤ)

theorem bennett_half_choose_scaled_eq_int (h : ℕ) :
    (4 : ℚ) ^ h * Ring.choose (1 / 2 : ℚ) h = (bennettScaledHalfInt h : ℚ) := by
  cases h with
  | zero => simp [bennettScaledHalfInt]
  | succ n =>
      rw [bennett_half_choose_scaled_catalan]
      simp [bennettScaledHalfInt]

/-- Explicit integer numerator for the shifted half-binomial coefficient.
The finite convolution is Vandermonde with the required powers of four. -/
def bennettScaledHalfShiftInt (k h : ℕ) : ℤ :=
  ∑ uv ∈ Finset.antidiagonal h,
    (4 : ℤ) ^ uv.1 * (k.choose uv.1 : ℤ) * bennettScaledHalfInt uv.2

theorem bennett_shifted_half_choose_scaled_eq_int_rat (k h : ℕ) :
    (4 : ℚ) ^ h * Ring.choose ((k : ℚ) + 1 / 2) h =
      (bennettScaledHalfShiftInt k h : ℚ) := by
  rw [Ring.add_choose_eq h (Commute.all _ _), Finset.mul_sum]
  unfold bennettScaledHalfShiftInt
  push_cast
  apply Finset.sum_congr rfl
  intro uv huv
  have he : uv.1 + uv.2 = h := Finset.mem_antidiagonal.mp huv
  rw [← he, pow_add, Ring.choose_natCast]
  calc
    ((4 : ℚ) ^ uv.1 * 4 ^ uv.2) *
        ((k.choose uv.1 : ℚ) * Ring.choose (1 / 2 : ℚ) uv.2) =
        ((4 : ℚ) ^ uv.1 * (k.choose uv.1 : ℚ)) *
          (4 ^ uv.2 * Ring.choose (1 / 2 : ℚ) uv.2) := by ring
    _ = _ := by rw [bennett_half_choose_scaled_eq_int]; ring

/-- The denominator bound transported to an arbitrary characteristic-zero
field, with the integer numerator displayed explicitly. -/
theorem bennett_shifted_half_choose_scaled_eq_int
    {F : Type*} [Field F] [CharZero F] (k h : ℕ) :
    (4 : F) ^ h * Ring.choose ((k : F) + 1 / 2) h =
      (bennettScaledHalfShiftInt k h : F) := by
  have hmap := congrArg (algebraMap ℚ F)
    (bennett_shifted_half_choose_scaled_eq_int_rat k h)
  simpa only [map_mul, map_pow, Ring.map_choose, map_add, map_natCast,
    map_div₀, map_one, map_ofNat, map_intCast] using hmap

/-- Existential form of the exact denominator bound, valid in every degree. -/
theorem bennett_shifted_half_choose_scaled_is_integer
    {F : Type*} [Field F] [CharZero F] (k h : ℕ) :
    ∃ z : ℤ, (4 : F) ^ h * Ring.choose ((k : F) + 1 / 2) h = (z : F) :=
  ⟨bennettScaledHalfShiftInt k h, bennett_shifted_half_choose_scaled_eq_int k h⟩

/-- A larger uniform power of four clears every coefficient below its
degree bound. This is the form used for a whole order-k residue row. -/
theorem bennett_shifted_half_choose_uniform_is_integer
    {F : Type*} [Field F] [CharZero F] (k h K : ℕ) (hh : h ≤ K) :
    ∃ z : ℤ, (4 : F) ^ K * Ring.choose ((k : F) + 1 / 2) h = (z : F) := by
  refine ⟨(4 : ℤ) ^ (K - h) * bennettScaledHalfShiftInt k h, ?_⟩
  calc
    (4 : F) ^ K * Ring.choose ((k : F) + 1 / 2) h =
        (4 : F) ^ ((K - h) + h) * Ring.choose ((k : F) + 1 / 2) h := by
      rw [Nat.sub_add_cancel hh]
    _ =
        (4 : F) ^ (K - h) *
          ((4 : F) ^ h * Ring.choose ((k : F) + 1 / 2) h) := by
      rw [pow_add]
      ring
    _ = _ := by rw [bennett_shifted_half_choose_scaled_eq_int]; push_cast; rfl

/-- All generalized choose coefficients at an integer upper parameter are
integers, by functoriality of the actual binomial-ring structure on Z. -/
theorem bennett_integer_choose_eq_int
    {F : Type*} [Field F] [CharZero F] (z : ℤ) (h : ℕ) :
    Ring.choose (z : F) h = ((Ring.choose z h : ℤ) : F) := by
  exact (Ring.map_choose (Int.castRingHom F) z h).symm

/-- In particular, the reciprocal pole coefficients have integral binomial
factors for every natural pole order and every Taylor degree. -/
theorem bennett_negative_choose_is_integer
    {F : Type*} [Field F] [CharZero F] (k h : ℕ) :
    ∃ z : ℤ, Ring.choose (-(k : F)) h = (z : F) := by
  refine ⟨Ring.choose (-(k : ℤ)) h, ?_⟩
  simpa only [Int.cast_neg, Int.cast_natCast] using
    (bennett_integer_choose_eq_int (F := F) (-(k : ℤ)) h)

end D1Bound5
