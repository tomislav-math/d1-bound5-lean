# Finite Q endpoint statement review

This is the current assistant's source-level mathematical review, not independent review.

The target uses an arbitrary field K with NumberField K, total complexness, and rational dimension two, together with its full integer ring and a complex ring embedding. Four anchors a : Fin 4 -> O_K and terminal entries c,d all lie in one IsD1 set. Injectivity of the anchors, their inequalities to c,d, and c != d specify six distinct entries. Nonzero entries and every square-root witness come from IsD1. No norm tie is excluded.

The scalar hypotheses are A > 0, A <= |a_j| <= T for all four anchors, 4T <= C <= D, and AC >= 1000. The actual full-ring row theorem derives an integral root z with z^2=cd+1 and the strict inequality
1 < 55 T^3 C^2 / |z| + 3 T |z| / (2 A^2 C^4).
It derives z != 0 and the coherent integral root-product signs; no root nonvanishing, row choice, determinant, coefficient or residual certificate is an extra endpoint assumption.

The interval endpoint further assumes
4*55^2*T^6*C^3/(1-1/4000) <= D <= A^4*C^7/(9*T^2*(1+1/4000))
and concludes False. Both endpoints are included. The statement is precisely the finite Q forbidden interval from frozen v4, not an assertion that the other families or all sextuple cases are already excluded. The code permits arbitrary positive A and an arbitrary common upper bound T; setting them equal to the smallest and largest anchor moduli recovers the manuscript specialization.

Exact original type examples for the determinant, full-ring inequality and closed-interval exclusion are included in the actual Lean audit. Final acceptance still requires successful audit and targeted replay receipts. Whole-root validation and independent review remain open.
