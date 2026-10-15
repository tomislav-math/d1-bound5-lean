# Exact assessment of the small corrections and graph observation

Frozen source: `output/D1_bound5-v3.tex`.

SHA256: `a1119af75cf623411c678ea0e9b6e7dc9a3f59a931ee67384fc98be8d8373bd5`.

Scope: reviewer comments 2, 3, 5, 6, 7, 20(b), and the additional explanation of the 1016 Pell graphs. This was a read-only review. No article source was modified. The bounded check script is `review_v3_comments/checks/small_checks.py`, with exact results in `small_results.json` and an execution log in `small_checks.log`.

## Decisions

| Comment | Finding | Recommended treatment |
|---|---|---|
| 2 | The bound on F3 is correct in the actual case, but AT >= 9 alone does not imply it. | Add the missing explicit justification using the already assumed large T. |
| 3 | Discriminant cutoffs 60 and 64 enumerate the same 21 fields. | Uniformly use 60, and state that 90/118/16 are totals over all listed fields. |
| 5 | Legendre's strict inequality follows immediately from the Pell equation and d >= 7. | Add the short inequality u/v + sqrt(d) > 2 sqrt(d) > 4. |
| 6 | The final zero-square sentence concerns an earlier part of the proof. | Move the allowance u = 0 to the equations x-1 = du^2, 3x-1 = dv^2. |
| 7 | Contrary to the review's characterization, t < 32 is valid here because t is explicitly a positive rational integer. | T < 32 is optional consistency, not a mathematical correction. If changed, also change t > 48 in the same sentence. |
| 20(b) | Both the existing modulo-16 argument and the proposed direct enumeration are correct. | Optional shortening to a direct check for 0 <= abs(v) <= 4. The present proof is already short and elementary. |
| New graph explanation | The bounded graphs contain a perfect matching given by x paired with -x. Equality E = V/2 forces these to be all the computed edges. | Add a short explanation after the graph table. Do not claim an unbounded analytic classification. |

## 2. Bound on F3 in the vanishing case

Actual location: lines 2282--2285, Lemma 7.4, label `sm:bs7-cutoff`. The review calls this Lemma 7.3, but in the frozen v3 Lemma 7.3 is the four-root order-one lemma.

Lemma `lem:general-three` gives

\[
 |F_3|\le \frac{1}{4T^3(1-1/(AT))^3}.
\]

At AT = 9 the coefficient is 729/2048 > 1/3. At AT = 11 it is 1331/4000 < 1/3, with exact difference 7/12000. Thus AT >= 11 suffices; 11 is the smallest sufficient integer threshold for this displayed estimate. The actual case has A >= 1 and T >= 10^72, so the estimate is entirely valid.

Suggested local insertion before the displayed two estimates:

> Here $AT\ge T\ge10^{72}>11$, so Lemma~\ref{lem:general-three} gives $|F_3|\le1331/(4000T^3)<1/(3T^3)$.

This refers to the estimate in the proof of that lemma, rather than its stated bound on L3. To avoid ambiguity, one may instead write “the bound on $F_3$ in the proof of Lemma...” No numerical constants downstream need changing.

The other inequality in that display is also valid. Rationalization gives
\[
 |1-\sqrt{1+1/(tc)}|
 =\frac{1}{TC\,|1+\sqrt{1+1/(tc)}|}
 >\frac{1}{3TC},
\]
since TC is much greater than one. Thus the equality of the two terms forces C > ABS T^2 as claimed.

## 3. Discriminant cutoff and totals

Actual location: Lemma 2.2, label `lem:tail-irregular`, lines 216--231.

For a nonreal b or c, the integral norm identity gives Delta <= 4N <= 60. The rational alternative forces the field Q(sqrt(-2)), already in the list. The imaginary quadratic absolute discriminant attached to a positive squarefree parameter q is q for q = 3 mod 4 and 4q otherwise. Exact enumeration gives the same list for cutoffs 60 and 64:

\[
1,2,3,5,6,7,10,11,13,14,15,19,23,31,35,39,43,47,51,55,59.
\]

Therefore changing the second cutoff to 60 improves consistency without changing any enumerated field or output.

I freshly reran this small enumeration, using a norm-bounded box followed by exact integral-basis multiplication and a complete square table. The totals are exactly 90 admissible unordered pairs, 118 retained triples, 16 candidates, and zero final passes. The script stores all per-field counts. These are totals across the 21 fields, and the source should explicitly say so.

Suggested sentence:

> Summing over these fields gives 90 admissible unordered pairs $b,c$, 118 retained triples, and 16 candidates before the final square test.

## 5. Legendre denominator

Actual location: Lemma 7.9, label `sm:bs7-unit-pair`, lines 2557--2562. The review calls this Lemma 7.8; actual Lemma 7.8 is the cubic-gap lemma.

The retained pairs satisfy u >= 1, v >= 1 and u^2-dv^2 = 2, so u/v > sqrt(d). The relevant field parameters already satisfy d >= 7. Consequently

\[
 u/v+\sqrt d>2\sqrt d\ge2\sqrt7>4.
\]

This establishes the strict factor required for Legendre's criterion. A short insertion is sufficient:

