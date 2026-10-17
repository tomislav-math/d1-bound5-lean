# Lagrange moment node adjunction and all-degree homogeneous identification

17 October 2026. Mathematical derivation (English). The accompanying Lean
source is **UNCOMPILED** because the attempted compiler invocation was refused
before execution. No kernel proof or theorem acceptance is claimed here.

## Exact algebraic lemma

Let F be any field, S a finite set of indices, t a new index, and
a:S ∪ {t}→F with a_i≠a_t for all i in S. Coincidences among the
values at indices of S are allowed for this lemma. Define the field-valued
barycentric moments (where division by zero has its usual totalized field
meaning)

L_S(n) = Σ_{i∈S} a_i^n / Π_{j∈S, j≠i}(a_i-a_j).

Then, for every n≥0,

    L_{S∪{t}}(n+1) = a_t L_{S∪{t}}(n) + L_S(n).

Indeed, for each index i in S∪{t},

    a_i^(n+1) = a_t a_i^n + (a_i-a_t)a_i^n.

After division by its barycentric denominator, sum over all indices.
The second summand vanishes at i=t. For i∈S, its denominator is
(a_i-a_t) times the old denominator. Since a_i-a_t≠0, that factor
cancels, whether or not the remaining old denominator is zero.
This establishes the lemma without requiring nonzero nodes or
pairwise distinct values within S.

The proposed Lean source
research/continuations/20261017T162240CEST-lagrange-node-adjunction/
LagrangeNodeAdjunctionTrial.lean spells out the two crucial identities.
It still requires a successful pinned Lean compilation and axiom audit
before any Lean proof status can be asserted.

## Complete mathematical proof of the full all-order moment identity

Assume now that the values a_i for i∈S are pairwise distinct and S is
nonempty, with m=|S|. Define H_S(k) as the complete homogeneous
symmetric polynomial of degree k in the a_i, namely

    H_S(k) = Σ_{(e_i)_{i∈S}∈ℕ^S, Σ e_i=k} Π_{i∈S} a_i^(e_i).

For all k≥0 the exact identity is

    L_S(m-1+k) = H_S(k).                                    (1)

Proof by induction on m. When m=1, L_{ {t} }(k)=a_t^k=H_{ {t} }(k).

Assume the result for an m-element index set S (m≥1), and adjoin
an index t with a_t distinct from all old values. Denote S∪{t} by T,
so |T|=m+1. The elementary Lagrange interpolation coefficient identity
gives L_T(m-1)=0, since m-1<|T|-1. Also L_S(m-1)=1 by the
induction hypothesis at k=0. Therefore node adjunction gives

    L_T(m) = a_t L_T(m-1) + L_S(m-1) = 1 = H_T(0).

For k≥1, induction on k together with node adjunction and the
induction hypothesis for S yields

    L_T(m+k)
      = a_t L_T(m+k-1) + L_S(m+k-1)
      = a_t H_T(k-1) + H_S(k)
      = H_T(k).

The last equality is the one-step complete homogeneous variable
adjunction identity. Thus (1) holds for all finite nonempty sets.
The induction includes zero nodes and does not assume positive
characteristic, positivity, or separateness of absolute values.
The source already contains separately kernel-verified statements
of both ingredients, namely lagrange_power_moment_low and
homogeneousMultisetSum_option_succ; type/subtype transport and
Lean induction assembly have NOT been formalized here.

## Reciprocal consequence

For pairwise distinct nonzero a_i, let b_i=1/a_i. The earlier
reciprocal-anchor transfer and (1) give, for every k≥0,

    Σ_i b_i^(k+1) / Π_{j≠i}(a_i-a_j)
       = (-1)^(m-1) / (Π_i a_i) · H_{(b_i)}(k).

This is a mathematical corollary, **not yet an accepted Lean theorem**.
It supplies exactly the all-k algebraic interpolation formula but
does not establish any of the required analytic remainder inequalities.

## Status and next Lean steps

(1) Compile and repair the isolated node-adjunction source after a
legitimate resolution of the refused compiler invocation.
(2) Establish a verified finite-index induction that transports the
previous all-degree hsymm Option-index recursion to the subtype of
Finset.insert, including the degree-zero base case and zero nodes.
(3) Apply the already verified Lagrange low-degree sum and node
recurrence to formalize (1), then combine it with the previously
verified reciprocal-anchor transfer.
(4) Only afterwards attack analytic interpolation errors and
the independent arbitrary-order Bennett determinant obligation.

MainStatement still UNPROVED. No change was made to the accepted root,
frozen paper, or handoff.
