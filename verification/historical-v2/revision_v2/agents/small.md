# Section 7: actual v2 source audit

**Disposition: PASS within this scope. No mathematical correction is requested.**

## Scope and source binding

I freshly read the complete actual Section 7, lines 2011–2881, including every proof, table, unchanged paragraph, and the final proof of `sm:main`. I reconstructed its arguments and checked the hypotheses of its applications. I also inspected the actual statements and relevant formulas of `lem:general-three`, `lem:separated-three`, `lem:four-anchor-nonvanishing`, `lem:direct-four`, `lem:ordinary-residue-construction`, `cor:ordinary-height-envelope`, and `lem:ordinary-three-normalized`. Those underlying results have other assigned reviewers; this report verifies their use here, not a second full independent audit of all earlier sections.

The full source initially read and used for the complete graph computations was:

`66f5a580e2b08bdd369c1b38a557de20a586cf3cf9a06bb7d0b82d4304587c63`

The final source `output/D1_bound5-v2.tex` is:

`5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70`

The Section 7 slice, from its section heading through the text immediately before the Section 8 heading, has SHA256:

`cb1bd3f3678a24c33f65940344b15fa9afc664039c26d2f92b13d1bece2548cf`

The entire slice is unchanged between the two v2 source hashes. This is checked, not inferred from a message: `small_v2_source_check.py` reverses the four later guarded changes QA01–QA04 in the final source, recovers exactly the original whole-source hash, and compares the two Section 7 slices. All four later changes lie outside this section. Thus the expensive reruns remain applicable to the final source without being rerun after unrelated edits. The 74 inexpensive constant/algebra checks were additionally rerun against the final hash.

## Checks actually executed

The numerical algorithms are the independently written v1 checker rebound to v2, **not newly independent algorithms invented for this revision**. I read the implementation again, checked its arithmetic and completeness assumptions, and executed fresh full runs. `small_prepare.py` records input/output script hashes and preserves the computational core. The fresh proof reading described below is separate from these algorithm reruns.

| Fresh run | Actual coverage and result | Runtime |
|---|---|---:|
| `small_v2_exact.py pairs` | All 72 small-pair classes; 48 nondegenerate closures to modulus (10^{550}); 36,931 graph vertices, 36,854 edges, zero triangles. All 48 source table rows compared exactly. | 149.671931 s |
| `small_v2_exact.py pell` | All 1,016 squarefree fields (7\le d<10^4), (d\equiv7\pmod8); continued fractions through the exact numerator cutoff for modulus (10^{550}); 409 nonempty graphs, 19,612 vertices, 9,806 edges, zero triangles. | 4.158516 s |
| `small_v2_exact.py triples` | All small triangles and fourth-vertex tests for squarefree (d<36); 24 triangles in 10 orbits, no four-clique; all ten selected pair closures to (10^{40}), with exactly the printed extensions. | 0.123258 s |
| `small_v2_constants.py` | 74 exact rational inequalities or polynomial identities, including all cutoff branches, interval constants, mutation/inverse identities, and the symmetric-pair factorization. Passed initially and again on final source. | Less than 0.1 s for the final invocation; no separate internal runtime was recorded. |
| `small_v2_source_check.py` | Guarded reconstruction of the entire Section 7 difference from v1, byte equality of all three tables, final/initial v2 hash reconciliation, P03/P04 calculations, and 23 unit-pair classes plus the unique other product-(-1) class. | 0.003125 s |

Raw results and logs are in `revision_v2/checks/small_v2_{pairs,pell,triples,constants}.*`; the graph modes have separate `small_v2_runtime_*.json` files. The final source check is recorded in `small_v2_source_check.json` and `.log`. The initial rebinding and constant outputs were preserved as `*_pre_qa.json`. The executable checkers now target the final full hash, so an additional future rerun would check the delivered source; the historical graph runtime records correctly retain the hash actually used for those runs.

All number-theoretic decisions in the graph checker use Python integers, integer square roots, exact divisibility, and parity. Timing alone uses floating point. Both half-integral and ordinary integral bases are covered. The square test includes zero. Seeds and closure retain zero and anchor coincidences until final vertex filtering. The modular filters enumerate squares in the full quotient ring, so they provide necessary conditions even at ramified primes; every surviving edge is tested by the exact square criterion. The Pell computation uses the rational positive-square/negative-(d)-square criterion. Triangle counting uses neighbor intersections. No heuristic cutoff or floating-point square test is present.

The triple seed construction was checked in two ways: direct enumeration of the radius-33 norm ball and the manuscript's root-first enumeration followed by exact division. The resulting seed sets agree for all ten rows. The pair closure counts are exactly

