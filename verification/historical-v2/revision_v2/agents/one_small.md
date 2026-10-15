# Final v2 audit: Sections 8 and 9

**Disposition: PASS.** I found no mathematical error, missing case, incorrect reference, or necessary language correction in the reviewed final text. No manuscript edit was made by this reviewer.

Authoritative source: `output/D1_bound5-v2.tex`, 3904 lines.

SHA-256: `5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70`.

The review covers all of Section 8 (lines 2882–3545), all of Section 9 (lines 3547–3847), and their use in the final proof. This was a fresh reading of the actual v2 proofs, including the unchanged surrounding prose. I also read the current prerequisite arguments for irregular growth (lines 108–145), tail irregularity, fourth-entry determinant gaps (392–521), the retained gap (790–875), integral transfer (1331–1404), fixed coefficient normalization, and the new adaptive rank argument (1640–1773). The four final QA changes were inspected; the revised description of the final table correctly refers to its cutoffs, and the Sections 8–9 mathematical data and arguments were unchanged.

The exact run regenerated the five polynomial families and all relevant finite sets; it did not read an old cache, an old result file, or another reviewer's numerical answer. The final-source run passed **23,921 exact assertions**. That is an assertion count, not a count of distinct theorems or a claim of proof-assistant formalization. Manual proof reconstruction and exact finite verification are distinguished below.

## Reproducible evidence

Run from the project root:

```sh
python revision_v2/checks/one_small_v2.py
python revision_v2/checks/one_small_cross_compare.py
```

Files:

- `revision_v2/checks/one_small_core.py`: exact full-ring arithmetic, square witnesses, two independent third-entry enumerations, polynomial generation, regional coefficients and overlap checks. The source hash is required before any calculation.
- `revision_v2/checks/one_small_v2.py`: 24-permutation determinant reconstruction, all 41 fixed-pair certificates, 57 cutoff calculations, and the new finite-complement proof checks. It verifies that the source hash is unchanged at completion.
- `revision_v2/checks/one_small_v2.log` and `one_small_v2_results.json`: final-hash results, including exact per-region and per-pair overlap quotients, every cutoff threshold, and the individual quadratic endpoint certificates.
- `revision_v2/checks/one_small_cross_compare.py` and `.log`: comparison performed only after the independent computations. All 57 row keys and 456 fields agree exactly with `completion_exact.json`: the five relevant cutoff outputs, all thirteen thresholds, the tail threshold, and the minimum overlap. The completion partition and worst quadratic endpoint agree as well.
- `revision_v2/checks/one_small_checker_development.txt`: records a mistaken assertion in the reviewer's first new determinant check, corrected after enumerating all permutations. The determinant has 22 cubic monomials, not the initially asserted 16. This was a checker-development error, not a manuscript error; the complete final-source run passes.

All acceptance decisions use integers or `Fraction`. Decimal displays are diagnostics only. The generator implementation was adapted from this reviewer's earlier independently written algorithm, but it now reads the actual v2 tables, requires the final source hash, and regenerates all polynomial and enumeration data. The six-column final table is parsed explicitly; exactly 56 rows are required. No deleted fourth-entry column or old fourth-entry search is used.

## Formal-claim and reading ledger

“Manual” means I reconstructed the argument from the current text and its stated hypotheses. “Exact” means the stated finite calculation was independently executed by the files above. Every scoped subsection and formal claim is covered; table entries are covered collectively and individually by the source-parsed result data.

