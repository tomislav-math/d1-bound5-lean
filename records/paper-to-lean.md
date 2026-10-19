# Paper-to-Lean inventory

## 17 October 2026 — cross-block, coherent interpolation and first-order Bennett verified

Seven new root-imported modules prove 45 exported theorems (plus 3 private cross-block helpers) and add 8 public definitions. The new results are the full-ring cross-block determinant lower bound; exact convergent coherent interpolation, manuscript tail estimate and coherent-root compatibility; the arbitrary-size k=1 Bennett determinant with explicit entries and nonvanishing; the conditional all-order determinant/degree and simple-residue coefficient principles; and the local inverse-power binomial expansion.

All seven standalone pinned module builds, the integrated root build, the exact 53-declaration type/transitive-axiom audit, the whole-project transitive-axiom audit and the source/import scan passed. Fresh whole-root leanchecker replay also passed in the SAME installed Lean kernel, with source SHA256 equality before and after replay. Only propext, Classical.choice and Quot.sound are permitted by the enforced audits. Independent source/statement review of all seven exact final module bodies passed. No fresh clean-checkout or independent kernel implementation was used.

The new work does NOT close the arbitrary-order Bennett determinant: concrete residue cancellation/decomposition, the node-removal recurrence and the nonzero determinant constant remain open. The integral coherent linear form and nonvanishing, quantitative approximation and cross-block upper bounds, complete finite certificates/descent, the three final sextuple branches and MainStatement remain UNPROVED. The full-ring product-four and product-five tuple growth endpoints were already proved and remain unchanged.

The public manuscript body matches frozen v4; only PDF metadata and date differ. The two requested hourly automations remain paused. Previous unsynchronized work was privately pushed in d7ba2c337d76df8e081ac8e299f48a019e0d2791 and fd0c8b471614a4b8c5a110a830524c973758e4aa. Publication of this new accepted snapshot requires the separate verified push receipt.

All names below are in namespace `D1Bound5`. Nested prefixes are retained.
The accepted build commands, exact code commits and audit results are recorded
in `build-record.md`. No row below claims the main theorem is proved.

| Declaration | Source / purpose |
|---|---|
| `IsD1`, `IsD1Tuple` | Section 1, exact finite-set and indexed definitions |
| `MainStatement` | `thm:main`, proposition only, NOT proved |
| `IsD1Tuple.productFive_growth` | `lem:product-five`, FULL ordered five-entry growth `D>3ABSC`, root-proved 17 October 2026 |
| `IsD1Tuple.five_compatible_schur_det_small` | Actual same-sign original-ring Schur determinant `|det G|<1/3` |
| `IsD1Tuple.five_compatible_schur_near` | Actual same-sign original-ring Schur proximity `‖G-H‖₂<1/2` |
| `IsD1Tuple.exists_five_signed_schur_witness` | One compatible five-entry original-ring witness for prefix and Schur estimates |
| `productFive_prefix_l2_lt_last_div_nine` | Prefix norm bound from last-four product growth |
| `productFive_cross_div_norm_lt_11_108` | Complex bilinear cross bound without Hermitian assumptions |
| `IsD1.subset` | Passing to a subset in the sextuple reduction |
| `IsD1.map_equiv` | Ring equivalences preserve D(1) |
| `IsD1.neg` | Simultaneous negation symmetry |
| `square_integers_iff_field` | Section 1, roots in the field are integral |
| `isD1_iff_field_roots` | Section 1, equivalence of square-root conventions |
| `IsD1.exists_ordered_sextuple` | Final proof, actual selection and sorting, including ties |
| `IsD1Tuple.isD1_image` | Converse indexed-to-finite-set passage |
| `IsD1Tuple.card_image` | Exact cardinality from injectivity |
| `card_bound_iff_no_ordered_sextuple` | Exact equivalence, not the exclusion itself |
| `regularDefect` | Symmetric polynomial in Section 2 |
| `regularDefect_swap` | Symmetry of regularity under first transposition |
| `regularDefect_cycle` | Symmetry of regularity under cyclic permutation |
| `extension_product` | Algebraic identity starting `lem:irregular-growth` |
| `irregular_extensions_ne_zero` | Nonvanishing of both algebraic extensions |
| `QuadInt`, `QuadInt.discriminant` | Model omega^2=tau*omega-nu, Delta=4nu-tau^2 |
| `QuadInt.norm_formula` | `eq:integrated-disk` / `eq:pr-ring-arithmetic` |
| `QuadInt.four_norm` | Completed-square identity in `eq:integrated-disk` |
| `QuadInt.norm_nonneg` | Norm nonnegativity for positive Delta |
| `QuadInt.norm_eq_zero_iff` | Definiteness of the coordinate norm |
| `QuadInt.norm_pos` | Nonzero coordinate elements have positive norm |
| `QuadInt.one_le_norm` | Integral nonzero norms are at least one |
| `QuadInt.discriminant_le_four_bound` | Nonreal bounded-norm entries bound Delta |
| `NoSquareResidues` | Finite two-equation modular square obstruction |
| `not_square_of_residues` | Soundness of the modular checker for all integral roots |
| `small_tail_q2_first` | `lem:tail-irregular`, row 1, target 1+4omega, modulus 3 |
| `small_tail_q2_second` | Same lemma, row 2, target -10+4omega, modulus 5 |
| `small_tail_q3` | Same lemma, row 3, target 22, modulus 4 |
| `small_tail_q6` | Same lemma, row 4, target -27, modulus 5 |
| `small_tail_q11` | Same lemma, row 5, target -14, modulus 4 |
| `small_tail_q35` | Same lemma, row 6, target -38, modulus 4 |
| `mutate` | `sm:bs7-mutation`, the plus transformation |
| `mutate_roots` | `sm:bs7-descent`, transformed square-root identities |
| `mutate_reverse` | Same lemma, inverse recovers the extension |
| `mutate_reverse_roots` | Same inverse also recovers chosen roots |
| `forbidden_interval_chain` | `sec:common-intervals`, logical chain argument |
| `scaled_power_unbounded` | Geometric lower endpoints exceed any fixed candidate |
| `geometric_forbidden_interval_chain` | All-orders geometric chain assembly |
| `transfer_forbidden_interval` | `eq:pr-transfer`, exact closed-interval transfer |
| `QuadInt.three_le_discriminant` | Positive integral quadratic discriminants are at least three |
| `one_three_integer_obstruction` | Integral conic contradiction in `lem:pr-one-three` |
| `one_three_im_zero` | Common extensions of 1 and 3 have zero imaginary coordinate |
| `one_three_common_extension_is_integer` | Rationality part of `lem:pr-one-three` in every positive-discriminant coordinate model |
| `zero_square_pair` | Regression: {-1,1}, zero root and equal absolute values |
| `half_integral_basis_square` | Regression: omega^2=omega-1 in tau=nu=1 |

There are 40 explicit proved theorems in this milestone, in addition to the
definitions and generated helper declarations. The six modular results use
kernel `decide` after a proved checker-soundness lemma, not Python or native
evaluation. Their preceding enumeration is still an open obligation.

The coordinate-to-full-ring bridge, analytic estimates, arbitrary-order
Bennett determinant identity, complete graph and Pell calculations, and
three major exclusions remain open; see `open-obligations.md`.

## Continuation: full-ring bridge and irregular growth

The new full-ring modules are individually and integrally compiled; their
full continuation audit is recorded separately. The construction proves
existence of the full integral coordinate models, not an assumed bridge.

