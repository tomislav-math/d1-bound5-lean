# Optional arithmetic-only selected-floor checker

`PairLightArithmetic.lean` is a **definitions-only module**. Root reported kernel
PASS at unchanged source `ac3b9e9f…`, 6.33 seconds, 2026-10-18 04:41:42 UTC.
It changes no previously accepted source and contains no data batches or theorem
claiming soundness. Root is the sole compiler and remote writer. The separate
bridge, concrete computation, and actual assembly still have their compiler gates.

## Dependency proposal

The sole import is `Init`: **0 Mathlib imports, 0 D1Bound5 imports, 0 external
package modules** in its import closure. Lean core's own Init dependency count
has not been enumerated. In particular, the candidate has no FullRing, Complex,
QuadraticAlgebra, ZMod, or graph-proof dependency. This is a source-level import
fact, not a measured speedup. Root's raw34 timing remains a separate experiment.

Bennett inspected the pinned Lean 4.33.1 Init headers and declarations:

- `Init` → `Init.Data`; Data imports Nat, Int, List.
- Nat imports Bitwise; `Nat.testBit` is in Bitwise.Basic.
- Int imports DivMod.Lemmas, including `Int.decidableDvd`, and Int.Pow.
- List imports Basic/Lemmas/Notation, including `all`, `map`, and `getElem?`.

The source uses `Int` and `Nat`, avoiding mathlib's integer/natural notation.
All remaining syntax, recursion, decidable equality/order, and operations are
ordinary Lean core. The coordinator's successful compile confirmed this module's
elaboration; it does not establish the separate arithmetic certificate theorem.

## Representation and exact mapping

No new record datatype is introduced. The aliases are
`PairLightCoordinate := Int × Int`,
`PairLightSignature := List (Nat × Nat)`, and
`PairLightCachedVertex := PairLightCoordinate × PairLightSignature`.

| Arithmetic-only definition | Accepted counterpart / exact expression |
| --- | --- |
| pairLightProductPlusOne | `((x*y+1).re, (x*y+1).im)` in `QuadInt tau nu` |
| pairLightNorm | `QuadInt.norm_formula`: `re² + tau*re*im + nu*im²` |
| pairLightCoordinateResidues | pairCoordinateResidues |
| pairLightCoordinateSignature | pairCoordinateSignature |
| pairLightResidueMaskNatBool | pairResidueMaskNatBool |
| pairLightSelectedMaskRejectBool | pairSelectedCachedMaskNatRejectBool |
| pairLightNegativeIntegerObstructionBool | pairNegativeIntegerObstructionBool |
| pairLightFloorObstructionBool | QuadInt.floorObstructionBool |
| pairLightSelectedFloorRowBool | pairRawSelectedFloorRowBool |
| pairLightSelectedFloorIndependentBool | pairRawSelectedFloorIndependentBool |
| pairLightSelectedFloorIndependentCertificateBool | pairRawSelectedFloorIndependentCertificateBool |

The original raw source is frozen at
`16663ee7ed18799dce07207a0b374d05787f04c1c37fca43ad73b4907ad0a013`.

The only arithmetic representation changes are explicit quadratic coordinate
formulas, the explicit quadratic norm, and replacing each integer ZMod value by
`(z % Int.ofNat (k+1)).toNat`. The modulus is always positive, including modulus
one. The residue-mask polynomial still permits arbitrary supplied natural
residues, not merely already-reduced or valid cached signatures.

## Mandatory equality bridge, not new trust

`PairLightArithmeticBridge.lean` now imports both the lightweight definitions and
the accepted raw checker. Its initial source SHA was
`35ced62467e1e2a03eb4def796ac4065fa092677e5d5759cf25c970faaf479f9`.
It defines the coordinate projections

```text
coords z = (z.re, z.im)
cachedCoords x = (coords x.vertex, x.signature)
```

and supplies an exact Boolean equality proof for **all** parameters and data:

```text
pairLightSelectedFloorIndependentCertificateBool tau nu sieve
  (vertices.map coords) (cached.map cachedCoords) rows
= pairRawSelectedFloorIndependentCertificateBool sieve vertices cached rows.
```

