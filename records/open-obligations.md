# Open mathematical obligations

## 18 October 2026 — weighted height and actual Bennett residual verified

Six working modules now prove the combined weighted column height, exact analytic residue evaluation, the inverse-denominator/repeated-node coefficient identity, and the actual arbitrary-order residual bound including its exact Gamma specialization. All original theorem headers are unchanged. The guarded pinned builds, exact public type/transitive-axiom audit and targeted installed SAME-kernel replays of the weighted-height, infinity and residual-bound endpoints passed with only propext, Classical.choice and Quot.sound. Applying the integral clearing factor and residual rate, the full-ring all-order inequalities, root integration, exhaustive finite checks and MainStatement remain open. Evidence: research/continuations/20261018T231100CEST-weighted-residual/VERIFICATION_SUMMARY.json.

## 18 October 2026 — Bennett coefficient bounds and signed-root approximation verified

Six working modules now prove the actual Bennett base-42 bounds for both nonzero columns and the integral signed-root approximation with strict factor3/2. All 17 original public theorems and one private helper compiled; five modules needed proof-body-only repairs, with all original headers preserved. The exact public type/transitive-axiom audit and six targeted installed SAME-kernel replays passed, with only propext/Classical.choice/Quot.sound. The final source review covers 33 project dependencies. Root integration, the weighted combined bound, residual evaluation/rate, full-ring all-order conclusion, exhaustive finite checks and MainStatement remain open. Evidence: research/continuations/20261018T222403CEST-coeff-root/VERIFICATION_SUMMARY.json.

## 18 October 2026 — two-anchor integral matrix and full-ring row selection verified

Four working modules now close exact two-anchor Bennett summand/entry integrality, column-power divisibility, nonsingularity of the constructed matrix and the full-ring existence of a row form with modulus at least one. All 21 original theorems and four definitions compiled unchanged, passed exact type/axiom checks and four targeted installed SAME-kernel replays. The full-ring endpoint retains the explicit a,b,z nonzero and a!=b hypotheses; tuple-specific upper estimates remain downstream. No root integration or MainStatement proof is claimed. Evidence: research/continuations/20261018T220533CEST-bennett-integrality/VERIFICATION_SUMMARY.json.

## 18 October 2026 — ordinary height envelope and conditional unit-pair cutoff verified

Three working modules OrdinaryLog10, OrdinaryHeightEnvelope and UnitPairHeightCutoff passed guarded pinned compilation, exact audits of 15 theorems and one definition, and three targeted installed SAME-kernel replays. All original theorem statements are unchanged. The cutoff S<10000 is derived from the explicit growth/root/all-order hypotheses, not assumed for arbitrary tuples. All ten wave119 repair targets now have current guarded compiled status. The earlier mixed full-ring gap was already verified in commit 5ca7c28 and was not repeated. Root integration, the remaining full-ring Bennett bridges, exhaustive finite certificates, and MainStatement remain open. Evidence: research/continuations/20261018T212721CEST-height-envelope/VERIFICATION_SUMMARY.json.

## 18 October 2026 — two Bennett analytic working modules verified

`BennettResidualMajorant` and `BennettPositiveSeries` now have repaired guarded pinned builds, exact audits of fourteen original theorems plus one helper and one definition, and successful installed SAME-kernel targeted replays. The combined fresh closure replay exceeded its 240-second budget and is unconfirmed. No original theorem headers or budgets were weakened. These modules are not root-integrated and MainStatement remains UNPROVED. Evidence: `research/continuations/20261018T1901CEST-bennett-analytic/VERIFICATION_SUMMARY.json`. Next ready reviewed repairs: RetainedMixedFourScalar, RetainedMixedScalar. Automation/diagnostic settings were not changed.

## 18 October 2026 — two-anchor Bennett denominator clearing separately verified

Six wave119 Bennett denominator identities in `D1Bound5/BennettTwoDenominatorClearing.lean` compiled with the guarded pinned driver, exact type/axiom-audited and targeted SAME-kernel replayed. All checks passed; root integration remains pending. Evidence and byte-identical source: `research/continuations/20261018T124800CEST-bennett-clearing/`. The full arbitrary-order Bennett determinant, finite exhaustive certificates/descent, final sextuple exclusions and MainStatement remain UNPROVED. No whole-root clean-checkout or independent final audit is claimed.

## 17 October 2026 — cross-block, coherent interpolation and first-order Bennett verified

Seven new root-imported modules prove 45 exported theorems (plus 3 private cross-block helpers) and add 8 public definitions. The new results are the full-ring cross-block determinant lower bound; exact convergent coherent interpolation, manuscript tail estimate and coherent-root compatibility; the arbitrary-size k=1 Bennett determinant with explicit entries and nonvanishing; the conditional all-order determinant/degree and simple-residue coefficient principles; and the local inverse-power binomial expansion.

All seven standalone pinned module builds, the integrated root build, the exact 53-declaration type/transitive-axiom audit, the whole-project transitive-axiom audit and the source/import scan passed. Fresh whole-root leanchecker replay also passed in the SAME installed Lean kernel, with source SHA256 equality before and after replay. Only propext, Classical.choice and Quot.sound are permitted by the enforced audits. Independent source/statement review of all seven exact final module bodies passed. No fresh clean-checkout or independent kernel implementation was used.

