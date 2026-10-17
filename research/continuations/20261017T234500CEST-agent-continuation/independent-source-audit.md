# Independent source and statement audit

Snapshot inspected: 2026-10-17 21:44 UTC.

Remote project: `/Users/tp/Lean/D1Bound5` on the authorized Mac.

Mode: READ ONLY. This reviewer performed no compilation, remote source edits, index changes, or process termination. Existing compiler logs were inspected, not regenerated. This local report was written at the coordinating agent's request.

## Exact target

`Specification.MainStatement` quantifies over a number field `K` with `finrank ℚ K = 2` and `NumberField.IsTotallyComplex K`, and the genuine mathlib `NumberField.RingOfIntegers K`. It asserts that every finite `IsD1` set has cardinality at most five.

`Basic.IsD1` and `Basic.IsD1Tuple` require nonzero entries and pairwise distinctness, with square roots allowed to be zero. Tuple injectivity is explicit. Monotone modulus ordering permits equal moduli. `Sextuple.card_bound_iff_no_ordered_sextuple` preserves these cases.

The equivalence between roots in `K` and roots in `𝓞 K` is proved using integrality of a square root of an integral element. No root-nonzero assumption occurs. `MainStatement` is currently a definition of a proposition, not a proved theorem.

## Product-four and product-five endpoints

The actual tuple endpoints, rather than only conditional matrix interfaces, were inspected.

`IsD1Tuple.productFour_large_growth` assumes only an imaginary quadratic field and its full ring of integers, an actual `IsD1Tuple` of length four, monotone complex moduli, and first modulus at least three. It concludes `D > 2ABC`. Its matrix and irregular-tail hypotheses are constructed or discharged internally.

`IsD1Tuple.productFour_mixed_growth` assumes the same ambient and tuple conditions, with `A >= 1` and `B >= 3`, and concludes `D > (3/2)ABC`. The first condition follows from nonzero integrality when needed. No determinant, root-sign, or tail assumption leaks into this tuple endpoint.

`IsD1Tuple.productFive_growth` assumes the same ambient conditions for a length-five tuple, monotone moduli, and `B >= 3`. It concludes `D > 3ABSC`. It derives `A >= 1` internally and constructs a single compatible signed integral root matrix. Schur proximity, determinant bounds, nonvanishing, and bilinear estimates are discharged within the proof and its proved dependencies.

These types agree with frozen v4 `lem:product-four` and `lem:product-five`. Their quantitative hypotheses may imply that some pair radicands are nonzero, but no general exclusion of zero square roots was inserted into the definitions or endpoint assumptions.

The full-ring coordinate bridge was inspected. Existence of an integral basis `{1,w}`, trace normalization, and the norm lower bound are proved from the full integer ring. No suborder or chosen-coordinate hypothesis is substituted.

## Analytic and coefficient work present before this session

`HalfBinomialAnalytic.lean` correctly derives the half-binomial `HasSum` on `‖z‖ < 1` from mathlib's complex cpow power-series theorem. The Cauchy product and antidiagonal rearrangement give the product of two principal complex half-powers under `‖xz‖ < 1` and `‖yz‖ < 1`.

The pinned mathlib source of `Complex.one_add_cpow_hasFPowerSeriesOnBall_zero` was inspected. It is a genuine analytic power-series proof, using analyticity on the slit plane and the binomial coefficient/derivative identity.

`ComplexHalfBinomialTrial.lean` defines the genuine finite homogeneous convolution coefficient. Its norm estimate has the required constant four, degree condition `n >= 2`, and modulus bounds `‖x‖, ‖y‖ <= t`. Its tail estimate uses `m >= 1` and `n >= m+1`. Arbitrary complex variables, zero variables, and equal variables are permitted.

The complete homogeneous tail bound allows `m` to differ from the finite alphabet cardinality. Its right-hand exponent is `Fintype.card ι`. This is sound and more general than the manuscript specialization. That specialization must explicitly identify `Fintype.card ι = m` and use reciprocal anchors.

`LowDegreeConvolutionTrial.lean` proves exactly frozen v4 equation `eq:integrated-5` in degrees two, three, and four. The coefficient recurrence and factorizations are correct. Its private `lowDegreeHalfCoefficient` duplicates the actual public `halfBinomialWeightedCoeff`. The recommended integration is to port these identities to the public coefficient definition. The coordinator subsequently reported doing so; the original hashes below refer to the earlier files actually inspected.

