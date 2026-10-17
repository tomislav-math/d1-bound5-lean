# Off-diagonal adjugate cofactor: complete scalar bound

Date: 2026-10-16, 06:27 Europe/Zagreb. This is a separate, kernel-elaborated exploratory unit. The main bound-five theorem is unproved.

## Proven statement

In `exploration/AdjugateOffdiagTrial.lean`:

`D1Bound5.nearHalf_offDiagonal_cofactor_bound`

For any six complex numbers x,y,z,u,v,w with each distance from 1/2 less than epsilon=128/8649,

    |w^2*x - w*z*u - w*y*v + 1/8| < 197/10000.

This is the exact missing scalar inequality for an off-diagonal entry of the adjugate of a symmetric, zero-diagonal 4x4 matrix. The result has no extra assumptions about reality, conjugation, branch choices, or matrix invertibility.

## Proof

Write a=x-1/2, b=z-1/2, c=u-1/2, d=y-1/2, e=v-1/2, f=w-1/2. The polynomial identity

    w²x - wzu - wyv + 1/8 =
        (a-b-c-d-e)/4
      + f*(a-(b+c+d+e)/2)
      + (f²-bc-de)/2
      + f*(af-bc-de)

is verified by Lean's ring tactic. From the six norm bounds |a|,...,|f|<=epsilon, the proof derives the following using explicit triangle inequalities and multiplicativity:

    |a-b-c-d-e| <= 5epsilon
    |a-(b+c+d+e)/2| <= 3epsilon
    |f²-bc-de| <= 3epsilon²
    |af-bc-de| <= 3epsilon².

Consequently the error is at most

    5epsilon/4 + 3epsilon² + (3/2)epsilon² + 3epsilon³.

The final strict rational inequality against 197/10000 is proved by `norm_num`, rather than a floating-point or Python computation.

## Verification and limits

From /Users/tp/Lean/D1Bound5:

    LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean exploration/AdjugateOffdiagTrial.lean

Final run exit 0. Full raw log: `local-logs/adjugate-offdiag-run11-03.log`.
Transitive Lean.collectAxioms returned exactly `[propext, Classical.choice, Quot.sound]`. No sorry, admit, custom axiom, or native evaluation shortcut. Some harmless unused-simp warnings remain.

SHA256 of source: `204e5a3d85e744a5ce1309a44f4ae39db417a6765338b5043019345bb3ebc2a0`.
SHA256 of final raw log: `9a51202eef2bb356b26ad6cab26663b91b9c6fce0b062ec2a69a75b8e9300ac1`.

The first two attempts exited 1 because generic linear arithmetic failed to normalize a denominator division; the third proof uses explicit division monotonicity and additive monotonicity. No theorem was accepted from failed attempts.

The theorem remains in ignored `exploration/`. It has not undergone integrated root build, installed leanchecker replay, or independent review. No new GitHub push was performed. The existing staged and unstaged state was preserved.

## Next mathematically exact obligation

Transfer the scalar inequality to each off-diagonal entry `(F.adjugate-H.adjugate) i j`, using the six-entry representation of a symmetric zero-diagonal 4x4 matrix, with all 12 index orientations accounted for. The previously proved diagonal bound is `nearHalf_triple_cofactor_bound` in `exploration/AdjugateFourTrial.lean`. Then invoke the already compiled conditional operator bound `four_adjugate_bound_of_entry_bounds` and integrate/audit the combined source when permitted. Separately, the A>=1,B>=3 case of product-four, all-orders Bennett identity, finite graph completeness, and final bound-five assembly remain open.
