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


## Independent review of the next substantive proof units

This section records a read-only mathematical/source review of the local next-step drafts. These are compilation candidates, not an assertion that their Lean proofs have compiled. The reviewer has not run a compiler or changed the remote project. Sources remain under active development; fingerprints below identify this local checkpoint, not the final accepted remote files.

### Full-ring {1,3} negative-entry branch

The complete `OneThreeNegative` draft, including the finite-set cardinality endpoint, is mathematically sound. Its common positive field parameter applies to all nonpositive rational integers that are squares in the same full integer ring. Including zero is essential and correctly permits the negative entry -1. The two negative common-extension equations force the shared parameter to be two and the extension to be odd. A positive common extension has integer square witnesses and is divisible by eight; compatibility with a negative one would contradict parity. Thus every non-anchor entry is a negative odd rational integer. Three negative odd entries cannot be pairwise compatible: their positive pair radicands have rational integer roots, while modulo four three odd residues cannot all form opposite-residue pairs.

The set endpoint correctly erases the two anchors before applying the extension restriction. Its disjunction permits the selected negative entry itself without requiring an unwarranted diagonal square condition. A hypothetical three-element remainder gives three distinct pair-compatible negative odd entries; hence the remainder has cardinality at most two, and the whole set at most four. No half-integral field, zero pair root, or permitted tuple entry is excluded. This completes precisely the negative-entry branch, conditional on containing 1, 3 and a negative rational integer; it does not assert the positive-only {1,3} branch or the whole main theorem.

### No four small entries

The three `SmallQuadruple` drafts and their README were inspected. The coordinate statement uses the exact integral norm bound at most eight, equivalent to complex modulus strictly less than three. Positive discriminant at most 32 and normalized trace zero or one yield exactly the sixteen models with parameter nu from one to eight. Retaining nonmaximal orders makes the finite rectangle more inclusive; it introduces no gap. For larger discriminant the completed-square bound forces imaginary coordinate zero. Already three distinct nonzero integers in [-2,2] contain a pair with product two, which would make the positive rational integer three a square, impossible in a positive-discriminant model.

The nested Boolean checker requires all six pair-square conditions, four nonzero entries, and all six inequalities. It permits a zero square root. Disk equality and the no-clique result are separate explicit kernel `decide` obligations. The soundness theorem consumes the proved exact square-test equivalence and exhaustive disk theorem. The actual full-ring endpoints transfer both tuple square witnesses and complex norm through the coordinate equivalence, with no choice of a proper suborder or special embedding.

An independent exact Python diagnostic regenerated all sixteen listed disks and independently tested all four-element subsets using the coordinate multiplication law. Every disk and exclusion agreed. This diagnostic is not an input to Lean and is not a substitute for compilation of the kernel certificates. The module proves only the cardinality part of the manuscript's small-entry lemma: at most three entries of modulus less than three. It does not establish the later triple classification or extension tables.

### Exact main reduction

`MainCaseReduction` fixes the faithful assembly target: no-small, exactly-one-small, and at-least-two-small ordered sextuple exclusions. The threshold is strict below three, with equality belonging to the large side; monotonicity permits all norm ties. The full-ring equivalence uses an actual complex-embedding instance in the reverse implication, so it does not exploit an empty universal quantifier. No branch is proved by this equivalence.

The additional `SmallSextupleReduction` draft uses the unconditional no-four-small theorem on the first four indices. Thus every actual ordered sextuple has its fourth modulus at least three. Its at-least-two-small branch consequently splits into exactly two or exactly three small entries. This is a substantive restriction from the finite theorem, but still not either remaining branch exclusion.

### Finite cross-block upper estimate

The new generic `CrossBlockUpper` source was checked. For a matrix `x_ij^2+x_ij/2+E_ij`, with `x_ij=a_i*b_j`, terms with repeated quadratic or repeated linear rank-one columns cancel in the alternating determinant sum. The retained product has thirteen terms per permutation: one cubic error term, three quadratic-layer/error/error terms, three linear-layer/error/error terms, and six mixed-layer/error terms. Six permutations give exactly

`18*P*c + 18*M^2*c^2 + 9*M*c^2 + 6*c^3`.

The separate-row and separate-column conditions in the mixed bound are correctly supplied by permutation injectivity. No analytic series interchange is required.

The author's proposed remaining numerical specialization was independently verified. With `W_i=|a_i|*|b_i|`, both block norm sequences sorted, and all W_i at least nine, take `M=W_3`, `P=W_3^2*W_2`, and `c=128/961`. The normalized bound is at most `18*c+(19/9)*c^2+(2/243)*c^3`, exactly `525134940928/215663394483`, which is below `18/7` by `205996514198/1509643761381`. The proposed scaling `|det(T)|^2=(W_1*W_2*W_3)^3*|det(R)|^2` is correct. Combined with the integral determinant lower bound it gives `W_3>(49/324)*W_1^3*W_2>W_1^3*W_2/7`. This paragraph audits the mathematical plan; at this checkpoint the actual source only contains the generic finite determinant estimate, not that complete full-ring specialization.

### Further arbitrary-order Bennett algebra

`BennettPartialFractions` proves the needed proper partial-fraction decomposition from mathlib's actual arbitrary-multiplicity theorem and degree uniqueness. Its final decomposition is a conclusion, not an assumed input. The positive multiplicities are `e_i+1`, the total degree is their sum, and the simple-pole index is correctly the last index `e_i`. The stronger numerator degree bound is strictly less than total degree minus one. Empty index types and the zero polynomial introduce no mathematical exception.

`BennettLocalResidues` defines an explicit residue as coefficient e_i of the numerator shifted by a_i times the other local inverse factors. At its own node these inverses cancel exactly; at another node the full factor X^(e_i+1) forces the relevant coefficient to vanish. Consequently its final explicit residue-sum theorem no longer assumes either a decomposition or cancellation identity. `BennettBinomialTransfer` uses the correct identity choose(k+nu,h)*choose(k+nu-h,r-h)=choose(k+nu,r)*choose(r,h), with the h>r zero case handled separately. It remains valid for the negative parameter values occurring in the node-removal induction.

`BennettClearedResidues` and `BennettResiduePolynomials` have the correct local coefficient index `k+delta_ij-1`, directed node differences, degree bound k, and homogenization multiplier N^k. At N=-a_q, removal of a different node contributes `(a_j-a_q)^(-k)` and shifts nu to nu-k. The off-diagonal vanishing theorem correctly requires k>=1; the surviving diagonal entry is choose(k+nu,k) times the product of directed inverse differences to power k. These statements do not assume a determinant identity. The main arbitrary-order coefficient identification, determinant monomial application, and induction determining its nonzero constant still require assembly beyond these individual modules.

### Coherent weights, integral lifts and quotient forms

All explicit two-, three- and four-anchor polynomial weights match Delta*a_i^(m-2)/prod_(j!=i)(a_i-a_j), with the displayed Vandermonde orientation and alternating signs. Ring-homomorphism transport preserves these identities. The coherent terminal root and each anchor root lift to the original tuple ring because equality of complex squares gives equality up to sign with an existing ring root or product of roots. The auxiliary eta need not itself be integral, and vanishing pair square roots are allowed.

The full-ring integral-form lower bound is valid for every nonzero such form. The specialized quotient-form endpoints discharge coefficient integrality by the explicit polynomial weights; they do not leave an unproved coefficient-integrality assumption. They still explicitly require the form to be nonzero, as they should. Proving nonvanishing or treating its vanishing alternatives, and comparing with analytic upper bounds, remain distinct mathematical work.

Checkpoint SHA256 values for inspected drafts (not final remote acceptance fingerprints):

```text
94580cd4f5977bc9f503aba3da8004380cecfe272766c2d856a70706a14c5d2b  main_next/MainCaseReduction.lean
4789e37bc7be370dca7760f7e8701eb6626196e753fc3782652d88cf791c3d64  main_next/SmallSextupleReduction.lean
6113e5b0e06c9632adba4c7515d0d7f4769e533064fe1459c5c642cf4405d042  one_three_next/OneThreeNegative.lean
14adf3f10fdc4fa38b0c8c8f25b1d030d41cedd9d36bb1ffe5906209d8835477  finite_next/D1Bound5/SmallQuadrupleCheck.lean
83944223ca113d2d1cc1c359d4a5cef8fb9f895b6e7bf9288b74b8f7a03d8908  finite_next/D1Bound5/SmallQuadrupleData.lean
3bc860b5d8cbf837f547c02785e2de88c015e4e2d35102342c17230c9850e5d1  finite_next/D1Bound5/SmallQuadruple.lean
146a04116b568bda5cb261a559b822c3f7c871044a80fe5debfb9cbb4172f1fb  finite_next/README.md
89edc282b9e6d017f860d77d81a59b3a9936f149f2c9011e8ecaf1e5b68c6b06  crossblock_next/CrossBlockUpper.lean
f7f7e7b0037fe6f4456a3f7f6adc6b834dc1d709eba87e7a15ecc386ed2aa010  allorder_next/BennettPartialFractions.lean
69884bc84f14bf065cb46a21f71bb9f253dca11c8d085058e033df4ac0004d31  allorder_next/BennettLocalResidues.lean
7c8a669a4f1cc287328c81f5b671e332dd23a6d5cc77c366017077852274896c  allorder_next/BennettBinomialTransfer.lean
649b9d14accf9c15bf6e1f50d0c0d7cf4a64cd373081517a7e7623c082493007  bennett_next/BennettClearedResidues.lean
841427398b3accc0992da179718a3298a8303809d161ed6857733241991f1a4a  bennett_next/BennettResiduePolynomials.lean
81ba9bc110346774bfe38546dd6df5b3d248268b6c5da77c404eff779b62f696  analytic_next/CoherentPolynomialWeights.lean
81e6a044e834ea1f7a20cfce931dfefd9cdd8cbc6a1dc7467c69328d64c38e4c  analytic_next/CoherentIntegralForms.lean
13073cd6c0cad34d5d51a4d419dcb87ec727ceb7d2adc316ea1d2993faecb1c5  analytic_next/CoherentQuotientForms.lean
```


## Latest mathematical review: completed draft chains and remaining limits

The following developments supersede the earlier local-draft gap descriptions where expressly stated. They are mathematical/source review results, not independent compiler results. The coordinator remains the sole compiler and remote writer.

The complete `CrossBlockGrowth`/`CrossBlockTuple` chain has now been read. It uses the slightly simpler error constant 2/15 and determinant upper constant 5/2, both valid strengthenings of the numerical target needed for the paper. The same selected signed matrix S is used for its approximation upper bound and its nonzero integral determinant lower bound. Row factors a_i*u_i and column factors b_j*v_j give exactly `(W_0*W_1*W_2)^3` after squared modulus; no exponent or sign factor is missing. Its actual tuple endpoint derives square witnesses and separate injections from disjoint indexed triples. Only the stated separate monotonicity and initial product at least nine remain. Subject to compiler acceptance, this chain really supplies the full cross-block growth inequality, rather than just its lower or upper half.

