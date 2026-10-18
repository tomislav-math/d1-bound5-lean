# Statement review of the two-anchor integral matrix unit

This is the current assistant's source/statement review, NOT an independent review or an alternative kernel implementation. Every reported Lean statement must still be supported by the actual combined elaborated-type/axiom log and targeted replay receipts.

## Exact original scopes

BennettTwoIntegralSummands proves three signed scalar summands integral in a subring of any characteristic-zero field. The hypotheses d0+d1+d2=1 and h0+h1+h2+1=k+dj are explicit at this intermediate level. In BennettTwoIntegralEntries these equalities are proved from i in Fin 3 and membership in both complete antidiagonal sums. No numerical range of k or incomplete selection of summands is used. Each positive integer k and all three rows are covered.

The row-lift theorem uses the range subring of an arbitrary ring homomorphism. Witnesses q0,q1,q2 return to the original commutative ring. The actual columns are respectively f(q0), f(a^k*q1), f(b^k*q2). Unique factorization, a principal-ideal property, rational-integral coordinates and any order smaller than the full integer ring are absent.

BennettTwoIntegralMatrix proves a nonzero determinant for the actual cleared matrix at every c in the field. It invokes the already constructed constant determinant theorem, which is in the current source/dependency closure, not an archived or assumed certificate. The factor (4*a*b*(a-b)^2)^k is nonzero under a!=0, b!=0 and a!=b. No nonsingularity hypothesis is added.

BennettIntegralRowSelection considers L_i=Q_i0*z+Q_i1*(sA/a)+Q_i2*(sB/b). Nonsingularity and z!=0 imply some L_i!=0. The divisibilities supply the explicit original-ring lift q0*z+a^(k-1)*q1*sA+b^(k-1)*q2*sB, including k=1. For K a totally complex number field of Q-dimension two and entries in its full ring of integers, a nonzero lift has complex modulus at least one. The endpoint requires a,b,z nonzero and a!=b, but c,sA,sB can vanish. It does not assume D(1) equations, norm ordering or unequal moduli. A later tuple application must prove its terminal z is nonzero; zero pair-square roots have not been excluded from MainStatement.

The identification with the unhomogenized original residue has an extra c!=0 assumption exactly where evaluation at (abc)^(-1) requires it. That assumption is not silently exported into other endpoints.

## Original-header and preservation gate

All four prepared working sources were read before execution and preserved in this run's .before.lean snapshots. Their final source bytes are required to match exactly; this run is a substantive verification batch, not a claim of newly invented mathematical theorems. Source snapshots in research are preservation copies, not additional accepted-root imports.

## Remaining obligations

Actual analytical upper bounds and root approximation/transfer are separate prerequisites of FullRingOrdinaryHeight. The conditional cutoff from the preceding run is not yet instantiated for every needed tuple. No MainStatement proof, accepted-root integration, clean-checkout build, fresh whole-root replay, or independent final statement audit is claimed here.
