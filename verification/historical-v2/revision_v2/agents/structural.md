# Fresh adversarial review of v2: Sections 1–3

## Source, scope, and outcome

- Source: `output/D1_bound5-v2.tex`.
- SHA-256: `5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70`.
- Read afresh in full: lines 1–875, including the preamble, abstract, every sentence, display, table and proof in Sections 1–3.
- Additional direct dependency reading: lines 1845–1950, with substantive review of the new all-large application and `K=400` derivation at 1854–1888. The rest of the Section 6 interval-chain review belongs to its assigned reviewer.
- Read the old IR01 and P02 proposals before the v2 source became available. Those proposals and earlier favorable reports were not treated as verification of the final source.
- Outcome: **PASS for the mathematical claims and dependencies within this scope. No correction requested.** This is not a claim that this reviewer alone checked the whole manuscript or newly checked the external historical sources.

The final source was not edited. The article's main theorem needs its downstream case exclusions; this report verifies the structural and interpolation inputs to those exclusions.

## Newly executed checks

A new script, `revision_v2/checks/structural_v2.py`, was written for this review. It imports only the Python standard library and uses exact fractions, integers and a small explicit sparse Laurent-polynomial implementation. It does not import or execute prior review scripts or use prior numerical result files.

Executed command:

```text
python revision_v2/checks/structural_v2.py --expected-sha 5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70
```

The stdout is saved in `revision_v2/checks/structural_v2.log`; the structured results, all assertion names, table candidates, orbit representatives and exact values are in `revision_v2/checks/structural_v2.json`.

Result: **128 exact assertions passed**, including:

1. The regular-completion product identity and the new retained-coefficient quadratic.
2. A newly enumerated full-ring tail search with **90 unordered pairs, 118 retained triples, 16 candidates, and zero final successes**. Its six symmetry orbits agree exactly with the six rows parsed from the final TeX source, including each printed final value.
3. The 24-permutation four-by-four determinant, all 22 cubic and six quartic monomials, their graph decomposition, their Laurent substitutions, and the coefficient groups needed by the determinant bound.
4. The five small-first-entry endpoint comparisons, plus the new all-large `F(2)` and `F(3)` comparisons.
5. Cleared generating-function identities for the barycentric formula for each of `m=2,3,4`. These identities cover every Taylor order; they are not a finite sample of orders.
6. The low-order interpolation coefficients, every displayed rational parameter comparison, the strong two-anchor elimination identity, and the retained-gap constants.
7. The new exact coefficient exceeding 400.

The first launch found that SymPy was unavailable. The script was rewritten to use standard-library exact polynomial arithmetic before any successful run. No result depends on SymPy or an unexecuted computation. The scripted assertions support, rather than replace, the analytical and dependency reasoning below.

## Claim ledger

### Conventions and definitions — lines 1–114

**Status: cleared.** A square root in the field of an algebraic integer is integral, by transitivity of integrality applied to the monic polynomial `X^2-z`. Thus requiring the tuple roots to lie in the full integer ring is equivalent to requiring them in the field. Nonzero algebraic integers in an imaginary quadratic field have positive integral norm and modulus at least one. Zero square values are allowed; tuple entries remain nonzero and distinct.

The full integral basis, norm, absolute discriminant, and two explicitly distinguished coordinate conventions are consistent. Simultaneous negation and conjugation preserve pairwise products or their conjugates; arbitrary unit multiplication is correctly not used as a symmetry. Equal moduli do not identify distinct tuple entries. The regularity equation is symmetric and equivalent to the displayed completion formula by completing the square.

The historical paragraphs were read for local meaning and consistency, including the proper-subring distinction. I did not newly inspect their external sources in this pass. No separate style file is introduced in the preamble.

### Lemma `lem:irregular-growth` — lines 116–143

**Status: cleared, including the newly inserted equation.** Put `q=a+b`, `h=1+2ab`, and `delta=(a-b)^2-4`. The exact identities are

```text
u+v = 2(q+hc),
uv = c^2-2qc+delta.
```

