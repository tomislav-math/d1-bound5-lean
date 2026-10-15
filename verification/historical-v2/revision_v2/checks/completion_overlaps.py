"""Fresh symbolic monomial reductions for v2 Sections 6 and 9.

Standard-library exact arithmetic. This independently derives quotient
monomials from raw endpoints and compares them with each printed sufficient
bound; it does not import an earlier checker or numerical result.
"""
from pathlib import Path
from fractions import Fraction as F
from hashlib import sha256
import json
ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'output/D1_bound5-v2.tex';HASH=sha256(SOURCE.read_bytes()).hexdigest()
assert HASH=='5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70'
CHECKS=0
def check(ok,msg):
    global CHECKS
    CHECKS+=1
    if not ok:raise AssertionError(msg)
class Mono:
    def __init__(self,c=1,**p):self.c=F(c);self.p={k:v for k,v in p.items() if v}
    def __mul__(self,o):
        if not isinstance(o,Mono):o=Mono(o)
        p=self.p.copy()
        for k,v in o.p.items():p[k]=p.get(k,0)+v
        return Mono(self.c*o.c,**p)
    __rmul__=__mul__
    def __pow__(self,n):return Mono(self.c**n,**{k:v*n for k,v in self.p.items()})
    def __truediv__(self,o):return self*(o if isinstance(o,Mono) else Mono(o))**-1
    def __rtruediv__(self,o):return self**-1*o
    def sub(self,**m):
        ans=Mono(self.c)
        for k,n in self.p.items():ans*=m.get(k,Mono(**{k:1}))**n
        return ans
    def __eq__(self,o):return isinstance(o,Mono) and self.c==o.c and self.p==o.p
    def show(self):return {'coefficient':str(self.c),'powers':self.p}
A,B,S,T,C,K=[Mono(**{s:1}) for s in ('A','B','S','T','C','K')]
M2,Mn,M3,M4,M5,Mm,Mbs=[Mono(**{s:1}) for s in ('M2','Mn','M3','M4','M5','Mm','Mbs')]
R2,Rn,R3,R4,R5,Rm,Rbs,Rp=[Mono(**{s:1}) for s in ('R2','Rn','R3','R4','R5','Rm','Rbs','Rp')]
h=F(4001,3999);eps=F(1,4000)
def intervals(bscoeff):
    rows={
      'Q':(4*55**2*T**6*C**3,A**4*C**7/(9*T**2)),
      'N2':(4*M2**2*B**8*C**5,A**6*C**7/(4*R2**2*B**4)),
      'P1':(4*2400**2*B**2*S**6*C**5,A**6*C**9/(4*Rp**2*S**4)),
      'P2':(4*2400**2*B**6*S**4*C**5,A**6*C**9/(4*Rp**2*S**4)),
      'A3':(4*M3**2*B**12*C**7,A**8*C**9/(4*R3**2*B**6)),
      'M':(4*Mm**2*B**6*S**16*C**5,A**6*C**11/(4*Rm**2*B**4*S**10)),
      'N3':(4*Mn**2*B**14*C**7,A**8*C**11/(4*Rn**2*B**6)),
      'N3bs':(4*bscoeff**2*S**14*C**7,B**8*C**11/(4*Rbs**2*S**6)),
      'A4':(4*M4**2*B**18*C**9,A**10*C**13/(4*R4**2*B**8)),
      'A5':(4*M5**2*B**24*C**11,A**12*C**17/(4*R5**2*B**10))}
    for j in (4,5,6):rows['O'+str(j)]=(36*(42*B**3*C)**(2*j)*C/B**2,(2*A*C**2/(5*B))**(2*j)/C)
    return rows
def quotient(rows,left,right):return rows[left][1]/(h*rows[right][0])

