# Checkpoint 14 tooling proposal

MainStatement remains UNPROVED. These are new research-only scripts. Authoring and AST validation do not execute archive creation, checkpoint preparation, staging, generators, Lean or Git mutations.

## Execution order after coordinator review

1. Run `prepare_checkpoint14_payloads.py` under Python 3.12 with `-B` and no `PYTHONOPTIMIZE`. It creates only new research payload archives, a small helper packet and a helper provenance manifest.
2. Run `prepare_checkpoint14.py`. It retains the checkpoint-13 intake-lock capture, exact current source-closure status, paired waves, terminal-only logs, source/credential audit, fixed private-research HEAD and reviewed-path publication-last gates. The source-map base is checkpoint 13. Waves begin at 101 and extend through the actual last complete pair, with a minimum of 107.
3. Review the generated record, manifest and paths. Only then may the coordinator separately run `stage_checkpoint14.py`. That script retains exact private-origin/index-blob checks and adds archive validation plus a strict 100MB-per-file limit. It does not commit or push.

The expected existing HEAD is de54cc736d61d9cbfc317218d1b805bdb085eb2f. No script installs a prepared source or changes the accepted root, queue or compiler protocol.

## Archive ownership

The self-contained source archive covers:
- remaining39: all429 original converter67 outputs and its exact manifest (148491182 source bytes);
- adaptive45: the ten optional proof-delta sources and its manifest;
- adaptive38: all366 new 40000-pair-budget proof-delta sources and its manifest;
- matching7: the two uniquely namespaced Pell matching pilot sources and its manifest.

Each scope prefixes member paths, so the monolithic and adaptive Left/Right alternatives cannot overwrite one another. The archive never imports, executes or installs a member.

The builder partitions lexicographically sorted members by at most48000000 bytes of padded tar entries. USTAR names, uid/gid, timestamps, modes and gzip filename/time are fixed; Python/zlib versions are recorded. Every compressed blob must be strictly below100000000 bytes. Each member is extracted as an in-memory stream and checked for exact SHA256/length before publication and again during checkpoint preparation/staging. No extractall, links, devices, path traversal or filesystem extraction is used. The global archive index proves exact member coverage and records every source SHA.

The remaining39 archive stays self-contained even where a few sources also occur in the current draft source map. Outside that intentional complete-package overlap, byte-identical tracked helpers are referenced rather than copied; unchanged draft sources and terminal logs retain the existing checkpoint reuse mechanism. Prepared Lean source is never embedded in the helper JSON packet.

## Evidence and honesty

Capture the failed capacity-v1 report, corrected v2 report, Python3.12 40-test report, actual single-worker opt-in restart receipt, adaptive preparation receipts/logs, remaining39 before/after hashes and source-preparation receipt, and new Pell matching generation and proof-repair provenance. Top-level runtime JSON includes current reachability and later intake evidence. Snapshotting a source-only review or prepared file never claims kernel acceptance.

The current prepare script follows the actual source/intake cut at execution. Active compiler logs are excluded. A changed closure does not inherit an older PASS. A partial archive/helper publication cannot authorize a checkpoint: required manifest/hash gates fail closed.

These scripts have not yet been run. Their generated archive sizes/hashes and current completion statuses must be recorded only after the coordinator authorizes execution.