`CoherentTwoVanishing` correctly derives the regular-quadruple equation from a vanishing two-anchor form by cancelling only the difference of the distinct anchors. No square root is divided by. `CoherentTwoSize` then excludes that equation under A>=1, B>=3, P>=5B and Q>=5ABP. The regular extensions are exactly a+b+p+2abp +/-2rst. The scalar squared-root-product ratio is at most 2944/2025 <25/16, while (A+B+P)/(ABP)<=19/45, giving the strict upper bound Q<5ABP for any regular extension. The final actual-tuple endpoint derives A>=1, the requisite square witnesses, nonvanishing, and the integral modulus lower bound; it does not assume those conclusions. The remaining analytic application is separate from this nonvanishing/integrality chain.

All three new `SmallTriple` modules were read. Their finite checker gives complete containment for every unordered actual small triple. The same sixteen-model rectangle is exhaustive; the large-discriminant case has no triple at all. The only extra coordinate model admitting a triple is the nonmaximal trace-zero parameter four, correctly excluded from a full number ring by the existing squarefreeness theorem. The resulting full-ring models are exactly (tau,nu)=(0,1),(0,2),(1,1),(1,2). An independent exact diagnostic enumerated every three-clique in all sixteen models and matched the explicit tables exactly: maximal-ring table sizes 10+2+8+4=24. The coordinate conjugation `(x,y)->(x+tau*y,-y)` and simultaneous negation are correct. Formal containment and table size/orbit equalities are distinguished from the as-yet separate reverse-validity and extension claims. The literal manuscript representative labels were not independently reread during this subreview.

The new actual `BennettResidualCancellation` chain has now been checked. The row multiplicities are k+delta_i,l, so the total denominator degree is nodecount*k+1. The coefficient transfer produces precisely choose(k+nu,r) times the local residue of W^r. Thus actual residual coefficients vanish for r<nodecount*k. Truncating the binomial multipliers preserves every coefficient used; the retained zero node has multiplier exactly one because nodecount*k>0. This genuinely discharges the residual premise of the earlier generic determinant theorem for the defined arbitrary-order Bennett matrix.

`BennettDeterminantConstant`, `BennettNodeRemoval`, `BennettDeterminantFormula`, and `BennettDeterminantNonzero` were then read. Homogenization contributes N^(nodecount*k), exactly cancelling the inverse-variable monomial. Characteristic-zero infinitude justifies extending the resulting cleared-determinant constant identity from nonzero N to every N, including zero. Removal of the last node has cofactor sign +1 and contributes both directed node-difference products. Prefix induction retains the zero node at every nonempty stage. For n+1 nodes the final factor is the product, v=0,...,n, of choose(k+nu-v*k,k), equivalent to the manuscript's v=-1,...,n-1 indexing. The directed inverse differences carry the entire sign; no additional sign is missing.

This reviewer supplied `BennettChooseNonzero`, proving general choose nonvanishing when its parameter avoids 0,...,k-1, then the concrete shifted half-integer factors. The proof uses the actual inspected mathlib descending-Pochhammer product and factorial-times-choose identity; it does not cancel a possibly zero factorial. A hypothetical half-integer/natural equality gives 2k+1=2(vk+j) after the injective characteristic-zero cast, contradicting parity. The all-order agent independently reviewed this contribution and found it sound, including negative shifted parameters and k=0. The final draft determinant endpoints now have no assumed residual cancellation, determinant formula, or nonvanishing premise: the cleared determinant at nu=1/2 is nonzero at every evaluation, and the original determinant is nonzero away from x=0. This is the arbitrary-order algebraic residue-construction determinant chain, still awaiting coordinator-controlled compilation and distinct from the remaining approximation estimates and main theorem.

For the small-pair descent, this reviewer supplied `DescentDenominator`. It avoids a unit classification altogether. If r and r+/-1 have norm at least one, put n=|r|^2 and t=2Re(r); then n>=1, -n<=t<=n, and |2r^2-1|^2=4n^2+4n+1-2t^2>=7. In the full number ring, nonzero a,b and ab+1!=0 imply that a square root r of ab+1 is nonzero and r^2!=1, so discreteness supplies all three distance bounds. The explicit zero-radicand exception remains, as required by this descent branch.

The complete `DescentNorm` and `FullRingDescent` drafts were independently read, together with the actual imported `RootPerturbation` and `DescentAlgebra`. The reciprocal multiplier product is one, and squared trace norm at least seven forces one multiplier to have norm strictly below one fifth. The perturbation theorem with c=0 gives |eta|*|tau-eta*z|<7; |r0|^2<=2|eta|^2 then gives scaled error below20. Hence one of the two fixed-root mutation neighbors satisfies |w|<|z|/5+26<|z| for |z|>=33, and its squared norm decreases too. Both output root witnesses are the existing integral mutation formulas. Zero output values and zero output roots are permitted. This is a correct one-step descent; exhaustive seed/orbit classification and the ab+1=0 exceptional branch remain separate work.

Additional local checkpoint fingerprints:

```text
f402dc338e6dfc499aff62b02dcd0aae4146634e20d1d8edb04e8d2ee3f18a09  crossblock_next/CrossBlockGrowth.lean
8a53f29f0f00829905e6dfb2e8fe27a7dd5c734f8a6fa36f059405063123c965  crossblock_next/CrossBlockTuple.lean
f6ae7de3a2507c8bcd5f2254425f30f9f2f396b727544117c7a99919202db23e  analytic_next/CoherentTwoVanishing.lean
8d5cb73ffc542e68e89a3613d73b0e8d00c7da65faedada0845dda0b33679899  analytic_next/CoherentTwoSize.lean
1f75bcdaa9e326145897ef273ea3989447fff478e71849b1db21c3aa9abd5c19  finite_next/triple/D1Bound5/SmallTripleCheck.lean
d79644481c842f2a40b2f5554666f54fa185f12915c38d31e4f1b24ec16844da  finite_next/triple/D1Bound5/SmallTripleData.lean
f17b68a2328d7502a8849af67ca8e41b634ad73bffd5c752e8764303e3aa18bb  finite_next/triple/D1Bound5/SmallTripleClassification.lean
0e8f4d1dac16aef29c7622ad8fa6e48d05646e38a9ebaf133da673991996797d  bennett_next/BennettResidualCancellation.lean
47471ec70765180f47b55029fc308e45cdf1e2a0c7e524ec9af9154152e5584a  allorder_next/BennettDeterminantConstant.lean
744b0d9ca6cef7f147ff8e1fb3ed54499f22a4c9c12ff289d69e5603296721b1  bennett_next/BennettNodeRemoval.lean
b0659475e4fec348a7d26cbc314758e210958274b0bce2ebc3cf0adfdb0f52fe  bennett_next/BennettDeterminantFormula.lean
164557a33c15c3cbb3b959546eec9a30e4643b3c84fcd2c4978c868aa62a1f8f  bennett_next/BennettDeterminantNonzero.lean
242284e834a07d1f10f92c6ff0dc397a65048f9ca805d58c05766b00a9bc4ab5  bennett_next/BennettChooseNonzero.lean
d9fa2684f7c94f979c01131a2ead16e5d2881f927dc6936b4ef4f47e97848c23  main_next/DescentDenominator.lean
6309c62fcd4903a569e0c578e60929253cc2e264cce8dd0d660799342a26291f  descent_next/DescentNorm.lean
2e55b42fde6422335ead75da82f1c34e162158817b6e0e1f3d2739eadd60cb50  descent_next/FullRingDescent.lean
```

The article-audit worker independently reviewed `DescentDenominator` after this record was written and confirmed the exact identity, three-distance argument, full-ring nonzero derivations, and the absence of a hidden smallness or distinctness assumption. Equality in the complex bound is possible for primitive sixth roots, consistent with the constant seven. Later orbit/seed proofs must retain zero or anchor-valued intermediate common extensions, because the proved mutation correctly permits them.

## Denominator integrality, bounded descent completeness, and two-anchor upper bounds

This is a source/mathematical review of local drafts. No new build was run by this reviewer, and these fingerprints do not certify remote compiler acceptance.

`BennettBinomialIntegrality` proves the previously missing generalized-binomial denominator statement rather than assuming it. The exact base formula is 4^(n+1)*choose(1/2,n+1)=(-1)^n*2*Catalan(n). Its recurrence follows from the actual inspected mathlib Catalan/central-binomial identities and generalized-choose recurrence. Chu–Vandermonde then provides an explicit integer numerator for 4^h*choose(k+1/2,h), for all natural k,h, with no restriction h<=k. Rational-to-field functoriality gives the identity in any characteristic-zero field; multiplying by 4^(K-h) gives the uniform bound when h<=K. Functoriality from the actual integer binomial-ring structure separately proves every negative-integer-parameter coefficient integral. The all-order worker independently read this draft and checked its recurrence, signs, scaling, and cast arguments. This addresses binomial factors only; the complete Bennett matrix normalizing-factor cancellation remains a separate bridge.

`PairExtensionCore` and `PairExtensionComplete` correctly retain zero and anchor-valued common extensions, as required by descent. The seed cutoff norm<=1089 is the squared-modulus version of modulus<=33. The root bound uses integer-valued norm: root-norm squared<=17426<133^2 implies root norm<=132. Exact quotient reconstruction uses multiplication by the conjugate and division by the nonzero anchor norm. Square roots are unique up to sign, including zero roots. Canonical mutations cover all signs of actual witnesses, and the reverse mutation is recovered with the appropriate negated second root. Strong induction on the integer norm proves that a finite set containing all seeds and closed under bounded canonical mutations contains every actual bounded common extension. The proof does not silently require its descending intermediate extension to be nonzero or distinct from the anchors. The endpoint is completeness/containment; reverse validity of arbitrary supplied graph vertices and concrete graph certificates are separate claims, not inferred by this audit.

`CoherentNearOne`, `CoherentFormBounds`, `CoherentTwoUpper`, and `CoherentTwoGap` were read together. The actual convergent binomial-series remainder, principal-root branch, and symmetric-polynomial coefficient cancellation are used; the final upper endpoint has no arbitrary remainder assumption. The degree-two coefficient is -(x-y)^2/8; its bound 25/(128 P^2), plus the explicit higher tail 63/(3844 P^2), is below 7/(32 P^2). The root comparison 0.99*sqrt(PQ)<Z<1.01*sqrt(PQ) supports both scalar constants in the stated strict upper bound 21B/(20Z)+Z/(2AP^2). Combining the actual integral/nonvanishing lower bound with this upper bound and PQ-1<=Z^2<=PQ+1 gives the claimed A^2 P^3<(10001/10000)Q under its displayed hypotheses.

The hypothesis PQ>10000 is not implied by A>=1, A<=B, B>=3, P>=5B, AP>=32 and Q>=5ABP alone: A=32/15, B=3, P=15, Q=480 gives PQ=7200. This was reported, and no broader implication is asserted. The subsequent `CoherentTwoMainGap` correctly discharges PQ>10000 and AP>=32 in each actual main regime: A>=3 gives PQ>=10125 and AP>=45; P>=48 gives PQ>=34560 and AP>=48. It also supplies its auxiliary square root internally. Therefore its new main-regime wrapper has no missing analytic parameter or branch-witness premise. A possible strengthening by relaxing the near-one threshold was discussed but is not counted as an existing proved statement.

