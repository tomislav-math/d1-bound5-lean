# Open mathematical obligations

The main theorem is UNPROVED in Lean. None of the items below is assumed
as a custom axiom or silently supplied as a hypothesis of a claimed proof.

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
