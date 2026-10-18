from fractions import Fraction as F
from itertools import permutations
import json
from pathlib import Path
terms=json.loads(Path('ordinary_m_next/terms.json').read_text())
def choose(x,n):
 r=F(1)
 for i in range(n):r*=F(x-i,i+1)
 return r
def mulpoly(x,y,r):return [sum(x[j]*y[n-j] for j in range(n+1)) for n in range(r+1)]
def raw(a,b,s,c,i,j):
 nodes=[0,b*s,a*s,a*b];N=a*b*s*c;delta=(a-b)*(a-s)*(b-s);r=1+(i==j)
 coeff=[F(1)]+[F(0)]*r
 for l in range(4):
  if l==j:continue
  p=2+(i==l);d=nodes[j]-nodes[l]
  coeff=mulpoly(coeff,[choose(-p,h)*F(1,d**(p+h)) for h in range(r+1)],r)
 return 16*(a*b*s)**4*delta**4*sum(choose(F(5,2),h)*coeff[r-h]*(N+nodes[j])**(2-h) for h in range(r+1))
def evalterm(t,a,b,s,v):
 co,ap,bp,sp,abp,asp,bsp,vp=t
 return co*a**ap*b**bp*s**sp*(a-b)**abp*(a-s)**asp*(b-s)**bsp*v**vp
for a,b,s,c in [(1,2,3,7),(-1,3,5,2),(2,-3,7,-4),(3,8,5,0)]:
 D=[[sum(evalterm(t,a,b,s,[c,a*c+1,b*c+1,s*c+1][j]) for t in terms[i][j]) for j in range(4)] for i in range(4)]
 delta=(a-b)*(a-s)*(b-s);rf=[delta,a*(b-s),b*(a-s),s*(a-b)]
 for i in range(4):
  for j in range(4):assert raw(a,b,s,c,i,j)==rf[i]*D[i][j]*[1,a,b,s][j]
 det=0
 for p in permutations(range(4)):
  sign=(-1)**sum(p[i]>p[j] for i in range(4) for j in range(i+1,4));v=sign
  for i in range(4):v*=D[i][p[i]]
  det+=v
 assert det==-226800*(a*b*s)**2*delta**10,(a,b,s,c,det)
print('PASS: direct rational Taylor coefficients match all16 factored entries at4 independent specializations; divided determinant matches -226800 H² Δ^10.')
for i,row in enumerate(terms):
 weights=[]
 for j,col in enumerate(row[1:],1):
  for co,ap,bp,sp,abp,asp,bsp,vp in col:
   assert sp+asp+bsp+vp<=8 and ap+bp+sp+abp+asp+bsp+vp<=11 and vp<=2
  weights.append(sum(abs(t[0])*2**sum(t[4:]) for t in col))
 assert sum(weights)<=169728
 print('row',i,'exact factored weights',weights,'total',sum(weights))