The `SmallSextupleReduction` edit in this checkpoint merely makes the map to `Fin 6` values explicit in the injection proof, resolving an inference ambiguity reported by the coordinator. It does not change its statement.

Local reviewed-source SHA256 checkpoints:

```text
caee668f30bb935f2388c15ef2f7811f85c07f1e9184c472ac83460ec5e684b8  bennett_integrality/BennettBinomialIntegrality.lean
eaea18b755b8f7e8f34fec90d13084740428d4b8247664ea529873a39dad87e5  finite_next/extensions/D1Bound5/PairExtensionCore.lean
b7f4a9bcbcf8ce4a5e28453ae3248ac43bf9a2403648a40057a77eaf724df5c3  finite_next/extensions/D1Bound5/PairExtensionComplete.lean
91b0fa3bb6d35c5241dc9f7de8c10b6455223ce03c54b1152a5f89666bb8c863  analytic_next/CoherentNearOne.lean
5f798fb010f3416a8f6a7df6993724a734a14e89ebca9dfd15fbdc272911e5b4  analytic_next/CoherentFormBounds.lean
e002fc6382b823787f279f9fd91e3ccabafe9ad864c044326604d14f16e84459  analytic_next/CoherentTwoUpper.lean
e8aae3271fff11229f084ead9ffb4aa3a83a872e55a441b92937dbd0bcf5adef  analytic_next/CoherentTwoGap.lean
218c2368700c8b6aa2d2ab32965e1099c79fd3b5febe3a23faddfa37f7ba72a1  analytic_next/CoherentTwoMainGap.lean
2f2b675e1d364ca494e730947448f10c1a8e9d0a223455b7d87ad4e8991d7442  main_next/SmallSextupleReduction.lean
```

## Actual two-anchor Bennett integrality and further independent reviews

The three new `BennettTwoDenominatorClearing`, `BennettTwoIntegralSummands`, and `BennettTwoIntegralEntries` drafts were read together with the actual `BennettSubringSums` and `BennettClearedResidues` definitions. They genuinely establish integrality of the defined two-anchor arbitrary-order entries, including the exact column divisibility. The identity h0+h1+h2+1=k+delta_j makes every surviving exponent nonnegative. Column zero retains a^(delta1+h1)*b^(delta2+h2), column one retains a^k*b^(delta2+h2), and column two retains b^k*a^(delta1+h1), together with the displayed polynomial factors. Signs from poles -b,-a and b-a are preserved. The antidiagonal expansion is exactly the actual three-index residue coefficient. The scale `(4ab(a-b)^2)^k G(abc)` equals the manuscript scale `(4(ab)^2 c(a-b)^2)^k P(1/(abc))`. Row lifts use the range subring of the original ring map, with no unique-factorization or injectivity premise. Positive k is explicitly required. The cleared integral endpoint permits c=0; only identification with reciprocal evaluation excludes it. No mathematical gap was found; compiler acceptance remains the coordinator's task.

`CoherentThreeGeneral` correctly derives PQ>=36 from AP>=9, P>=4S>=4A, and Q>=P. The geometric half-root remainder at |w|<=1/36 is at most1/70<1/36, giving the stated35/36,37/36 and36/71 bounds. Its exact tail constant is1085/16384, which together with the first-coefficient bound1/4 is5181/16384<1/3. The Vandermonde bound8BS^2 and the final constants5 and3 follow with strict slack. The final norm upper bound uses the actual analytic remainder, not an assumed auxiliary estimate.

All four `SmallExtensionSymmetry`, `SmallTripleRepresentativeProperties`, `SmallTripleOrbitProperties`, and `SmallTripleBoundedExtensions` files were read. Their transport uses only simultaneous negation and conjugation, both actual involutions preserving every square condition and the integer norm. Properness is required only of the final extension, never a mutation intermediate. The full-ring bridge uses exactly norm<=10^80, corresponding to modulus<=10^40, and produces strict modulus<85. The literal allowed lists were also inspected: each is a singleton except row8, which is empty. The largest listed norm is7168 at32-64omega in model(1,2), strictly below85^2=7225. Thus their uniqueness and smallness conclusions follow from the previously reviewed complete-list dependency. No hidden ordering, coordinate branch, or unproved orbit convention was found. This review does not replace kernel checking of the large finite certificates.

This reviewer supplied `UnitPairSymmetric`, the actual full-ring obstruction to a tuple containing {-1,1,a,-a,b}, with a,b distinct from each other and from the opposite anchor, and both moduli at least3. The core factorization `(G-J)(G+J)=(a^2-1)^2`, with G=2a^2b^2-a^2-1 and J=2axyvw, is exact. Discreteness gives both factor norms at least1; their product and the triangle inequality force3A^4-4A^2-4<=0, contradicting A>=3. Norm ordering is handled by swapping six existing root conditions, not by assuming a larger tuple. Zero roots are allowed. The all-order worker independently read and mathematically approved the entire draft. This is a substantive unit-pair ingredient, not the full unit-pair exclusion lemma.

Review also caught a concrete error in the first `CoherentThreeSimultaneous` draft: its cubic subtraction polynomial omitted the term -(p+q) in the X^3 coefficient. The correct coefficient is2*z*v-(p+q)+e1. The erroneous displayed polynomial expansion would be false for general p,q. This was immediately reported to the author and coordinator. The lower-coefficient and rational-identity strategy remains valid after this correction; acceptance of its corrected source is recorded separately when reviewed.

Local reviewed-source checkpoints (uncompiled by this reviewer):

```text
5c6dc38483a1ffe561d5b372dae564d5f7dfc4341056fc2ea52dce10beef81d6  unit_pair_next/UnitPairSymmetric.lean
0d963effaea260802075fce3b6666ab54e51276c7a00162cfd3b66c4a6a80629  allorder_next/BennettSubringSums.lean
fe93309e4ed29ce50db58301d6c4c7ac9f15423c0e17871ef3b2d6557acc2c1f  bennett_next/BennettTwoDenominatorClearing.lean
cf848c27c1e7b66b43f1bb2e9f008252599e35de774adedcbacb56ab48e836d3  bennett_next/BennettTwoIntegralSummands.lean
785e134bdd50cf275872ed8b977f9e082f4aef1087a73cebda82dfe69c4ca20a  bennett_next/BennettTwoIntegralEntries.lean
2efd66eb0a636e906a8d534b1a2fbfc96cd7006e143e38e037b577416df7647f  analytic_next/CoherentThreeGeneral.lean
b5b6500f05bd18eae4b7fb0224178384206a45604180b7258f0e4cfa00476118  finite_next/symmetry/D1Bound5/SmallExtensionSymmetry.lean
a83bbabd2bee324566724658a0b1876696641e481ed94e75fb471c1207165f52  finite_next/symmetry/D1Bound5/SmallTripleRepresentativeProperties.lean
07ff15f6c03ab8e7ee1a1b77d6f2898bc846565283f65a83ca1bf04790a167ce  finite_next/symmetry/D1Bound5/SmallTripleOrbitProperties.lean
48c636c065940c264bf5d45a57d236f9488ed0396e76184df898bebb518e4568  finite_next/symmetry/D1Bound5/SmallTripleBoundedExtensions.lean
```

## Subsequent independent mathematical reviews, 2026-10-18

This is a read-only mathematical/source review, with local drafts only and no compiler run by this reviewer. Coordinator build evidence is separate. The hashes below identify current local inspected source checkpoints, not acceptance claims.

The corrected CoherentThreeSimultaneous source now includes the previously missing -(p+q) term. Its actual four-root polynomial subtraction and the CoherentThreeNonvanishing wrapper were read completely and approved mathematically. The coefficient consequences w²=e4,2vw=-e3,v²+2zw-1=e2 give exactly pq+1=(e2+1-e3²/(4e4))²/(4e4). Only distinct anchors and nonzero e4 are divided out, never a square root. The norm estimate is121BST/(4A³); P²≥32BST/A³, A≥1 and ordering contradict it. The wrapper uses shared actual coherent root choices, so overlapping L3 forms are genuinely the same forms.

The complete EisensteinPellDescent and EisensteinExceptionalPair sources were read. Coordinates give M²-3D²=1 and the two exact integral mutations have norm sums7M∓12D. For M>2 one sign decreases M; the M≤2 kernel base contains all81 coordinate possibilities. Reversing either mutation preserves the balanced-root conclusion, which gives the actual trace-zero extension classification for the exceptional pair(-omega,1-omega). Zero roots remain allowed. This reviewer's EisensteinImaginaryExtensions then excludes three pairwise compatible nonzero trace-zero entries: products are1-3xy, a negative square would contradict its residue modulo3, and three pairwise opposite coordinate signs cannot occur. EisensteinExceptionalBound erases exactly the two anchors and proves cardinal≤4, with an explicit ring-equivalence transport. These two supplied modules were independently approved mathematically by other agents.

BennettTwoBetaBound was read completely: b1=27/64 and the Gamma successor ratio are exact; the positive denominator minus numerator is(432k²+1110k+273)/32, giving monotonicity and the strict normalized1/2 bound. This reviewer supplied BennettChooseGamma, independently read and approved by the Bennett worker. Its finite choose-factor splitting, half-Pochhammer products and Gamma(1/2)²=pi give the actual absolute choose/Gamma identity with no missing sign or factor.

All five BennettResidualMajorant, BennettResidualEvaluation, BennettResiduesAtInfinity, BennettRepeatedHsymm, and BennettResidualBound sources were read completely. The reflection argument uses degree d+t, selecting coefficient t+1, and correctly proves inverse coefficient H_t equals the top monomial-remainder coefficient. The proper partial fractions are constructed; denominator-divisible polynomial parts have zero actual local residues. The reciprocal is the complete homogeneous generating series on exactly sum(e_i+1) repeated nodes, including zero nodes. The analytic evaluation uses the principal complex binomial series inside its actual unit disk and an absolutely summable polynomial Cauchy product. Pole degree card(I)*k+1 gives residual start card(I)*k. The hsymm count choose(n+t,t) cancels exactly against choose_smul_choose, giving exponent n-s, hence2k-1/2. The final actual P-matrix residual theorem includes the exact Gamma factor. No residual envelope, partial-fraction decomposition, convergence, or determinant assertion is assumed as an unexplained premise. Final cleared-scale normalization and later height assembly are separate obligations.

All three FrontierLarge modules were read, along with the actual imported full-ring root-matrix existence and even-dimensional determinant lower bound. The six cofactor permutations are correct. The bilinear upper coefficient is exactly88139/270000; an independent rational calculation gives margin24811/1250 at T=54 in1/4+cT²<T²/3. The actual factor2 quadruple growth gives T>18S andT>54. Arithmetic and analytic bounds use the same signed integral root matrix. Thus the new actual quadruple factor3 endpoint has no hidden nonzero-determinant, nonzero-square-root, strict-order, or additional-gap premise.

