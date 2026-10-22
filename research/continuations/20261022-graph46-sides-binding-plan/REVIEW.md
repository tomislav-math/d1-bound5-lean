# Graph46 sides foundation-binding helper

This helper is separate from every frozen foundation, sides and closure runtime.
It prepares one actual `REVIEWED_FOUNDATION_BINDING.json` after the foundation
has completed its seven bounded builds, exact type/axiom audit, seven kernel
replays and private publication. No actual binding is included here.

## Deployment and invocation

Root may copy `bind_foundation.py` to:

```text
/Users/tp/Lean/D1Bound5/research/continuations/20261022-graph46-sides-binding-plan/bind_foundation.py
```

The required interface is:

```text
python3.12 -B bind_foundation.py REVIEWED_HEAD PUBLISHED_FOUNDATION_COMMIT PROOF_FINGERPRINT
```

All three arguments must be actual reviewed values. The helper imports the
frozen sides installer from its real sides directory at SHA-256
`61c868f4cfa1ed33bcbc179da509ee7a827d51df3c66cdc0d9dd5d16b3946294`.
It uses that installer's `foundation_binding_files()` interface, compares its
26 unique paths with the pinned template, constructs the proposed binding in
memory, and calls the existing `verify_foundation()` function. That verifier
does not read the destination binding file, so the reuse is non-circular.

The existing verifier checks current foundation source and artifact bytes,
actual bound audits and replays, proof-state fingerprint, prepared original
sources, configuration and committed provenance. It also checks the actual
private post-push receipt, equal local and remote heads, successful exits,
selected committed blobs, released owner, and publication ancestry. The helper
explicitly compares the returned publication commit and proof fingerprint with
the supplied arguments and checks that every saved foundation build receipt is
the actual latest driver row for that fingerprint.

## Write boundary

Both project locks remain held throughout the idle intake, verification and
exclusive write. The helper requires an unchanged `main` HEAD, clear and stable
index, idle driver, no live project compiler, paused serial queue, exact current
side originals and payload, unchanged root/configuration, and unchanged queue,
receipt and baseline files. Existing side installation outputs or a destination
binding cause it to stop.

The only created file is:

```text
/Users/tp/Lean/D1Bound5/research/continuations/20261022-graph46-sides/REVIEWED_FOUNDATION_BINDING.json
```

The helper prints its actual SHA-256 and the reviewed input values. Root must
review that concrete output before passing the resulting SHA to the frozen
sides installer. Post-push receipt, owner and release files are bound by their
actual bytes without requiring them to occur inside their own publication
commit. The helper runs no compiler or replay, changes no Git state, sources,
queue or proof receipts, and makes no endpoint or main-theorem claim.
