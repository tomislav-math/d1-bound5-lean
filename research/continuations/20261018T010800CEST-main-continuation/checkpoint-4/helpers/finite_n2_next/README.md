# Actual finite N2 family

Frozen source drafts; the parent is the only Lean compiler and remote
writer. None of these new files is claimed compiled at creation.

The construction is exactly the frozen manuscript's k=m=2,g=2 generator.
The integer polynomial matrix has row factors2(x-y),2x,2y relative to the
ordinary Bennett k2 matrix. The exact divided determinant is
`-225*(x-y)^7`; restoring anchor columns gives`-225*x*y*(x-y)^7`, equal
to the manuscript determinant after division by g^3.

The coefficients were expanded using the local exact Fraction script.
The script proposes definitions only: Lean's polynomial identities prove
the definitions equal the actual Bennett entries, and prove their
determinant and coefficient decomposition. The script is not an oracle.

The actual root coefficient sums after g division are bounded by50,200,240
in c degrees0,1,2. Exact rational slack gives the manuscript constant243.
The analytic residual is reused from actual ordinary k2; beta5/1024 is
evaluated by the proved Pochhammer product. The shared eta estimate uses
the rational inequality(999/1000)^9>100/101 and covers every finite
family exponent at most9. It gives both the uniform5/4 residual and the
distance-sensitive bound

`(101/2560)*max(delta^4,A*delta^3)/(A^3*B^2*C^4)`.

`full_ring_finiteN2_inequalities` constructs signs of actual integer root
products and a nonzero actual integer row. It returns both strict form
inequalities from four distinct actual tuple entries. Its hypotheses
contain no determinant, integrality, coefficient or residual certificate.
`full_ring_finiteN2_closed_interval_excluded` proves the whole uniform
closed interval, including endpoints, is forbidden. Fixed-anchor
coefficient refinements remain to be instantiated separately.

Dependency order:
FiniteHomogeneousTwo, FiniteEtaBound, FiniteN2Matrix,
FiniteN2BennettIdentity, FiniteN2IntegralRows, FiniteN2Height,
FiniteN2Residual, FiniteN2RowBound, FiniteN2FullRing, FiniteN2Interval.
External shared dependencies: FiniteRootApproximation (N3 directory),
FiniteRowRootTransfer and FiniteClosedWindow (Q directory).
