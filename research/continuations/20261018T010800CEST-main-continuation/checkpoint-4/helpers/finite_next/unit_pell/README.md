# Exceptional unit-pair Pell certificates — draft, not yet compiled

This branch supplies the exact norm-two Pell computation for the pair
`{-1,1}`. Root is the sole Lean compiler, remote writer and Git operator.
None of the new Lean sources in this directory is claimed accepted yet.

## Exact reproduction

`generate_pell.py` independently reproduces the pinned public article's
`extension_graphs.py` output: 1016 squarefree fields `7 ≤ d < 10000`,
`d % 8 = 7`; 409 nonempty graphs; 19,612 signed vertices; 9,806 edges;
zero triangles. There are 484,964 continued-fraction states, including the
first overbound numerator in each field. The bound is `X=10^275` on the
numerator and closed radius `X^2=10^550` on an extension.

The stronger matching property holds: two distinct positive magnitudes
`x,y` have neither an ordinary square `x*y+1` nor a scaled square
`x*y-1=d*r*r`. Every one of the 516,440 required rejections has an exact
modular witness of modulus at most 107. There are no uncovered cases.
The masks accept all actual squares, including zero. No primality
assumption is used. Out-of-range witness indices default to an all-accepting
mask, so malformed indices cannot manufacture a rejection.

The diagnostic generator and JSON data are not trusted by the formal proof.
Every finite assertion is submitted to Lean's `decide +kernel`.

## Formal dependency chain

1. `PellMatchingCheck.lean`: modular-mask soundness, exact triangular witness
   lengths, matching property, signed-triple exclusion, and certificate type.
2. `graphs/PellMatchingPilot.lean`: small d4519 pilot, four positive
   magnitudes and six unordered pairs; only about 2KB of source.
3. `graphs/PellMatchingData1..26.lean`: the other 408 nonempty graphs,
   sixteen fields per file. Empty graphs use the proved empty certificate.
4. Agent source_audit owns `PellConvergentCompleteness.lean` and
   `PellCFPrefixCheck.lean`: genuine Legendre completeness, primitive
   positive convergents, monotone stopping numerator, verified integer
   complete-quotient recurrence, and both root signs via absolute values.
5. `PellFiniteCertificate.lean` joins the actual computed CF list to the
   graph list by checked equality. It proves the actual full-ring bounded
   no-three theorem using root's fixed `UnitPairArithmeticModel`, so
   negative-square and Pell parameters are the same d.
6. `prefixes/PellFinitePilot.lean`, then `PellFiniteData1..64.lean`, check
   every prefix, stopping numerator and exact magnitude-list equality.
   Public iteration count is one more than our last convergent index.
7. `PellFiniteFields.lean` supplies exhaustive field coverage. Each omitted
   `d=7+8k`, `0 ≤ k <1250`, has an explicit nonunit square divisor. Thus the
   proof does not trust Python's squarefree test or assume a field list.
8. `PellUnitPairBounded.lean` gives the actual ordered-sextuple endpoint
   `IsD1Tuple.unit_pair_fifth_large`: for entries 0,1 equal to -1,1, the fifth
   entry has modulus greater than 10^550. Root's actual field/axis reduction
   supplies the field range and real Pell descriptions.

The final analytic upper bound contradicting that large fifth entry is a
separate branch. The finite result does not infer an analytic cutoff.

## Reproduction and compiler policy

Run the three Python generators in order from the workspace root:

```
python finite_next/unit_pell/generate_pell.py
python finite_next/unit_pell/generate_graph_lean.py
python finite_next/unit_pell/generate_prefix_lean.py
```

First compile the generic checker and the d4519 graph pilot. Compile the CF
pilot only after its generic dependencies pass. Measure these before
queuing the complete batch. No `native_decide`, `sorry`, axioms or unverified
external arithmetic is used. `SOURCE_MANIFEST.json` records all source
hashes; the separate graph and prefix manifests record field/file mappings.

The independent mathematical audit of source_audit's two CF files passed:
strict floor brackets and exact denominator transition identify the true
real tails; coprimality plus positive denominators identifies the actual
integral convergent; the checked stopping numerator excludes every later
index. Compiler and API verification remains pending.