## Integration status at the initial inspected snapshot

`HalfBinomialAnalytic.lean` existed under `D1Bound5` but was not imported by `D1Bound5.lean`. Its existing run record claimed only isolated compilation and incomplete axiom/replay acceptance. `ComplexHalfBinomialTrial.lean` and `LowDegreeConvolutionTrial.lean` were exploratory. Their inspected logs exposed the exact theorem types and only `propext`, `Classical.choice`, and `Quot.sound` for all respective declarations.

These are historical snapshot observations, not assertions about the coordinator's subsequent integration. Accepted-root status requires the new compilation and audit receipts.

## Trust observations and limits

A source scan of `D1Bound5.lean` and all `D1Bound5/*.lean` found no `sorry`, `admit`, own axiom declaration, `unsafe`, `native_decide`, `implemented_by`, `extern`, or `run_tac` token in actual proof source. Visible matches for the word `axiom` were comments.

The tracked mathlib working tree was clean. Its actual HEAD was `0df444a360eaa60ab8c11dca51a86af692955474`, matching `lakefile.lean` and `lake-manifest.json`. The toolchain pin is Lean 4.33.1.

This is an independent source/specification review, not a new compiler run, complete transitive axiom audit, clean-checkout build, or independent-kernel validation.

## Initial inspected source hashes

```text
60d7ff20e6ffc449c6452bceb3b22f98c1db628f9ed34831c674a58bbcf40b50  D1Bound5/Specification.lean
408272dc6fd995b836f6d3c6be839fa9c5248e49b1ec96b2135117042cb995cf  D1Bound5/Basic.lean
18bf68c70f7461d132ff1bb7a87d58364bb611e213e0471f018bd1b883568dd6  D1Bound5/TupleRootMatrixBridge.lean
6405700c83d4efaa313716abc06975c43c8dd7320d44c6d848be130386d5f504  D1Bound5/MixedProductFourGrowth.lean
80d98052c4994147171c28574e3e10fcf54fe865d2b39c5d757ddcc0ffb46c5d  D1Bound5/ProductFiveTupleGrowth.lean
109e12b103be56576f2b508ea1bde2f80f1c2a5c9319f282768950102447591a  D1Bound5/HalfBinomialAnalytic.lean
2555eedff68114926c871771791b8d3065c70c565ae892a1262c064bf3abb732  exploration/ComplexHalfBinomialTrial.lean
35d553182396ffbb42eaa90a0da0118d2bd6e9864b27227089d575b2c55e2bc9  research/continuations/20261017T231300CEST-low-degree-coefficients/LowDegreeConvolutionTrial.lean
776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3  verification/v4/output/D1_bound5-v4.tex
```

## New draft audit: crossblock_draft.lean

The theorem `crossBlock_rootMatrix_det_ne_zero` is mathematically correct as stated for characteristic-zero integral domains. It requires separate injectivity of the three row parameters and three column parameters and all nine square equations. It requires neither nonzero individual parameters nor nonzero root entries, nor disjointness between the two parameter families. These are legitimate generalizations of the algebraic portion of frozen v4 `sm:crossblock`.

The proof's key identities were checked algebraically. A linear dependence yields `2 λ μ r_0j r_1j = P b_j + Q`. Three distinct column parameters force the quadratic coefficient equations. Their displayed linear combination is exactly `L^2 (a_0-a_1)^2 = 0`, where `L = 4 λ^2 μ^2`. Characteristic zero and row distinctness force `λ μ = 0`. The separate two-row argument then eliminates the remaining dependence. This avoids an unproved assertion that a quadratic has at most two roots and avoids dividing by roots that may be zero.

The full-ring norm theorem is the correct arithmetic consequence, applying the existing nonzero integral norm bound to the determinant. The draft does not prove the analytic upper bound or the concluding inequality `W_3 > W_1^3 W_2 / 7`. Report it as the algebraic nonvanishing and arithmetic lower-bound portion of `sm:crossblock`, not completion of that lemma.

