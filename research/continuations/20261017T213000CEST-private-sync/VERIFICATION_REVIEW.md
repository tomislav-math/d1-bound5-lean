# Final source verification for private synchronization

Observed at 2026-10-17T21:38:30.354336+02:00. No new mathematical proof is claimed by this synchronization run.

The earlier eight root additions have been reviewed against their saved pinned compilation, exact-type/axiom and installed-kernel receipts. Source/import scan passed. The separate 21:16 HalfBinomialCoefficients source was stable during this review; its exact bytes and audit source were compared with the saved stability snapshot.

The latest full root build was independently read from remote process 3482: `lake build D1Bound5.HalfBinomialCoefficients D1Bound5`, EXIT 0, 3064 jobs, runtime 115.48 seconds. This build belongs to the proof writer, not to the synchronizer.

To ensure the just-added source was ready for upload, the synchronizer ran `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean scripts/HalfBinomialCoefficientsAudit.lean`, process 3864, EXIT 0, 41.26 seconds. All seven exact theorem types and their transitive axioms passed. Only propext, Classical.choice and Quot.sound occur. Output is binomial-type-axiom-review.log.

The synchronizer then ran `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.HalfBinomialCoefficients`, process 3939, EXIT 0, 33.51 seconds. This is a targeted replay in the SAME installed kernel, not an independent review or a full fresh-root/clean-checkout validation. Output is binomial-kernel-review.log. No other compiler/checker was active at the two launch checks, and neither process was left running.

Manifest repair is limited to the exact newly verified root import and the missing HalfBinomialCoefficients source/audit entries. All other recorded fingerprints were verified without alteration. No root proof source, another writer's staged file, pin, frozen manuscript, handoff, permission or automation was changed. The preexisting staged POST_PUSH receipt remains intact.

The frozen v4 source hash was reconfirmed as 776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3. Lean 4.33.1 and mathlib 0df444a360eaa60ab8c11dca51a86af692955474 remain pinned. MainStatement remains UNPROVED; successful upload will not change that status.
