# Alignment with frozen v4 finite Q family

The original pair rows L_ab, L_as, L_bs, L_at, L_bt and all constants are retained. The exact determinant is equation eq:ff-qdet, 180 a^2 b^2 s^2 t^2 (a-b)^2(a-s)(a-t)(b-s)(b-t)(s-t). FiniteQMatrix checks the polynomial determinant directly, rather than using the manuscript's analytic c-independence argument followed by its constant term. This is an algebraic proof of the identical displayed identity, with no extra nonzero or modulus hypothesis.

The fourth/fifth Taylor remainders retain coefficient 5/128, total coefficient bound 36, residual constant 625/444 < 3/2, transferred coefficient 54 enlarged to 55, and the exact interval endpoints from Table tab:pr-windows. The expected full-ring conclusion rules out the closed D interval [4*55^2*T^6*C^3/(1-1/4000), A^4*C^7/(9*T^2*(1+1/4000))], with four distinct anchors whose moduli lie in [A,T], 4T <= C <= D, and AC >= 1000. Endpoint inclusion, full rings, tied moduli and derivation of nonzero terminal roots must be retained.

All statements in this paragraph describe the reviewed target sources, not a completed Lean verification until the current receipts and audits pass. The frozen manuscript is untouched. The main theorem remains UNPROVED.
