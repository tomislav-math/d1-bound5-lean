# PROGRESS — hsymm analytic summability

Initial API probe returned correct pinned signatures for the mathlib negative-binomial series and `Summable.of_norm_bounded`; several unused guessed probe identifiers were absent. The corrected 52-line isolated source `research/continuations/20261017T181708CEST-hsymm-summability/HsymmSummabilityTrial.lean` compiled with Lean 4.33.1, EXIT 0, and printed exactly the permitted axioms `propext`, `Classical.choice`, `Quot.sound` for its new theorem.

The theorem proves convergence of the complex generating series `sum_k z^k h_k(a)` for a nonempty finite alphabet under explicit conditions `0 <= rho`, `norm(a_i) <= rho`, `rho * norm(z) < 1`. It uses the exact `Nat.choose` coefficient majorant, `Nat.choose_symm_add`, and the existing mathlib negative-binomial summability theorem. No distinctness, integrality, or unstated analytic assumptions are added.

The matching root module `D1Bound5/HsymmSummability.lean` was written, its import appended to `D1Bound5.lean`, and the dedicated axiom audit script saved. Pinned integrated build is running and must be collected before acceptance or Git preparation. The earlier staged POST_PUSH receipt remains untouched.
