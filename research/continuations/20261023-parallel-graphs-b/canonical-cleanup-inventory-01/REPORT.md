# Read-only canonical publication inventory

The Mac currently contains 4759 production Lean sources. The frozen candidate contains 4406. Exactly 353 Mac sources are outside that candidate's complete import closure; all 353 are absent from both Git HEAD and the index. Nothing has been relocated, installed, deleted or staged. This exact Mac inventory supersedes the earlier 198-extra count derived from the local offload tree: another 155 older Mac-only files were never transferred into that local production tree. Frozen earlier receipts remain historical.

All 4405 selected namespace modules match the candidate byte-for-byte. The sole selected mismatch is `D1Bound5.lean`: its exact pending change is a blank line followed by `import D1Bound5.MainTheorem`. All three configuration pins match. No source is missing, symlinked or nonregular, and the production namespace contains no non-Lean files.

| Out-of-closure source category | Files | Bytes |
|---|---:|---:|
| Superseded exact-closure chunks for 11 graphs | 198 | 108279 |
| Pell pilots and data | 96 | 5192011 |
| Other prior pilots and helper variants | 59 | 2174844 |
| Total to preserve outside production | 353 | 7475134 |

“Outside closure” describes the selected release dependency graph. It does not certify or dismiss the archived investigations. No selected module imports one of these 353 names. The largest extra file is 926825 bytes; every selected production source and every extra source is below the existing 5 MiB staged-file review limit. Neither source nor proposed preservation path is ignored by Git.

Git HEAD and the index each track 107 production sources, and all 107 current files exactly match their indexed/HEAD blobs. There are no staged production changes and no tracked extra sources. Final publication therefore adds 4299 selected sources and changes the umbrella import; relocating the 353 extras entails no tracked deletion. HEAD at this snapshot is `9b418359968913eb3e73beeee72ffa1ce953c9f1`; any later legitimate publication requires a refreshed guard snapshot.

`PREPARED_RELOCATION_PLAN.json` contains every source/destination/hash/size row. The proposed destination is `research/continuations/20261023-final-source-preservation/obsolete-untracked/`, preserving each original `D1Bound5/...` relative path. The plan requires coordinated writers, a stable HEAD/index, exact source hashes, absent destination paths, a journal, no-overwrite atomic relocation, post-move verification and a guarded inverse rollback. It cannot expand its file set dynamically or touch tracked sources. The destination does not yet exist.

The parent performs any eventual relocation only after the required clean candidate gates. Root import installation, verification-tool installation, canonical manifest refresh, final source-policy acceptance, explicit staging and private Git publication are separate reviewed actions. The current immutable candidate, active Linux clean build, cache and proof artifacts are outside this plan.

The existing `GIT_SYNC_POLICY.md` explicitly requires preserving unfinished trials under `research/`, forbids deleting work or interfering with another writer, and requires explicit staged sets plus preflight/index review. This plan preserves all source bytes and does not change that policy. Its archive/preservation paths fit the existing `research/` staging scope; ordinary source/tool manifest checks remain necessary. A relocation receipt would certify only file preservation, never proof or publication acceptance.

Exact snapshot hashes:

- Frozen candidate source lock: `b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c`.
- Frozen 4406-source fingerprint list: `af5813a4364be84328e0e67bc940f8388c6539b435eb180b7a1fa66857bbe80b`.
- Current 4759-source fingerprint list: `1dbff8c543dc0e21330c5275c65eaa72ae45d3c3d3ea31e6cbf99dbbb7c1a63d`.
- Exact 353-extra fingerprint list: `54da6d5be2198096c5d21977272006d1311c38a0c2fb018399cf730cc2599d6e`.
- Exact extra-source JSON: `0258eb9bb6ed9b0ffe62b7c7d4471e027b77e8ffeee141fbfb5ab4c5e5ccf487`.
- Original read-only output manifest: `d15c9ace8ef70adad1459acace0acef2c985da06071027053425f11156eaedcc`.

The snapshot script only reads canonical sources and Git state, then writes its evidence into an explicit new owned research directory. No compiler or kernel checker was launched.
