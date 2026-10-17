# All-order nodal moment recurrence and initial-data uniqueness

Date: 2026-10-17. Status: verified ISOLATED proof unit; NOT accepted/root-imported.

Let F be an arbitrary field, s a finite index set of size m, and
a_i, b_i in F. Define M_n = sum_{i in s} b_i (a_i)^n, and let
Q(T) = prod_{i in s} (T-a_i) = sum_{k=0}^m q_k T^k.

For every n >= 0, Lean proves

    sum_{k=0}^m q_k M_{n+k} = 0.

Because Q is monic, q_m=1, hence

    M_{n+m} = -sum_{k=0}^{m-1} q_k M_{n+k}.

It also proves that two choices of weights on the same nodes having
equal M_0,...,M_{m-1} have all moments equal, by strong induction.
These statements require no pairwise distinctness or nonzero nodes.
In particular the ordinary Lagrange-weighted moments

    L_n = sum_{i in s} a_i^n / prod_{j in s, j != i} (a_i-a_j)

satisfy exactly this recurrence. In the noninjective case the division
notation still denotes field division and the identity remains valid
because the theorem allows arbitrary weights.

Lean declarations in the standalone proof:
- D1Bound5.polynomial_weighted_moment_annihilation
- D1Bound5.nodal_weighted_moment_recurrence
- D1Bound5.nodal_weighted_moment_step
- D1Bound5.weighted_moments_eq_of_initial
- D1Bound5.lagrange_power_moment_step

This reuses the installed mathlib Lagrange.nodal, Lagrange.nodal_monic,
Lagrange.natDegree_nodal and Lagrange.eval_nodal_at_node. It does not
re-prove the nodal-polynomial theory. It is a necessary algebraic
ingredient for all-order interpolation moments, not the yet-unproved
complete-homogeneous coefficient identity, analytic series remainder,
Bennett determinant, finite coverage or sextuple exclusion.

Proof source:
  research/continuations/20261017T132022CEST-interpolation-nodal/InterpolationNodalRecurrenceTrial.lean
The source is also retained under exploration/ for continuation.

Verification with pinned Lean 4.33.1/mathlib 0df444a360eaa60ab8c11dca51a86af692955474:
- Trial01 EXIT 1: underdetermined typeclass at an implicit rewrite.
- Trial02 EXIT 0: four recurrence/uniqueness proofs.
- Trial03 EXIT 0: five proofs and exact elaborated theorem types.
- Transitive axiom inspection: all five list only propext, Classical.choice,
  Quot.sound. No sorry, admit, sorryAx, custom axioms or native_decide.
- Isolated output-module compilation: EXIT 0.
- Targeted installed same-kernel leanchecker replay of
  exploration.InterpolationNodalRecurrenceTrial: EXIT 0.
- No root-imported Lean proof module, root build, whole-root replay,
  clean-checkout build or independent proof review is claimed.

A separate ordinary root-copy request was PRE_EXECUTION_DENIED before
execution, with cause unknown. It was not retried via another tool.
The original accepted D1Bound5 source/import graph remains unchanged:
82 modules, 387 explicit proved declarations.

Next: after legitimate resolution of the root-integration boundary,
import and audit a dedicated module without changing this proof's
statement. Then identify L_n for n >= m with the complete homogeneous
symmetric polynomial in reciprocal nodes (under the needed nonzero
and injectivity hypotheses) and prove the explicit analytic tail.
