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
| `zero_square_pair` | Regression: {-1,1}, zero root and equal absolute values |
| `half_integral_basis_square` | Regression: omega^2=omega-1 in tau=nu=1 |

There are 36 explicit proved theorems in this milestone, in addition to the
definitions and generated helper declarations. The six modular results use
kernel `decide` after a proved checker-soundness lemma, not Python or native
evaluation. Their preceding enumeration is still an open obligation.

The coordinate-to-full-ring bridge, analytic estimates, arbitrary-order
Bennett determinant identity, complete graph and Pell calculations, and
three major exclusions remain open; see `open-obligations.md`.
