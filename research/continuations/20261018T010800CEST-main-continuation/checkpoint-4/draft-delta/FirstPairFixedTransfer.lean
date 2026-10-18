import D1Bound5.FirstPairGeometryFixedRows

namespace D1Bound5

/-- Matching coordinate pairs have identical exact squared norms and
separation, even though the unused third coordinate differs. -/
theorem FirstPairGeometryMatches.pair_invariants
    (g : FirstPairGeometryRow) (r : OneSmallCutoffRow)
    (h : FirstPairGeometryMatches g r) :
    g.a0 = r.a0 ∧ g.b0 = r.b0 ∧ g.dab = r.dab := by
  rcases h with ⟨ht,hn,ha,hb,_⟩
  simp [FirstPairGeometryRow.a0,FirstPairGeometryRow.b0,FirstPairGeometryRow.dab,
    FirstPairGeometryRow.anchorA,FirstPairGeometryRow.anchorB,
    OneSmallCutoffRow.a0,OneSmallCutoffRow.b0,OneSmallCutoffRow.dab,
    OneSmallTripleRow.anchorA,OneSmallTripleRow.anchorB,
    QuadInt.norm,ht,hn,ha,hb]

/-- The pair-dependent residual coefficients agree exactly. The P rate
uses a different geometric enclosure and is deliberately not identified. -/
theorem FirstPairGeometryMatches.residual_rates
    (g : FirstPairGeometryRow) (r : OneSmallCutoffRow)
    (h : FirstPairGeometryMatches g r) :
    g.R2 = r.R2 ∧ g.Rn = r.Rn ∧ g.R3 = r.R3 ∧
      g.R4 = r.R4 ∧ g.R5 = r.R5 := by
  obtain ⟨_,hb,hd⟩ := FirstPairGeometryMatches.pair_invariants g r h
  simp [FirstPairGeometryRow.R2,FirstPairGeometryRow.Rn,
    FirstPairGeometryRow.R3,FirstPairGeometryRow.R4,FirstPairGeometryRow.R5,
    OneSmallCutoffRow.R2,OneSmallCutoffRow.Rn,
    OneSmallCutoffRow.R3,OneSmallCutoffRow.R4,OneSmallCutoffRow.R5,hb,hd]

end D1Bound5
