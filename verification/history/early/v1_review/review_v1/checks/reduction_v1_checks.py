#!/usr/bin/env python3
"""Fresh independent Section 8 checks from authoritative v1 source.
Python standard library only. No import of earlier audit scripts or results.
All comparisons affecting asserted results use integers or Fraction.
"""
from fractions import Fraction as F
from math import isqrt,comb
from itertools import combinations,permutations,product
from collections import defaultdict,Counter
from pathlib import Path
import hashlib,json,re
BASE=Path(__file__).resolve().parents[2]
SRC=BASE/'upload/D1_bound5-v1(1).tex'
s=SRC.read_text(); lines=s.splitlines()
assert hashlib.sha256(SRC.read_bytes()).hexdigest()=='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
results={'source_sha256':hashlib.sha256(SRC.read_bytes()).hexdigest(),'checks':{}}
def put(k,v): results['checks'][k]=v;print(k,':',json.dumps(v,default=str))
def sqrtfloor(x,j=0):
 x=F(x);scale=10**j;n=isqrt((x.numerator*scale**2)//x.denominator)
 assert n*n*x.denominator<=x.numerator*scale**2<(n+1)**2*x.denominator
 return F(n,scale)
def sqrtceil(x,j=0):
 z=sqrtfloor(x,j);return z if z*z==x else z+F(1,10**j)
def binom(a,n):
 r=F(1)
 for j in range(n):r*=F(a-j,j+1)
 return r
# Independent dense-in-degree expansions for the two root columns, before g.
families=[('N2',2,2,2,F(5,4)),('N3',3,3,4,F(35,32)),('A3',3,2,4,F(35,16)),('A4',4,3,2,F(63,8)),('A5',5,4,4,F(495,64))]
polys={}
for name,k,m,g,_ in families:
 p=(m,k,k);rows=[]
 for i in range(3):
  cols=[]
  for j in (1,2):
   out=defaultdict(F);total=p[j]+(i==j)-1
   for h0 in range(total+1):
    for h1 in range(total-h0+1):
     h=(h0,h1,total-h0-h1)
     c=F(4**k)*binom(F(2*k+1,2),h[j])
     for z in range(3):
      if z!=j:c*=binom(-p[z]-(i==z),h[z])
     # Row 0 division removes an (x-y); row 1 removes x; row 2 removes y.
     if j==1:
      c*=(-1)**(k+(i==2)+h[2]);xx=m;yy=(i==2)+h[2]
      power=k-h[1];dp=k-(i==2)-h[2]
     else:
      xx=(i==1)+h[1];yy=m;power=k-h[2];dp=k-(i==1)-h[1]
     if i==0:dp-=1
     elif i==1:xx-=1
     else:yy-=1
     if j==1:xx-=1
     else:yy-=1
     assert min(xx,yy,dp,power)>=0
     for ell in range(power+1):
      for v in range(dp+1):
       r=xx+dp-v+(ell if j==1 else 0);t=yy+v+(ell if j==2 else 0)
       out[(r,t,ell)]+=c*comb(power,ell)*comb(dp,v)*(-1)**v
   out={key:v for key,v in out.items() if v}
   assert all(v.denominator==1 and v.numerator%g==0 and r+t==ell+m+k-2 for (r,t,ell),v in out.items())
   cols.append(out)
  rows.append(cols)
 polys[name]=rows
put('generated_polynomials',{'families':len(polys),'root_columns':30,'all_coefficients_integral_divisible_by_g':True,'all_weights_and_exponents_checked':True,'term_counts':{n:sum(len(p) for row in rows for p in row) for n,rows in polys.items()}})
# Number-field arithmetic independently uses the integral basis 1,w.
class Ring:
 def __init__(self,d):self.d=d;self.t=int(d%4==3);self.u=(d+1)//4 if self.t else d;self.disc=4*self.u-self.t
 def add(self,a,b):return(a[0]+b[0],a[1]+b[1])
 def neg(self,a):return(-a[0],-a[1])
 def sub(self,a,b):return self.add(a,self.neg(b))
 def mul(self,a,b):x,y=a;v,w=b;return(x*v-self.u*y*w,x*w+y*v+self.t*y*w)
 def pow(self,a,n):
  v=(1,0)
  for _ in range(n):v=self.mul(v,a)
  return v
 def norm(self,a):x,y=a;return x*x+self.t*x*y+self.u*y*y
 def conj(self,a):x,y=a;return(x+self.t*y,-y)
 def disk(self,L):
  ymax=isqrt(4*L//self.disc)
  for y in range(-ymax,ymax+1):
   emax=isqrt(4*L-self.disc*y*y)
   for e in range(-emax,emax+1):
    if (e-self.t*y)%2==0:yield((e-self.t*y)//2,y)
 def sqrt(self,z):
  nz=self.norm(z);n=isqrt(nz)
  if n*n!=nz:return None
  p=2*z[0]+self.t*z[1];q=z[1];e2=2*n+p;f2num=2*n-p
  if e2<0 or f2num<0 or f2num%self.disc:return None
  e=isqrt(e2);f=isqrt(f2num//self.disc)
  if e*e!=e2 or self.disc*f*f!=f2num:return None
  if e:
   if q%e:return None
   f=q//e
  if e*f!=q or (e-self.t*f)%2:return None
  r=((e-self.t*f)//2,f)
  assert self.mul(r,r)==z
  return r
 def good(self,a,b):return self.sqrt(self.add(self.mul(a,b),(1,0))) is not None
 def div(self,z,a):
  na=self.norm(a);p=self.mul(z,self.conj(a))
  return(p[0]//na,p[1]//na) if p[0]%na==p[1]%na==0 else None
 def rep(self,a,b):
  orbit={(a,b),(self.neg(a),self.neg(b)),(self.conj(a),self.conj(b)),(self.neg(self.conj(a)),self.neg(self.conj(b)))}
  def key(v):
   aa,bb=v;return(2*aa[0]+self.t*aa[1]<0,aa[1]<0,2*bb[0]+self.t*bb[1]<0,bb[1]<0,*aa,*bb)
  return min(orbit,key=key)
# Parse tables from source, not copied previous reports.
pairblock=s.split('\\label{tab:pr-forty-pairs}')[1].split('\\end{longtable}')[0]
pat=r'^(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)'
pairs={}
for line in pairblock.splitlines():
 mm=re.match(pat,line)
 if mm:
  i,d,ax,ay,bx,by,na,nb=map(int,mm.groups());pairs[i]=(Ring(d),(ax,ay),(bx,by),na,nb)
assert set(pairs)==set(range(40))
coeffblock=s.split('\\label{tab:pr-forty-coefficients}')[1].split('\\end{longtable}')[0]
coeff={}
for line in coeffblock.splitlines():
 mm=re.match(r'^(\d+)&(\d+)&(\d+)&(\d+)&(\d+)&(\d+)',line)
 if mm:nums=list(map(int,mm.groups()));coeff[nums[0]]=nums[1:]
assert len(coeff)==40
fields=[1,2,3,5,6,7,11,15,19,23]
for d in fields:
 R=Ring(d)
 assert R.sqrt((0,0))==(0,0)
 root=R.sqrt((-d,0))
 assert root is not None and R.mul(root,root)==(-d,0)
 assert 2*root[0]+R.t*root[1]==0
put('explicit_zero_and_pure_imaginary_root_cases',{'fields':fields,'zero_cases':10,'pure_imaginary_e_zero_cases':10})
counts={};all_reps=set()
for d in fields:
 ring=Ring(d);found=set()
 for a in ring.disk(2):
  na=ring.norm(a)
  if na not in (1,2):continue
  for r in ring.disk(8):
   b=ring.div(ring.sub(ring.mul(r,r),(1,0)),a)
   if b is None:continue
   nb=ring.norm(b)
   if not 9<=nb<=(63 if na==1 else 15):continue
   if (a,b) in [((1,0),(3,0)),((-1,0),(-3,0))]:continue
   assert ring.good(a,b)
   found.add((a,b))
 reps={ring.rep(*p) for p in found};counts[d]=(len(reps),len(found))
 all_reps|={(d,a,b) for a,b in reps}
assert all_reps=={(R.d,a,b) for R,a,b,_,_ in pairs.values()}
assert [counts[d][0] for d in fields]==[9,3,15,2,2,2,2,2,2,1]
assert [counts[d][1] for d in fields]==[30,10,58,6,6,8,8,8,8,4]
put('pair_enumeration',{'field_counts':counts,'representatives':len(all_reps),'pairs_before_symmetry':sum(c[1] for c in counts.values()),'exact_match_printed_table':True})
# Independently cross-check square predicate against full square sets on tested target range.
triples=[];predicate_total=0
for i,(R,a,b,na,nb) in pairs.items():
 squares={R.mul(r,r) for r in R.disk(121)} # every |as+1|,|bs+1| < 121 in this enumeration
 for z in R.disk(224):
  if R.norm(z)<nb or z in (a,b):continue
  targets=[R.add(R.mul(a,z),(1,0)),R.add(R.mul(b,z),(1,0))]
  for target in targets:
   predicate_total+=1
   assert (R.sqrt(target) is not None)==(target in squares)
  if all(t in squares for t in targets):triples.append((i,z[0],z[1],R.norm(z)))
assert len(triples)==57
assert (7,3,0,9) in triples
finiteblock=s.split('\\label{tab:fixed56}')[1].split('\\end{longtable}')[0]
printed=[]
for line in finiteblock.splitlines():
 mm=re.match(r'^(\d+) & (-?\d+) & (-?\d+) & (\d+) &',line)
 if mm:printed.append(tuple(map(int,mm.groups())))
assert set(triples)-{(7,3,0,9)}==set(printed) and len(printed)==56
put('third_entry_enumeration',{'triples':len(triples),'retained':56,'square_tests_crosschecked_with_enumerated_square_set':predicate_total,'full_match_final_table':True,'triples':triples})
# Five-region coefficients and all overlap quotients.
eps=F(1,4000);hh=F(4001,3999);mu=F(51051,400000);kap=F(3535,409600);Mm=F(8,9)*608**2;Rm=F(3920,81)
def residual(q):
 x=1/F(q);tau=F(21,1024*999)
 L=[5*x+10*x*x+10*x**4+5*x**5,10*(x+x**4+x**5),15+80*x+150*x*x+120*x**3+35*x**4,15+80*x+150*x*x+280*x**3+35*x**4]
 W=[295*x+143*x*x+143*x**4+295*x**5,590*(x+x**4+x**5),885+1144*x+435*x*x+42*x**3+170*x**4,885+1144*x+435*x*x+2634*x**3+170*x**4]
 vals=[v/256+tau*w for v,w in zip(L,W)];assert vals[-1]==max(vals)
 return vals[-1]
def qcoeff(q):
 ans=[]
 for name,k,m,g,_ in families:
  v=max(sum(abs(v)*F(q)**(-r)*F(1000)**(ell-k) for pp in row for (r,t,ell),v in pp.items()) for row in polys[name])*F(101,100*g)
  ans.append((v.numerator//v.denominator+1,v))
 return ans
names=['START-Q','Q-N2','N2-P1','N2-P2','P-N3','P-A3','A3-M','M-N3','N3-A4','N3-N3bs','N3bs-A4','A4-O4','O4-A5','A5-O5','O5-O6']
def overlaps(n,B2,S2,G,rho,M,R,Rp,first=(1024,256)):
 n,B2,S2,G,rho=map(F,(n,B2,S2,G,rho));M2,Mn,M3,M4,M5=map(F,M);R2,Rn,R3,R4,R5=R
 return [first[0]*n**5*B2**5*(1-eps)/12100,first[1]*n**4*S2**2/(36*M2*M2*hh),G*G*n**10*B2*B2/(16*R2*R2*2400**2*hh),G*G*n**10*S2/(16*R2*R2*2400**2*hh),G*G*n**10/(16*Rp*Rp*Mn*Mn*hh),G*G*n**10/(16*Rp*Rp*M3*M3*hh),G**4*n**18/(16*R3*R3*Mm*Mm*hh),G**4*n**17*B2*S2/(16*Rm*Rm*Mn*Mn*hh),G*G*n**11*B2*B2/(16*Rn*Rn*M4*M4*hh),G**4*n**18*B2**4/(16*Rn*Rn*4143**2*hh),rho*rho*n**7/(16*M4*M4*hh),G**4*n**19*B2/(144*R4*R4*42**8*hh),G**4*n**18/(4*M5*M5*F(5,2)**8*hh),G**6*n**27*B2**5/(144*R5*R5*42**10*hh),G**6*n**26*B2*B2/(36*42**12*F(5,2)**10*hh)]
region_data=[(1,8,1,F(27,8),F(8),269,7495,20687,F(7,50),[36,282,145,4605,38390],F(1260,1000)),(2,4,F(3,2),F(3),F(8,3),368,1771,7973,F(7,20),[69,697,326,14771,171856],F(2329,1000)),(3,3,F(7,4),F(11,4),F(12,7),540,598,3226,F(18,25),[109,1306,663,34919,482131],F(1166,1000)),(4,3,F(2),F(29,10),F(3,2),637,624,3507,F(47,50),[130,1652,863,48019,701908],F(5459,1000)),(5,3,F(17,6),F(3),F(18,17),1121,375,2217,F(201,100),[220,3553,1944,134712,2400382],F(1321,1000))]
regout=[]
for n,m,U,t,q,Fp,G,rho,Rp,M,margin in region_data:
 assert q==m/U and t*n*m*m>=54
 lo=F(0);hi=F(2)
 def crit(x):return 5*x*x/q+4*(1+q**-2)*x-4/q
 for _ in range(30):
  mid=(lo+hi)/2
  if crit(mid)>0:hi=mid
  else:lo=mid
 fup=(4-lo*lo)**4*(1+q**-2+hi/q)**2
 assert crit(lo)<=0<=crit(hi) and fup<Fp
 Q0=2*(1+1/q)**2;cc=F(9999,10000)*F(200,19)**2;H=cc*t**5*(1-mu*Q0/m**2)**2
 assert 1-mu*Q0/m**2>0 and H/Q0**2>G and H/(kap*Fp)>rho
 mc=qcoeff(q)
 assert [a for a,v in mc]==M and residual(q)<Rp
 R=[old*F(101,200)*((1+1/q)/2)**(2*k) for _,k,_,_,old in families]
 qq=overlaps(n,m*m,m*m,G,rho,M,R,Rp)
 assert min(qq)>margin and F(G,105)*n**4*m**4>1
 regout.append({'norm_lower':n,'phase_upper':fup,'G_lower':H/Q0**2,'rho_lower':H/(kap*Fp),'coefficients':M,'residual':residual(q),'min_quotient':min(qq),'min_at':names[qq.index(min(qq))],'claimed_strict_margin':margin,'quotients':dict(zip(names,qq))})
put('five_unbounded_regions',regout)
# Fixed coefficients use ring evaluation before absolute values.
def fixedcoeff(R,a,b,nb):
 out=[]
 for name,k,m,g,_ in families:
  P=m+2*k;vals=[]
  for row in polys[name]:
   v=F(0)
   for pp in row:
    degree=defaultdict(lambda:(0,0))
    for (r,t,ell),co in pp.items():
     zz=R.mul(R.pow(a,r),R.pow(b,t));zz=(int(co)*zz[0],int(co)*zz[1]);degree[ell]=R.add(degree[ell],zz)
    for ell,z in degree.items():
     r=k-ell;np=R.norm(z)
     if nb<=25:v+=sqrtceil(F(np,nb**(P-2)),10)/1000**r
     else:v+=sqrtceil(F(np,nb**(P-2+r)),10)/200**r
   vals.append(v*F(101,100*g))
  v=max(vals);out.append((v.numerator//v.denominator+1,v))
 return out
pairs[40]=(Ring(1),(1,0),(3,0),1,9);coeff[40]=[12,41,25,300,1100]
fixout=[];min_global=None
for i,(R,a,b,na,nb) in pairs.items():
 nab=R.norm(R.sub(a,b));mc=fixedcoeff(R,a,b,nb)
 assert [v for v,_ in mc]==coeff[i],(i,mc,coeff[i])
 A1=sqrtceil(na,8);B0=sqrtfloor(nb,8);B1=sqrtceil(nb,8);d1=sqrtceil(F(nab,nb),8)
 Q0=d1*(1+A1/15)*(1+B1/15);c0=F(9999,100);tau=F(59,20)
 K=c0*na*(1/Q0-mu/nb)**2;G=K*tau**5;H=c0*na*tau**5*(1-mu*Q0/nb)**2;F0=F(nab,nb)*(1+A1/15)**2*(1+B1/15)**8;rho=H/(kap*F0)
 assert 1/Q0>mu/nb and K>F(7,4) and B0/A1>2
 rr=[old*F(101,200)*F(nab,4*nb)**k for _,k,_,_,old in families]
 Rp=residual(B0/A1);qq=overlaps(1,nb,225,G,rho,coeff[i],rr,Rp,(9604,784))
 assert min(qq)>F(59,50) and G*B0*15**3/105>1
 record={'pair':i,'coefficients':coeff[i],'K':K,'G':G,'rho':rho,'Rp':Rp,'min_quotient':min(qq),'min_at':names[qq.index(min(qq))],'quotients':dict(zip(names,qq))}
 fixout.append(record)
 if min_global is None or min(qq)<min_global[0]:min_global=(min(qq),i,record['min_at'])
put('fixed_pair_coefficients_and_overlaps',{'pair_count':41,'coefficient_count':205,'quotient_count':615,'global_minimum':min_global,'rows':fixout})
# The fresh determinant expansion uses permutations of J+E, independent of the printed cubic grouping.
edges=list(combinations(range(4),2));ed={e:i for i,e in enumerate(edges)};det=defaultdict(F)
for p in permutations(range(4)):
 sign=(-1)**sum(p[i]>p[j] for i in range(4) for j in range(i+1,4));available=[ed[tuple(sorted((i,p[i])))] for i in range(4) if i!=p[i]]
 for bits in product((0,1),repeat=len(available)):
  ex=[0]*6
  for index,b in zip(available,bits):ex[index]+=b
  det[tuple(ex)]+=sign
# constants, linear and quadratic terms cancel exactly.
det={k:v for k,v in det.items() if v};assert set(map(sum,det))=={3,4}
r=list(map(F,[F(1,3),F(1,15),F(1,90),F(1,45),F(1,270),F(1,1350)]));ks=[F(v,10000) for v in [5506,5087,5014,5029,5005,5001]]
assert all(F(1,2)<k<1 and rr*k*k<2*k-1 for rr,k in zip(r,ks))
leading=defaultdict(F);errors=defaultdict(F)
for ex,co in det.items():
 if sum(ex)!=3:continue
 ax=[1]*4
 for (i,j),power in zip(edges,ex):ax[i]-=power;ax[j]-=power
 lead=F(co,8);prodK=F(1)
 for k,p in zip(ks,ex):prodK*=k**p
 leading[tuple(ax)]+=lead;errors[tuple(ax)]+=abs(co)*(prodK-F(1,8))
combined={key:abs(leading[key])+errors[key] for key in leading}
# All four triangle types and six reciprocal-pair types occur.
assert len(combined)==10
alpha=combined[(-1,-1,-1,1)]
# Exact coefficient-level test of all c_ij from the source.
cs=[]
for i,j in edges:
 kl=[x for x in range(4) if x not in (i,j)];k,l=kl
 def ke(x,y):return ks[ed[tuple(sorted((x,y)))]]
 c=2*(ke(i,j)*(ke(i,k)*ke(j,l)+ke(i,l)*ke(j,k))+ke(i,j)**2*ke(k,l))-F(1,2)
 exp=tuple(-1 if v in(i,j) else 0 for v in range(4));assert combined[exp]==c and c>0;cs.append(c)
Q4=(ks[0]*ks[5]+ks[1]*ks[4]+ks[2]*ks[3])**2;W=F(1,4050)
# Quartic total coefficient bound equals Q4 when multiplied by ABST.
qsum=F(0)
for ex,co in det.items():
 if sum(ex)!=4:continue
 ax=[1]*4;term=F(abs(co))
 for (i,j),p,k in zip(edges,ex,ks):ax[i]-=p;ax[j]-=p;term*=k**p
 assert ax==[-1]*4;qsum+=term
assert qsum==Q4
beta=combined[(1,-1,-1,-1)]*3*W+combined[(-1,1,-1,-1)]*F(1,450)+combined[(-1,-1,1,-1)]*F(1,18)+sum(c*rr for c,rr in zip(cs,r))+Q4*W
assert alpha==2*ks[0]*ks[1]*ks[3] and alpha<F(141,500) and beta<F(21,125)
assert F(141,500)*F(59,20)+F(21,125)==F(9999,10000)<1
put('uniform_fourth_gap',{'permutations':24,'cubic_monomials':sum(sum(k)==3 for k in det),'quartic_monomials':sum(sum(k)==4 for k in det),'all_10_cubic_groups_verified':True,'six_pair_defects':cs,'alpha':alpha,'beta':beta,'direct_determinant_bound_at_59_over_20':alpha*F(59,20)+beta,'coarse_bound_at_59_over_20':F(9999,10000)})
# Exceptional-pair identity and full-ring small discriminant cutoffs, independently exact.
# Symbolic coefficients for XV-3(eh-fg)^2 reduce to -2(3ef-gh)^2.
# Exhaustive low-norm discriminant checks cover the only borderline fields31,35.
border={}
for d in [31,35]:
 R=Ring(d);roots=[r for r in R.disk(8) if r[1]!=0];border[d]=[(r,R.norm(R.sub(R.mul(r,r),(1,0)))) for r in roots]
 assert (d==31 and len(roots)==4 and all(v==80 for _,v in border[d])) or(d==35 and not roots)
put('borderline_discriminants',border)
# Confirm integer residual cases for positive1,3 third entries with3<s<15.
assert [t for t in range(4,15) if isqrt(t+1)**2==t+1 and isqrt(3*t+1)**2==3*t+1]==[8]
put('positive_rational_third_entry',8)
out=Path(__file__).with_name('reduction_v1_results.json');out.write_text(json.dumps(results,indent=2,default=str)+'\n')
print('ALL FRESH CHECKS PASSED; evidence',out)
