# Manuscript alignment

The immutable v4 source has SHA256 776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3. The two families are the existing constructions in its finite-family parameter and coefficient tables, not new assumptions.

A4 uses k=4, m=3 and g=2. The coefficient table in Lean is exactly the article table divided by 2. The coefficient bound is 165763, the uniform residual is 63/8, and the total pole-tail degree is 11. The divided determinant is 2910600*x*y*c*(x-y)^15; the original root-column factors multiply it by x*y.

A5 uses k=5, m=4 and g=4. Its coefficient table is exactly the article table divided by 4. The coefficient bound is 3113013, the uniform residual is 495/64, and the tail degree is 14. The divided determinant is -62432370*(x*y)^2*c*(x-y)^19; the original root-column factors again multiply it by x*y.

The actual residue polynomials are identified with the explicit integral matrices. The previously verified unequal-pole convergence and majorant theorem, not a finite truncation or unproved contour identity, supplies the tail bound. Nonzero rows and compatible root signs are constructed in the full ring. All endpoints and input size conditions are preserved, including both closed endpoints.

The original A4 and A5 public theorem headers and all coefficient data remain unchanged. Current repairs affect literal finite-index normalization, numeral transport, and algebraic rewriting only. All statuses require actual pinned compilation, exact-type and transitive-axiom checks, and recorded targeted installed same-kernel replay. Preparation alone is not verification. No accepted-root integration, independent review, clean checkout or final MainStatement completion is claimed by this note.

## Later A5 source-granularity repairs

At 2026-10-20T02:11:39.115918+02:00, the public vector definitions have been refactored into six explicitly typed private scalar definitions to avoid declaration-elaboration heartbeat exhaustion. The coordinate expressions were preserved verbatim, and six original-coordinate rfl examples will be checked in the final audit. The coefficient decomposition was split into six private cases with the original universally quantified public theorem reassembled exhaustively. These changes alter source organization, not the matrix or coefficient values. They do not change any proof limit or final hypothesis.