The new work does NOT close the arbitrary-order Bennett determinant: concrete residue cancellation/decomposition, the node-removal recurrence and the nonzero determinant constant remain open. The integral coherent linear form and nonvanishing, quantitative approximation and cross-block upper bounds, complete finite certificates/descent, the three final sextuple branches and MainStatement remain UNPROVED. The full-ring product-four and product-five tuple growth endpoints were already proved and remain unchanged.

The public manuscript body matches frozen v4; only PDF metadata and date differ. The two requested hourly automations remain paused. Previous unsynchronized work was privately pushed in d7ba2c337d76df8e081ac8e299f48a019e0d2791 and fd0c8b471614a4b8c5a110a830524c973758e4aa. Publication of this new accepted snapshot requires the separate verified push receipt.

## 17 October 2026 — sharp real half-binomial convolution CLOSED

The root-imported `halfBinomialCoeff_abs_convolution` proves exactly `sum_(i+j=n) |b(i)*b(j)| = 4|b(n)|` for all n>=2, where `b(n)=choose(1/2,n)` over the reals. Its new intermediate theorems prove the interior sum and its total absolute value. Integrated pinned build, exact type/axiom audit, targeted same-kernel replay, root-source audit and exact source/tool manifest checks all passed. No additional mathematical assumptions were inserted. No independent reviewer or clean checkout.

**Still OPEN:** formalize the complex weighted convolution `f_n(x,y)` and use the sharp real equality, the already proved antitone absolute coefficients, and the powers of the node norm to prove `|f_n(x,y)| <= 4|b(m+1)|P^(-n)` for n>=m+1, with the correct hypotheses m>=1 and norm bounds. Then identify the paper's analytic square-root remainder with the generic coherent weighted tail; Bennett's arbitrary-order determinant, complete finite coverage/descent, final exclusions and MainStatement also remain open.

## 17 October 2026 — weighted homogeneous analytic tail sum CLOSED under coefficient envelope

Root-imported `coherent_weighted_remainder_summable_and_norm_le` proves the exact sum-of-norms bound `C*t^m*((1-rho*t)^(-m_nodes)-1)` and absolute summability for arbitrary complex weighted complete-homogeneous coefficients, with the necessary coefficient envelope explicitly present in its formal type. All root build, axiom, fresh same-kernel replay, import and fingerprint gates passed. The parent negative-binomial positive-tail identity is root-imported too.

**Still OPEN:** prove for the concrete square-root convolution `f_n(x,y)` the uniform bound `|f_n| <= 4|binom(1/2,m+1)|P^(-n)` when `n>=m+1`, rigorously identify `F_m-f_m` with this weighted tail, and discharge the parameters `rho=1/A_1` and `t=1/P`. Only then does v4 `eq:coherent-tail` become an unconditional theorem. Independently open: Bennett all-orders determinant, finite certified coverage and descent, final sextuple exclusions and `MainStatement`.

## 17 October 2026 — hsymm analytic summability CLOSED

`hsymm_aeval_complex_summable` proves convergence of the hsymm generating series inside `rho * norm(z) < 1` by comparison with a negative-binomial majorant, assuming a nonempty finite complex index type. This uses the already closed exact coefficient bound and has no additional mathematical hypotheses. The proof is root-imported and pinned-built, with exact type and transitive axioms checked. The remaining analytic gap is the frozen square-root-binomial convolution and the explicit tail constant in `eq:coherent-tail`, followed by Bennett's identity, exhaustive finite certification/descent, sextuple exclusions, and MainStatement.

## 17 October 2026 — complex hsymm coefficient bound CLOSED

The root theorem `hsymm_aeval_complex_norm_le_choose` proves the exact estimate `‖h_k(b)‖ ≤ choose(m+k-1,k) * ρ^k` over a finite complex alphabet when `ρ≥0` and all variable norms are ≤ρ. The proof handles k=0 and an empty alphabet. Target/root build, exact type/axiom audit, source/import audit and installed fresh same-kernel replay PASS. No independent reviewer or clean checkout.

STILL OPEN: prove analytic summability from the strict radius hypothesis, combine with the frozen binomial/square-root expansion and derive the v4 inequality `eq:coherent-tail`. The arbitrary-order Bennett determinant, exhaustive finite certificate coverage and descent, final exclusions and MainStatement also remain open. Git/fingerprint release gate remains pending after a previous explicit safety refusal.

## 17 October 2026 — finite rational pole/hsymm tail CLOSED, analytic bounds OPEN

The exact finite geometric expansion of each reciprocal pole and the arbitrary weighted finite sum are root-proved. The formal theorem `reciprocal_pole_hsymm_finite_tail` identifies all polynomial coefficients with the already proved reciprocal-anchor hsymm moments for arbitrary finite order and retains an explicit rational remainder. This is an algebraic identity over any field, not an absolute convergence or infinite-series theorem. A complete root build, exact-type/axiom audit and targeted fresh same-kernel replay passed; manifest refresh and Git synchronization remain blocked before execution.

NEXT: prove for complex b_i with ||b_i||<=rho the uniform bound `||h_k(b)|| <= Nat.choose (m+k-1) k * rho^k` using `Sym.card_sym_eq_choose` and multiset monomial norms; then establish absolute convergence and the full binomial square-root tail estimate of frozen v4 `eq:coherent-tail`. The arbitrary-order Bennett determinant and all global sextuple exclusions remain independent open obligations.

