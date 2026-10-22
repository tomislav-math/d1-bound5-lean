# Graph3 closure source preparation

This is a prospective source-preserving proposal generator. Its narrow source
inspection has actually completed under root ownership; full proposal
generation, installation, compilation, audits, replay, acceptance and
publication remain separate work. No current HEAD, queue hash, accepted
baseline, execution binding or future proof/publication result is supplied.

## Actual source evidence

The graph3 source catalog has SHA-256
`ac4e0093babad78ab72dfd13b046bb8e546472142e1a863b83d724fea086a416`.
The actual narrow closure inspection is 32,435 bytes with SHA-256
`d2cef3ebacc09565b3e5693db245661b866c98fd86fdebffd31397632f5acc76`.
Root collected its successful remote exit. Both observations retain their
source-only status; neither claims driver or kernel acceptance.

The original merged `SmallPairGraphData3.lean` is 2,359,193 bytes, SHA-256
`07311ff8945e773cdf988ada0f87f63750db70cc8562e6c58d56c0624515d35e`.
Its eight preservation markers match these archived originals in order:

| Original module | Bytes | SHA-256 |
|---|---:|---|
| SmallPairGraphInputs3 | 931,270 | `a2060547d6581e20f545c7e19b614ba81c5b621f4b74f09542728f5c0cd6e190` |
| SmallPairGraphArithmetic3 | 555 | `a5595d899d140695b2f8be811778d9ea2f78cc8ff96425eb8c43a4bc305fc489` |
| SmallPairGraphWitnessData3 | 497,242 | `a78b10049617e1d74eafb6271f6262389571a9c140713da149c7b82e0f009eb8` |
| SmallPairGraphClosure3 | 720 | `3db79a70d33b3c18a681859cbedffe29b00c4cb8f3854c82757da5533ebdcb31` |
| SmallPairRawSelectedData3 | 926,089 | `3cb34dbb3c8cf4ab2b603d59d6b2ff15b0c53902a93733c12e87ba7abefc3e82` |
| SmallPairLightAssembly3 | 2,022 | `56edac3dc1067d6b0f3c0222e535e97bb79b045082fc27258c676fd28249c84d` |
| SmallPairGraphTriangle3 | 389 | `d8a8275159088014cfa15f46761ebe17b260e8974aa1072d206bf114db69c5bf` |
| SmallPairGraphData3 | 121 | `590b2dae2c18b31f2621d070caa9854c89763bc29f08e3e47b31a8e0678ee92c` |

The frozen source helper verifies every archive hash and size, original
imports, exact public headers and declaration-body hashes. It compares each
archive body with its merged segment and reconstructs the complete merged
file, explicitly preserving the differing boundary whitespace records.
The original archive directory remains the historical
`20261018T010800CEST-main-continuation/prepared-light-remaining39/D1Bound5`;
it is not renamed into a new graph3 provenance directory.

The actual model is `QuadInt 0 1`. Closure, root-pair and destination lists
have 829 rows. The filtered list has 827 vertices, with 413 selected left
cached/row entries and 414 right entries. The original eight modules contain
28 public declarations: 13 definitions and 15 theorems. Destination indices
range from 0 through 828. The two destination columns retain their observed
`none`/`some` entries; the generator neither relabels nor truncates them.

## Exact raw-data partition

The four new raw-data modules copy complete existing definition blocks,
including the original imports/namespace prefix and closing suffix. The
original raw module becomes an imports-only facade. No literal is regenerated,
normalized or reordered.

| Exact fragment | Bytes | SHA-256 |
|---|---:|---|
| SmallPairRawSelectedData3LeftCached | 330,587 | `8a32e9f7d86dc59a36ea0660dfebcdba8d621da540889450381ce6f7b57bdce7` |
| SmallPairRawSelectedData3LeftRows | 132,295 | `5893743dd0d2c4cf08935f0d21867dc24ebef8f64b60edde7a878d22e6a948e1` |
| SmallPairRawSelectedData3RightCached | 330,885 | `9f4a809f57973c61f2edc63ba031dfe618fb83fc59d5065de1b6879885525a91` |
| SmallPairRawSelectedData3RightRows | 132,970 | `68939a8252614958415fc03b95601fa601cb5507fd713525f05ec2d344abc32d` |

The larger input module and fragment sizes are measured source facts, not
timing predictions. Any future compiler run retains the actual 240-second
per-target cap and its reviewed stop/no-retry behavior.

## Global destination semantics and proof preservation

The actual source inspection proposes thirteen contiguous prefix checks:
twelve blocks of 64 rows at offsets 0 through 704, followed by 61 rows at
offset 768. Their union is exactly rows 0 through 828; the final drop is 829.
Every prefix keeps the complete original `smallPairClosure_3` vertex list.
Only `witnesses` and `destinations` are dropped by the prefix offset. Both
mutation signs therefore keep their original global destination lookups.

