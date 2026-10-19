# Alignment with the frozen v4 unit-pair proof

This unit retains the article's reduction from a possible ordered sextuple containing {-1,1} to a common squarefree field parameter, its norm-two Pell descriptions, its continued-fraction cutoff 10^275 and extension radius 10^550, and both relative-sign compatibility tests.

The substantive formalization adjustment concerns evaluation granularity. The original universal field-coverage predicate over Fin 1250 is unchanged, but its single decide +kernel proof exceeded the 240-second compiler limit. Twenty-five blocks of fifty original indices now prove it. The later blocks evaluate a pure-Init integer predicate, linked to the original certificate-valued predicate by two proved list equalities and a proved logical equivalence. The quotient/remainder join proves that every original index is covered; no sampling, omitted edge, field restriction, or external computation is an assumed premise.

The original certificate-existence theorem, including its body, is unchanged. The two full-ring endpoint theorem headers are unchanged. Their local proof repairs use the installed power lower-bound and Fin.castSucc coercion lemmas and remove redundant tactics. No additional axiom, unproved bound, nonzero-root assumption, or analytic hypothesis is inserted.

This is a focused comparison for the bounded Pell endpoint. It is not an independent final statement review of the whole article or a whole-root correctness claim. The analytic upper bounds needed for the final contradiction remain separate pending work.
