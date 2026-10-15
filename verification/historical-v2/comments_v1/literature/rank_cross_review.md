# Cross-review of the four-row simplification and interval chain

**Verdict: no mathematical or application defect found in CA-1 or its two prepared diffs.** The four-row matrix has rank four under the existing quadratic-row hypotheses; the universal six-row construction can be removed. Residual constant 3 is sufficient, and all 15 remaining overlap comparisons pass with either the original K=54 argument or, conditionally on P02, its K=400 argument. No article was edited or candidate article written.

This review independently read `assessment.md`, `check_comments.py`, `current_proposal.diff` and `with_P02_proposal.diff` in `comments_v1/approximation/`, plus `make_proposals.py`, the exact replacement lists and the relevant unchanged source. The authoritative manuscript SHA-256 remains `74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228`.

## Rank and guards

Let E=3s²−(a+b)s−ab and L=2s−a−b. If the displayed determinant factor F_s=7L+6cE vanished and E were nonzero, E would be a nonzero algebraic integer in an imaginary quadratic field. Its norm is a positive integer, so |E|≥1. Hence

\[
6C\le 6C|E|=7|L|\le7(2S+A+B)\le28S,
\]

contradicting C≥200S. If E=0, F_s=0 gives L=0, then a+b=2s and ab=s². Thus a and b are both roots of (X−s)², contrary to the distinctness of a,b,s. Every other factor in the displayed determinant is nonzero by the same nonzero/distinct-entry hypotheses. This argument works even when some moduli coincide. It uses neither a ratio separation nor rationality of the entries.

The replacement removes only the extra sufficient rank conditions S≥2B and the alternative q≥18/17, S≥3 conditions. It retains the ordered moduli 1≤A≤B≤S≤C≤D and **all three quadratic-row guards** C≥200S, AC≥1000 and C≥1000. These imply the basic finite-form guards, preserve the sharper approximation-error factor 101/100, and ensure that z is nonzero. The statement “for every q≥1 with B≥qA” is sufficient for the unchanged coefficient and residual estimates: their monomial arguments require only the ordering, A≥1 and this ratio bound. There is no hidden use of S≥2B in those estimates.

This review relies on the previously established, unchanged four-row determinant formula. It checks the new nonvanishing proof; it does not claim a fresh independent symbolic expansion of that entire determinant.

## Residual 3 and the changed transitions

At x=1, the four leading-coefficient sums are 30/256, 30/256, 400/256 and 560/256, and the corresponding tail sums are 876, 1770, 2676 and 5268. With τ=21/(1024·999), the largest residual is

\[
\mathcal R(1)=35/16+5268\tau=65233/28416<3.
\]

This is the same normalization as the coefficient 2400H_*C³/Z. Setting both summands to at most 1/2 and applying the existing CD-to-Z² conversion gives exactly the proposed raw interval

\[
l_P=4\cdot2400^2H_*^2C^5,
\qquad u_P=\frac{A^6C^9}{4\cdot3^2S^4}.
\]

The common conversion factor in an outgoing-to-incoming quotient is h=(1+ε)/(1−ε)=4001/3999. Direct endpoint division, followed by C>KA⁷B⁵S³, gives the following decisive factors:

| Transition | Lower expression after the coarse gap, before the branch reduction | Sufficient reduction |
|---|---|---|
| N₂→P, H_*=BS³ | K²A²⁰B⁴/(25·2400²h) | None |
| N₂→P, H_*=B³S² | K²A²⁰S²/(25·2400²h) | None |
| P→N₃ | K²A²⁰S²/(16·3²M_n²h B⁴) | S≥B² |
| P→A₃ | K²A²⁰S²/(16·3²M_3²h B²) | S≥B; valid in the chosen S≤B² branch |

Both incoming comparisons are retained, so they cover the maximum defining H_*. The first branch can now start with G,Q,N₂,P for every S≥B. The alternatives at S=B² and S=B³ still cover every possibility; both boundary equalities satisfy the relevant weak branch reductions. Deleting the P₀ branch therefore leaves no missing interval transition.

