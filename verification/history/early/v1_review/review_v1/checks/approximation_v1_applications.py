#!/usr/bin/env python3
"""Fresh downstream reproduction of finite coefficients from authoritative rows.
Imports only the new Section 4–5 exact construction, not earlier audits.
"""
from approximation_v1_exact import *
import re
TEXT=SOURCE.read_text();appchecks=[]
def ck(name,condition,detail=None):
 if not condition:raise AssertionError((name,detail))
 appchecks.append({'name':name,'passed':True,**({'detail':detail} if detail is not None else {})})
def table(start,end='\\end{longtable}'):
 return TEXT.split(start,1)[1].split(end,1)[0]
def rgmul(z,w,tau,nu):return(z[0]*w[0]-nu*z[1]*w[1],z[0]*w[1]+z[1]*w[0]+tau*z[1]*w[1])
def rgpow(z,n,tau,nu):
 ans=(1,0)
 for _ in range(n):ans=rgmul(ans,z,tau,nu)
 return ans
def norm(z,tau,nu):return z[0]**2+tau*z[0]*z[1]+nu*z[1]**2
def rootsqceil(q,places=10):
 q=F(q);scale=10**places;u=isqrt(q.numerator*scale**2//q.denominator)
 if F(u*u,scale**2)<q:u+=1
 return F(u,scale)
def specialized_ps(mat,x,y,tau,nu):
 rows=[]
 for row in mat:
  cols=[]
  for j in (1,2):
   pc={}
   for ex,co in shift(row[j],j-1,-1).items():
    z=rgmul(rgpow(x,ex[0],tau,nu),rgpow(y,ex[1],tau,nu),tau,nu)
    old=pc.get(ex[4],(0,0));pc[ex[4]]=(old[0]+co*z[0],old[1]+co*z[1])
   cols.append(pc)
  rows.append(cols)
 return rows
def fixed_threshold(name,k,m,g,x,y,tau,nu):
 yy=norm(y,tau,nu);P=m+2*k
 rows=specialized_ps(FAMILIES[name],x,y,tau,nu);bounds=[]
 for row in rows:
  bound=F(0)
  for col in row:
   for ell,z in col.items():
    np=norm(z,tau,nu);rr=k-ell
    ck(name+' specialized coefficient is integral',z[0].denominator==1 and z[1].denominator==1 and np.denominator==1)
    if yy<=25:bound+=rootsqceil(np/F(yy)**(P-2))/1000**rr
    else:bound+=rootsqceil(np/F(yy)**(P-2+rr))/200**rr
  bounds.append(bound*F(101,100*g))
 return max(bounds)
PAIRS={}
for line in table('\\caption{The forty first-pair representatives;').splitlines():
 mm=re.match(r'(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)',line)
 if mm:
  idx,d,ax,ay,bx,by,na,nb=map(int,mm.groups());tau=int(d%4==3);nu=(d+1)//4 if tau else d
  PAIRS[idx]=(d,(ax,ay),(bx,by),tau,nu,na,nb)
coeffs={}
for line in table('\\caption{Coefficient bounds for the forty fixed pairs.}').splitlines():
 mm=re.match(r'(\d+)&(\d+)&(\d+)&(\d+)&(\d+)&(\d+)',line)
 if mm:
  v=list(map(int,mm.groups()));coeffs[v[0]]=v[1:]
ck('parsed forty pair/coefficient rows',len(PAIRS)==len(coeffs)==40)
reproduced=[]
for idx,(d,x,y,tau,nu,na,nb) in PAIRS.items():
 ck(f'pair{idx} norms',norm(x,tau,nu)==na and norm(y,tau,nu)==nb)
 generated=[]
 for ff,(name,k,m,g,*_) in enumerate(PARAMS):
  threshold=fixed_threshold(name,k,m,g,x,y,tau,nu);value=threshold.numerator//threshold.denominator+1;generated.append(value)
  ck(f'pair{idx}/{name} exact printed integer',value==coeffs[idx][ff],{'computed':value,'printed':coeffs[idx][ff],'upper_bound':str(threshold)})
 reproduced.append({'pair':idx,'values':generated})
for (name,k,m,g,*_),printed in zip(PARAMS,[12,41,25,300,1100]):
 bound=fixed_threshold(name,k,m,g,(1,0),(3,0),0,1)
 ck(f'rational pair {name} coefficient bound',bound<printed,{'bound':str(bound),'printed':printed})
# Region-dependent coefficient bounds use the full monomial expansion.
regions=[(F(8),[36,282,145,4605,38390],F(7,50)),(F(8,3),[69,697,326,14771,171856],F(7,20)),(F(12,7),[109,1306,663,34919,482131],F(18,25)),(F(3,2),[130,1652,863,48019,701908],F(47,50)),(F(18,17),[220,3553,1944,134712,2400382],F(201,100))]
for q,ms,rp in regions:
 for (name,k,m,g,*_),printed in zip(PARAMS,ms):
  rows=[]
  for row in FAMILIES[name]:
   rows.append(sum(abs(co)*q**(-ex[0])*F(1000)**(ex[4]-k) for j in (1,2) for ex,co in shift(row[j],j-1,-1).items())*F(101,100*g))
  ck(f'q={q} {name} coefficient bound',max(rows)<printed,{'bound':str(max(rows)),'printed':printed})
 rv=sum(F(v,256)*q**(-i) for i,v in enumerate(L_PRINT[3]))+F(21,1024*999)*sum(v*q**(-i) for i,v in enumerate(W_PRINT[3]))
 ck(f'q={q} adaptive residual',rv<rp,{'bound':str(rv),'printed':str(rp)})
# Recompute N3 evaluated at each b,s in the final table, including nonunit b.
found=0
for line in table('\\caption{All remaining triples and the common cutoff procedure.').splitlines():
 mm=re.match(r'(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) &',line)
 if not mm:continue
 idx,sx,sy,ss,mbs,n0=map(int,mm.groups());d,x,y,tau,nu,na,nb=PAIRS[idx]
 ck(f'triple{found} third norm',norm((sx,sy),tau,nu)==ss)
 bound=fixed_threshold('N3',3,3,4,y,(sx,sy),tau,nu);result=bound.numerator//bound.denominator+1
 ck(f'triple{found} N3-bs exact printed integer',result==mbs,{'pair':idx,'third':[sx,sy],'computed':result,'printed':mbs})
 found+=1
ck('parsed 56 triple coefficient rows',found==56)
bound=fixed_threshold('N3',3,3,4,(3,0),(8,0),0,1)
ck('rational 1,3,8 N3-bs',bound.numerator//bound.denominator+1==34)
# Order-one four-anchor formulas, compared directly with generic residues.
anchors=[2,-3,5,7];hh=prod(anchors);dd=prod(anchors[i]-anchors[j] for i in range(4) for j in range(i+1,4))
for cv in [11,-13]:
 mat=ordmatrix(anchors,cv,1);expected=[[F(0)]*5 for _ in range(5)]
 for j,aj in enumerate(anchors,1):
  ej=F(dd**2,prod(ai-aj for ii,ai in enumerate(anchors,1) if ii!=j))
  expected[0][j]=4*aj**3*(aj*cv+1)*ej
  for i,ai in enumerate(anchors,1):
   if i!=j:expected[i][j]=4*aj**3*(aj*cv+1)*ai*ej/F(ai-aj)
  expected[j][j]=6*aj**3*ej-expected[0][j]-sum(expected[i][j] for i in range(1,5) if i!=j)
 ck(f'four root coefficient formulas c={cv}',all(mat[i][j]==expected[i][j] for i in range(5) for j in range(1,5)))
 ck(f'four root special determinant c={cv}',detnum(mat)==-1440*hh**3*dd**8)
res={'sha256':EXPECTED,'checks':appchecks,'check_count':len(appchecks),'reproduced_coefficients':reproduced,'scope':'Downstream finite coefficient values and four-anchor specialization. Does not claim to reproduce all interval overlaps or finite tuple enumerations.'}
(ROOT/'review_v1/checks/approximation_v1_applications_results.json').write_text(json.dumps(res,indent=2,default=str)+'\n')
print('APPLICATIONS PASS',len(appchecks),'checks')
