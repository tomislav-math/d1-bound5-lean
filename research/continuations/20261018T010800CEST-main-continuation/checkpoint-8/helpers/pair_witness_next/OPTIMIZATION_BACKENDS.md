# Pair-graph optimization backends

These are new local sources, separate from the frozen checkpoint-7 generators.
Standalone compiler results must be recorded by the root agent before intake;
mathematical source review is not kernel acceptance.

## Selected Graph41 integration

`integration_indexed_structural/SmallPairGraphData41.lean` is the preferred
replacement. It reuses the accepted indexed closure and the new structural
triangle pilot. Its SHA is
`6c8c0126a7151a578309a619162d064752a9a6a8ac9c7dba1beb89045753d3f5`.
The original declaration block is byte-identical and every public theorem type
is preserved. Earlier membership, cached, and cached-integer integrations
remain separate history; none was remotely replaced by this agent.

## Triangle phase choices

The shared original Inputs, seed/filter arithmetic, and indexed closure phases
remain independent of the triangle proof. Select one triangle backend per row:

- Structural trace-zero: rows16,22,27,31,32,37,41. It needs only the actual
  per-vertex trace check and the proven coordinate-parameter inequality.
  It needs no color or modular-signature data for the triangle argument.
  The Gaussian trace-zero rows6,9,11,12 do not satisfy the structural parameter
  condition and must use another backend.
- Cached integer obstruction: remaining rows with no residual floor witnesses.
  The existing cached signatures and color partition are reused. The actual
  negative-integer rejection is checked after the cached modular sieve and
  before any root fallback. The new generic proves equality to the original
  cached Boolean under positive discriminant.
- Sparse floor witnesses: the17 rows with residual survivors. This also reuses
  the exact cached signatures and color partition but requires no root search.
  Its certificate implies the original cached and original independent-class
  Booleans; arbitrary incorrect witness data need not be equivalent to them.

The all48 Python classification found31 rows with no floor survivors, including
all7 structural rows. Its totals are40,026 cheap negative-integer rejections,
12,443 positive-real floor witnesses,16,165 scaled negative-real witnesses,
and6 nonreal norm witnesses. These are diagnostics, not Lean results.

## Sparse data and checker interface

`PairCachedFloorWitnesses.lean` consumes one `List (List Nat)` per color.
Every head has exactly one row, including the final empty tail. Each row
traverses the entire remaining actual class list in order. It consumes one
natural witness only for a distinct pair surviving the cached sieve and the
negative-integer rejection. The witness is tested against that actual radicand
using `QuadInt.floorObstructionBool`; indices, tags, and coordinates are not
stored redundantly. Missing or trailing floors and missing or trailing rows
reject. All pairs crossing any proposed chunk boundary remain in the earlier
head's full tail.

The public adapter is:

```
pairIndependentBool_of_cached_floor_certificate hd sieve vertices cached rows hcheck
```

Here `hcheck` proves the actual
`pairCachedFloorIndependentCertificateBool sieve vertices cached rows = true`.
This includes exact projected vertex-list equality and every canonical
signature check. The endpoint is the unchanged
`pairIndependentBool sieve vertices = true`.

Source-audit's separate generator emits
`sparse_floor_next/generated/SmallPairFloorWitnessDataN.lean`, namespace
`D1Bound5.PairFloorWitnessN`, with `leftRows` and `rightRows`. Companion JSON
retains full actual head/target indices for reproducibility and auditing.
The Lean data need only the28,614 natural witnesses and empty-row delimiters.
Analytic-bridge owns the underlying floor obstruction algebra; this checker
only orchestrates those proven local checks.

## Review and status at creation

`PairCachedIntegerObstruction.lean` SHA7b88d466 and its three new41 wrappers
passed independent article-audit source review. Root reported the underlying
`PairNegativeIntegerObstruction.lean` SHA099be79d passed standalone compilation
in30.07seconds; the cached-integer wrapper was compiling when this note was
written.

`PairCachedFloorWitnesses.lean` SHA344ed1b90b84f82b59da3776e3d6e5f30a12a3e268e2e655e2aac504ca085b06
passed article-audit's full mathematical and interface review. It has not yet
been reported compiler-accepted. No main theorem or root-import acceptance is
claimed here.
