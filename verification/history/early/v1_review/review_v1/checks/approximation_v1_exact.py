#!/usr/bin/env python3
"""Fresh exact checks for Sections 4–5, source SHA bound; stdlib only.
Polynomials use 5 variables a,b,s,t,c, and Fraction coefficients.
No imports from any earlier audit or manuscript revision scripts.
"""
from fractions import Fraction as F
from itertools import permutations
from pathlib import Path
from math import factorial,comb,isqrt
import hashlib,json,time
ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'upload/D1_bound5-v1(1).tex'
EXPECTED='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
N=5; ZERO=(0,)*N
checks=[]
def check(name,condition,detail=None):
 if not condition: raise AssertionError((name,detail))
 checks.append({'name':name,'passed':True,**({'detail':detail} if detail is not None else {})})
def clean(p):return {e:v for e,v in p.items() if v}
def const(v):return {ZERO:F(v)} if v else {}
def mon(v,**e):
 z=[0]*N
 for k,x in e.items():z['abstc'.index(k)]=x
 return {tuple(z):F(v)} if v else {}
def add(*ps):
 d={}
 for p in ps:
  for e,v in p.items():d[e]=d.get(e,0)+v
 return clean(d)
def scale(p,v):return clean({e:x*v for e,x in p.items()})
def mul(p,q,cap=None):
 d={}
 for e,v in p.items():
  for f,w in q.items():
   g=tuple(x+y for x,y in zip(e,f))
   if cap is None or g[4]<=cap:d[g]=d.get(g,0)+v*w
 return clean(d)
def power(p,n):
 assert n>=0
 q=const(1)
 for _ in range(n):q=mul(q,p)
 return q
def shift(p,k,n):
 d={}
 for e,v in p.items():
  ee=list(e);ee[k]+=n;d[tuple(ee)]=v
 return d
def divpoly(p,q):
 d={}; r=p.copy(); fq=max(q);vq=q[fq]
 while r:
  er=max(r);dif=tuple(x-y for x,y in zip(er,fq))
  assert min(dif)>=0,(er,fq)
  co=r[er]/vq;d[dif]=co
  r=add(r,scale(mul({dif:co},q),-1))
 return d
def det(mat,cap=None):
 out={};n=len(mat)
 for p in permutations(range(n)):
  sig=(-1)**sum(p[i]>p[j] for i in range(n) for j in range(i+1,n));v=const(sig)
  for i,j in enumerate(p):v=mul(v,mat[i][j],cap)
  out=add(out,v)
 return out
def binom(x,k):
 z=F(1)
 for i in range(k):z*=F(x-i,i+1)
 return z
def comps(n,k):
 if k==1:yield (n,);return
 for j in range(n+1):
  for t in comps(n-j,k-1):yield (j,)+t
def evaluate(p,values):
 return sum(co*prod(v**e for v,e in zip(values,ex)) for ex,co in p.items())
def prod(xs):
 r=1
 for x in xs:r*=x
 return r
