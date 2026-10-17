# FINISH — 2026-10-17 16:03 CEST

Outcome: COMPLETED_UNIT (three genuinely new standalone mathematical theorems). Bound-five `MainStatement` remains UNPROVED.

## Proved

For an arbitrary field and any finite set of m>=2 distinct interpolation nodes, the second-below-leading nodal coefficient is the elementary symmetric value e2, and the barycentric power moment at degree m+1 is exactly e1^2-e2, i.e. the second complete homogeneous symmetric value h2. For pairwise distinct nonzero anchors a_i, the reciprocal Vandermonde transfer now gives the explicit degree-three negative-power Lagrange sum as (-1)^(m-1)/product(a_i) times h2 of the reciprocal nodes. Precise elaborated types and complete source are in `research/continuations/20261017T154335CEST-hsymm-recurrence/SecondHomogeneousMomentTrial.lean`, SHA256 758416a8bd474aa4a1e8de7552d3a32a2aa2eef923c1fed655f2eafb14004db2. Mathematical record: `records/second-homogeneous-moment-20261017.md`.

The first attempted two recurrence declarations are a DUPLICATE of the prior five-theorem `InterpolationNodalRecurrenceTrial.lean` and are NOT counted as new. They are retained with this explicit caveat.

## Verification

Pinned Lean 4.33.1/mathlib 0df444a360eaa60ab8c11dca51a86af692955474: trial01 failed, repaired trial02/03 and final warning-free trial04 exit zero. Isolated .olean compilation EXIT 0, installed same-kernel targeted leanchecker EXIT 0. Exact three theorem types and each transitive axiom list verified; only propext, Classical.choice, Quot.sound. Static trust scan found no sorry, admit, custom axioms or native-evaluation shortcuts. Three imported exploratory sources were verified byte-identical to their own reviewed archive copies. Existing accepted root source audit PASS (82 modules/387 theorems) and both existing source/tool SHA256 manifests EXIT 0. No claim of new accepted root imports, independent statement review, fresh clean checkout, or whole-project kernel replay.

## Concurrency and handoff

The separate scheduled 15:45 hsymm Option-variable worker ran concurrently with this invocation. The overlap was discovered at 16:03 after both proof units completed. Each used a distinct research directory; no source/index/file of the other run was modified, no process killed and no compilation is left running. Single-worker exclusion was not fully maintained during the overlap, and no contrary claim is made. The other worker's genuine all-order hsymm splitting result is preserved in its own 20261017T154548CEST continuation. Inspect all active sessions before another heavy compilation.

## Unfinished / next

The actual identity with mathlib MvPolynomial.hsymm for ALL k remains OPEN, as do the analytic remainder inequalities, Bennett arbitrary-order determinant, complete finite certification/coverage, descent termination and final sextuple exclusions. Final target still only a proposition. Combine the other worker's all-order hsymm variable-addition theorem with previous nodal recurrence/remainder work next. Git publication of this unit PENDING ordinary explicit review/staging/commit/push; a separate receipt must confirm any result. Frozen manuscript/handoff unchanged.
