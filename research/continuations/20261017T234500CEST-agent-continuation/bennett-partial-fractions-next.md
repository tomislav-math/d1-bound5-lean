# Exact partial fractions: available theorem and next specialization

Status: discovery and implementation plan. The specialization below is NOT
implemented by `bennett_residue_coefficient.lean`.

Pinned mathlib revision: 0df444a360eaa60ab8c11dca51a86af692955474.
Primary source inspected directly on the authorized Mac:
`.lake/packages/mathlib/Mathlib/Algebra/Polynomial/PartialFractions.lean`.

## Existing kernel-checked theorem to reuse

`Polynomial.eq_quo_mul_prod_pow_add_sum_rem_mul_prod_pow` states, over a
nontrivial commutative ring, for monic pairwise-coprime `g i` and multiplicities
`n i`, that there exist `q` and remainders `r i j`, `j : Fin (n i)`, with
`degree (r i j) < degree (g i)` and

    f = q * product_i (g i)^(n i)
        + sum_i sum_j r i j * (g i)^j.val * product_{l != i}(g l)^(n l).

The theorem is implemented in mathlib, not an external assumption. Its source
uses polynomial Euclidean division and Bezout identities. The neighboring
`quo_mul_prod_pow_add_sum_rem_mul_prod_pow_unique` proves uniqueness.

Important indexing: in this ACTUAL cleared formula the simple pole is the
highest index `j=n i-1`, despite explanatory prose elsewhere using denominators
`g_i^(j+1)`. The inverse-denominator theorem explicitly reverses indices with
`Fin.revPerm`.

## Exact proposed specialization

Work over a field F, with injective `a : iota -> F`. Put

    g i = X - C(a i), n i = e i + 1, S = sum_i (e i+1).

Use `Polynomial.monic_X_sub_C` and
`Polynomial.pairwise_coprime_X_sub_C ha` (defined in RingDivision.lean) to
instantiate the existing theorem. Its output remainders have degree <1,
therefore each equals `C((r i j).coeff 0)`.

A robust constant-remainder proof is:
- split `r i j = 0`, handled by simplification;
- otherwise use `Polynomial.natDegree_lt_iff_degree_lt` to get natDegree <1;
- deduce natDegree <=0 and apply `Polynomial.eq_C_of_natDegree_le_zero`.

Let B_i,j be `clearedPoleNumerator a e i j` from the new draft. It is monic and
has degree `j.val + sum_{l != i}(e l+1) < S`. Hence every constant multiple has
degree <S, and so does the double sum. This can be shown using `degree_sum_le`
and `Finset.sup_lt_iff (WithBot.bot_lt_coe S)`, which also handles empty index
sets and avoids unnatural natDegree restrictions on the zero polynomial.

If f.degree <S, the quotient q must vanish. One direct exact route is
`Polynomial.div_modByMonic_unique q remainder hQmonic`: after rewriting the
cleared identity as `remainder + Q*q = f`, it gives `f /_m Q = q`.
`Polynomial.divByMonic_eq_zero_iff hQmonic` then gives q=0 from the degree bound.
The denominator degree S follows from monic-product natDegree and
`Polynomial.degree_eq_natDegree hQmonic.ne_zero`.

This produces an unconditional EXISTENCE of constants c and the exact
hypothesis of `coeff_eq_sum_simple_residues`. Under f.degree <S-1, the new
`sum_simple_residues_eq_zero_of_degree_gap` then proves their simple-residue
sum is zero. Uniqueness can be specialized from the same mathlib file.

## What still distinguishes this from Bennett's cancellation

Existence of partial fractions and the zero sum alone do not identify c_i,last
with the explicit finite residue formula from the manuscript. For this:
1. Taylor-shift the cleared identity at node a_i.
2. Divide as formal series by product_{l != i}(a_i-a_l+X)^(n l), whose constant
   coefficient is a unit because nodes are distinct.
3. Other-node terms vanish modulo X^(n i).
4. Extract coefficient n i-1. The Bennett worker's proposed binomial-series
   module supplies the coefficients of each inverse denominator factor.
5. Match the finite product convolution with the manuscript's multi-index sum.

Only after this identification may the algebraic residue sum be used to prove
the residual divisibility required by `bennett_allorder_determinant.lean`.
