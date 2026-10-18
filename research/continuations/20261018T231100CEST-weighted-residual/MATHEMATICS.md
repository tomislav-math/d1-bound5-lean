# Weighted Bennett height and analytic residual identification

Status at preparation: UNVERIFIED prepared sources. Later build and audit receipts determine the verified subset.

The weighted-height endpoint combines the already constructed column bounds. For nonzero a,b,c with a!=b, |a|<=|b| and |a||c|>=1000 it proves |Q_i1|/|a|+|Q_i2|/|b| < 2(42|b|^3|c|)^k/|b| for every k>=1 and every row. Its elementary scalar input is monotonicity of (A^2 H)^k/A on positive A for H>=0 and k>=1. Modulus ties are allowed.

BennettResidualEvaluation identifies the actual analytic row sum, not an assumed residual or merely a coefficient bound. In the disk |a_j x|<1, its formal coefficients evaluate absolutely using polynomial-times-binomial Cauchy products. The coefficient at arbitrary r equals choose(k+nu,r) times the sum of local residues of X^r. Previous exact cancellation removes all degrees below card(I)*k, leaving the genuine high-degree tail for every positive order k.

BennettResiduesAtInfinity is the algebraic connection needed to control that tail. For a monic denominator D of positive degree d, the reciprocal of reverse(D) has coefficient t equal to the coefficient of X^(d-1) in X^(d-1+t) mod D. Summing actual local residues yields the same remainder coefficient. The explicit reciprocal product is proved to invert reverse(D). These assertions do not assume analytic convergence.

BennettChooseGamma, if reached and verified in this unit, expresses the absolute shifted-half binomial coefficient by Gamma values at positive half-integers. All arguments are finite choose/factorial identities and the proved Gamma recurrence. No numerical oracle or reflection formula is used.

The full-ring all-order inequality and final theorem are still downstream. No independent review, root integration, complete finite check, clean-checkout build or final completion is claimed by this preparation note.

## Optional coherent downstream completion

The already prepared BennettRepeatedHsymm identifies the formal reciprocal product with complete homogeneous symmetric polynomials on a Sigma type of repeated nodes. BennettResidualBound joins this identity with the analytic tail to bound the actual residue row, rather than a surrogate series. These sources may be checked only after their dependencies pass. Their preparation is not acceptance.