## 17 October 2026 — all-k moment/hsymm bridge CLOSED

Root-proved and freshly same-kernel replayed: `lagrange_power_moment_eq_hsymm` and `reciprocal_anchor_sum_eq_hsymm`, for arbitrary finite nonempty node sets and every natural k. Do NOT redo or describe this identity as still open. The proof uses actual finite-set and degree induction, not guessed recurrence assumptions. See `records/interpolation-all-orders-20261017.md`.

Next: derive the complex hsymm norm envelope, absolute summability and the square-root interpolation remainder estimate. This algebraic unit does not prove eq:coherent-exact as an infinite-series statement, Bennett's determinant, complete finite descent/coverage, final exclusions or MainStatement. The original 16:47 finite-pole draft remains preserved as an uncompiled artifact; its corrected successor is root-proved as recorded in the newer section above.

The main theorem is UNPROVED in Lean. None of the items below is assumed
as a custom axiom or silently supplied as a hypothesis of a claimed proof.

## 17 October 2026 — product-five growth CLOSED (new authoritative status)

`IsD1Tuple.productFive_growth` proves the full ordered five-entry inequality
`D > 3ABSC` in every imaginary quadratic full integer ring, with `B >= 3`.
The root proof constructs one compatible signed original-ring matrix; no
independent Schur, bilinear, determinant or growth assumption is inserted.
The first-entry lower bound comes from nonzero integral norm. Root build and
seven-declaration transitive-axiom audit PASS; further verification receipts
are in the current run records. This supersedes all older OPEN mentions of
`lem:product-five` below. A fortiori, it does NOT prove the global bound five.

Still OPEN: interpolation/remainder inequalities, the genuine arbitrary-order
Bennett determinant identity, all-orders approximation consequences, finite
certificate checker correctness and exhaustive vertex/edge coverage, reversible
descent termination and field-range cutoffs, final exclusions for zero, one
and at least two small entries, and the faithful `MainStatement` proof with
independent statement audit and a clean-checkout verification.

## Product-five arithmetic closure (16 October 2026, evening)

The root-imported `ProductFiveArithmeticClosure.lean` proves, for every
imaginary quadratic FULL ring of integers and any symmetric five-entry
integral root matrix, that the following TWO quantitative hypotheses on
the actual complex normalized Schur complement G suffice for product-five:

* `‖G - halfOffDiagonal‖₂ < 1/2`;
* `‖G.det‖ < 1/3`.

The first proves `G.det ≠ 0`; the exact determinant identity gives
`M.det ≠ 0`, and the full-ring integer norm bound gives
`3 * ∏_{i<4} |t_i| < |t_4|`. This is proved, root-built and axiom-audited
without assuming nonvanishing of `M.det`. Both quantitative estimates
are STILL OPEN for the original arbitrary ordered quintuple; the
corresponding signed-root construction and tuple-interface wrapper also
remain to be completed. No part of this conditional result is counted
as the entire `lem:product-five`.

The exact normalized five-entry determinant bridge is root-integrated.
The arbitrary-order Bennett identity, analytic interpolation/remainder
estimates, finite checker soundness/coverage/descent, and final sextuple
exclusions remain open. Older comments below may predate these modules.

## Current analytic status (16 October 2026, 17:30 CEST)

The mixed first-row/lower-block symmetric zero-diagonal matrix now has both
unconditional `‖det F‖<3/10` and `‖adj F‖<(155/96)*(59/96)^2` estimates. The
same signed matrix over the original commutative ring satisfies BOTH through
`mixed_signed_root_det_and_adjugate_upper`, with its exact `MixedSignedEntryGood`
hypothesis. The predicate is provided by the separately proved simultaneous
sign-existence theorem under pair-product lower thresholds >=3 in the first
row and >=9 in the remaining block. The new scalar, sixteen-entry, Schur
and signed-ring transfer proof contains 14 audited and kernel-replayed
theorems. Historical remarks below that call the mixed determinant,
adjugate or weighted spectral subproblems open have been superseded.

Still OPEN in `lem:product-four`: assemble the mixed A>=1, B>=3 case
for an ACTUAL D(1) quadruple, including exact rank-one squared-norm
control, arithmetical determinant lower bound, nonvanishing, D>18 and the
numerical inequality. The separate isolated numerical closure exists but
has not been root-integrated. The first A>=3 branch is proved in the actual
tuple interface. Beyond product-four, product-five, the all-order Bennett
determinant identity, structural estimates, exhaustive finite graphs,
termination and the final sextuple exclusions all remain open.



## Full-ring bridge: now proved

The continuation constructs the full ring equivalence for every imaginary
quadratic field, including squarefree d, tau=0/1 and the exact half-integral
branch. It identifies coordinate, integral algebraic and complex squared
norms. No bridge assumption is inserted into the final target. See
`full-ring-bridge.md` and the latest build/axiom/replay record.

## Analytic and structural arguments

The direct symmetric 4x4 determinant bound now has a self-contained compiled Lean proof in `exploration/SymmetricFourDetTrial.lean` (seven declarations; transitive axiom audit PASS). For six entries near 1/2 it proves the strict upper bound 6/25, which is below the product-four target h*s^3, and transfers the result to the ring-valued sign choice. This source is NOT integrated in the root because the file move was blocked by the safety guard. The adjugate upper bound and A>=1,B>=3 branch remain unproved. See `records/direct-symmetric-four-det-20261016.md`.