No hidden inconsistency or own-axiom substitution was found. Lean API/elaboration acceptance remains the coordinator's serial compilation responsibility.

## New draft audit: analytic_bridge.lean

The low and high reciprocal-anchor moment statements have the correct powers, sign, and product denominator. In particular, the low-order weight `a_i^(m-1)` multiplied by `a_i^(-n)` becomes the degree `m-1-n` Lagrange moment when `n<m`. For `n=m+k`, the high moment has factor `(-1)^(m-1)/(product a_i)` and degree-`k` homogeneous polynomial in reciprocal anchors.

`coherent_interpolation_series_exact` proves a genuine analytic identity from convergent series at finitely many distinct nonzero anchors. Its only series hypotheses are the explicitly supplied `HasSum` statements for the input analytic function. Finite summation, removal of the finite prefix, and division by the nonzero moment factor justify convergence of the homogeneous tail. No desired interpolation identity or remainder estimate is assumed.

`coherent_half_binomial_exact` discharges those input series hypotheses with the already established cpow series theorem. The exact split theorem separates the constant homogeneous term from the convergent positive tail. Its subtraction of `(1+xy)^(1/2)` is algebraic and therefore does not itself require `‖xy‖<1`. The manuscript's branch-specific interpretation and integral-root construction still require their own appropriate hypotheses and proof.

`coherent_half_binomial_full_tail_norm_le` correctly adds the degree-zero homogeneous term and obtains the norm estimate for `F_m-f_m`. Again, its parameter `m` and alphabet cardinality are independent in the general statement. A manuscript corollary should specialize to `ι = Fin m` or a finite set of cardinality `m`, reciprocal anchor values, `ρ=1/A_1`, and `t=1/P`, proving the radius condition from `A_1 P>1` and modulus bounds from the ordering hypotheses.

The identity corresponds to the analytic normalized expression in frozen v4 `eq:coherent-exact` and the tail is the correct `eq:coherent-tail` series. It does not yet define or prove integrality of the manuscript's `L_m`, prove cancellation of Vandermonde denominators as integral polynomials, or identify the chosen cpow factors with roots in the original integer ring. The draft's comments appropriately describe the step before multiplying by the Vandermonde and the chosen square root of `pq`; later reporting should retain that distinction.

No mathematical error, unintended exclusion of equal moduli or zero coefficients, or hidden target assertion was found in either new draft. New compilation and transitive-axiom receipts are still necessary.

The local new-draft source hashes at this review are:

```text
3f0cdbb7fa79ea43bbcbae7617aebbfce60a57c3b98b916984b5dbac924642a4  crossblock_draft.lean
e2a62b7c42f0055eb13c79bf90d72739cc68a90253c97ddc74fbf17f85bf8c5c  analytic_bridge.lean
```

## Remaining mathematical obligations

1. Finish the analytic-to-integral bridge for `L_m`, including root signs, the chosen square root of `pq`, Vandermonde cancellation, and nonzero integral norm bounds.
2. Specialize the full homogeneous tail inequality to exactly `m` reciprocal anchors and the manuscript parameters, retaining all radius hypotheses explicitly.
3. Complete the cross-block analytic upper bound and its numerical growth conclusion.
4. Prove the arbitrary-order Bennett determinant and required approximation consequences.
5. Complete exhaustive finite certificate coverage, descent, range cutoffs, and the three final sextuple exclusions.
6. Assemble a proof of the faithful `MainStatement` and obtain current end-to-end verification. Nothing reviewed here claims this final theorem.

## Additional independent audit: Bennett first-order drafts

Read-only local files reviewed: `bennett_draft/BennettFirstOrder.lean`, `BennettFirstOrderResidues.lean`, and `RESEARCH_NOTE.md`. No compiler was started. Manuscript equations were read directly from `paper/Diophantine_tuples_bound_five_2026-10-15.tex`, lines 938-1017.

The operator argument is mathematically sound. In the Lagrange evaluation basis, differentiation has matrix `D_ij = L_j'(a_i)`. The operator `t-(N+X)d/dX` has monomial coefficient matrix with diagonal `t-j` and upper adjacent coefficient `-Nj`. Consequently its determinant is `product_(j=0)^(n-1)(t-j)`. Conjugation by the Vandermonde is valid precisely because the nodes are distinct. The opposite multiplication order `tI-D diag(N+a_i)` has the same determinant by the standard `AB`/`BA` characteristic-polynomial identity.