| Declaration | Source / purpose |
|---|---|
| `integral_basis_one_gcd` | Section 1: coordinates of one form a primitive pair in every full integral basis |
| `exists_integral_generator` | Section 1: bijective integer coordinates n+m*omega for the full ring |
| `exists_quadratic_ring_equiv` | Full-ring equivalence before trace normalization |
| `exists_normalized_quadratic_ring_equiv` | Full-ring coordinates with tau=0 or 1 |
| `QuadInt.shift`, `QuadInt.discriminant_shift` | Integral generator translation and unchanged discriminant |
| `QuadInt.complex_image` | Formula for every complex image of a coordinate element |
| `QuadInt.complex_generator_parameters` | Real part, norm and positive-discriminant relation for the generator |
| `QuadInt.discriminant_pos_of_complex_embedding` | Positivity derived from a nonreal embedding |
| `QuadInt.norm_sq_complex_image` | Coordinate norm equals squared complex modulus |
| `QuadInt.complex_im_zero_iff` | Reality exactly means vanishing second coordinate |
| `full_ring_generator_nonreal` | A full-ring generator has nonreal image in a totally complex field |
| `exists_imaginary_quadratic_ring_equiv` | All imaginary quadratic fields have positive-discriminant full-ring coordinates |
| `norm_sq_full_ring_equiv` | Complex norm transported along the full-ring equivalence |
| `one_le_norm_integer` | Section 1: every nonzero algebraic integer has modulus at least one |
| `integral_of_quadratic_relation` | Integrality from an integer monic quadratic |
| `square_division_in_full_ring` | Maximality without unique factorization |
| `squarefree_trace_zero_parameter` | Squarefree d in the tau=0 full-ring case |
| `squarefree_trace_one_discriminant` | Squarefree d=Delta in the tau=1 full-ring case |
| `trace_zero_parameter_not_three_mod_four` | Half-integral cases cannot be omitted by using a proper suborder |
| `exists_full_integer_coordinates` | Full classification covering EVERY imaginary quadratic field |
| `QuadInt.algebra_norm_eq` | Polynomial coordinate norm equals determinant-defined algebraic norm |
| `algebra_norm_ring_equiv` | Integral norm invariant under the full-ring equivalence |
| `norm_sq_eq_absolute_norm` | Absolute field norm equals squared modulus at every complex embedding |
| `full_ring_one_three_common_extension_is_integer` | Rationality part of lem:pr-one-three, now in every full integer ring |
| `extension_norm_quadratic` | Complex-norm estimate underlying eq:irregular-quadratic |
| `extension_coarse_quadratic` | Coarse quadratic q(C)>=0 in lem:irregular-growth |
| `monic_quadratic_neg_between` | Closed-interval quadratic convexity, including endpoints |
| `growth_quadratic_negative` | Exact endpoint inequalities for 3<=A<=B<=C<=2AB |
| `irregular_quadratic` | Original eq:irregular-quadratic in every imaginary quadratic full ring |
| `irregular_growth` | Complete lem:irregular-growth, C>2AB, with modulus ties allowed |

The 70-theorem continuation closes the full-ring bridge and the first
structural growth lemma. The main bound-five theorem remains unproved.

## Recovery continuation: complete tail lemma and even determinant

The earlier milestones above are historical. The full-ring bridge remains
closed. All thirty finite models and the complete lem:tail-irregular now
have compiled proofs without an extra unproved certificate assumption.
Consult recovery validation receipts for the current acceptance gates.

| Declaration / module | Source and exact purpose |
|---|---|
| `QuadInt.square_coordinates`, `rootCandidate_complete`, `squareRoot_sound`, `squareRoot_complete`, `hasSquareRoot_iff` | Exact necessary-and-sufficient square test, including zero, at arbitrary input size |
| `QuadInt.mem_disk_iff` | Exact exhaustive closed norm disk, including zero and boundary |
| `coordinate_mul_eq_zero`, `regular_completion_cases` | Positive-discriminant domain and BOTH regular completion signs |
| `smallTailCheck_sound`, `small_tail_discriminant_bound` | Finite-check soundness, complete edge coverage and Delta<=60 |
| `small_tail_parameter_range` | Normalized parameter rectangle tau=0/1, 1<=nu<=15 |
| `smallTailCheck_of_explicit_list` | Explicit list coverage plus the Boolean checker implies full `SmallTailCheck` |
| `tailDisk_t_n_eq`, `tailDisk_t_n_checked`, `smallTailExplicit_t_n` | Kernel-checked disk identities and finite exclusions, for 29 models |
| `small_tail_015` | Earlier kernel-checked remaining model (0,15) |
| `smallTailCheck_rectangular` | Unconditional combination of all THIRTY models |
| `IsD1Tuple.tail_irregular_of_lt_four` | Finite C<4 case transferred to every full imaginary quadratic integer ring |
| `IsD1Tuple.tail_irregular_and_growth` | Complete lem:tail-irregular: B>=3 => irregular (b,c,d) and D>2BC |
| `det_identity_plus_two_rank_one` | det(I+J+vv^t)=(1+n)(1+sum v_i^2)-(sum v_i)^2 over any commutative ring |
| `even_root_matrix_det_sq_char_two` | Even-size root determinant squares to one in characteristic two |
| `quadraticReductionTwo` | Explicit nontrivial coefficient reduction modulo two |
| `even_root_matrix_det_ne_zero` | Arithmetic nonsingularity before lem:product-four, every quadratic number field |
| `even_root_matrix_one_le_norm` | |det(M)|>=1 for imaginary quadratic full integer rings |
| `rational_integer_square_cases`, `negative_integer_square_trace_zero`, `negative_integer_square_trace_one`, `positive_integer_square_is_integer` | Rational square conditions, with both integral bases |
| `full_ring_positive_integer_square`, `full_ring_negative_integer_square` | Coordinate rational-square conditions transported to the full rings |

The analytic C>=4 proof modules are byte-identical to their previously
accepted private-branch source at 3a8f9ff. The explicit-data generator is
untrusted; Lean separately proves its output's coverage and consequences.
Most added theorem declarations are finite certificate components, not
independent large mathematical results. Bennett's all-orders identity,
analytic determinant size estimates and the main theorem remain OPEN.

## Determinant normalization continuation (15 October 2026)

All declarations below are in `D1Bound5/DeterminantNormalization.lean`
and are compiled, with targeted axiom audit and kernel replay passing.

| Declaration | Manuscript role |
|---|---|
| `scaledRootMatrix`, `normalizedRootError` | Polynomial definitions of N and F in (integrated-1) |
| `scaledRootMatrix_det` | Determinant of diag(u) M diag(u) in arbitrary finite dimension |
| `root_error_quadratic`, `normalizedRootError_relation` | Denominator-free form of (integrated-2), all commutative rings |
| `normalizedRootError_diag` | F has zero diagonal even if entries vanish |
| `scaledRootMatrix_eq_rankOne_add_error` | N = aa^T + F |
| `normalizedRootError_det` | det N = (prod a_i) det M |
| `root_error_sub_half` | Complex identity F_ij-1/2=-F_ij^2/(2a_i a_j) for nonzero pair product |

Seven explicit theorems, two named definitions. The transitive audit
covered all eleven generated/name-prefixed declarations in the module.
The analytic inequalities needed to derive lem:product-four are still open.

## Root-error magnitude continuation (15 October 2026)

Five compiled, axiom-audited and kernel-replayed theorems in `D1Bound5/RootErrorMagnitude.lean`.

| Declaration | Role |
|---|---|
| `exists_root_error_control` | General branch/sign selection and near-half correction for complex roots |
| `exists_small_root_error` | Bounds 16/31 and 128/8649 for pair-product modulus at least 9 |
| `exists_small_normalized_root_error` | Transport to scaled integral-root products |
| `exists_root_error_three` | First-row constants 5/9, 25/486 at modulus at least 3 |
| `exists_root_error_twelve` | Later-row bounds 7/13, 1/64 at modulus at least 12 |

Pointwise sign choices are proved here. Their simultaneous symmetric matrix assembly is proved in the subsequent RootMatrixSigns module. Spectral and determinant upper bounds remain open.

## Simultaneous symmetric four-by-four signs (15 October 2026)