`61, 89, 64, 105, 71, 112, 112, 57, 83, 55`.

## Formal-claim ledger

Every formal statement in Section 7 is covered below, together with the unnumbered six-entry interval calculation.

### `sm:crossblock` — lines 2024–2079

Verified nonvanishing of the integral (3\times3) root matrix: two proportional rows would give equality of distinct anchors after squaring at three distinct column anchors; rank two would make a square polynomial equal a quadratic with two distinct simple roots. Cross-root nonvanishing follows from (W_1\ge9). Verified the exponent rearrangement in the Cauchy–Binet sum, the factor (36/16), and the three geometric denominators. Absolute convergence justifies the infinite sum. The denominator is greater than (7/8), and squaring gives (49/324>1/7). No assumption on the arguments of complex entries is needed.

### `sm:lem-four-root-k1` — lines 2080–2188

Reconstructed the order-one specialization and checked its use of the common residue lemma. The new local definitions of (H) and (\Delta) have exactly the required four-anchor meanings. The determinant specialization is (-1440H^3\Delta^8\ne0). The stated residue expressions are polynomial and have even integral coefficients as required for the lower bound two. For (K=B^2S^4T^6), removal of incident difference factors gives (A_j^3|E_j|\le2^9K) and (A_iA_j^3|E_{ji}|\le2^8K). In a nonzero-index row, expansion of its diagonal entry gives one zero-row term, six off-diagonal terms, and the (6a_i^3E_i) term; this produces exactly (8192C+11264/A).

Verified the beta integral (B(5/2,7/2)=3\pi/256), the residual (192BS^3T^5/(AC^4\eta^{7/2})), and the safe constants 10300 and 193. The multiplicative forbidden interval has the correct directions and powers: with (CD/2<Z^2<2CD), either closed endpoint makes the respective term strictly less than one. The sum then contradicts (2<\cdots). There is no additive/multiplicative ambiguity and no endpoint gap.

### Unnumbered six-entry calculation — lines 2193–2223

P04 now names (a,b,s,t,p,q) as six distinct tuple entries and explicitly gives (A\le B\le S\le T\le P\le Q). This supplies the previously implicit referents without changing any guard. The shared-root nonvanishing lemma applies. Writing (X=BST/A^3\ge1), the numerical margin is

((32X-1)-(121/4)X=(7/4)X-1\ge3/4>0).

The separated three-anchor estimate gives the displayed (5BT^2/Z+3TZ/(4AP^3)). Since (P\ge4T\ge4A) and (AP\ge1000), the stated (P^2\ge4000) is valid. The two closed interval endpoints each bound a summand by (1/2), contradicting the strict inequality. The weakenings (100/(1-1/4000)<101) and (4/[9(1+1/4000)]>2/5) are exact.

### `sm:bs7-cutoff` — lines 2225–2336

Checked the three product bounds and their anchor choices; the crossblock condition (AT\ge9) is invoked only in ranges where it holds. The ordinary envelope parameters give exactly (g(x)=7x+212/5+(4047/25)/(x-4)), convex on (x>4).

* For (S\ge10^8), the lower bound on (C) supplies every four-anchor and separation guard. The bound on (DC) places (D) above the first forbidden endpoint. Thus (D>S^8/400). P03 correctly weakens this to (\log_{10}D>8s-3), using (400<10^3). Its difference from (g(s)) is exactly the printed rational expression, has positive derivative, and equals (1/375) at 49. Convexity on ([8,49]) gives (D<10^{389}).
* For (S<10^8), (T\ge10^{72}), the nonzero (L_3) branch has a lower forbidden endpoint below one and yields (D>T^8/10^{27}), contradicting the envelope. In the zero branch, the analytic identity first proves (C>ABS T^2>4T); therefore separated-three is not applied circularly. It then gives (C>5ABS T^2), all nonvanishing guards, and (D>1250S^5T^8). The envelope contradiction is valid. The remaining range (10^8\le T<10^{72}) gives (D<10^{549}).
* For (S,T<10^8), assuming (C\ge10^{100}), nonvanishing and the general-three estimate give (D>C^5/(100M^2)), which supplies both the direct-four separation condition and the bound excluding (L_4=0). The next lower bound (D>10^{-50}C^7) lies above (10^{143}C^5); the ordinary three-root window ends at (10^{-87}C^{11}), beyond the envelope (10^{60}C^7). All inequalities are strict in the needed directions.

These cases exhaust the possibilities and prove the claimed (C<10^{550}). P03 introduces an explicit intermediate bound, not a stronger unproved logarithmic estimate.

