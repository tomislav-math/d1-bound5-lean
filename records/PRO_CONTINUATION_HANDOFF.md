# Current D1 formalization handoff

Main theorem UNPROVED. Canonical-root integration remains unverified.

Graph1 left and right independence proofs are now scoped-verified. The three
completed scopes cover exactly 32 theorems in 26 distinct build/replay targets:

- sides-pilot: two theorems in two targets;
- left-rest: 15 theorems in 12 targets;
- right-rest: 15 theorems in 12 targets.

All 26 guarded builds, all three exact original-type/transitive-axiom audits,
and all 26 targeted installed SAME-kernel replays passed. The remainder scopes
reuse both verified pilots with their exact proof-state, source, artifact and
bound-receipt evidence. The 32-theorem count comprises 20 partition helper
theorems, four original parent theorems and eight theorems in the two unchanged
side wrapper files. It excludes the previously verified foundation declarations.

The left side retains all 360 heads and the original parent blocks 137+223;
the right side retains all 358 heads and the original parent blocks 138+220.
The verified full-tail partitions are:

- left000: [16, 20, 22, 24, 26, 29];
- left001: [34, 42, 56, 91];
- right000: [16, 20, 22, 24, 26, 30];
- right001: [34, 42, 56, 88].

Every head is compared with its complete original remaining tail, including
comparisons across partition boundaries and across the two original parent
blocks. The coverage is exactly 64,620 unordered pairs on the left and 63,903
on the right, totaling 128,523 pairs. The four parent theorem statements and
both wrapper files are unchanged. No data, pair comparison or mathematical
assumption is removed.

Authoritative side evidence is under
research/continuations/20261022-graph1-sides/
in the sides-pilot-, left-rest- and right-rest-VERIFICATION_SUMMARY.json and
corresponding PROOF_STATE.json files. Their bound audit records are under
research/continuations/20261020T100000CEST-work-resume/
pro-graph1-sides-pilot-audit/, pro-graph1-left-rest-audit/ and
pro-graph1-right-rest-audit/.

The verified graph1 foundation was committed and privately pushed at
d05caaa83a0d079d90599de5dc3d376fb41e4ff1. Its seven modules preserve the exact
19 original definitions and four original validation theorems, with 25 sieve
entries and the complete asymmetric 360/358 side data. This publication
preserves POST_PUSH_RECEIPT.json, OWNER.json and RELEASE.json from
research/continuations/20261022-graph1-foundation-publication/.
Older scoped and publication records retain their historical status fields;
completed scope evidence and actual push receipts document subsequent progress.

Graph1 is not yet a completed graph endpoint. Its original 720-entry closure,
718 large vertices, indexed closure witnesses, and final endpoint assembly
remain to be verified. Continue with the exact closure partition and the
final endpoint collector after preserving these verified foundation and side
proofs. The verified working endpoint count remains 28 of 48.

Graph11 is complete. Its proof/evidence was committed at
20c3be2fa9297634047833a290a5bca9007adb5e, with final publication records at
91411eede8ee5f726362c031322ec97078b82a57.
Remaining endpoints: 1, 3, 4, 5, 6, 7, 8, 10, 14, 15, 19, 21, 23, 24, 28,
30, 36, 39, 43, 46.

The separate graph43 raw left-data build was preserved as research evidence
and privately pushed at 91f9f53bce69959727d5fe5b751e6cc29e88abea. Its exact
source snapshot, original build receipts, exact-index reconciliation and push
receipt are under research/continuations/20261022-graph43-pilot/. This archive
does not establish guarded driver acceptance or a graph43 endpoint theorem.
The original D1 data source and SmallPairLightAdaptiveLeft43_000Part00 trial
remain unchanged; the trial is uncompiled and unverified. The earlier
pre-execution refusals remain preserved in the historical handoff and
reconciliation and have not been overridden or claimed permanently remedied.

After all finite graph endpoints: SmallPairGraphs, TwoSmallSextuple,
TwoSmallNondegenerateImpossible, MainTheorem, canonical-root integration,
and the final clean-checkout pinned build, full type/axiom review and fresh
integrated-root installed-kernel replay remain open.

The unchanged target is every finite D(1)-set of distinct nonzero elements of
the full ring of integers O_K in every imaginary quadratic number field having
cardinality at most five. Half-integral bases, tied moduli and zero pair-square
roots remain allowed. No new mathematical assumption is introduced.


Publication starting HEAD: d05caaa83a0d079d90599de5dc3d376fb41e4ff1.
Publication is prepared, not yet pushed. The actual final Git state is recorded
in POST_PUSH_RECEIPT.json under research/continuations/20261022-graph1-sides-publication.
