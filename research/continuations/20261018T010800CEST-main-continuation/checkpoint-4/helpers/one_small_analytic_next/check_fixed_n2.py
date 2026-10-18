from fractions import Fraction as F
from math import isqrt
from pathlib import Path
import json
base=Path('/workspace/scratch/40edb97fa4c0')
recs=json.loads((base/'one_small_analytic_next/fixed_cutoff_certificates.json').read_text())
data=json.loads((base/'finite_next/one_small/finite_data.json').read_text())
pairs=data['pairs']+[dict(tau=0,nu=1,a=[1,0],b=[3,0],na=1,nb=9)]
vs=[[[[0,20,-4],[4,-20,0]],[[15,10,-1],[-4,-20,0]],[[0,-20,-4],[-1,10,15]]],
[[[0,0,60,-28],[28,-60,0,0]],[[0,80,-40,8],[12,-60,0,0]],[[0,0,-60,12],[8,-40,80,0]]],
[[[0,0,0,40,-24],[24,-40,0,0,0]],[[0,0,80,-80,24],[16,-40,0,0,0]],[[0,0,0,-40,16],[24,-80,80,0,0]]]]
L=10**10
def ceilroot(v):
 lo=F(isqrt(v.numerator*L*L//v.denominator),L)
 return lo if lo*lo==v else lo+F(1,L)
out=[]
for r in recs:
 p=pairs[r['pair']];tau,nu=p['tau'],p['nu'];a,b=p['a'],p['b'];nb=p['nb']
 def add(x,y):return[x[0]+y[0],x[1]+y[1]]
 def mul(x,y):return[x[0]*y[0]-nu*x[1]*y[1],x[0]*y[1]+x[1]*y[0]+tau*x[1]*y[1]]
 def powz(x,n):
  v=[1,0]
  for _ in range(n):v=mul(v,x)
  return v
 def norm(x):return x[0]**2+tau*x[0]*x[1]+nu*x[1]**2
 def poly(v):
  n=len(v)-1;res=[0,0]
  for j,k in enumerate(v):res=add(res,mul([k,0],mul(powz(a,j),powz(b,n-j))))
  return res
 # Important: QuadInt relation is theta²=tau*theta-nu, as in norm.
 weights=[];norms=[]
 for i in range(3):
  wi=[];ni=[]
  for j in range(2):
   wj=[];nj=[]
   for ell in range(3):
    n=norm(poly(vs[ell][i][j]));nj.append(n)
    bpow=4 if nb<=25 else 6-ell
    k=1000 if nb<=25 else 200
    w=ceilroot(F(n,nb**bpow))/k**(2-ell)
    assert F(n)<=w*w*nb**bpow*k**(4-2*ell)
    wj.append(w)
   wi.append(wj);ni.append(nj)
  weights.append(wi);norms.append(ni)
 maxsum=max(sum(sum(j) for j in i) for i in weights)
 computed=(F(101,100)*maxsum).numerator//(F(101,100)*maxsum).denominator+1
 assert computed==r['M2'],(r['index'],r['pair'],r['M2'],computed,float(maxsum))
 out.append(dict(index=r['index'],pair=r['pair'],M2=r['M2'],norms=norms,weights=[[[str(w) for w in j] for j in i] for i in weights]))
(base/'one_small_analytic_next/fixed_n2_certificates.json').write_text(json.dumps(out,indent=2)+'\n')
print('All57 N2 fixed-row M2 values match exactly after evaluation and norm.')