All three direct-four modules were read. The24 Vandermonde monomials are bounded byBS²T³. The degree-four coefficient and tail bounds give ell≈0.038499,u≈0.0396263. Exact rational checks independently verify100u/99<49/1200,10<100/(201u),100/(199ell)<17. Reusing the three-form scalar helper with V'=VP,F'=PF correctly produces powers P^4 in the upper bound andP^3 in the zero window. The final actual coherent-form theorem derives its AP/PQ conditions from A≥1,T≤P,P≥1000,Q≥1000P, yielding constants13 and49/50. Its zero-window implication remains conditional on the actual form vanishing; it does not silently assert nonvanishing or full-ring integrality.

CoherentRetainedIntegral and RetainedGapScalar were read completely. The strong L2 bound on(b,s;t,c), together with factor2/factor3 growth and A≥3, gives C>18/h0 ABST²>15ABST² and excludes the actual H48 zero window. The coherent integral lower bound uses the same root choices and exact mapped Vandermonde. The scalar first-term coefficient51051/400000 is exact; alpha=(200/19)(1/Q-mu/(A²B²))>1 follows at Q≤8 andA²B²≥81. The terminal-root conversion uses Y²>10000, henceTC>Y²-1>(9999/10000)Y². Final scaling is exactlyA²T^5/S². The H32 table correction reported by the author is U=179/10, not18; H48 remainsU=15.

FastSquareTest, SmallPairGraphCheck, and SmallPairLargeDiscriminant were read completely. The finite residue mask is only a necessary filter and never substitutes for exact root checking. Its completeness includes zero roots. Actual graph exclusion retains all three square edges, distinctness, and complete bounded closure. For discriminant>32 all norm≤8 elements are rational; the coordinate negative-square criteria eliminate nondegenerate small pairs. The three lightweight pair-classification sources and generic graph symmetry/full-ring endpoint were also read: all16 normalized coordinate orders are checked before maximality excludes(0,3),(0,4),(0,7),(0,8),(1,7). The eleven surviving models have48 representative orbits. Symmetry applies simultaneous negation/conjugation to every triangle edge and norm; the final annulus is exactly3≤modulus≤10^550, equivalently9≤integer norm≤10^1100. This review did not reread the35MB numeral certificates or exhaustively read the repetitive48 representative and orbit dispatch wrappers; their actual kernel acceptance is still required.

Current inspected-source hashes:

```text
8f7681a89348b43ff73a4abed83ed61946119968c143c095e8af5fa15741841b  analytic_next/CoherentThreeSimultaneous.lean
e9cf20b72662d31310c0b2b949607b08e0ecba96d5b5fbef8bf1950d2dd25848  analytic_next/CoherentThreeNonvanishing.lean
f71bacba2ddd33835a5db603073a6061ce1e7c522a17a1fc6d8f8d202e745c32  eisenstein_next/EisensteinPellDescent.lean
52c8dba49f5e41a0a42204b4560e020ba6c05facbd97830f86f4fc0348522e6c  eisenstein_next/EisensteinExceptionalPair.lean
f5613860237080423cef0fc0ca80e7ec94337d23d38631bc8f873a4713120fec  unit_pair_next/EisensteinImaginaryExtensions.lean
4dec4a579864b576f644183713b7dee5ddcef25eb8394ba3c5af324423249700  unit_pair_next/EisensteinExceptionalBound.lean
6be0ec4b4373f2704cbfdc6beb52a3796d8063f1c67fa2c91242af5752323182  bennett_next/BennettTwoBetaBound.lean
d9bcba0050f96c2e5358883423228bb6c2cb33d7ddbc636ef04e0b742d0152a4  bennett_integrality/BennettChooseGamma.lean
621bf3350b583bf323a08abac3edc3459f36cec3092a6486cd8040d14d1acbc9  bennett_next/BennettResidualMajorant.lean
56974b83f6461ac2258288263f7719d676b88107cfcfdd594bc2f4ae53fb6328  bennett_next/BennettResidualEvaluation.lean
ffee844ddcc512f46ac459e558a24bcd0f711cd6e3a6d9884e8c9565460a90d6  allorder_next/BennettResiduesAtInfinity.lean
2c35125785b6ff0c9b69a4236b7a718a4b75a5a68706b7a3ada2c46efaddc905  allorder_next/BennettRepeatedHsymm.lean
3c29d54435c8f56bfeb7e3f81fe455543ad575b44d5a72d4fcaf4ba39ae4767d  bennett_next/BennettResidualBound.lean
3bfaed4faa374b1d36b137317feb47820b7b87a27f3f315b69ca22986aa27c5d  frontier_next/FrontierLargeCofactors.lean
32e213f2ee302cb081feb7f93b14dce00d736ed88c5de49cdb8c44ba8926354b  frontier_next/FrontierLargeNumeric.lean
032f5dcfa7f2d1e4c769199c1e52d56b49ba79beea9494a575c1801419e80604  frontier_next/FrontierLargeTuple.lean
2556333e1780dc7b3414824cb7258d6a7838cd035277186bdc20da9032636237  analytic_next/CoherentVandermondeFourNorm.lean
2bc555f91b3621a49713ff18705737b443a8d9d3a111a69e7cf3b5d7566fe8d2  analytic_next/CoherentFourParameters.lean
50df4500b50826d0ec35acdc6de9c30a5afcce358a9e44b196a49e0ab65ed549  analytic_next/CoherentDirectFour.lean
48518b26144c01366297f251d7487446287ba2b04e8dba97c17fa9f163225e9d  analytic_next/CoherentRetainedIntegral.lean
1c30dbd3d60010fcdfcb01cdd1ce2698a9b3dc9f5e04be150f2736cbfcb8b624  no_small_next/RetainedGapScalar.lean
036007c7cf24f9c04b6faeae72a9651f4860411946ffe8689f07673305457949  finite_next/two_small/D1Bound5/FastSquareTest.lean
a1fd39ac1e63a1a407d5fbedb3ad3d7599b1489a8857fc7d2c2d3c2c9b4396e6  finite_next/two_small/D1Bound5/SmallPairGraphCheck.lean
c69437fd6732a6665be073a5675405812d333a1b31dbbd565010be6a462d9850  finite_next/two_small/D1Bound5/SmallPairLargeDiscriminant.lean
13b30ee79d1344410e8883c71036e3d9b17e9072cb676e51f16a84aa1a8cfd5a  finite_next/two_small/classification/D1Bound5/SmallPairClassificationCheck.lean
0479960d253f413b6231376d75e08d6895df49dd0720f2623e327fcef62f8410  finite_next/two_small/classification/D1Bound5/SmallPairClassificationData.lean
a32a3e7b2d5dfed4754fd2fe6af26c9e86156fe171110d66d6c2f3d17661c981  finite_next/two_small/classification/D1Bound5/SmallPairClassification.lean
fe95f828c789959447eda784c0aa5f4516dacd522e3da889399545aa071a7bef  finite_next/two_small/symmetry/D1Bound5/SmallPairGraphSymmetry.lean
2d3b593f3dbcd94a91f8cff878c1a07d2b27fd0bfa8ae05c2a4318a604fc5399  finite_next/two_small/symmetry/D1Bound5/SmallPairBoundedExtensions.lean
```

## Actual unit-pair axes and Pell classification drafts

The reviewer has now supplied three constructive drafts, rather than leaving the unit-pair classification as a dependency map. UnitPairAxes extracts a primitive integral direction using the actual integer gcd Bezout identity; orthogonality gives the integral perpendicular vector. The sum of direction squares divides8 and is at most8, so the25 bounded coordinate cases leave only axes or diagonals. The coordinate wrapper works for every positive-discriminant order and its full-ring wrapper permits every imaginary quadratic field, every embedding and zero roots.

UnitPairPellClassification derives the exact norm2 real alternatives and norm1 imaginary alternative with a nonzero signed integer v. In the half-integral basis, each actual unit-pair root is proved to have even second coordinate: a real square makes the root either real or trace-zero, while a trace-zero extension forces evenness modulo2. Both roots then lift through sqrt(-d)=2omega-1. FullRingUnitPairPell combines this with actual maximality/squarefree results to construct one fixed positive squarefree d and integral w with w²=-d, and classifies every nonzero common extension in that fixed model. These are uncompiled draft statements, with independent mathematical review requested; they do not yet constitute the full unit-pair exclusion or the finite norm2 Pell certificate.

```text
3ba4038cce65db782e4bb249d4c2afe29097cd6876f3cd9a63d02c5404b12a6c  unit_pair_next/UnitPairAxes.lean
ed563d0e0ef72594c7e02ac4b7f74ecee2b8f06a15744f42426fbaf31c5404db  unit_pair_next/UnitPairPellClassification.lean
acf5fd1a1e92192060d5a61d38f1baec77bc13af3dbc3770ebd76174375951b8  unit_pair_next/FullRingUnitPairPell.lean
```

## Completed small-frontier and actual retained-growth review

All eight small-frontier files through FrontierNormRows were read completely. The root-error choice c=7/8 works at product modulus5; its coefficient32/225 is strictly below1/7. Cubic products have error at mostK-1/8, and the actual signed cofactor cancellation gives3K-1/4. Every cubic term contains a later edge, soK=k²l is legitimate. The quartic determinant bound is9k²l². Normalization by(ABC)² gives exactly the displayedP andJ. Independent exact-rational evaluation confirms that all five quadratic endpoint values are negative at both2/3 and the listed target. The true tuple tail bound2BC<D andA<3 give the necessary tau>2/3. The arithmetic lower and analytic upper use the same signed integral matrix. All final normrow assumptions are explicit and faithful.

CoherentRetainedAnalyticData, CoherentRetainedGap, and CoherentRetainedTuple were read completely. Distinct anchors make the normalized Vandermonde ratio positive; triangle inequalities give at most8. The actual terminal root satisfies(3999/4000)PC<W²≤PC+1. Raising the proved factor3 frontier to its fifth power gives3^5 A^7B^5S^3, and the exact rational retained coefficient exceeds400. The final actual IsD1Tuple.all_large_retained_growth theorem assumes only the full-ring ordered quintuple and first modulus at least3. No analytic or chosen-root premise remains. Compilation remains the coordinator's responsibility.

```text
fdb5110fd7c01a02f52f2b7aca40f48eff76285798bc764522ee4ed8858163e4  frontier_next/FrontierTableNumeric.lean
c0df373cd2018435455136a8791088ec477d6596e984e25caf9b5371841d3929  frontier_next/FrontierRootBounds.lean
8b0b4e502bb0feb79ed7c1e76ce6284a21b166f5b473df451378ff6e7d9d01d8  frontier_next/FrontierMixedCofactors.lean
90fcd008ba5150c5f1159858f95da5d5b64d116b047933622f1fe12554a6d284  frontier_next/FrontierCubicErrors.lean
d976a1aa3c8dbe50a13733e9995f206dc40e2ae91de018df31e361e837d06327  frontier_next/FrontierTableTuple.lean
6b39c4e24d2a3e18baf2c32d46ac457d49a62143a7d03aafbd81b809d9622683  frontier_next/FrontierScalarReduction.lean
ac2181984cc485611948ed65e1efa5572ea24edac09ef71b42dcdc907c5da46b  frontier_next/FrontierNormRows.lean
e76549c7be2114c73c541263aabd0333cbb141f20d68a185e84bf3bc5a6d8efa  frontier_next/FrontierMixedDeterminant.lean
68b564f4d3cda563295f61b0e00ba461345960f986e54002d190c0895b8f793e  analytic_next/CoherentRetainedAnalyticData.lean
06ea4ca4102dda5980c98290800a41a77378b238825b3c79cbd879a25e8dce63  analytic_next/CoherentRetainedGap.lean
37b51857e6ce92762b8c8b5a74cbdf2fd67aa50c89bea8a0c460d3f6d5c254e5  analytic_next/CoherentRetainedTuple.lean
```

