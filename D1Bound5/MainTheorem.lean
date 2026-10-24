import D1Bound5.MainCaseReduction
import D1Bound5.AllLargeImpossible
import D1Bound5.OneSmallImpossible
import D1Bound5.ThreeSmallExclusion
import D1Bound5.TwoSmallNondegenerateImpossible
import D1Bound5.DegeneratePairImpossible

open scoped NumberField
open Module

universe u

namespace D1Bound5

/-- The full-ring cardinality bound, assembled from the three exhaustive
ordered cases. The entries may have equal moduli, and pair square roots
may be zero. -/
theorem main_statement : MainStatement.{u} := by
  apply mainStatement_iff_three_ordered_cases.mpr
  intro K _ _ _ hK phi
  refine ⟨?_, ?_, ?_⟩
  · intro t ht hmon hlarge
    exact ht.all_large_impossible hK phi t hmon hlarge
  · intro t ht hmon hfirst hsecond
    exact ht.not_one_small hK phi t hmon hfirst hsecond
  · intro t ht hmon hsecond
    by_cases hthird : ‖phi (t 2 : K)‖ < 3
    · exact ht.not_three_small hK phi t hmon hthird
    · by_cases hprod : t 0*t 1+1 = 0
      · exact ht.degenerate_first_pair_impossible hK phi t hmon hprod
      · exact ht.two_small_nondegenerate_impossible hK phi t hmon hsecond
          (le_of_not_gt hthird) hprod

end D1Bound5

#check @D1Bound5.main_statement
#print axioms D1Bound5.main_statement
