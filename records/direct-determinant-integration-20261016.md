# Direct four-by-four determinant and same-sign adjugate bridge

## New mathematics (16 October 2026)

For a symmetric zero-diagonal complex 4x4 matrix F with
all six off-diagonal entries within e=128/8649 of 1/2,
the direct determinant polynomial proves

    ||det F|| < h*s^3,
    h=8905/5766, s=3139/5766.

The proof writes the three opposite-edge products P=xw, Q=yv,
R=zu and uses

    det F = P^2+Q^2+R^2-2*(P*Q+P*R+Q*R).

Each of P,Q,R differs from 1/4 by less than 1/40.
Expanding around 1/4 yields the strict rational bound ||det F||<6/25,
which is less than h*s^3.

The new theorem exists_signed_root_matrix_det_and_adjugate_upper
chooses ONE symmetric signed root matrix S over the ORIGINAL commutative ring
and complex roots u_i satisfying u_i^2=f(a_i). It preserves:
* S_ii=a_i, S_ij=S_ji
* S_ij=M_ij or S_ij=-M_ij when i!=j
* S_ij^2=a_i*a_j+1
and simultaneously yields

    ||det(normalizedRootError)|| < h*s^3,
    ||adjugate(normalizedRootError)|| < h*s^2.

The same-witness conclusion avoids an invalid combination of two existential
sign choices. All pair products have modulus >=9, and no ordering or
distinct-modulus assumption is made. Zero square values are not excluded by
an additional hypothesis.

## Limits

The theorem is a structural analytic component. It does NOT yet imply
D>2ABC, because the scaled determinant's arithmetic lower bound,
the squared-size bound on the rank-one input vector, and the appropriate
ordered quadruple reduction must still be connected. The separately weighted
A>=1,B>=3 case, Bennett's all-order determinant identity, finite-graph
coverage, and the final bound-five sextuple exclusions are OPEN.

## Source

Accepted candidates:
- D1Bound5/SymmetricFourDetBound.lean (7 proved theorems)
- D1Bound5/SignedRootMatrixBounds.lean (1 proved theorem)
- scripts/DeterminantIntegrationAudit.lean (elaborated types and axioms)

The exploratory source is retained unchanged. Validation results and exact
log file names are recorded in the dated run report; do not infer an
independent review from a replay using the same Lean kernel.