The existing `PairClosureIndexedChunks` theorems retain the same vertex list
through prefix/drop factorization and preserve mismatched-list behavior.
The new coverage helper separately proves the anchor-root equation and
ordered witness coverage. It is adapted from the exact historical
`D1Bound5/SmallPairGraphClosure29Coverage.lean`, SHA-256
`16bbbcfa2e81413a9c2553d413b4d7d2e2f9203e70dc18f06687328ff90afce1`.
Only graph-specific identifiers and its three explicit `QuadInt 1 1`
annotations change, to the actual `QuadInt 0 1` model. The generator first
checks the original input and witness type headers and the `List.zipWith`
witness construction. The future accepted dependency/source-map proof gate
remains mandatory; a local template read does not establish current acceptance.

The original `PairGraphPrepared3.indexed_checked` public statement is copied
exactly. Its new proof joins all checked prefixes backwards from the empty
terminal drop 829. The entire original second theorem
`smallPairClosure_3_checked` and trailing source suffix remain byte identical.
The six other original modules retain their complete archived bytes. The
four raw definitions preserve their exact original source text in the new
fragments. All 28 original public declarations are assigned exactly once.

In particular, the original final theorem remains:

```lean
theorem smallPairNoTriangle_3_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_3 = true
```

## Intended scopes, subject to actual full generation

The architecture produces 13 prefix helpers and one coverage helper in
addition to the preserved original declarations. The generator calculates
counts from the complete emitted source and rejects any mismatch with these
expected dimensions:

| Future scope | Targets | Definitions | Theorems | Declarations |
|---|---:|---:|---:|---:|
| closure-pilot | 4 | 9 | 2 | 11 |
| closure-rest | 13 | 0 | 14 | 14 |
| assembly | 9 | 4 | 13 | 17 |
| Total | 26 | 13 | 29 | 42 |

The pilot contains the exact Inputs and WitnessData modules, Chunk00 and
Coverage. The remainder contains Chunk01 through Chunk12 and the reconstructed
original Closure module. Assembly retains arithmetic, the four literal data
fragments and facade, the original assembly and triangle proofs, and the
original graph facade. These are prospective generated-scope counts, not
completed build, audit or replay counts. Root must collect the actual full
source generator's output before binding execution.

## Generator interface and provenance changes

`build_candidates(merged, archived, coverage_template)` remains a pure function
of its three byte inputs. It reruns the frozen inspector and requires the
canonical serialized result to match the actual narrow inspection's exact
SHA-256 and 32,435-byte length. It checks model, literal dimensions, all 28
original declarations, complete row coverage, raw fragment hashes/sizes,
original public headers and unchanged suffix/module bytes. The returned
candidate plan includes both `source_inspection_sha256` and
`source_catalog_sha256`.

The main entry point keeps four explicit path arguments, restricted to:

```text
MERGED = /Users/tp/Lean/D1Bound5/D1Bound5/SmallPairGraphData3.lean
ARCHIVES = /Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation/prepared-light-remaining39/D1Bound5
COVERAGE_TEMPLATE = /Users/tp/Lean/D1Bound5/D1Bound5/SmallPairGraphClosure29Coverage.lean
NEW_OUTPUT = /Users/tp/Lean/D1Bound5/research/continuations/20261022-graph3-closure/proposal
```

It also reads the actual graph3 intake catalog and the existing narrow
`20261022-graph3-closure/SOURCE_INSPECTION.json` from their fixed paths.
Source reads use the frozen descriptor-based, bounded no-follow reader;
original sources are checked against their actual hashes and sizes. Every
input is reread for equal bytes before any output directory is created.
This is two sequential observations, not an atomic filesystem snapshot.
All output files are created exclusively under the new proposal directory.
No project source, queue, state, accepted baseline or receipt is changed.
The script invokes no subprocess, compiler, Git operation or network call.

`INPUT_PROVENANCE.json` retains the existing merged/archive/template fields
and adds `source_catalog_path` and `source_inspection_path`. Its
`source_sha256` map includes those two actual research inputs. Any later
runtime adaptation must verify these extra fields and exact map entries,
rather than assume the old graph46 provenance schema. The frozen helper,
inspector and actual narrow inspection remain unchanged.

## Local checks and remaining execution boundary

Local checks parsed the Python sources and imported only pure module
initialization with file/subprocess operations trapped. They verified the
actual catalog and inspection hashes, all original pins/counts/model fields,
the complete prefix interval partition, the exact coverage-template bytes,
and the five available small archive texts against public headers and
recorded declaration-body hashes. The complete merged and three large archive
byte strings are remote-only; `build_candidates` and the generator main were
not run locally, and no proposal output hash is invented.

The proposed runtime remains separate and unbound. It must require the actual
completed and privately published graph3 foundation and both side scopes,
fresh idle HEAD/queue/configuration/source/artifact evidence, both locks,
one compiler, paused serial execution, the 240-second inner target cap,
exact original-type/transitive-axiom audits and target kernel replays. No
identical attempted or failed fingerprint may be retried. Original failures
and all historical records must remain unchanged.

A local source review or source generator result does not complete graph3,
integrate the canonical root or prove the main theorem. The full-ring O_K
scope and all original mathematical hypotheses remain unchanged.
