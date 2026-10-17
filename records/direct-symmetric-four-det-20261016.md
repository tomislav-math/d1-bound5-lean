# Direct symmetric four-by-four determinant bound

2026-10-16. Mathematical unit completed in the isolated exploration source `exploration/SymmetricFourDetTrial.lean`. The source compiled under the pinned Lean toolchain and all seven new declarations passed transitive axiom audit. Integration into `D1Bound5.lean` and targeted leanchecker replay have NOT occurred, because the authorized file-move operation was blocked by the remote tool's safety check. The current integrated theorem count is unchanged.

## Mathematical argument

For a symmetric zero-diagonal matrix with off-diagonal entries x,y,z,u,v,w, set P=xw, Q=yv, R=zu. Direct Laplace expansion gives

    det F = P^2 + Q^2 + R^2 - 2(PQ+PR+QR).

If all six entries satisfy |entry - 1/2| < e = 128/8649, then

    |P-1/4|, |Q-1/4|, |R-1/4| < 1/40,

because e+e^2 < 1/40. Writing P=1/4+a, Q=1/4+b, R=1/4+c, the determinant polynomial is

    -3/16 - (a+b+c)/2 + (a-b-c)^2 - 4bc.

Hence |det F| < 3/16 + 3/80 + 13/1600 < 6/25. The exact rational comparison

    6/25 < (8905/5766)*(3139/5766)^3

is kernel-proved. This is stronger than the determinant estimate needed in the A>=3 branch of `lem:product-four`. No singular-value theorem is used, and no matrix invertibility is needed for this upper bound.

## Exact formal claims

The seven theorem names are `symmetricZeroFour_det`, `nearHalf_product_nearQuarter`, `threePairDetPolynomial_bound`, `symmetricZeroFour_det_norm_lt`, `symmetric_zero_four_det_upper`, `signed_root_matrix_det_upper`, and `exists_signed_root_matrix_det_upper` (all in namespace `D1Bound5`). The final theorem transports the bound to a single simultaneous symmetric sign choice in the ORIGINAL coefficient ring. Its hypotheses are precisely the already available off-diagonal square relations, symmetric root matrix, fixed diagonal, and pair-product complex norm at least 9. Zero algebraic square roots are permitted by the generic construction where its magnitude hypotheses allow them.

Compiled and axiom-audited command (project root):

    LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean exploration/SymmetricFourDetTrial.lean

Actual exit: 0. Raw log: `local-logs/sym-zero-trial-final-20261016.log`; it reports `SYM_FOUR_TRIAL_AXIOM_PASS: 7 theorems` and lists only `propext`, `Classical.choice`, `Quot.sound` for every new theorem. No `sorry`, `admit`, custom axiom, or native-evaluation shortcut occurs in the source.

Earlier nonpassing attempts and repaired blockers are preserved under `local-logs/sym-zero-trial-02.log` through `-07.log`. The genuine problems were insufficient reduction of concrete `Fin.succAbove` indices and two incorrectly ordered additive monotonicity applications, followed by a missing ring rearrangement and two symmetry orientation subgoals. They are all repaired in the final trial.

## Remaining precise work

1. Move the verified source into an ordinary project module and import it from `D1Bound5.lean`, only when the file operation is authorized and permitted. A direct `move_file` request was blocked before execution. Do not bypass a safety guard.
2. Re-run integrated build, source/import policy, axiom audit and targeted installed-kernel replay after integration; do not claim these checks yet.
3. Prove the perturbative adjugate operator bound `‖adj F‖ < h*s^2`. The determinant upper bound is mathematically settled in this trial, but the full `lem:product-four` still requires that cofactor norm estimate and the A>=1,B>=3 mixed branch.
4. Complete the main bound-five proof's subsequent approximation, Bennett, finite-descent/coverage, and final assembly obligations.
