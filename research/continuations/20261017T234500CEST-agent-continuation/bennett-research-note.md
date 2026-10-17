# Bennett first-order determinant

Status: source drafts supplied for root-controlled compilation. No remote source,
compiler, or Git mutations were performed by this worker. The all-orders Bennett
identity and the manuscript main theorem remain UNPROVED.

## Exact bounded target

Let `a : Fin n -> F` be injective over a field. Put
`w_i = product_{l != i} (a_i-a_l)^(-1)` and let `L_i` be the Lagrange basis
polynomial. Set `D_ij = L_j'(a_i)`. The proposed first module proves

    det(t I - diag(N+a_i) D) = product_{j=0}^{n-1} (t-j).

It also proves the same identity with the factors in the opposite order, using
mathlib's characteristic-polynomial identity for `AB` and `BA`.

The second module identifies the corresponding residue matrix

    F = diag(N^(-1) w_i) (t I - D diag(N+a_i))

with the following explicit entries:

    F_ii = N^(-1) w_i (t-(N+a_i) sum_{l != i} (a_i-a_l)^(-1)),
    F_ij = N^(-1) (N+a_j) w_j / (a_j-a_i)       (i != j).

Consequently

    det F = N^(-n) (product_i w_i) product_{j=0}^{n-1}(t-j).

For `n=m+1`, `t=3/2` and `N != 0` over characteristic zero this is the
manuscript's complete k=1 determinant and nonvanishing assertion, prior to its
additional global clearing factor. The mathematical identification follows by
enumerating the zero/one total-degree index in the manuscript residue formula.
The generic finite multi-index residue-sum definition is not yet present in the
repository and this enumeration has not been separately formalized.

## Proof mechanism

1. Differentiate Lagrange interpolation of each monomial `X^j`, `j<n`. This gives
   `sum_k D_ik a_k^j = j a_i^(j-1)`.
2. In the monomial basis, `t-(N+X)d/dX` sends `X^j` to
   `(t-j)X^j - Nj X^(j-1)`. Its coefficient matrix is upper triangular with
   diagonal `t-j`.
3. The Vandermonde matrix conjugates this coefficient matrix to
   `tI-diag(N+a_i)D`. Distinct nodes make its determinant nonzero, allowing
   cancellation.
4. The diagonal derivative identity is obtained by differentiating the product
   defining `L_i`. Off the diagonal, evaluation of the derivative of the nodal
   product leaves its unique vanishing factor out. This gives
   `w_i D_ij = w_j/(a_i-a_j)`.
5. Row normalization and the `AB`/`BA` characteristic-polynomial identity give
   the residue determinant with all weights and the power of N intact.
6. `3/2-j` cannot be zero for a natural integer j in a characteristic-zero field.
   Thus every factor in the determinant is nonzero.

No square-root branches, contour integration, complex analysis, or assumptions
that `N+a_i` be nonzero enter this k=1 algebraic result. The determinant identity
itself is valid in arbitrary characteristic. Nonvanishing at `t=3/2` uses
characteristic zero.

## Relation to actual repository

The frozen manuscript is
`paper/Diophantine_tuples_bound_five_2026-10-15.tex`, lines 920-1018,
Lemma `ordinary-residue-construction`. Root-imported sources initially had no
Bennett residue definition or determinant proof. The new unit is not a repeat of
the product-four or product-five determinant estimates. It begins the separate
arbitrary-order residue-determinant obligation.

Only k=1 is addressed. No arbitrary-k determinant, polynomial integrality,
residual norm estimate, root-transfer estimate, sextuple exclusion, or main
bound-five theorem follows from this module alone.

## Literature checked

M. A. Bennett, Simultaneous rational approximation to binomial functions,
Transactions of the American Mathematical Society 348 (1996), 1717-1738.
DOI: https://doi.org/10.1090/S0002-9947-96-01480-8
Author-hosted PDF: https://personal.math.ubc.ca/~bennett/B-Binom.pdf

The primary PDF's indexed text reproduces section 2, p. 1721, formula (2.4)
and its following unnumbered determinant identity. Substituting k=1 gives the
explicit entries and factor product above. The full PDF open timed out, so no
visual PDF inspection is claimed. Bennett attributes nonvanishing to Rickert's
Lemma 3.4. The institutional Rickert copy was located at
https://scholar.rose-hulman.edu/cgi/viewcontent.cgi?article=1138&context=math_mstr
but direct retrieval returned 403. The proof in the proposed modules is derived
independently and does not assume either paper's determinant theorem.

## Suggested next step after acceptance

