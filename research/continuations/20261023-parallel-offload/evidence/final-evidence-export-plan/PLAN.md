# Final private evidence export plan

Status: preparation only. No final build snapshot, audit snapshot, or kernel
snapshot has been taken. Packaging starts only after the root coordinator has
confirmed that the build, both audits, resource observers and final checker have
exited and their output writers have drained. The exporter records bytes and
hashes; it must not decide whether any mathematical gate passed.

## Retained evidence

Retain `clean-build/ORIGIN.json` and the final `SUMMARY.json`, every file in
`accepted/`, every invocation directory, and every attempt's `receipt.json` and
`compiler.log`. Include unsuccessful, interrupted and superseded attempts.
Never filter these files by `COMPILE_PASS`, latest invocation, or current
accepted pointer. This preserves the complete surviving invocation history,
including the final receipt chain and the evidence for earlier interruptions.
Preserve empty compiler logs and classify START-only invocation directories
explicitly as missing a terminal summary. Retain recursively referenced
receipt/log chains as well as all unreferenced historical attempts.

Exclude `clean-build/artifacts/`, every exact `stage/` directory below attempts,
every `superseded/` artifact bundle, and the empty `build.lock`. Inclusion of
attempt files is explicitly limited to `receipt.json` and `compiler.log`; any
other unexpected attempt text is reported for review. The stage exclusion is essential: the live inventory
at 14:37 UTC contained 143 stage `.olean` files totalling 73,032,536 bytes, while
the permanent attempt JSON/log files totalled only 8,989,999 bytes. Earlier
approximately 83 MiB estimates included those stage artifacts; filesystem
allocation was not the explanation. Do not delete these excluded local files.

Retain all text output files from:

- `lean-offload/results-clean-final-audits/`, including both logs, the summary,
  and the exact input freeze;
- `lean-offload/results-clean-broad-audit/`, including its log, summary and
  evidence freeze;
- `lean-offload/audit-resource-observation/observations/clean118/` and `broad/`,
  including incomplete records if an observer failed;
- `lean-offload/final-kernel-plan/CLEAN_FREEZE.json` and
  `lean-offload/final-kernel-plan/clean-fresh-run/`, including every result,
  checker log and memory sample file.

If there are additional actual audit or fresh attempts, retain each separate
attempt directory rather than replacing the first. Missing outputs and failed
gates must be listed explicitly. A transport package can be complete for the
observed files while a proof gate is incomplete. Do not manufacture a successful
summary or a missing terminal receipt.

Reference the already archived exact source/runtime locks, source checkout
identity, reviewed runners, audit harnesses, invocation recipes and kernel
supervisor by their recorded SHA256 hashes. Their durable archive locations and
the final private Git archive commit belong in the package index. Reuse the
existing byte-exact text splits of large locks rather than publishing new
reformatted copies; each reference must identify a verified reconstruction
manifest and its durable parts, not only name a hash. Include or reference all
source-policy reports/manifests actually used for final acceptance. The later
source-equivalence/publication bridge is a separate supplement if it does not
yet exist at capture time. Record actual builder/checker/audit/observer source
hashes together with their exact argv, configuration and environment recipes.
Resource-control and interruption notes already archived by
their owners remain part of the linked history; include any later unarchived
notes explicitly. No `.olean`, `.ir`, compiled binary, compressed transport file
or base64 payload belongs in the Git evidence tree.

## Exact-byte capture and text limits

1. Capture the selected path inventory and each selected file's byte length and
   SHA256. Reject symlinks and unexpected binary/non-UTF-8 inputs for explicit
   review; never silently drop them. The source and runtime artifacts are not
   traversed or copied by this packaging operation.
2. Copy files of at most 4 MiB byte-for-byte to an independent staging directory
   outside all frozen inputs and outputs. Preserve their relative logical paths.
3. Split larger UTF-8 text files into ordered parts of at most 4 MiB. Prefer a
   newline boundary; if a single line is too long, use a valid UTF-8 boundary.
   Preserve every original byte, including whitespace and terminal newlines.
   The reconstruction is raw concatenation, never JSON parsing/serialization.
4. Record original path, byte count and SHA256, and each ordered part's path,
   byte count and SHA256. Shard this manifest itself below 4 MiB and use a small
   index containing the shard hashes. Preserve exact identities of unchanged
   files as well as split ones. All Git text files remain below the 5 MiB policy.
5. Rescan the complete selected input path set and rehash the inputs after
   staging. Refuse the package if any input appeared, vanished or changed. Hash
   every staged member and reconstruct/hash every split file locally. The
   package status is byte-capture/verification only, never proof acceptance.

This is sufficient to retain original receipts and logs without adding a new
acceptance registry. Existing proof guards, exact audits and the official
checker remain the acceptance mechanisms. There is no reason to normalize or
deduplicate proof receipts: the current permanent build text is small.

## Transport and remote verification

Create one compressed tar transport of the immutable staging tree outside the
Git evidence directory. Record its exact byte count and SHA256. Compression is
for transfer only; the remote durable tree contains the reviewed plain-text
members and reconstruction manifests. Use the existing scoped RDC transport:
local base64 reads of 50,000 characters in bounded parallel batches, accumulated
into at most 400,000-character remote writes. Write ordered chunks sequentially,
or use distinct chunk paths and an explicit ordered assembly manifest. Do not
print payloads to the conversation. Retry only failed, hash-checked transport
chunks and retain a transport error/retry record when needed.

Remote extraction starts only after exact archive size and SHA256 match. Reject
absolute paths, `..`, symlinks, hard links and non-regular archive members.
Extract into a new, narrowly scoped private research evidence directory. Verify
every member and manifest shard hash, and reconstruct/hash every original split
file. Reconstruction can be streamed into a hash; it need not create an oversized
Git file. Preserve the compressed archive outside the Git tree or remove it only
after successful verification, according to the coordinator's storage plan.

Return a small transport receipt with source package index SHA256, archive
SHA256/size, remote member count, reconstruction results, destination and any
retry history. The owner then reviews and archives only the exact text manifest
paths using the existing private Git process. This plan performs no Git action.

## Size and timing expectations

`LIVE_SIZE_ESTIMATE.json` is metadata from a running build, not a frozen
evidence package. At the first scan, permanent build text was 11,459,903 bytes
across 11,766 files for 3,913 accepted modules. Straight-line scaling to 4,406
modules suggests roughly 12–14 MiB of build text, but final invocation counts,
diagnostics and failures can change this. The biggest existing build text file
was about 215 KiB. No build receipt currently requires splitting.

The final input freezes may each contain large runtime/hash inventories, so
they are expected to dominate package size. The final memory sample log depends
on actual checker duration and is not yet measurable. Existing source/runtime
locks are already durable and need only exact references. Do not claim a final
compressed size or transfer ETA from this live estimate. Compression and the
actual final byte inventory are measured once after the gates stop.

No packaging or transfer process should overlap a proof writer merely to save
time. After quiescence, the copy/hash work is lightweight compared with the
proof build and does not require another Lean execution.