V=[mon(1,**{v:1}) for v in 'abstc'];a,b,s,t,c=V
diff=add(a,scale(b,-1))
PARAMS=[('N2',2,2,2,-1800,F(-15,64),F(5,1024),F(5,4)),('N3',3,3,4,235200,F(105,256),F(35,65536),F(35,32)),('A3',3,2,4,-156800,F(-35,256),F(35,32768),F(35,16)),('A4',4,3,2,23284800,F(3465,16384),F(63,524288),F(63,8)),('A5',5,4,4,-3995671680,F(-27027,65536),F(495,33554432),F(495,64))]
PRINTED_L={
'N2':[[96,352,256],[100,400,480]],
'N3':[[1344,9408,17024,8960],[1368,8384,23168,16384]],
'A3':[[800,4544,10368,6144],[1288,4256,9856,8960]],
'A4':[[10944,86784,350208,482304,215040],[18128,80512,276096,561920,327680]],
'A5':[[156000,1601280,9707520,22379520,22087680,7864320],[262152,1463264,6707712,22437888,28452864,12300288]]}
M_PRINT=[243,4143,2265,165763,3113013]
FAMILIES={}
def family(k,m):
 p=[m,k,k];out=[]
 for i in range(3):
  row=[]
  for j in range(3):
   q={}
   for h in comps(p[j]+int(i==j)-1,3):
    co=4**k*binom(F(2*k+1,2),h[j])*prod(binom(-p[l]-int(i==l),h[l]) for l in range(3) if l!=j)
    if j==0:
     term=mon((-1)**(2*k+int(i==1)+int(i==2)+h[1]+h[2]),a=int(i==1)+h[1],b=int(i==2)+h[2],c=k-h[0]);term=mul(term,power(diff,2*k))
    elif j==1:
     term=mon((-1)**(k+int(i==2)+h[2]),a=m,b=int(i==2)+h[2]);term=mul(term,power(add(mul(a,c),const(1)),k-h[1]));term=mul(term,power(diff,k-int(i==2)-h[2]))
    else:
     term=mon(1,b=m,a=int(i==1)+h[1]);term=mul(term,power(add(mul(b,c),const(1)),k-h[2]));term=mul(term,power(diff,k-int(i==1)-h[1]))
    q=add(q,scale(term,co))
   row.append(divpoly(q,[diff,a,b][i]))
  out.append(row)
 return out
def residual(mat,n):
 """Exact Laurent coefficient of c^{-n}, where n may be negative."""
 out=[]
 for row in mat:
  r={}
  for j,q in enumerate(row):
   for ex,v in q.items():
    deg=ex[4];power_bin=deg+n
    if j==0:
     if power_bin==0:r=add(r,shift({ex:v},4,-deg))
    elif power_bin>=0:
     rr=shift(shift({ex:v*binom(F(1,2),power_bin)},4,-deg),j-1,-power_bin)
     r=add(r,rr)
  out.append(r)
 return out
