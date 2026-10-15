#!/usr/bin/env python3
"""Source-bound assessment of approximation comments. Writes only this directory.
Reuses function definitions from the freshly audited exact polynomial engine,
without executing its tests, importing its module, or writing old results.
"""
from pathlib import Path
from fractions import Fraction as F
import ast,hashlib,json
ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'upload/D1_bound5-v1(1).tex';HERE=Path(__file__).resolve().parent
SHA='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
assert hashlib.sha256(SRC.read_bytes()).hexdigest()==SHA
source=SRC.read_text();checks=[]
def check(name,condition,detail=None):
 assert condition,(name,detail)
 checks.append({'name':name,'passed':True,**({'detail':detail} if detail is not None else {})})
# Obtain only audited function definitions. No prior top-level tests or writes run.
engine=ROOT/'review_v1/checks/approximation_v1_exact.py'
tree=ast.parse(engine.read_text());defs=ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef)],type_ignores=[])
ns={'F':F,'N':5,'ZERO':(0,)*5};exec(compile(defs,str(engine),'exec'),ns)
ns['V']=[ns['mon'](1,**{v:1}) for v in 'abstc']
a,b,s,t,c=ns['V'];add,scale,mul,power,shift,pairrows=[ns[n] for n in ('add','scale','mul','power','shift','pairrows')]
Rab=pairrows(a,b,'R');Rbs=pairrows(b,s,'R');Ras=pairrows(a,s,'R');Tas=pairrows(a,s,'T');Tbs=pairrows(b,s,'T')
H=ns['radd'](Rab,Rbs,ns['rneg'](Ras));V=ns['radd'](Tas,ns['rneg'](Tbs))
def W(row):
 out={}
 for anchor in range(3):
  for ex,co in shift(row[anchor+1],anchor,-1).items():
   ee=list(ex);ee[anchor]-=4+ex[4];ii,jj,kk=ee[:3]
   check('tail exponent guard',ii+jj+kk+1<=0 and 2-jj-kk>=0 and 2-kk>=0)
   q=2-jj-kk;out[q]=out.get(q,F(0))+abs(co)
 return {k:int(v) for k,v in sorted(out.items())}
def plus(*ds):
 out={}
 for d in ds:
  for k,v in d.items():out[k]=out.get(k,0)+v
 return dict(sorted(out.items()))
weights={'H_combined':W(H),'H_separate':plus(W(Rab),W(Rbs),W(Ras)),'V_combined':W(V),'V_separate':plus(W(Tas),W(Tbs))}
check('H printed W from combined columns',weights['H_combined']=={1:590,4:590,5:590})
check('V printed W from combined columns',weights['V_combined']=={0:885,1:1144,2:435,3:2634,4:170})
check('H separate absolute coefficient sum differs',weights['H_separate']=={1:590,2:286,4:1162,5:590})
check('V separate absolute coefficient sum differs',weights['V_separate']=={0:885,1:1144,2:435,3:2718,4:170})
# Exact degeneracy identity E = (s-a)^2 + (a+s)L.
L=add(scale(s,2),scale(a,-1),scale(b,-1))
E=add(scale(power(s,2),3),scale(mul(add(a,b),s),-1),scale(mul(a,b),-1))
check('rank degeneration identity',E==add(power(add(s,scale(a,-1)),2),mul(add(a,s),L)))
check('rank contradiction existing guard',6*200>28)
# Actual normalizations: no hidden factor differs between P and its all-large use.
tau=F(21,1024*999);Rp=F(35,16)+tau*5268;Rp0=4*(F(25,16)+tau*2676)
check('exact P residual',Rp==F(65233,28416) and Rp<F(23,10)<3)
check('exact P0 residual',Rp0==F(45961,7104) and Rp0<F(13,2)<7)
eps=F(1,4000);hh=F(4001,3999);kap=F(3535,409600);phase=F(8,5)**4*F(12,5)**6
Mn=4143;M3=2265;M4=166000;M5=26859063;Rn=F(35,32);R3=F(35,16);R4=F(63,8);R5=F(495,64);Mm=F(8,9)*608**2;Rm=F(3920,81)
def ratios(K,rp,rp0,phase_sensitive,onlyP=False):
 A=B=S=F(3)
 out={
 'start-Q':1024*A**20*B**10*(1-eps)/12100,
 'Q-N2':256*A**16*S**4/(36*735**2*hh),
 'N2-P-BS3':K*K*A**20*B**4/(25*2400**2*hh),
 'N2-P-B3S2':K*K*A**20*S**2/(25*2400**2*hh),
 'N2-P0-S4':K*K*A**20*B**4/(4*25*39000**2*hh),
 'N2-P0-B5':K*K*A**20*B**2/(25*39000**2*hh),
 'P-N3':K*K*A**20/(16*rp**2*Mn**2*hh),
 'P-A3':K*K*A**20/(16*rp**2*M3**2*hh),
 'P0-A3':K*K*A**20/(16*rp0**2*M3**2*hh),
 'A3-M':K**4*A**36/(16*R3**2*Mm**2*hh),
 'M-N3':K**4*A**34*B**2*S**2/(16*Rm**2*Mn**2*hh),
 'N3-A4':K*K*A**22*B**4/(16*Rn**2*M4**2*hh),
 'N3-N3bs':K**4*A**36*B**8/(16*Rn**2*Mn**2*hh),
 'N3bs-A4':(F(3456)**2/(kap**2*phase**2) if phase_sensitive else K*K/Rn**2)*A**14/(16*M4**2*hh),
 'A4-O4':K**4*A**38*B**2/(144*R4**2*42**8*hh),
 'O4-A5':K**4*A**36/(4*M5**2*F(5,2)**8*hh),
 'A5-O5':K**6*A**54*B**10/(144*R5**2*42**10*hh),
 'O5-O6':K**6*A**52*B**4/(36*42**12*F(5,2)**10*hh)}
 if onlyP:out={k:v for k,v in out.items() if 'P0' not in k}
 return out