Four new compiled theorems and one definition in `D1Bound5/RootMatrixSigns.lean`,
covered by targeted axiom audit and module-specific Lean kernel replay.

| Declaration | Manuscript role |
|---|---|
| `SignedEntryGood` | Precise pair of complex error inequalities for a signed off-diagonal ring root |
| `signed_entry_good_or_neg` | At least one of the two integral signs satisfies both inequalities |
| `signed_entry_good_swap` | Interchanging endpoints does not change normalized errors |
| `exists_good_symmetric_root_matrix` | Simultaneous symmetric choices of six integral off-diagonal signs given four complex diagonal roots |
| `exists_good_symmetric_root_matrix_with_roots` | Chooses the four complex roots as well; retains symmetric ring-valued entries and the two uniform constants |

This covers the `A>=3` sign-normalization step in `lem:product-four`
when every pair product has complex modulus at least 9. The mixed-row
`A>=1, B>=3` normalization and spectral/adjugate determinant estimates
are still open. The final bound-five theorem is not proved.

## Exact reference determinant and cofactors (16 October 2026)

The new module `D1Bound5/ReferenceMatrixSpectral.lean` has six proved theorems and one definition. They are compiled, target-audited and kernel-replayed successfully.

| Declaration | Manuscript role |
|---|---|
| `halfOffDiagonalInverse` | Explicit inverse of H=(J_4-I_4)/2 |
| `halfOffDiagonal_mul_inverse`, `inverse_mul_halfOffDiagonal` | Both inverse identities, including all sixteen matrix entries |
| `halfOffDiagonal_det_ne_zero` | Exact nonsingularity of reference matrix |
| `halfOffDiagonal_det` | det H=-3/16 via rank-one determinant lemma |
| `halfOffDiagonal_adjugate` | adj H=(-3/16)H^{-1} |
| `halfOffDiagonal_adjugate_apply` | Exact reference cofactors, diagonal 1/4 and off diagonal -1/8 |

The singular-value and upper-perturbation inequalities remain open. Exact proof log: `records/reference-matrix-spectral-20261016.md`.

## Four-by-four operator-norm estimate (16 October 2026)

`D1Bound5/MatrixOperatorNorm.lean` contains `four_zero_diagonal_operator_norm_lt`. It proves `‖E‖ < 3*δ` for every 4×4 complex zero-diagonal matrix with all off-diagonal moduli `<δ`, without assuming symmetry. Its three explicit fixed-point-free permutation matchings provide an exact finite entry decomposition.

`D1Bound5/RootMatrixOperatorBound.lean` defines `halfOffDiagonal` and proves `signed_root_matrix_operator_bound` and `exists_signed_root_matrix_operator_bound`. They transport the prior `SignedEntryGood` estimates and simultaneous symmetric integral sign choices to the spectral bound `‖normalizedRootError - halfOffDiagonal‖ < 3*(128/8649)`. The original ring-valued square relations are preserved.

Both modules are compiled, three exposed theorem types and transitive axioms are audited, and both modules have exit-zero installed-Lean-kernel replays. These results supply the A>=3 spectral-perturbation step of `lem:product-four`; they do not yet prove singular-value/adjugate determinant bounds or the mixed A>=1 branch.

## Sharp inverse norm and contraction (16 October 2026)

`D1Bound5/ReferenceInverseNorm.lean` contains eight new theorems and one
matrix definition, with an additional perturbation corollary (nine
theorems total). They were integrated, source-audited, transitive-axiom-audited
and replayed by the installed Lean kernel.

| Declaration | Manuscript role |
|---|---|
| `referenceReflection` | Explicit symmetric Householder-type involution R with diagonal 1/2 and off diagonal -1/2 |
| `referenceReflection_sq`, `referenceReflection_conjTranspose` | R²=I and Rᴴ=R |
| `referenceReflection_norm` | Exact L2 operator norm ‖R‖=1 |
| `halfOffDiagonalInverse_decompose` | K=-(2/3)I-(4/3)R |
| `halfOffDiagonalInverse_norm_le` | Upper spectral bound ‖K‖≤2 |
| `halfOffDiagonalInverse_mul_reflection_plus_one` | Nonzero eigenspace witness K(I+R)=-2(I+R) |
| `halfOffDiagonalInverse_norm_ge`, `halfOffDiagonalInverse_norm` | Sharp norm ‖K‖=2 |
| `reference_inverse_error_norm_lt_one` | From ‖F-H‖<3*128/8649 derive ‖K(F-H)‖<1 |

This provides the exact reference inverse norm and Neumann-resolvent
smallness input for the A>=3 branch of `lem:product-four`. Neither
inverse bounds for general F nor the required determinant and adjugate
upper estimates are yet formalized. The mixed-row A>=1,B>=3 branch
and main bound-five theorem remain OPEN.

## Matrix perturbation: nonsingularity and inverse norm (16 October 2026)

`D1Bound5/ReferencePerturbation.lean` contains four newly accepted theorems:

| Declaration | Mathematical role |
|---|---|
| `reference_perturbed_det_ne_zero` | `‖K(F-H)‖<1` implies `det F≠0`, using a proved Banach-algebra unit theorem |
| `reference_perturbed_det_ne_zero_of_near` | The previous uniform `3*(128/8649)` error bound implies `det F≠0` |
| `reference_perturbed_inverse_norm_lt` | `‖F-H‖<1/8` implies the strict bound `‖F⁻¹‖<8/3` |
| `exists_signed_root_matrix_with_bounded_inverse` | Applies these conclusions to an actual simultaneous symmetric ring-valued sign choice, retaining pair-square identities |

The new module and integrated project compiled with exit 0, the 45-module source/import audit passed, all four explicit theorem types and transitive axioms passed, and the new module passed the installed Lean kernel replay. The A>=1 mixed-row upper operator bound, determinant and adjugate upper estimates, and full lemma `lem:product-four` remain open. See `records/reference-perturbation-20261016.md`.


## Rank-one determinant and numerical closure (16 October 2026)

The following nine theorems are compiled, transitive-axiom audited, and individually kernel-replayed through their three containing Lean modules.

| Declaration | Manuscript role |
|---|---|
| `bilinear_mulVec_norm_le` | Non-Hermitian complex bilinear quadratic-form bound by L2 matrix operator norm |
| `rankOneDeterminant` | Rank-one determinant lemma, with det F nonzero |
| `adjugate_eq_det_smul_inverse` | Cofactor/inverse identity |
| `rankOneDeterminant_norm_le` | Determinant bound through the inverse norm |
| `rankOneDeterminant_adjugate_norm_le` | Determinant bound in the adjugate form used by (integrated-1) |
| `scaledRootMatrix_det_adjugate_norm_le` | Exact transport to the normalized/scaled root matrices |
| `productFour_numeric` | Exact rational terminal inequality for the A>=3 case |
| `productFour_rankOne_numeric` | Derives |det N|<D^2/2 from explicit det/adjugate upper-bound hypotheses |
| `productFour_growth_from_bounds` | Derives D>2ABC also assuming the integral determinant lower bound |

The last two statements remain conditional. They do not prove `lem:product-four`; its upper perturbative determinant/adjugate hypotheses and the mixed-row branch remain open. The source audit counts 48 modules and 256 explicit proved theorems. Root build, targeted axiom audit, and three individual Lean kernel replays each exited 0.

## Direct determinant upper-bound trial (2026-10-16; compiled, NOT root-integrated)

Seven source declarations are preserved under `exploration/SymmetricFourDetTrial.lean`: `symmetricZeroFour_det` (the symmetric zero-diagonal four-by-four determinant polynomial), `nearHalf_product_nearQuarter` (pair-product error), `threePairDetPolynomial_bound` (uniform complex polynomial bound), `symmetricZeroFour_det_norm_lt` (explicit six-entry bound), `symmetric_zero_four_det_upper` (general matrix bound), `signed_root_matrix_det_upper` (transport to normalized integral matrix), and `exists_signed_root_matrix_det_upper` (complete simultaneous sign choice with the determinant upper bound). All seven compile without extra axioms; the transitive audit PASS is in `local-logs/sym-zero-trial-final-20261016.log`. These seven are **not included in the integrated root theorem count** because the safety guard blocked moving the source into an accepted module; no integrated source audit or leanchecker replay is claimed. The adjugate norm bound and full `lem:product-four` remain open.

