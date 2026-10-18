# Grounded analytic source repairs

All patches are new local files. Original drafts, remote files and active compiler inputs remain untouched. These sources are uncompiled.

- `CoherentParameterForms`: `d643a3af3dd01df8dfd80ece8c0ba72fab82231c9bdbd4f7f0a0571fd0d2e013` -> `5e5c9b3da5452efd2e2d6fd0420aa7be9400aae7c56e798af8556d4d09ddd9ea`. Reassociate199*P*Q before rewriting P*Q=E^2; previous failed identical rewrite shape in CoherentTwoUpper. No mathematical change.
- `CoherentThreeZeroBootstrap`: `c270301446cffc3c4364e3916c86e21c76fc384ef44c17d9627da797005f3f54` -> `b54246d0d1c9cfd8828a4478b051dd30ad348a9516f72094e48c67fab1b6cf30`. Pinned add_le_add_right adds the fixed value on the left. hn needs the ht inequality on the left and coefficient on the right; use add_le_add ht le_rfl.
- `CoherentRetainedMixedSizes`: `4a5e584dffd7911c9ee847f40533f172284101dbb8bc3ae687905a5a7f45c73b` -> `4052953496a6dda73eb03810524dfb628d86696644b05029e09eaad381eb4055`. Pinned mul_lt_mul requires its second order premise non-strict; hC864 is strict, so pass hC864.le. Independently found by article_audit and verified against actual remote hash and pinned definition.

Pinned API evidence: Mathlib/Algebra/Order/Monoid/Unbundled/Basic.lean lines69–82; Mathlib/Algebra/Order/GroupWithZero/Defs.lean lines337–355. Parent previously accepted the same association repair in CoherentTwoUpper.

## Additional current-hash parameter fixes

Parent authorized these new copies after exact current remote hashes88d/e9ab were reconfirmed. Only three addition-inequality terms change; the previously added noncomputable sections remain. Pre/post hashes are in repair_manifest.json.

The ThreeParameters reverse-square bound also starts from an untyped norm_add_le hypothesis before norm_pow rewrites, the same source-instance shape as the actual UnitPairSymmetric failure. Its hypothesis is now explicitly typed and uses Complex.norm_pow. Other norm_pow uses operate on already typed goals and remain unchanged. The before snapshot remains current88d0f347.