> Every such pair $u,v$ is coprime, and $u/v+\sqrt d>2\sqrt d>4$, since $d\ge7$. Hence ...

No new lemma or citation is required for this correction. The existing proof of the criterion is independent of this small missing explanation.

## 6. The zero square for the pair {1,3}

Actual location: Lemma 8.2, label `lem:pr-one-three`, lines 3165--3175.

The entry -1 corresponds to x = 1, d = 2, u = 0 and v = +/-1 in
\[
 x-1=du^2,\qquad 3x-1=dv^2.
\]

This case is included in the existing proof. The subsequent statements remain valid: d divides 2, d = 1 is excluded modulo 3, x is odd, and positive entries cannot coexist with -x. The last modulo-4 argument concerns products of two negative entries, whose product plus one is strictly positive; the earlier zero square is irrelevant there. The review is correct that the final sentence is misplaced.

Suggested revision of the earlier sentence:

> Thus $x-1=du^2$ and $3x-1=dv^2$, where $u=0$ is allowed, and $d\mid2$.

Then delete the final sentence “This includes the possible zero square value when an entry is $-1$.” This is a placement clarification, not a mathematical repair.

## 7. t versus T for (1,3,8)

Actual location: Section 9.1, lines 3711--3712.

Section 9 opens with an explicit reduction: any sextuple containing the additional pair (1,3) consists of positive rational integers, by Lemma `lem:pr-one-three`. Thus on this branch t = |t| = T. N(t) < 1024 therefore implies both t < 32 and T < 32, and the growth lemma implies both t > 48 and T > 48.

The review's proposed capitalization is harmless and may improve consistency with the rest of the cutoff discussion, but the existing lowercase statements are not erroneous. If adopted, change both inequalities to uppercase T together.

## 20(b). Final square calculation

Actual location: Section 9.2, lines 3767--3769.

The current modulo-16 proof is correct. Square residues modulo 16 are 0,1,4,9, so the form u^2+2v^2 cannot be 30 or 31 modulo 16. If it is 32, reduction modulo 16 forces both u and v divisible by 4. Then u^2+2v^2 = 32 gives u = 0 and v = +/-4.

An equally valid direct check uses |u| <= 5 and |v| <= 4. The possible values of u^2 for |v| = 0,1,2,3,4 and n in {30,31,32} are respectively

\[
\{30,31,32\},\quad\{28,29,30\},\quad\{22,23,24\},
\quad\{12,13,14\},\quad\{-2,-1,0\}.
\]

Only zero is a square. The exact bounded script found only (u,v) = (0,-4),(0,4), both with norm value 32. This is genuinely a tiny complete calculation and requires no external program in the proof.

Optional replacement:

> Since $|v|\le4$, checking $|v|=0,1,2,3,4$ shows that $u^2+2v^2\in\{30,31,32\}$ has only the solutions $(u,v)=(0,\pm4)$. These give $t=-33$, contrary to $T<32$.

The existing two-line modular proof is arguably just as transparent. Either choice is acceptable.

## Additional explanation of the Pell graphs

Actual location: Lemma 7.9, after the table at lines 2600--2609.

For every real common extension x of {-1,1}, both 1-x and 1+x are squares in the same integer ring, so
\[
 1-x^2=(1-x)(1+x)
\]
is a square. Hence x is adjacent to -x. In the specific Pell parametrization x = u^2-1 and u^2-dv^2 = 2, this reads
\[
 1-x^2=-du^2v^2=(uv\sqrt{-d})^2.
\]

Each nonzero vertex occurs with its distinct opposite in the symmetric disk. These edges already form a perfect matching. The tabulated total E = 9806 = 19612/2 equals this mandatory matching count. Therefore no other edge can occur in any of the computed graphs. In particular no triangle occurs. Equality of aggregated totals suffices because every individual graph already has at least V/2 matching edges, so no negative deviations can cancel positive ones.

I checked the algebraic identity and the existing saved per-field results: all 1016 rows individually satisfy E = V/2 and triangle count zero. I did not rerun the large graph computations. The entire unit-pair proof is byte-for-byte unchanged between final v2 and the frozen v3, and the earlier recorded source-to-final-v2 check confirms preservation since the computational run. The earlier full-record SHA256 is included in the new bounded-check results.

Suggested insertion after the table:

> Each vertex $x$ is adjacent to $-x$, since $1-x^2=(1-x)(1+x)$ is a square. The total number of edges is half the total number of vertices, so these pairs are all the edges of the computed graphs.

Keep “computed graphs” or an explicit disk qualification. The numerical edge count is still required; this observation alone does not exclude other edges at arbitrary heights and is not a new analytic proof of the unbounded claim.

## Numbering corrections for the revision register

The labels in the actual compiled v3 resolve as follows:

- `lem:tail-irregular`: Lemma 2.2.
- `sm:bs7-cutoff`: Lemma 7.4, not 7.3.
- `sm:bs7-descent`: Lemma 7.5, not 7.4.
- `sm:bs7-unit-pair`: Lemma 7.9, not 7.8.
- `lem:pr-one-three`: Lemma 8.2.

Use labels and exact source locations rather than the review's shifted Section 7 numbering when applying changes.