The later reductions were independently reconstructed from the printed endpoints. In order they use B⁸/S⁴≥1 when S≤B²; no additional reduction for M→N₃; S⁶/B¹⁴≥B⁴ when S≥B³; B¹⁴/S²≥B⁸ when S≤B³; and S≥B for the four final finite junctions. For K=54, the N₃,bs→A₄ comparison still uses the retained phase bound. For K=400, it uses the proposed uniform residual 35/32 and the coarse gap. The simplification does not incorrectly mix these two versions.

## Independent exact controls

`rank_cross_check.py` constructs rational monomials directly from the manuscript's interval endpoints, divides them, substitutes the lower gap bounds, and applies the stated upper/lower branch substitutions only when the exponent has the appropriate sign. It then substitutes A=B=S=3 into the resulting expressions, whose remaining exponents are all nonnegative. This endpoint-algebra implementation does not import the approximation review's checker or its polynomial engine. It compares the independently derived final fractions with that review's JSON only after deriving them.

The run passed **104 assertions**, recorded in `rank_cross_check.json`. These are assertions within one checker, not 104 independent proofs. Results:

| Version | Comparisons | Smallest exact ratio | Location |
|---|---:|---|---|
| K=54, phase estimate retained | 15 | 4003515472412109375/3611631944665923584 > 1 | N₃,bs→A₄ |
| K=400, uniform b,s residual | 15 | 1224133953984/844113475625 > 7/5 | N₃,bs→A₄ |

For the infinite ordinary tail, direct substitution gives R₂/H₂ > K A⁸ B S³/105 ≥ K·3¹²/105 > 1 in both versions. Thus the checked O₅→O₆ overlap continues to every later order, as in the unchanged proof.

The same script applied each of the **17 guarded replacements** in each proposal in memory and verified:

- each old string matched exactly once;
- the deleted construction/rank labels have no surviving references;
- Section 6 contains no universal P₀, H₀, 145 or 300 remnant;
- the unrelated structural scalar `P_0=\frac2{\alpha B_0}` remains exactly once;
- the three quadratic-row guards remain unchanged;
- no undefined `ref`, `eqref` or `pageref` targets appear;
- the authoritative manuscript hash remains unchanged.

The approximation review's own `check_comments.py` uses audited polynomial-engine function definitions for its coefficient checks. That reuse is disclosed; it is not an independently implemented polynomial engine. Its exact-rational overlap formulas agree with this independent endpoint derivation. The new cross-check does not itself re-prove the upstream P02 fourth-entry improvement or its K=400 gap; the K=400 conclusion here is explicitly conditional on that separately reviewed proposal.

## Deletions and wording

Deleting the universal matrix, its cyclic minors, its residual/coefficient estimates, its interval and its three overlap entries removes material no longer needed. These deletions preserve the unrelated scalar P₀ in the structural estimates. The two P outgoing denominators are updated from 145² to 3² consistently with the updated interval. The downstream five-region, fixed-pair and fifty-six-triple edits remove only obsolete rank explanations; their numerical q-dependent residual estimates remain intact.

CA-2 correctly clarifies that H and V are formed and like polynomial terms collected before their absolute coefficients are summed. It does not claim cancellation between different binomial-series coefficients. No issue requiring another manuscript change was found in this wording.

No additional proposal is needed from this cross-review. It does not certify the full article or all of P02 anew.

## Reviewed-file hashes

| File | SHA-256 |
|---|---|
| `approximation/assessment.md` | `3d7d89c9278e8699b177abe4389dbe6da15c9f5db8136628ca894900df502a11` |
| `approximation/check_comments.py` | `f138f5c9b2aa7a223b344df962bd6c20b106028a2366d97991ba3946f0c6ab50` |
| `approximation/current_proposal.diff` | `4c7076c47ffd16402060a3780ad975dfd921bef23c51498e883f124e767cfb66` |
| `approximation/with_P02_proposal.diff` | `462532b47965aaa3928e085d342535308ea9efdb0d8f4ac6c6ba55068d087347` |
| `literature/rank_cross_check.py` | `02201473659a58a7f92dc498009cb6c6b7384d1f660ea88236bdb1f7fd4e9473` |
