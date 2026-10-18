# Main target and exact three-case reduction

Status: local uncompiled draft for coordinator-controlled Lean compilation. This worker performed no remote writes or compilation.

Current actual `Specification.MainStatement` and `Basic.IsD1` were reread. The target remains every finite set of distinct nonzero elements of the full `NumberField.RingOfIntegers K`, where `[NumberField K]`, `[NumberField.IsTotallyComplex K]`, and `finrank Q K = 2`. Every pair sum `xy+1` has a square root in that same ring; a zero square root is allowed. The equivalent field-root convention has already been proved.

The existing `Sextuple.card_bound_iff_no_ordered_sextuple` already selects six distinct entries and orders them using a monotone weight function, retaining all modulus ties. There was no source declaration for a final all-large, exactly-one-small, or at-least-two-small exclusion at this inspection. Only the generic ordered-sextuple reduction existed.

The new draft builds on that existing reduction. It proves three exact ordering characterizations and the equivalence of the cardinality bound with three explicit ordered exclusions. Its full-ring endpoint is

`MainStatement <-> (for every imaginary quadratic K and every complex embedding phi, all three exclusions hold)`.

Writing `A=norm(phi(t 0))` and `B=norm(phi(t 1))`, the branches are exactly:

- `3 <= A`;
- `A < 3` and `3 <= B`;
- `B < 3`.

Monotonicity makes these respectively no small entries, exactly one small entry, and at least two small entries. Boundary modulus three belongs to the large branch. Equal moduli, half-integral coordinates, zero pair radicands, and negative or complex entries are not excluded. The reduction has no norm-growth assumptions.

The main equivalence quantifies over every complex embedding on its right side. Its reverse implication chooses an embedding using the actual number-field instance, rather than silently assuming the embedding exists or using an empty universal quantifier. No new mathematical predicate or own axiom hides the branch hypotheses.

The manuscript's final branch propositions are stronger set-level statements, but their restrictions to these ordered sextuples are precisely sufficient for `MainStatement`. This draft does not prove any of them and must not be counted as progress on their analytic or finite-exhaustion arguments. Its role is to fix a faithful, mechanically checkable assembly interface before substantive branch proofs are attached.
