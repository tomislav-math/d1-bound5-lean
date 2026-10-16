# Status

2026-10-16. IN PROGRESS. MAIN THEOREM UNPROVED.

## Latest accepted root proof unit: full adjugate bound and signed-ring transfer

Four newly imported modules contain twelve theorem declarations. The actual symmetric zero-diagonal 4x4 matrix with six off-diagonal entries within 128/8649 of 1/2 has the unconditional bound `||adj F||_2 < (8905/5766)*(3139/5766)^2`. A further theorem constructs simultaneous integral signs in an arbitrary commutative coefficient ring and derives this same bound for `normalizedRootError`, assuming only the pairwise root-square equations and pair-product moduli at least nine. Zero square roots and tied moduli are not excluded.

After removal of embedded exploratory audit commands, the final integrated build PASSED with exit 0 and 3015 jobs. Source/import policy PASSED (52 modules, 268 explicit proved theorems). All 12 new declarations passed an external transitive axiom audit with only `propext`, `Classical.choice`, `Quot.sound`. The four new modules each PASSED targeted installed Lean-kernel replay, exit 0. The SHA256 source and verification-tool manifests passed. These are same-kernel replays, not an independent external reviewer or a new clean-checkout build. See `records/adjugate-root-integration-20261016.md` and the latest START/PROGRESS/FINISH record.

The direct determinant size bound remains only in the isolated exploratory source. The integral determinant-lower-bound interface and mixed A>=1,B>=3 branch have not been assembled. Bennett, large graph completeness and all three main sextuple exclusions remain open. The older historical sections below predate this successful integration.

## New isolated off-diagonal cofactor inequality (06:28 CEST)

`exploration/AdjugateOffdiagTrial.lean` now proves the exact missing scalar inequality `nearHalf_offDiagonal_cofactor_bound`: if each of the six complex entries is within epsilon=128/8649 of 1/2, then `‖w^2*x-w*z*u-w*y*v+1/8‖ < 197/10000`. The expansion and its rational margin are proved in Lean, with no sorry and transitive axioms limited to propext, Classical.choice and Quot.sound. The pinned targeted `lake env lean` command exited 0. See `records/offdiagonal-cofactor-20261016.md` and `local-logs/adjugate-offdiag-run11-03.log`. This is **isolated exploration**, not yet root-imported, leanchecker-replayed or pushed.

The remaining gap for the full adjugate bound is the formal transfer to all twelve off-diagonal index orientations, and then combination with the already proved diagonal scalar bound and conditional norm closure in `exploration/AdjugateFourTrial.lean`. The separate mixed A>=1,B>=3 branch and global main theorem remain unproved. Previously integrated theorem counts have not changed.

## New isolated adjugate entry reduction (05:56 CEST)

Six additional theorems in `exploration/AdjugateFourTrial.lean` now compile with exit 0 and pass transitive axiom audit (only propext, Classical.choice, Quot.sound). They give a general 4x4 operator-norm estimate from separate diagonal/off-diagonal entry bounds, two exact symmetric cofactors, the needed numerical margin, an exact conditional adjugate norm closure, and the complete diagonal cubic error estimate. The remaining off-diagonal cubic error estimate and transfer to all 16 entries are NOT proved. See `records/adjugate-entry-reduction-20261016.md` and `local-logs/adjugate-four-trial-final-20261016.log`.

The new file is isolated, not integrated into `D1Bound5.lean`, not checked by installed leanchecker and not pushed. The previous direct determinant trial remains isolated for the same integration reason. Both are saved on the Mac. The root proof count and previously verified source/axiom receipts are unchanged. No competing project-owned compiler was active at start.

## New isolated Lean proof: direct symmetric determinant upper bound

Seven new declarations in `exploration/SymmetricFourDetTrial.lean` compile and pass a transitive axiom audit (only propext, Classical.choice, Quot.sound). They prove directly, without singular-value theory, the needed large-entry bound `‖det F‖ < productFourH * productFourS^3` for a symmetric zero-diagonal four-by-four normalized root matrix, including the actual simultaneous ring-valued sign choice. A stronger intermediate bound is `‖det F‖ < 6/25`. Exact records are in `records/direct-symmetric-four-det-20261016.md` and `local-logs/sym-zero-trial-final-20261016.log`.