for ix,(name,k,m,g,Delta,J,beta,Rstar) in enumerate(PARAMS):
 mat=family(k,m);FAMILIES[name]=mat;P=m+2*k
 scalar_lists={2:[16,40,30],3:[64,224,280,140],4:[256,1152,2016,1680,630],5:[1024,5632,12672,14784,9240,2772]}
 check(name+' printed numerator scalar list',[4**k*binom(F(2*k+1,2),hh) for hh in range(k+1)]==scalar_lists[k])
 check(name+' all coefficients integral after g division',all(v.denominator==1 and v.numerator%g==0 for row in mat for q in row for v in q.values()))
 check(name+' anchor divisibility',all(ex[j-1]>=1 for row in mat for j in (1,2) for ex in row[j]))
 for n in range(-k,P-k):check(name+f' residual coefficient c^({-n}) vanishes',all(not r for r in residual(mat,n)))
 check(name+' predicted first residual not identically zero',any(residual(mat,P-k)))
 expected=scale(mul(mon(1,a=m-1,b=m-1,c=k-m),power(diff,4*k-1)),Delta)
 # Full determinant, without truncating c or using the residual degree bound.
 check(name+' full symbolic determinant',det(mat)==expected)
 lp=[]
 for i in range(3):
  cols=[shift(mat[i][1],0,-1),shift(mat[i][2],1,-1)]
  check(name+f' row{i} homogeneous weight',all(e[0]>=0 and e[1]>=0 and e[0]+e[1]==e[4]+P-k-2 and 0<=e[4]<=k for q in cols for e in q))
  sums=[sum(abs(v) for q in cols for e,v in q.items() if e[4]==l) for l in range(k+1)]
  check(name+f' row{i} printed coefficient sums',sums==PRINTED_L[name][int(i>0)],list(map(int,sums)));lp.append(sums)
 threshold=F(101,100*g)*max(sum(z*F(1000)**(l-k) for l,z in enumerate(row)) for row in lp)
 check(name+' printed uniform M',threshold<M_PRINT[ix],str(threshold))
 exactbeta=F(factorial(2*k+2)*factorial(2*P-2*k-2),4**P*factorial(k+1)*factorial(P-k-1)*factorial(P))
 lam=F(2*k+1,2)-m
 aa=[(-1)**j*binom(lam,j)*binom(lam-k-j,k-j) for j in range(k+1)]
 bb=[(-1)**j*binom(lam,j)*binom(lam-k-1-j,k-1-j) for j in range(k)]
 def at(v,i):return v[i] if 0<=i<len(v) else 0
 for rr in range(2*k+1):check(name+f' printed convolution r={rr}',sum(at(aa,j)*at(aa,k-rr+j)-at(bb,j)*at(bb,k-rr+j) for j in range(k+1))==J*(-1)**rr*comb(2*k,rr))
 def ABpoly(xx,yy,which):
  dxy=add(xx,scale(yy,-1));ans={};upper=k if which=='A' else k-1
  for hh in range(upper+1):
   ans=add(ans,scale(mul(power(xx,hh),power(dxy,upper-hh)),binom(-k-int(which=='B'),hh)*binom(lam,upper-hh)))
  return ans
 block=[[scale(mul(power(a,m-1),ABpoly(b,a,'A')),4**k),scale(mul(power(b,m),ABpoly(a,b,'B')),4**k)],
        [scale(mul(power(a,m),ABpoly(b,a,'B')),4**k),scale(mul(power(b,m-1),ABpoly(a,b,'A')),4**k)]]
 actual=[[{ex:co for ex,co in mat[ii][jj].items() if ex[4]==0} for jj in (1,2)] for ii in (1,2)]
 check(name+' printed constant root block',actual==block)
 check(name+' J',(-1)**k*binom(lam,k)*binom(lam-k,k)==J)
 check(name+' Delta',4**k*binom(F(2*k+1,2),m)*16**k*J==Delta)
 check(name+' beta',exactbeta==beta)
 check(name+' Rstar',2*16**k*beta/g==Rstar)
 print(name,'completed',flush=True)

# Quadratic and linear rows are entered directly, not derived from finite families.
def pairrows(u,v,kind):
 if kind=='R':
  pu=[add(scale(power(u,2),7),scale(mul(u,v),-35)),add(scale(power(u,3),64),scale(mul(power(u,2),v),-140)),add(scale(power(u,4),72),scale(mul(power(u,3),v),-120))]
  pv=[add(scale(mul(u,v),35),scale(power(v,2),-7)),add(scale(mul(u,power(v,2)),140),scale(power(v,3),-64)),add(scale(mul(u,power(v,3)),120),scale(power(v,4),-72))]
 elif kind=='T':
  pu=[add(scale(power(u,3),-15),scale(mul(power(u,2),v),56),scale(mul(u,power(v,2)),-105)),add(scale(power(u,4),-180),scale(mul(power(u,3),v),512),scale(mul(power(u,2),power(v,2)),-420)),add(scale(power(u,5),-240),scale(mul(power(u,4),v),576),scale(mul(power(u,3),power(v,2)),-360))]
  pv=[add(scale(mul(u,power(v,2)),70),scale(power(v,3),-6)),add(scale(mul(u,power(v,3)),100),scale(power(v,4),-12)),scale(power(v,5),24)]
 else:
  pu=[add(power(u,2),scale(mul(u,v),-5)),add(scale(power(u,3),4),scale(mul(power(u,2),v),-8))]
  pv=[add(scale(mul(u,v),5),scale(power(v,2),-1)),add(scale(mul(u,power(v,2)),8),scale(power(v,3),-4))]
 q0={};row=[{}, {}, {}, {}, {}]
 for fixed,pc in [(u,pu),(v,pv)]:
  j=next(i for i in range(4) if V[i]==fixed)
  for ell,pe in enumerate(pc):
   row[j+1]=add(row[j+1],shift(mul(fixed,pe),4,ell))
   for n in range(ell+1):q0=add(q0,scale(shift(shift(mul(fixed,pe),j,-n),4,ell-n),-binom(F(1,2),n)))
 row[0]=q0
 return row
