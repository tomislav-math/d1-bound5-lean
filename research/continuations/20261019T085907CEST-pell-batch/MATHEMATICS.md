# Mathematical scope and relation to frozen v4

The current unit follows the finite computation in the proof labelled sm:bs7-unit-pair in the unchanged manuscript. It does not change the reduction to squarefree 7 <= d < 10000, d congruent to 7 modulo 8, the norm-two Pell equation, or the closed radius 10^550.

## Continued-fraction prefixes

For each of the 128 listed parameters in PrefixData8--15 the original concrete theorem is

`pellLightFiniteCheck d a0 (10^275) N magnitudes_d = true`.

The checker verifies the same integer complete-quotient recurrence as the manuscript, positivity and floor inequalities at every state, exact transition divisibility, a terminal numerator exceeding 10^275, and the exact filtered ordered list of `u^2-1` for positive convergents with u <= 10^275 and u^2-d*v^2=2. These are proof-producing `decide +kernel` terms. The separate proved completeness bridge and the eventual full-ring endpoint are not replaced by a Python enumeration or an asserted list.

## Matching certificates

For each d in {47,71,79,103}, three original theorems certify validity of the ordinary/scaled square masks, exhaustive matching checks on the listed positive magnitudes, and the lower bound 2 on every magnitude. The matching checker recursively compares every head with its complete tail and rejects mismatched witness-list lengths. A witness chooses masks excluding x*y+1 as an ordinary square and x*y-1 as d times an ordinary square. Thus the checks account for both equal and opposite signs for distinct positive magnitudes. Opposite vertices with the same magnitude are not discarded or asserted incompatible.

The counts are 139 magnitudes/9591 unordered pairs for d=47, 72/2556 for d=71, 125/7750 for d=79, and 49/1176 for d=103, for 21073 unordered pairs in this batch. Counts obtained by parsing data are corroboration, not a substitute for the exhaustive Lean checker and its soundness theorem.

## Boundaries

This batch closes concrete certificate nodes only. It does not itself construct every full-ring PellFiniteCertificate, prove the aggregate no-three bounded endpoint, or establish the global bound-five theorem. No additional hypotheses or altered constants were introduced. Details of the local algebraic replacement in the earlier cubic lemma remain in the preceding MANUSCRIPT_ALIGNMENT.md; that proof is not changed here.
