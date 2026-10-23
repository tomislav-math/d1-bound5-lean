import D1Bound5.PairExtensionCore

namespace D1Bound5
open QuadInt

/-- An explicit pair-extension vertex and square roots of both anchor products.
The checker verifies these equalities; the record itself asserts nothing. -/
structure PairRootWitness (tau nu : ℤ) where
  vertex : QuadInt tau nu
  leftRoot : QuadInt tau nu
  rightRoot : QuadInt tau nu

/-- A candidate outside the bound needs no list membership certificate. -/
def pairWitnessCandidateCoveredBool {tau nu : ℤ} (bound : ℤ)
    (vertices : List (QuadInt tau nu)) (w : QuadInt tau nu) : Bool :=
  if decide (w.norm ≤ bound) then decide (w ∈ vertices) else true

/-- Verify supplied roots and the two distinct mutation values. The four
choices of signs for the two supplied roots yield precisely these two values.
This computation contains no square-root search. -/
def pairRootWitnessCheckedBool {tau nu : ℤ} (a b r0 : QuadInt tau nu)
    (bound : ℤ) (vertices : List (QuadInt tau nu))
    (w : PairRootWitness tau nu) : Bool :=
  decide (w.leftRoot * w.leftRoot = a * w.vertex + 1 ∧
    w.rightRoot * w.rightRoot = b * w.vertex + 1) &&
    (pairWitnessCandidateCoveredBool bound vertices
        (mutate a b w.vertex r0 w.leftRoot w.rightRoot) &&
      pairWitnessCandidateCoveredBool bound vertices
        (mutate a b w.vertex r0 w.leftRoot (-w.rightRoot)))

/-- A replacement closure certificate. It verifies the anchor root, exact
coverage in the original vertex order, all vertex roots, and both mutations.
The original vertex list and final mathematical closure claim are unchanged. -/
def pairClosureWitnessBool {tau nu : ℤ} (a b r0 : QuadInt tau nu)
    (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu)) : Bool :=
  decide (r0 * r0 = a * b + 1 ∧ witnesses.map PairRootWitness.vertex = vertices) &&
    witnesses.all (pairRootWitnessCheckedBool a b r0 bound vertices)