`lem:irregular-growth` and its exact quadratic inequality are now proved
in every imaginary quadratic full integer ring. `lem:tail-irregular` is now compiled in full, including its finite C<4
case and D>2BC for B>=3. The arithmetic nonsingularity assertion for
even-dimensional root matrices is also compiled, with its integral-modulus
lower bound. The four-by-four simultaneous symmetric integral sign
selection is now proved for all pair products of modulus at least 9,
including independent complex square-root choices. The A>=3 four-by-four L2 spectral perturbation estimate now follows
from three kernel-proved permutation-matrix matchings and the uniform
entrywise error bounds. The mixed-row A>=1,B>=3 sign choice and its
weighted operator-norm estimate remain open. The reference matrix H=(J_4-I_4)/2 now has a proved explicit inverse, det H=-3/16 and exact adjugate entries. The sharp spectral norm `‖halfOffDiagonalInverse‖=2` and the contraction bound `‖halfOffDiagonalInverse*(F-halfOffDiagonal)‖<1` under the previously proved uniform error hypothesis are now proved. The *perturbative* adjugate/determinant upper bounds and the weighted A>=1,B>=3 branch of lem:product-four remain open. Complete the analytic determinant size and gap bounds,
interpolation identities and analytic remainder estimates. The extension-product identity is connected to the norm bound and the
full real endpoint proof; it is no longer the only completed part of
`lem:irregular-growth`.
Prove the explicit ordinary and finite approximation families and their
coefficient, divisibility, determinant and remainder bounds.

Bennett's arbitrary-order determinant identity is a genuine dependency.
Tests at small orders are not a proof for all orders. Prove the required
identity (or an equivalent replacement) with its exact normalization and
hypotheses. The generic interval-chain lemma now proved does not discharge
this dependency or the domain-specific interval estimates.

## Finite computations and completeness

The exhaustive disk enumeration and full-ring square-test criteria are now
proved. The complete small-tail exclusion is proved directly over all
thirty normalized models, avoiding a symmetry-classification dependency.
Its list coverage and full Boolean checks have kernel proofs. The six old
modular obstructions alone were insufficient; the new certificate closes
that gap. See tail-complete-proof.md and the current validation receipts.

Complete the analytic contraction in `sm:bs7-descent`, its well-founded
termination, and reverse-chain coverage of the bounded extension sets.
The mutation and inverse identities are already proved without division.
Prove that every admissible vertex and relevant edge is represented by the
checked graph, including zero/anchor-coincident intermediate extensions.
Then kernel-check the compact certificates. Do not scan a disk of radius
10^550 naively, and do not use native-evaluation axioms as final evidence.

The historical graphs, exceptional product-minus-one pairs, Pell/continued-
fraction enumeration, small triple orbits, forty first-pair representatives,
fifty-six triples, and rational pair (1,3) require full coverage arguments.
No large historical graph was regenerated during the initial local session.

The rationality part of `lem:pr-one-three` is now proved both in every
positive-discriminant coordinate model and in the full integer ring of
EVERY imaginary quadratic field. The separate signed-cardinality argument
remains open. See `one-three-proof.md` and `full-ring-bridge.md`.

## Final assembly and release gates

Prove the three main exclusions: no small entry, exactly one small entry,
and at least two small entries. Then use the proved sextuple reduction.
Re-audit the fully elaborated target and transitive dependency closure.
Require an independent statement back-translation, clean-checkout build,
reproducible certificate checks, and final kernel replay.

No independent reviewer or paid agent was used in this session.
Prove2Me is deferred until local completion; no mission has been opened.
The v4 proof does not use He-Togbe-Ziegler, and that dependency has not been
introduced into the Lean project.


### Auxiliary statement packaging

Before using `full_ring_negative_integer_square` as a fixed-field
classification, strengthen its conclusion to retain the ring equivalence
and a single field parameter d uniformly over the negative integers.
The existing conclusion forgets that identification. Its coordinate
lemmas are available; the complete tail and even determinant do not use
the weaker wrapper. See the latest statement-review entry.

## Quantitative matrix perturbation update (16 October 2026)

The four-by-four normalized matrix's nonsingularity and the inverse bound `‖F⁻¹‖<8/3` for `‖F-(J-I)/2‖<1/8` are now proved without extra mathematical axioms. The simultaneous signed-root construction has a formally proved corollary with the same inverse bound when all pair products have modulus at least nine. For `lem:product-four`, the still essential next proof unit is the **upper** bound `|det F|<hs³` and `‖adj F‖<hs²` from the singular-value perturbation estimates, followed by the rank-one determinant estimate and the separately required weighted `A≥1,B≥3` branch. The current inverse estimates alone do not prove either product-four inequality.


## Rank-one determinant step and numerical closure (16 October 2026)

The rank-one determinant/cofactor inequality used in (integrated-1) now has a formal proof, including the non-Hermitian bilinear L2 estimate and transfer to the scaled root matrix. The exact A>=3 rational numerical closing inequality is also proved. The formal implication D>2ABC still explicitly assumes |det F|<h*s^3, ||adj F||_2<h*s^2, a squared-size bound for the input vector, and the lower bound coming from the integral root matrix. These hypotheses must be proved in the original arithmetic setting before claiming the product-four lemma.

