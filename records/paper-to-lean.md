# Paper-to-Lean inventory

All names below are in namespace `D1Bound5`. Nested prefixes are retained.
The accepted build commands, exact code commits and audit results are recorded
in `build-record.md`. No row below claims the main theorem is proved.

| Declaration | Source / purpose |
|---|---|
| `IsD1`, `IsD1Tuple` | Section 1, exact finite-set and indexed definitions |
| `MainStatement` | `thm:main`, proposition only, NOT proved |
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