/-- In positive-definite quadratic coordinates, two square roots of the same
element agree up to sign. Neither root is required to be canonical. -/
theorem quadInt_root_eq_or_neg_of_sq_eq {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (r q : QuadInt tau nu)
    (h : r * r = q * q) : r = q ∨ r = -q := by
  have hf : (r - q) * (r + q) = 0 := by
    calc
      _ = r * r - q * q := by ring
      _ = 0 := sub_eq_zero.mpr h
  rcases quadInt_mul_eq_zero hd hf with hzero | hzero
  · exact Or.inl (sub_eq_zero.mp hzero)
  · exact Or.inr (eq_neg_of_add_eq_zero_left hzero)

/-- Arbitrary genuine root choices give one of the two supplied-root
mutations, including when one of the roots is zero. -/
theorem mutate_eq_supplied_roots {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b z r0 r s R0 R S : QuadInt tau nu)
    (h0 : r0 * r0 = a * b + 1) (hr : r * r = a * z + 1)
    (hs : s * s = b * z + 1) (hR0 : R0 * R0 = a * b + 1)
    (hR : R * R = a * z + 1) (hS : S * S = b * z + 1) :
    mutate a b z R0 R S = mutate a b z r0 r s ∨
      mutate a b z R0 R S = mutate a b z r0 r (-s) := by
  rcases quadInt_root_eq_or_neg_of_sq_eq hd R0 r0 (hR0.trans h0.symm) with h0 | h0 <;>
    rcases quadInt_root_eq_or_neg_of_sq_eq hd R r (hR.trans hr.symm) with hr | hr <;>
    rcases quadInt_root_eq_or_neg_of_sq_eq hd S s (hS.trans hs.symm) with hs | hs
  all_goals rw [h0, hr, hs]
  all_goals unfold mutate
  · left; ring
  · right; ring
  · right; ring
  · left; ring
  · right; ring
  · left; ring
  · left; ring
  · right; ring

/-- Both original deterministic neighbors are among the supplied-root
mutations. Canonical roots occur only in this symbolic soundness proof. -/
theorem pairMutation_eq_supplied_roots {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b z r0 r s : QuadInt tau nu)
    (h0 : r0 * r0 = a * b + 1) (hr : r * r = a * z + 1)
    (hs : s * s = b * z + 1) {w : QuadInt tau nu}
    (hw : w = pairMutationPlus a b z ∨ w = pairMutationMinus a b z) :
    w = mutate a b z r0 r s ∨ w = mutate a b z r0 r (-s) := by
  have hc0 := rootCandidate_complete hd (show ∃ q, q * q = a * b + 1 from ⟨r0, h0⟩)
  have hcr := rootCandidate_complete hd (show ∃ q, q * q = a * z + 1 from ⟨r, hr⟩)
  have hcs := rootCandidate_complete hd (show ∃ q, q * q = b * z + 1 from ⟨s, hs⟩)
  rcases hw with rfl | rfl
  · exact mutate_eq_supplied_roots hd a b z r0 r s _ _ _ h0 hr hs hc0 hcr hcs
  · exact mutate_eq_supplied_roots hd a b z r0 r s _ _ _ h0 hr hs hc0 hcr
      (by simpa only [neg_mul_neg] using hcs)

theorem pairWitnessCandidateCovered_of_checked {tau nu : ℤ}
    (bound : ℤ) (vertices : List (QuadInt tau nu)) (w : QuadInt tau nu)
    (hcheck : pairWitnessCandidateCoveredBool bound vertices w = true)
    (hbound : w.norm ≤ bound) : w ∈ vertices := by
  simpa [pairWitnessCandidateCoveredBool, hbound] using hcheck

/-- The witness certificate supplies exactly the closure hypothesis used by
the accepted full-ring descent completeness theorem. -/
theorem pairClosure_of_witness_checked {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b r0 : QuadInt tau nu)
    (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu))
    (hcheck : pairClosureWitnessBool a b r0 bound vertices witnesses = true)
    {z w : QuadInt tau nu} (hz : z ∈ vertices)
    (hw : w = pairMutationPlus a b z ∨ w = pairMutationMinus a b z)
    (hbound : w.norm ≤ bound) : w ∈ vertices := by
  have hparts := Bool.and_eq_true_iff.mp hcheck
  have hdata : r0 * r0 = a * b + 1 ∧
      witnesses.map PairRootWitness.vertex = vertices := of_decide_eq_true hparts.1
  have hzmap : z ∈ witnesses.map PairRootWitness.vertex := by rwa [hdata.2]
  obtain ⟨v, hv, hvz⟩ := List.mem_map.mp hzmap
  have hc := List.all_eq_true.mp hparts.2 v hv
  have hvparts := Bool.and_eq_true_iff.mp hc
  have hroots : v.leftRoot * v.leftRoot = a * v.vertex + 1 ∧
      v.rightRoot * v.rightRoot = b * v.vertex + 1 := of_decide_eq_true hvparts.1
  have hneighbors := Bool.and_eq_true_iff.mp hvparts.2
  have hw' : w = pairMutationPlus a b v.vertex ∨
      w = pairMutationMinus a b v.vertex := by simpa only [hvz] using hw
  rcases pairMutation_eq_supplied_roots hd a b v.vertex r0 v.leftRoot v.rightRoot
    hdata.1 hroots.1 hroots.2 hw' with hplus | hminus
  · rw [hplus] at hbound ⊢
    exact pairWitnessCandidateCovered_of_checked bound vertices _ hneighbors.1 hbound
  · rw [hminus] at hbound ⊢
    exact pairWitnessCandidateCovered_of_checked bound vertices _ hneighbors.2 hbound

/-- A witness certificate proves the original Boolean closure certificate.
Consumers such as `small_pair_graph_excludes_three_full_ring` need no change. -/
theorem pairClosureBool_of_witness_checked {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b r0 : QuadInt tau nu)
    (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu))
    (hcheck : pairClosureWitnessBool a b r0 bound vertices witnesses = true) :
    pairClosureBool a b bound vertices = true := by
  apply List.all_eq_true.mpr
  intro z hz
  apply Bool.and_eq_true_iff.mpr
  constructor
  · by_cases hbound : (pairMutationPlus a b z).norm ≤ bound
    · have hmem := pairClosure_of_witness_checked hd a b r0 bound vertices witnesses
        hcheck hz (Or.inl rfl) hbound
      simp [hbound, hmem]
    · simp [hbound]
  · by_cases hbound : (pairMutationMinus a b z).norm ≤ bound
    · have hmem := pairClosure_of_witness_checked hd a b r0 bound vertices witnesses
        hcheck hz (Or.inr rfl) hbound
      simp [hbound, hmem]
    · simp [hbound]

end D1Bound5