| ID | Final-source location | Claim and verification | Status |
|---|---|---|---|
| OS01 | 2882–2891 | The remaining ordered case is `1≤A<3≤B≤S≤T≤C≤D`; norms are nonnegative integers. The scope matches the prior all-large and at-least-two-small propositions. Manual check of the transition and final use. | PASS |
| OS02 | 2893–2923 | Constants, five family parameters, the relabeled ordinary family, and `Phi=max(d0^6,v d0^5)` have the current earlier normalizations. The residual parameter `R_*` and the family subscripts have consistent referents. Manual comparison with the earlier constructions and exact regenerated coefficients. | PASS |
| OS03 | 2925–2954 | Every displayed forbidden interval follows from the integral approximation inequality with the correct powers of the anchors, `B,S,T,C`, and the factors 4 and `h`. Both terms of the adaptive maximum are retained. The retained gap supplies the needed size conditions in each actual application. Manual division and dependency check. | PASS |
| OS04 | 2956–3014 | The fifteen overlap quotients are sufficient lower bounds. I reconstructed the starting comparison, the first finite-family comparison, all subsequent endpoint divisions, and the relabeled junction. Positive/negative substitution directions are correct. The `S=B^2` and `S=B^3` equality cases are included. The ordinary base ratio is greater than one and its lower endpoints diverge, so the infinite chain really excludes every finite `D`. | PASS |
| OS05 | 3016–3042 | The phase estimate couples the two distances correctly. The parallelogram identity gives the stated radical; `d0≥v` permits the substitution and `d0<v` gives the separate bound. Differentiation gives the stated quadratic with one positive interior maximizing root. Thirty exact bisections provide a conservative upper enclosure. Manual derivation and exact five-row evaluation. | PASS |
| OS06 | Proposition `prop:pr-H2`, 3044–3144 | Five regions exhaust all integer norms 1–8 outside the proposed bounded regions. Their `U` values are upper bounds on `A`; the fourth-entry gap implies `AT>tnm²≥54`. The retained-gap coefficient, the weakening of `mu/(A²B²)`, and separate estimates for `G` and `rho` all have the correct directions. | PASS |
| OS07 | Tables `tab:pr-five-regions`, `tab:pr-five-coefficients` | Actual-source values were parsed and recomputed: all 25 coefficient integers, five adaptive residual comparisons, five phase bounds, five `G,rho` comparisons, all 75 overlaps and all five ordinary tails. Each printed overlap margin is a strict lower bound. | PASS |
| OS08 | 3098–3143 | The degree relation after root-anchor division yields the stated monomial majorant. All exponents substituted at `A²=n,B=S=m` are nonnegative, and all powers of `A` are even. The rational bisection and rounding prescriptions are executable and use strict inequalities in the needed direction. Fresh polynomial generation verifies the coefficient sums. | PASS |
| OS09 | Lemma `lem:pr-one-three`, first part, 3148–3170 | With the global absolute discriminant, the half-integral root representation is valid in both full-ring types. `k` is integral; a nonreal extension makes all four root coordinates nonzero. From `3ef=gh`, one obtains `V=3f²X/g²`, hence `X,V>0`, and `XV=12k²`. `k=0` would force a nonzero rational square to equal 3. Thus `64≥48 Delta k²≥144` is impossible. Manual reconstruction, including parity and zero-coordinate cases. | PASS |
| OS10 | Same lemma, second part, 3172–3183 | Purely imaginary full-ring integers are integer multiples of `sqrt(-d)`. A negative extension forces `d|2`, eliminates `d=1` modulo 3, and has odd absolute value for `d=2`. Any positive extra entry is divisible by 8 and cannot coexist with a negative one. Three negative extras would give two equal odd residues modulo 4 and a forbidden positive square value congruent to 2. The zero root at entry `-1` is included. No positive-quintuple theorem is invoked. | PASS |
| OS11 | Field-reduction lemma, 3185–3204 | For discriminant at least 25 the small first entry is rational and, after simultaneous negation, is 1. The root norm bound is strict. The only intermediate fundamental discriminants are 31 and 35; norm integrality excludes 35, and the four roots at 31 give `N(b)=80`. A rational root leaves precisely `b=3`. The field-independent rational pair is retained as an alternative, not incorrectly excluded. | PASS |
| OS12 | 3206–3230 | The ten full rings are exactly those with absolute discriminant at most 24. Multiplication, conjugation and norm formulas match the chosen basis. The norm disk follows from the completed square and includes both parity conditions and boundary elements. Manual necessity/sufficiency check and exact implementation. | PASS |
| OS13 | 3232–3261 and `tab:pr-forty-pairs` | Root range, division by `N(a)`, coordinate integrality, strict bounds on `B`, and the set-aside rational pair are correct. Only simultaneous negation and conjugation are used; they preserve square conditions. Fresh enumeration gives 146 pairs and exactly the printed 40 representatives with the stated per-field counts. No unit symmetry, equal-modulus case, or zero root is silently discarded. | PASS |
| OS14 | `tab:pr-forty-coefficients`, rational tuple before 3359 | All 200 printed coefficient bounds were reproduced from fresh polynomial rows, specializing at `a,b` before taking norms. The five stated rational-pair bounds `(12,41,25,300,1100)` are safe. They are field-independent because all polynomial evaluations there are rational integers. | PASS |
| OS15 | S<15 proposition, 3361–3387 | The proof begins with the existing strict tail bound `T>2BS≥90`, without introducing an unjustified factor `A`. All six edge radii and rational `k` values satisfy `1/2<k<1` and `r k²<2k−1`. The two square-root defect estimates follow by rationalization and `delta−z/2=−delta²/2`. Exact rational checks. | PASS |
| OS16 | 3389–3429 | The integral four-by-four matrix is the one from the cited determinant lemma and is nonsingular by the same congruence. I independently expanded all 24 permutations, recovered the signed leading cubic, and counted all cubic remainder multiplicities and quartic terms. This reproduces `alpha`, `beta`, and the stated `c_ij`; no absolute-value estimate incorrectly replaces a favorable signed term. | PASS |
| OS17 | Same determinant calculation | The bounds on `A/(BST)`, `B/(AST)`, `S/(ABT)`, and `1/(ABST)` follow from `1≤A<3,B≥3,S≥15,T>2BS`. Exact evaluation gives `alpha<141/500`, `beta<21/125`, and hence the contradiction at `tau=59/20` via `9999/10000<1`. The final `AT>90` is sufficient for the retained-gap row used. | PASS |
| OS18 | 3433–3465 | The lower/upper square-root enclosures have the required directions. For every one of the 41 pairs, `1/Q0>mu/nb` and `K>7/4`. The retained gap gives both `C>K T^5/S²` and `C>G B^5S³`; discarding additional positive powers of `A≥1` is legitimate. The pointwise coefficient divided by `R_bs` is at least `rho`. All 41 checks exact. | PASS |
| OS19 | 3467–3490 | Specialization precedes absolute values and preserves cancellation. The coefficient rounding uses `B^(P−2)` and `C0^(k−ell)` with the correct `nb≤25` branch. Every integer is the floor of the prescribed rational maximum plus one, hence strictly exceeds it even if the maximum is integral. Exact regeneration. | PASS |
| OS20 | 3492–3505 | `|a−b|>A` holds also for the two norm-two pairs since `B≥3>2sqrt(2)`. The finite residual maximum therefore reduces as stated. The adaptive residual is safely bounded by the displayed polynomial for `0≤x≤1`; its use does not depend on an obsolete rank restriction. Manual reconstruction and exact numerical use. | PASS |
| OS21 | 3507–3517 | Replacing positive powers of `A` by 1 is conservative; the two improved numerators are exactly 9604 and 784. All 615 overlap quotients exceed `59/50`, and all 41 ordinary-tail comparisons exceed 1. The common interval argument therefore proves the stated bound for all 40 listed pairs and the additional rational pair. | PASS |
| OS22 | 3519–3545 | Norm cutoff 224 is exactly equivalent to integral `N(s)<225`. The square test is necessary and sufficient in the full ring, including zero, `e=0`, both signs and parity. Direct enumeration and an independently organized root-first enumeration agree on all 57 triples. The exact set equals the actual six-column table's 56 triples plus `(1,−3,3)`, correctly excluded by the negative-entry lemma. No extra symmetry is applied to `s`. | PASS |
| OS23 | 3547–3554 | For the already normalized literal pair `(1,3)`, the lemma makes all entries rational and rules out any negative entry in a sextuple. Positive rational algebraic integers are integers. The only third entry with `3<s<15` satisfying both square conditions is 8, verified directly. The 56 listed triples and this one rational triple are disjoint and exhaustive. | PASS |
| OS24 | 3556–3594 | The fixed-triple enclosures bound `Q` and `Phi` correctly, including the mixed `b0 d_bs^5/s0^6` term. All 57 `1/q1>mu/b0` and `K>1` inequalities hold. Norm-two rows impose `N(t)≥4a0b0s0+1`, strictly giving `T>2ABS`; norm-one rows use the tail lemma. `N(t)≥1024` supplies `AT≥32`. The retained gap therefore applies without a circular size assumption. | PASS |
| OS25 | 3596–3615 | All fixed-pair coefficients use the correct family order. Regeneration of the relabeled `N3` at `(b,s)` reproduces every `M_bs`, including the rational value 34. The branch denominator exponents 7 and `10−ell`, factor `101/400`, and `C0=max(1000,200S)` match the normalization. | PASS |
| OS26 | 3617–3650 | The five residual constants, adaptive residual and ordinary-three constants are valid for the current pairs. The fixed endpoint table discards positive powers of `A` only from upper endpoints, so both possible `a0` values remain covered. All raw endpoints were checked against the common table and earlier approximation forms. | PASS |
| OS27 | 3652–3689 | All thirteen displayed endpoint quotients follow from raw endpoint division and `C>K T^5/S²`; both adaptive lower endpoints are checked. Integer doubling and binary search determine the least strict threshold, with both final inequalities verified. The separate ordinary-tail threshold and norm-two guard are correctly included in `N0`. | PASS |
| OS28 | Table `tab:fixed56` | All 56 actual-source rows have the correct third norm, regenerated `M_bs`, and recomputed `N0`; the largest `N0` is 21270. Every individual threshold and its minimality certificate is archived. The table has exactly the intended six columns and no remaining fourth-entry enumeration field. | PASS |
| OS29 | 3691–3702 | For `N(t)≥N0`, the starting lower bound and strict consecutive overlaps exclude every possible finite `D`. The squared ordinary-base ratio has the stated lower bound, so one verified ordinary overlap propagates indefinitely; lower endpoints diverge. Equality `N(t)=N0` is included in the excluded case. | PASS |
| OS30 | 3704–3715 | For `(1,3,8)`, independently recomputed `q1=1822916667/5000000000`, `K>744`, `M_bs=34`, all thirteen displayed thresholds, tail threshold 14, and `N0=1024`. Thus positive integer `t<32`, while the tail lemma gives `t>48`. This excludes only the sextuple case needed here and invokes no external rational no-quintuple theorem. | PASS |
| OS31 | 3717–3723 | The third-entry set is already supplied by Section 8, so the finite-complement proof needs no second enumeration. In exactly 38 of the 56 actual rows, `4 b0 s0≥N0`. Strict `T>2BS` then contradicts `N(t)<N0`, including equality in the coefficient comparison. | PASS |
| OS32 | 3725–3744 | The current irregular-quadratic inequality applies to `(b,s,t)` because the tail is irregular. Its derivation uses two nonzero algebraic integers `U,V`, so `|U|+|V|≤|UV|+1` is justified. The resulting `f(T)≥0`, convexity, and comparison with the older quadratic are valid; the comparison is correctly restricted to `X≥0`. The earlier endpoint calculation gives `f(2BS)<0` uniformly. | PASS |
| OS33 | 3746–3758 | In exactly 16 additional rows, the signed coefficient `[N(h)]_−−[N(q)]_+` is positive. Thus use of the lower bound on `sqrt(N0)` gives an upper bound on `f(sqrt(N0))`, not the reverse. All 16 resulting rational bounds are strictly less than −100. Convexity excludes the entire remaining open interval, not merely its endpoints. Exact source-row calculation. | PASS |
| OS34 | 3760–3782 | The only two residual triples are precisely `(1,−3,−2±2sqrt(−2))`, both with `N0=1024`. Their three norms are 33,457,153. Rational square comparisons prove `f(30)<−5`; with the negative lower endpoint and convexity, this gives `T>30`. Integral `|t+1|=u²+2v²` then belongs to `{30,31,32}`. Modulo 16 excludes the first two; residue zero forces `4|u,v`, and norm 32 leaves `(u,v)=(0,±4)`, giving `t=−33`, outside `T<32`. Exact residue enumeration and direct norm check independently verify the short argument. | PASS |
| OS35 | Proposition `prop:one-small`, 3837–3847; final proof | The conclusion uses all 41 first-pair possibilities, the 56 nonrational-case triples, the rational triple already excluded, and complementary strict ranges `N(t)≥N0` and `N(t)<N0`. There is no missing boundary and no reference to the removed fourth-entry search. Any larger tuple in the stated class would contain a sextuple in the same class. The global final proof invokes this proposition in the correct branch. | PASS |
| OS36 | New adaptive rank prerequisite, 1692–1703, and all scoped uses | I checked the new proof rather than assuming the old rank conditions remain available. If `3s²−(a+b)s−ab` is nonzero, its integral modulus is at least 1 and vanishing of `F_s` would imply `6C≤28S`, contrary to `C≥200S`. If it is zero, `F_s=0` forces `a+b=2s` and then `ab=s²`, hence `a=b=s`, contradicting distinctness. Therefore the removal of the former ratio/size rank conditions from the downstream one-small proof is valid. | PASS |

