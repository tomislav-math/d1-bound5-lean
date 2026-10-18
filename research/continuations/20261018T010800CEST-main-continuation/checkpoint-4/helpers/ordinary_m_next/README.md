# Ordinary three-anchor order-two family M

Research continuation sources; parent owns the serial remote Lean compiler gate and Git persistence. No source in this directory is represented as compiler-accepted merely because it exists here.

## Exact construction

For H=abs, Delta=(a-b)(a-s)(b-s), nodes=(0,bs,as,ab), N=Hc, let
Q_ij=(4H^2 Delta^2)^2 G_ij(N), using the actual Bennett cleared residue polynomial at k=2, nu=1/2. Divide rows by (Delta,a(b-s),b(a-s),s(a-b)), then columns by (1,a,b,s). `finiteMDividedMatrix` is the resulting integer-polynomial matrix.

`FiniteMMatrix.lean` stores the exact88 factored Taylor terms, rather than their larger expanded form. `FiniteMBennettIdentity.lean` identifies them with actual G and derives nonsingularity from the already-proved arbitrary-order determinant. Its determinant is -226800 H^2 Delta^10, but the new Lean source does not need to expand a4x4 determinant.

## Simpler height proof

Each root-column monomial is bounded using |a|<=B, |a-b|<=2B, |a-s|,|b-s|<=2S, and |u c+1|<=2SC. Its S exponent is at most8, total anchor degree at most11, and terminal exponent at most2. A finite natural-number certificate yields row weight38400 for row0 and169728 for rows1,2,3. Therefore

sum_j>=1 |D_ij| <=169728 B^3 S^8 C^2.

The signed-root transfer constant3/2 gives254592 < (8/9)*608^2, so the manuscript's height constant follows with considerable slack. No rho/tau or phase-sector estimate is needed here.

## Actual residual

`FiniteMResidualPoint.lean` specializes the actual general Bennett residual to four nodes and order2. The coefficient is |choose(5/2,8)|=45/32768. Homogenization and clearing yield

|R_i theta| < (101/100)*(45/2048)*|Delta|^4/(A^2 B^2 S^2 C^6 |d_i|).

`FiniteMResidual.lean` proves A|Delta|^4 <=2048 B^4 S^7 |d_i| from1<=A<=B<=S and triangle bounds. This yields the manuscript bound

|R_i theta| < (3920/81) B^2 S^5/(A^3 C^6).

The final residual theorem includes hA1:1<=|a| before hAB,hBS,hAC. This is an actual full-ring norm fact at the tuple endpoint.

## Ownership and intake order

1. FiniteMMatrix
2. FiniteMBennettIdentity
3. FiniteMHeight (depends only on Matrix)
4. FiniteMResidualPoint (also depends on BennettResidualBound and shared FiniteEtaBound)
5. FiniteMResidual

Crossblock owns integral-row selection, root-transfer, full-ring approximation, and both common-epsilon and coarse closed windows. Source_audit owns final all-large interval overlap assembly.

`generate_terms.py` reconstructs the88 factored integer terms directly from finite Taylor indices. `verify_exact.py` independently computes rational Taylor coefficients without the factor table and checks all16 entries at four distinct signed specializations; all checks pass, as does the exact determinant value there. These checks support source review, and do not replace Lean proof checking.
