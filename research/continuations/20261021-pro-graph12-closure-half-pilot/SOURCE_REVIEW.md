# Graph12 first closure chunk exact halving

The original128-row kernel decision timed out under its240-second guard.
The first64-row pilot passed in121.043 seconds with all guards unchanged.
The second64-row helper retains the full original destination vertex list,
both root equations and both mutation signs. Neither helper truncates vertices.

The original parent header is byte-identical. Its new proof is the existing
prefix-add identity with64+64, followed by Bool.and_eq_true_iff and the exact
List.drop_drop normalization. No new mathematical lemma or axiom is introduced.
The two data builds are reused from genuine receipts, not repeated. Complete
ordered coverage remains a separate required theorem and is not inferred from
Python counts. This unit does not establish the remaining closure chunks.