The residue normalization is correct. Put `w_i=product_(l != i)(a_i-a_l)^(-1)`. The off-diagonal Lagrange derivative formula is `w_i D_ij=w_j/(a_i-a_j)`, so the minus sign in the operator gives the explicit entry `N^(-1)(N+a_j)w_j/(a_j-a_i)`. The diagonal is `N^(-1)w_i[t-(N+a_i)sum_(l != i)(a_i-a_l)^(-1)]`.

These entries agree exactly with the manuscript's finite residue formula at `k=1`. For `i != j`, the total multi-index degree is zero and the unique term has the additional factor `(a_j-a_i)^(-1)`. For `i=j`, the degree is one. Its `h_j=1` term gives `3w_i/(2N)`, and each `h_l=1`, `l != i`, gives `-N^(-1)(N+a_i)w_i/(a_i-a_l)`. Thus the manuscript square-root parameter is `t=3/2`, with no missing sign or power of `N`.

For `n=m+1`, the resulting determinant is `N^(-n) product_i(w_i) product_(j=0)^(n-1)(3/2-j)`. This agrees with the manuscript factor indexed by `v=-1,...,m-1`, since `3/2-j=1/2-(j-1)`. The product of weights equals the manuscript's product over both orientations of every pairwise difference. Reversing every difference does not introduce a further global sign because `n(n-1)` is even.

The identity itself can hold in arbitrary field characteristic as stated. The square-root specialization's nonvanishing correctly assumes characteristic zero and `N != 0`. Neither `N+a_i != 0` nor nonzero individual nodes is required. The first-order result does not establish arbitrary `k`, the global clearing factor, polynomial integrality, or approximation error estimates. The finite residue-sum definition and a formal theorem identifying its `k=1` specialization remain separate integration work.

## Additional independent audit: all-orders Bennett roadmap

Verdict: the roadmap is mathematically viable and does not assume the determinant identity it is intended to prove. The following checks concern a characteristic-zero field, `n=m+1 >= 1`, `k >= 1`, and pairwise distinct nodes. Generalized binomial coefficients must use their characteristic-zero field meaning. No root choices or contour integral are necessary for this algebraic route.

### Residual vanishing order

Let `P_ij(x)` be the polynomial obtained from the manuscript residue sum by replacing `N^(-k)(N+a_j)^(k-h_j)` with `x^(h_j)(1+a_j x)^(k-h_j)`, and replace `1/2` by a general parameter `nu`. Since `h_j <= k`, every entry has degree at most `k`.

Multiplying column `j` by the formal binomial series `(1+a_j x)^nu`, the coefficient of `x^r` in the sum of row `i` is the sum of the algebraic residues of

`binom(k+nu,r) W^r / [(W-a_i) product_l(W-a_l)^k]`.

The coefficient identity follows from `binom(k+nu,h_j) binom(k+nu-h_j,r-h_j) = binom(k+nu,r) binom(r,h_j)`. It is a polynomial binomial identity and does not require division by a possibly vanishing binomial coefficient.

The denominator has degree `nk+1`. For `r<nk`, the numerator has degree at most `nk-1`, so the sum of simple-pole residues is zero. Hence the residual series vanishes to order at least `nk`, exactly as stated in the roadmap. There is no missing one in this degree count.

A purely finite proof of the residue cancellation is available after establishing a partial-fraction/Hermite decomposition. Clear the denominator `Q(W)` and compare the coefficient of `W^(nk)`. The numerator contributes zero. Terms with pole order at least two have degree at most `nk-1`. A simple-pole term contributes its residue, since `Q(W)/(W-a_j)` is monic of degree `nk`. Therefore the sum of residues is zero. This avoids Laurent-series analysis at infinity, though the finite decomposition must still be proved.

### Determinant degree and constant

Replace one column of `P(x)` by the residual vector. By determinant multilinearity, the new determinant is `det(P(x)) (1+a_q x)^nu`, since all other replacement terms have repeated columns. Every entry of the new column is divisible by `x^(nk)`. Its binomial multiplier has constant coefficient one and is a unit. Thus `det(P(x))` is divisible by `x^(nk)`. The independent degree bound `degree(det P)<=nk` forces `det P=C x^(nk)`.

