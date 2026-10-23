Proposed transport03, preparation only. Selected transport02 and every current batch are unchanged. The sole production-code delta doubles the raw chunk from300000 to600000 bytes and each of eight base64 text pieces from50000 to100000 characters. The128MiB cap, XZ filenames, scope, source/plan/chunk hashes, no-overwrite rules and independent arrival gate remain byte-identical.

The Linux fixture payload is640000bytes, crossing the new boundary. Eight synthetic tests pass, including exact600000/40000split, eight100000-character pieces, invalid piece index refusal and all original corruption/path/no-overwrite cases. Source-only loading ignores cached bytecode. Python3.8 AST parsing passes; that is syntax validation, not an executed Python3.8 test.

No real batch transfer, Mac write, Lean, source/runtime/build mutation or Git action occurred here. Actual remote size probe, Mac fixture validation, independent review and root selection remain pending.