Next: construct the sharp determinant and adjugate perturbation bounds from the established operator-norm estimate ||F-(J4-I4)/2||<3*(128/8649). The singular-value/exterior-power estimates are not yet formalized. Then prove the mixed A>=1,B>=3 weighted estimate and assemble both branches. The Bennett all-orders identity, large finite-graph/Pell completeness and three final sextuple exclusions remain separate open obligations.

## Adjugate entry reduction update (16 October 2026, isolated)

Six compiled and axiom-audited theorems provide the general `||E|| < a+3b` decomposition, exact symmetric cofactors, diagonal cubic cofactor error, and the numerical final implication `||adj F|| < h*s²` **conditional** on 4 diagonal bounds `<23/1000` and 12 off-diagonal bounds `<197/10000`. The off-diagonal scalar bound, expansion to all 16 indices and integration/replay remain OPEN. Source `exploration/AdjugateFourTrial.lean`; do not count it in accepted root modules. Continue from the deviation expansion in `records/adjugate-entry-reduction-20261016.md`.

## Off-diagonal cubic bound (16 October 2026, 06:28 CEST)

The exact scalar inequality `‖w²x-wzu-wyv+1/8‖ < 197/10000` from six near-half hypotheses is now proved in `exploration/AdjugateOffdiagTrial.lean`, targeted compilation exit 0 with standard transitive axioms only. The formal six-variable polynomial identity, all linear/quadratic/cubic norm bounds and the strict rational margin are closed. Remaining: derive the bound for all twelve off-diagonal adjugate entries of a symmetric 4x4 zero-diagonal matrix, combine with the proved diagonal scalar inequality and the conditional four-by-four operator-norm estimate, and perform legitimate integration, installed kernel replay and global root audits. No change to final main-theorem status.

## 16 October 2026 — adjugate cofactor index coverage

CLOSED in isolated Lean source: all 4 diagonal and 12 off-diagonal cofactor bounds of a symmetric zero-diagonal complex 4x4 matrix, yielding `||adj F|| < productFourH*productFourS^2` from six near-half entry hypotheses. It is also proved for any symmetric zero-diagonal F by explicit 16-index representation. Not yet root-imported. NEXT: connect this theorem to the ring-valued symmetric signed-root construction and integrate all needed proof modules. The separate mixed A>=1,B>=3 branch, Bennett identity, complete finite certificates and main theorem remain OPEN.

## 16 October 2026 — adjugate analytic bound integrated

CLOSED as a root-imported Lean theorem: for every symmetric, zero-diagonal complex 4x4 matrix whose six off-diagonal entries lie within 128/8649 of 1/2, the L2 operator norm of its adjugate is strictly less than (8905/5766)*(3139/5766)^2. The cofactor formulas and all 16 index cases are proved. The full signed root matrix transfer (arbitrary commutative ring and integral sign choices) is proved as exists_signed_root_matrix_adjugate_upper, assuming only the stated root-square relations and pair-product norm at least nine. Root build and 12-theorem transitive axiom audit passed; see dated records for targeted kernel replays.

The direct determinant bound remains isolated in exploration/SymmetricFourDetTrial.lean. Its integration, the integral determinant lower-bound connection, the mixed A>=1,B>=3 product-four case, Bennett's arbitrary-order identity, final finite certificates and sextuple exclusions remain OPEN. MainStatement is still only a proposition.

## Direct determinant and same-witness adjugate closure (16 October 2026)

CLOSED, root-integrated: the direct symmetric zero-diagonal 4x4 determinant bound `||det F||<h*s^3` and the joint existential signed-root theorem guaranteeing BOTH this determinant bound and `||adj F||<h*s^2` for the SAME matrix and original ring-valued signs. All eight new declarations compiled, passed transitive axiom audit and targeted same-kernel replay. This closes the two analytic upper-bound hypotheses in the A>=3 product-four argument at the signed-matrix level.

OPEN: connect the scaled root determinant to the lower bound from even_root_matrix_one_le_norm, prove the rank-one input squared-size estimate in the ordered quadruple setting, assemble the quantitative growth conclusion, and separately close the weighted A>=1,B>=3 case. The arbitrary-order Bennett determinant identity and final finite sextuple exclusions remain open. No proof of MainStatement is claimed.

## Exact full-ring determinant lower interface (16 October 2026)

CLOSED and root-integrated. `full_ring_scaledRootMatrix_det_norm_lower` deduces the scaled matrix's determinant lower bound directly from the full-ring even root-matrix theorem, for every even index type, every imaginary quadratic full integer ring and arbitrary complex square roots (including zero). Its underlying generic identity is proved over any commutative ring. All three declarations passed pinned compilation, transitive axiom audit and targeted same-kernel replay. The explicit finite product must still be identified with the ordered first four moduli and applied to the SAME signed matrix as the determinant/adjugate upper bounds. The vector squared-size bound and weighted mixed branch remain open. See dated run and detailed record.

## 16 October 2026 — large-entry product-four branch

