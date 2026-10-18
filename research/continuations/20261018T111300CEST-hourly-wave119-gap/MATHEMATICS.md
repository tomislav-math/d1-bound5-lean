# Coherent retained gap verification

This run verifies the already reviewed wave119 source `D1Bound5/CoherentRetainedGap.lean` without changing its proof body or theorem statements.

The module proves two linked results. First, under the no-small-entry ordering and two frontier growth hypotheses for five distinct entries of a D(1)-tuple in the full ring of integers of an imaginary quadratic field, it derives the retained H48 analytic gap with the explicit constants `9999/10000`, `200/19`, and `51051/400000`. The proof derives the quotient-form bounds, nonvanishing/integrality gap, terminal root estimates, and normalized Vandermonde estimates from imported verified lemmas.

Second, after sharpening the four-entry frontier from coefficient 2 to 3, it converts the retained gap into the explicit monomial lower bound

`400 * (A^7 * B^5 * S^3) < C`.

The hypotheses still quantify over the full ring of integers, retain injectivity and membership in an actual D(1)-tuple, allow the ambient imaginary quadratic field through the totally complex degree-two assumptions, and do not assume a root witness or the desired retained-gap inequality. This is one dependency unit, not the final bound-five theorem.