**NOT INTEGRATED/NOT YET ACCEPTED AS A ROOT DEPENDENCY:** the remote file-move operation was blocked by the tool safety check. Consequently no new root build, source/import audit, installed leanchecker replay or GitHub push is claimed for these seven declarations. Preserve the saved exploration code. The adjugate operator-norm upper bound and mixed A>=1,B>=3 case remain open. Next: permitted integration and audits, then the adjugate bound.

## Latest verified proof unit: rank-one determinant and numerical closure

The new `RankOneDeterminantBound.lean` and `ScaledRootRankOneBound.lean` prove the complex bilinear L2 norm estimate and the exact rank-one determinant/adjugate inequality for invertible four-by-four matrices, including its precise transfer to the normalized root matrix. The transpose is algebraic, not conjugate; symmetry and Hermitian hypotheses are not introduced.

`ProductFourNumericalClosure.lean` proves the exact rational end-of-proof inequality for the A>=3 branch and the implication |det N|<D^2/2, hence D>2ABC, **conditional** on the still-open bounds |det F|<h*s^3 and ||adj F||_2<h*s^2 and the explicitly stated integral determinant lower bound. Its theorem types retain these hypotheses. The full `lem:product-four` is not yet proved.

Targeted module and integrated root builds: PASS (3011 root jobs, exit 0). Source/import audit: PASS (48 modules, 256 explicit theorems). The nine new theorems passed transitive axiom audit with only propext, Classical.choice and Quot.sound. Each of the three new modules separately passed installed Lean-kernel replay, exit 0. These are three targeted replays, not a fresh whole-project replay or an independent external checker. See `records/product-four-rankone-numerical-20261016.md` and the dated run records.

The next mathematical dependency is the genuine perturbative upper bounds on det F and adj F, followed by the mixed A>=1,B>=3 case. Bennett's all-orders identity, large graph completeness and the final sextuple exclusions remain OPEN.

All 18 selected files were staged successfully, and their staged diff and hashes checked. The new `git commit` command was blocked by the remote-tool safety guard, so this unit remains local and staged. No push was made. Starting local HEAD remains 8b686a8.

## Latest verified proof unit: reference perturbation and bounded inverse

`D1Bound5/ReferencePerturbation.lean` proves four new theorems. For H=(J₄-I₄)/2 and K=H⁻¹ it proves `det F ≠ 0` whenever `‖K(F-H)‖<1`, by a genuine normed-ring unit argument. Under the stronger numerical condition `‖F-H‖<1/8` it proves the strict bound `‖F⁻¹‖<8/3`. A separate corollary transfers nonsingularity and the inverse bound to the existing simultaneous symmetric sign choice over an arbitrary commutative coefficient ring, retaining all off-diagonal integral square identities.

The project source/import scan PASSED for 45 modules and 247 theorems. The integrated build returned exit 0 (3008 jobs). Targeted transitive axiom audit PASSED for all four new theorem declarations, with only propext, Classical.choice and Quot.sound. The installed Lean kernel replay of ReferencePerturbation returned exit 0. No new whole-root replay, fresh clean checkout, or independent reviewer is claimed.

This completes a quantitative inverse estimate required later for the four-by-four prefix in `lem:product-five`. It does NOT prove the upper determinant or adjugate perturbation bounds needed for `lem:product-four`. The weighted A>=1,B>=3 branch, arbitrary-order Bennett identity, finite graph coverage and bound-five theorem remain OPEN. See `records/reference-perturbation-20261016.md`.

Local verified commit `8b686a8` succeeded. GitHub repository visibility was confirmed PRIVATE, but the push was blocked by the remote-tool safety guard. The last verified remote main is `980cc19`. Do not claim these newest changes have been pushed.

## Latest verified proof unit: sharp reference inverse operator norm