This theorem has no signature-validity, nonnegative-parameter, mask-validity,
discriminant, or well-formed-certificate premise. The positive discriminant
hypothesis appears only in the already accepted final soundness theorem.
The bridge passed independent source review, recorded in
`audit_next/pair_light_bridge_review.json`, SHA
`17c82648c402241479b3ffca3ad7dfbfed8fd1cba1695f3d37c24d9dc010a47c`.
This review is not kernel acceptance. After actual compiler feedback, Bennett
repaired four elaboration/API points without changing any theorem statement.
The first repaired bridge source was
`91befed7666b5e9d6c03683a36ae4afcd0bfdf3a649140e1eb549d6ff230f0c0`.
Its separate fresh source-review receipt is
`audit_next/pair_light_bridge_91befed_review.json`, SHA
`630c94d060f86661bbef7624f377573ac61bb05d57f4fe1969ad0cc600e1589b`.
The original35ced receipt remains preserved and is not used for the new source.
The next compiler retry passed all declarations except an equality of Boolean
floor checks whose hidden decision instances differed. Bennett added one
`split_ifs`/`decide_eq_decide` proof step, leaving all statements unchanged.
The current bridge SHA is
`74989ea9779fa4da2831c156377a44908c388871054e7832fd443986758442a6`;
its fresh independent source review is
`audit_next/pair_light_bridge_74989ea_review.json`, SHA
`be8112b3252d0e023ee26bf4e4a63c7ca82f0c31819084142e688cf0353fb6b6`.
Both earlier review receipts remain preserved; current kernel acceptance is
still pending.

The residue API is pinned and already used in accepted
`finite_fast_next/sieves/CoordinateSquareMaskCheck.lean`:

```lean
-- ZMod.val_intCast : ↑(a : ZMod n).val = a % n, with [NeZero n]
by
  simpa only [Int.toNat_natCast] using
    congrArg Int.toNat (ZMod.val_intCast (n := k + 1) z)
```

For the negative coefficient use `z := -nu` and `Int.cast_neg`. For norm and
product use the existing coordinate/norm lemmas in the heavy bridge. Coordinate
projection is injective, which transfers duplicate and ordered-list equality.
Then induction over the actual tail and over the outer cached list transfers
the row and certificate checks. The bridge must cover all mismatched lengths,
invalid tags, extra digits, and floor-list cases; checking only generated data
would be insufficient.

Only after the bridge passes can a lightweight data module's kernel-checked
Boolean theorem be transported to the original independent-class theorem. The
heavy graph imports belong in that bridge/assembly, after the expensive concrete
arithmetic proof. Generated original-coordinate data must still be connected to
the lightweight data by checked equality; the generator is never trusted.

## Preserved rejection cases

- Tail length, not packed-word length, drives the row recursion.
- Tags 0–24 select the same aligned mask and both signatures; any absent entry
  rejects. Leading zero tags still process every actual pair.
- Tags 25–29 reject. Tag 30 checks actual coordinate equality.
- Tag 31 tests the same negative-integer guard first; success consumes no floor.
  Otherwise exactly one floor is required and consumed with the same strict
  inequalities and branch order.
- Final word and floor list must both be empty; outer lists end together.
- The full ordered vertex projection and every canonical signature are checked.
- Unsupported trace parameters, negative/zero scale values, and zero radicands
  retain the accepted Boolean behavior; no extra mathematical premise is used.

No mass data, selected-row optimization, chunking change, or new arithmetic
filter is part of this proposal. The point is to isolate the exact existing
computation from proof imports. Independent source review of the definitions
passed at source SHA `ac3b9e9f7d91be83861de5b2f384eb0c669c61cfa9bd323309d57565e89af6eb`;
the report is `audit_next/pair_light_arithmetic_review.json`, SHA
`e6c24358e3623cbe1b575a34917298afecef388eb95489dccd618fab2a3da29f`.

## Single generated left34 pilot — uncompiled

`prepare_light34.py` was run once locally, only after the exact bridge source
passed independent review as requested by root. The converter requires
a receipt containing the bridge `source_sha256`, `source_review_pass: true`, and
an identified `reviewer`; this records that source-review gate, not Lean acceptance.

