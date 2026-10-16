# Mixed four-by-four weighted-row certificate — 2026-10-16

## Scope
This is an exact finite-dimensional algebraic component of the second branch of manuscript Lemma product-four (A >= 1, B >= 3). It does not prove the weighted spectral/operator-norm estimate or D > (3/2)ABC.

The independently created module `D1Bound5/WeightedRowCertificate.lean` defines positive weights w = (3/2,1,1,1) and a symmetric nonnegative entrywise majorant B with B_ii = 0, B_ij = 1/18 when one index is 0, and B_ij = 1/64 on the lower three-by-three off-diagonal block.

For row 0, the weighted sum is 3/18 = 1/6 < (11/96)(3/2) = 11/64. For each later row, the sum is (3/2)(1/18)+2(1/64) = 11/96, exactly equal to (11/96)w_i. Thus all four rows satisfy (B w)_i <= (11/96) w_i, with strict first-row slack.

The proved matrix-transfer theorem assumes E_ii = 0, |E_ij| < 1/18 for pairs meeting row 0, and |E_ij| < 1/64 otherwise. It derives the pointwise inequality |E_ij| <= B_ij and then the weighted row bounds for E. No symmetry assumption on E is necessary.

## Proof boundary
This verifies the numerical certificate and its complex entrywise transfer. A separate kernel proof is required to convert the weighted row bounds (using symmetry of the entrywise norm matrix) into ||E||_2 <= 11/96. The manuscript's spectral argument cannot be treated as discharged by the present theorems.

## Provenance and verification
The source was first developed as `exploration/WeightedRowCertificateTrial.lean`, and a byte-identical copy was placed in `D1Bound5/WeightedRowCertificate.lean`. Earlier failed attempts were repaired (noncomputable real constants and finite-index normalization). Source elaboration and targeted Lake build returned exit 0. The seven elaborated theorems passed the dedicated `scripts/WeightedRowCertificateAudit.lean` transitive axiom check, with only propext, Classical.choice and Quot.sound. A few nonfatal Lean linter warnings on proof punctuation remain. See dated records and local-logs for further final verification receipts.