`D1Bound5/ReferenceInverseNorm.lean` proves the exact complex L2
operator-norm identity `‖halfOffDiagonalInverse‖ = 2`. Its proof
constructs the symmetric involution R with diagonal 1/2 and off-diagonal
-1/2, verifies Rᴴ=R and R²=I, and uses K=-(2/3)I-(4/3)R.
For the lower bound K(I+R)=-2(I+R) and I+R≠0.
It also proves ‖K(F-H)‖<1 from the already verified hypothesis
‖F-H‖<3*(128/8649), where H=(J₄-I₄)/2.
At this earlier milestone no inverse estimate for F had been proved;
ReferencePerturbation above now supplies it. Upper determinant and adjugate
perturbation bounds and the completed lem:product-four remain open.

The integrated source build passed (3007 jobs, exit 0), as did
source/import audit (44 modules, 243 explicit theorems),
targeted transitive axiom audit of 10 new declarations
(only propext, Classical.choice, Quot.sound), and the installed
Lean kernel replay of ReferenceInverseNorm (exit 0).
No new clean checkout, full-project replay or external reviewer.
See records/reference-inverse-norm-20261016.md and the dated run record.

## Previous verified proof unit: exact reference determinant, inverse and adjugate

`ReferenceMatrixSpectral.lean` formalizes the reference matrix H=(J_4-I_4)/2. It proves HK=KH=I, where K has diagonal -4/3 and off-diagonal 2/3, and proves det H=-3/16 by the rank-one determinant lemma. It also proves adj H=(-3/16)K, with exact entries 1/4 (diagonal) and -1/8 (off diagonal). These statements do not assume the global bound-five theorem or any unproved spectral estimate.

Direct source elaboration, integrated root build (3006 jobs), source/import scan (43 modules, 234 explicit theorems), targeted transitive axiom audit (seven declarations) and installed Lean kernel replay of this new module all passed with exit 0. The only axiom dependencies found are propext, Classical.choice and Quot.sound. This is a targeted replay, not an independent checker or a new full clean-checkout proof. The root operator norm of K, determinant/adjugate perturbation bounds, weighted A>=1 branch, Bennett all-orders identity, finite graph completeness and final main theorem remain open. See `records/reference-matrix-spectral-20261016.md`.

## Previous verified proof unit: four-by-four L2 operator-norm estimate

`MatrixOperatorNorm.lean` proves `four_zero_diagonal_operator_norm_lt`:
for every 4x4 complex E with zero diagonal and all off-diagonal
entries of norm < delta, with delta>0, the L2 operator norm satisfies
||E|| < 3*delta. Symmetry is not required. The proof uses three
explicit perfect matchings, diagonal matrices and permutation matrices.
`RootMatrixOperatorBound.lean` proves the spectral estimate
||normalizedRootError-halfOffDiagonal|| < 3*(128/8649) and its
simultaneous integral symmetric-sign existence corollary, retaining
all original root-square relations in the source ring.

Pinned targeted build: exit 0, 2903 jobs. Integrated root build: exit 0,
3005 jobs. Source/import audit: PASS, 42 modules and 228 explicit theorems.
All three new exported theorem types and their transitive axioms were
audited (only propext, Classical.choice and Quot.sound). Both new
modules passed the installed Lean kernel replay, each with exit 0.
See records/matrix-operator-bound-proof.md and the run/check logs.
These are targeted replays, not a fresh whole-root replay. No complete
lem:product-four, determinant/adjugate bound, or bound-five proof is claimed.
The A>=1,B>=3 weighted operator-norm branch also remains open.


## Previous verified proof unit: simultaneous symmetric root-matrix signs

`RootMatrixSigns.lean` adds four proved theorems and one definition.
For an arbitrary commutative ring R and ring map f:R->C, a symmetric
4x4 root matrix with diagonal entries a_i and
M_ij^2=a_i*a_j+1, under |f(a_i)f(a_j)|>=9 for i!=j, admits one
simultaneous choice of all four complex square roots u_i and six
symmetric signs S_ij=+/-M_ij. The signed matrix stays in R, has
S_ii=a_i, preserves every off-diagonal square, and its normalized
corrections satisfy |e_ij|<16/31 and |e_ij-1/2|<128/8649.
No nonzero-root, distinct-modulus or analytic square-root branch
assumption is added.

