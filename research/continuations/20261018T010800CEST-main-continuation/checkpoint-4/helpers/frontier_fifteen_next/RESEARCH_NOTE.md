# Fourth-entry frontier for S >= 15

Stable local drafts, not yet compiler-verified:
1. FrontierFifteenRootError
2. FrontierFifteenCofactors
3. FrontierFifteenNumeric
4. FrontierFifteenTuple

The actual endpoint IsD1Tuple.frontier_fifteen_growth proves
T > (59/20) A B S for every ordered full-ring D(1)-quadruple with
A<3, B>=3, S>=15. Full-ring discreteness supplies A>=1 and the
existing irregular-tail theorem supplies T>2BS>=90.

The six near-half constants are exactly those in the manuscript:
(5506,5087,5014,5029,5005,5001)/10000, corresponding to minimal
pair products (3,15,90,45,270,1350). They are established by existing
root perturbation with rational margins (40/49,24/25,993/1000,
49/50,99/100,99/100), retaining signs in the original integral ring.

The independent cubic envelopes give diagonal adjugate bounds
(252,256,277,282)/1000 and upper off-diagonal bounds
(142,142,144,143,148,181)/1000. These are rational roundings upward;
each is checked against its actual cubic expression. The leading
one-eighth cancellation is retained in every off-diagonal cofactor.
A common envelope551/1000 also gives |det F|<=1.

If T<=(59/20)ABS, the normalized determinant upper bound is at most
0.9995313580246914..., strictly below1. The Lean scalar proof uses
only exact rational arithmetic, not this displayed decimal. The same
signed matrix supplies the full-ring determinant lower bound, giving
the contradiction. No first-pair table assumption is needed.