Define the cleared polynomial entries `G_ij(N)=N^k P_ij(1/N)` through their explicit sum with nonnegative exponents, rather than by rational substitution at zero. Then `det G=C` as a polynomial. One may prove this using coefficient reversal or first prove it for nonzero `N` and use infinitude of the characteristic-zero field. This constant-determinant step must precede evaluation at `N=-a_q`.

### Node-removal recurrence

At `N=-a_q`, column `q` of `G` is zero off its diagonal. Indeed, for `i != q` its total multi-index degree is `k-1`, so `h_q<=k-1` and `(N+a_q)^(k-h_q)` vanishes. For `i=q`, exactly the term `h_q=k` survives, giving

`binom(k+nu,k) product_(l != q)(a_q-a_l)^(-k)`.

For a complementary entry with `i,j != q`, set `r=h_j+h_q`. The power of `a_j-a_q` in the original expression becomes `-r`. Chu-Vandermonde gives

`sum_(h_j+h_q=r) binom(k+nu,h_j) binom(-k,h_q)=binom(nu,r)`.

This is exactly the reduced node construction at parameter `nu-k` and the same `N=-a_q`, multiplied in column `j` by `(a_j-a_q)^(-k)`. The reduction has `k+(nu-k)=nu` in its numerator binomial coefficient. Thus both the parameter shift and the proposed column scaling are correct.

Expansion along column `q` has cofactor sign `(-1)^(q+q)=1`. It therefore gives the stated recurrence with no extra sign. Any finite-index reindexing should use the same order for rows and columns so that their permutation signs cancel.

The one-node base case is `C(1,k,nu)=binom(k+nu,k)`. Iteration yields `product_(r=0)^(n-1) binom(k+nu-rk,k)`, equivalently `product_(v=-1)^(n-2) binom(nu-vk,k)`. Since `n=m+1`, this is the manuscript range `v=-1,...,m-1`. Every unordered node pair contributes both oriented differences to exponent `-k`, exactly matching the manuscript determinant formula.

### Scope and next proof obligations

No substantive mathematical error was found in this roadmap. Its steps are not yet accepted Lean proofs. The essential formal obligations are the exact finite residue definition, finite algebraic residue cancellation, the formal binomial residual identity, determinant divisibility/degree control, and the finite node-removal Vandermonde convolution. The generic parameter `nu` must be retained during induction because the shift `nu -> nu-k` is essential. Restricting prematurely to `nu=1/2` would obstruct the recurrence.

Do not extend the roadmap naively to `k=0`, since the off-diagonal multi-index constraint involves `k-1`; this audit assumes `k>=1`. Evaluation at `N=-a_q=0` is legitimate only for the independently defined cleared polynomial matrix. It is not a license to substitute zero in `P(1/N)`.

### Bennett draft hashes inspected

```text
2fa53bc1d3e3c7acb9597497099e2c92d6a941d6fe114e9e11631ff862e797af  bennett_draft/BennettFirstOrder.lean
2db68dedd31808368e1b08da59706bcaf1ac74aaa5e1eafb6da71dd4911a1ca1  bennett_draft/BennettFirstOrderResidues.lean
0751a2d28c84e54f0ba45ca81ee0ac49b51dbdaa7f3c2accdfe5a42bea13c49d  bennett_draft/RESEARCH_NOTE.md
```

The Bennett author subsequently appended this review's coefficient-comparison refinement to the research note. That appended paragraph was also inspected and is accurate. The updated note hash is `d29454a8dc6633727f94b333b68500e708fa449c7a82c4fd958d1fad1728bc89`. The two Lean draft hashes above were unchanged at the time of this review.

## Final requested draft review: specialization, analytic roots, normalization, determinant principle

Mode remained source/mathematical review only. No remote source changes or compiler invocation were performed.

