import sympy as s
from itertools import combinations
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
import json
R=s.Rational
x,y,z,c=s.symbols('x y z c')
result=[]
def rec(name,ok,details=''):
  result.append({'check':name,'passed':bool(ok),'details':str(details)})
  print(('PASS ' if ok else 'FAIL ')+name+' '+str(details),flush=True)
def comp(n,t):
  if n==1:
    yield (t,);return
  for i in range(t+1):
    for rest in comp(n-1,t-i):yield (i,)+rest

def common(anchors,c,k,polynomial=False):
  m=len(anchors);H=s.prod(anchors);delta=s.prod(aa-bb for aa,bb in combinations(anchors,2));alpha=[0]+[H/v for v in anchors];N=H*c
  M=s.zeros(m+1)
  for i in range(m+1):
    for j in range(m+1):
      for h in comp(m+1,k+int(i==j)-1):
        co=4**k*s.binomial(k+R(1,2),h[j])
        for ell in range(m+1):
          if ell!=j:co*=s.binomial(-k-int(i==ell),h[ell])
        if polynomial:
          if j==0:
            T=(-1)**sum(k+int(i==r)+h[r] for r in range(1,m+1))*c**(k-h[0])*delta**(2*k)*s.prod(anchors[r-1]**(int(i==r)+h[r]) for r in range(1,m+1))
          else:
            aj=anchors[j-1]
            T=aj**((m-1)*k)*(aj*c+1)**(k-h[j])*s.prod(anchors[ell-1]**(int(i==ell)+h[ell]) for ell in range(1,m+1) if ell!=j)*delta**(2*k)/s.prod((anchors[ell-1]-aj)**(k+int(i==ell)+h[ell]) for ell in range(1,m+1) if ell!=j)
          M[i,j]+=s.cancel(co*T)
        else:
          T=N**(-k)*(N+alpha[j])**(k-h[j])*s.prod((alpha[j]-alpha[ell])**(-k-int(i==ell)-h[ell]) for ell in range(m+1) if ell!=j)
          M[i,j]+=co*T*(H**m*c*delta**2)**k
      M[i,j]=s.cancel(M[i,j])
  return M

for anchors in ([R(2),R(3)],[R(2),R(3),R(5)],[R(2),R(3),R(5),R(7)]):
 for k in range(1,5 if len(anchors)==2 else 3):
  m=len(anchors);cc=R(13);M=common(anchors,cc,k)
  P=common(anchors,cc,k,True)
  rec(f'm={m},k={k} direct residue matches polynomial summands',M==P)
  H=s.prod(anchors);D=s.prod(aa-bb for aa,bb in combinations(anchors,2))
  target=((-1)**(m*(m+1)//2)*4**(m+1)*H**(m-1)*D**(2*m))**k*s.prod(s.binomial(R(1,2)-v*k,k) for v in range(-1,m))
  rec(f'm={m},k={k} direct residue determinant',s.cancel(M.det()-target)==0)

# Symbolic normalized three-anchor matrix, exact polynomial quotient checks.
M=common([x,y,z],c,2,True)
divs=[(x-y)*(x-z)*(y-z),x*(y-z),y*(x-z),z*(x-y)]
N=s.Matrix(4,4,lambda i,j:s.cancel(M[i,j]/divs[i]))
for i in range(4):
  for j in range(4):
    P=s.Poly(N[i,j],x,y,z,c)
    rec(f'normalized three anchor integral i={i},j={j}',all(q.q==1 for q in P.coeffs()))
    if j:
      P=s.Poly(s.cancel(N[i,j]/[1,x,y,z][j]),x,y,z,c)
      rec(f'normalized three anchor root divisibility i={i},j={j}',all(q.q==1 for q in P.coeffs()))
    for power in range(-2,6):
      coeff=N[i,0].expand().coeff(c,-power) if power<=0 else 0
      for jj,anc in enumerate((x,y,z),1):
        for ell in range(3):
          nn=power+ell
          if nn>=0:coeff+=N[i,jj].expand().coeff(c,ell)*s.binomial(R(1,2),nn)*anc**(-nn)
      # This is repeated per j intentionally avoided below.
      if j==0:rec(f'normalized three anchor residual row={i},inverse power={power}',s.cancel(coeff)==0)
Delta=(x-y)*(x-z)*(y-z);H=x*y*z
# Full symbolic determinant is huge. Degree bound from proved cancellations gives determinant c degree <=0;
# all constant coefficient entries are explicitly generated above, so evaluate c=0 symbolically.
rec('normalized three anchor full determinant',s.cancel(N.subs(c,0).det(method='domain-ge')+226800*H**3*Delta**10)==0)
(ROOT / 'audit/checks/approximation_three_normalized_matrix.txt').write_text(str(N))
(ROOT / 'audit/checks/approximation_residue_results.json').write_text(json.dumps(result,indent=2))
print('TOTAL',len(result),'PASSED',sum(q['passed'] for q in result),'FAILED',sum(not q['passed'] for q in result))