## Adjugate entry reduction (isolated, 16 October 2026)

| Trial declaration | Precise role |
|---|---|
| `four_operator_norm_lt_of_entry_bounds` | General L2 matrix norm `< a+3b` from diagonal `<a` and off-diagonal `<b` bounds |
| `symmetricZeroFour_adjugate_00` | Exact cofactor `2uvw` for the (0,0) entry of the symmetric zero-diagonal 4x4 matrix |
| `symmetricZeroFour_adjugate_01` | Exact off-diagonal cofactor `w²x-wzu-wyv` |
| `four_adjugate_numeric_margin` | `3/8+23/1000+3*(197/10000) < h*s²` |
| `four_adjugate_bound_of_entry_bounds` | Conditional operator adjugate upper bound; explicit scalar entry hypotheses remain |
| `nearHalf_triple_cofactor_bound` | Diagonal scalar cofactor error `<23/1000` from three entry deviations `<128/8649` |

All six theorems compiled and passed embedded transitive axiom audit; they remain under ignored `exploration/AdjugateFourTrial.lean`, not part of the root or theorem inventory count. Off-diagonal scalar error `<197/10000`, full index coverage and accepted integration remain OPEN. See `records/adjugate-entry-reduction-20261016.md`.

## Exploratory proof update, 2026-10-16 06:28 CEST

- Paper: first A>=3 branch of `lem:product-four`, off-diagonal cofactor perturbation.
- Lean declaration: `D1Bound5.nearHalf_offDiagonal_cofactor_bound`, source `exploration/AdjugateOffdiagTrial.lean`.
- Complete quantified scalar statement: six complex numbers within 128/8649 of 1/2 imply the precise error `<197/10000` for `w^2*x - w*z*u - w*y*v + 1/8`.
- Targeted proof compilation and transitive axiom audit: PASS, see `records/offdiagonal-cofactor-20261016.md`.
- Status: ISOLATED PROVED, not integrated root dependency and not a proof of `lem:product-four` or `MainStatement`. Next dependency: all 12 off-diagonal index instances, then combined 4x4 adjugate operator bound.

## Full adjugate entry coverage, 16 October 2026 (isolated)

The three compiled and axiom-audited declarations in `exploration/AdjugateCoverageTrial.lean` are `symmetricFour_adjugate_formula` (all 16 explicit cofactors), `symmetricFour_adjugate_norm_lt` (six near-half complex entries give the needed strict adjugate operator bound), and `symmetric_zero_four_adjugate_norm_lt` (same bound for an arbitrary symmetric zero-diagonal 4x4 complex matrix). Installed Lean kernel replay exited 0. None is yet included in the root import graph or the current 256-theorem integrated inventory. See the FINISH record at `records/runs/20261016T052800Z-adjugate-integration-FINISH.md`.

## Root-integrated adjugate proof (2026-10-16)

The 4x4 adjugate bound is now fully root-imported, not merely exploratory. Four modules, D1Bound5/AdjugateFourBounds.lean, D1Bound5/AdjugateOffDiagonal.lean, D1Bound5/AdjugateCoverage.lean and D1Bound5/SignedRootAdjugateBound.lean, contribute 12 proved theorems, including the complete 16-entry coverage and simultaneous sign-choice transfer over arbitrary commutative rings.

| New theorem | Precise function |
|---|---|
| four_operator_norm_lt_of_entry_bounds | Four-by-four operator norm from diagonal and off-diagonal entry bounds |
| symmetricZeroFour_adjugate_00 | Exact representative diagonal cofactor |
| symmetricZeroFour_adjugate_01 | Exact representative off-diagonal cofactor |
| four_adjugate_numeric_margin | Strict rational inequality for the final coefficient |
| four_adjugate_bound_of_entry_bounds | Operator norm under explicit cofactor bounds |
| nearHalf_triple_cofactor_bound | Uniform cubic diagonal error |
| nearHalf_offDiagonal_cofactor_bound | Uniform cubic off-diagonal error |
| symmetricFour_adjugate_formula | All sixteen exact cofactor formulas |
| symmetricFour_adjugate_norm_lt | Full bound for six independently chosen complex entries |
| symmetric_zero_four_adjugate_norm_lt | General symmetric zero-diagonal matrix version |
| signed_root_matrix_adjugate_upper | Transfer to fixed simultaneous ring-valued signs |
| exists_signed_root_matrix_adjugate_upper | Existence of suitable signs and the final adjugate estimate from the six root-square equations |

The statement inventory is 52 imported modules and 268 explicit proved theorems. Root compilation exited zero (3015 jobs), transitive axiom audit of these 12 declarations passed with exactly the three standard allowed axioms. This is an adjugate bound, not completion of the product-four lemma. Its determinant inequality is still an isolated exploratory proof. See records/adjugate-root-integration-20261016.md and the run logs.

## Direct determinant and joint adjugate transfer (16 October 2026)

`D1Bound5/SymmetricFourDetBound.lean` contributes seven proved declarations: `symmetricZeroFour_det` (exact six-entry 4x4 formula), `nearHalf_product_nearQuarter` (pair-error control), `threePairDetPolynomial_bound` (strict uniform polynomial bound), `symmetricZeroFour_det_norm_lt` (explicit 4x4 complex determinant upper bound), `symmetric_zero_four_det_upper` (general symmetric zero-diagonal matrix bound), `signed_root_matrix_det_upper` (fixed ring-valued choice), and `exists_signed_root_matrix_det_upper` (simultaneous ring-valued sign choice). `D1Bound5/SignedRootMatrixBounds.lean` adds `exists_signed_root_matrix_det_and_adjugate_upper`, which combines determinant and adjugate inequalities for ONE sign choice while retaining signs and squares. The same-witness property is necessary for the later rank-one argument. All eight are root-imported, with permitted transitive axioms only. Integrated inventory: 54 modules and 276 explicit proved theorems. `lem:product-four` is still not complete because its arithmetic lower bound and mixed branch have not been connected.

## Arithmetic determinant lower bound (16 October 2026)

| Declaration | Manuscript role |
|---|---|
| `scaledRootMatrix_det_norm_identity` | Exact complex norm of the scaling determinant as product of entry moduli times original determinant modulus, arbitrary finite dimension and commutative coefficient ring |
| `scaledRootMatrix_det_norm_lower` | Norm lower bound conditional only on the unscaled determinant modulus at least one |
| `full_ring_scaledRootMatrix_det_norm_lower` | Arithmetic lower bound from `even_root_matrix_one_le_norm` in every even dimension for every imaginary quadratic full integer ring |

All three are root-imported, compiled, transitive-axiom audited and targeted kernel-replayed, with source/import coverage of 55 modules and 279 explicit theorems. The next step is the exact ordered-coordinate identification and shared signed-root witness in `lem:product-four`; this is not the complete product-four lemma or the main bound-five theorem.

## Product-four first branch — 16 October 2026

The three integrated theorems `productFour_ordered_square_sum`, `productFour_tail_large`, and `full_ring_productFour_large_growth` in `D1Bound5/ProductFourLargeBranch.lean` establish the proof of the A>=3 large-entry determinant inequality `D>2ABC` under the separately proven tail assumption `2BC<D`. The ring theorem quantifies over every totally complex quadratic number field, its FULL `RingOfIntegers`, any complex field homomorphism, any symmetric integral root matrix and ordered moduli (ties allowed); the proof uses the same signs for all matrix estimates and arithmetic lower bound. It has no excluded zero-square cases. This is the first assertion of manuscript `lem:product-four`, at the ordered integral-root-matrix interface, not the entire lemma or main theorem. Missing structural packaging is from a D(1)-tuple to the matrix plus pre-proved tail lemma; second case is still OPEN.

