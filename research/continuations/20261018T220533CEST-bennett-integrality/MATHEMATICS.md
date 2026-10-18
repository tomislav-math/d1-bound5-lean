# Two-anchor Bennett integrality bridge

The current bounded unit concerns the explicitly constructed cleared matrix, not an arbitrary matrix assumed to have integer entries. Let F be any characteristic-zero field and S a subring containing a,b,c. For a,b nonzero and distinct and k>=1, the three column entries are intended to satisfy Q_i0 in S, Q_i1 in a^k S, and Q_i2 in b^k S for every row i. The construction uses nodes (0,b,a), the factor (4*a*b*(a-b)^2)^k and the cleared residue polynomial evaluated at abc.

The three summand lemmas combine the already proved binomial integrality with exact signed denominator cancellation. The finite-sum theorem retains a quotient in the same subring. The three Taylor indices and the row indicator sum are derived from the actual finite antidiagonals; they are not additional hypotheses of the row-lift endpoint. Applying the subring result to a ring-homomorphism image returns witnesses in the original ring. Consequently the full ring of integers can be used without any assumption of unique factorization.

The nonsingularity endpoint is a separate use of the already constructed constant determinant and a nonzero common scalar. It allows c=0. The identification with the original unhomogenized residue explicitly requires c nonzero, because it evaluates at 1/(abc). Zero radicands ac+1 or bc+1 are not excluded by the integrality arguments.

Verification status is given only by the actual build/type/axiom/replay receipts. Prepared source and this mathematical description alone do not assert successful formal verification. The final arithmetic lower bound for the actual approximation form and its analytic estimates remain downstream, as does MainStatement.
