import D1Bound5.OneSmallCutoffArithmetic

namespace D1Bound5

/-- The finite triple classifier supplies an actual member of the
analytic cutoff table, rather than just an isolated valid record. -/
theorem oneSmallFixedRows_cutoff_member (r : OneSmallTripleRow)
    (hr : r ∈ oneSmallFixedRows) :
    ∃ c ∈ oneSmallCutoffRows, c.triple = r := by
  have hm : r ∈ (oneSmallCutoffRows.map OneSmallCutoffRow.triple).toFinset := by
    rw [oneSmallCutoffRows_triples]
    exact Finset.mem_insert_of_mem hr
  have hl : r ∈ oneSmallCutoffRows.map OneSmallCutoffRow.triple := by
    simpa only [List.mem_toFinset] using hm
  exact List.mem_map.mp hl

end D1Bound5
