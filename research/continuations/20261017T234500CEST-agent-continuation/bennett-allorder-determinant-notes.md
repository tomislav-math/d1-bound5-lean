# Intermediate all-orders determinant reduction

The source `bennett_allorder_determinant.lean` supplies five general algebraic
lemmas. Their correctness is conditional only on their explicitly stated Lean
hypotheses; the module does not assert that the Bennett residue polynomials
satisfy those hypotheses.

1. Over an arbitrary commutative ring, if a linear combination of the columns
   of a square matrix has all entries divisible by z, and the coefficient of
   one distinguished column is 1, then the determinant is divisible by z.
2. A polynomial matrix with column-j degrees at most d_j has determinant degree
   at most the sum of d_j.
3. A polynomial of degree at most D divisible by X^D is precisely its degree-D
   monomial, including the zero polynomial.
4. Applying the preceding facts gives the determinant-monomial identity under
   explicit residual-divisibility assumptions and columnwise degree bounds.
5. A specialization gives the uniform degree-k case and exponent card(iota)*k.

For the manuscript construction, a_0 = 0. The associated binomial series is
identically 1. The remaining series can be truncated below degree (m+1)k,
leaving polynomial coefficients theta_j with theta_0=1. Thus the exact
assumptions of these lemmas match the intended residual cancellation without
requiring formal power-series topology or inversion.

Remaining work includes defining the all-orders residue polynomials, proving
their degrees, proving the coefficient cancellation and its preservation under
truncation, identifying the monomial coefficient by node removal, and proving
its nonvanishing. None of these conclusions is claimed here.

The determinant lemmas used from the pinned mathlib source are
`Matrix.det_updateCol_sum` and `Matrix.det_updateCol_smul`. The degree argument
uses the Leibniz determinant formula and mathlib's polynomial sum/product degree
bounds. The monomial identity is proved directly by coefficient extensionality.
The draft contains no `sorry`, added axioms, computational reflection, or external
literature assumptions. Root controls compilation and repository integration.
