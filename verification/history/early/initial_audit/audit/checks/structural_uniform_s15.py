"""Independent reconstruction of the proposed universal S>=15 estimate.
No manuscript coefficient formula is used to construct the determinant majorant.
All 24 determinant permutations are expanded, before coefficient cancellation.
"""
from fractions import Fraction as F
from itertools import combinations,permutations
from collections import defaultdict
import json
edges=list(combinations(range(4),2))
k=list(map(lambda n:F(n,10000),[5506,5087,5014,5029,5005,5001]))
r=list(map(F,['1/3','1/15','1/90','1/45','1/270','1/1350']))
for rr,kk in zip(r,k):assert F(1,2)<kk<1 and rr*kk*kk<2*kk-1
# det(J+E), with zero diagonal in E and e_ij=e_ji.
det=defaultdict(F)
for p in permutations(range(4)):
 sign=(-1)**sum(p[i]>p[j] for i in range(4) for j in range(i+1,4))
 terms={(0,)*6:F(sign)}
 for i,j in enumerate(p):
  if i==j:continue
  eidx=edges.index(tuple(sorted([i,j])))
  new=defaultdict(F)
  for powers,coef in terms.items():
   new[powers]+=coef
   changed=list(powers);changed[eidx]+=1
   new[tuple(changed)]+=coef
  terms=new
 for powers,coef in terms.items():det[powers]+=coef
det={powers:coef for powers,coef in det.items() if coef}
assert {sum(p) for p in det}=={3,4}
lead=defaultdict(F);errors=defaultdict(F);quartic=defaultdict(F)
for powers,coef in det.items():
 exps=[1]*4
 product=F(1)
 for j,((u,v),e) in enumerate(zip(edges,powers)):
  exps[u]-=e;exps[v]-=e;product*=k[j]**e
 exps=tuple(exps)
 if sum(powers)==3:
  lead[exps]+=coef/8
  errors[exps]+=abs(coef)*(product-F(1,8))
 else:quartic[exps]+=abs(coef)*product
majorant={e:abs(lead[e])+errors[e] for e in lead}
alpha=majorant[(-1,-1,-1,1)]
W=F(1,4050)
beta=F(0)
for exps,coef in majorant.items():
 if exps==(-1,-1,-1,1):continue
 if exps==(1,-1,-1,-1):bound=3*W
 elif exps==(-1,1,-1,-1):bound=F(1,450)
 elif exps==(-1,-1,1,-1):bound=F(1,18)
 else:
  pair=tuple(i for i in range(4) if exps[i]==-1)
  assert len(pair)==2 and all(e in [-1,0] for e in exps)
  bound=r[edges.index(pair)]
 beta+=coef*bound
assert set(quartic)=={(-1,-1,-1,-1)}
beta+=quartic[(-1,-1,-1,-1)]*W
assert alpha==F(70428685819,250000000000)
assert beta==F(752304371871001601,4500000000000000000)
assert alpha<F(141,500) and beta<F(21,125)
assert F(141,500)*F(59,20)+F(21,125)==F(9999,10000)
assert alpha*F(59,20)+beta<F(9999,10000)<1
result={'method':'24 determinant permutations; signed cubic leading cancellation; absolute polynomial error expansion; exact fractions only','radii':[str(x) for x in r],'k':[str(x) for x in k],'rationalization_margins':[str(2*kk-1-rr*kk*kk) for rr,kk in zip(r,k)],'alpha':str(alpha),'beta':str(beta),'majorant_coefficient_by_modulus_laurent_weight':{str(e):str(c) for e,c in majorant.items()},'quartic_coefficient':str(quartic[(-1,-1,-1,-1)]),'upper_bound_at_tau_59_20':str(alpha*F(59,20)+beta),'margin_below_one':str(1-alpha*F(59,20)-beta),'verified':True}
open('audit/checks/structural_uniform_s15.json','w').write(json.dumps(result,indent=2)+'\n')
print('PASS: independent universal S>=15 bound T>(59/20)ABS')
print('alpha =',alpha)
print('beta =',beta)
print('exact margin below one =',1-alpha*F(59,20)-beta)
