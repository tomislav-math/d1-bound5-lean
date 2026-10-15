#!/usr/bin/env python3
"""Fresh exact assessment of removing Section9 fourth-entry enumeration.
No old check imports. Current source tables provide the independently audited
analytic cutoff N0; this script proves a new lower-bound comparison to it.
"""
from pathlib import Path
from fractions import Fraction as F
from math import isqrt
import hashlib,re,json
ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'upload/D1_bound5-v1(1).tex'
raw=SOURCE.read_bytes(); text=raw.decode(); sha=hashlib.sha256(raw).hexdigest()
assert sha=='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
checks=0

def check(ok,message):
 global checks
 checks+=1
 if not ok: raise AssertionError(message)

# Coordinates are x+y*omega, omega^2=tau*omega-nu.
class Ring:
 def __init__(self,d):
  self.d=d;self.tau=int(d%4==3);self.nu=(d+1)//4 if self.tau else d
 def add(self,a,b): return (a[0]+b[0],a[1]+b[1])
 def sub(self,a,b): return (a[0]-b[0],a[1]-b[1])
 def mul(self,a,b): return (a[0]*b[0]-self.nu*a[1]*b[1],a[0]*b[1]+a[1]*b[0]+self.tau*a[1]*b[1])
 def norm(self,a): return a[0]*a[0]+self.tau*a[0]*a[1]+self.nu*a[1]*a[1]
 def scale(self,a,k):return tuple(k*z for z in a)
 def square(self,a):return self.mul(a,a)

def rootbounds(n,places=0):
 scale=10**places; v=isqrt(n*scale*scale)
 lo=F(v,scale);hi=lo if v*v==n*scale*scale else F(v+1,scale)
 check(lo*lo<=n<=hi*hi,'square enclosure')
 return lo,hi

# Independent polynomial reconstruction of the regular-completion product.
def padd(a,b):
 out=dict(a)
 for ex,co in b.items():out[ex]=out.get(ex,0)+co
 return {ex:co for ex,co in out.items() if co}
def pscale(a,c):return {ex:c*co for ex,co in a.items() if c*co}
def pmul(a,b):
 out={}
 for ea,ca in a.items():
  for eb,cb in b.items():
   ex=tuple(x+y for x,y in zip(ea,eb));out[ex]=out.get(ex,0)+ca*cb
 return {ex:co for ex,co in out.items() if co}
one={(0,0,0):1};bv={(1,0,0):1};sv={(0,1,0):1};tv={(0,0,1):1}
center=padd(padd(padd(bv,sv),tv),pscale(pmul(pmul(bv,sv),tv),2))
radprod=pmul(pmul(padd(pmul(bv,sv),one),padd(pmul(bv,tv),one)),padd(pmul(sv,tv),one))
product=padd(pmul(center,center),pscale(radprod,-4))
difference=padd(bv,pscale(sv,-1))
expected=padd(padd(pmul(tv,tv),pscale(pmul(padd(bv,sv),tv),-2)),padd(pmul(difference,difference),pscale(one,-4)))
check(product==expected,'symbolic completion product identity')
check(-1+F(7,9)+F(7,9)**2/4+F(1,81)==-F(19,324),'uniform old quadratic endpoint margin')

pairs={}
pat=r'^(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\$'
for m in re.finditer(pat,text,re.M):
 i,d,ax,ay,bx,by,na,nb=map(int,m.groups());pairs[i]=(Ring(d),(ax,ay),(bx,by),na,nb)
check(len(pairs)==40,'pair count')
triples=[]
for m in re.finditer(r'^(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) & (\d+|--) \\\\$',text,re.M):
 i,sx,sy,s0,mbs,n0=map(int,m.groups()[:6]);ring,a,b,a0,b0=pairs[i]
 s=(sx,sy);check(ring.norm(a)==a0 and ring.norm(b)==b0 and ring.norm(s)==s0,'input norms')
 triples.append(dict(pair=i,ring=ring,a=a,b=b,s=s,a0=a0,b0=b0,s0=s0,N0=n0))
check(len(triples)==56,'triple count')
triples.append(dict(pair='rational',ring=Ring(1),a=(1,0),b=(3,0),s=(8,0),a0=1,b0=9,s0=64,N0=1024))

# F(T)=T²-2(|1+2bs|-|b+s|)T+|(b-s)²-4|+2|b+s|+1.
# For x>=0, this computes an upper bound for F(sqrt(x)).
def certificate(row,x,places=0):
 ring=row['ring']; b=row['b'];s=row['s']
 h=ring.add((1,0),ring.scale(ring.mul(b,s),2));q=ring.add(b,s)
 e=ring.sub(ring.square(ring.sub(b,s)),(4,0))
 H,Q,E=map(ring.norm,(h,q,e))
 hmin,_=rootbounds(H,places);_,qmax=rootbounds(Q,places);_,emax=rootbounds(E,places)
 xmin,_=rootbounds(x,places)
 A=2*(hmin-qmax);check(A>0,'positive linear coefficient')
 upper=x-A*xmin+emax+2*qmax+1
 return dict(H=H,Q=Q,E=E,A=str(A),C=str(emax+2*qmax+1),x=x,upper=str(upper),places=places)