## Retained-start completion and first-pair finite review

CoherentRetainedBasicGap, CoherentRetainedFourSizes, CoherentRetainedStart and RetainedFourScalar were read completely and approved mathematically. The actual two overlapping five-entry subtuples give both fifth-power gaps. They imply C>16BST and D>17ABST*C³, excluding the actual direct-four zero window. The integral four-anchor form and its upper bound give the first summand<1/100 and hence Z>(99/98)Y with Y=AC⁴/(ST²). SinceY≥C>1000, ((99/98)²-1)Y²>1, so the root-square upper bound givesCD>Y². The seventh-power conclusion is therefore exactlyD>A²C⁷/(S²T⁴). The final actual sextuple theorem internally supplies all coherent roots, nonvanishing, integrality and size assumptions, retaining only full-ring tuple/order/A≥3.

OneSmallFiniteCheck and FirstPairClassification were read completely and approved mathematically. The integral trace bound15 at product norm≤63 givesN(q)²≤79, henceN(q)≤8. The fourth-entry root bound300 is a safe upper bound. Exact candidate reconstruction and covering hypotheses supply completeness. For discriminant>32 the small anchor and first-pair root are rational, which forcesa=±1 andq²=4, hence only simultaneous±(1,3). No claim that the larger anchor itself lies in the norm-eight disk is made. The complete FirstPairData and56 concrete certificates were not read in this review.

The reviewer additionally supplied UnitPairPellBounds: the two Pell alternatives rule out d=1 by square congruences/factorization, and imply modulus≥d+1. Its full-ring wrapper uses the same fixed squarefree d for all common extensions. This last module is an uncompiled new proof draft, not an independently reviewed accepted dependency.

```text
0093e0f5fa46fd09a75986f336c92e22e37c52d067b1d8aefcf37b795ec169c3  analytic_next/CoherentRetainedBasicGap.lean
f882bd4a0a69601412377b810cf2c65dfd4dc2c6d90a13a2431ad0da2123b8a9  analytic_next/CoherentRetainedFourSizes.lean
7e6d28194165a53998bf3b0fa37f33fcbec0dec6eb1dd0b27bdd51bbd7a73688  analytic_next/CoherentRetainedStart.lean
8dfd6178bcbebe1a47b8dbdf8b25d99c86e04aee70f86e9aa8ed8a0a95e0bdee  no_small_next/RetainedFourScalar.lean
071c08b2bdc31b423cf7fceaeeb7fd97f8c1844d2c362578eed3d43c62423b55  finite_next/one_small/D1Bound5/OneSmallFiniteCheck.lean
90daa88e381b4d150998bc5bf92ac5df72217d00450a73da5a8fa4de9c5175de  finite_next/one_small/D1Bound5/FirstPairClassification.lean
42c9a42a32086860e85fa53387bb228cf19fda8e61777a6a8b2b594944963936  unit_pair_next/UnitPairPellBounds.lean
```

Proof-only checkpoint update: UnitPairPellBounds uses `simp only` after the complex-of-real cast in its integer norm helper, with no statement/import change. Final local SHA256: `1178dc6a1d489f674cee08cf292f50fddb6f3feea7fb0740aede10bca22fc23b`.

## Unit cubic, fixed-model arithmetic, and actual Bennett root transfer

The three UnitPairCubic modules were read completely. The actual integral signs are retained throughout the second-order cancellation. With C>=9 and C<=D, the perturbation ratio is at most9/40<15/64. The exact identity 2zL=-((u-z)^2+(v-z)^2), integral nonvanishing, and the product-root lower bound imply C^3<2D. Nonvanishing uses precisely d_entry != -c_entry. In the genuine sextuple wrapper all three opposite exclusions follow from the previously proved symmetric-five obstruction; three iterations yield D>S^27/8192. No assumed analytic remainder, sign convention, or artificial tuple enlargement appears.

The complete UnitPairPellParity, UnitPairArithmeticModel and UnitPairRealReduction sources were reviewed. One model fixes the same positive squarefree d for Pell descriptions, conjugation, and negative-integer-square classification, including the half-integral basis. Same-axis imaginary compatibility would give d|1. Mixed compatibility and conjugation supply the six actual square witnesses for the symmetric obstruction. Consequently every one of four extensions is real. A norm-two solution forces d=7 mod8 or d=2 mod4; even d gives magnitudes3 mod4 and excludes three real extensions by a same-sign pair. The final full-ring unit-pair sextuple endpoint therefore supplies one common squarefree d=7 mod8 with all four signed norm-two descriptions. It has no hidden ordering or modulus hypothesis and no omitted zero-square-root case.

BennettRootApproximation, BennettTwoHeightBounds, BennettWeightedHeight and BennettRootTransfer were read completely. The exact ratio-square error is theta^2(c-a)/(a z^2). Signs are selected once among existing integral root products before selecting a determinant row. The node order (0,b,a) correctly pairs column1/a with theta_a and column2/b with theta_b. Stronger42 coefficient bounds and monotonicity of A^(2k-1) give the constant3 after the uniform3/2 root errors. The terminal root is proved nonzero: otherwise norm(c)norm(d)=1 contradicts C>4B>=4. The final full-ring all-positive-orders inequality has only actual square, nonzero-anchor, distinct-anchor, and explicit size hypotheses. This review checks those four files and their joins; it is not a fresh independent reread of every upstream local coefficient proof.

The article agent independently reviewed UnitPairAxes, UnitPairPellClassification and FullRingUnitPairPell and reported mathematical/interface PASS, recorded separately in finite_next/one_small/UNIT_PAIR_REVIEW.md.

## Norm-two Pell completeness implementation

The reviewer supplied PellConvergentCompleteness and PellCFPrefixCheck as new local drafts. The first proves positive coprime integral convergent pairs, monotone numerators, the actual strict norm-two Legendre approximation, and finite-prefix completeness from a stopping numerator. The second implements the standard integer (m,Q,a,p_prev,p,q_prev,q) recurrence, checks the exact floor intervals and denominator transition identities, identifies the computed trace with the real continued fractions, and proves membership in the actual filtered output list. Its final absolute-value theorem takes u^2-dv^2=2, v!=0 and u^2-1<=X^2, covering both root signs. No arbitrary solution list or completeness assumption is supplied. The article agent independently approved the first core's mathematics; the executable bridge is awaiting independent review and coordinator compilation. These are proof drafts, not build acceptance claims. Only the coordinator runs Lean or writes the remote project.

Inspected or newly authored local source hashes at this checkpoint:

```text
c4d7919a92d82cd87a0dcb74850c68bc85f7a8e1833cf277658e5ce2a0af5966  unit_cubic_next/UnitPairCubic.lean
a34fce4fbc0641e3fd4321f40ebb3bba4fb6d40eab6d0dad17f09e677f1ee8f7  unit_cubic_next/UnitPairCubicIteration.lean
8c7ff651911ee31cb8b29e22e5594dd428c04a7b2295263089a9dfbaf6358898  unit_cubic_next/UnitPairCubicNumeric.lean
7e9aec028480b50c2cb220094e0e90211007d0ea28f519db94089e93d0ea1c55  unit_reduction_next/UnitPairArithmeticModel.lean
4424f8e2a140558f7a39359f2e6344e2dc4d7030605afacb58d6d657808d2181  unit_reduction_next/UnitPairFieldBound.lean
c3ddfaf5f52b6eb5e200c691ed8fef73987c7bcf94ceaba681f82626823199bf  unit_reduction_next/UnitPairPellParity.lean
cd94773a437964063bac7ab2166363cc91e6f7def1cf54462389c1582fed23d0  unit_reduction_next/UnitPairRealReduction.lean
c859a7ac4551e632ed52309e168fbb30a02664778979c67d38b93ad6478c49f6  bennett_next/BennettRootApproximation.lean
b12e65ec6d401c7fabddc06adb035752cfece5be9507e9709df180f92d429f81  bennett_next/BennettTwoHeightBounds.lean
d361a8b36c0f6d3f5dcdf5c44f16f404acfb39e902b48a07dac16ede5bacabd4  allorder_next/BennettWeightedHeight.lean
5c64458c0ea917a7540bf4cc89a1d4131c4ce0e298dff2ba0472b4c9b702ba5a  bennett_next/BennettRootTransfer.lean
f6e34479707c3fc69b0f9830fd82f97a10ee38c66fb5e75c971c541a3caf473c  pell_next/PellCFPrefixCheck.lean
79019559493a6ae1d20a8478158487032b4e0a0607df14c04c70a679ae582293  pell_next/PellConvergentCompleteness.lean
```

## Concrete ordinary intervals, all-large assembly, and finite joins

This update records local source and mathematical review only. This agent has not compiled Lean, written to the remote project, or changed the remote git index. Coordinator compilation and final accepted hashes remain separate gates.

The actual N3/N3bs chain is complete locally through FiniteN3Interval: original determinant 3675*x²*y²*(x-y)^11, divided determinant 3675*x*y*(x-y)^11; exact row factors 4*(x-y,x,y); coefficient bound 4143; residual 35/32; fixed original integral root signs chosen before row selection; entire closed window follows from the actual full-ring lower bound. Independent allorder_det review of all eight modules found no mathematical gap. The shared finite root error101/100 is derived under AC≥1000 and C≥200Y. No coefficient/residual/nonvanishing hypothesis is left in the actual tuple endpoint.

OrdinaryClosedIntervals derives every positive-order O_k closed exclusion directly from the actual Bennett matrix theorem and the proved quadratic rate comparison. Its tail uses exact H² and R² recurrences, one order5/6 overlap, and unbounded positive geometric lower endpoints. AllLargeWindows and AllLargeWindowOverlaps supply the exact fifteen endpoint comparisons, both P maximum terms, both S vs B²/B³ detours, the actual retained start comparison, and the ordinary rate comparison. Independent analytic_bridge full-source mathematical review passed all three modules.

AllLargeForcedPWindow is an unconditional actual full-ring ordered-sextuple theorem: from A≥3 it forces D inside the explicit P closed window. Every other finite family, all-order ordinary tail, retained start, and overlap is obtained internally. It deliberately does not assert False while the P construction remains unfinished. This records a substantive remaining dependency, not a conditional approximation hypothesis.

