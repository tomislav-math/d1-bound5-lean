# Repository verification entrypoint proposal

This is a reviewed tooling proposal, not a replacement proof or a completed release verification. It changes no production Lean source, no frozen clean candidate, and no Git state. The active fresh build remains separate.

Copy the proposed `scripts/` files and `records/` files to their matching repository paths only after reviewing the final package manifest. Existing historical tools not present in this proposal stay in place: all 58 previous tool fingerprints were independently rechecked against the Mac working tree; 55 remain unchanged and three intentional replacements are `scripts/Audit.lean`, `scripts/check.sh`, and `scripts/source_audit.py`. The new manifest preserves their historical identities in `records/verification-history/20261023/`.

The proof manifest contains exactly 4406 production modules. The three unchanged configuration pins move from the old proof manifest to the tool manifest and are also recorded in `release_pins.json`; both existing Git preflight tools verify every row in both manifests. `MANIFEST_CATEGORY_MAPPING.json` records that category change. `PATH_MAPPING.json` records byte-identical relocation of the 114-declaration and independent target harnesses, and the unchanged path/bytes of `scripts/fresh_project_build.py`.

The production namespace must contain exactly the selected root closure. The 198 disconnected fallback sources in the broader development tree cannot remain under `D1Bound5/` in an accepted release checkout. Their preservation/relocation and any corresponding Git deletions require the parent's explicit repository review; this proposal does not perform them or add an exclusion.

The new `check.sh` requires reviewed source/runtime locks and separate build/evidence paths. It runs the accepted source-policy scanner, fresh-origin builder, exact 114+4 declaration/target audits, and optionally the installed official fresh root checker. Its complete status requires `--replay`; without it the result is explicitly pending with exit 3. Detailed commands are in `scripts/verification/README.md`.

The broad `scripts/Audit.lean` keeps the original complete scan, every original named diagnostic, the `AUDIT` output and `AXIOM_AUDIT_PASS` marker. It appends the exact target and private-prefix checks. Its compilation is still pending in the fresh clean environment; no current tooling unit test substitutes for that gate.

Tooling tests and static reviews do not certify the theorem. The final proposal status explicitly leaves the actual end-to-end wrapper run and optional broad Lean audit pending. Current fresh-build receipts remain tied to the immutable candidate's exact source root and Git identity; publishing byte-identical production sources may preserve the mathematical evidence through an explicit mapping, but does not turn this newly packaged entrypoint into an already executed gate.

No private continuation directory, old D1Bound5 proof artifact, local host path, or environment-specific final-checker supervisor is an execution dependency of the proposed entrypoint. Public pinned Lean/Mathlib artifacts are the only permitted imported cache. Existing `GIT_SYNC_POLICY.md` and publication helpers are retained unchanged; manifest refresh is preparation for review, never proof acceptance or publication authorization.
