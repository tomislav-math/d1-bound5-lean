import D1Bound5.OneSmallRows

namespace D1Bound5
open QuadInt

/-- Exact metadata used when joining the finite fourth-entry certificates to
the analytic retained-triple argument. Every assertion is checked directly
on all 56 manuscript rows. -/
theorem oneSmallFixedRows_metadata :
    ∀ r ∈ oneSmallFixedRows,
      1024 ≤ r.cutoff ∧
      (r.anchorA.norm = 1 ∨ r.anchorA.norm = 2) ∧
      9 ≤ r.anchorB.norm ∧
      (r.anchorA.norm = 2 →
        4*r.anchorA.norm*r.anchorB.norm*r.anchorS.norm < r.cutoff) := by
  decide +kernel

end D1Bound5