def radd(*rows):return [add(*(r[j] for r in rows)) for j in range(5)]
def rneg(row):return [scale(q,-1) for q in row]
def general_residual(row,n):
 r={}
 for j,q in enumerate(row):
  for ex,v in q.items():
   nn=n+ex[4]
   if j==0:
    if nn==0:r=add(r,shift({ex:v},4,-ex[4]))
   elif nn>=0:r=add(r,shift(shift({ex:v*binom(F(1,2),nn)},4,-ex[4]),j-1,-nn))
 return r
Rab=pairrows(a,b,'R');Rbs=pairrows(b,s,'R');Ras=pairrows(a,s,'R');Tab=pairrows(a,b,'T');Tbs=pairrows(b,s,'T');Tsa=pairrows(s,a,'T');Tas=pairrows(a,s,'T')
H=radd(Rab,Rbs,rneg(Ras));VV=radd(Tas,rneg(Tbs));ADAPT=[Rab,H,Tab,VV];UNIVERSAL=[Rab,Rbs,Ras,Tab,Tbs,Tsa]
for name,row in [('Rab',Rab),('Tab',Tab),('H',H),('V',VV),('Rbs',Rbs),('Ras',Ras),('Tbs',Tbs),('Tsa',Tsa)]:
 check(name+' integral polynomial row',all(v.denominator==1 and min(e)>=0 for q in row for e,v in q.items()))
 check(name+' anchor divisibility',all(e[j-1]>=1 for j in range(1,5) for e in row[j]))
 for n in range(-2,5):check(name+f' cancellation n={n}',not general_residual(row,n))
ER=add(mon(F(5,128),a=-2),mon(F(-5,128),b=-2),mon(F(5,256),a=1,b=-3),mon(F(-5,256),a=-3,b=1))
ET=add(mon(F(-75,128),a=-1),mon(F(5,16),a=-2,b=1),mon(F(-15,256),a=-3,b=2),mon(F(-35,256),a=1,b=-2),mon(F(15,32),b=-1))
check('printed ER',general_residual(Rab,5)==ER);check('printed ET',general_residual(Tab,5)==ET)
Fs=add(scale(add(scale(s,2),scale(a,-1),scale(b,-1)),7),scale(mul(c,add(scale(power(s,2),3),scale(mul(add(a,b),s),-1),scale(mul(a,b),-1))),6))
base=mul(mon(1,a=2,b=2,s=2),mul(power(diff,4),mul(add(a,scale(s,-1)),add(b,scale(s,-1)))))
# The full 4x4 determinants are expanded, not just constant/linear terms.
check('universal full polynomial 4x4 minor',det([r[:4] for r in UNIVERSAL[:4]])==scale(mul(base,Fs),15750))
check('adaptive full polynomial 4x4 determinant',det([r[:4] for r in ADAPT])==scale(mul(mul(base,diff),Fs),-78750))
PRINTED_DEG=[[84,408,384],[210,840,720],[252,1224,1200],[492,2424,2352]]
L_PRINT=[[0,5,10,0,10,5],[0,10,0,0,10,10],[15,80,150,120,35,0],[15,80,150,280,35,0]]
W_PRINT=[[0,295,143,0,143,295],[0,590,0,0,590,590],[885,1144,435,42,170,0],[885,1144,435,2634,170,0]]
for idx,row in enumerate(ADAPT):
 pp=[shift(row[j],j-1,-1) for j in range(1,4)]
 ds=[sum(abs(v) for q in pp for ex,v in q.items() if ex[4]==ell) for ell in range(3)]
 check(f'adaptive row {idx} degree sums',ds==PRINTED_DEG[idx],list(map(int,ds)))
 leading=general_residual(row,5);ll=[F(0)]*6;ww=[0]*6
 for ex,v in leading.items():
  i,j,k=ex[:3];check(f'row{idx} leading monomial guards {ex}',i+j+k+1<=0 and 2-j-k>=0 and 2-k>=0)
  ll[2-j-k]+=abs(v)*256
 for fixed in range(3):
  for ex,coef in pp[fixed].items():
   ee=list(ex);ee[fixed]-=4+ex[4];i,j,k=ee[:3]
   check(f'row{idx} tail monomial guards {ex}/{fixed}',i+j+k+1<=0 and 2-j-k>=0 and 2-k>=0)
   ww[2-j-k]+=abs(coef)
 check(f'adaptive row {idx} leading L table',ll==L_PRINT[idx],list(map(str,ll)))
 check(f'adaptive row {idx} tail W table',ww==W_PRINT[idx],ww)