Source/import audit: PASS, 40 modules and 225 explicit theorems.
Integrated lake build: exit 0 (2988 jobs). Targeted transitive axiom
audit: PASS for the new five project declarations, allowing only
propext, Classical.choice and Quot.sound. Bundled Lean kernel replay
of RootMatrixSigns: exit 0. Whole-root repeat axiom audit, whole-root
kernel replay and fresh clean checkout were not performed on this
snapshot. The accepted earlier milestones remain distinct.
See records/root-matrix-signs-proof.md and the dated run receipts.

Next: prove the operator-norm bound for E=F-(J-I)/2 using
the entrywise estimates, then adjugate and determinant upper bounds
in lem:product-four. The A>=1,B>=3 mixed-row branch remains separate.
MainStatement remains only a proposition specification.

## Previous verified proof unit: uniform complex root-error bounds

`RootErrorMagnitude.lean` proves five new theorems selecting signs of
complex square roots t²=x(x+1). The resulting corrections e satisfy:

- |x|>=3: |e|<5/9, |e-1/2|<25/486.
- |x|>=9: |e|<16/31, |e-1/2|<128/8649.
- |x|>=12: |e|<7/13, |e-1/2|<1/64.

The arbitrary-margin version is also proved, as is the transfer to a
scaled product u*r*v. These close the scalar branch-selection and
entrywise error estimates needed in lem:product-four. Simultaneous
matrix choices, spectral norm/determinant upper bounds and the main
theorem remain unproved.

Integrated build exit 0 (2987 jobs), source audit PASS for 39 modules
and 221 explicit theorems, targeted axiom audit PASS for all five new
theorems, and installed Lean kernel replay of the new module exit 0.
Only propext, Classical.choice and Quot.sound occur. A fresh whole-root
kernel replay and clean-checkout build have not been performed.
See records/root-error-magnitude-proof.md and the run records.

## Previous verified proof unit: determinant normalization

The algebraic content of (integrated-1) and (integrated-2) now has
seven compiled Lean theorems in `DeterminantNormalization.lean`.
This extends the root import to 38 modules and 216 explicit theorems.
Targeted module build, integrated root build and source/import coverage
all exited 0. The targeted transitive axiom audit passed for all 11
new project declarations, and the new module's installed Lean kernel
replay exited 0. No extra axioms occur beyond propext,
Classical.choice and Quot.sound.

These are polynomial identities over arbitrary commutative rings,
including zero roots. The complex division identity assumes only that
the pair product is nonzero. At that preceding milestone analytic branch
selection was open; the latest module closes its scalar estimates.
Matrix determinant bounds, lem:product-four and the main theorem remain OPEN.
A whole-root repeat of the 420-declaration axiom audit and full kernel
replay for this enlarged snapshot has not yet been performed.
See records/determinant-normalization-proof.md and the latest run record.

## Previous fully audited local milestone

37 Lean modules; 209 explicit theorem declarations; 420 project declarations
covered by the transitive axiom audit. The whole integrated build, source
policy/import-coverage scan and axiom audit all PASS with exit 0. The only
allowed axiom dependencies are propext, Classical.choice and Quot.sound.
A targeted replay of TEN modules also completed with exit 0. Its precise
module list and command are in records/recovery-kernel-20261015.json.
This is the installed Lean kernel, not an independent implementation.
No whole-project fresh replay or new clean checkout is claimed.

## Newly closed mathematical obligations

1. Exact full-ring square testing and exhaustive closed norm disks.
2. ALL THIRTY normalized finite small-tail models, with kernel-checked
   explicit-list completeness and full Boolean exclusions.
3. COMPLETE lem:tail-irregular in every imaginary quadratic full integer
   ring: ordered D(1) quadruple with B>=3 => irregular last triple and
   D>2BC. The auxiliary C>=4 restriction has been removed.
4. Even-dimensional root-matrix determinant nonsingularity in every
   quadratic number field, plus |det(M)|>=1 in the imaginary case.
   The reduction modulo two works with zero divisors. This is NOT
   Bennett's arbitrary-order determinant identity.

The previous full-ring bridge, norm bridge and analytic C>=4 branch are
reused. The four analytic sources are byte-identical to private source
commit 3a8f9ff. The current tested proof source is commit 62292f0. Merge
commit a91af24 preserves independent remote paper/verification additions
without changing any Lean source or build configuration. Later record-only
commits do not change this tested source. See the hash manifests.