The two-small finite/analytic joins now include actual TwoSmallNondegenerateImpossible and UnitPairImpossible. The latter uses the same fixed arithmetic model for all Pell and negative-square tests via PellUnitPairBounded, and derives S≥8 rather than assuming the two-small analytic size range. These are local proof drafts; the1016 kernel finite certificates and all analytic dependencies still require coordinator acceptance.

Independent reviews completed in this interval: (1) PellConvergentCompleteness and PellCFPrefixCheck were independently read by article_audit and passed mathematically; (2) PellMatchingCheck and PellFiniteCertificate were read here, with exact finite-prefix/list equality, both signs, integral cutoff rounding, and same-d full-ring square testing checked; (3) current CoherentRetainedMixedSizes/Forms/Gap/Tuple plus RetainedMixedScalar passed here, with exact H32 upper179/10 and all actual size conditions derived; (4) FiniteMResidualPoint/FiniteMResidual passed here: choose(5/2,8)=45/32768, η exponent11/2, scale45/2048, four rowfactor geometries, and final45.45<3920/81 are correct without a separation lower-bound assumption.

### Local checkpoint hashes (uncompiled by this reviewer)

| Source | SHA256 |
|---|---|
| `finite_n3_next/FiniteN3Approximation.lean` | `f26246975c80b5760d0ea539ec2ff5e63beb9cc0b41dec677d2fb5d75f1a43f5` |
| `finite_n3_next/FiniteN3BennettIdentity.lean` | `858b3c523e62d5285ef332fddf0ac0e69ebabf7caf3d59e87199de622f020376` |
| `finite_n3_next/FiniteN3Height.lean` | `c8ebdf891f885f26b8f67749946ed648b69c95b11df4e7fc221e2e9d670c22c1` |
| `finite_n3_next/FiniteN3IntegralRows.lean` | `ca1fd139cebeff18245edb3bb4b8be21a0d83ac77a401b702c780a3f8c44eeb6` |
| `finite_n3_next/FiniteN3Interval.lean` | `bd19cb0f15e25ca5629c0b6fe3d5ab9e1b98c2c5cc92c021b9f5983870ce8973` |
| `finite_n3_next/FiniteN3Matrix.lean` | `9b5cf6f1b34a2d14f582faaafec43fb3607631a0d4aabe09544ccdd317c95e9c` |
| `finite_n3_next/FiniteN3Residual.lean` | `23494638bf4a924ae358f2fb61f7d123cf137805d570f3bc5df00f36fe4ff9ea` |
| `finite_n3_next/FiniteRootApproximation.lean` | `3eb0625b1bc5b24d5bf964a4f1ffefb0c9955b498e80c90017d816a9b67d0609` |
| `all_large_next/AllLargeForcedPWindow.lean` | `19a8f4caf033fea13c4ebacb2633db2dc01042c9ea4bcd19dfff3901c0e4455e` |
| `all_large_next/AllLargeWindowOverlaps.lean` | `57c699424d8911980b24555e7b7909b46435d5964df9f5c4cf44e0c99372ea4e` |
| `all_large_next/AllLargeWindows.lean` | `8a55028f795f579ca9d48bce231b9a089c1b85f46e7e028019c12a2849cb716c` |
| `all_large_next/OrdinaryClosedIntervals.lean` | `66fbae1f3710f16cb1c21ef85799e3508c94cf3f73bd2d1350244b0228bfb5fa` |
| `main_next/TwoSmallFiniteReduction.lean` | `49a026200d9b2c23a30bb80a59675b6751738a7268ea49a62b0a044817a0b925` |
| `main_next/TwoSmallNondegenerateImpossible.lean` | `cd2e46669d5180d170708c2c6e146711677502487bd331463fa9c364e4d7b7bb` |
| `unit_reduction_next/UnitPairFiniteReduction.lean` | `4c985f3362a3ffa72266af357f8b21e31a3eb40f6bdc85b15d6a449bfa269acc` |
| `unit_reduction_next/UnitPairImpossible.lean` | `4c2c87182eaafedb4e09a0e7ed0a5df2fe634a496242cdfdf9316b2aefde68ea` |

## S≥15 first-pair completion: source review, no build

The parameterized CommonIntervalWindows/CommonIntervalOverlaps keep all fifteen adjacent/start comparisons and the ordinary-tail rate from the reviewed all-large computation. They expose numerical M/R constants, the retained coefficient K0, and a separate coupled rho*Rbs growth estimate. The latter correctly cancels the actual relabeled N3 residual coefficient; no determinant or analytic family estimate is presumed. FirstPairGeometryNumeric lifts the exact 41 rational certificates to real B,S with B²=b0 and S≥15.

I independently read FirstPairRetainedScalar and FirstPairRetainedPacket in full. Their mathematical argument is sound: R²*Phi≤F0 and H/R²≤KR*tau⁵ bound the actual relabeled residual jointly with the Vandermonde; A≥1 safely weakens the subtractive term and the frontier factor. Positivity of the actual Vandermonde follows from distinct anchors. Equal moduli are allowed throughout. The norm-only packet remains meaningful for the rational pair in every field.

FirstPairFifteenExclusion assembles actual fixed-pair coefficient intervals, actual Φ-dependent N3bs, adaptive P, Q/M, and the infinite ordinary tail. The endpoint has no approximation/exclusion premise: it retains an actual coordinate equivalence plus certified geometry/fixed-row memberships and matching normalized first pair. FirstPairGeometryNormalization and FirstPairThirdBound select these records from the complete nonrational table, including all allowed models and the empty discriminant31 table. The universal rational pair still requires a separate direct coefficient transfer; these theorems do not assert a Gaussian equivalence for it.

All files below are local draft snapshots. No compiler was run by this reviewer; kernel acceptance remains the coordinator's responsibility.

- `all_large_next/AllLargeImpossible.lean`: `33a0330c203e78ef360d3145b58a19fb19c43490eaed1fa7a331623489af59e0`
- `first_pair_next/CommonIntervalWindows.lean`: `434c1e003ab0ffd56d20c6075fbb7f8dbbe8ae4b2f40e32cd0f38970b22689e3`
- `first_pair_next/CommonIntervalOverlaps.lean`: `c45c61962abed7d79189cb8409644f76167e0f5520b7d2c8bc90589c5ab70df4`
- `first_pair_next/FirstPairGeometry.lean`: `e8d37964df579279bdd431575456b3f9d48de5c38ce6a56167231e7e39156a30`
- `first_pair_next/FirstPairGeometryNumeric.lean`: `e0ddcd03c4074da67d6df075317e17d1e246f945c184c318198897f2f01d2027`
- `first_pair_next/FirstPairFixedTransfer.lean`: `3b06fac7620b627228e15cb25d13c7c21bdc235f1c625e2d9c059cf6da0c14f0`
- `first_pair_next/FirstPairRelabeledN3.lean`: `39e5467e6554e09d549cb1fdde5d7daabc449d55fff307f5135a00d77433b3b0`
- `first_pair_next/FirstPairFifteenExclusion.lean`: `0a6fd1fd9445dcb8449452fc619cd502c094b652096c015b729aefd071f0f911`
- `first_pair_next/FirstPairGeometryNormalization.lean`: `4206f2286176a320ba746fdabac586933eb6bfa3544f68d18a249e57d6927f1f`
- `first_pair_next/FirstPairThirdBound.lean`: `ac5acf1fb69d556385bebb8a811fad4d6d36eaeb24490aab616fd33039b92b90`
- `first_pair_next/FirstPairRetainedScalar.lean`: `4477dbae688720ee8eed6c081fbdfc30a6a337f99e5765c7da7a2289da3494f8`
- `first_pair_next/FirstPairRetainedPacket.lean`: `2c5b331b08cd71f9b2cba3dfbfabb85664eaafafc19ebe6e253e7b983c530963`

## Complete reduced one-small branch and five-region audit

The new actual reduced branch endpoint `IsD1Tuple.one_small_reduced_impossible` assumes only the genuine ordered full-ring sextuple and exactly the first-pair remainder N(a)=1,9≤N(b)<64 or N(a)=2,9≤N(b)<16. It invokes the complete S<15 classification, the56 nonrational finite complements, and the universal signed rational triple. RationalFirstPairThirdBound uses direct signed-integer coefficient interval theorems; it never postulates a Gaussian field equivalence. RationalFirstTriple uses the original same-field positivity/rationality/cardinality theorem to derive the signed third entry8.

Independent review of article agent's OneSmallNormalizedImpossible passes mathematically: its exceptional normalized(1,−3,3) branch explicitly uses the negative-extension cardinal≤4 theorem after a simultaneous sign transform; the56 remaining rows use the same normalization for analytic cutoff and exact finite extension comparison. Distinctness, equal moduli and zero square roots are preserved.

Independent full read of FiveRegionParameters, FiveRegionRetainedScalar, FiveRegionTupleGap and FiveRegionOverlapBounds passes mathematically. The retained H/R² estimate correctly keeps the frontierA⁵ contribution, yielding A⁷; e≤μ/m² and R≤Q have the correct directions. The phase residual stays coupled. All16 rational corner inequalities match the shared window formulas. Exact Python replay returned minima570459974677/452508298800,2033690778168/872947946441,22754585143197/19514262322244,1624655176704/297600105431,56873382265625/43026630577152, each strictly above1. These diagnostics are not substitutes for Lean/kernel acceptance.

The crossblock agent independently read CommonIntervalWindows/CommonIntervalOverlaps/FirstPairGeometryNumeric and reported mathematical PASS, including both P maxima and relabeled residual cancellation. No reviewer compilation was performed. Current source hashes:

- `first_pair_next/FirstPairGeometryNormalization.lean`: `4206f2286176a320ba746fdabac586933eb6bfa3544f68d18a249e57d6927f1f`
- `first_pair_next/FirstPairThirdBound.lean`: `ac5acf1fb69d556385bebb8a811fad4d6d36eaeb24490aab616fd33039b92b90`
- `first_pair_next/RationalFirstPairThirdBound.lean`: `4efa89711beaca5f38cf3d119f2655caf24d86a83c3f50a4775b15cfd5a1660f`
- `first_pair_next/OneSmallThirdBound.lean`: `414fed639d00630abc873843fed95b1f814f949717e489e36ec998d99d698a12`
- `first_pair_next/RationalFirstTriple.lean`: `1203dfea880fe8b3eb2782e65c9cd100171afb6d04708f178d1a5792ff549234`
- `first_pair_next/OneSmallReducedImpossible.lean`: `eb14aff0b9ac6bdd8104694a4445f6257a639e3dd6f21e90f35760e3e104c960`
- `one_small_final_next/OneSmallNormalizedImpossible.lean`: `ec0d24000fd3914a62dd4954db77c423a7cfd120a688d6cb997d165bd8d5f5fe`
- `five_regions_next/FiveRegionParameters.lean`: `65f7e325f2151e0f2af30e37640b01bd0b8c1d0b0a3d676c5c3e8a30c2fc0365`
- `five_regions_next/FiveRegionRetainedScalar.lean`: `b9b807f214521a3f6c7bd8a4fd60d12e295e7783b996d3049c3d149e52520331`
- `five_regions_next/FiveRegionTupleGap.lean`: `3d15a84b22295ab439f5bb30313a6c1a83680688a165eaacff09e4f7730afc0a`
- `five_regions_next/FiveRegionOverlapBounds.lean`: `bd8eb73e34bf3eb631670856a2e4ffcc80e4e92205466cc5757dff4dfbb4591e`

