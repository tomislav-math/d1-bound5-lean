# Concrete finite Q family

Status: complete local source chain, awaiting the parent serial Lean compiler. No file is considered accepted merely because it exists here. No theorem contains `sorry`, an axiom, or an assumed family exclusion.

Dependency order:

1. `FiniteQMatrix`: exact integer polynomial rows ab/as/bs/at/bt, divided/full determinant, actual nonsingularity. The determinant identity was independently verified by exact multivariate integer expansion: 42 final monomials and no c dependence.
2. `FiniteQIntegralRows`: map compatibility, actual nonzero-row selection, full-ring norm at least one.
3. `FiniteQHeight`: actual root-column height at most 36 T^3 C.
4. `FiniteQResidualIdentity`: actual principal half-power remainders, convergent tail bound from degree four, exact cancellation into degree-four/five tails.
5. `FiniteQResidualBound`: actual pair residual below 3 T/(2 A^2 C^4), with intermediate coefficient625/444.
6. `FiniteRowRootTransfer`: generic triangle step reusable by other families; its explicit analytic premises are derived in the Q application.
7. `FiniteQRowBound`: all five actual Q rows have transferred coefficient54 and the actual residual.
8. `FiniteQFullRing`: actual IsD1 witnesses and coherent signed products, determinant-selected integral row, and the strict coefficient55 inequality. No analytic or arithmetic certificate is assumed.
9. `FiniteClosedWindow`: actual root relative norm bounds and generic closed-window contradiction.
10. `FiniteQInterval`: actual full-ring closed Q interval exclusion.

The final endpoint takes an actual full-ring IsD1 set, four pairwise distinct anchors a_j distinct from c,d, c!=d, A>0, A<=|a_j|<=T, 4T<=C<=D, AC>=1000. It excludes

    4*55^2*T^6*C^3/(1-1/4000) <= D
    D <= A^4*C^7/(9*T^2*(1+1/4000)).

Reference: frozen manuscript lines1813–1873; generic closed interval argument lines1410–1418. The root-transfer helper uses the broadened weak4A<=C hypothesis in BennettRootApproximation.

Parent owns all remote writes, compiler runs, and Git. New work proceeds to ordinary-three order2 M; this Q chain remains frozen pending actual compiler feedback.
