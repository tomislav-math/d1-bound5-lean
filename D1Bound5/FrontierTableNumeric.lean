import D1Bound5.FrontierScalarReduction

namespace D1Bound5

/-- The five rational parameter rows of the manuscript frontier table. -/
def FrontierTableRow (alpha beta target : ℝ) : Prop :=
  (alpha = 1 ∧ beta = 8 ∧ target = 27/8) ∨
  (alpha = 140/99 ∧ beta = 4 ∧ target = 3) ∨
  (alpha = 12/7 ∧ beta = 3 ∧ target = 11/4) ∨
  (alpha = 2 ∧ beta = 3 ∧ target = 29/10) ∨
  (alpha = 20/9 ∧ beta = 3 ∧ target = 3)

/-- All listed parameter rows satisfy the positivity and ordering
conditions needed by the determinant estimate. -/
theorem FrontierTableRow.parameters {alpha beta target : ℝ}
    (h : FrontierTableRow alpha beta target) :
    0 < alpha ∧ 3 ≤ beta ∧ alpha ≤ beta ∧ 5 < alpha*beta ∧
      0 ≤ frontierK alpha beta ∧ 0 ≤ frontierL alpha beta ∧
      0 ≤ frontierQ alpha beta := by
  rcases h with ⟨rfl,rfl,rfl⟩ | ⟨rfl,rfl,rfl⟩ | ⟨rfl,rfl,rfl⟩ |
    ⟨rfl,rfl,rfl⟩ | ⟨rfl,rfl,rfl⟩ <;>
    norm_num [frontierK, frontierL, frontierQ]

/-- All five frontier constants pass the exact rational endpoint check.
This is only the scalar closing step; the determinant inequality is
explicitly displayed here and supplied by the tuple assembly. -/
theorem frontier_table_numeric (alpha beta target tau : ℝ)
    (hrow : FrontierTableRow alpha beta target) (htau : (2/3 : ℝ) < tau)
    (hscalar : tau ≤ 2*frontierK alpha beta*tau^2+
      frontierL alpha beta*frontierP alpha beta*tau+frontierJ alpha beta) :
    target < tau := by
  rcases hrow with ⟨rfl,rfl,rfl⟩ | ⟨rfl,rfl,rfl⟩ | ⟨rfl,rfl,rfl⟩ |
    ⟨rfl,rfl,rfl⟩ | ⟨rfl,rfl,rfl⟩
  · by_contra hbad
    apply frontier_quadratic_interval_exclusion
      (2*frontierK (1) (8))
      (frontierL (1) (8)*frontierP (1) (8)-1)
      (frontierJ (1) (8)) (2/3) (27/8) tau
      (by norm_num [frontierK]) htau (le_of_not_gt hbad)
    · norm_num [frontierK, frontierL, frontierP, frontierJ, frontierQ]
    · norm_num [frontierK, frontierL, frontierP, frontierJ, frontierQ]
    · nlinarith only [hscalar]
  · by_contra hbad
    apply frontier_quadratic_interval_exclusion
      (2*frontierK (140/99) (4))
      (frontierL (140/99) (4)*frontierP (140/99) (4)-1)
      (frontierJ (140/99) (4)) (2/3) (3) tau
      (by norm_num [frontierK]) htau (le_of_not_gt hbad)
    · norm_num [frontierK, frontierL, frontierP, frontierJ, frontierQ]
    · norm_num [frontierK, frontierL, frontierP, frontierJ, frontierQ]
    · nlinarith only [hscalar]
  · by_contra hbad
    apply frontier_quadratic_interval_exclusion
      (2*frontierK (12/7) (3))
      (frontierL (12/7) (3)*frontierP (12/7) (3)-1)
      (frontierJ (12/7) (3)) (2/3) (11/4) tau
      (by norm_num [frontierK]) htau (le_of_not_gt hbad)
    · norm_num [frontierK, frontierL, frontierP, frontierJ, frontierQ]
    · norm_num [frontierK, frontierL, frontierP, frontierJ, frontierQ]
    · nlinarith only [hscalar]
  · by_contra hbad
    apply frontier_quadratic_interval_exclusion
      (2*frontierK (2) (3))
      (frontierL (2) (3)*frontierP (2) (3)-1)
      (frontierJ (2) (3)) (2/3) (29/10) tau
      (by norm_num [frontierK]) htau (le_of_not_gt hbad)
    · norm_num [frontierK, frontierL, frontierP, frontierJ, frontierQ]
    · norm_num [frontierK, frontierL, frontierP, frontierJ, frontierQ]
    · nlinarith only [hscalar]
  · by_contra hbad
    apply frontier_quadratic_interval_exclusion
      (2*frontierK (20/9) (3))
      (frontierL (20/9) (3)*frontierP (20/9) (3)-1)
      (frontierJ (20/9) (3)) (2/3) (3) tau
      (by norm_num [frontierK]) htau (le_of_not_gt hbad)
    · norm_num [frontierK, frontierL, frontierP, frontierJ, frontierQ]
    · norm_num [frontierK, frontierL, frontierP, frontierJ, frontierQ]
    · nlinarith only [hscalar]

end D1Bound5