print('quadratic rows completed',flush=True)
LINEAR=[pairrows(u,v,'L') for u,v in [(a,b),(a,s),(b,s),(a,t),(b,t)]]
for idx,row in enumerate(LINEAR):
 for n in range(-1,4):check(f'linear{idx} cancellation {n}',not general_residual(row,n))
 check(f'linear{idx} coefficient total',sum(abs(v) for j in range(1,5) for v in row[j].values())==36)
expected=const(180)
for z in [mon(1,a=2,b=2,s=2,t=2),power(diff,2),add(a,scale(s,-1)),add(a,scale(t,-1)),add(b,scale(s,-1)),add(b,scale(t,-1)),add(s,scale(t,-1))]:expected=mul(expected,z)
check('linear constant determinant',det([[clean({e:v for e,v in q.items() if e[4]==0}) for q in r] for r in LINEAR])==expected)
# Full exact evaluation at c=1,2,-3 confirms the degree argument independently at these points.
for cv in [1,2,-3]:
 mat=[[const(evaluate(q,[2,-5,7,11,cv])) for q in row] for row in LINEAR]
 check(f'linear determinant evaluation c={cv}',det(mat)==const(evaluate(expected,[2,-5,7,11,cv])))
print('linear rows completed',flush=True)

# Generic ordinary residue determinant at exact distinct integer anchors.
def ordmatrix(anchors,cv,k):
 m=len(anchors);hh=prod(anchors);al=[F(0)]+[F(hh,a) for a in anchors];nn=hh*cv;dd=prod(anchors[i]-anchors[j] for i in range(m) for j in range(i+1,m));clearing=(4*hh**m*cv*dd**2)**k
 mat=[]
 for i in range(m+1):
  row=[]
  for j in range(m+1):
   vv=F(0)
   for h in comps(k+int(i==j)-1,m+1):
    v=binom(F(2*k+1,2),h[j])*F(nn)**(-k)*(nn+al[j])**(k-h[j])
    for l in range(m+1):
     if l!=j:v*=binom(-k-int(i==l),h[l])*(al[j]-al[l])**(-k-int(i==l)-h[l])
    vv+=v
   row.append(vv*clearing)
  mat.append(row)
 return mat

def detnum(mat):
 out=F(0);n=len(mat)
 for p in permutations(range(n)):out+=(-1)**sum(p[i]>p[j] for i in range(n) for j in range(i+1,n))*prod(mat[i][p[i]] for i in range(n))
 return out