`coherent_specialization.lean` correctly closes the earlier cardinality and parameter substitutions. Both the series starting degree and the exponent in the majorant are exactly `s.card`, which also equals the cardinality of the subtype of anchors. With positive `A,P`, `A<=norm(a_i)`, and `AP>1`, it proves the reciprocal-node bound `norm(a_i^(-1))<=1/A` and the radius condition `(1/A)(1/P)<1`. The scalar factor `(1/P)^s.card` is correctly rewritten as division by `P^s.card`. Nonempty `s` supplies the necessary positive starting degree. Distinctness of anchors is unnecessary for this tail estimate and is correctly absent. The separate radius lemma has the proper product order and supplies strict convergence at each anchor. No mismatch of the cardinality and the remainder order remains in this specialization.

`coherent_analytic_roots.lean` uses the valid principal-power identity `(z^(1/2))^2=z` for every complex `z`, including zero. Its terminal root square is exactly `pq+1`, and its anchor root square is exactly `(ap+1)(aq+1)`. These are algebraic identities under nonzero `a,p,q` and `eta^2=pq`; they do not require disk hypotheses because only the square is being asserted. The final up-to-sign equality follows in the complex integral domain from equal squares and permits either or both input roots to vanish. It does not divide by those roots or choose incompatible signs. This is a correct analytic-root bridge, but its theorem types are still over the complex numbers. Transport of an actual integral product root and formal integrality of the resulting linear combination remain separate.

`interpolation_normalization.lean` has the correct sign and exponents for the manuscript form. Its explicit assumption `2<=s.card` proves `s.card-1=(s.card-2)+1` without truncated-natural subtraction errors. Factoring `Delta*eta` yields the weighted analytic sum minus the terminal factor. Only the common nonzero normalization factor is cancelled; no unproved nonvanishing of an individual nodal denominator is used. The theorem deliberately accepts any nonzero `Delta`; it does not assert that `Delta` is the Vandermonde or that the coefficients and the linear form are integral.

`bennett_allorder_determinant.lean` is a sound conditional determinant principle. A residual column combination whose distinguished coefficient is exactly one has the same determinant as the original matrix. A common divisor of that residual vector divides the determinant. The permutation expansion yields the columnwise total degree bound over any commutative coefficient ring. Combining divisibility by `X^D` with degree at most `D` gives the exact top monomial, including the zero determinant case. The uniform specialization uses `D=Fintype.card(iota)*k`, with no missing factor. Its residual divisibility is explicitly assumed, so this module neither defines the Bennett residues nor proves their cancellation or their determinant constant to be nonzero.

One important proof-design constraint was communicated to the coordinator and both Bennett workers. This draft assumes the distinguished coefficient polynomial is exactly one, not merely that its constant coefficient is one. The manuscript has a zero interpolation node, so this assumption is available. During node-removal induction, remove a nonzero node whenever more than one node remains, retaining the zero node for the next application; the one-node base case then has the zero node. If an arbitrary zero node is removed prematurely, or an arbitrary-node version is claimed, a separate translation argument or the more general invertible-coefficient-modulo-`X^D` argument is needed. This is a constraint on the future application, not a false statement in the present conditional theorem.

No mathematical error, hidden target assumption, or exclusion of permitted zero-root cases was found in the four drafts. Compiler acceptance and the transitive-axiom audit remain the coordinator's separate responsibility.

```text
abbe031041b0e779beca4f81f9012f2f421df885bb8c1eed729af7c8784a0b41  coherent_specialization.lean
352b6073cf80c3d40aa16a014c092bed8d17013ab54de34ae7508f9928a78cf3  coherent_analytic_roots.lean
7dfc9a4ccf9059e3d0ab4c917e7a6413ba89859205adc98677022b5ec7242df8  interpolation_normalization.lean
d4ad136bba1428279a794309f2af79d21c79a906eda481e0c4808281896bf444  bennett_allorder_determinant.lean
```

## Final source re-review after compiler-directed syntax repairs

The current local drafts were reread, including the new `bennett_residue_coefficient.lean` and `bennett_draft/BennettPoleSeries.lean`. This remains an independent mathematical/source review, not an additional compiler run. Compiler outcomes communicated by the coordinator are not reclassified as this reviewer's own observations.

The cross-block, six interpolation bridge statements, normalization, parameter specialization, complex-root statements, conditional determinant statements, and first-order Bennett statements retain the mathematical hypotheses and scope audited above. The changes inspected were proof elaboration/import repairs, including explicit simplification, function congruence, and an unambiguous identifier for a relation coefficient. No assumption excluding zero roots, imposing strict modulus ordering, or assuming the claimed final inequality was added.