## Exact numerical checkpoints

The exact five regional minimum overlap quotients are archived in the JSON. Decimal displays here are for readability only:

| Region `N(a)` | Computed minimum | Printed strict lower margin |
|---|---:|---:|
| 1 | 1.2606619065104314 | 1.260 |
| 2 | 2.329681610981888 | 2.329 |
| 3 | 1.1660489526811069 | 1.166 |
| 4 | 5.459188847904102 | 5.459 |
| 5–8 | 1.3218181740641783 | 1.321 |

In each case the minimum occurs at the relabeled ordinary-family to `A4` junction. The gap bounds and phase maxima were independently recomputed from 30 rational bisections and the actual table values.

The exact determinant constants are

```text
alpha = 70428685819/250000000000
beta  = 752304371871001601/4500000000000000000
```

The minimum among all 615 fixed-pair overlap certificates is approximately `1.1871579586098404`, strictly greater than `59/50=1.18`; its full exact fraction and each pair's minimum are in the JSON. All 41 `K>7/4` and all 41 tail checks pass.

The full-ring pair enumeration independently gives:

| d | Orbit count | Raw count |
|---|---:|---:|
| 1 | 9 | 30 |
| 2 | 3 | 10 |
| 3 | 15 | 58 |
| 5 | 2 | 6 |
| 6 | 2 | 6 |
| 7 | 2 | 8 |
| 11 | 2 | 8 |
| 15 | 2 | 8 |
| 19 | 2 | 8 |
| 23 | 1 | 4 |
| Total | 40 | 146 |

