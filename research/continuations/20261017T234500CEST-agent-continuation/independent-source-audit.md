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
