# Concrete finite Q family

Read frozen manuscript lines 1355–1420 and 1813–1873 directly. This is the
next finite family after the focused Bennett coefficient-majorant helper.

For every ordered pair u,v among a,b,s,t define over an arbitrary commutative
ring, using only integer polynomial operations:

```
Pu = u^2 - 5*u*v + (4*u^3 - 8*u^2*v)*c
Pv = 5*u*v - v^2 + (8*u*v^2 - 4*v^3)*c
Q0 = -(u-v)^3*(3+4*(u+v)*c)
Qu = u*Pu; Qv = v*Pv
```

The five rows are ab,as,bs,at,bt, in columns 0,a,b,s,t; unselected root
columns are zero. The exact determinant of Q entries is

```
180*a^2*b^2*s^2*t^2*(a-b)^2*(a-s)*(a-t)*(b-s)*(b-t)*(s-t).
```

For the divided matrix [Q0,Pa,Pb,Ps,Pt], the determinant is the same with
a,b,s,t to power1. This lower-degree identity may be cheaper to prove by
explicit sparse determinant expansion. The full matrix is the divided
matrix times diag(1,a,b,s,t). A generic ring polynomial definition gives
integrality upon evaluation; root-column divisibility is explicit.

Alternatively homogenize each linear-in-c entry as x*Q(1/x). The residual
against theta_u(x)=sqrt(1+x/u) vanishes below degree5, so the accepted generic
residual determinant lemma makes det of the original matrix constant in c.
Only its constant coefficient then needs a five-by-five polynomial check.

Exact cancellation data: for n=1,2,3,
the pairs of coefficient sums are
(u²−v²,4(u²−v²)), (6(u−v),12(u−v)),
(5(u/v−v/u),8(u/v−v/u)). Their combinations with half-binomial b_n,b_(n+1)
are zero. Q0 cancels c^1 and c^0 terms.

Analytic obligations still substantive: define actual row residual and prove
the convergent tail norm ≤3*T/(2*A²*C⁴). It follows from |b_n|≤5/128 for n≥4,
the first inverse monomial norm≤T/A², and the geometric ratio1/(AC)≤1/1000.
The divided row coefficient norm sum is≤36*T³*C.

The arithmetic root-vector approximation (paper ff-error) with e=3/2 gives
1<55*T³*C²/Z+3*T*Z/(2*A²*C⁴) for one nonzero form. Actual determinant and
full-ring integer norm lower bound must supply nonzero form, not a hypothesis.
The common root estimate is a separate dependency that Bennett's actual
ordinary approximation path also needs.

Final excluded interval endpoints before epsilon factors are
4*55²*T⁶*C³ and A⁴*C⁷/(9*T²), epsilon1/4000. Accepted generic IntervalChain
does not itself supply this family. Source generation intentionally paused
while root prioritizes the actual Bennett uniform-height coefficient bound.