for anchors in [[2,-3],[2,5,-7],[2,-3,5,7],[1,2,3,5,7]]:
 m=len(anchors);hh=prod(anchors);dd=prod(anchors[i]-anchors[j] for i in range(m) for j in range(i+1,m))
 for k in [1,2,3]:
  for cv in [11,-13]:
   mat=ordmatrix(anchors,cv,k)
   expected=((-1)**(m*(m+1)//2)*4**(m+1)*hh**(m-1)*dd**(2*m))**k*prod(binom(F(1,2)-v*k,k) for v in range(-1,m))
   check(f'ordinary m={m},k={k},c={cv} determinant',detnum(mat)==expected)
   check(f'ordinary m={m},k={k},c={cv} integer column factors',all(mat[i][j].denominator==1 and (j==0 or (mat[i][j]/anchors[j-1]**((m-1)*k)).denominator==1) for i in range(m+1) for j in range(m+1)))
   if k==1:check(f'ordinary m={m},k=1,c={cv} even quotients',all((mat[i][j]/(2 if j==0 else 2*anchors[j-1]**(m-1))).denominator==1 for i in range(m+1) for j in range(m+1)))
   if m==3 and k==2:
    aa,bb,ss=anchors;dv=[dd,aa*(bb-ss),bb*(aa-ss),ss*(aa-bb)];rm=[[v/dv[i] for v in row] for i,row in enumerate(mat)]
    check(f'ordinary normalized 3-root det c={cv}',detnum(rm)==-226800*hh**3*dd**10)
    check(f'ordinary normalized column divisibility c={cv}',all((rm[i][j]/(1 if j==0 else anchors[j-1])).denominator==1 for i in range(4) for j in range(4)))
print('generic exact residue instances completed',flush=True)

# Exact strict numerical bounds (no floating point).
ineq=[('uniform branch e',F(1001,1000)*F(5,4)**2,F(3,2)**2),('sharp branch e',F(1001,1000)*F(201,200)**2,F(101,100)**2),('ordinary H2',F(125,3)*F(5007,5000),42),('ordinary coefficient',4*F(5007,4995)*F(25*1001,16000),9),('ordinary R2 lower',F(2,5),F(27,64)*F(999,1000)**2),('three G',F(16384,27)*F(4005,4000),608),('three pe',F(25*1001*4005,64000*999),F(16,9)),('three residual',27*F(1000,999)**3,28),('finite eta',F(1000,999)**17,F(101,100)**2),('quadratic M',F(101,100)*max(F(L[2])+F(L[1],1000)+F(L[0],10**6) for L in PRINTED_DEG),2400),('universal M',F(101,100)*32*(1200+F(1224,1000)+F(252,10**6)),39000),('universal V',F(45961,7104),F(13,2)),('adaptive V',F(65233,28416),F(23,10)),('linear residual',F(36*5*1000,128*999),F(3,2))]
for name,lhs,rhs in ineq:check(name,lhs<rhs,{'lhs':str(lhs),'rhs':str(rhs)})
check('adaptive rational residual equality',F(35,16)+F(21*5268,1024*999)==F(65233,28416))
check('universal rational residual equality',4*(F(25,16)+F(21*2676,1024*999))==F(45961,7104))
# b_k ratio difference as a polynomial in k, verified at four points (degree <=3).
for kk in [0,1,2,3]:check('beta recurrence polynomial '+str(kk), (3*kk+1)*(3*kk+2)*(3*kk+3)-F(27,4)*(kk+F(3,2))*(2*kk-F(1,2))*(2*kk+F(1,2))==F(432*kk*kk+1110*kk+273,32))
result={'source':str(SOURCE.relative_to(ROOT)),'sha256':EXPECTED,'check_count':len(checks),'checks':checks,'scope':'Sections 4–5 polynomial algebra and constants; includes exact generic residue probes. Determinant probes do not constitute a proof for arbitrary m,k; that proof was separately reconstructed in the ledger.'}
(ROOT/'review_v1/checks/approximation_v1_exact_results.json').write_text(json.dumps(result,indent=2,default=str)+'\n')
print('PASS',len(checks),'checks')
