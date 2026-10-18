from fractions import Fraction as F
from math import isqrt
from pathlib import Path
import json, re, ast
base=Path('/workspace/scratch/40edb97fa4c0')
recs=json.loads((base/'one_small_analytic_next/fixed_cutoff_certificates.json').read_text())
data=json.loads((base/'finite_next/one_small/finite_data.json').read_text())
pairs=data['pairs']+[dict(tau=0,nu=1,a=[1,0],b=[3,0],na=1,nb=9)]
triples=data['triples']+[dict(s=[8,0],ns=64)]
src=(base/'finite_n3_next/FiniteN3Height.lean').read_text()
vs=[]
for ell in range(4):
 raw=re.search(rf'def finiteN3Coeff{ell}[^=]+:=\s*(.*?)(?=\n\ndef |\n\ntheorem)',src,re.S).group(1).strip()
 vs.append(ast.literal_eval(raw.replace('!','')))
L=10**10
def ceilroot(v):
 lo=F(isqrt(v.numerator*L*L//v.denominator),L)
 return lo if lo*lo==v else lo+F(1,L)
for mode in ['ab','bs']:
 out=[]
 for r in recs:
  p=pairs[r['pair']];tau,nu=p['tau'],p['nu']
  a,b,nb=(p['a'],p['b'],p['nb']) if mode=='ab' else (p['b'],triples[r['index']]['s'],triples[r['index']]['ns'])
  def add(x,y):return[x[0]+y[0],x[1]+y[1]]
  def mul(x,y):return[x[0]*y[0]-nu*x[1]*y[1],x[0]*y[1]+x[1]*y[0]+tau*x[1]*y[1]]
  def powz(x,n):
   v=[1,0]
   for _ in range(n):v=mul(v,x)
   return v
  def norm(x):return x[0]**2+tau*x[0]*x[1]+nu*x[1]**2
  def poly(v):
   n=len(v)-1;res=[0,0]
   for j,z in enumerate(v):res=add(res,mul([z,0],mul(powz(a,j),powz(b,n-j))))
   return res
  weights=[];norms=[]
  for i in range(3):
   wi=[];ni=[]
   for j in range(2):
    wj=[];nj=[]
    for ell in range(4):
     n=norm(poly(vs[ell][i][j]));nj.append(n)
     bpow=7 if nb<=25 else 10-ell
     cbase=1000 if nb<=25 else 200
     w=ceilroot(F(n,nb**bpow))/cbase**(3-ell)
     assert F(n)<=w*w*nb**bpow*cbase**(6-2*ell)
     wj.append(w)
    wi.append(wj);ni.append(nj)
   weights.append(wi);norms.append(ni)
  value=F(101,100)*max(sum(sum(j) for j in i) for i in weights)
  computed=value.numerator//value.denominator+1
  target=r['Mn'] if mode=='ab' else r['Mbs']
  assert computed==target,(mode,r['index'],r['pair'],target,computed,float(value))
  out.append(dict(index=r['index'],pair=r['pair'],M=target,norms=norms,weights=[[[str(w) for w in j] for j in i] for i in weights]))
 (base/f'one_small_analytic_next/fixed_n3_{mode}_certificates.json').write_text(json.dumps(out,indent=2)+'\n')
 print(f'All57 N3/{mode} coefficient bounds match exactly after evaluation and norm.')
