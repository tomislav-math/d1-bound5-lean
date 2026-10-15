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

## Separate analytic-tail continuation, 2026-10-15

This worktree adds nine explicit theorems to the accepted 70-theorem base.
The old sections above are historical milestones, not current totals.

| Declaration | Source / purpose |
|---|---|
| `normalized_root_perturbation` | Elementary sign-selected square-root estimate replacing analytic branches in lem:tail-irregular |
| `exists_sign_root_perturbation` | Perturbation about an arbitrary nonzero complex target |
| `tail_error_sum_lt_one` | Rational bounds for the three root errors, two ranges for sqrt(A) |
| `tail_sum_root_bounds` | Nonzero beta+gamma and valid perturbation radius for ad+1 |
| `exists_ring_sign_root_perturbation` | Sign selection preserves integral square roots |
| `exists_aligned_square_roots` | Auxiliary beta,gamma aligned with the given root of bc+1 |
| `no_regular_large_tail_core` | Analytic contradiction with the arithmetic norm input explicit |
| `tail_irregular_of_four_le` | C>=4 branch in EVERY imaginary quadratic full integer ring, norm input discharged |
| `IsD1Tuple.tail_irregular_and_growth_of_four_le` | Same branch plus D>2BC for actual ordered D(1)-quadruples, ties allowed |

All new theorem sources compiled successfully. The separate C<4 finite
branch, remaining determinant/approximation estimates and main bound-five
theorem are not asserted by this milestone.