Irregularity makes `uv` nonzero, so both completion expressions are nonzero algebraic integers. From their moduli at least one,

```text
2|h|C-2|q| <= |u+v| <= |u|+|v| <= |uv|+1
                                  <= C^2+2|q|C+|delta|+1.
```

Rearrangement gives exactly the new `eq:irregular-quadratic`, with the correct sign and coefficient of every term. It is valid independently of the subsequent lower bound `A>=3`; the lemma's later endpoint argument is where that bound is needed.

For `X>=0`, replacing `|h|` below by `2AB-1`, `|q|` above by `A+B`, and `|delta|` above by `(A+B)^2+4` gives precisely `(A+B+X+1)^2+4-4ABX`. The nonnegativity of `X` is essential to this comparison and is satisfied at `X=C`. Both displayed endpoint upper bounds are negative: `-4/9` and `-19/324`. Convexity excludes the entire **closed** interval `[B,2AB]`, giving the strict conclusion even at equal moduli or the alleged upper endpoint. The completion identity and quadratic majorant were expanded afresh in the script.

### Lemma `lem:tail-irregular` — lines 145–246

**Status: cleared.** The two regular signs are covered by choosing the sign of `r` in `d=b+c+2r`. For `C>=4`, the branch choices are compatible: `beta*gamma` can be given the required sign, and each later chosen analytic root differs only by a sign from an available integral root. None of the branches crosses its disk of analyticity.

The branch-error constants follow from rationalization and lower bounds for the real part of the square root. The bounds for `p=beta+gamma` imply `p!=0`. In the perturbation quotient, dividing the numerator by `A` is what gives `1/A+40/(39 sqrt(BC))`; hence the displayed `19/54` bound is justified using `A>=1`, rather than an unsupported upper bound for `A`.

For `|u+v-w|`, the upper bound is a positive multiple of `1/sqrt(A)` plus a positive multiple of `sqrt(A)`; it is convex on the specified interval. The endpoint bounds `12247/12636` and `14813/22464` are both strictly below one. Integrality then forces the difference to be zero, but squaring gives `2(ar-uv)=1`, impossible in the integer ring. The endpoint cases `C=4`, `B=3`, `A=1`, and `A=B` are included.

For `3<=B<=C<4`, integral norms give `9<=N(b)<=N(c)<=15`. A nonreal element of this norm range forces `Delta<=60`; if both entries are rational, distinctness leaves `{-3,3}` and its product condition forces the field with radicand 2. The harmless enumeration cutoff `Delta<=64` therefore covers every field. The script generated its 21 squarefree radicands independently.

The fresh disk enumeration uses `(2x+tau*y)^2+Delta*y^2<=4N`, including the parity condition and zero. Every tested root has norm below 70: the largest tested square expression is `ad+1`, with `A<4` and `D<17`, so its modulus is below 69. Both root signs are included. The script reproduces all four counts and verifies exact equality of the printed six-orbit table with the computed orbits. The stated final nonsquare obstructions are valid, including rational negative values. No failure at the final test was assumed from the old table.

### Determinant setup — lines 248–274

**Status: cleared.** The coherent off-diagonal entries square to the tuple products, hence are integral. Scaling gives `N=vv^T+F` and the displayed identity for `F_ij-1/2`. In characteristic two, entrywise squaring commutes with the determinant, including over a quotient ring with zero divisors. For even dimension, `J^2=0`, the inverse of `I+J` is itself, and the rank-one determinant formula gives one. Thus the integral determinant is nonzero. No field assumption on the quotient ring and no unjustified square-root sign consistency are used.

### Lemma `lem:product-four` — lines 276–324

**Status: cleared.** For the all-large branch, the tail lemma gives `D>6C` and `D>18` before any stronger product estimate is used. The entrywise perturbation yields an operator-norm bound `3e`; singular-value perturbation then gives the determinant and adjugate bounds even if the perturbed matrix is singular. The final exact coefficient is strictly below `1/2`, giving `D>2ABC` through the integral determinant.

