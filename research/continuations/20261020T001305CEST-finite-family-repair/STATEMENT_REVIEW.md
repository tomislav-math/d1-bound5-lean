# Source-level mathematical statement review

This is a review by the current proof developer, not an independent external review. The exact original-signature audit and kernel-replay receipts are recorded separately.

Let K be an arbitrary degree-two totally complex number field, phi an embedding into C, and (x,y,c,d) an IsD1Tuple in the full ring of integers. Write X=|phi(x)|, Y=|phi(y)|, C=|phi(c)| and D=|phi(d)|. The actual A3 endpoint assumes only X<=Y, 1000<=X*C, 200*Y<=C and C<=D, in addition to the tuple and field data. It proves that D cannot belong to the closed interval

[4*2265^2*Y^12*C^7/(1-1/4000), 64*X^8*C^9/(1225*Y^6*(1+1/4000))].

Both endpoints are included. The preceding tuple theorem constructs a full-ring square root z with z^2=c*d+1 and proves

1 < 2265*Y^6*C^4/|phi(z)| + (35/16)*Y^3*|phi(z)|/(X^4*C^5).

The tuple predicate retains distinct nonzero entries and existential square roots for every distinct pair. No assumption requires those pair roots to be nonzero. The proof derives the needed terminal root nonvanishing from the displayed size conditions. Equality of anchor moduli is permitted. No coordinate basis or particular field parameter occurs in this analytic endpoint, so half-integral full rings are not excluded.

The actual polynomial matrix, its determinant, root-column height, residual identity and convergent residual estimate are proved dependencies. They are not supplied as unproved premises to the final interval theorem. No claim is made that this one approximation family completes the sextuple exclusions or MainStatement.
