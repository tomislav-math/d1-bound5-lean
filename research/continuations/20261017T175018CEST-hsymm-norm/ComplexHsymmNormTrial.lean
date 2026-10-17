import D1Bound5.HomogeneousSymmetric
import Mathlib.Analysis.Complex.Basic
import Mathlib.Data.Sym.Card
import Mathlib.Analysis.Normed.Ring.Basic

open Finset

namespace D1Bound5

/-- Every complete homogeneous symmetric polynomial over a finite complex
alphabet has the exact stars-and-bars coefficient bound. -/
theorem hsymm_aeval_complex_norm_le_choose
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a : ι → ℂ) (k : ℕ) (ρ : ℝ)
    (hρ0 : 0 ≤ ρ) (hρ : ∀ i, ‖a i‖ ≤ ρ) :
    ‖MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ k)‖ ≤
      (Nat.choose (Fintype.card ι + k - 1) k : ℝ) * ρ ^ k := by
  have hproduct : ∀ u : Multiset ι, ‖(u.map a).prod‖ ≤ ρ ^ u.card := by
    intro u
    induction u using Multiset.induction_on with
    | empty => simp
    | @cons b s ih =>
        simp only [Multiset.map_cons, Multiset.prod_cons, Multiset.card_cons]
        calc
          ‖a b * (s.map a).prod‖ = ‖a b‖ * ‖(s.map a).prod‖ := norm_mul _ _
          _ ≤ ρ * ρ ^ s.card := mul_le_mul (hρ b) ih (norm_nonneg _) hρ0
          _ = ρ ^ (s.card + 1) := by rw [pow_succ]; ring
  have hterm (t : Sym ι k) : ‖(t.1.map a).prod‖ ≤ ρ ^ k := by
    simpa only [t.2] using hproduct t.1
  rw [← homogeneousMultisetSum_eq_hsymm]
  unfold homogeneousMultisetSum
  calc
    ‖∑ t : Sym ι k, (t.1.map a).prod‖ ≤
        ∑ t : Sym ι k, ‖(t.1.map a).prod‖ := norm_sum_le _ _
    _ ≤ ∑ _t : Sym ι k, ρ ^ k :=
      Finset.sum_le_sum (fun t _ => hterm t)
    _ = (Fintype.card (Sym ι k) : ℝ) * ρ ^ k := by simp
    _ = (Nat.choose (Fintype.card ι + k - 1) k : ℝ) * ρ ^ k := by
      rw [Sym.card_sym_eq_choose]

end D1Bound5

#check @D1Bound5.hsymm_aeval_complex_norm_le_choose
#print axioms D1Bound5.hsymm_aeval_complex_norm_le_choose
