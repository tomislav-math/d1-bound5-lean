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