### `sm:bs7-descent` and the following closure paragraph — lines 2338–2379

The statement explicitly assumes the integral root (r_0\in\mathcal O_K), (r_0^2=ab+1\ne0). Every application obtains it from a compatible chosen pair; the nonzero condition is checked before invoking descent. Expanded both forward square identities and the inverse identity, with exact polynomial checks. They use no division by roots and remain valid for zero squares, zero extensions, and anchor coincidences.

For the contraction, norm integrality and the five possible unit traces give (|2r_0^2-1|^2\ge7); the excluded trace-(\pm2) cases would make (ab=0). The reciprocal roots (\lambda_\pm) cannot both have larger modulus at most five, since (2\sqrt7>26/5). The sign choice for (\tau) makes the denominator at least (|\eta z|), and gives the printed additive bound below 26. The strict decrease holds already at 33. Squared norms are nonnegative integers, so descent terminates; reversing its chain stays inside the original closed disk. Retaining the enlarged set throughout closure is necessary and done in both manuscript and checker.

### `sm:bs7-finite-pairs` — lines 2381–2470

Checked the doubled-coordinate parity rules, necessary and sufficient square test, initial small-element range, simultaneous symmetry action, and exact radius thresholds. The fresh enumeration finds exactly 72 classes: 23 unit-pair classes and the one additional product-(-1) class (d=3,(-1,-1),(1,-1)); the other 48 have valid descent. All printed coordinate representatives, vertex counts, and edge counts match the fresh closures. No triangles occur. A tuple containing three vertices in the closed disk would give a triangle, so the finite conclusion follows from the already verified descent completeness, not from an arbitrary numerical search radius.

### `sm:bs7-unit-axes` — lines 2472–2495

Reconstructed the orthogonal coordinate-vector argument. The real vector cannot vanish; a vanishing imaginary vector gives only the excluded (z=0). Primitivity and the divisor-of-eight equation leave squared primitive length one or two. In the half-integral basis, the odd/odd possibility in the latter case contradicts (g^2-dh^2=4\pmod4). Thus the integral Pell forms are valid in the full ring, and the lower bound (|z|\ge d+1) holds in both alternatives.

### `sm:five-unit-cubic` — lines 2497–2521

The analytic roots are integral because their squares already are squares in the ring, and either complex square root is one of the two integral choices. (L=0) would imply (c+d=0), explicitly excluded. The even binomial tail, (|h|\le9/40), (|z|^2\ge(80/81)CD), and the final coefficient square below two yield (D>C^3/2). No ordering or branch assumption is missing.

### `sm:bs7-unit-pair` — lines 2523–2619

Checked the positive/negative rational square criterion, including the coefficient integrality in the half-integral basis. The (d=1) case and same-imaginary-half-axis exclusion are valid. In the symmetric five-entry argument, adjoining (-b) is legitimate and yields a distinct new entry; the original distinctness excludes (b=\pm a,\pm1), and (b\ne0). The factorization ((G-J)(G+J)=(a^2-1)^2) was expanded exactly. Both factors are nonzero integral elements, so their moduli are at least one and their sum is at most their product plus one. Together with (A\le B), this gives the impossible (3A^4-4A^2-4\le0). Adjoining (-a) in the mixed-axis case has all square conditions supplied by conjugation and the two unit anchors.

The parity restrictions leave only real extensions in odd squarefree fields (d\equiv7\pmod8) when four further entries are assumed. The symmetric argument excludes repeated absolute values. Three cubic gaps and the ordinary envelope prove the smallest of those four absolute values below (10^4), whence (d<10^4). The parameters, monotonic difference, and endpoint comparison are exact.

Read and reconstructed the complete elementary Legendre-criterion proof. Consecutive convergents have alternating errors and determinant one. For a nonconvergent with denominator between the two, the integer coefficients are nonzero with opposite signs; the determinant estimate contradicts the assumed error. This includes the relevant reduced Pell fractions. Here (gcd(u,v)=1), and (d\ge7) gives the required strict (1/(2v^2)) approximation. The continued-fraction recurrence, stop condition, monotone numerators, and exact Pell test enumerate the entire closed disk. The fresh Pell run checked 484,964 recurrence steps (maximum 916 in one field). Its graph totals exactly match the source. Absence of triangles forces the third of four extensions outside the disk, contradicting the cutoff lemma.

### `sm:bs7-eisenstein` — lines 2620–2646