## Independent three-small endpoint audit

I read all six three_small_next Lean modules in full. Mathematical PASS: the detailed zero-form alternative derives its own4P separation before applying the separated zero window. With1≤A≤B≤S<3 the quintic coefficient1/400 is a valid weakening of1/(37S²). For three extensions above10^40, all three actual pair alternatives are used; quadratic/quadratic incompatible branches and tenth-power growth are controlled with the stated405 and32000 constants. For the remaining fourth extensionT<85, the actual V window forces a lower bound past10^38C³. The actual Q and M closed windows overlap and cover the interval up toC¹¹/10²², which contains the ordinary upper bound10^60C⁷ forC≥10^40. No extra nonvanishing, bounded-extension, root-choice, or interval premise is present in the final theorem.

RationalCutoffBound and RationalTripleExclusion were also read in full. Their endpoint is universal over the same full ring, with signed1,3,8 entries; actual fourth cutoffN(t)<1024 contradicts actualT>48. No Gaussian equivalence is used. These are source/math reviews only, not build reports.

- `three_small_next/ThreeSmallFixedScalar.lean`: `d59d2ffa2f67d68b2084d696be49c307e1d6ca76bebadcdcb67883e86b4bbd55`
- `three_small_next/ThreeSmallPairAlternative.lean`: `3dc02360d7110c7469529da785f83b480f3aecc6182b6bb58ab6b87d9082a50e`
- `three_small_next/ThreeSmallExclusion.lean`: `0dc7dba5727b9d1694bbd794d4a0876ffc8c3e3b74991534d3bd30a3608db3bd`
- `three_small_next/ThreeAnchorDetailedAlternative.lean`: `f9098a9ab0ec6ecdfc603dc143813b16d99036e382112cff2d94c3cbfd82d84a`
- `three_small_next/ThreeSmallLargeExtensions.lean`: `8da38b77fe00bb084484fc9ed300dfbd5248e790c9e1443754b3a9ffe31ae0f2`
- `three_small_next/ThreeSmallFixedExtension.lean`: `999afea207e83c6eb416ab427e85f6488ee25779104fb0c02d8cf1141d92fd6f`
- `rational_pair_next/RationalCutoffBound.lean`: `010ebd569905b421ed749da17a38345ff30a3f9a1e8f7c0ea74467dc2e941dd5`
- `rational_pair_next/RationalTripleExclusion.lean`: `3b4eed051b98e0913edf7e32a5b70e88b0ca44cd93ed0d346cb059d3464f9839`

## Concrete final theorem and remaining branch assembly audit

Independent read-only source review of the local final MainTheorem and every branch endpoint passes mathematically and at the stated interface level. The explicit theorem is `main_statement : MainStatement.{u}`, for every universe u. Its only foundational assumptions are those in the original Specification: an arbitrary number field K of rational dimension two which is totally complex, its genuine full ring of integers, and the finite nonzero distinct D(1) set. It does not add any analytic, determinant, table-certificate, coordinate-equivalence, nonzero-root, strict-modulus-ordering, or approximation premise.

The three-case equivalence is applied exactly. The all-large and one-small cases are closed by their actual endpoints. In the at-least-two-small case, the third modulus is either below three or at least three. The latter is divided by whether the first pair radicand vanishes. Therefore tied moduli, zero square roots and the complete product-minus-one case are covered. The degenerate endpoint requires no additional smallness assumption. There is no new unproved premise in this final assembly. This is source review, not a claim that the transitive import closure has compiled; the coordinator must still complete compilation, dependency/axiom verification and the required certificate gates before accepting or importing the final theorem into the accepted project root.

The complete FiveRegionImpossible, OneSmallFirstPairReduction and OneSmallImpossible sources were read independently. The actual integer norm split exhausts norms one through eight for the first entry; the five analytic regions leave exactly the norm-one/second-norm-below64 and norm-two/second-norm-below16 alternatives used by OneSmallReducedImpossible. Threshold equalities go into the analytic regions, so none is omitted. The final one-small theorem has only the actual tuple, ordering and A<3≤B hypotheses.

The complete DegeneratePairClassification/Impossible sources were also read. Product minus one forces both positive integral norms to equal one. The coordinate norm identity restricts a nonreal unit to the Gaussian or Eisenstein models. Gaussian nonrational candidates would repeat the anchors and are excluded by injectivity. The Eisenstein orientations and simultaneous negations reduce to the actual trace-zero extension obstruction; the rational orientations reduce to the same-field unit-pair theorem. No imaginary or half-integral case is silently omitted.

The current BennettRootApproximation, RootTransfer, TwoHeightBounds and WeightedHeight sources were independently read. The original integral signs are fixed before row selection; the node order (0,b,a) and anchor-column weights agree. The exact root error is proportional to theta squared times (c-a)/(a z squared); the bound3/2 combines with the weighted height factor2 to give the actual constant3. The positive-order condition k≥1 is retained where the exponent2k−1 is used. Nonzero terminal root follows from the actual size conditions and the unit norm contradiction, not an extra assumed root premise.

Current local source hashes (reviewer performed no compiler run or remote mutation):

- `main_next/MainTheorem.lean`: `0d4652828c5f48475a6e80d8d00fa209e39c0638a58ebd99fd719e271c2670f6`
- `main_next/MainCaseReduction.lean`: `94580cd4f5977bc9f503aba3da8004380cecfe272766c2d856a70706a14c5d2b`
- `all_large_next/AllLargeImpossible.lean`: `33a0330c203e78ef360d3145b58a19fb19c43490eaed1fa7a331623489af59e0`
- `five_regions_next/FiveRegionImpossible.lean`: `3281ee93e5d3410cde913e013f34ab2168918a5c8a4e338ed5b773b2107a415c`
- `five_regions_next/OneSmallFirstPairReduction.lean`: `66e7f810a1c1cdcdb734375865d2b25b872d878392d400f437e819908963776b`
- `five_regions_next/OneSmallImpossible.lean`: `bc74e35dff73f3a31c3a0c7289fa9bc0b4bcfd974356cedbecf1e757ce31954a`
- `three_small_next/ThreeSmallExclusion.lean`: `0dc7dba5727b9d1694bbd794d4a0876ffc8c3e3b74991534d3bd30a3608db3bd`
- `main_next/TwoSmallNondegenerateImpossible.lean`: `cd2e46669d5180d170708c2c6e146711677502487bd331463fa9c364e4d7b7bb`
- `degenerate_pair_next/DegeneratePairClassification.lean`: `f0401b5dab82318c60bc3a185c8a978e00d598be587cc3416656786b904a06f4`
- `degenerate_pair_next/DegeneratePairImpossible.lean`: `449a3a0eb81ab63cbb073585d13a396c6886de6c7e8f6b4565307a657ed38f67`
- `bennett_next/BennettRootApproximation.lean`: `c859a7ac4551e632ed52309e168fbb30a02664778979c67d38b93ad6478c49f6`
- `bennett_next/BennettRootTransfer.lean`: `5c64458c0ea917a7540bf4cc89a1d4131c4ce0e298dff2ba0472b4c9b702ba5a`
- `bennett_next/BennettTwoHeightBounds.lean`: `b12e65ec6d401c7fabddc06adb035752cfece5be9507e9709df180f92d429f81`
- `allorder_next/BennettWeightedHeight.lean`: `d361a8b36c0f6d3f5dcdf5c44f16f404acfb39e902b48a07dac16ede5bacabd4`

## Modular-mask optimization and final integration gates

Independent full read of CoordinateSquareMaskCheck and original FastSquareTest passes mathematically. The two finite List.range(k+1) traversals cover all ZMod representatives including zero. Positivity of k+1 makes signed Euclidean remainders nonnegative before toNat. The real coordinate x²−nu*y², imaginary coordinate 2xy+tau*y², and re*(k+1)+im indexing agree exactly with the original predicate. No primality or nonzero-root hypothesis is added. This is a sound evaluation optimization; acceptance of one pilot is not acceptance of all275 masks.

Read-only live dependency inspection at2026-10-18T01:40:57Z found653 modules in MainTheorem closure, all sources present, with557 not reachable from the107-module accepted root. Of411 queued targets, only CoordinateSquareMaskPilot, CoupledPhaseDerivativePilot, SmallSextupleReduction and EisensteinExceptionalBound were outside the main closure. Adding the main import alone would leave these four plus TwoSmallFiniteReduction outside root reachability. The final integration checklist and exact blocked98-module snapshot are saved in main_next/FINAL_INTEGRATION_CHECKLIST.md and FINAL_INTEGRATION_SNAPSHOT.json. No queue or accepted-file changes were made.

- `finite_fast_next/sieves/CoordinateSquareMaskCheck.lean`: `d2d8bc2ee22d2527d31449ebcfb799b981fd548c07c5db168946e1208c6d24cc`
- `main_next/FINAL_INTEGRATION_CHECKLIST.md`: `0311d26eb082d5d0191f0e31b3330d94dd0d814f8e7e7564191b1326a9bc33f8`
- `main_next/FINAL_INTEGRATION_SNAPSHOT.json`: `8b1d598ad54462b66dfcf7ab63590c12e013fca7b237e71946c4dc54c98ae2f5`

## Proposed two-color graph optimization — preliminary independent audit

A two-color certificate is mathematically sufficient for the exact existing triangle-free target if it checks that every original large vertex belongs to a color class and every distinct same-color pair has nonsquare product-plus-one. Three distinct vertices force two of one color. Disjointness or Nodup of color lists is not required; zero roots remain accepted by the original square relation and cannot be omitted from the same-color test. The reversible closure, filtering and full-ring transport can remain unchanged. This is a proposed optimization; its actual generic Lean proof and all finite checks still require review/compilation.

Independent BFS over all48 previously exactly regenerated diagnostic edge lists found a bipartition in every graph. Row41 has372large vertices,371edges,colors186/186, and34410 same-color unordered pairs. Across all48 there are8063266 same-color unordered pairs;68640 pass the existing25moduli and still require exact rejection. These diagnostic facts are not assumed by the formal proof or substitutes for kernel certificates.

- `audit_next/PAIR_BIPARTITE_REVIEW.json`: `759c1c77d492abac9aa574b34c6d300e1cd4d22216a2153e181b8409ad2aeb17`

## PairBipartiteCheck actual generic source audit

Full source mathematical PASS. An arbitrary Nat bitmask recursively places every input occurrence into one of two lists; unconditional coverage includes short masks, duplicates and empty inputs. The triangular checker tests every distinct same-color value pair, with commutativity covering reversed occurrence order. Three compatible distinct vertices must contain a same-color pair, directly contradicting its false fast-square Boolean. The final adapter proves exactly the existing pairGraphTriangleFreeBool=true proposition. Therefore seed, reversible closure, final filtering, symmetry and full-ring endpoint interfaces need no mathematical change. No correctness premise about a Python coloring, disjointness or Nodup is assumed. Positive discriminant and sieve validity are appropriately unnecessary in this purely Boolean adapter and remain hypotheses of the original downstream square-soundness theorem. Zero square roots are preserved. No concrete source-level API problem was identified; coordinator compilation and every concrete same-color certificate are separate gates.