For the small-first-entry branch, a nonnegative symmetric comparison matrix controls the complex matrix's Euclidean operator norm: `|Ex|<=B|x|`, and the comparison matrix's norm is its spectral radius. The weighted row bounds `1/9` and `11/96` are below `1/8`. The final coefficient `95225/36864` is below `8/3`. This proves the stated strict bound using only the hypotheses of this branch.

### Lemma `lem:product-five` — lines 326–390

**Status: cleared.** The preceding all-large four-entry result applies to the last four entries, giving `D>18C` and `D>54`. The Schur complement at the nonzero entry `d^2` is exactly the displayed `G`. The prefix inverse exists because its distance from `(J-I)/2` is below `1/8` while the least singular value of that matrix is `1/2`.

The resolvent bound gives `203/225<11/12`. Each paired-edge product differs from `1/4` by at most `7/192`: its two errors are bounded by `1/18` and `1/64`. The four-by-four zero-diagonal determinant formula is verified by the same fresh permutation expansion. The rank-two formula for `det G` has the term **`-p_0`**, with the correct placement of `p_0` and `q_0`; a separate exact two-by-two calculation verifies it.

The determinant coefficient is below `1/3`, and the independent norm bound on `G-F_0` is below `1/2`. This proves the necessary nonsingularity in odd dimension before invoking the nonzero integral determinant. There is no use of the even-dimensional congruence for the five-by-five matrix.

### Lemma `lem:five-frontier-gaps` — lines 392–520

**Status: cleared, including the new all-large branch.** The cubic graph identity contains four triangles, twelve unoriented Hamiltonian paths and six squared-edge terms. The script independently expands all 24 determinant permutations, obtaining 22 cubic and six quartic monomials, and verifies the stated cubic and quartic formulas.

Under substitution `delta_ij=z_ij/2`, the leading Laurent identity is exact. Grouping the **absolute original cubic coefficients** gives 2 in the four one-over-three groups and 6 in the six reciprocal-pair groups. Every cubic monomial has at most two incident occurrences at the smallest anchor; every quartic monomial has exactly two. Thus the `K_1`, `L_1=6K_1-1/2`, and `Q_1=9k_1^2k_2^2` constants in the majorant are justified; cancellation is used only where the exact leading identity supplies it.

The defect bounds follow from the displayed polynomial identity and `rho<=1/5`. The cases here have `AB>5`, including the new case `A>=3`. All majorant terms are positive and decrease when the lower bounds on `A,B` increase, so replacing `A,B` by `alpha,B_0` is legitimate. `J_0>0`, hence `F''(tau)=2J_0/tau^3>0` for positive `tau`.

For the new all-large case, the dependency is

```text
irregular growth -> irregular tail -> product-four -> frontier strengthening.
```

It does not use the retained gap or the later Section 6 result. Lemma `lem:product-four` already gives `tau>2`; with `alpha=B_0=3`, fresh exact evaluation gives

```text
F(2)=27298839409/40831674912 < 7/10,
F(3)=57530072833/61247512368 < 19/20.
```

Convexity makes `F(tau)<1` on the entire closed interval `[2,3]`, contradicting `1<=|det M|<=F(tau)`. In particular, the endpoint `tau=3` is excluded and the conclusion is strict. There is no illicit use of `2/A>2/3` in this branch.

For `A<3`, the tail lemma separately gives `tau>2/A>2/3`. All five rational lower bounds for `A` and the `alpha B_0>5` condition hold. Every endpoint comparison was recomputed; the maximum right endpoint is exactly the printed norm-two fraction, below `499/500`. The table remains a set of sufficient conditions, not an assertion that it covers every small first entry.

### Coherent interpolation setup — lines 522–589

**Status: cleared.** The analytic arguments have modulus below one because `A_1P>1`. The expressions `z` and `R_i` are integral, and all denominators in their coefficients cancel in the Vandermonde product. Distinctness, not distinct modulus, is required for those denominators.

