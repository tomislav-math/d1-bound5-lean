# Finite proof of the cross-block bound

Status: mathematical argument independently audited; Lean drafts awaiting root-owned sequential compilation. No manuscript edit is proposed or performed.

This replaces the analytic Cauchy–Binet step of manuscript Lemma 7.2 by a finite expansion of a three-by-three determinant. It uses the already formalized sign-selection estimate and the accepted cross-block determinant nonvanishing theorem.

Let a_i, b_j be the two separately ordered triples, with A_i=|a_i|, B_i=|b_i|, W_i=A_i B_i and W_0>=9 (indices 0,1,2 below). Choose u_i^2=a_i, v_j^2=b_j. Select signs of the existing integral roots r_ij so that e_ij=u_i r_ij v_j-a_i b_j satisfies |e_ij|<16/31. This sign selection is already available from RootErrorMagnitude and RootMatrixSigns.

For x=a_i b_j, the exact square relation gives e_ij^2+2 x e_ij=x. Hence

F_ij=x(e_ij-1/2)=-e_ij^2/2,

so |F_ij|<128/961<2/15. Set

T_ij=(a_i u_i) r_ij (b_j v_j)=a_i^2 b_j^2+(1/2)a_i b_j+F_ij.

The first two summands form rank-one matrices. In the determinant expansion, any term containing two columns from the quadratic layer or two columns from the linear layer cancels. The retained thirteen terms per determinant permutation are:

- one error from each of the three factors (1 term),
- one quadratic layer and two errors (3 terms),
- one linear layer and two errors (3 terms, coefficient 1/2),
- one quadratic layer, one linear layer, one error (6 terms, coefficient 1/2).

Across all six determinant permutations there are 78 retained monomials. Separate ordering gives A_i^2 A_j <= A_2^2 A_1 when i!=j, and likewise for B. Thus for any common error bound c,

|det T| <= 18c W_2^2 W_1 + 18c^2 W_2^2 + 9c^2 W_2 + 6c^3.

For c=2/15 and W_1,W_2>=9 this is strictly less than (5/2) W_2^2 W_1. The normalized coefficient is at most

18c+(19/9)c^2+(2/243)c^3 < 5/2.

The determinant scaling is exact:

|det T|^2=(W_0 W_1 W_2)^3 |det(r_ij)|^2.

The same signed integral root matrix has nonzero determinant by CrossBlockDeterminant, hence |det(r_ij)|>=1 in the full ring of integers of an imaginary quadratic field. Therefore

(W_0 W_1 W_2)^3 < (25/4) W_2^4 W_1^2,

and positive cancellation gives W_2>(4/25)W_0^3W_1>W_0^3W_1/7. The current endpoint states precisely the manuscript's weaker coefficient 1/7.

## Draft files

1. CrossBlockUpper.lean: exact retained expansion and abstract finite determinant estimate.
2. CrossBlockGrowth.lean: ordered norm envelopes, uniform scaled root error, rational numerical bound, scalar final implication.
3. CrossBlockTuple.lean: simultaneous signs in the original ring, exact norm scaling, generic discrete-domain growth, unconditional full-ring growth, actual IsD1Tuple endpoint for arbitrary two disjoint embedded triples.

No infinite series, analytic branch, Cauchy–Binet limit, nonzero-entry assumption on the roots, or division by a determinant is used.
