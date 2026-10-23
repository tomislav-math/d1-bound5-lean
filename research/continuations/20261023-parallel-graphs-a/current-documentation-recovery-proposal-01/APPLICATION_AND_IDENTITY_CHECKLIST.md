# Current documentation proposal and later identity bridge

This is a documentation-only proposal after the second workspace loss on
23 October 2026 at 18:07 UTC. No canonical document, handoff file, source,
control, artifact, Git index or commit has been changed by preparing it.
The new text deliberately records pending recovery gates.

## Applying the current correction

1. Review the three proposed entrypoints and their diffs. Recheck the exact
   canonical before hashes in INPUT_PINS.json immediately before replacing
   anything; a changed input requires a fresh diff, not an overwrite.
2. README.md is a replacement. STATUS.md is exactly STATUS_PREPEND.md followed
   by all 83,512 bytes of the previous STATUS.md, including its original title.
   The old dated history is not edited or silently discarded.
3. The external LOCAL_START_HERE.txt is a separate, parent-controlled handoff
   edit outside repository staging. Its old bytes are preserved in before/.
   Apply its proposed SHA256SUMS update together with it: exactly one checksum
   row changes. Keep the old manifest copy. No numerical SOURCE_MAP.json entry
   changes; that map is not a Lean release bridge.
4. Current README/STATUS corrections may be applied before the final gates.
   They do not authorize production installation or success wording. Refresh
   publication-scope doc hashes after an actual edit/commit, and retain the
   separate unchanged proof/tool/configuration manifests.
5. The incident statement is supported by root's actual terminal result:
   exit 1, terminal summary SHA256
   2a6aae1f27ee75ccfcae74bcc00d7e242c3ddc855c31c7807286250c857befaa.
   This package does not pretend to contain that summary's full body.
   Later recovery status must be reported with its own timestamp and evidence.

## Fields required for the eventual successful release update

| Record | Required binding |
|---|---|
| Source candidate | Commit b4c81242dd9c9cee6966a1e08bce0f94c66f1491 and tree ee490da49ba30447d92745140f48c1ae3c34f263 |
| Production source identity | Exact 4,406 relative paths and SHA256 values from source lock b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c; count alone is insufficient |
| Configuration | All three lake-manifest.json, lakefile.lean and lean-toolchain pins |
| Runtime and build | Origin c2f3ad9fe463b99529db5586397a291f268c18fed12f5b27eaf30cc6876f3795, runtime 5c83f7bd62e806af5aca7f63dde0f124ca04cea9dee5028744f8e606826b16fc, builder 349a4e81d9ae80f66e505f3fa927cbde3a0a287cdb1e9971f1d6295d2b797da0 and actual invocation/resume chain |
| Exact audit | Actual 114+4 occurrence result, helper 553767859804a0ae0fb29fe7bb6f2844d3d331b06898971a6994b2d533166830, invocation, terminal exit, source/artifact freeze and full receipt identities |
| Broad and fresh gates | Separate actual broad result and official full-root fresh replay result, each with its invocation, terminal exit, freeze and durable evidence manifest |
| Canonical installation | Actual guarded preservation of 353 untracked helpers, actual 25-target installation, all 75 tool/configuration fingerprints, and refreshed source-policy check excluding disconnected extras |
| Release | Exact staged production/configuration blobs, then actual commit/tree and private-push verification recorded separately after the commit |

The source lock describes the reachable closure; it does not by itself prove
that no disconnected production file exists. The final source-policy check
must establish the complete intended production set.

The bridge may state that the released production/configuration bytes equal
those of the tested candidate, once every listed path and hash matches. It
must retain the original candidate, run and runtime identities. It may not
claim that the future release commit ran in an earlier environment, that new
tooling is covered by old receipts, or that packaged check.sh ran end to end
when verification used separate direct steps.

The historical successful build/exact/broad summaries remain historical;
original fresh exit 130 and later recovery failures remain failures or
interruptions. Missing original logs/artifact chains/freeze bodies are not
reconstructed by writing their hashes into new documentation.
