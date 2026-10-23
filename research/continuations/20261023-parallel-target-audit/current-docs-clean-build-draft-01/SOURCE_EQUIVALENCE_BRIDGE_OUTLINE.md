# Source-equivalence evidence bridge — outline, not an installed-release claim

This outline records the successful tested snapshot and the exact checks needed
to connect a later canonical publication to it. The fresh full-root replay is
in progress; canonical preservation/installation and the final source-equivalence
receipt remain pending. The original run identities and failed broad-v1 evidence remain intact.

| Object | Tested or prepared identity | Status |
|---|---|---|
| Tested source commit/tree | `102905a54f1b4db67ed81dd9d2c01d4eb6fd97c2` / `b6dd4139f839698609352d7f9866b4b429d32475` | Fixed historical run identity |
| Project source lock | `b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c` | 4406 reachable source paths/imports/hashes and 3 configuration pins |
| Production-only SHA manifest | `af5813a4364be84328e0e67bc940f8388c6539b435eb180b7a1fa66857bbe80b` | Exactly equals the source lock's 4406 relative-path/hash map |
| Full source-policy path map | `fa84386224dedc9b6a9a4fa76679b7bdaf1250cf1927e0ae59c170bc4eee9550` | Must be regenerated and matched after installation to exclude unused extras |
| Runtime lock | `c50d017cd71b3ee22d299302c15a64d5e82a9b71f95ef6040ca077dc56dbd404` | Historical tested runtime/cache identity; never relabel |
| Empty-origin build | origin `082a76e73032059147d45ec53b6a878cee97d7104a7653d8f9d8a0ae105feaae`, summary `a1f72a5787940ae47eec852c68c4bea88f00e845371dfd67a425728a694523af` | Completed 4406 through guarded resumes |
| Exact118 freeze/summary | `698a3a0fecaa49f8451b7fc3e55df85802cab02e14bded5b7a10504dd9b00c95` / `5b5a21c944be0923563a6948ce37a39506b8ae9c69a31353fc750f8b2e79db14` | PASS, actual tested commit/tree and 4412 selected Git blobs bound |
| Corrected broad audit | source `0e4779bb1f294d3588dd409e9afe616855346da52172596efabd9adca594537f`, summary `ca6cf12fca5019030ad4eaf5ef4c69467f99f539f224f54aec97ac32b1288908` | v2 PASS; original exit1 remains separate |
| Installation revision02 | map `cd83528b50a0f2a89b3225498c530efd4aa4defa9da0ebd34522ad69a0d5abfb` | Reviewed preparation only, 25 explicit targets |
| Tool manifest revision02 | `8bbb2035cb90b849e96a0d1b5b9b0f3e37eb29c44fa4c92b4c502fa42f4875b9` | 75 tool/config/history paths, corrected broad harness; not production-source identity |
| Final installed commit/tree and fresh replay result | Unfilled | Must come from actual later operations and successful receipts |

## Required production/configuration correspondence

The reviewed Mac inventory contains 4759 Lean sources: 4406 selected and 353
untracked extras. Preserve the 353 through the reviewed executor and retain its
actual execution receipt. The 4405 selected namespace files are specified to
remain unchanged. The sole production edit is the umbrella:

`33c5f8a0eb94b1ab1196054d8189a968dbe6da8f19ae818d962e435ea72a43c2`
→ `a45a579195a0e787c3e1986e2e0ee671ca64fa82aa030d0c68908c1f61f5982d`.

It appends exactly `\nimport D1Bound5.MainTheorem\n` while retaining all legacy
imports. The resulting bytes equal the tested candidate root. This proposal
mapping is checked; live canonical installation is not asserted here.

The configuration pins are unchanged:

- `lake-manifest.json`: `7ba6f92faaef8900c85a20ac695495111285a1b0c355cb1441a69b34ba9500f4`.
- `lakefile.lean`: `fa17c8e0e386fe8ffadcab88a9a328337c3db37cc7d64681e7ca26836c73bfb3`.
- `lean-toolchain`: `3aac669c7a910ec2389f4e4f921b605adf6ebf2d1e0c9b9cd0be4d33f3f5db71`.

After installation, compare every production relative path and SHA, verify
there are exactly those 4406 production files, run the reviewed source-policy
gate, and regenerate the source lock. Both source-set equality and lock equality
are necessary: the lock alone describes reachable imports and cannot rule out
unimported extra files. Verify all 25 installation targets and all 75 tool-manifest
rows separately. Documentation edits belong to their own reviewed scope.

## Bridge receipt fields to fill only after real operations

Record the canonical root, actual reviewed HEAD/index, preservation receipt,
installation map/version and per-target results, complete production path/hash
map, three configuration pins, source-policy result/map, regenerated source-lock
hash and proof/tool manifest checks. Bind staged Git blobs and then the actual
commit/tree and private push result in separate records, since a commit cannot
contain its own future hash. Attach the actual fresh-root replay result and
freeze hashes without changing any tested-run identity.

The resulting claim is exact released-production/configuration byte-equivalence
to the tested snapshot, with an explicit tooling mapping. It does not claim the
final commit ran in the old environment, that a changed broad audit was covered
by the failed first run, or that the portable check.sh was executed end-to-end.
A later clean clone derives its own commit/tree and runtime paths, generates its
own reviewed locks and starts with empty project artifacts. Resume is restricted
to the same frozen run identity.