Verified (a^3=1), (b=-\bar a), the preserved sum (r^2+q^2=-a), and the integral inverse of (T). Its two complex eigen-coordinates scale by (2+\sqrt3) and its inverse. Balancing them gives squared root moduli at most (3/2); norm integrality makes them at most one. The six-unit enumeration and unit-square sums leave only the stated two pairs. The conjugate relation is invariant under (T) and (T^{-1}), hence holds for the original roots, forcing every extension onto the imaginary axis. The parity rule makes its coefficient integral. At most one extension lies on each half-axis, proving the bound four without numerical enumeration.

### `sm:five-two-small-four-large` — lines 2648–2657

For (d\ge36), all small entries and all relevant roots are rational; the only small compatible pair is the unit pair. For (d<36), the 72 classes partition into the unit pairs, the single exceptional product-(-1) class, and the 48 nondegenerate graphs. The relevant previous lemma excludes each part. The third of four large entries is exactly the modulus controlled by the cutoff. No field or exceptional pair is omitted.

### `sm:six-small-triple-classification` — lines 2662–2721

The (d\ge36) rational-root argument excludes any small triple. For (d<36), small nonzero norms are at most eight, and norms of candidate roots are at most nine; the finite graph therefore contains every required square, including zero. The fresh run confirms 24 triples, the ten stated orbits, and no fourth small neighbor. Every selected pair is compatible with (ab+1\ne0). Checked the root-first radius-33 bound, exact divisibility and integrality conditions, reverse-descent completeness, and third-anchor filtering. All ten orbit sizes and extension values agree with the table, and every surviving extension has modulus at least three and strictly below 85. The extension assertion is explicitly bounded by (10^{40}), not an assertion about all unbounded common extensions.

### `sm:five-small-anchor-alternative` — lines 2726–2769

When (E\le4V), the analytic main term has modulus greater than (1/(12V^2)), larger than the (F_3/(abs)) tail for (V\ge1000); thus (L_3\ne0). The general estimate would then be below one, proving (E>4V) before invoking separated-three. Its zero branch gives (5V^2<E<405V^2); its nonzero branch gives (Z>2V^3/9) and then (E>V^5/100). The final weaker lower bound (E>5V^2) is valid in either branch.

### `sm:five-three-small` — lines 2771–2870

Reconstructed the upper envelope (E<10^{60}V^7), the normalized-three forbidden interval, and the fixed-four-anchor interval. Checked each size guard and each exact endpoint comparison. The finite triple lists allow at most one further entry in the closed radius-(10^{40}) disk, and any such entry has modulus below 85.

If all three extra entries lie outside the disk, a nonzero consecutive form gives a tenth-power lower bound contradicting the seventh-power envelope. If both consecutive forms vanish, the quadratic bounds force the nonconsecutive form to be nonzero and give (U<100\cdot405^3), again impossible. If one extra entry is in the disk, four-anchor nonvanishing supplies one nonzero three-anchor form; the resulting (W>V^5/10^6) lies above the first forbidden interval's lower endpoint. The two intervals overlap since (V^2>10^{69}), and the envelope lies below their final endpoint since (V^4>10^{82}). All boundary cases are covered by the closed disk and closed forbidden intervals.

### `sm:main` — statement lines 2014–2017, proof lines 2873–2880

Selecting six entries including two small ones is legitimate if the proposition were false. The classification allows at most three small entries. Exactly two are excluded by the two-small proposition, and exactly three by the three-small proposition. This exhausts the cases.

## Editorial and source-difference review

The entire Section 7 difference from authoritative v1 is reconstructed by seven exact guarded replacement blocks. They account for all text: local (H,\Delta) definitions, P03, P04, three unused equation-number removals (one combined with P03), an unused section label, and the split rational-square sentence. No arbitrary masking or wholesale normalization is used. The P03 and P04 wording is correct, has clear referents, and supplies the intended local explanation. The local envelope remains (g), distinct from the analytic square-root function (f); no accidental function rename was found.

The pair longtable, entire triple table including caption, and Pell summary tabular are all byte-identical to v1. Their hashes and byte counts are recorded in `small_v2_source_check.json`. The pair table is additionally parsed by the fresh checker; the triple and Pell assertions are bound through exact row inspection plus this table equality. All complete enumeration details and the elementary continued-fraction proof remain present. No optional new stylistic rewrite is proposed.

## Limits of the conclusion

This is a fresh mathematical/textual audit of Section 7 and fresh execution of previously independent exact algorithms, with explicit final-source reconciliation. It is not a machine-checked formal proof. The exhaustive computations depend on the descent, axis classification, continued-fraction completeness, and cutoff proofs; those were separately reconstructed above, rather than inferred from matching counts. No new external-source attestation or full-manuscript audit is claimed here. No unresolved Section 7 defect remains from this review.