## Next mathematical action

Proceed to the analytic determinant size bounds in lem:product-four,
then the remaining structural gap/interpolation/approximation arguments.
Do NOT redo the full-ring bridge, small-tail enumeration, full tail lemma,
or even-dimensional arithmetic nonsingularity. The main theorem remains
only a proposition specification, not a proved theorem.

Bennett's all-orders determinant identity, large graph/Pell exclusions with
complete descent/coverage proofs, and all three main sextuple exclusions
remain open. An inherited negative-rational-square wrapper needs stronger
statement packaging before use as a uniform fixed-field classification;
neither new main lemma depends on it. See records/statement-review.md.

## Validation and recovery

Read records/build-record.md, records/paper-to-lean.md,
records/open-obligations.md, and the latest records/runs entry. The direct
recovery invocation has finished its proof unit and saved the results.
No owned compiler/checker is intentionally left running. Inspect live state
before starting another heavy process. Use one compiler/checker at a time.
The 40-theorem historical checkpoint passed a clean checkout; a new clean
checkout of this larger milestone and an independent statement review have
NOT been performed. Those remain final release gates.

Lean 4.33.1; mathlib 0df444a360eaa60ab8c11dca51a86af692955474;
user-local Python 3.12.15. PRIVATE repository tomislav-math/d1-bound5-lean.
No manuscript edit, Freiman change, paid agent, public release or Prove2Me
mission was made. The original frozen manuscript hash is unchanged.
The hourly task was updated and retained enabled; its earlier platform
failure cause is unknown. See records/automation-repair-20261015.md.

## 16 October 2026 — complete adjugate index coverage (isolated)

The new `exploration/AdjugateCoverageTrial.lean` proves all 16 adjugate cofactor formulas and the required operator-norm upper bound for every symmetric zero-diagonal complex 4x4 matrix with off-diagonal entries within 128/8649 of 1/2. Three new theorems passed compilation, standard transitive axiom audit and installed Lean kernel replay (all exit 0). This is NOT root-integrated; the previous 48-module/256-theorem integrated inventory is unchanged. Transfer to the signed-root normalized matrix, the mixed A>=1,B>=3 branch, Bennett's identity and the final bound-five theorem remain OPEN. See `records/runs/20261016T052800Z-adjugate-integration-FINISH.md`.

## 16 October 2026 — determinant and adjugate with ONE signed root choice

The direct four-by-four symmetric zero-diagonal determinant bound is now root-integrated and fully proved by an explicit polynomial estimate, without singular-value theory. For six entries within 128/8649 of 1/2, it gives `||det F||<h*s^3` with h=8905/5766 and s=3139/5766. More importantly, `exists_signed_root_matrix_det_and_adjugate_upper` simultaneously proves both `||det F||<h*s^3` and `||adj F||<h*s^2` for the SAME symmetric sign choice over the original commutative ring. Eight new theorems, 54 root-imported modules and 276 explicit proved theorems. Integrated build, separate transitive axiom audit, both targeted kernel replays, source/import audit and source/tool SHA256 checks all exited zero. No clean-checkout or independent review was run.

The arithmetic determinant lower-bound and squared-size vector estimate must still be assembled into the large-entry branch of `lem:product-four`. The separately weighted A>=1,B>=3 branch, Bennett identity, finite descent/coverage and sextuple exclusions remain OPEN. `MainStatement` is not yet a theorem.

## 16 October 2026 — uniform arithmetic determinant lower bound

The new root-imported module `D1Bound5/RootDeterminantLower.lean` proves three theorems, including an exact determinant-norm factorization for any finite matrix over any commutative ring mapped to ℂ, and its unconditional full-integer-ring specialization in every **even** dimension for imaginary quadratic fields. From only the diagonal and pairwise square-root conditions it proves
`∏ i, ‖phi (a i : K)‖ ≤ ‖det (scaledRootMatrix u (M.map (phi.comp (algebraMap (𝓞 K) K))))‖`.
All zero-root and tied-modulus cases remain allowed; no additional arithmetic hypotheses were inserted. The integrated pinned build exited 0 (3018 jobs); source/import audit PASS (55 modules, 279 theorems); transitive axiom audit PASS for all three new theorems with only propext, Classical.choice, Quot.sound; targeted installed Lean-kernel replay exited 0. Both SHA256 manifest checks exited 0. See `records/root-determinant-lower-20261016.md` and the run records. No clean-checkout or independent reviewer was used.