- `finite_fast_next/graphs/PairBipartiteCheck.lean`: `05602f4ab7e4a764032bd3284db39455209014243d33c3663ef1a3e3ac9a5cf0`

### Isolated graph41 coloring pilot integration

Read the data/left/right/aggregate modules and generator. Independent byte comparison after only renaming the definition confirms the372-entry pilot list equals the original actual large-vertex literal exactly. Independently decoded the Nat mask; both classes have186entries and every previously regenerated diagnostic edge crosses classes. Left and right certificates separately invoke decide+kernel on the actual fast-square predicate; the aggregate uses the proved adapter and returns the original triangle Boolean. No seed, closure, filter, cutoff or full-ring theorem is replaced. This remains an isolated pilot, not yet integrated into the original GraphData41 theorem or accepted by the compiler.

- `finite_fast_next/graphs/PairBipartiteCheck.lean`: `05602f4ab7e4a764032bd3284db39455209014243d33c3663ef1a3e3ac9a5cf0`
- `finite_fast_next/graphs/SmallPairBipartitePilot41.lean`: `313dea2effe73097b17e90a1be42f9262cf9dee6ba0df1908c5fafe5c8d1e842`
- `finite_fast_next/graphs/SmallPairBipartitePilotData41.lean`: `2b372ea69aa4ddf10ba200548e2c8626875c378f5024f82c705abd17039c238b`
- `finite_fast_next/graphs/SmallPairBipartitePilotLeft41.lean`: `900744597a20ab152335bf08c7eb5dcb74523f2306a70a592c64542b16a65e9c`
- `finite_fast_next/graphs/SmallPairBipartitePilotRight41.lean`: `df944df2a37e55e291813777f5a31717847256ba4467cc63548ffe42ecdee537`

## Pell convergence actual compiler repair

Read coordinator log PellConvergentCompleteness-20261018T020429336980Z.log (failed build,63seconds). It reports exactly three proof-elaboration failures: simp did not close IsCoprime(floor x,1); exact_mod_cast did not unfold the local gcd abbreviation; omega treated two unreduced lambda applications as unrelated atoms in the stopping-index contradiction. The authoritative local draft now uses explicit Bezout witnesses, an explicit integer-gcd cast target, and typed numerator monotonicity followed by the actual numerator equality and transitivity. The statement, imports, norm-two Legendre argument and scope are unchanged. All qualification fixes from article_audit are retained. No reviewer compiler or remote mutation was performed; retry acceptance is pending.

- `pell_next/PellConvergentCompleteness.lean`: `c43074daa228222fbe1ca798070304a8be11d05710c382ec9a9e73d7799c8266`

## Pell prefix actual compiler repair

Coordinator reports PellConvergentCompleteness at SHA c43074daa228222fbe1ca798070304a8be11d05710c382ec9a9e73d7799c8266 passed standalone compilation in61seconds. This does not itself claim full-root/axiom/replay acceptance. Read full remote PellCFPrefixCheck source and failure log PellCFPrefixCheck-20261018T021211433912Z.log. The local pre-edit source matched f6e34479707c3fc69b0f9830fd82f97a10ee38c66fb5e75c971c541a3caf473c. Fixed two nested one-line tactic-block scoping errors, exposed the already supplied integer floor-upper-bound hypothesis before omega and casting, and normalized the zeroth real tail before rewriting the n=1 recurrence. No executable definition, certificate predicate, theorem type or import changed. Reviewer performed no compiler run or remote mutation. Retry remains the coordinator gate.

- `pell_next/PellCFPrefixCheck.lean`: `a5468d17d5b8fd8febaae9f486b606a6148827a88a3b76dca5782d036662adba`

## Checkpoint 7 reconciliation: source review, diagnostic reproduction and standalone kernel builds

**MainStatement remains unproved; the accepted root is unchanged.** This checkpoint updates the research evidence only. This reviewer read the three independent JSON reports below before updating this record, then read the current generic cached-residue and indexed-closure source bodies and the pilot integration. This reviewer did not run a compiler, mutate remote files, or rerun the article agent's Python diagnostic scripts.

### Independent source and mathematical evidence

The article agent's cached_residue_review.json records mathematical/source PASS at PairCachedResidues SHA8d30539028d401e948637a33f705cb33707d8ad4e1fe939eafd5ed7c690a9100 and verifies the six pinned QuadraticAlgebra coordinate APIs. My read of the same current body agrees: exact stored signature equality validates both coordinates and every sieve entry in order; small-residue product-plus-one arithmetic equals the original mask Boolean; positive modulus is k+1 with no primality assumption; malformed signature lengths reject; exact full root testing remains for all modular survivors. Exact vertex-list projection prevents a truncated cache from dropping vertices. Duplicate vertices, zero roots and the existing downstream full-ring hypotheses are preserved. The endpoint proves the original independent-class Boolean with no added mathematical premises.

The article agent's indexed_closure41_review.json reviewed the earlier generic PairClosureIndexedWitness SHAcf1974b83acff2e08dabccf8818b3a4f539024362890883b72209680ae904e55, including the pinned List.mem_of_getElem? API. The current compiled version has the distinct SHA396e39b992bc9611aabcfcda13356692e98676409381a756555e84104fe22420; I read this current body independently and confirm mathematical PASS. Some i requires exact in-range list lookup returning the computed candidate. None requires strict norm greater than the bound, so equality at the boundary cannot disappear. Root witnesses and destination pairs are consumed together; unmatched tails reject. Exact witness-vertex projection and both signed mutations are checked, and the final theorem returns the existing pairClosureBool=true through the earlier symbolic root/sign soundness. The different historical/current hashes are intentional and must not be conflated.

The final PairBipartiteCheck SHAd1497b46c9dcbae577d7172e6c4401388a1797e68d33ba795d4e6a6a05dd4c0c replaces only fragile guard simplification with explicit cases on decide(P)=true and exact if_pos/if_neg rewrites. The already reviewed partition, independence and pigeonhole statements and the final original triangle predicate are unchanged. I inspected the final adapter.

### Independent Python/data evidence — not Lean acceptance

The article agent's cached_pilot41_review.json reports independent recomputation of all9300 coordinate-residue pairs (372vertices times25moduli) in cache-data SHA8675170ee8dd4cc2f8b97a8045aab373693eeb10d3ad80f0d24e5d1dc549c779. Both class certificates check exact projected original vertex lists and use the same mask for stored and original vertices. The report does not claim either class certificate compiled.

The article agent's indexed_closure41_review.json and verify_indexed_closure41.py independently parse actual Lean data, validate all anchor/vertex square-root equations and both signed mutations for all373 closure vertices, and reproduce745 exact destination indices plus one strict out-of-bound destination. The reviewed pilot hash aa955931a4521c8735423353db9d089a97667a50300a9fb2f5aca1b3277b29ee matches the coordinator's compiled pilot below. This exact diagnostic reproduction is separate evidence from its kernel certificate. The original witness/phase input hashes are retained in that JSON report.

### Coordinator-reported standalone compiler results

These are the coordinator's reported actual standalone passes, not new runs by this reviewer and not whole-root/axiom/fresh-replay acceptance. The current local hashes were checked against the reported fingerprints.

| Module | SHA256 | Reported standalone time |
|---|---|---|
| PellCFPrefixCheck | a5468d17d5b8fd8febaae9f486b606a6148827a88a3b76dca5782d036662adba |76s|
| PairBipartiteCheck | d1497b46c9dcbae577d7172e6c4401388a1797e68d33ba795d4e6a6a05dd4c0c |69.76s|
| PairCachedResidues | 8d30539028d401e948637a33f705cb33707d8ad4e1fe939eafd5ed7c690a9100 |78.69s|
| PairClosureIndexedWitness | 396e39b992bc9611aabcfcda13356692e98676409381a756555e84104fe22420 |31.97s|
| SmallPairIndexedClosure41 | aa955931a4521c8735423353db9d089a97667a50300a9fb2f5aca1b3277b29ee |78.1968s|

The coordinator additionally reports passes for the Graph41 data, seed, filtering, witness-data and cached-data modules. This records the reported scope, not invented per-file times or additional audit receipts. The generic Pell core now has standalone passes for both PellConvergentCompleteness and PellCFPrefixCheck. Full1016-field prefix/matching certificates remain separate gates.

The original monolithic Graph41 certificate and the unindexed witness-closure certificate each timed out at600seconds. Neither timeout is a mathematical success. At the coordinator's supplied snapshot, CachedLeft41 was active from02:41:02 and **no left/right color certificate had passed**. Consequently no completed cached triangle certificate, complete48-graph acceptance, final import closure or main theorem acceptance is asserted here. The indexed closure success cannot substitute for the outstanding within-color nonsquare certificates.

### Checkpoint 7 evidence fingerprints

- `audit_next/cached_residue_review.json`: `0566fb62afd7029e6ee3fd876d91982a58299c24823275137c1149e00d2799f0`
- `audit_next/cached_pilot41_review.json`: `dcdf8299030b1f6615925a273a443a731582f98907388874cf3e77b826eebfcf`
- `audit_next/indexed_closure41_review.json`: `62620391673d0370b51a5460dcc3912ad9ccaae99b006af9abff3000e0e8de5a`
- `pell_next/PellCFPrefixCheck.lean`: `a5468d17d5b8fd8febaae9f486b606a6148827a88a3b76dca5782d036662adba`
- `finite_fast_next/graphs/PairBipartiteCheck.lean`: `d1497b46c9dcbae577d7172e6c4401388a1797e68d33ba795d4e6a6a05dd4c0c`
- `pair_witness_next/PairCachedResidues.lean`: `8d30539028d401e948637a33f705cb33707d8ad4e1fe939eafd5ed7c690a9100`
- `pair_witness_next/PairClosureIndexedWitness.lean`: `396e39b992bc9611aabcfcda13356692e98676409381a756555e84104fe22420`
- `pair_witness_next/SmallPairIndexedClosure41.lean`: `aa955931a4521c8735423353db9d089a97667a50300a9fb2f5aca1b3277b29ee`
- `pair_witness_next/cached_pilot41/SmallPairCachedData41.lean`: `8675170ee8dd4cc2f8b97a8045aab373693eeb10d3ad80f0d24e5d1dc549c779`
- `pair_witness_next/cached_pilot41/SmallPairCachedLeft41.lean`: `a52e679de7890d6bac467cbcc164e8b97c592b1d833214a773f07f4b291f741f`
- `pair_witness_next/cached_pilot41/SmallPairCachedRight41.lean`: `2ed87cf544d8a89125a662faa03067e13dec4a00c69f967b931e36261a979d64`
- `pair_witness_next/cached_pilot41/SmallPairCachedPilot41.lean`: `c0f4bf9ac5af7caa12571a3c7ba5d505533a04594ca8d6f0b860336c7ab6ec94`
