"""Independent exact v2 completion checks, read directly from the reviewed source.

No old audit implementation or cached numerical result is imported. The five
fixed-pair coefficient bounds are inputs from the manuscript, independently
audited by the one-small agent. N3 coefficients for (b,s), all 57 cutoffs and
the finite complement are freshly calculated here with rational arithmetic.
Run: python revision_v2/checks/completion_exact.py
"""
from pathlib import Path
from fractions import Fraction as F
from math import isqrt, comb
from hashlib import sha256
import json,re

ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'output/D1_bound5-v2.tex'
HASH=sha256(SOURCE.read_bytes()).hexdigest()
assert HASH=='5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70'
TEX=SOURCE.read_text()
CHECKS=0
def check(ok,why):
    global CHECKS
    CHECKS+=1
    if not ok:raise AssertionError(why)
def enc(v,upper=False):
    v=F(v);L=10**10;n=isqrt(v.numerator*L*L//v.denominator)
    check(F(n*n,L*L)<=v<F((n+1)**2,L*L),'integer sqrt enclosure')
    return F(n+(upper and F(n*n,L*L)<v),L)

class Ring:
    def __init__(self,d):self.t=int(d%4==3);self.h=(d+1)//4 if self.t else d
    def add(self,a,b):return tuple(a[i]+b[i] for i in range(2))
    def sub(self,a,b):return tuple(a[i]-b[i] for i in range(2))
    def scale(self,a,k):return tuple(k*v for v in a)
    def mul(self,a,b):return (a[0]*b[0]-self.h*a[1]*b[1],a[0]*b[1]+a[1]*b[0]+self.t*a[1]*b[1])
    def norm(self,a):return a[0]**2+self.t*a[0]*a[1]+self.h*a[1]**2
    def power(self,a,n):
        out=(1,0)
        for _ in range(n):out=self.mul(out,a)
        return out
    def divide(self,a,b):return self.scale(self.mul(a,(b[0]+self.t*b[1],-b[1])),F(1,self.norm(b)))

def binom(q,n):
    out=F(1)
    for j in range(n):out*=F(q-j,j+1)
    return out

def n3_divided_coefficients(R,x,y):
    # Evaluate the finite generator before taking any absolute values.
    k=m=3;p=(m,k,k);rootcolumns=[]
    for i in range(3):
        row=[]
        for j in (1,2):
            poly=[(F(0),F(0)) for _ in range(4)]
            total=p[j]+(i==j)-1
            for h0 in range(total+1):
                for h1 in range(total-h0+1):
                    hh=(h0,h1,total-h0-h1)
                    coeff=4**k*binom(F(7,2),hh[j])
                    for l in range(3):
                        if l!=j:coeff*=binom(-p[l]-(i==l),hh[l])
                    if j==1:
                        coeff*=(-1)**(k+(i==2)+hh[2])
                        base=R.mul(R.power(x,m),R.power(y,(i==2)+hh[2]))
                        base=R.mul(base,R.power(R.sub(x,y),k-(i==2)-hh[2]))
                        anchor=x;degree=k-hh[1]
                    else:
                        base=R.mul(R.power(y,m),R.power(x,(i==1)+hh[1]))
                        base=R.mul(base,R.power(R.sub(x,y),k-(i==1)-hh[1]))
                        anchor=y;degree=k-hh[2]
                    for ell in range(degree+1):
                        term=R.scale(R.mul(base,R.power(anchor,ell)),coeff*comb(degree,ell))
                        poly[ell]=R.add(poly[ell],term)
            divisor=R.mul((R.sub(x,y),x,y)[i],anchor)
            poly=[R.divide(c,divisor) for c in poly]
            check(all(z.denominator==1 for c in poly for z in c),'integral divided generator')
            row.append(poly)
        rootcolumns.append(row)
    return rootcolumns

def coefficient_bs(R,b,s):
    ns=R.norm(s);sums=[]
    for row in n3_divided_coefficients(R,b,s):
        total=F(0)
        for poly in row:
            for ell,p in enumerate(poly):
                if ns<=25:total+=enc(F(R.norm(p),ns**7),True)/1000**(3-ell)
                else:total+=enc(F(R.norm(p),ns**(10-ell)),True)/200**(3-ell)
        sums.append(total)
    return (F(101,400)*max(sums)).__floor__()+1

def least(c,p):
    hi=1
    while c*hi**p<=1:hi*=2
    lo=0
    while hi-lo>1:
        mid=(lo+hi)//2
        if c*mid**p>1:hi=mid
        else:lo=mid
    check(c*hi**p>1 and c*(hi-1)**p<=1,'least strict threshold')
    return hi

pairs={}
for m in re.finditer(r'^(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\',TEX,re.M):
    i,d,ax,ay,bx,by,na,nb=map(int,m.groups());pairs[i]=(d,(ax,ay),(bx,by))
    check((Ring(d).norm((ax,ay)),Ring(d).norm((bx,by)))==(na,nb),'source pair norms')
check(len(pairs)==40,'40 source pairs')
sec=TEX.split('Coefficient bounds for the forty fixed pairs.')[1].split('\\end{longtable}')[0]
coeff={int(m[0]):tuple(map(int,m[1:])) for m in re.findall(r'^(\d+)&(\d+)&(\d+)&(\d+)&(\d+)&(\d+)\\\\',sec,re.M)}
check(len(coeff)==40,'40 source coefficient rows')
rows=[tuple(map(int,m)) for m in re.findall(r'^(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) \\\\',TEX,re.M)]
check(len(rows)==56,'56 source completion rows')
rows.append((40,8,0,64,34,1024));pairs[40]=(1,(1,0),(3,0));coeff[40]=(12,41,25,300,1100)
eps=F(1,4000);h=F(4001,3999);mu=F(51051,400000);Mm=F(8,9)*608**2;Rm=F(3920,81)
tau=F(21,1024*999)
def rp(q):
    y=1/q
    return (15+80*y+150*y*y+280*y**3+35*y**4)/256+tau*(885+1144*y+435*y*y+2634*y**3+170*y**4)

certs=[];quad=[];tail=[]
for i,u,v,sprinted,mbsprinted,nprinted in rows:
    d,a,b=pairs[i];R=Ring(d);s=(u,v);aa,bb,ss=map(R.norm,(a,b,s))
    check(ss==sprinted and aa in (1,2),'completion norms')
    dab,das,dbs=(R.norm(R.sub(z,w)) for z,w in ((a,b),(a,s),(b,s)))
    q1=enc(F(dab*das*dbs,bb*ss**2),True)
    check(1/q1>mu/bb,'positive gap bracket')
    K=F(9999,100)*aa*(1/q1-mu/bb)**2
    check(K>1,'gap K>1')
    Rbs=F(3535,409600)*enc(max(F(dbs**6,ss**6),F(bb*dbs**5,ss**6)),True)
    Mbs=coefficient_bs(R,b,s)
    check(Mbs==mbsprinted,f'Mbs row {i,s}')
    M2,Mn,M3,M4,M5=coeff[i]
    R2,Rn,R3,R4,R5=[r*F(101,200)*F(dab,4*bb)**k for r,k in ((F(5,4),2),(F(35,32),3),(F(35,16),3),(F(63,8),4),(F(495,64),5))]
    q=enc(F(bb,aa));check(q>=1,'P ratio q>=1');Rp=rp(q)
    bounds=[((1-eps)*K**4/(12100*ss**5),5),
      (K**2/(36*M2**2*bb**4*ss**2*h),4),
      (K**2/(16*R2**2*2400**2*bb**3*ss**5*h),5),
      (K**2/(16*R2**2*2400**2*bb**5*ss**4*h),5),
      (K**2/(16*Rp**2*M3**2*bb**6*ss**4*h),5),
      (K**4/(16*R3**2*Mm**2*bb**6*ss**12*h),10),
      (K**4/(16*Rm**2*Mn**2*bb**9*ss**9*h),10),
      (K**4/(16*Rn**2*Mbs**2*bb**3*ss**11*h),10),
      (K**2/(16*Rbs**2*M4**2*bb**5*ss**5*h),5),
      (K**4/(144*R4**2*42**8*bb**15*ss**4*h),10),
      (F(2,5)**8*K**4/(4*M5**2*bb**16*ss**4*h),10),
      (K**6/(144*R5**2*42**10*bb**19*ss**6*h),15),
      (F(2,5)**10*K**6/(36*42**12*bb**22*ss**6*h),15)]
    thresholds=[least(c,p) for c,p in bounds]
    tailn=least(K**2/(105**2*bb**4*ss**2),5)
    eta=1 if aa==1 else 4*aa*bb*ss+1
    n0=max(1024,tailn,eta,*thresholds)
    check(n0==nprinted,f'N0 row {i,s}: computed {n0}, printed {nprinted}')
    certs.append({'pair':i,'s':s,'Mbs':Mbs,'N0':n0,'thresholds':thresholds,'n_infinity':tailn,'eta':eta,'K':str(K),'q1':str(q1),'minimum_overlap_at_N0':str(min(c*n0**p for c,p in bounds))})
    if i==40:
        check(q1==F(1822916667,5000000000) and K>744,'rational q1,K')
        check(thresholds==[3,23,96,101,108,179,131,9,34,76,123,29,438] and tailn==14,'rational displayed witnesses')
        check(32<2*3*8,'rational tail contradiction')
        continue
    if 4*bb*ss>=n0:
        tail.append({'pair':i,'s':s,'4b0s0':4*bb*ss,'N0':n0});continue
    q=R.add(b,s);hh=R.add((1,0),R.scale(R.mul(b,s),2));delta=R.sub(R.power(R.sub(b,s),2),(4,0))
    qn,hn,dn=map(R.norm,(q,hh,delta))
    difference=enc(hn)-enc(qn,True)
    check(difference>0,'negative coefficient sign in endpoint envelope')
    endpoint=900 if i==7 else n0
    upper=endpoint-2*difference*enc(endpoint)+enc(dn,True)+2*enc(qn,True)+1
    # Independent direct lower-end verification as well as the general lemma.
    lower2=4*bb*ss
    lower_upper=lower2-2*difference*enc(lower2)+enc(dn,True)+2*enc(qn,True)+1
    check(lower_upper<0,'f(2BS)<0, direct interval check')
    check(upper<(-5 if i==7 else -100),'finite quadratic endpoint')
    if i==7:check((qn,hn,dn)==(33,457,153),'exceptional norms')
    quad.append({'pair':i,'s':s,'N0':n0,'Nq':qn,'Nh':hn,'Ndelta':dn,'right_squared':endpoint,'right_upper':str(upper),'left_upper':str(lower_upper)})
check(len(tail)==38 and len(quad)==18,'38/16/2 partition')
check(sum(r['pair']==7 for r in quad)==2,'2 exceptional rows')
check(F(213,10)**2<457 and F(29,5)**2>33 and F(62,5)**2>153,'printed coarse radicals')
check(901-60*F(213,10)+62*F(29,5)+F(62,5)==-5,'strict radical comparisons imply f30<-5')
residues=sorted({(u*u+2*v*v)%16 for u in range(16) for v in range(16)})
check(14 not in residues and 15 not in residues,'30,31 excluded modulo16')
check(all((u*u+2*v*v)%16 or (u%4==0 and v%4==0) for u in range(16) for v in range(16)),'norm32 divisibility')
roots32=[(u,v) for u in range(-5,6) for v in range(-4,5) if u*u+2*v*v==32]
check(roots32==[(0,-4),(0,4)],'complete norm32 roots')
check(all(Ring(2).sub(Ring(2).power(z,2),(1,0))==(-33,0) for z in roots32),'t=-33')
report={'source':str(SOURCE.relative_to(ROOT)),'sha256':HASH,'checks':CHECKS,'assumptions':['The five fixed-pair coefficient bounds are read from the manuscript; their independent regeneration is owned by the one-small audit.','The integral approximation constructions and retained gap are verified as separate structural dependencies.'],'cutoffs':certs,'finite_tail_rows':tail,'quadratic_rows':quad,'quadratic_worst_regular_upper':str(max(F(q['right_upper']) for q in quad if q['pair']!=7)),'mod16_norm_residues':residues,'norm32_roots':roots32}
(ROOT/'revision_v2/checks/completion_exact.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({'sha256':HASH,'checks':CHECKS,'cutoffs_verified':len(certs),'fresh_Mbs_verified':len(certs),'finite_partition':[len(tail),16,2],'largest_N0':max(c['N0'] for c in certs),'worst_regular_quadratic_upper':report['quadratic_worst_regular_upper'],'mod16_norm_residues':residues},indent=2))
