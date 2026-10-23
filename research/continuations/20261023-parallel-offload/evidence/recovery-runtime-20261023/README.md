# Recovery runtime identity

This is a new verification environment after the unexpected loss of the earlier
workspace's regular files. It is infrastructure evidence, not a recovered proof
result. The prior fresh checker was stopped and must not be reported as passed.

Use `RECOVERY_RUNTIME_LOCK_V2.json`, SHA256
`5c83f7bd62e806af5aca7f63dde0f124ca04cea9dee5028744f8e606826b16fc`.
Its exact durable reconstruction is specified by
`RECOVERY_RUNTIME_LOCK_V2_PARTS_INDEX.json`; concatenate the listed parts and
check the original length and hash. The provisional lock remains separately
archived and is not selected for the new build.

The official Lean 4.33.1 release archive was downloaded once and verified against
SHA256 `890afd185370f85666025b883914ab4f4b339136f8c96167b69cfb62aecaf235`.
The complete official runtime was extracted. Mathlib is pinned to
`0df444a360eaa60ab8c11dca51a86af692955474`; its official cache tool fetched the
3,492 modules reachable from the 93 production Mathlib imports. The three actual
audit harnesses add only builtin Lean imports. All selected import sidecars are
retained. No historical D1Bound5 artifacts were imported or proof sources compiled.

The runtime lives at `/tmp/d1bound5-verification-20261023/runtime`. Moving the owned
dependency trees to ordinary temporary storage avoids keeping large live
dependencies in the watched workspace; it does not establish the cause of the
earlier loss. Unknown workspace copy files were left untouched. Three unexpected
copy files inherited inside the extracted runtime were reversibly quarantined
outside the locked roots, with original paths, sizes and hashes retained.

Compared with the earlier durable runtime lock, 60,412 retained files are byte
identical. Eleven differences are Lake `.trace` bookkeeping files from rebuilding
the official cache utility. There are no added files in the final lock. The
independent review verifies the required import closure and current membership;
the build runner must still perform its initial complete runtime hash guard.

Measured runtime size is 6,616,215,561 logical bytes and 6,866,550,784 allocated
bytes. The previous complete project artifacts occupied about 4.27 GB; one new
artifact store avoids the earlier duplicate stores. These are disk measurements,
not a guarantee against platform cleanup and not an estimate of checker RAM.

Keep the new source lock, runtime lock, build origin and every actual attempt's
receipt/log distinct from earlier runs. Checkpoint exact completed receipts and
invocation history to the private Mac archive during the new build. The source
build, exact type/axiom audits, broad audit and official full fresh kernel replay
must obtain their own terminal results before a final proof acceptance claim.

The first metadata transfer refused a carriage-return log normalization mismatch;
the second transfer preserved exact original bytes and verified every file hash.
Compressed transport files remain outside the text evidence directory. No Git
action was performed by the runtime worker.