The five input files are SHA-pinned in the converter. It parses the original
457-vertex list and color word, extracts its actual 229-record left class, and
checks the existing literal cached records against that exact ordered split.
It copies the 25 original masks, every existing residue signature, every packed
word, and the two existing floor witnesses. It discovers no new witnesses and
never reruns a frozen generator.

Its output is only `SmallPairLightData34.lean` plus the computation-only
`SmallPairLightLeft34.lean`. Both import solely the lightweight definitions/data.
The separate `SmallPairLightAssembly34.lean` supplies equality proofs with all four original inputs:
the sieve, the actual split vertex list, cached records, and packed rows. Until
those equalities and the generic bridge pass, no original graph theorem follows.

The converter's own independent source review passed at SHA
`f9f9b1d858a7ccfc8e25bc9bd7315e39ea1b7a1ea7bee648780d34d4b647be59`:
`audit_next/prepare_light34_source_review.json`, report SHA
`c4bb5a82e4a6282f5c7addb42cd83cd890ce93bfc8ea6dca015eb9308be7475c`.
That review did not execute the converter; generation occurred after the separate
bridge review passed. The generated outputs and assembly are in `left34/`:

| Module | SHA256 | Role |
| --- | --- | --- |
| SmallPairLightData34 | `49cf35338156ecb1931249f486271e229055efff5ae4e02760660236fac3c46a` | 229 original left vertices/cached records, masks and rows |
| SmallPairLightLeft34 | `734d15677639f0fedfc48da6132ef1e0408a7c506f8c499f9b3f9d1a045be66e` | Isolated arithmetic `decide +kernel` proof |
| SmallPairLightAssembly34 | `6a0195e9356ce602881ba23270aeac451918eed77e30e3bdb8e3b35be0fb5140` | Four exact original-data equalities and original left assertion |

The first data source `49cf3533…` reached the default 200,000-heartbeat limit
while elaborating pending metavariables (line 361:105). The actual log is saved
in `audit_next/light34_data_failure.json`. The minimal retry candidate is now
`left34_v2/SmallPairLightData34.lean`, SHA
`6eb18ec1ec46c6b05910af2bed24ce3e93897cf152ae676aa67eb92e8f49689c`:
it adds only `set_option maxHeartbeats 0` to the header. Every byte from the first
data declaration onward is identical; the checker and assembly are unchanged.
The bounded external compiler timeout is unchanged.

The matching converter copy is `prepare_light34_v2.py`, SHA
`1e42872f3ee23556a8ba926972952b8a15d910fd7ea49f5cf7ccccdbd52f2cb9`.
It was run against the then-current reviewed bridge35ced/receipt17c; its manifest
SHA is `b30d6853215d211da9277b66cd122254e953bc612178a67c93672fca421a8f4c`.
`LIGHT34_DATA_REPAIR.json` records the pre/post hashes and byte-preservation
checks. Later bridge proof repairs do not change these data; a later converter
run must nevertheless use the exact review receipt matching its bridge source.
The data/converter exact-diff repair independently passed review in
`audit_next/LIGHT34_DATA_REPAIR.json`, SHA
`7225352e33fad42c7c6b9782835877559cfc6801aad8db1cf119c84067389058`.
Root reports that Mac reproduction against bridge35ced and receipt17c matched
the v2 manifest byte-for-byte before the data6eb and bridge91bef were intaken
together as wave87. No old review was applied to a changed bridge.

The definition module must compile first. The data and arithmetic-check modules
have no dependency on the heavy bridge; the assembly depends on both chains.
Only this one optional left pilot has been generated. There is no right-side or
triangle-free claim, no remote modification, and no compilation by this agent.

Independent review of the emitted data and assembly passed:
`audit_next/light34_data_assembly_review.json`, SHA
`e36ec2e6681873645b6b11c35f292fb7c8fdba0f2e076a00c6f539916ed855d9`.
The reviewer parsed the output without importing the converter and verified all
229 original vertices, 25 masks, 5,725 signature entries, original packed rows,
and two floor witnesses. An independent Python replay found 26,104 selected
mask rejections and two strict norm-floor rejections, with full exhaustion.
These are source/data diagnostics, not a substitute for the Lean certificate.
The exact generated manifest SHA is
`917b25378fc82cb0db5b9094f149fd68a88f98afbf82f6aa5982a214ce937c5d`.