The new cleared-residue coefficient module is mathematically sound. If the pole multiplicity at `i` is `e i + 1`, its indexed cleared numerator is `(X-a_i)^j` times the other pole factors. Thus its corresponding pole order is `e i + 1 - j`, and `j=Fin.last(e i)` is exactly the simple pole. The numerator is monic of degree `j+sum_(l != i)(e l+1)`. Consequently the coefficient at total denominator degree minus one is one exactly at the simple-pole index, and zero otherwise. These degree facts correctly require only a nontrivial commutative ring and do not require distinct nodes.

The final two residue-coefficient theorems explicitly assume the exact cleared decomposition `hdecomp`. They then correctly identify the top coefficient as the sum of simple residues and prove that sum zero under the strict degree gap. They do not prove existence of that decomposition or identify its coefficients with the concrete Bennett multi-index sum. Describing this module as a complete proof of actual Bennett residue cancellation would be an overstatement. No such conclusion occurs in the formal theorem types.

The new `BennettPoleSeries` module has the correct local coefficients `binom(-k,h)d^(-k-h)`, and proves that the series inverts `(d+X)^k` when `d != 0` over a characteristic-zero field. Its coefficient theorem is meaningful for all `d` under Lean's total inverse convention, while the actual inverse theorem properly requires nonzero `d`. The `k=0` case is consistent. This is a genuine factor-expansion theorem. The product convolution, finite residue identification, and global residual cancellation still require separate proofs.

No false mathematical statement or hidden circular premise was found in the current local drafts. In particular, the arbitrary-order determinant lemma remains conditional on residual divisibility, the coefficient-cancellation lemma remains conditional on the exact partial-fraction decomposition, and the first-order determinant remains only `k=1`. The arbitrary-order Bennett determinant, its nonzero constant, the integral interpolation form, the cross-block upper bound, and the global sextuple exclusion must not be reported as completed by these modules.

Current rereviewed draft hashes:

```text
cd6114eda30e1efcab5d9caabda7a9fe3c6ed338040456745dfdf25b3b2550b3  crossblock_draft.lean
7bbc83e325fa7d4b7bd19dbbb6bd1f3e4c466b53ed239c2a118552ba5b7c5d20  analytic_bridge.lean
7dfc9a4ccf9059e3d0ab4c917e7a6413ba89859205adc98677022b5ec7242df8  interpolation_normalization.lean
122cba0b33343aad1bf0a43ec9cc4ef27153996e81fe2f46defd737270d1fe41  coherent_specialization.lean
65ea871c8d346e0ba2f39a27408ff1c688b0ec222fde370dbc93437166ad0f26  coherent_analytic_roots.lean
d4ad136bba1428279a794309f2af79d21c79a906eda481e0c4808281896bf444  bennett_allorder_determinant.lean
8c207032d119b0629e3cee3a36cfe0f7dd94d73784c8b28b8cba78efa262f829  bennett_residue_coefficient.lean
4664fa466c459928f5c91a9d33b2ed5293a525ebaff57c8ca43c89a6c3955693  bennett_draft/BennettFirstOrder.lean
2db68dedd31808368e1b08da59706bcaf1ac74aaa5e1eafb6da71dd4911a1ca1  bennett_draft/BennettFirstOrderResidues.lean
941da19e4e20cfd1ece142507e54a861e98862081cb384b4def418cd16919d50  bennett_draft/BennettPoleSeries.lean
```

## Final remote standalone-source correspondence

The seven final standalone source files were read directly from the authorized remote project after the coordinator's bundling step. This reviewer did not compile or mutate them. Standalone build, transitive-axiom checking, root integration, and kernel replay remain the coordinator's responsibility; this section does not claim those gates have finished.

All seven remote files match the reviewed local drafts after removing import lines and exploratory `#print` lines and normalizing whitespace. This comparison retains theorem statements, proof bodies, declarations, namespace/section boundaries, and comments. The coherent module matches the ordered concatenation of `analytic_bridge.lean`, `interpolation_normalization.lean`, `coherent_specialization.lean`, and `coherent_analytic_roots.lean`. Its import list was inspected. It contains all thirteen reviewed declarations with unchanged hypotheses and conclusions. No theorem was lost or strengthened during bundling. All seven standalone files contain no trailing `#print` or `#check` command.