Both third-entry enumeration routes give 57 before excluding `(1,−3,3)` and 56 afterwards. The separate rational pair gives only third entry 8. All 57 cutoff calculations pass; the rational thresholds are exactly

```text
3, 23, 96, 101, 108, 179, 131, 9, 34, 76, 123, 29, 438;
n_infinity = 14; N0 = 1024.
```

The finite-complement partition is exactly **38 direct tail + 16 quadratic endpoints + 2 elementary annulus arguments**. The largest of the 16 rational upper bounds is

```text
-526504132441877163783/5000000000000000000
```

which is less than −105 and hence less than the stated uniform −100. This is an exact upper bound, not a floating estimate of the true endpoint value.

## Candidate objections resolved

- **Forty versus forty-one and 56 versus 57:** forty refers to the field-dependent pair representatives after setting aside `(1,3)`; forty-one includes that additional pair. The direct third enumeration yields 57 in the forty-pair branch, one is removed, and the separate rational third `(1,3,8)` is then added for the common cutoff. Every occurrence in the current text follows this distinction.
- **Possible dependence on an external `{1,3}` theorem:** none is used. The local lemma proves rationality and excludes a negative entry in a sextuple. The positive rational sextuple case is excluded later by its own cutoff and tail contradiction.
- **Norm-two guard and a premature factor `A`:** the universal `S≥15` proof starts with only `T>2BS`; it derives `T>(59/20)ABS` before using the retained gap. The small-third norm-two case independently imposes the explicit norm guard. Neither argument assumes its desired stronger bound.
- **Zero square roots and half-integral rings:** the field arithmetic and square test include zero, pure imaginary roots, the `e=0` branch, and the full-ring parity condition. All returned square witnesses are multiplied back. Direct and root-first third enumeration agree.
- **Strict endpoints:** all intervals use the same epsilon convention; each strict comparison is checked exactly. The infinite ordinary tail has a base ratio greater than one and diverging endpoints. Equality at `N0`, regional branch boundaries and equal third-entry moduli is covered.
- **Deletion of the fourth-entry enumeration:** the new proof genuinely covers the entire finite complement. The universal lower endpoint for the quadratic is proved analytically; 16 upper endpoints are checked with certified sign and rounding directions; the two remaining annuli are excluded by an elementary full-ring norm argument. No old finite-search claim is needed to complete this proof.
- **Removed adaptive rank conditions:** the current integral nonvanishing proof covers every present use; the deletions are justified, not merely editorial.

All ordinary prose in the scoped sections was read with its current antecedents, table headings and cited labels. The final-table description now accurately says that the table contains the triples and their cutoffs. I found no actual ambiguity, incorrect dependency, or typographical error requiring a proposal. There are therefore no additional changes requested by this audit.
