# Verified working Bennett analytic modules

Verified at 2026-10-18T19:25:00.997342+02:00 in a live interactive invocation. This is not a scheduled diagnostic result.

- `BennettResidualMajorant.lean`: six original theorems, repaired exact exponent/cast normalization.
- `BennettPositiveSeries.lean`: eight original theorems and one definition, plus a separated finite weighted coefficient helper. Exact public original headers are unchanged.
- Both guarded pinned builds, all sixteen type/axiom audits and both ordinary installed same-kernel targeted replays PASSED. Only propext, Classical.choice and Quot.sound occur transitively.
- The separate combined `--fresh` replay exceeded its 240-second budget and is UNCONFIRMED. It was not reclassified as a successful fresh check. Whole-root clean-checkout/fresh final gates remain required.
- `*.before.lean` and `*.trial02.lean` are preserved FAILED source states, excluded from accepted dependencies. Their failed build receipts and diagnostics are retained. Use only the exact two source files named above for this verified working unit, via `SOURCE_MAP.json`.
- The accepted root import file is unchanged. `MainStatement` remains UNPROVED. No independent reviewer was used.

See `MATHEMATICS.md`, `STATEMENT_REVIEW.md` and `VERIFICATION_SUMMARY.json`. The live worktree source and compiled artifact guards are recorded separately. Reconstruct on a fresh checkout from the existing project checkpoint and these exact source-map entries; never import the failed research snapshots.

Next reviewed wave119 targets: RetainedMixedFourScalar, RetainedMixedScalar. Other remaining wave119 targets: CoherentRetainedMixedGap, OrdinaryHeightEnvelope. A fresh runtime snapshot overrides this list. The diagnostic task and its original prompt backup are untouched.
