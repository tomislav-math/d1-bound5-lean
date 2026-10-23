import Mathlib.RingTheory.Binomial
import Mathlib.Tactic.LinearCombination
import Lean.Elab.Tactic.Omega

open Polynomial

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- A generalized binomial coefficient is nonzero whenever its upper
parameter avoids the first k natural numbers. -/
theorem bennettChoose_ne_zero_of_avoids_naturals (r : F) (k : ℕ)
    (h : ∀ j : ℕ, j < k → r ≠ (j : F)) : Ring.choose r k ≠ 0 := by
  have hpoch : (descPochhammer F k).eval r ≠ 0 := by
    rw [descPochhammer_eval_eq_prod_range]
    apply Finset.prod_ne_zero_iff.mpr
    intro j hj
    exact sub_ne_zero.mpr (h j (Finset.mem_range.mp hj))
  have heq : (descPochhammer ℤ k).smeval r = (descPochhammer F k).eval r := by
    rw [descPochhammer_smeval_eq_ascPochhammer, ascPochhammer_smeval_eq_eval,
      descPochhammer_eval_eq_ascPochhammer]
  intro hz
  have hh := Ring.descPochhammer_eq_factorial_smul_choose r k
  rw [heq, hz, smul_zero] at hh
  exact hpoch hh

/-- Every half-integer parameter in the Bennett node-removal induction
differs from every natural number. This is the exact parity obstruction,
transported through the characteristic-zero cast. -/
theorem bennett_halfInteger_ne_nat (k v j : ℕ) :
    (k : F) + (1 / 2 : F) - (v : F) * (k : F) ≠ (j : F) := by
  intro h
  have heF : ((2 * k + 1 : ℕ) : F) = ((2 * (v * k + j) : ℕ) : F) := by
    push_cast
    linear_combination (2 : F) * h
  have heN : 2 * k + 1 = 2 * (v * k + j) := Nat.cast_injective heF
  omega

/-- The concrete generalized choose factors never vanish at nu=1/2,
including every shifted parameter nu-v*k and k=0. -/
theorem bennett_halfInteger_choose_ne_zero (k v : ℕ) :
    Ring.choose ((k : F) + (1 / 2 : F) - (v : F) * (k : F)) k ≠ 0 := by
  apply bennettChoose_ne_zero_of_avoids_naturals
  intro j _
  exact bennett_halfInteger_ne_nat k v j

end D1Bound5
