# D1Bound5 mixed product-four continuation — verified nonsingularity and draft closure

Date: 2026-10-16 (Europe/Zagreb). Project: `/Users/tp/Lean/D1Bound5`, `main`, starting HEAD `feb2b68`. The authorized Mac and pinned Lean 4.33.1/mathlib project were accessed through Remote Desktop Commander. No project-owned compiler was running at initial or final inspection. The main bound-five theorem remains UNPROVED.

## 1. Newly elaborated and kernel-accepted proof unit

File: `D1Bound5_MixedInvertibility_20261016.lean`.

Theorem: `D1Bound5.mixed_four_det_ne_zero_of_entry_bounds`.

For every complex 4x4 matrix F, assume F_ii=0; |F_ij-1/2|<1/18 for i != j with i=0 or j=0; and |F_ij-1/2|<1/64 for the other off-diagonal entries. Then det(F) != 0. No symmetry is assumed and no complex entry needs be nonzero individually.

Proof: E=F-H, where H has diagonal zero and off-diagonal 1/2. The already accepted weighted Schur theorem yields ||E||_2 <= 11/96. The exact pre-existing operator norm ||H^{-1}||_2=2 gives ||H^{-1}E||_2 <= 11/48 < 1. The existing normed-ring Neumann-series unit lemma, packaged as `reference_perturbed_det_ne_zero`, then gives det(F) != 0. Every estimate is pointwise and compatible with modulus ties and zero radicands in the original D(1) configuration.

A direct pinned command using `lake env lean /dev/stdin` ELABORATED this theorem with exit code 0 (runtime 48.15 seconds). `#print axioms D1Bound5.mixed_four_det_ne_zero_of_entry_bounds` returned exactly `[propext, Classical.choice, Quot.sound]`. The only diagnostic was a harmless suggestion to replace `simpa` by `simp` at line 18. This was source elaboration and ordinary kernel acceptance, NOT `.olean`-based targeted replay and NOT a root build. The source was passed by stdin because writes to the remote project were denied by a safety gate. The stored file mirrors the submitted proof. A separate minimal `#check` of the previously accepted signed-root theorem also exited 0.

## 2. Full mixed growth formalization draft — UNCOMPILED

File: `D1Bound5_MixedProductFourClosure_20261016.lean` (236 lines; SHA256 `a0168cfe9e637efc28e7619741e6e8949908c8367abc4642f5f07617c70a5293`). The first nonvanishing lemma was separately tested as above. The remaining declarations, including the numerical proof unit adapted from the earlier independently tested `/mnt/data/MixedProductFourNumericalTrial.lean`, have NOT been compiled together.

The draft explicitly joins the already kernel-audited mixed determinant and adjugate bounds for a single signed root matrix, the new nonvanishing result, the tail-growth inequality, the real squared-size estimate, the full-ring determinant lower bound, and the exact numerical rank-one closure. It proposes both `full_ring_productFour_mixed_growth` and `IsD1Tuple.productFour_mixed_growth` with the original field/tuple interface, no custom axioms or placeholders.

Exact rational cross-checks (Python Fraction only, not Lean proof):

- `productFourMixedH*productFourMixedS^3 = 31833745/84934656 > 3/10`, with `h=155/96`, `s=59/96`.
- `productFourMixedH*productFourMixedS^2 = 539555/884736`.
- `2/3 - h*s^2*(13/12+s/324) = 133206671/27518828544 > 0`.
- `||H^{-1}E|| <= 11/48 < 1`.

Mathematical reasoning: for the ordered tuple A<=B<=C<=D with A>=1, B>=3, the previously established tail growth D>2BC implies D>18 and A^2+B^2+C^2+D^2<=13D^2/12. The pair products with the first entry have modulus >=3, and other pair products have modulus >=9. Thus one admissible signed integral matrix gives |det F|<3/10 and ||adj F||_2 < h*s^2. The new lemma gives det F != 0. The rank-one bound and exact arithmetic yield |det(F+ww^T)|<(2/3)D^2. On the other hand the even full-ring root determinant lower bound yields A*B*C*D <= |det(F+ww^T)|. Since D>0, this implies (3/2)A*B*C<D. An `IsD1Tuple` bridge uses the already established symmetric root matrix and complete tail growth.

This would close the mixed case only after the full Lean draft passes compilation, an exact elaborated-statement audit, transitive axioms, targeted kernel replay, source/import scan, and integration checks. It does not close the main bound-five theorem.

## 3. Recovery and storage

Remote initial inspection: 2026-10-16T17:38:58+0200, branch `main`, local HEAD `feb2b68`, staged prior mixed-adjugate files and unrelated notes preserved, tail worktree `tail-analytic-20261015` present. Newest staged root-status reports 65 imported modules, 322 proved theorems, successful 3028-job build, 14-claim axiom audit and four target replays (previous run), while its START/PROGRESS run lacked an on-disk FINISH. No rewriting of those notes was attempted.

Two remote write attempts (direct file write and a single simpler terminal write) were rejected by the OpenAI tool safety check before execution. The precise cause is UNKNOWN. No Mac project source was changed. Work was saved instead as sandbox files and sent to the persistent Library folder. No local Git commit or private push was attempted in this invocation. Only the newly isolated stdin lemma was compiled, not the 236-line closure draft.

Next exact action: first inspect whether another run has integrated the mixed numerical closure. If not, insert the isolated nonvanishing lemma and numerical closure in the pinned project, compile the remaining `full_ring_productFour_mixed_growth` and tuple theorem, fix ordinary Lean errors, audit the elaborated statements and allowed axioms, and then stage/commit/push only audited coherent changes. Continue product-five, arbitrary-order Bennett identity, finite coverage/descent and final sextuple exclusions afterwards.
