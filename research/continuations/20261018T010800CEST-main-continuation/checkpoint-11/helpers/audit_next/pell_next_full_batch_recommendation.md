# Pell batching: one minimal next performance pilot

Read-only review, 2026-10-18 04:19–04:22 UTC. No queue/source changes and no
compiler was started. The saved runtime snapshot reports stable queue, ledger,
and trusted-baseline bytes during its read.

After this recommendation, the coordinator reported unholding and prioritizing
only PellMatchingData10 at 04:22:45 UTC, leaving the other 91 Pell holds in place.
That is a coordinator report, not another remote observation by this reviewer.

## Recommendation

Allow **only `PellMatchingData10`** as the next full Pell batch under the existing
bounded, serial verification policy. Its current source SHA256 is
`ba809583d03629d83554522dfd457cb152e1a2def909bf1d9ad41e706a2c336d`, identical
to `finite_next/unit_pell/graphs/PellMatchingData10.lean` and the frozen graph
source manifest. It is 76,109 bytes. Current closure fingerprint:
`1a282ced4c3847cd5c82d65b8504be2ca0bad956e24669e9ef21ef534880388a`.

The module is currently **outside `names` and inside `blocked_modules`**.
Therefore merely removing its hold is insufficient: the coordinator would also
need to add this single module to the queue. All other 91 held Pell modules can
remain held. No source rewrite, new helper, relaxed check, or prerequisite build
is required for this pilot.

This is the smallest existing full matching batch by actual unordered-pair
workload, not a claim about wall-clock time: 16 fields, 190 positive magnitudes,
1,332 unordered pairs, 2,664 selected signed-mask checks, and 48 `decide +kernel`
proofs. The slightly smaller source `PellMatchingData26` has 3,287 pairs and is
therefore a less conservative workload choice. The existing four-magnitude,
six-pair matching pilot passed in 83.32 seconds; that does not justify scaling
its time linearly to this batch. The pilot is specifically intended to measure
the larger computation under the current machine conditions.

## Accepted dependency evidence

`PellMatchingData10` imports only `D1Bound5.PellMatchingCheck`. That checker has
no D1Bound5 imports; its mathlib prerequisites are already built.

| Dependency | Current source SHA256 | Current receipt |
| --- | --- | --- |
| PellMatchingCheck | `c1c0284d3cb9fe91ae3599a7d1d28cf05b2201c8cbaef193b20c1b2b5f4ccfa0` | PASS, 2026-10-18 01:11:57 UTC, 105.35 s |

Checker closure fingerprint:
`1a4825179ddde69ef1131403ac3c9ef42e52489e60084860da492796cf3daea7`.
At 04:21:32 UTC, **all eight existing checker artifacts were freshly hashed and
matched the accepted receipt/baseline manifest**. The exact artifact paths,
expected hashes, actual hashes, receipt path, and source hashes are saved in
`pell_matching10_artifact_check.json`. This verifies current readiness without
executing the checker again.

## Concrete downstream use

The batch supplies actual `pellGraphCertificate_d` declarations for
3271, 3319, 3343, 3359, 3383, 3391, 3407, 3431, 3463, 3511, 3527, 3559,
3583, 3607, 3623, and 3631. These instantiate the accepted matching certificate
and its signed-list no-three theorem. They do **not** yet establish completeness
of the lists of Pell solutions.

`PellMatchingData10` is the sole graph dependency of these two existing prefix
batches, containing 32 complete-field certificates once their checks pass:

| Consumer | Current source SHA256 | Other dependency |
| --- | --- | --- |
| PellFiniteData22 | `2881bc249f64edb44d327529aa9538cb3d991c86fcc0d2a2656d2574ee41c5a3` | PellFiniteCertificate |
| PellFiniteData23 | `938def5b0f26b8c2be8965c4f71d26ca3b0233029adfc8b842190d742d75ef34` | PellFiniteCertificate |

Data21 and Data24 also use this graph batch, together with graph batches 9 and
11 respectively. The exact existing main path is:

`PellFiniteCertificate.full_ring_no_three` → `PellFiniteFields` →
`PellUnitPairBounded` → `UnitPairFiniteReduction` → `UnitPairImpossible` →
`DegeneratePairImpossible` → `MainTheorem`.

Thus this is reusable work on the actual unit-pair branch, not a disposable
performance benchmark. One batch alone does not close that branch; exhaustive
field coverage still needs all the corresponding graph and prefix certificates.

## Why no full prefix batch is ready now

The 92 holds are exactly 26 graph batches, 64 prefix batches, PellFiniteFields,
and PellUnitPairBounded. All 26 graph batches have only the accepted matching
checker as D1 dependency. Every prefix batch also imports the unaccepted
`PellFiniteCertificate`, SHA
`2bf16b7db5d3fcd397b763bbabe27877978ae5f84daeba0bc35f5d4e2272764f`.

The generic CF side is accepted:

| Module | Source SHA256 | Current status |
| --- | --- | --- |
| PellConvergentCompleteness | `c43074daa228222fbe1ca798070304a8be11d05710c382ec9a9e73d7799c8266` | PASS, 61.37 s |
| PellCFPrefixCheck | `a5468d17d5b8fd8febaae9f486b606a6148827a88a3b76dca5782d036662adba` | PASS, 76.00 s |
| PellMatchingPilot | `b3354d245d028c0332eb8923755ca62c393732ccc165dfddfa48128283c5db65` | PASS, 83.32 s |
| PellFinitePilot | `d641c1d72a9eabbb940319d37c8f8a94f8c5a3feaa207c284b496d69f8223ac7` | No current receipt; dependency-blocked |

The outstanding chain entering PellFiniteCertificate is
UnitPairPellClassification → FullRingUnitPairPell → UnitPairPellBounds →
UnitPairArithmeticModel / UnitPairPellParity → UnitPairRealReduction.
At the snapshot, UnitPairPellClassification source
`ed563d0e0ef72594c7e02ac4b7f74ecee2b8f06a15744f42426fbaf31c5404db`
had a current failed receipt at 04:19:07 UTC; the later modules had no current
accepted receipt. UnitPairAxes and UnitPairSymmetric were already accepted.
This status may advance independently after the snapshot; no changes to that
chain are proposed by this review.

The minimal useful next prefix test remains the existing `PellFinitePilot`
after that chain and `PellFiniteCertificate` pass. Unholding a full prefix batch
now would not make it eligible and would not bypass the missing proof.

## Evidence

- `pell_batch_readiness_snapshot.json`: all 92 holds, exact current source/closure
  fingerprints, receipts, and dependency statuses.
- `pell_matching10_artifact_check.json`: fresh accepted checker artifact hashes
  and exact downstream main imports.
- `pell_matching_batch_ranking.json`: independent local batch ranking by Bennett,
  SHA256 `c09eaa656ff1e0fc266a653602bd2610115c1fc374f06dbb1c0882bea953b1b3`.
  All 26 actual source hashes matched the frozen graph manifest. No Lean
  compilation or remote mutation was performed by either reviewer.
