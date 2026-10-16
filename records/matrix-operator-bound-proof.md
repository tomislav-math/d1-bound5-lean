# Four-by-four normalized operator-norm estimate

Status: proof sources are saved; verification receipts follow separately. The main bound-five theorem remains unproved.

## Mathematical assertion

Let E be any 4 by 4 complex matrix such that E_ii=0 and |E_ij|<delta for all i!=j, with delta>0. In the matrix L2 operator norm,

    ||E||_2 < 3 delta.

This does not assume E symmetric. The three fixed-point-free permutations
(01)(23), (02)(13), (03)(12) partition every off-diagonal ordered pair exactly once. For each permutation sigma_k let D_k be the diagonal matrix with entries E_(i,sigma_k(i)) and P_k the corresponding permutation matrix. Then

    E = D_0 P_0 + D_1 P_1 + D_2 P_2.

The formal proof verifies the 16 matrix entries exhaustively using ordinary kernel-decided finite permutation values. The l2 operator norm of each P_k is at most one, and the operator norm of each D_k is the supremum of its diagonal entries' complex moduli. Hence ||D_k P_k||_2 < delta, and the triangle inequality proves the claim.

## Application to integral root matrices

Given four complex roots u_i^2=f(a_i) and a symmetric signed integral root matrix S for which every ordered pair satisfies SignedEntryGood, put

    F_ij = u_i f(S_ij) u_j - f(a_i) f(a_j),
    F0_ij = 0 if i=j and 1/2 otherwise,
    E = F-F0.

The existing normalizedRootError_diag theorem gives E_ii=0. The second conjunct of SignedEntryGood gives |E_ij|<128/8649, so the previous theorem yields

    ||F-F0||_2 < 3(128/8649).

The second theorem packages the simultaneous existence of the chosen complex roots and ring-valued signed matrix from exists_good_symmetric_root_matrix_with_roots, retaining the original pairwise square identities. This is the A>=3 spectral perturbation estimate in Lemma product-four. The determinant/adjugate estimates and the distinct A>=1,B>=3 weighted branch are not yet proved.

## Proof trust and scope

Uses Matrix.l2_opNorm_mul, Matrix.l2_opNorm_diagonal, Matrix.permMatrix_l2_opNorm_le and pi_norm_lt_iff from pinned mathlib. No custom axioms, sorry, admit or native_decide in the new sources. A successful compile/axiom audit/kernel replay must be documented in build-record.md before accepting the code as a checked milestone. Previous attempts failed due to an overly broad simp expansion of permutation-matrix products, a recursive rewrite of an equality and a missing noncomputable modifier for F0; these were repaired.

## Validation completed 2026-10-16 (CEST)

The previously saved proof modules were compiled and integrated, with no changes to their proof bodies. Commands executed from the pinned /Users/tp/Lean/D1Bound5 project:

- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.MatrixOperatorNorm D1Bound5.RootMatrixOperatorBound`: exit 0, 2903 Lake jobs.
- `/Users/tp/.local/bin/python3.12 scripts/source_audit.py`: exit 0, 42 modules and 228 explicit theorem declarations, root import coverage checked.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5`: exit 0, 3005 Lake jobs.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean scripts/MatrixOperatorBoundAudit.lean`: exit 0; the elaborated theorem types were inspected and each of the three exported theorems depends only on `propext`, `Classical.choice`, and `Quot.sound`.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.MatrixOperatorNorm`: exit 0.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.RootMatrixOperatorBound`: exit 0.

Raw output is in `local-logs/matrix-operator-targeted-20261015T2239.log`, `matrix-operator-source-20261015T2239.log`, `matrix-operator-integrated-20261015T2239.log`, `matrix-operator-axioms-20261015T2239.log`, and both `matrix-operator-replay-*-20261015T2239.log`. These were targeted same-kernel replays, not a fresh full-project replay or independent external audit. The full bound-five theorem, the determinant/adjugate inequalities, and the A>=1 mixed-row branch remain unproved.