The final `BennettFirstOrderResidues` uses the explicitly supplied finite set and function in `Finset.mul_prod_erase`, and `Finset.erase_right_comm` for the two erased indices. These changes supply the intended API arguments and do not change the residue formulas, sign, or assumptions. The final `BennettPoleSeries` qualifies `PowerSeries.C`, `PowerSeries.X`, coefficient functions, and the rescaling lemma. These qualifications resolve ambiguity with polynomial names and preserve the reviewed formal-series statements exactly.

There are 48 explicit theorem declarations in these seven files, including the three private cross-block helpers. This is a source inventory, not an independent proof-count or acceptance gate. The prior mathematical scope limitations remain in force: the all-orders residue decomposition/cancellation and Bennett determinant constant are not thereby completed, and no global sextuple theorem is claimed.

Final remote source SHA256 mapping:

```text
cd6114eda30e1efcab5d9caabda7a9fe3c6ed338040456745dfdf25b3b2550b3  D1Bound5/CrossBlockDeterminant.lean
289b0bd79153d270dd2b679ca68b0d95c46f0054669b3b58cbc13d328e8ce08c  D1Bound5/CoherentAnalyticInterpolation.lean
d4ad136bba1428279a794309f2af79d21c79a906eda481e0c4808281896bf444  D1Bound5/BennettResidualDeterminant.lean
8c207032d119b0629e3cee3a36cfe0f7dd94d73784c8b28b8cba78efa262f829  D1Bound5/BennettResidueCoefficient.lean
4664fa466c459928f5c91a9d33b2ed5293a525ebaff57c8ca43c89a6c3955693  D1Bound5/BennettFirstOrder.lean
a5bc776c76f0cc6f55ed92581ea8a603da02d8ca2275fd331ceaa1b560988ba0  D1Bound5/BennettFirstOrderResidues.lean
8723bb4bba6ef720998bc49eebcb04c9e158c38bf88666aa83919b7afb85f3f2  D1Bound5/BennettPoleSeries.lean
```

Matched normalized content SHA256 values, remote versus reviewed local source:

```text
99f804cf387efba621d7c0e2d0b47aa07ce62b26a774b35a84ea7e617d47dba2  CrossBlockDeterminant
dde2f17e9825d22b1310034a94ad78d18e9a642f348ca9a534bb1a6a9537aae6  CoherentAnalyticInterpolation
432d73726c4bd9b6a4b5916a91472ddaf11310811247e7928cb1574f1fd070f2  BennettResidualDeterminant
70c4b967c3abaf6e7b184c5fccf8375df4227fecff7f2d0a9a6e088c7e253d76  BennettResidueCoefficient
03f2883cfd353c9ebea6db81ddb6a49b12bd2b35016bf9faead868870a01855d  BennettFirstOrder
bbd66cad3189beaee966a5db2a65fd06d051e38f81c601835d6e6be2810e4ebb  BennettFirstOrderResidues
abe7cc955d2e607d6e6a5157904a32e3d20e890e955fcd874d07037256c09eea  BennettPoleSeries
```

## Final standalone PowerSeries proof normalization

After the preceding correspondence check, the coordinator replaced the single proof command `rw [map_mul, map_pow]` by `simp only [map_mul, map_pow]` before `ring` in the last theorem of `BennettPoleSeries.lean`. The replacement normalizes all occurrences of the coefficient homomorphism and does not alter any theorem statement, definition, hypothesis, import, or mathematical argument. The changed final proof lines were read directly from the remote file.

The final remote `D1Bound5/BennettPoleSeries.lean` is byte-identical to the current local `bennett_draft/BennettPoleSeries.lean`, with SHA256 `d467fe1ce7d532a4e4fe7ebbe139b749331fe498c06b5ac2897ed0a4d7fa6354`. This supersedes its earlier raw and normalized fingerprints above. Raw hashes of the other six standalone modules were re-read and are unchanged. This reviewer did not start compilation or modify remote files; the standalone retry result remains the coordinator's verification responsibility.