## Product-four tuple interface (16 October 2026; isolated)

The statement `IsD1Tuple.exists_symmetric_root_matrix` (generic finite index size and arbitrary commutative ring) builds a symmetric matrix with the tuple on its diagonal, using square roots selected for canonical unordered pairs. Its diagonal entries are the original tuple and every off-diagonal entry squares to `t i * t j + 1`. The statement `IsD1Tuple.productFour_large_growth` specializes to any imaginary quadratic full ring, an ordered D(1) quadruple with first modulus at least three, and concludes `2*A*B*C<D` by invoking the already accepted `IsD1Tuple.tail_irregular_and_growth` and `full_ring_productFour_large_growth`. Proof source: `exploration/TupleRootMatrixBridgeTrial.lean`, targeted elaboration and olean compile and kernel replay EXIT 0, but transitive axiom audit and root integration are not completed. Do not mark the product-four lemma complete: the mixed A>=1,B>=3 branch is still missing.

## Accepted D(1)-tuple bridge for the large product-four branch (2026-10-16)

Two new root-imported theorems are in `D1Bound5/TupleRootMatrixBridge.lean`.

- `IsD1Tuple.exists_symmetric_root_matrix`: any indexed D(1)-tuple in any commutative ring admits a symmetric original-ring root matrix with the correct diagonal and pairwise square identities, including zero-square cases.
- `IsD1Tuple.productFour_large_growth`: an ordered D(1)-quadruple in the full ring of integers of any imaginary quadratic field satisfies `D>2ABC` when `A>=3`. The already established complete tail growth is derived internally; no separate matrix hypothesis is exposed.

Integrated source scan: 57 modules, 284 explicit proved theorems. Target/root build, dedicated two-theorem transitive axiom audit and targeted installed same-kernel replay all EXIT 0. Weighted A>=1,B>=3 remains OPEN. See `records/tuple-root-matrix-bridge-20261016.md`.

## Weighted four-by-four row certificate (2026-10-16)

| Declaration | Exact manuscript role |
|---|---|
| `weightedFourWeights_pos` | Positive coordinates of (3/2,1,1,1). |
| `mixedFourEnvelope_nonneg` | Nonnegative real entrywise majorant of mixed errors. |
| `mixedFourEnvelope_symmetric` | Symmetry of the majorant. |
| `mixedFourEnvelope_weighted_rows` | Every weighted row sum <= 11/96 times the corresponding weight. |
| `mixedFourEnvelope_first_row_strict` | Exact strict first-row slack. |
| `mixedFour_entry_norm_le_envelope` | Complex entrywise error dominated by the majorant; no matrix symmetry needed. |
| `mixedFour_entrywise_weighted_row_bound` | Conditional weighted row inequality for any complex 4x4 error matrix with stated rowwise <1/18 and <1/64 hypotheses. |

All seven theorem types and transitive axioms audited, source root-imported and kernel replayed. The essential step from row sums to spectral/L2-operator norm has not been formalized. The eight previously developed mixed-sign results were independently axiom-audited and replayed in this invocation. See `records/weighted-row-certificate-20261016.md`.

## Mixed determinant interface — 2026-10-16

- `mixedPairProduct_nearQuarter`: pair with errors <1/18 and <1/64 has product within 7/192 of 1/4.
- `mixedThreePairDet_norm_lt`: the exact symmetric 4x4 determinant polynomial has norm <3/10 when each opposite-edge product lies within 7/192 of 1/4.
- `mixedSymmetricFour_det_lt`: six-entry symmetric zero-diagonal matrix, first-row error <1/18 and lower-block error <1/64.
- `mixed_zero_four_det_norm_lt`: index-free matrix version, no invertibility hypotheses.
- `mixed_signed_root_det_upper`: maps arbitrary commutative-ring normalized symmetric root matrix with `MixedSignedEntryGood` to the strict `<3/10` bound.

All five imported, compiled, transitive-axiom audited and same-kernel replayed. This is the mixed **determinant** portion of `lem:product-four`, not the mixed adjugate or full growth result. See `records/mixed-four-determinant-20261016.md`.

## Complete mixed adjugate analytic bounds — 2026-10-16

The four new root-imported modules below close the mixed adjugate estimate for
the actual *same* chosen signed matrix that satisfies the prior determinant
estimate. Every item is a proved Lean theorem with its exact hypotheses.

| Module | Theorem declarations and role |
|---|---|
| `MixedAdjugateScalarBound` | Six theorems: generic independent-radius diagonal/off-diagonal cubic estimates and four strict numerical prototypes, covering both diagonal and off-diagonal types. |
| `MixedAdjugateEnvelope` | Three exact nonnegative/symmetric/row-sum facts for the 4x4 cofactor envelope, plus `mixedFour_adjugate_norm_of_entries`. |
| `MixedFourAdjugateBound` | `mixedSymmetricFour_adjugate_norm_lt` uses the full sixteen-cofactor formula; `mixed_zero_four_adjugate_norm_lt` removes choice of coordinates. |
| `MixedSignedRootAdjugate` | `mixed_signed_root_adjugate_upper` transfers to the original ring; `mixed_signed_root_det_and_adjugate_upper` certifies the **same** signed-root matrix satisfies both mixed analytic estimates. |

Mathematical conclusion: every symmetric complex zero-diagonal 4x4 matrix with
the first row <1/18 and the remaining 3 entries <1/64 from 1/2 has
`‖adj F‖<(155/96)*(59/96)^2`, with no invertibility assumption.

Root build 3028 jobs EXIT 0, source/import check 65 modules and 322 explicit
proved theorems EXIT 0, 14 transitive axioms audited (only propext,
Classical.choice, Quot.sound), four targeted installed-Lean-kernel replays EXIT
0, source/tool SHA256 manifests 68/27 PASS. No independent external reviewer
or fresh clean-checkout replay. See `records/mixed-adjugate-completion-20261016.md`.

The full mixed product-four theorem for actual ordered D(1) quadruples is not
yet deduced from these matrix facts. Its numerical closure and arithmetical
normalization must be integrated with the precise hypotheses.

## Mixed product-four complete growth (2026-10-16)

`D1Bound5/MixedProductFourGrowth.lean` closes the paper's second product-four branch using six new theorems: `mixed_four_det_ne_zero_of_entry_bounds`, `productFour_mixed_numeric`, `productFour_mixed_rankOne_numeric`, `productFour_mixed_growth_from_bounds`, `full_ring_productFour_mixed_growth`, `IsD1Tuple.productFour_mixed_growth`. The final declaration assumes only `IsD1Tuple`, ordered moduli, A>=1 and B>=3, and proves D>(3/2)ABC over every imaginary quadratic full ring. Zero radicands and tied moduli included. All six exact elaborated types and axioms audited (standard axioms only), integrated build 3029 jobs EXIT 0, targeted kernel replay EXIT 0, source audit 66 modules/328 theorems EXIT 0. See the dedicated proof record. The bound-five main theorem is still an unproved proposition.

## 16 October 2026 — product-five determinant polynomial

| Declaration | Source / purpose |
|---|---|
| `rankTwo_det_factor`, `rankTwo_det_entries` | Weinstein-Aronszajn reduction from a four-by-four rank-two update to an explicit two-by-two determinant |
| `productFive_update_entry`, `productFive_compressed_entry` | Complete entries of the low-rank Schur update and its compressed two-by-two correction |
| `productFive_rankTwo_det_general` | Exact nonsymmetric complex bilinear rank-two determinant polynomial, retaining both mixed products |
| `symmetric_inverse_bilinear_swap` | Algebraic inverse-transpose symmetry, with no complex conjugation |
| `productFive_rankTwo_det_symmetric` | Manuscript symmetric rank-two determinant expression |
| `productFiveSchur_eq`, `productFiveSchur_det` | Pointwise Schur complement and exact determinant identity in (integrated-3) |

