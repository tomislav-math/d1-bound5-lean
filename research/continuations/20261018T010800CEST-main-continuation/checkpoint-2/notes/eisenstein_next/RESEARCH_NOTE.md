# Exceptional Eisenstein product-minus-one pair

Uncompiled Lean drafts for root-owned sequential compilation:
1. `EisensteinPellDescent.lean`
2. `EisensteinExceptionalPair.lean`

The first proves a complete infinite solution constraint using exact integer
Pell descent. For r=x+yω, q=u+vω and r²+q²=ω (ω²=ω−1), define
M=x²+xy+y²+u²+uv+v² and D=xv−yu. The exact invariant is M²−3D²=1.
The maps (r,q)↦(2r+tq,−tr+2q), t=2ω−1, and its inverse preserve the
sum of squares and change M to 7M−12D and 7M+12D. For M>2 choose
by the sign of D; the new norm is nonnegative and strictly smaller.
Strong induction on M.toNat reaches M≤2, which bounds all four integer
coordinates to [-1,1]. The 81 cases yield q=(y,x) or q=(-y,-x), and
the property transports back by the exact inverse linear equations.

For the exceptional pair a=-ω,b=1-ω (ab=-1), actual roots
r²=az+1 and s²=bz+1 yield q=a*s and r²+q²=ω. The balanced relation
then forces 2*z.re+z.im=0. This endpoint has no size or nonzero assumptions.
The independent `EisensteinImaginaryExtensions` draft by source_audit uses
this trace-zero conclusion to exclude three further compatible nonzero
extensions; it does not depend on the descent proof.
