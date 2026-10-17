# PROGRESS — five-entry signed prefix determinant

Observed branch main, HEAD 122b4cd, no project-owned Lean compiler initially. Earlier selected project source is clean apart from unrelated record edits and untracked research notes.

A new isolated Lean trial `exploration/ProductFivePrefixSignedTrial.lean` has compiled with EXIT 0 under the pinned `lake env lean` using `LEAN_NUM_THREADS=1` (log `local-logs/product-five-prefix-signed-automation9-trial01.log`).

It proves `mixed_signed_root_det_upper_33_128` for one symmetric original-ring signed 4x4 matrix satisfying `MixedSignedEntryGood`, then transfers the sharp bound to the canonical first-four block of an actual Fin5 original-ring signed matrix in `five_prefix_det_upper_of_mixed_signed_entries`. No assumptions are introduced on the last row or column; sign compatibility outside the prefix is not claimed.

Byte-identical source copied into `D1Bound5/ProductFivePrefixSigned.lean`, root import added to `D1Bound5.lean`, and dedicated transitive axiom audit created. Next: pinned integrated build, axiom audit, targeted same-kernel replay, source/import coverage and manifest refresh. No acceptance before these checks exit zero.

Integrated target+root pinned Lake build EXIT 0, 3037 jobs, log `local-logs/product-five-prefix-signed-automation9-build.log`. Two-theorem transitive axiom audit EXIT 0, with exact elaborated types and only `propext`, `Classical.choice`, `Quot.sound`, log `local-logs/product-five-prefix-signed-automation9-axioms.log`. Targeted same-kernel replay has been started, no result asserted yet.
