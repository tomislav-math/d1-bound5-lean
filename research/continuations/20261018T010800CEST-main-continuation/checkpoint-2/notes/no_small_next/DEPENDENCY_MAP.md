# Proposition 6.1: actual dependency status

Read directly from the frozen project manuscript
`paper/Diophantine_tuples_bound_five_2026-10-15.tex`, lines 1875–2079,
and the remote Lean sources on 2026-10-18. Source presence is distinguished
from root's compiler acceptance; new draft status must not be promoted merely
because a file has been copied to the remote project.

The target is exclusion of an ordered sextuple of full-ring integers with
`3 ≤ A ≤ B ≤ S ≤ T ≤ C ≤ D`. `MainCaseReduction` already expresses exactly
this branch, but does not prove it.

| Required paper step | Existing formal source / status | Remaining obligation |
|---|---|---|
| Order sextuple; all six moduli at least 3 | Accepted `MainCaseReduction`, `Sextuple` | Routine specialization only |
| `T > 3 A B S` | Accepted `ProductFourLargeBranch` gives factor 2. Accepted `ProductFiveTupleGrowth` concerns the fifth entry, not the fourth. Crossblock has now drafted the actual sharper `IsD1Tuple.frontier_large_growth` in `frontier_next/FrontierLargeTuple.lean`, with cofactor/numerical dependencies. | Root compilation remains. The paper's `five-frontier-gaps`, lines 404ff, must not be misread as the accepted five-entry growth theorem. |
| Strong two-anchor gap | `CoherentTwoUpper`, `CoherentTwoGap`, `CoherentTwoMainGap` drafts; root compiles serially | Connect actual full-ring tuple positions to the established size hypotheses |
| At least one of two three-anchor forms nonzero | `CoherentThreeSimultaneous`, `CoherentThreeNonvanishing` drafts | Root compiler acceptance; actual form theorem already has no abstract nonvanishing assumption |
| Three-anchor parameter vanishing window | Analytic bridge currently implements exact coefficient bounds and H32/H48 rows | H48 needs lambda=19/200, U=15 |
| Retained-gap lemma | Not yet present as actual full-ring theorem | Derive `C>A²T⁵/S²`, `D>A²C⁷/(S²T⁴)`, size conditions, and retained coefficient; direct-four/form selection remains necessary |
| Coarse gap `C>400 A⁷B⁵S³` | New local `AllLargeOverlapConstants.all_large_retained_gap_monomial` | Takes the explicit retained bound and elementary `0<Q≤8`, `3≤A,B`; does not assume this coarse gap as its own premise |
| Actual forbidden intervals Q,N2,P,A3,M,N3,N3bs,A4,A5 | No actual family endpoint/exclusion module found | Define/verify the finite rows, coefficients, residuals, and determinant nonzero; transfer via actual full-ring lower bound |
| All-order ordinary intervals Oj | Arbitrary-order Bennett algebra and m=2 integrality under active compilation | Actual all-order coefficient/residual analytic bounds, then forbidden intervals |
| Endpoint overlap algebra | Generic accepted `IntervalChain` only | Connect concrete positive endpoints to the monomial quotient bounds in manuscript table; two case splits `S≥B²`, `S≥B³` |
| Rational minima of all table quotients | New local `AllLargeOverlapConstants.all_large_overlap_constants` | Root compilation only: all 15 table quotients plus ordinary tail are handled by monotonicity and exact rational arithmetic |
| Infinite-tail contradiction | Accepted `forbidden_interval_chain`, `scaled_power_unbounded`, `geometric_forbidden_interval_chain` | Assemble actual finite path and ordinary tail; exclusions are substantive unavailable inputs, not an allowed assumption in a claimed main branch |

The retained coefficient constant is
`3^5*(9999/10000)*(200/19)^2*(1/8-(51051/400000)/81)^2 > 400`.
The local certificate verifies it by rational arithmetic and proves its
monotone use when `A²B² ≥ 81` and `Q ≤ 8`. It also verifies the smallest
overlap `N3bs–A4 > 7/5`; all other displayed quotients exceed `13/10`.

The finite path is Q,N2,P, then N3 if S≥B², else A3,M,N3; then A4 if
S≥B³, else N3bs,A4; finally O4,A5,O5,O6,... . Equality is covered by
the ≥ branch. Ordinary tail uses `R0/H0=AC/(105B^4)>1` and positive
geometric lower endpoints. The scalar and logical final steps contain no
further number-theoretic obstruction, but currently missing actual interval
exclusions prevent any honest closed proof of Proposition 6.1.

Root assigned the sharper four-entry frontier to crossblock and retained
three-anchor bounds to analytic_bridge. After stabilizing the numerical
certificate, allorder_det returns to the actual all-order Bennett residue
generating identity needed for ordinary-family analytic estimates.
