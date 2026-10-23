# Bounded checkpoint transport preparation

This helper transports bytes only. The independent reviewed checkpoint exporter
is the only component that can issue `DURABLE_BATCH.json` after checking the
archive members and complete receipt dependency chain. No proof checkpoint has
been prepared or transferred by these synthetic tests.

1. After the exporter prepares a concrete new batch, run `transport.py plan`
   with its output directory, the actual build identifier, batch number and a
   new plan path. The plan checks the exporter's archive hash and length. Root
   reviews and authorizes this exact plan, archive/PREPARED hashes and previous
   durable checkpoint pointer before any real transfer.
2. Copy the small plan byte-exact to a new temporary Mac path; pin its SHA256.
   The reviewed transport helper must also be present with its reviewed hash.
   `begin --plan ... --plan-sha256 ...` creates a new incoming directory and a
   new final batch directory outside the Git repository. Existing destinations
   are refused. Only one coordinator owns a batch's incoming directory.
3. For each of the two files, in tuple order `batch.tar.gz`, `PREPARED.json`,
   and each chunk, call `emit` for pieces 0 through 7. Each piece is at most
   50,000 base64 characters; at most eight independent local reads run at once.
   Concatenate the pieces in order in the tool orchestration runtime, never in
   model-visible output. Write at most 400,000 characters to the corresponding
   new `file-J-chunk-NNNNNN.b64` using RDC `write_file` with mode `append`.
   There is exactly one write per new chunk. Never blindly retry an uncertain
   append: read/check the existing encoded length and decoded SHA, then either
   skip a complete matching chunk or retain the failed attempt and start a new
   transfer directory. Payload content must never be printed to the model.
4. After all chunks arrive, invoke `assemble` with the pinned plan. It checks
   the complete incoming member set, every encoded/decoded length and SHA, and
   assembles the two exact final files with exclusive creation. It emits only
   `EXACT_BYTES_ARRIVED_NOT_VERIFIED_NOT_DURABLE`. A failure may leave partial
   files; no retry may overwrite them or claim durable acceptance.
5. Run the independently reviewed exporter on the Mac:
   `verify-arrival --archive DEST/batch.tar.gz --archive-sha256 ROOT_PIN
   --prepared DEST/PREPARED.json --prepared-sha256 ROOT_PIN --destination DEST`.
   Later batches also pass the exact previous `DURABLE_BATCH.json` path/hash.
   Only its actual successful terminal result and independently re-read durable
   receipt can advance the saved checkpoint head. The exporter, not this helper,
   fsyncs and validates the complete dependency chain.

The transport bounds are 300,000 raw bytes per chunk, 128 MiB per selected file,
and batch numbers 1 through 100. Only the two named payload files are allowed.
The Mac base is `/Users/tp/Lean/D1Bound5ProofObjects`; incoming directories use
fresh random identifiers. Binary archives and base64 chunks remain outside Git.
No existing checkpoint, source, runtime, build artifact or Git state is modified.

Retain all failed/uncertain attempts as incomplete. Any cleanup of completed
incoming transport chunks is a separate, explicit later action after durable
verification. The local archive is read in bounded chunks without making a full
base64 duplicate. Before and after each read, source inode/size/timestamps are
checked, and the bytes must match the planned chunk hash.