Still needed: identify the ordered `A B C D` product and square-size vector bound for the SAME chosen signed-root matrix, use existing perturbative upper estimates to close the A>=3 growth branch, then prove mixed A>=1,B>=3, Bennett and finite-graph exclusions. MainStatement remains UNPROVED.

## 16 October 2026 — product-four A>=3 branch closed at root-matrix level

`D1Bound5/ProductFourLargeBranch.lean` has three root-integrated, kernel-replayed and transitive-axiom-audited theorems. The main new result `full_ring_productFour_large_growth` proves D>2ABC in EVERY imaginary quadratic full ring for an ordered symmetric integral root matrix with A>=3 and the already-proved weaker tail growth 2BC<D. The SAME integral sign choice satisfies determinant and adjugate upper estimates, and full-ring scaled determinant lower bound. The squared-size estimate and D>18 are formally discharged. Integrated build PASS (3019 jobs), audit PASS (56 modules, 282 explicit theorems), 3/3 axiom PASS with only standard allowed axioms, targeted same-kernel replay PASS, source/tools manifest checks PASS. No clean checkout or independent reviewer.

The symmetric-root-matrix construction from an arbitrary `IsD1Tuple` should be packaged explicitly; the remaining weighted A>=1,B>=3 case, Bennett arbitrary-order determinant, finite completeness and final sextuple exclusion are OPEN. `MainStatement` remains a proposition.

## 16 October 2026 — isolated tuple-to-symmetric-root-matrix bridge

Saved `exploration/TupleRootMatrixBridgeTrial.lean` (SHA256 `18bf68c70f7461d132ff1bb7a87d58364bb611e213e0471f018bd1b883568dd6`). A generic theorem constructs a symmetric original-ring root matrix from any indexed `IsD1Tuple` (all finite sizes), and a second theorem combines the proven complete tail lemma with the A>=3 matrix-level product-four theorem, proving `D>2ABC` for an ordered D(1) quadruple with smallest modulus >=3, without matrix/tail assumptions. Trial elaboration EXIT 0, .olean compilation EXIT 0, installed same-kernel replay EXIT 0. The original first trial EXIT 1 was repaired. Axiom print/audit is not complete: a stdin call failed because `lean -` is unsupported, and the corrected invocation was blocked by an external safety check before execution. Attempts to integrate/move the trial into the root source were likewise blocked before execution. Consequently this is NOT a root-accepted theorem; root inventory remains 56 modules, 282 explicit theorems. No root rebuild, source/import audit or independent verification in this invocation. Next: root-integrate and audit this bridge when tool access permits; then address the weighted A>=1,B>=3 case. MainStatement remains UNPROVED.

## 16 October 2026 — accepted tuple-to-matrix bridge (hourly continuation)

`D1Bound5/TupleRootMatrixBridge.lean` is now ROOT-INTEGRATED, replacing the previously isolated proof with byte-identical content. Two proved theorems construct a symmetric original-ring root matrix from any indexed `IsD1Tuple` and prove the A>=3 branch `D>2ABC` for actual ordered D(1) quadruples in every imaginary quadratic full integer ring, without separate matrix/tail hypotheses. Integrated build EXIT 0 (3020 jobs); dedicated exact-type and transitive axiom audit EXIT 0; installed same-kernel replay EXIT 0; source/import audit EXIT 0 (57 modules, 284 explicit proved theorems); both SHA256 manifests checked EXIT 0. No full clean-checkout replay or independent review. See `records/tuple-root-matrix-bridge-20261016.md` and `records/runs/20261016T091135Z-hourly11-FINISH.md`.

Remaining: weighted A>=1,B>=3 branch of product-four, product-five, genuine Bennett arbitrary-order determinant, certified finite graph/descent coverage and final sextuple exclusions. `MainStatement` remains a proposition, UNPROVED.
