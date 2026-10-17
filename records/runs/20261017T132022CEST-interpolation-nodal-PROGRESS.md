# PROGRESS — nodal moments and uniqueness

Observed project: branch main, HEAD e0f9038; no concurrent project compiler.
The trial source exploration/InterpolationNodalRecurrenceTrial.lean is saved.

Mathematics:
- Arbitrary vanishing polynomials annihilate all weighted power moments.
- Existing mathlib Lagrange.nodal gives a monic order-m recurrence for any
  finite index set and any weights, even with repeated or zero nodes.
- Monicity isolates the next moment in terms of the preceding m moments.
- Strong induction proves uniqueness of the entire moment sequence from
  its first m terms; no injectivity or nonzero-node assumption.

Pinned Lean trial01 EXIT 1 at an ambiguous rewrite of the library's
natDegree_nodal. Replacing it with a typed monicity/cardinality equality
resolved the elaboration issue. Trial02 EXIT 0 for all four theorems.
No user manuscript or external project was changed.
The trial is NOT YET an accepted/root-imported theorem unit.
Next: write a dedicated novel root module, root import, build, exact types,
enforced transitive-axiom audit, targeted installed-kernel replay, source and
fingerprint validation. The main bound-five theorem remains unproved.
