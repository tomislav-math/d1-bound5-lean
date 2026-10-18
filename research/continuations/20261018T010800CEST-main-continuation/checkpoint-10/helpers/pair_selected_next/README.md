# Selected-mask row34 pilot

This directory is an isolated, uncompiled pilot. It does not change any accepted
checker, original graph, literal cache, sieve, floor data, or public graph theorem.
Only row34 is generated. Root owns remote installation and compilation.

`generate_selected34.py` reads SHA-pinned original inputs, the frozen literal
cached classes, the original ordered sieve, original sparse floor rows, and the
selected-mask/checker sources. All paths have explicit command-line overrides.
`--expected-manifest` checks all emitted source hashes and sizes before writing.

`generated/SmallPairSelectedData34.lean` contains one base-32 natural word and the
unchanged floor list for each class head. The least significant digit describes
the first actual tail vertex. Each modular rejection uses the first rejecting
mask in the original sieve. The full actual tail determines how many digits the
checker must consume, so zero digits never shorten the checked pair list.

The two wrappers reuse `PairLiteralPilot34.leftCached/rightCached` without copying
their coordinates or signatures. Their targets are the original split-class
`pairIndependentBool` predicates. The full exact vertex coverage and canonical
signature validation remain inside each certificate.

Python diagnostic replay covers all 51,984 same-color pairs: 51,981 have a selected
rejecting mask, and three use the exact original norm-floor witnesses. There are
no duplicate or negative-integer-obstruction tags in this particular row. The
floor lists match the frozen originals by value, including every empty/final row.
This diagnostic is not a Lean acceptance or performance claim.

The old literal and sparse-floor backends remain untouched for comparison.