The barycentric identity is correctly signed for `m=2,3,4`. The fresh script verifies the cleared rational generating identity for each `m`; extracting coefficients gives the displayed identity for all orders. Absolute convergence follows from `1/(A_1P)<1`. The absolute binomial series has the stated square, yielding `4|b_n|P^{-n}` for `n>=2`. Counting complete-homogeneous monomials then gives the full remainder bound without omitting higher orders. The three low-degree `f_n` formulas were multiplied afresh.

The near-one bounds follow from `|xy|<1/10000` and rationalization; they hold for complex arguments. No real-root ordering is assumed. The newly introduced plain-language definition of “anchors” is accurate.

### Lemma `lem:interpolation-parameters` — lines 591–651

**Status: cleared.** For two anchors, `|x-y|<=5/(4P)` gives the `25/128` leading bound. For three anchors, factorizing `f_3` and using `|y/x|<=1/4` gives both endpoints `45/1024` and `85/1024`. The complete tails give positive `l_H` for both parameter rows. All stated rational comparisons, including the four printed exact endpoint fractions, were recomputed.

When `L_3=0`, the exact identity equates `|1-f(xy)|` and `|F_3|/(XYV)`. The strict near-one comparisons therefore give the stated **strict** lower and upper bounds for `Q`, including equality in the size hypotheses.

### Lemma `lem:strong-two-anchor` — lines 653–685

**Status: cleared.** The squared elimination from `L_2=0` and its quadratic discriminant were independently expanded. The quadratic roots are exactly the two regular-completion expressions displayed. All divisions use distinct anchors or nonzero tuple entries; no zero-root case is silently discarded. The size conditions make the resulting bound for `Q/(XYP)` strictly below five. Thus even `Q=5XYP` forces nonvanishing.

The first summand is strictly below one half using `Z^2/Y^2>=159`; the second therefore exceeds one half. Finally `PQ>10000` makes `PQ+1<h_0PQ` strict. The asserted cubic growth follows without reversing an inequality.

### Lemma `lem:general-three` — lines 687–705

**Status: cleared.** The absolute coefficient bound for every `n>=3` is at most `1/(4P^n)`. Summing the full homogeneous series yields the stated bound for `F_3`. Since `P>=4S>=4A`, `P^2>=4AP>=36`; this justifies the different near-one constants used here. The two resulting coefficients are `296/71<5` and `6561/2240<3`. This lemma does not improperly require `Q>=4P`.

### Lemma `lem:separated-three` — lines 707–721

**Status: cleared.** From `A>=1`, `P>=1000`, and `Q>=4P`, the same parameter calculation is available with `H=1000` and `PQ>10000`. All four comparisons were recomputed. The nonvanishing-window implication uses the same strict near-one bounds and so remains strict.

### Lemma `lem:four-anchor-nonvanishing` — lines 723–748

**Status: cleared.** Two vanishing forms give quadratic interpolants of `uR_u` with equal leading coefficient `z`. Their difference has degree at most one and vanishes at distinct `a,b`, so they coincide. The quartic polynomial has leading coefficient `z^2-pq=1` and all four distinct anchor roots; the displayed factorization follows. Since `e_4=abst!=0`, the division by `w` or `e_4` is legitimate.

The numerator bound reduces to `11BST/A`, using `B/A>=1`, `ST>=1`, and `6ST+1<=7BST/A`. Its square gives exactly `121BST/(4A^3)`. With `r=BST/A^3>=1`, the final strict contradiction follows from `32r-1>121r/4`, including the smallest possible `r=1` and equality in the stated `P^2` hypothesis.

### Lemma `lem:direct-four` — lines 750–788

**Status: cleared.** Dividing the Vandermonde product by `prod u_j^(j-1)` gives the polynomial in consecutive ratios claimed in the proof. Each ratio has modulus at most one. The maximum-modulus argument and Hadamard's inequality therefore give the uniform `m^(m/2)` bound, including equal moduli. For `m=4`, the result is `16BS^2T^3`.

The leading `f_4` bounds use `|y/x|<=1/1000`; the complete tail uses `AP>=1000`. The exact `l` is positive. All four rational comparisons were recomputed, establishing both the direct bound and the strict vanishing window.