Define the arbitrary-k finite residue sum in a separate module with the exact
Kronecker-delta exponent conventions. Prove its k=1 specialization equals
`bennettFirstOrderExplicit`. Retain the arbitrary-size first-order operator
identity as a reusable ingredient when developing the higher-order Hermite
interpolation analogue. Do not infer k>1 from this base case without a proved
recurrence or independent determinant argument.

## Higher-order route identified during this pass (not formalized)

There is a purely algebraic strategy that should avoid importing the cited
determinant theorem or formalizing complex contour integration. It has two
separate proof obligations.

Write `n=m+1` and `P_ij(x)` for Bennett's degree-at-most-k polynomial matrix.
Let `G_ij(N)=N^k P_ij(1/N)`, also a polynomial of degree at most k.

First, prove the formal-power-series residual cancellation

    sum_j P_ij(x) (1+a_j x)^nu = O(x^(n*k)).

At degree r<n*k, its coefficient is the sum of algebraic residues of

    binom(k+nu,r) w^r / ((w-a_i) product_l(w-a_l)^k).

The rational function has no `w^(-1)` coefficient at infinity, because its
denominator has degree `n*k+1` and the numerator degree is below `n*k`.
Therefore the sum of its finite residues vanishes. This statement can be
proved by partial fractions / Hermite interpolation; it is not yet available
as a project theorem. Replacing one determinant column by the residual column
shows that `det P(x)` is divisible by `x^(n*k)`. The multiplying binomial series
has constant coefficient one, hence is a unit. Since `degree(det P)<=n*k`, the
determinant equals `C*x^(n*k)`. Equivalently, `det G(N)=C` is independent of N.

Second, determine C by induction on n. Evaluate the polynomial matrix G at
`N=-a_q`. Column q is zero off the diagonal; its diagonal entry is

    binom(k+nu,k) product_{l != q}(a_q-a_l)^(-k).

In the complementary submatrix, combine the two summation indices associated
with j and q by Chu--Vandermonde:

    sum_{h_j+h_q=r} binom(k+nu,h_j) binom(-k,h_q) = binom(nu,r).

After removing node q, the resulting submatrix is the same G construction at
parameter `nu-k`, with column j additionally scaled by `(a_j-a_q)^(-k)`.
Thus, with `A'` the node set excluding q,

    C(n,k,nu,a) = binom(k+nu,k)
      * product_{l != q}(a_q-a_l)^(-k)
      * product_{j != q}(a_j-a_q)^(-k)
      * C(n-1,k,nu-k,A').

The one-node base case is exactly `binom(k+nu,k)`. Iteration gives every factor
in Bennett's formula, including both orientations of every node difference.
Evaluation at `N=-a_q` is legitimate even when this is zero, because G is the
cleared polynomial matrix, not a rational evaluation of P(1/N).

This roadmap is a mathematical derivation, not an accepted Lean proof. It
identifies precise reusable next modules: finite algebraic residue cancellation,
power-series determinant divisibility, and the node-removal Chu--Vandermonde
identity. Each must be independently proved before the arbitrary-k endpoint
can be claimed.

Independent mathematical review by the source-audit worker checked the k=1
signs/scaling against the actual frozen residue formula and checked the
higher-order recurrence. It suggested a more elementary form of the residue
cancellation step. Let

    Q(W)=(W-a_i) product_l(W-a_l)^k,      degree Q = n*k+1.

After constructing finite partial fractions for `W^r/Q(W)`, clear Q and
compare the coefficient of `W^(n*k)`. For r<n*k the left coefficient is zero.
A partial-fraction term of pole order h>=2 contributes a polynomial of degree
at most n*k-1. A simple-pole term contributes its residue, since
`Q(W)/(W-a_j)` is monic of degree n*k. Therefore the sum of residues is zero.
This avoids formal Laurent series at infinity as well as analytic contour
integration. Finite partial-fraction existence and the identification of its
simple-pole coefficient with the prescribed finite derivative sum still need
proof.

The currently drafted determinant-divisibility bridge uses a distinguished
zero anchor, so that its multiplier is the constant polynomial one. To use that
bridge in the node-removal induction, remove a nonzero node whenever n>1 and
retain the zero node. The one-node base case then consists of the zero node.
The preceding unrestricted-node mathematical outline used a general unit
series; it must not be claimed as a consequence of the narrower Lean bridge
until unit-modulo-X-power cancellation or a translation argument is supplied.
This design restriction was independently flagged by the source-audit worker.

`BennettPoleSeries.lean` is a separate uncompiled draft supplying the explicit
formal inverse of `(d+X)^k` for d nonzero, with coefficient
`choose(-k,h)*(d^(-1))^(k+h)`. It derives the inverse identity directly from
mathlib's proved binomial-series addition theorem. This is the local factor
needed to identify the partial-fraction remainders with the finite residue sum.