CLOSED in the accepted integrated ring-matrix interface: `full_ring_productFour_large_growth` formally deduces `D>2ABC` for ordered moduli `A>=3`, from the existing irregular-tail consequence `2BC<D`, and an actual symmetric integral 4x4 root matrix over the full integer ring. The four-square sum `<= (13/12)D^2`, threshold `D>18`, sign choice, perturbation bounds, rank-one determinant upper and arithmetic determinant lower are all PROVED, not new axiomatic hypotheses. Audit and targeted kernel replay PASS. **Remaining interface**: construct symmetric root matrix from arbitrary D(1)-tuple and apply existing complete tail-growth theorem. **Remaining second branch**: weighted `A>=1,B>=3` determinant bounds, so the whole `lem:product-four` is not yet closed; followed by product-five, Bennett, finite certificates and main exclusion. See `records/product-four-large-branch-20261016.md`.

## Tuple-to-matrix A>=3 bridge (16 October 2026, isolated)

An actual Lean proof of the generic symmetric original-ring root-matrix construction and the complete-tail-to-product-four A>=3 implication has been elaborated and same-kernel replayed in `exploration/TupleRootMatrixBridgeTrial.lean`. This removes auxiliary root-matrix and tail-growth hypotheses from this branch at the *isolated-source* level. Acceptance OPEN: higher-level safety checks blocked copying/moving the source into the imported project module, and blocked the corrected transitive axiom-audit attempt. The .olean and isolated replay exited zero; no axiom audit or integrated root build occurred for this unit. Do not count it in the 56-module inventory yet. After integration and full audit, develop the separately weighted A>=1,B>=3 case. Bennett arbitrary-order identity and main bound-five exclusions remain OPEN.

## 16 October 2026 — tuple bridge ACCEPTED

CLOSED: generic symmetric original-ring root-matrix construction and the full-ring `IsD1Tuple` theorem `A>=3 => D>2ABC` for any ordered D(1) quadruple, with no independent matrix/tail hypotheses. Both are root-imported, built, transitive-axiom audited and same-kernel replayed (EXIT 0). 57 root modules, 284 explicit theorems. This supersedes the preceding isolated-source status.

OPEN NEXT: prove weighted manuscript product-four branch `A>=1, B>=3 => D>(3/2)ABC`. It needs the first-row `<1/18` and remaining `<1/64` perturbation bounds, the weighted matrix norm `<11/96`, determinant/adjugate control, an appropriate numerical closure and the same root-matrix arithmetic lower bound. Do not infer the mixed case from the A>=3 result. Product-five, arbitrary-order Bennett, rigorous finite completeness/descent and all sextuple exclusions remain open; `MainStatement` UNPROVED.

## 2026-10-16 — mixed weighted-row envelope, formalized

Seven new root-imported declarations in `D1Bound5/WeightedRowCertificate.lean` prove the positive weight vector (3/2,1,1,1), nonnegative symmetric envelope with off-diagonal entries 1/18 on row/column zero and 1/64 otherwise, exact weighted row bound 11/96, its strict first-row slack, entrywise norm comparison for general complex matrices, and the resulting weighted-row sum inequality. The matrix theorem does **not** assume symmetry. All seven elaborated types and transitive axioms checked (only propext, Classical.choice, Quot.sound).

The previously prepared eight-declaration `D1Bound5/MixedRootMatrixSigns.lean` also passed targeted transitive-axiom audit and same-kernel replay in this run, making the mixed sign-choice machinery available for the next operator-norm bridge. The root build includes both modules; the source/import audit records 59 modules and 299 explicit proved theorems. No fresh clean-checkout verification or independent mathematical review occurred.

**Unfinished dependency:** From the weighted row-sum certificate and symmetric entrywise moduli, prove the weighted Schur/spectral comparison that yields `‖E‖_2 ≤ 11/96` (preferably strict with the given strict entry bounds). Do not use the row inequality as a substitute for operator norm control. Then prove determinant/adjugate estimates for `s = 59/96`, `h = 155/96`, and close the `A >= 1, B >= 3` product-four case. Bennett's identity, complete finite search soundness/coverage, and final bound-five theorem remain open.

## Mixed determinant milestone — 2026-10-16

CLOSED: full ring-agnostic `mixed_signed_root_det_upper`, showing `<3/10` for the normalized signed-root matrix after mixed sign selection. It only uses the stated `MixedSignedEntryGood` conditions. The operator-norm weighted Schur lemma is also kernel-replayed (exit zero).

OPEN: Prove `‖F.adjugate‖ < (155/96)*(59/96)^2` for that SAME mixed normalized matrix. The polynomial determinant `<3/10` alone does not give the required adjugate estimate. Then bind both with integral determinant lower bound, squared-size estimate and the already proved numerical conditional lemma to establish D>(3/2)ABC for actual D(1) quadruples. Product-five, Bennett all-orders identity, certified finite coverage and final sextuple exclusion remain open.

## 2026-10-16 — product-four status update

CLOSED (formal theorem, kernel replayed): `IsD1Tuple.productFour_mixed_growth`, the full-ring A>=1, B>=3 bound D>(3/2)ABC. This closes the remaining mixed case, alongside the already proved A>=3 branch. It is unconditional on any auxiliary signed matrix or tail-growth witness beyond `IsD1Tuple` and the stated norm lower bounds. See `records/mixed-product-four-growth-20261016.md`.

OPEN: product-five, full arbitrary-order Bennett determinant identity, checker soundness/exhaustive coverage and descent termination for the large finite computations, the three sextuple exclusions and final complete `MainStatement` proof. Final clean checkout, independent statement review, global axiom audit and whole-root kernel replay are not yet done.