### Lemma `lem:retained-gap` — lines 790–874

**Status: cleared.** All approximation hypotheses are established before use. From `C>3ABST`, `T>2ABS`, `B,S>=3`, and `AT>=H`, one obtains `C>27H`, `TC>486H>10000`, `C/T>27`, and `C/S>9H>200`. Both applications of the strong two-anchor lemma meet `P>=5Y`, `Q>=5XYP`, and their inherited parameter guards.

The second strong bound `C>B^2T^3/h_0` exceeds the vanishing upper bound for the three-anchor form because `BT/(AS)>2B^2>=18>Uh_0` for both rows. Thus the integral form used in the retained inequality is nonzero.

The `W^2>kTC` inequality follows from `TC>4000`. The displayed first-term estimate and exact multiplication giving `mu=51051/400000` are correct. The lower bound for alpha is positive and exceeds one even at `AB=3`, `Qcal=8`, and `lambda=1/10`; its squared value after the `9999/10000` factor also exceeds one. Consequently the relative subtraction of one is justified by a quantity strictly exceeding `T^4>10000`.

The proof of the conclusion for `C` uses only five entries. Reapplying it to `(a,b,s,c,d)` therefore is not circular. Its hypotheses follow from previously established strict bounds. This gives the first `D` estimate and `D>1000C`.

For the four-anchor form, the preceding `D` lower bound contradicts the vanishing upper window once `C^2>17BS^3T/A`. The displayed comparisons prove this using only `C>3ABST` and `T>2ABS`. The first summand is below `1/10`, since its square is below `1/(9kA^8B^4)<1/100`. The second summand then gives the factor `9/8`. The final subtraction of one is valid because `(17/64)A^2C^8/(S^2T^4)>1`. All five stated size consequences and both `D` bounds are therefore established.

## New `K=400` application — lines 1854–1888

**Status: cleared.** The four-entry strengthening applies to the first four entries of the hypothetical all-large sextuple and gives `T>3ABS`. Thus `AT>3A^2BS>=243`, which is more than the required 48, and it also gives the weaker `T>2ABS` needed by the retained-gap lemma.

Inserting `T>3ABS` into its retained bound yields the coefficient `3^5 c_*`. Here `A^2B^2>=81`, `0<Qcal<=8`, and the expression inside the square stays positive. It is therefore legitimate to replace it below by `1/8-mu/81` before squaring. Fresh exact calculation gives

```text
3^5*(9999/10000)*(200/19)^2*(1/8-mu/81)^2
 =16405041495117/40000000000 >400.
```

Hence `C>400 A^7 B^5 S^3` follows with strict inequality. The proof no longer needs the old phase optimization. This check covers the derivation of the new gap, not a duplicate certification of every later overlap table.

## Final adversarial conclusions

The plausible failure points were explicitly attacked: zero completion expressions, noncoherent root signs, non-field reduction modulo two, odd-dimensional nonsingularity, equal-modulus anchors, boundary values in convexity, the exact leading-term cancellations, every lower-bound substitution before squaring, and cyclic dependence between the new `T>3ABS` result and the retained gap. None produces an objection to the final source.

No mathematical correction, added hypothesis, new disclaimer, or optional prose rewrite is requested from this review. If the source changes, the hash guard must be reconciled before these results are presented as evidence for that changed source.

## Final source reconciliation

The initial full reading used source hash `66f5a580e2b08bdd369c1b38a557de20a586cf3cf9a06bb7d0b82d4304587c63`. Four registered editorial changes QA01–QA04 then produced the final hash above. I inspected all four exact replacements and reread the affected introduction at lines 63–74. Reversing those four changes in memory reproduces the initial reviewed source hash exactly. Thus no intervening proof change is hidden by the hash update. The only change inside Sections 1–3 makes the historical field explicit; the structural and interpolation arguments are unchanged. The entire new, inexpensive exact script was rerun against the final hash and again passed all 128 assertions, including the finite tail enumeration. The JSON and log now bind the final source.