Nine new proved theorems in `D1Bound5/ProductFiveRankTwo.lean`, root-integrated: 67 modules and 337 explicit theorems after a passing source audit. Target+root build, nine-theorem transitive axiom audit and targeted same-kernel replay all EXIT 0. This proves the rank-two determinant formula but NOT the product-five growth inequality. Next establish `det N=d^2 det G` in the original arithmetic matrix and its analytic/numerical bounds; Bennett's all-order identity remains separate.

2026-10-16 product-five equation (integrated-3): `ProductFiveBlockDet.lean` gives scalar block det, `ProductFiveMatrixBridge.lean` now proves the actual Fin 5 index conversion and complex normalized-root determinant `(∏ t_i) det M=d² det G`. Three theorems compiled and kernel-replayed, but these two modules are not imported by root due blocked edits. Full-ring transfer and product-five growth remain open.

2026-10-16 subsequent integration: `ProductFiveBlockDet`, `ProductFiveMatrixBridge`, and `ProductFiveExactIdentity` are now imported by the root along with `ProductFiveArithmeticClosure`. This supersedes the older unimported-status note above. The integrated pinned root build passed with 3034 jobs.

| `fiveNormalizedSchur` | Actual Fin 5 normalized-root four-by-four Schur matrix, with no new mathematical hypothesis |
| `five_root_det_ne_zero_of_schur` | `lem:product-five`, det G nonzero implies det M nonzero via the exact Fin 5 determinant identity |
| `five_schur_det_ne_zero_of_near` | `lem:product-five`, operator-norm proximity <1/2 to the reference H forces det G nonzero |
| `full_ring_productFive_arithmetic_growth` | Full imaginary-quadratic integer-ring determinant comparison from det G nonzero and norm det G<1/3 |
| `full_ring_productFive_growth_of_schur_estimates` | Full arithmetic growth `3ABSC<D` conditional ONLY on the two explicit Schur estimates and original-ring matrix/root inputs; analytic hypotheses still open |

New arithmetic module: four proved theorems, integrated build PASS, exact-type/axiom audit PASS, targeted same-kernel replay PASS. Project-wide source/import audit PASS, 71 modules and 349 explicit proved theorems. The complete product-five lemma and MainStatement are still UNPROVED.

## Product-five quantitative Schur determinant (2026-10-16)

`D1Bound5/ProductFiveDetNumeric.lean` realizes the exact numeric last step of v4 Lemma `lem:product-five`, equation `integrated-3`, with the original non-Hermitian rank-two formula: `productFive_scalar_det_upper` and `productFive_schur_det_upper_of_bilinear_bounds`. Root-integrated and targeted-replayed. Its quantitative hypotheses are explicit and NOT yet discharged for actual five-tuples. Next derive prefix bound 33/128, inverse/f-vector estimates and dimensionless bilinear bounds, then non-singularity via Schur proximity.

## `lem:product-five` — sharp prefix determinant, 2026-10-16

`D1Bound5/ProductFivePrefixDet.lean` contains four root-imported proofs and the dedicated audit `scripts/ProductFivePrefixDetAudit.lean`. From the paper's exact four-by-four symmetric determinant formula and three complementary pair products within `7/192` of `1/4`, it proves the stronger `|det F|<33/128`. The previously proved `<3/10` bound was insufficient for `ProductFiveDetNumeric`. This is a verified analytic sublemma conditional on the six signed-entry bounds, not a formal proof of the full `lem:product-five`. Target/root build, axiom audit, targeted Lean-kernel replay and source/import audit PASS; remaining five-tuple sign compatibility, inverse/last-column controls, Schur closeness and tuple assembly OPEN.

## Product-five signed prefix determinant transfer (2026-10-16 23:28 CEST)

- `mixed_signed_root_det_upper_33_128`: sharpened original-ring mixed signed-root 4x4 determinant, with one fixed symmetric sign choice and six explicit `MixedSignedEntryGood` hypotheses.
- `five_prefix_det_upper_of_mixed_signed_entries`: exact Fin 5-to-Fin 4 prefix restriction gives `||det F|| < 33/128` for the same five-entry integral root matrix, provided its six prefix edge signs satisfy the mixed predicate. No extra fifth-column hypothesis, and no implicit compatibility/existence statement.

Both root-integrated with verified build, exact-type and transitive-axiom audit, targeted same-kernel replay. Still OPEN: construct globally compatible five-entry signs, bound last-column terms and Schur distance. See the run FINISH record.

## Product-five compatible signs and last-column estimates (16 October 2026)

`D1Bound5/ProductFiveCompatibleSigns.lean` adds ten theorems and the predicate `FiveSignedEntryGood`. It closes the same-witness full-five-entry sign construction, rather than making separate prefix and last-column choices.

- `signedEntryBounds_fiftyfour_or_neg`: c=49/50 gives correction modulus <50/99 and distance to 1/2 <625/264627 when the pair product has modulus >=54.
- `fiveSignedEntryGood_swap`, `fiveSignedEntryGood_or_neg`, `exists_five_signed_root_matrix`: all ten original-ring signs chosen on unordered pairs, preserving symmetry and all pair-square identities.
- `fiveSignedEntryGood_prefix`, `fiveSignedEntryGood_last_column`: exact Fin4-in-Fin5 restriction gives the existing mixed prefix predicate and last-column distance <1/400.
- `exists_five_signed_root_matrix_with_bounds`: one matrix has prefix determinant <33/128 AND all four last-column bounds.
- `IsD1Tuple.five_last_modulus_gt_fiftyfour`: D>54 is derived from the already proved large product-four bound on the last four elements.
- `IsD1Tuple.exists_five_compatible_signed_matrix`: actual ordered quintuple over every imaginary quadratic full integer ring, with only IsD1Tuple, monotone moduli, A>=1 and B>=3 as inputs; no extra sign/existence/last-size hypotheses.
- `fiveLastColumn_l2_bounds`: component bounds imply ||f-f0||_2<1/200 and ||f||_2<201/200, with the Euclidean norm explicit in Lean.

Trial05 and integrated target/root build EXIT 0 (3038 jobs). Source/import audit PASS (75 modules, 367 explicit theorems), source/tool manifests PASS (78/38). Final type/axiom/kernel receipts are recorded separately in the current run. This is not full product-five or global bound-five completion.

## Product-five signed prefix analytic bridge (17 October 2026)

D1Bound5/ProductFiveSignedPrefixInverse.lean connects the EXISTING one-witness `FiveSignedEntryGood` tuple construction to the original-ring normalized Fin4 prefix: operator proximity <=11/96, inverse-vector L2 norm <11/12 and p-form modulus <1. This is an actual proof for the SAME signed matrix, including the complex bilinear Cauchy--Schwarz reduction. It is a dependency of the manuscript's product-five estimates, not the complete lemma. Pinned integrated build, transitive axiom audit, installed same-kernel replay and source audit succeeded; SHA manifests and Git synchronization are pending after a PRE_EXECUTION_DENIED refresh. Remaining h/d, q/d^2, p/d^2, Schur closeness, arithmetic assembly and final exclusions are OPEN.

## 2026-10-17 — product-five vector and cross-form isolated bridge

The prefix size <D/9 follows formally from the ordered last-four product-four growth inequality. Complex bilinear Cauchy--Schwarz and symmetry give |h/d|<11/108 from the existing inverse-vector estimate. Both are elaborated as trial theorems, with a separately checked real scalar lemma. No root-imported new theorem is claimed, since a root-module copy command was denied before execution. Next: root import/replay and specialize all assumptions to the actual five-tuple's single original-ring sign matrix. See records/product-five-prefix-size-cross-20261017.md.

## Product-five normalized bilinear q and p controls (17 October 2026)