# The actual sufficient-comparison table: the additional factor shown here
# is retained by direct substitution, and is >=1 on the stated branch.
large=intervals(Mn)
large_constants=dict(K=Mono(400),M2=Mono(735),Mn=Mono(4143),M3=Mono(2265),M4=Mono(166000),M5=Mono(26859063),Mm=Mono(F(8,9)*608**2),R2=Mono(F(5,4)),Rn=Mono(F(35,32)),R3=Mono(F(35,16)),R4=Mono(F(63,8)),R5=Mono(F(495,64)),Rm=Mono(F(3920,81)),Rbs=Mono(F(35,32)),Rp=Mono(3))
records=[]
start=(1-eps)*A**2*C**7/(S**2*T**4*large['Q'][0])
start=start.sub(C=A**2*T**5/S**2).sub(T=2*A*B*S)
expected=(1-eps)*1024*A**20*B**10/12100
check(start==expected,'start Q direct reduction')
records.append(('start Q',expected,Mono(), 'all'))
qn=quotient(large,'Q','N2').sub(C=A**2*T**5/S**2).sub(T=2*A*B*S)
qe=256*A**16*S**4/(36*M2**2*h)
check(qn==qe,'Q N2 direct reduction');records.append(('Q N2',qe,Mono(),'all'))
branches=[
 ('N2','P1',K**2*A**20*B**4/(25*2400**2*h),Mono(),'all'),
 ('N2','P2',K**2*A**20*S**2/(25*2400**2*h),Mono(),'all'),
 ('P1','N3',K**2*A**20/(16*Rp**2*Mn**2*h),S**2/B**4,'S>=B^2'),
 ('P1','A3',K**2*A**20/(16*Rp**2*M3**2*h),S**2/B**2,'S>=B'),
 ('A3','M',K**4*A**36/(16*R3**2*Mm**2*h),B**8/S**4,'S<=B^2'),
 ('M','N3',K**4*A**34*B**2*S**2/(16*Rm**2*Mn**2*h),Mono(),'all'),
 ('N3','A4',K**2*A**22*B**4/(16*Rn**2*M4**2*h),S**6/B**18,'S>=B^3'),
 ('N3','N3bs',K**4*A**36*B**8/(16*Rn**2*Mn**2*h),B**6/S**2,'S<=B^3'),
 ('N3bs','A4',K**2*A**14/(16*Rbs**2*M4**2*h),Mono(),'all'),
 ('A4','O4',K**4*A**38*B**2/(144*R4**2*42**8*h),S**12/B**12,'S>=B'),
 ('O4','A5',K**4*A**36/(4*M5**2*F(5,2)**8*h),S**12/B**12,'S>=B'),
 ('A5','O5',K**6*A**54*B**10/(144*R5**2*42**10*h),S**18/B**18,'S>=B'),
 ('O5','O6',K**6*A**52*B**4/(36*42**12*F(5,2)**10*h),S**18/B**18,'S>=B')]
for l,r,bound,factor,branch in branches:
    raw=quotient(large,l,r).sub(C=K*A**7*B**5*S**3)
    # N2 has R2=5/4, which is already reduced to 25 in the printed table.
    raw=raw.sub(R2=Mono(F(5,4)))
    check(raw==bound*factor,l+' '+r+' symbolic reduction')
    if branch=='S>=B^2':reduced=factor.sub(S=B**2*Mono(z=1))
    elif branch=='S<=B^2':reduced=factor.sub(S=B**2/Mono(z=1))
    elif branch=='S>=B^3':reduced=factor.sub(S=B**3*Mono(z=1))
    elif branch=='S<=B^3':reduced=factor.sub(S=B**3/Mono(z=1))
    elif branch=='S>=B':reduced=factor.sub(S=B*Mono(z=1))
    else:reduced=factor
    check(reduced.c>=1 and all(v>=0 for v in reduced.p.values()),l+' '+r+' branch factor >=1')
    records.append((l+' '+r,bound,factor,branch))
results=[]
for name,bound,factor,branch in records:
    evaluated=bound.sub(**large_constants).sub(A=Mono(3),B=Mono(3),S=Mono(3))
    check(not evaluated.p,'all-large reduction leaves no symbols')
    check(evaluated.c>F(7,5) if name=='N3bs A4' else evaluated.c>F(13,10),name+' strict rational margin')
    results.append({'junction':name,'quotient_at_3':str(evaluated.c),'discarded_factor':factor.show(),'condition':branch})
critical=next(F(r['quotient_at_3']) for r in results if r['junction']=='N3bs A4')
check(critical==F(1224133953984,844113475625),'printed critical quotient')
mu=F(51051,400000);cstar=F(9999,10000)*F(200,19)**2
check(F(1,8)-mu/81>0,'positive bracket before squaring')
gap=3**5*cstar*(F(1,8)-mu/81)**2
check(gap==F(16405041495117,40000000000) and gap>400,'printed K400 gap')
check(F(400*3**12,105)>1,'all-large ordinary base ratio')
# Independently evaluate the two upstream endpoints that now supply T>3ABS.
k1=k2=F(1,2)+F(1,63);kprod=k1*k1*k2;lin=6*kprod-F(1,2);quart=9*k1*k1*k2*k2
p0=F(1,3);j0=2*kprod*F(3,81)+lin*F(3,81)+quart/F(729)
f2=4*kprod+lin*p0+j0/2;f3=6*kprod+lin*p0+j0/3
check(f2==F(27298839409,40831674912) and f2<F(7,10),'new fourth-entry F2')
check(f3==F(57530072833,61247512368) and f3<F(19,20),'new fourth-entry F3')