rows=[]
for row in triples:
 tail=4*row['b0']*row['s0'];direct=tail>=row['N0']
 rec={k:v for k,v in row.items() if k!='ring'};rec.update(d=row['ring'].d,tail=tail,direct_tail=direct)
 if not direct:
  exceptional=row['pair']==7 and row['s'] in ((-2,-2),(-2,2))
  target=900 if exceptional else row['N0']
  trials=[]
  for places in (0,1,2,3,6,10):
   left=certificate(row,tail,places);right=certificate(row,target,places)
   trials.append(dict(places=places,left=left['upper'],right=right['upper']))
   if F(left['upper'])<0 and F(right['upper'])<0:break
  check(F(left['upper'])<0 and F(right['upper'])<0,'convex endpoint certificates')
  H,Q,E=right['H'],right['Q'],right['E']
  J=lambda v:isqrt(100*v)
  P=J(H)-J(Q)-1
  endpoint_certificate=50*target-P*J(target)+5*J(E)+10*J(Q)+65
  check(P>0 and endpoint_certificate<0,'uniform integer endpoint certificate')
  precise=certificate(row,target,10)
  precise_bound=F(precise['upper'])
  manuscript_certificate=-((-precise_bound.numerator)//precise_bound.denominator)
  check(precise_bound<=manuscript_certificate<0,'existing bracket notation certificate')
  rec.update(method='irregular gap then annulus' if exceptional else 'irregular gap',target=target,left=left,right=right,trials=trials,integer_certificate=endpoint_certificate,integer_inputs=dict(H=H,Q=Q,E=E,P=P),manuscript_certificate=manuscript_certificate,precise_upper=str(precise_bound))
 else:rec['method']='tail gap'
 rows.append(rec)
check(sum(r['direct_tail'] for r in rows[:-1])==38,'38/56 direct count')
check(sum(r['method']=='irregular gap' for r in rows)==16,'16 additional irregular exclusions')
check(sum(r['method']=='irregular gap then annulus' for r in rows)==2,'two annulus cases')
check(rows[-1]['direct_tail'],'rational triple direct tail exclusion')
check(max(r['integer_certificate'] for r in rows if r['method']=='irregular gap')==-4714,'maximum of sixteen exact certificates')
check([r['integer_certificate'] for r in rows if r['method']=='irregular gap then annulus']==[-250,-250],'exception certificate at900')

# Independent finite modular facts for the final elementary annulus proof.
mod5=[(u,v) for u in range(5) for v in range(5) if (u*u+2*v*v)%5==0]
check(mod5==[(0,0)],'norm30 obstructed modulo5 and valuation')
mod8=sorted({(u*u+2*v*v)%8 for u in range(8) for v in range(8)})
check(7 not in mod8,'norm31 obstructed modulo8')
mod16=sorted({(u*u+2*v*v)%16 for u in range(16) for v in range(16)})
check(14 not in mod16 and 15 not in mod16,'both30and31 excluded modulo16')
check(all(u%4==v%4==0 for u in range(16) for v in range(16) if (u*u+2*v*v)%16==0),'norm32 impliescoordinatesdivisibleby4')
sol32=[(u,v) for u in range(-isqrt(32),isqrt(32)+1) for v in range(-isqrt(16),isqrt(16)+1) if u*u+2*v*v==32]
check(sol32==[(0,-4),(0,4)],'norm32 roots')
check([u*u-2*v*v-1 for u,v in sol32]==[-33,-33],'norm32 gives t=-33')
check(33**2>1024,'outside cutoff')

out=dict(source=str(SOURCE),source_sha256=sha,status='PASS',checks=checks,rows=rows,
 counts=dict(table_rows=56,with_rational=57,tail_table_rows=38,tail_with_rational=39,refined_gap_rows=16,elementary_annulus_rows=2),
 certificate_precision_max=max(r.get('left',{}).get('places',0) for r in rows),
 max_existing_enclosure_upper=str(max(F(r['precise_upper']) for r in rows if r['method']=='irregular gap')),
 annulus=dict(norm_root_candidates=[30,31,32],mod5_zero_pairs=mod5,mod8_residues=mod8,mod16_residues=mod16,norm32_roots=sol32,t=-33,t_norm=1089))
(ROOT/'comments_v1/finite_reduction/results.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({k:out[k] for k in ('status','checks','counts','certificate_precision_max')},indent=2))
for r in rows:
 if not r['direct_tail']:print(r['pair'],r['s'],'precision',r['left']['places'],'left',r['left']['upper'],'right',r['right']['upper'],'target',r['target'])
