# Unit-pair cubic gap

Stable drafts, not yet compiler-verified:
1. UnitPairCubicNumeric.lean
2. UnitPairCubic.lean

The actual indexed endpoint IsD1Tuple.unit_pair_cubic_growth proves
|c|^3/2 < |d| for {-1,1,c,d}, with |c|>=9, |c|<=|d| and d!=-c.
The full-ring endpoint takes the five square conditions directly.

This finite proof avoids the manuscript's binomial series estimate.
Choose integral z with z^2=cd+1 and put w=c+d. The root products of
c+1,d+1 and 1-c,1-d have squares z^2+w and z^2-w. From C>=9 and C<=D,
|w| <= C+D and CD <= |z|^2+1 imply |w| < (15/64)|z|^2.
Existing sign perturbation at c=7/8 selects signs U,V of those same
integral roots with (15/8)|z||U-z|<|w| and the analogous V bound.

The exact identity
2z(U+V-2z) = -((U-z)^2+(V-z)^2)
retains second-order cancellation. Its left form L is nonzero, because
L=0 implies UV=z^2 and then w^2=0, contradicting d!=-c.
Discreteness therefore gives |L|>=1. The norm inequality yields
225|z|^3 < 64|w|^2 <=256D^2.
Also |z|^2 >= (80/81)CD. Squaring the first estimate and cubing the
second proves C^3 < [(256/225)^2(81/80)^3]D <2D.

All selected signs stay in the original full ring, zero input roots
are permitted, and no analytic or integrality premise is hidden in
the final theorem. Root owns copying, compiler verification and Git.