`ProductFiveNormalizedQuadratic.lean` proves `productFive_quadratic_q_div_norm_lt` and `productFive_p_div_sq_norm_lt` in the exact scalar forms required by `productFive_schur_det_upper_of_bilinear_bounds`. They have explicit analytic hypotheses `||F-H||<1/8`, `||w||_2<||d||/9`, `d!=0`, or `||p||<1` and `||d||>=54`. No symmetry/Hermitian assumption is needed in the q estimate. Both are root-imported, type/axiom audited and targeted same-kernel replayed. An actual quintuple-level bridge and the Schur determinant/nonvanishing closure are NOT supplied by this unit.

## `lem:product-five`: analytic Schur proximity (17 October 2026)

`ProductFiveSchurNear.lean` now closes the dimension-four entrywise Schur norm inequality, the rank-two correction <9/100 per matrix entry and the resulting `||G-H||<1/2` theorem with its exact coordinate hypotheses, plus the necessary 1/18 ordered prefix-coordinate ratio. Five new root-integrated proved theorems, 79 modules/380 explicit theorem inventory. It is an interface lemma, not yet the v4 `lem:product-five` for actual tuples. Next specialize to the same `IsD1Tuple.exists_five_compatible_signed_matrix` witness, close the numeric determinant bounds and use `full_ring_productFive_growth_of_schur_estimates`.

## Frozen v4 interpolation weights — all degrees, 17 October 2026

`HomogeneousSymmetric`: the multiset-sum definition and six prior checked hsymm Option-variable theorems, root-promoted without trailing exploratory audit commands. `LagrangeAdjunction`: three new denominator/cancellation/power-recurrence proofs. `LagrangeHomogeneous`: three finite-type/finite-set infrastructure lemmas plus the two all-degree moment identities, including exact evaluation of mathlib hsymm. `ReciprocalAnchors`: six prior checked reciprocal-weight transfer statements, root-promoted. `InterpolationWeights.reciprocal_anchor_sum_eq_hsymm` (namespace D1Bound5): the new all-k signed reciprocal identity, exactly the n>=m branch of the displayed formula before eq:coherent-exact (frozen v4 lines 561-571, n=m+k).

Nine new and twelve reused theorem declarations, all type/axiom audited; complete fresh same-kernel replay of InterpolationWeights and its imports passed. No analytic infinite-sum interchange or remainder bound is included. MainStatement remains UNPROVED. Evidence: records/interpolation-all-orders-20261017.md and research/continuations/20261017T164243CEST-interpolation-recovery/.

## Frozen v4 analytic interpolation coefficient envelope — 17 October 2026

`ComplexHsymmNorm.hsymm_aeval_complex_norm_le_choose` closes the exact complete-homogeneous symmetric coefficient norm bound at EVERY k, with binomial multiplicity `choose(m+k-1,k)`. This directly follows the already accepted `HomogeneousSymmetric.homogeneousMultisetSum_eq_hsymm` and mathlib's `Sym.card_sym_eq_choose`. The theorem is unconditional on distinct or nonzero variable values. The finite source alphabet may be empty. It is the coefficient-level step needed before `eq:coherent-tail`.

The analytic summability and genuine square-root remainder bound, arbitrary-order Bennett determinant, exhaustive certificate coverage/descent and final sextuple exclusions are still missing. Complete root build, type/axiom audit, same-kernel replay and source/import audit have passed; fingerprint/Git publication has not. See `records/complex-hsymm-norm-20261017.md`.

## 17 October 2026 — complex homogeneous-series convergence

`D1Bound5.HsymmSummability.hsymm_aeval_complex_summable` is a root-imported proof of summability of the series `z^k * h_k(a)` for nonempty finite complex alphabets satisfying `norm(a_i) <= rho`, `rho >= 0`, `rho * norm(z) < 1`. It uses the exact coefficient estimate `hsymm_aeval_complex_norm_le_choose`, `Nat.choose_symm_add`, and mathlib's negative-binomial series theorem. This resolves convergence of the homogeneous generating function in the radius disk, but not the v4 square-root coefficient convolution and explicit `eq:coherent-tail` inequality.

## 17 October 2026 — convergence of exact weighted-pole remainder

- Declaration: D1Bound5.weighted_poles_tail_tendsto_zero in D1Bound5/WeightedPoleLimit.lean.
- Manuscript role: analytic convergence of the finite rational remainder attached to the exact weighted-pole Taylor formula, preceding the stronger square-root tail estimate.
- For arbitrary finite s, complex a,w,z with |z|<|a_i| on s, the remainder z^n * sum_(i in s) w_i/(a_i^n*(a_i-z)) tends to zero. Repeated nodes, an empty set and zero weights are allowed.
- Pinned target/root build, type/axiom audit, same-kernel fresh replay and source/import audit all PASS. This statement does NOT itself prove the infinite HasSum identity, a parameter-uniform bound, the binomial square-root estimate or MainStatement. See records/weighted-pole-limit-20261017.md.

## 17 October 2026 — v4 `eq:coherent-tail` weighted summation factor

`D1Bound5/CoherentMajorant.lean`: `negative_binomial_positive_tail_tsum` proves exactly the positive-degree negative-binomial generating-function value, and `hsymm_aeval_complex_positive_tail_norm_le` gives the complete-homogeneous sum-of-norms factor `(1-rho*t)^(-card)-1`. Two theorems previously elaborated separately, now root-imported, built and covered by the subsequent imported kernel replay.

`D1Bound5/CoherentWeightedRemainder.lean`: `coherent_weighted_remainder_summable_and_norm_le` proves that an explicit coefficient bound `|f_(m+j+1)|<=C*t^(m+j+1)` implies summability and the bound `C*t^m*((1-rho*t)^(-card)-1)` for the complex interpolation tail. New root-imported theorem, built, exact type/axioms checked, and freshly same-kernel replayed. This is a necessary conditional analytic sublemma, NOT yet the paper's actual `eq:coherent-tail`. The square-root coefficient envelope and identification of the paper's `F_m` with this tail remain open. See `records/coherent-weighted-remainder-20261017.md`.

## 17 October 2026 — sharp absolute half-binomial convolution

`D1Bound5/HalfBinomialConvolutionAbs.lean` proves five new declarations: `halfBinomialCoeff_interior_convolution`, `halfBinomialCoeff_abs_signed`, `halfBinomialCoeff_pair_abs_signed`, `halfBinomialCoeff_interior_abs_sum`, and `halfBinomialCoeff_abs_convolution`. The final identity says that for n>=2, `sum_(i+j=n) abs(b(i)*b(j)) = 4*abs(b(n))`, where b(n) is the real half-binomial coefficient. This closes the *real unweighted* absolute convolution step leading to the constant four in the frozen v4 square-root interpolation coefficient estimate; the complex weighted coefficient envelope and identification with the actual analytic remainder remain OPEN. Integrated pinned build, exact types/transitive axioms, targeted installed same-kernel replay, source/import scan and source/tool manifest verification passed. MainStatement UNPROVED.

## 17 October 2026 — recovered analytic modules integrated and audited

The three previously isolated units are now integrated as ComplexHalfBinomial, HalfBinomialAnalytic and HalfBinomialLowDegree. The last uses the same public halfBinomialWeightedCoeff definition, removing the private duplicate. All three module builds and the combined root build passed under the pinned environment. All ten exported theorems plus the coefficient definition passed enforced transitive axiom checks with only propext, Classical.choice and Quot.sound. An independent read-only statement/source audit found no weakened product-four/product-five endpoints or analytic formula errors. A fresh replay of this combined recovered snapshot is still pending in the current continuation. MainStatement remains UNPROVED.

The public manuscript and frozen v4 have identical document bodies: only PDF metadata and the printed date differ. Both hourly formalization automations were paused at the author request. Current new interpolation, cross-block and Bennett drafts are excluded from accepted imports until their tests succeed.


