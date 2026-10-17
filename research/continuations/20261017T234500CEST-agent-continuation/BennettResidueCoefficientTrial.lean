import Mathlib.Algebra.Polynomial.BigOperators
import Mathlib.Algebra.Polynomial.RingDivision
import Lean.Elab.Tactic.Omega

open Finset Polynomial

namespace D1Bound5

section CommRing

variable {R ι : Type*} [CommRing R] [Nontrivial R]
variable [Fintype ι] [DecidableEq ι]

/-- The numerator obtained on clearing the pole at node `i`.
The multiplicity at node `l` is `e l + 1`. The index `j = Fin.last (e i)`
is the simple pole, in exactly the indexing used by mathlib partial fractions. -/
noncomputable def clearedPoleNumerator (a : ι → R) (e : ι → ℕ)
    (i : ι) (j : Fin (e i + 1)) : R[X] :=
  (X - C (a i)) ^ j.val *
    ∏ l ∈ (Finset.univ : Finset ι).erase i, (X - C (a l)) ^ (e l + 1)

theorem clearedPoleNumerator_monic (a : ι → R) (e : ι → ℕ)
    (i : ι) (j : Fin (e i + 1)) : (clearedPoleNumerator a e i j).Monic := by
  apply Polynomial.Monic.mul ((Polynomial.monic_X_sub_C _).pow _)
  exact Polynomial.monic_prod_of_monic _ _ fun l _ ↦
    (Polynomial.monic_X_sub_C _).pow _

theorem clearedPoleNumerator_natDegree (a : ι → R) (e : ι → ℕ)
    (i : ι) (j : Fin (e i + 1)) :
    (clearedPoleNumerator a e i j).natDegree =
      j.val + ∑ l ∈ (Finset.univ : Finset ι).erase i, (e l + 1) := by
  unfold clearedPoleNumerator
  rw [((Polynomial.monic_X_sub_C (a i)).pow j.val).natDegree_mul
    (Polynomial.monic_prod_of_monic _ _ fun l _ ↦
      (Polynomial.monic_X_sub_C (a l)).pow (e l + 1))]
  rw [Polynomial.natDegree_prod_of_monic
    (h := fun l _ ↦ (Polynomial.monic_X_sub_C (a l)).pow (e l + 1))]
  rw [(Polynomial.monic_X_sub_C (a i)).natDegree_pow,
    Polynomial.natDegree_X_sub_C, mul_one]
  congr 1
  apply Finset.sum_congr rfl
  intro l hl
  rw [(Polynomial.monic_X_sub_C (a l)).natDegree_pow,
    Polynomial.natDegree_X_sub_C, mul_one]

/-- At degree one below the denominator degree, only the cleared simple pole
has a nonzero coefficient. This calculation does not require distinct nodes. -/
theorem clearedPoleNumerator_top_coeff (a : ι → R) (e : ι → ℕ)
    (i : ι) (j : Fin (e i + 1)) :
    (clearedPoleNumerator a e i j).coeff ((∑ l, (e l + 1)) - 1) =
      if j = Fin.last (e i) then 1 else 0 := by
  have hsum : e i + 1 + ∑ l ∈ (Finset.univ : Finset ι).erase i, (e l + 1) =
      ∑ l, (e l + 1) :=
    Finset.add_sum_erase _ _ (Finset.mem_univ i)
  split_ifs with hj
  · subst j
    have hd : (clearedPoleNumerator a e i (Fin.last (e i))).natDegree =
        (∑ l, (e l + 1)) - 1 := by
      rw [clearedPoleNumerator_natDegree, Fin.val_last]
      omega
    rw [← hd, Polynomial.coeff_natDegree]
    exact clearedPoleNumerator_monic a e i (Fin.last (e i))
  · apply Polynomial.coeff_eq_zero_of_natDegree_lt
    rw [clearedPoleNumerator_natDegree]
    have hlt := j.isLt
    have hne : j.val ≠ e i := by
      intro heq
      apply hj
      exact Fin.ext heq
    omega

/-- The coefficient one below the denominator degree is the sum of the
simple-pole coefficients in an exact cleared partial-fraction identity.
The identity itself is an explicit hypothesis, not inferred from notation. -/
theorem coeff_eq_sum_simple_residues (a : ι → R) (e : ι → ℕ)
    (c : (i : ι) → Fin (e i + 1) → R) (f : R[X])
    (hdecomp : f = ∑ i, ∑ j : Fin (e i + 1),
      C (c i j) * clearedPoleNumerator a e i j) :
    f.coeff ((∑ l, (e l + 1)) - 1) = ∑ i, c i (Fin.last (e i)) := by
  classical
  rw [hdecomp, Polynomial.finsetSum_coeff]
  apply Finset.sum_congr rfl
  intro i hi
  rw [Polynomial.finsetSum_coeff]
  simp only [Polynomial.coeff_C_mul, clearedPoleNumerator_top_coeff]
  simp

/-- The algebraic residue sum vanishes when an exact cleared decomposition
has numerator degree at least two below the denominator degree. -/
theorem sum_simple_residues_eq_zero_of_degree_gap (a : ι → R) (e : ι → ℕ)
    (c : (i : ι) → Fin (e i + 1) → R) (f : R[X])
    (hdecomp : f = ∑ i, ∑ j : Fin (e i + 1),
      C (c i j) * clearedPoleNumerator a e i j)
    (hdeg : f.degree < ((∑ l, (e l + 1)) - 1 : ℕ)) :
    ∑ i, c i (Fin.last (e i)) = 0 := by
  rw [← coeff_eq_sum_simple_residues a e c f hdecomp]
  exact Polynomial.coeff_eq_zero_of_degree_lt hdeg

end CommRing

end D1Bound5