## Product-five rank-two determinant bridge — 2026-10-16

CLOSED: The exact complex rank-two determinant polynomial of (integrated-3), including the Schur-complement entry identification, and the reduction from two distinct bilinear cross terms to one under `F.transpose = F`. The new root-imported `productFiveSchur_det` assumes only `F.det != 0`, `d != 0` and symmetry. All nine new theorems passed the pinned build, transitive axiom audit and targeted same-kernel replay. This is a genuine matrix-algebra step, NOT the full product-five lemma.

NEXT: Prove `det N = d^2 det G` from the actual five-entry scaled root matrix and its block decomposition. Then formalize the quantitative bounds `|det F|<33/128`, `||F^{-1} f||<11/12`, `|h|<11C/6`, `|p|<1`, `|q|<32C^2/3`, `|det G|<1/3` and `||G-F0||<1/2` with their exact ordering assumptions. Use the even integral determinant lower bound to prove `D>3ABSC`. The full Bennett arbitrary-order identity, large finite certificates and final sextuple exclusions remain OPEN. No clean checkout or independent statement audit for the final theorem yet.

### Product-five exact five-entry matrix bridge (2026-10-16 20:30 CEST)

The canonical Fin5-to-(Fin4⊕Fin1) determinant normalization is proved in a targeted compiled and kernel-replayed module (`ProductFiveMatrixBridge.lean`). It is not root imported (blocked write); reconnect the original-ring D(1) tuple, derive analytic numerical bounds and the inequality `D>3ABSC`. Do not count this isolated module in root-import coverage until fixed.

## 2026-10-16 — product-five scalar determinant margin CLOSED

The two root-integrated, audited and same-kernel-replayed theorems in `ProductFiveDetNumeric.lean` convert exactly five quantitative bounds on `det F`, `h/d`, `p`, `q/d²`, `p/d²` to `|det G|<1/3`. Exact rational margin is 5849/497664. Remaining OPEN: derive these bounds for the actual chosen symmetric original-ring root matrix, including `|det F|<33/128` (existing mixed estimate `<3/10` is insufficient), prefix inverse and last-column estimates; prove `||G-H||<1/2`; apply the already proved full-ring arithmetic growth endpoint to the ordered tuple. Bennett arbitrary-order, finite-completeness/descent, and global bound five remain OPEN.

## 2026-10-16 — product-five sharp prefix determinant CLOSED

`mixed_zero_four_det_norm_lt_33_128` in `D1Bound5/ProductFivePrefixDet.lean` proves `|det F|<33/128` for every symmetric zero-diagonal 4x4 complex matrix with mixed first-row (`<1/18`) and other off-diagonal (`<1/64`) entry perturbations about `1/2`. The exact determinant polynomial is controlled by `3/16 + 3*(7/192)/2 + 9*(7/192)^2 = 1041/4096`, with margin `15/4096`. Root build, transitive axiom audit, targeted same-kernel replay and source/import audit all passed. The result requires no invertibility.

NEXT: Construct compatible signs for the full five-entry original-ring root matrix (not merely its four-entry prefix), transfer the prefix determinant estimate, and establish the normalized last-column errors, `F^{-1}f` estimate and Schur norm control. Close the five scalar bounds of `ProductFiveDetNumeric` and `||G-halfOffDiagonal||<1/2` to obtain the tuple-level product-five inequality. Arbitrary-order Bennett identity, finite-checker correctness/coverage/descent and global sextuple exclusions are separate OPEN obligations.

## 2026-10-16 23:28 CEST — five-entry prefix determinant bridge

CLOSED under explicit mixed-sign hypotheses: the root-imported theorem `five_prefix_det_upper_of_mixed_signed_entries` transfers `||det F|| < 33/128` from the original-ring signed four-prefix into the canonical Fin 5 normalized-root matrix. The exact Fin4 inclusion is proved by matrix extensionality. This does not yet construct signs on the remaining four edges, nor prove the inequalities for h, p, q or `||G - halfOffDiagonal|| < 1/2`. Product-five and MainStatement remain OPEN. Two new theorems passed pinned integrated build, full transitive axiom audit and targeted installed same-kernel replay. See 20261016T231824Zagreb-automation9-FINISH.md.

## Compatible full-five-entry signs and f-vector bounds — 16 October continuation

The ten-theorem module ProductFiveCompatibleSigns has now passed isolated and integrated compilation. It constructs a single original-ring symmetric root matrix from an actual ordered full-ring D(1) quintuple with A>=1 and B>=3. D>54 is derived using product-four on the last four entries. Both the 33/128 prefix determinant bound and last-column distances <1/400 refer to the same matrix. The resulting Euclidean estimates ||f-f0||_2<1/200 and ||f||_2<201/200 are proved separately and may be applied to that same last column. Final acceptance receipts are in the current run, not inferred from compilation alone.

NEXT PRECISE DEPENDENCY: derive ||F^-1 f||_2<203/225<11/12 using the resolvent identity and F0^-1 f0=(1/3,...,1/3), with the already established mixed prefix operator bound. Then obtain the bilinear h,p,q bounds, Schur proximity <1/2, and the tuple-level product-five conclusion. The whole product-five lemma, Bennett all-orders identity, complete finite descent/coverage and the global main theorem remain OPEN. Do not redo the sign construction or assume a new independent matrix witness.

