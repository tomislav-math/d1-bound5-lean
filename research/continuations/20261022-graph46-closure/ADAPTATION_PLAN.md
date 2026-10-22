# Graph46 closure source preparation

This phase prepares a source-preserving closure proposal for a future reviewed execution. It is based on the actual broad graph46 inspection with SHA256 `f2d3955f2af8d40917f33e1697a825c786fb8a8f2a2f09720628f5a0cc0b2b54`. The narrow source inspection and complete proposal generation must still run against the actual remote sources. No proposal-output hash, compiler result, replay, acceptance, final baseline, or publication is claimed here.

## Actual merged source and archived originals

The current merged `SmallPairGraphData46.lean` is **2,184,936 bytes**, SHA256 `cbc0aecb61786cf910cf6f7e987d1dc255fcae3a9df10a4700def2ab8b8d6870`. Its eight preservation markers match the actual archived originals in this order:

| Original module | Bytes | SHA256 |
| --- | ---: | --- |
| SmallPairGraphInputs46 | 413,862 | `6333b204dd3536bbffa2ef809a533bc9064ac2358a86f4c3b384d25e4845bf29` |
| SmallPairGraphArithmetic46 | 567 | `f9a32640a9b051fd190da9bbb41a14d597818d62631e660bf974bcf2f782f93c` |
| SmallPairGraphWitnessData46 | 431,078 | `3841afc95893ed26ac8e5c9ad4bf6731084ca03aafa55c9acf04ebf8bcf99989` |
| SmallPairGraphClosure46 | 734 | `8cc3f88cd6dfbaabd0b7f1a56e28f8e00098fa11519f9c612ea82df4bcfbf41c` |
| SmallPairRawSelectedData46 | 1,335,344 | `fe085f12e6515d75b7568d0ddcbb303a1ef09f78cf9e4113a5646865de391f6c` |
| SmallPairLightAssembly46 | 2,047 | `6e234132c97201897fc0a7fb8b6edd79e6ed62c8792a7bf0786831c44ea7aefb` |
| SmallPairGraphTriangle46 | 396 | `0c226230f87956ec57f7eb8e4aeb385d0b852d01223caa9557f0af7d6cb178d7` |
| SmallPairGraphData46 | 124 | `f552150b39fb7f4c65bc718d1ecc68fa3fcd70343e8c3d734861c1d523266d4a` |

The source inspector must re-read all eight originals, verify their exact hashes and sizes, compare every preserved body to its merged segment, preserve all import/boundary whitespace evidence, and reconstruct the complete merged source exactly before it writes evidence. Original headers are compared with the merged headers without normalizing their source text.

The actual model is `QuadInt 1 6`, with `smallPairA_46 = ⟨-1,-1⟩` and `smallPairB_46 = ⟨-2,1⟩`. Closure, root-pair, and destination lists each have **719 rows**; the large-vertex list has **718 rows**. Left selected lists have 360 rows and right selected lists have 358 rows. The eight original modules contain **28 public declarations: 13 definitions and 15 theorems**.

## Exact data partition

The original raw selected data are divided only at their four existing complete definition boundaries. Each new data module retains the original import/namespace prefix, one exact full definition block, and original suffix. The raw facade contains imports only. No list literal is regenerated or reordered.

| Exact fragment | Bytes | SHA256 |
| --- | ---: | --- |
| SmallPairRawSelectedData46LeftCached | 183,870 | `f823be5f37e88e084cc22dd4653de386f557856f9cc1111a58e23d50ee434e5f` |
| SmallPairRawSelectedData46LeftRows | 350,897 | `9045d24265a2235b1784d04ea3ec7a5320fa7df4da966a378e1c1dcbfcab7455` |
| SmallPairRawSelectedData46RightCached | 182,650 | `40c91455704070272672e21a26d19ff39f582e48128ad57287d7a496a4ec62e2` |
| SmallPairRawSelectedData46RightRows | 618,584 | `1f12438dde9e65bd1df99f594096e8d0c017811b860982dd94614c9c201614cb` |

The 618,584-byte right-row fragment is larger than graph1's corresponding fragment. The proposal checks its actual hash, size, and full declaration body; it does not impose graph1's incidental 500,000-byte heuristic. Its compiler runtime remains unmeasured. Future execution retains the 240-second per-target cap, one compiler, both locks, and rejection of previously attempted unchanged fingerprints.

## Closure helpers and original theorem

The generated closure proposal follows the already reviewed graph1 architecture. Twelve prefix helpers cover **11 × 64 + 15 = 719** rows, with offsets 0, 64, …, 704. Every helper uses the complete original 719-vertex destination list and checks both mutation signs; only the witness and destination-index lists are dropped at the corresponding offset.

The coverage helper is adapted from the exact graph29 coverage source, SHA256 `16bbbcfa2e81413a9c2553d413b4d7d2e2f9203e70dc18f06687328ff90afce1`. It changes the graph-specific identifiers and the three explicit `QuadInt 1 1` annotations to the actual `QuadInt 1 6` model. The generator verifies the original graph46 input and witness type headers before doing so.

The original `PairGraphPrepared46.indexed_checked` statement is preserved exactly. Its proof assembles all checked prefixes backwards from the empty terminal drop 719. The complete original `smallPairClosure_46_checked` theorem and trailing source suffix remain byte-identical. Inputs, arithmetic, witnesses, assembly, triangle, and the original graph facade remain exact archived module bytes. In particular, the original triangle theorem remains:

```lean
theorem smallPairNoTriangle_46_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_6 smallPairLarge_46 = true
```

The intended proposal has 25 modules across three disjoint scopes: 4 pilot targets, 12 remaining closure targets, and 9 assembly targets. The original 28 declarations and 13 new reviewed helper theorems require exact type/axiom audit coverage; each target also requires a targeted kernel replay. These are proposed dimensions, subject to the actual remote generator's complete source checks.

## Required execution inputs

The source-only inspector takes the actual merged file, `prepared-light-remaining39/D1Bound5` archive directory, and a fresh output path. The proposal generator takes those same original sources, the actual graph29 coverage file, and a fresh proposal directory. Both create research outputs exclusively and do not touch project sources or the queue.

Installation and proof execution remain a separate future phase. They require actual completed and published graph46 foundation and side receipts, an actual idle baseline HEAD and queue, accepted current external artifacts, committed source maps, and separately reviewed executable bindings. No placeholder may authorize that phase. The canonical root and overall theorem are outside this source proposal.