# Fixed-triple reductions. Both incoming maxima are handled separately;
# every positive power of A in upper endpoints is safely removed.
fixed={key:(l,u.sub(A=Mono())) for key,(l,u) in intervals(Mbs).items()}
x=Mono(x=1);b0=Mono(b0=1);s0=Mono(s0=1)
def fixed_reduce(v):
    v=v.sub(C=K*T**5/S**2)
    check(all(v.p.get(q,0)%2==0 for q in ('B','S','T')),'fixed reduction has even modulus powers')
    p=v.p.copy()
    for old,new in (('B','b0'),('S','s0'),('T','x')):
        n=p.pop(old,0)
        if n:p[new]=p.get(new,0)+n//2
    return Mono(v.c,**p)
fixed_cases=[
 ('start Q',(1-eps)*C**7/(S**2*T**4*fixed['Q'][0]),(1-eps)*K**4*x**5/(12100*s0**5)),
 ('Q N2',quotient(fixed,'Q','N2'),K**2*x**4/(36*M2**2*b0**4*s0**2*h)),
 ('N2 P1',quotient(fixed,'N2','P1'),K**2*x**5/(16*R2**2*2400**2*b0**3*s0**5*h)),
 ('N2 P2',quotient(fixed,'N2','P2'),K**2*x**5/(16*R2**2*2400**2*b0**5*s0**4*h)),
 ('P A3',quotient(fixed,'P1','A3'),K**2*x**5/(16*Rp**2*M3**2*b0**6*s0**4*h)),
 ('A3 M',quotient(fixed,'A3','M'),K**4*x**10/(16*R3**2*Mm**2*b0**6*s0**12*h)),
 ('M N3',quotient(fixed,'M','N3'),K**4*x**10/(16*Rm**2*Mn**2*b0**9*s0**9*h)),
 ('N3 N3bs',quotient(fixed,'N3','N3bs'),K**4*x**10/(16*Rn**2*Mbs**2*b0**3*s0**11*h)),
 ('N3bs A4',quotient(fixed,'N3bs','A4'),K**2*x**5/(16*Rbs**2*M4**2*b0**5*s0**5*h)),
 ('A4 O4',quotient(fixed,'A4','O4'),K**4*x**10/(144*R4**2*42**8*b0**15*s0**4*h)),
 ('O4 A5',quotient(fixed,'O4','A5'),F(2,5)**8*K**4*x**10/(4*M5**2*b0**16*s0**4*h)),
 ('A5 O5',quotient(fixed,'A5','O5'),K**6*x**15/(144*R5**2*42**10*b0**19*s0**6*h)),
 ('O5 O6',quotient(fixed,'O5','O6'),F(2,5)**10*K**6*x**15/(36*42**12*b0**22*s0**6*h))]
for name,raw,printed in fixed_cases:check(fixed_reduce(raw)==printed,name+' fixed symbolic reduction')
base=(C/(105*B**4))**2
check(fixed_reduce(base)==K**2*x**5/(105**2*b0**4*s0**2),'fixed ordinary base ratio')
# For any j, u_j/l_{j+1} is multiplied by (R/H)^2 at the next j.
H=Mono(H=1);R=Mono(R=1);j=9
ordinary=lambda n:(36*H**(2*n)*C/B**2,R**(2*n)/C)
qj=ordinary(j)[1]/ordinary(j+1)[0];qnext=ordinary(j+1)[1]/ordinary(j+2)[0]
check(qnext/qj==(R/H)**2,'ordinary overlap induction, generic exponent cancellation')

# P's universal residual bound and polynomial dominance on 0<=x<=1.
tau=F(21,1024*999)
check(F(35,16)+tau*5268<3,'P residual below3 at q1')
L=[(0,5,10,0,10,5),(0,10,0,0,10,10),(15,80,150,120,35,0),(15,80,150,280,35,0)]
W=[(0,295,143,0,143,295),(0,590,0,0,590,590),(885,1144,435,42,170,0),(885,1144,435,2634,170,0)]
for polys in (L,W):
    for p in polys:
        difference=[v-w for v,w in zip(polys[-1],p)]
        # Move negative high-degree coefficients to x^3: x^j<=x^3,
        # so this gives a coefficientwise nonnegative lower polynomial.
        for k in (5,4):
            if difference[k]<0:difference[3]+=difference[k];difference[k]=0
        check(all(n>=0 for n in difference),'P V polynomial dominance')
check(6*200>28,'P nonzero determinant bracket contradicts C>=200S')
report={'source':str(SOURCE.relative_to(ROOT)),'sha256':HASH,'checks':CHECKS,'large_15_junctions':results,'fixed_13_junctions':[name for name,_,_ in fixed_cases],'retained_gap_coefficient':str(gap),'P_residual_at_1':str(F(35,16)+tau*5268),'critical_all_large_quotient':str(critical)}
(ROOT/'revision_v2/checks/completion_overlaps.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({'sha256':HASH,'checks':CHECKS,'all_large_junctions':len(results),'fixed_junctions':len(fixed_cases),'gap_coefficient':str(gap),'critical_quotient':str(critical),'P_residual_at_1':report['P_residual_at_1']},indent=2))
