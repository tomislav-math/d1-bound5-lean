# Completed formalization checkpoint after requested stop

This archival checkpoint saves all 384 current accepted source versions whose bytes were absent everywhere in base commit `52af5fcbfbe50016869f3875a4c1694149aaa6d4`. It also saves current acceptance records for all 1,269 accepted modules, including 885 source versions already present in that commit. Successful build evidence can be newer than the previously published source.

## Exact scope and assurance

The 384 new versions have existing successful guarded-build receipts: exit zero, unchanged source closure, unchanged shared artifacts, no timeout/interruption, and matching current artifact hashes. Their complete project dependency closure contains 865 accepted source versions with no unaccepted dependency. The inventory checked 10,152 artifact hashes without starting a compiler.

Across all 1,269 selected modules, 1,161 have guarded-build evidence and 108 use a trusted baseline matching the current source-closure fingerprint and artifacts. Original selected receipts, fingerprints, closure maps, artifact hashes and original build logs are retained. An artifact hash is evidence metadata; no compiled artifact is included. The build registry and artifact hash check do not by themselves establish an additional exact-type/axiom audit or final theorem acceptance.

There are 20 accepted graph endpoint modules out of 48, now including graph 40. Graph 33 is incomplete: chunks 00 through 03 passed; chunk 04 was interrupted by the user-requested stop and is excluded. MainTheorem and OneSmallImpossible remain unfinished. No root integration or fresh main-theorem replay is claimed.

The separate row26 mixed audit records 58 fresh declaration/type/axiom checks, 17 fresh targeted replays and 17 reused successful replays under its stated guards. It does not claim a fresh full-main replay or pinned external dependency artifact bytes.

## Reconstruction

SOURCE_MAP.json maps every accepted module to its canonical project path and SHA-256. For a payload_path, use the archived source at that path. Otherwise extract base_path from the exact base_commit using Git. Restore it to the recorded canonical path, verify SHA-256, and use the recorded configuration files. This describes reconstruction for future work; it was not run during publication.

accepted-receipts contains complete selected inventory records in bounded-size parts. BUILD_LOG_MAP.json relates the original receipt paths to archived log payloads. REQUIRED_NEW_SOURCE_CLOSURE.json records the complete closure required by the 384 new versions. EXCLUDED_CURRENT_SOURCES.json preserves the reasons the remaining 517 current source versions are not claimed accepted. Those unfinished sources remain local.

## Publication context

The user explicitly requested uploading all completed work after stopping the main Work session and compiler. The existing 547 staged historical entries were separately reviewed and are included in the same publication. They preserve completed audits, compiled-only work and failed historical attempts with their original dated labels. This checkpoint supersedes older progress counts, without rewriting historical evidence.

This is a research archive; canonical Lean sources and root imports are unchanged. No compiler or proof task is restarted, no permission or visibility is changed, and no unfinished module is labeled complete. STATUS.json is a preparation-time status, not a push receipt.