oldresults=json.loads((ROOT/'review_v1/checks/completion_v1_all_large_results.json').read_text())
check('current 18 ratios independently reproduced',{k:str(v) for k,v in ratios(F(54),F(145),F(300),True).items()}==oldresults['original_ratios'])
variants={}
for K,phase_sensitive in [(54,True),(400,False)]:
 for name,rp,rp0,onlyP in [('old',F(145),F(300),False),('fractional',F(23,10),F(13,2),False),('clean',F(3),F(7),False),('P_only_clean',F(3),F(7),True)]:
  rr=ratios(F(K),rp,rp0,phase_sensitive,onlyP);key=f'K{K}_{name}'
  for junction,value in rr.items():check(key+' '+junction,value>1)
  check(key+' infinite tail',F(K,105)*3**12>1)
  smallest=min(rr,key=rr.get)
  variants[key]={'comparisons':len(rr),'minimum_junction':smallest,'minimum':str(rr[smallest]),'minimum_decimal':float(rr[smallest]),'ratios':{k:str(v) for k,v in rr.items()}}
check('P02 K400 ratios independently reproduced',variants['K400_old']['ratios']==oldresults['proposed']['ratios'])
# Source-independent raw incoming comparison for a hypothetical universal P0 bound.
# Every T row has coefficient monomials of degree 5, so a global generic bound
# uses S^5 instead of max(S^4,B^5). Then N2->P0 ratio has factor B^6/S^4.
check('global P0 incoming not uniform as S grows',F(3**6,30**4)<F(3**6,3**4))
# Precise source checks for explanation and branch contexts.
check('W wording unique',source.count('Sum the original absolute integer coefficients, before Taylor\ncancellation, with weight $x^{2-j-k}$. This gives $W_i(x)$.')==1)
check('rank condition source unique',source.count('For the four-row matrix it suffices to prove $F_s\\ne0$.')==1)
check('unconditional P inequality source unique',source.count('Under either rank condition above, and $B\\ge qA$, we conclude that')==1)
res={'source':str(SRC.relative_to(ROOT)),'source_sha256':SHA,'engine_definitions_sha256':hashlib.sha256(engine.read_bytes()).hexdigest(),'checks':checks,'check_count':len(checks),'tail_weights':weights,'residuals':{'P_exact':str(Rp),'P0_exact':str(Rp0),'P_clean':3,'P0_clean':7},'variants':variants,'rank_proof':{'identity':'E=(s-a)^2+(a+s)L','nonzero_integral_E_bound':'|E|>=1','contradiction':'6C<=28S versus C>=200S','zero_E_case':'L=0 and E=0 force (s-a)^2=0, then b=s'}}
(HERE/'results.json').write_text(json.dumps(res,indent=2)+'\n')
print(json.dumps({'status':'PASS','checks':len(checks),'variants':{k:{p:v[p] for p in ('comparisons','minimum_junction','minimum','minimum_decimal')} for k,v in variants.items()},'tail_weights':weights},indent=2))
