# Five verified working units

This isolated checkpoint contains the five modules listed in VERIFICATION_SUMMARY.json. Each has current guarded compilation, original statement checks, a transitive-axiom audit and a targeted installed SAME-kernel replay. The failed initial audit is retained separately.

MainStatement remains unproved. No accepted-root integration, fresh whole-closure replay or clean-checkout validation is claimed. SOURCE_STATEMENT_REVIEW.md is an independent source-level semantic review, not a claim of completed verification.

SOURCE_MAP.json locates all 62 dependency-closure source files. Five are included in sources/. The other 57 are byte-identical blobs in reference commit 16c7d9d29b03dbbe4fb2d572f933ced4cd82c260. Restore each to its source path only in a fresh checkout, verify SHA256, and use the pinned toolchain/manifest. Existing project files must first be compared, never overwritten blindly.

Historical audit scripts and receipts preserve their original absolute paths. They document the performed checks; replay in a new checkout requires appropriately located audit commands.

This package excludes every inherited staged path and does not retry the earlier denied graph commit. Creating it does not stage, commit or push anything.
