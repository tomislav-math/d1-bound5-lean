# Finite M identity repair, first trial

Time: 2026-10-19T12:28:41.519259+02:00

Actual errors include an unavailable antidiagonal-zero lemma, a non-progressing simplification, and two product-cancellation cases in node injectivity. Replace the unavailable lemma by a proof-producing finite equality, make the optional normalization explicit, and give the six pairwise node inequalities by cancellation. Original public theorem signatures remain unchanged. The first failed source and full log are in wave02. Recompilation remains pending.

## Second actual failure and finite-domain expansion

2026-10-19T12:42:49.396629+02:00

The first repair compiled the injectivity proof but left unresolved coefficients of products over `univ.erase` in the matrix identity. Add the explicit proved equality `univ = {0,1,2,3}` before expanding coefficients, so the finite product is unfolded without relying on numeral-form matching of the erase lemmas. Original failed source/log: wave03. This is an uncompiled repair until a new successful build.

## Third repair — explicit erased finite product

2026-10-19T12:52:07.848454+02:00

The second attempt left products over literal finite sets with an erasure still unevaluated. A private general commutative-monoid lemma now replaces an erased Fin 4 product by four factors, with the erased factor equal to one. It is proved using product congruence, Finset.prod_erase, and Fin.prod_univ_four. The main computation uses this theorem instead of set-literal simplifications. Public signatures remain exactly unchanged. Failed source/log: wave06. New Lean checks remain pending.

The same failed goals also contain the constant-coefficient homomorphism on individual pole series. Add its exact degree-zero identity from bennettPoleSeries_coeff; the simplifier otherwise normalizes coeff 0 to constantCoeff before applying the general coefficient formula. Separate the all_goals phases so any already solved case needs no additional tactic. The third repair has not yet been compiled.