## 18 October 2026 — scalar height steps (wave119 validation)

`OrdinaryHeightScalar` is now separately build/type/axiom/kernel verified. `ordinary_integer_orders_log_bound` selects k=floor(log Z/log R)+1 from an all-positive-integer-order approximation inequality; `ordinary_height_scalar_envelope` derives the exact rational logarithmic envelope; `unit_pair_height_cutoff_scalar` excludes the two scalar height bounds for s>=4. The all-order input and the full-ring branch specialization remain separate dependencies. No original theorem was weakened; accepted root imports are unchanged.

## 2026-10-18 — retained H48 gap and monomial consequence

The working module `CoherentRetainedGap` now has a verified build and audit for the retained H48 analytic inequality on five actual full-ring tuple entries and its explicit consequence `400*(A^7*B^5*S^3) < C` under the sharpened frontier. The module is not yet imported into the accepted root, and this entry does not close the all-large branch or the final theorem.

## 18 October 2026 — live schedule-recovery Bennett coefficient unit

`BennettCoefficientMajorant` had one actual Lean rewrite failure through explicit lambda application. Added `dsimp only at hmono`, preserving every statement. Corrected guarded pinned build EXIT 0; seven public declarations (six theorems, one definition) passed exact-type/transitive-axiom audit with only propext/Classical.choice/Quot.sound; installed same-kernel target replay EXIT 0. The final lemma bounds the evaluated complex cleared Taylor expression by an explicit positive numerator/pole coefficient majorant, under its stated pole-series envelope. Source and complete project import hashes are in `research/continuations/20261018T1423CEST-schedule-recovery/`. This is separately verified work, not root integration or global MainStatement closure.

## 18 October 2026 — two Bennett analytic working modules verified

`BennettResidualMajorant` and `BennettPositiveSeries` now have repaired guarded pinned builds, exact audits of fourteen original theorems plus one helper and one definition, and successful installed SAME-kernel targeted replays. The combined fresh closure replay exceeded its 240-second budget and is unconfirmed. No original theorem headers or budgets were weakened. These modules are not root-integrated and MainStatement remains UNPROVED. Evidence: `research/continuations/20261018T1901CEST-bennett-analytic/VERIFICATION_SUMMARY.json`. Next ready reviewed repairs: RetainedMixedFourScalar, RetainedMixedScalar. Automation/diagnostic settings were not changed.

The residual module proves the exact negative-binomial/homogeneous majorant needed for the eta exponent in v4 `eq:ordinary-residue-error`, including the specialization n=3k and s=k+1/2. It does not itself identify the actual algebraic residue with that series. The positive-series module supplies the norm-compatible pole factors, their analytic Cauchy multiplication and the two-pole coefficient bound used in local Taylor coefficient estimates. The downstream algebraic identification and final tuple exclusions remain separate dependencies.

## 18 October 2026 — retained mixed scalar growth verified

RetainedMixedFourScalar (two theorems) and the repaired RetainedMixedScalar (one theorem) passed pinned guarded builds, exact type/transitive-axiom audits and installed SAME-kernel targeted replays. Original theorem headers and limits are unchanged. These are separately verified working dependencies, not accepted-root integration. CoherentRetainedMixedGap still requires CoherentRetainedMixedSizes and CoherentRetainedMixedForms. Evidence: research/continuations/20261018T203306CEST-retained-scalars/. MainStatement remains UNPROVED.

## 18 October 2026 — ordinary height envelope and conditional unit-pair cutoff verified

Three working modules OrdinaryLog10, OrdinaryHeightEnvelope and UnitPairHeightCutoff passed guarded pinned compilation, exact audits of 15 theorems and one definition, and three targeted installed SAME-kernel replays. All original theorem statements are unchanged. The cutoff S<10000 is derived from the explicit growth/root/all-order hypotheses, not assumed for arbitrary tuples. All ten wave119 repair targets now have current guarded compiled status. The earlier mixed full-ring gap was already verified in commit 5ca7c28 and was not repeated. Root integration, the remaining full-ring Bennett bridges, exhaustive finite certificates, and MainStatement remain open. Evidence: research/continuations/20261018T212721CEST-height-envelope/VERIFICATION_SUMMARY.json.

## 18 October 2026 — two-anchor integral matrix and full-ring row selection verified

Four working modules now close exact two-anchor Bennett summand/entry integrality, column-power divisibility, nonsingularity of the constructed matrix and the full-ring existence of a row form with modulus at least one. All 21 original theorems and four definitions compiled unchanged, passed exact type/axiom checks and four targeted installed SAME-kernel replays. The full-ring endpoint retains the explicit a,b,z nonzero and a!=b hypotheses; tuple-specific upper estimates remain downstream. No root integration or MainStatement proof is claimed. Evidence: research/continuations/20261018T220533CEST-bennett-integrality/VERIFICATION_SUMMARY.json.

## 18 October 2026 — Bennett coefficient bounds and signed-root approximation verified

Six working modules now prove the actual Bennett base-42 bounds for both nonzero columns and the integral signed-root approximation with strict factor3/2. All 17 original public theorems and one private helper compiled; five modules needed proof-body-only repairs, with all original headers preserved. The exact public type/transitive-axiom audit and six targeted installed SAME-kernel replays passed, with only propext/Classical.choice/Quot.sound. The final source review covers 33 project dependencies. Root integration, the weighted combined bound, residual evaluation/rate, full-ring all-order conclusion, exhaustive finite checks and MainStatement remain open. Evidence: research/continuations/20261018T222403CEST-coeff-root/VERIFICATION_SUMMARY.json.

## 18 October 2026 — weighted height and actual Bennett residual verified

Six working modules now prove the combined weighted column height, exact analytic residue evaluation, the inverse-denominator/repeated-node coefficient identity, and the actual arbitrary-order residual bound including its exact Gamma specialization. All original theorem headers are unchanged. The guarded pinned builds, exact public type/transitive-axiom audit and targeted installed SAME-kernel replays of the weighted-height, infinity and residual-bound endpoints passed with only propext, Classical.choice and Quot.sound. Applying the integral clearing factor and residual rate, the full-ring all-order inequalities, root integration, exhaustive finite checks and MainStatement remain open. Evidence: research/continuations/20261018T231100CEST-weighted-residual/VERIFICATION_SUMMARY.json.

## 19 October 2026 — full-ring all-positive-order Bennett inequality verified

Three working modules now prove the exact half-rate residual, the full-ring two-anchor inequality for every positive integer order, and the ordinary height envelope for an actual ordered D(1)-quadruple. The terminal root nonzero, signed integral approximations, nonzero integral row, and all coefficient/residual estimates are derived internally. The parameterized height envelope retains its explicit logarithmic h,r,u premises. Nine original theorems and two definitions passed pinned builds, exact type/transitive-axiom checks and three targeted installed SAME-kernel replays; only propext, Classical.choice and Quot.sound. No root integration, final finite exclusion, independent final review, whole-root clean checkout or MainStatement proof. Evidence: research/continuations/20261019T001143CEST-residual-rate/VERIFICATION_SUMMARY.json.

## 19 October 2026 — unit-pair cubic growth and first-extension cutoff verified

Four working modules now prove the full-ring cubic gap, its three-step iteration, and |a_2|<10000 for an actual modulus-ordered D(1)-sextuple with a_0=-1 and a_1=1. Opposite-pair exclusions, nonzero integral forms, signed roots and the all-order Bennett input are derived, not supplied as certificates. All ten original public theorems and one private helper compiled with unchanged statements. Public type/transitive-axiom audit and four targeted installed SAME-kernel replays passed with only propext, Classical.choice and Quot.sound. The cutoff does not exclude the remaining small range. Field/axis reduction, finite Pell certificates, global exclusions, root integration and final whole-project gates remain open. Evidence: research/continuations/20261019T054036CEST-unit-pair-cubic/VERIFICATION_SUMMARY.json.
