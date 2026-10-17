# FINISH — 17 October 2026, 16:52:53 CEST

Outcome: PARTIAL. An independently scoped, new finite reciprocal-pole Taylor-tail proof was developed mathematically and saved as a full Lean proof ATTEMPT. The Lean draft was NOT compiled or accepted.

Mathematical identity proved on paper for every field, a!=0,z, n>=0:
  1/(a-z) = sum_(k<n) z^k/a^(k+1) + z^n/(a^n(a-z)).
Multiplication by arbitrary finite weights and interchange of finite sums gives the all-node exact rational remainder. Proof: telescope R_k=z^k/(a^k(a-z)), noting R_k-R_(k+1)=z^k/a^(k+1). No analyticity, distinctness of nodes, nonzero weights, or characteristic restrictions are required.

Saved:
- research/continuations/20261017T164712CEST-pole-tail/WeightedPoleFiniteTailTrial.lean, SHA256 8f59a0fb5599e2fc87d4ce72f31341bd9fc27d913ba47867648c9794e6d8c049;
- records/runs/20261017T164712CEST-pole-tail-{START,PROGRESS,PRE_EXECUTION_DENIED,FINISH}.md.

A longer mathematical note was NOT saved: explicit safety refusal from Remote_Desktop_Commander.write_file before execution; exact message in PRE_EXECUTION_DENIED. No bypass attempted. The saved Lean source passed only a static forbidden-token grep. It has NO observed Lean compilation exit code, no elaborated theorem-type/axiom audit and no kernel replay. The separate interpolation-recovery project writer was active with its own root builds during this unit, so no competing heavy compiler and no change to that writer's root files/index were attempted.

Git: NOT STAGED, NOT COMMITTED, NOT PUSHED. Inspected branch main, local HEAD 64a1094 (one commit ahead of origin/main as observed); zero staged paths at 16:52:53. No post-push verification or claim of remote delivery. All this run's files are local-only PENDING_GITHUB_UPLOAD. Preserve and reconcile against the concurrent writer before any later ordinary reviewed Git operation.

Remaining gap: compile and repair this isolated trial legitimately when no project-owned compiler/writer conflicts, inspect exact elaborated types and transitive axioms, run installed same-kernel replay, then formalize the multi-pole rational identity and stable complex binomial tail bound. The all-degree homogeneous interpolation identity may be in progress in the concurrent separate run and must be checked before duplicate work. The arbitrary-order Bennett determinant, analytic inequalities, finite exhaustive coverage/descent and final sextuple exclusions remain open. MainStatement remains UNPROVED.

No unrelated automation, frozen manuscript, or handoff was modified.