## 2026-10-17 — signed five-prefix inverse and p-form

PROVED in root-imported source: from one compatible original-ring signed five-entry matrix, `||F-H||<=11/96`, `||F^-1 v||_2<11/12` and `||v dot (F^-1 v)||<1`. The operator bound and vector bound were not inserted as hidden tuple hypotheses. Kernel replay and axiom audit passed; source/tool SHA-256 manifest refresh was denied, so the final integrity gate is PENDING. NEXT: derive prefix-size bound from the actual ordered quintuple and the scalar h/d, q/d^2, p/d^2 and Schur distance <1/2 bounds; then close product-five. Bennett arbitrary-order, certified finite coverage/descent, sextuple exclusions and MainStatement remain open.

## 2026-10-17 — prefix vector and h/d bounds proved in isolated Lean source

Three explicit declarations for the scalar four-square estimate, the Euclidean prefix vector norm ||w||_2 < ||d||/9, and the symmetric cross form |(v dot F^-1 w)/d|<11/108 compiled and passed allowed transitive-axiom inspection. Proof source exploration/ProductFivePrefixSizeContinuationTrial.lean is NOT root-imported because of a PRE_EXECUTION_DENIED copy call; it is not accepted formalization. Remaining: root integration and targeted replay, actual tuple specialization, q/d² and p/d², Schur reference distance, the full product-five conclusion, Bennett arbitrary-order identity, finite-checker completeness/descent and the sextuple exclusions.

## 2026-10-17 — normalized q/d² and p/d² bounds

CLOSED (root-imported, compiled, axiom-audited, targeted kernel-replayed): the two conditional normalized quadratic estimates in `ProductFiveNormalizedQuadratic.lean`. The first obtains `||q/d²||<8/243` from `||F-H||<1/8` and `||w||_2<||d||/9`; the second obtains `||p/d²||<1/2916` from `||p||<1` and `||d||>=54`. Neither theorem assumes a genuine tuple, and both must still be specialized to the SAME five-entry signed-root witness. The prefix-size/cross-form trial is NOT root-integrated. OPEN: establish the last-four-entry product-four input for an actual ordered quintuple, transfer h/d, q/d², p/d², prove Schur proximity <1/2, finish product-five and all global exclusions.

## 17 October 2026 — Schur reference neighborhood, conditional interfaces CLOSED

Root-proved `ProductFiveSchurNear` gives `||productFiveSchur F v w d - halfOffDiagonal|| < 1/2` from `||F-halfOffDiagonal||<=11/96`, `||d||>=54`, all coordinate ratios `||w_i/d||<1/18`, and `||v_i||<3/4`. The ordered scalar `||w_i/d||<1/18` follows from the last-four product-four growth inequality with second modulus >=3. Exact types, axioms, pinned build and targeted kernel replay PASS. These explicit conditions have NOT yet been assembled from one actual ordered full-ring D(1) quintuple. NEXT: use the existing compatible signs and last-column bound to discharge all conditions for one same matrix; combine determinant and arithmetic closure. Bennett arbitrary-order, finite completeness/descent and main bound-five still OPEN.

## 2026-10-17 — analytic weighted-pole remainder limit closed

ROOT-PROVED: the finite complex remainder in weighted_poles_finite_tail converges to zero under |z|<|a_i| for every finite node; proof in WeightedPoleLimit.lean. Integrated build, exact type/transitive axioms, fresh same-kernel replay and source/import checks PASS. No assumption of distinctness is needed for this analytic lemma.

NEXT: prove the corresponding HasSum identity by combining exact finite expansion, summability of the coefficient sequence, and this tail convergence. Then specialize it to reciprocal Lagrange anchors/homogeneous polynomials and prove the manuscript's explicit square-root remainder inequality eq:coherent-tail. Arbitrary-order Bennett determinant, full certified graph/descent and final sextuple exclusions remain open. MainStatement is UNPROVED.

## 17 October 2026 — recovered analytic modules integrated and audited

The three previously isolated units are now integrated as ComplexHalfBinomial, HalfBinomialAnalytic and HalfBinomialLowDegree. The last uses the same public halfBinomialWeightedCoeff definition, removing the private duplicate. All three module builds and the combined root build passed under the pinned environment. All ten exported theorems plus the coefficient definition passed enforced transitive axiom checks with only propext, Classical.choice and Quot.sound. An independent read-only statement/source audit found no weakened product-four/product-five endpoints or analytic formula errors. A fresh replay of this combined recovered snapshot is still pending in the current continuation. MainStatement remains UNPROVED.

The public manuscript and frozen v4 have identical document bodies: only PDF metadata and the printed date differ. Both hourly formalization automations were paused at the author request. Current new interpolation, cross-block and Bennett drafts are excluded from accepted imports until their tests succeed.


## 18 October 2026 — retained mixed scalar growth verified

RetainedMixedFourScalar (two theorems) and the repaired RetainedMixedScalar (one theorem) passed pinned guarded builds, exact type/transitive-axiom audits and installed SAME-kernel targeted replays. Original theorem headers and limits are unchanged. These are separately verified working dependencies, not accepted-root integration. CoherentRetainedMixedGap still requires CoherentRetainedMixedSizes and CoherentRetainedMixedForms. Evidence: research/continuations/20261018T203306CEST-retained-scalars/. MainStatement remains UNPROVED.

