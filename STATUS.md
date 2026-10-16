# Status

2026-10-16. IN PROGRESS. MAIN THEOREM UNPROVED.

## Latest verified proof unit: reference perturbation and bounded inverse

`D1Bound5/ReferencePerturbation.lean` proves four new theorems. For H=(J₄-I₄)/2 and K=H⁻¹ it proves `det F ≠ 0` whenever `‖K(F-H)‖<1`, by a genuine normed-ring unit argument. Under the stronger numerical condition `‖F-H‖<1/8` it proves the strict bound `‖F⁻¹‖<8/3`. A separate corollary transfers nonsingularity and the inverse bound to the existing simultaneous symmetric sign choice over an arbitrary commutative coefficient ring, retaining all off-diagonal integral square identities.

The project source/import scan PASSED for 45 modules and 247 theorems. The integrated build returned exit 0 (3008 jobs). Targeted transitive axiom audit PASSED for all four new theorem declarations, with only propext, Classical.choice and Quot.sound. The installed Lean kernel replay of ReferencePerturbation returned exit 0. No new whole-root replay, fresh clean checkout, or independent reviewer is claimed.

This completes a quantitative inverse estimate required later for the four-by-four prefix in `lem:product-five`. It does NOT prove the upper determinant or adjugate perturbation bounds needed for `lem:product-four`. The weighted A>=1,B>=3 branch, arbitrary-order Bennett identity, finite graph coverage and bound-five theorem remain OPEN. See `records/reference-perturbation-20261016.md`.

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
