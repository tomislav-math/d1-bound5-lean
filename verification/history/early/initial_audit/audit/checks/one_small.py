"""Independent exact reproduction of section 7 (one-small-entry reduction).
No numerical floating point is used in proof assertions. Decimal output only.
"""
from fractions import Fraction as F
from math import isqrt,comb
from pathlib import Path
import json,re,pickle

ROOT=Path(__file__).resolve().parents[2]
TEX=(ROOT/'upload/D1_bound5_complete.tex').read_text()
OUT=ROOT/'audit/checks'
def require(x,msg):
    if not x: raise AssertionError(msg)
def floorroot(v,j=0):
    v=F(v); L=10**j
    return F(isqrt((v.numerator*L*L)//v.denominator),L)
def ceilroot(v,j=0):
    a=floorroot(v,j)
    return a if a*a==v else a+F(1,10**j)

class Ring:
    def __init__(self,d):
        self.d=d; self.t=int(d%4==3); self.u=(d+1)//4 if self.t else d
        self.D=4*self.u-self.t*self.t
    def add(self,a,b): return a[0]+b[0],a[1]+b[1]
    def sub(self,a,b): return a[0]-b[0],a[1]-b[1]
    def neg(self,a): return -a[0],-a[1]
    def mul(self,a,b):
        x,y=a;v,w=b
        return x*v-self.u*y*w,x*w+y*v+self.t*y*w
    def power(self,a,n):
        o=(1,0)
        for _ in range(n): o=self.mul(o,a)
        return o
    def norm(self,a):
        x,y=a
        return x*x+self.t*x*y+self.u*y*y
    def conj(self,a): return a[0]+self.t*a[1],-a[1]
    def ball(self,L):
        yl=isqrt(4*L//self.D)
        for y in range(-yl,yl+1):
            el=isqrt(4*L-self.D*y*y)
            for e in range(-el,el+1):
                if (e-self.t*y)%2==0:
                    yield ((e-self.t*y)//2,y)
    def square(self,z):
        nz=self.norm(z); n=isqrt(nz)
        if n*n!=nz:return False
        p=2*z[0]+self.t*z[1];q=z[1]
        e2=2*n+p; f2num=2*n-p
        if e2<0 or f2num<0 or f2num%self.D:return False
        e=isqrt(e2);f=isqrt(f2num//self.D)
        if e*e!=e2 or self.D*f*f!=f2num:return False
        if e and e*f!=q: f=-f
        if e*f!=q or (e-self.t*f)%2:return False
        rt=((e-self.t*f)//2,f)
        require(self.mul(rt,rt)==z,'square witness failed')
        return True
    def orbitkey(self,a,b):
        aa,ab=a;ba,bb=b
        return (2*aa+self.t*ab<0,ab<0,2*ba+self.t*bb<0,bb<0,aa,ab,ba,bb)
    def canonical(self,a,b):
        p=[(a,b),(self.neg(a),self.neg(b)),(self.conj(a),self.conj(b)),(self.neg(self.conj(a)),self.neg(self.conj(b)))]
        return min(p,key=lambda z:self.orbitkey(*z))

pairsec=TEX.split('The forty first-pair representatives')[1].split('\\end{longtable}')[0]
pairs={}
for m in re.finditer(r'^(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)',pairsec,re.M):
    i,d,ax,ay,bx,by,na,nb=map(int,m.groups());pairs[i]=(d,(ax,ay),(bx,by))
    require(Ring(d).norm((ax,ay))==na and Ring(d).norm((bx,by))==nb,'printed norms')
require(len(pairs)==40,'40 parsed pairs')
coeffsec=TEX.split('Fixed coefficients and the common')[1].split('\\end{longtable}')[0]
fixed={}
for m in re.finditer(r'^(\d+)&(\d+)&(\d+)&(\d+)&(\d+)&(\d+)&(\d+)&(\d+)',coeffsec,re.M):
    i,*v=map(int,m.groups());fixed[i]=v

def inventory():
    counts=[];triples=[]
    for d in [1,2,3,5,6,7,11,15,19,23]:
        R=Ring(d);found=set()
        for a in R.ball(2):
            na=R.norm(a)
            if na not in [1,2]:continue
            for r in R.ball(8):
                bn=R.mul(R.conj(a),R.sub(R.mul(r,r),(1,0)))
                if any(v%na for v in bn):continue
                b=tuple(v//na for v in bn);nb=R.norm(b)
                if not(9<=nb<=(63 if na==1 else 15)):continue
                if (a,b) in [((1,0),(3,0)),((-1,0),(-3,0))]:continue
                found.add((a,b))
        canonical={R.canonical(a,b) for a,b in found}
        expected={(a,b) for _,(dd,a,b) in pairs.items() if dd==d}
        require(canonical==expected,f'pair inventory d={d} diff={canonical^expected}')
        counts.append((d,len(canonical),len(found)))
    for i,(d,a,b) in pairs.items():
        R=Ring(d)
        values=[]
        squares={R.mul(z,z) for z in R.ball(120)}
        for s in R.ball(224):
            if R.norm(s)<R.norm(b) or s in (a,b):continue
            aa=R.add(R.mul(a,s),(1,0));bb=R.add(R.mul(b,s),(1,0))
            direct=aa in squares and bb in squares
            require(direct==(R.square(aa) and R.square(bb)),f'square test disagreement {i,s}')
            if direct:values.append(s)
        byroot=set()
        na=R.norm(a)
        for rt in R.ball(23):
            sn=R.mul(R.conj(a),R.sub(R.mul(rt,rt),(1,0)))
            if any(z%na for z in sn):continue
            s=tuple(z//na for z in sn)
            if R.norm(b)<=R.norm(s)<=224 and s not in (a,b) and R.square(R.add(R.mul(b,s),(1,0))):byroot.add(s)
        require(set(values)==byroot,f'two independent triple enumerations {i}')
        triples.extend((i,*s) for s in values)
    expected=[]
    sec=TEX.split('All remaining triples and the common cutoff procedure.')[1].split('\\end{longtable}')[0]
    for m in re.finditer(r'^(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) & (\d+|--)',sec,re.M):
        i,x,y,ns,mb,n0,last=m.groups();expected.append((int(i),int(x),int(y)))
    require(set(triples)-set(expected)=={(7,3,0)},f'triple difference {set(triples)^set(expected)}')
    require(len(triples)==57 and len(expected)==56,'triple counts')
    print('PAIR COUNTS',counts)
    print('PAIR TOTAL',sum(v for _,_,v in counts),'TRIPLES',len(triples),'MATCH 56+{(1,-3,3)}')
    return triples

families=[('N2',2,2,2,F(5,4)),('N3',3,3,4,F(35,32)),('A3',3,2,4,F(35,16)),('A4',4,3,2,F(63,8)),('A5',5,4,4,F(495,64))]
def binom(a,n):
    v=F(1)
    for j in range(n): v=v*(a-j)/(j+1)
    return v
def make_polys():
    result=[]
    for name,k,m,g,Rold in families:
        pol=[];p=[m,k,k]
        for i in range(3):
            row=[]
            for j in [1,2]:
                out={};tot=p[j]+int(i==j)-1
                for h0 in range(tot+1):
                    for h1 in range(tot-h0+1):
                        h=[h0,h1,tot-h0-h1]
                        bij=4**k*binom(F(2*k+1,2),h[j])
                        for l in range(3):
                            if l!=j:bij*=binom(-p[l]-int(i==l),h[l])
                        if j==1:
                            bx=m;by=int(i==2)+h[2];pc=k-h[1];pd=k-int(i==2)-h[2]
                            bij*=(-1)**(k+int(i==2)+h[2])
                        else:
                            bx=int(i==1)+h[1];by=m;pc=k-h[2];pd=k-int(i==1)-h[1]
                        if i==0:pd-=1
                        if i==1:bx-=1
                        if i==2:by-=1
                        if j==1:bx-=1
                        if j==2:by-=1
                        require(min(bx,by,pc,pd)>=0,'termwise integral division')
                        for l in range(pc+1):
                            for w in range(pd+1):
                                ex=(bx+w+(l if j==1 else 0),by+pd-w+(l if j==2 else 0),l)
                                co=bij*comb(pc,l)*comb(pd,w)*(-1)**(pd-w)
                                out[ex]=out.get(ex,F(0))+co
                require(all(v.denominator==1 for v in out.values()),f'integral {name} {i,j}')
                out={ex:int(v) for ex,v in out.items() if v}
                require(all(r>=0 and s>=0 and 0<=l<=k and r+s==l+m+k-2 for r,s,l in out),'monomial weights')
                row.append(out)
            pol.append(row)
        print('POLYNOMIAL GENERATED',name,flush=True)
        result.append(pol)
    return result

cache=OUT/'one_small_polys.pkl'
if cache.exists():POLYS=pickle.loads(cache.read_bytes())
else:
    POLYS=make_polys();cache.write_bytes(pickle.dumps(POLYS))

def evalpoly_byc(R,poly,a,b,k):
    vals=[(0,0) for _ in range(k+1)]
    for (r,s,l),n in poly.items():
        z=R.mul(R.power(a,r),R.power(b,s));vals[l]=R.add(vals[l],(n*z[0],n*z[1]))
    return vals
def fixed_coeff(R,a,b):
    nb=R.norm(b);output=[]
    for (name,k,m,g,Rold),rows in zip(families,POLYS):
        P=m+2*k;rs=[]
        for row in rows:
            ss=0
            for poly in row:
                for l,z in enumerate(evalpoly_byc(R,poly,a,b,k)):
                    r=k-l
                    if nb<=25:ss+=ceilroot(F(R.norm(z),nb**(P-2)),10)/1000**r
                    else:ss+=ceilroot(F(R.norm(z),nb**(P-2+r)),10)/200**r
            rs.append(F(101,100*g)*ss)
        output.append(int(max(rs))+1)
    return output

eps=F(1,4000);h=F(4001,3999);mu=F(51051,400000);kap=F(3535,409600)
Mm=F(8,9)*608**2;Rm=F(3920,81)
def adaptive(x):
    L=[5*x+10*x*x+10*x**4+5*x**5,10*(x+x**4+x**5),15+80*x+150*x*x+120*x**3+35*x**4,15+80*x+150*x*x+280*x**3+35*x**4]
    W=[295*x+143*x*x+143*x**4+295*x**5,590*(x+x**4+x**5),885+1144*x+435*x*x+42*x**3+170*x**4,885+1144*x+435*x*x+2634*x**3+170*x**4]
    return [l/256+F(21,1024*999)*w for l,w in zip(L,W)]
def quotients(n,b2,s2,G,rho,M,R,Rp,start=1024,second=256):
    M2,Mn,M3,M4,M5=M;R2,Rn,R3,R4,R5=R
    return [
      F(start,12100)*n**5*b2**5*(1-eps),
      F(second,36)*n**4*s2**2/(M2*M2*h),
      G**2*n**10*b2**2/(16*R2**2*2400**2*h),
      G**2*n**10*s2/(16*R2**2*2400**2*h),
      G**2*n**10/(16*Rp**2*Mn**2*h),
      G**2*n**10/(16*Rp**2*M3**2*h),
      G**4*n**18/(16*R3**2*Mm**2*h),
      G**4*n**17*b2*s2/(16*Rm**2*Mn**2*h),
      G**2*n**11*b2**2/(16*Rn**2*M4**2*h),
      G**4*n**18*b2**4/(16*Rn**2*4143**2*h),
      rho**2*n**7/(16*M4**2*h),
      G**4*n**19*b2/(144*R4**2*42**8*h),
      G**4*n**18/(4*M5**2*F(5,2)**8*h),
      G**6*n**27*b2**5/(144*R5**2*42**10*h),
      G**6*n**26*b2**2/(36*42**12*F(5,2)**10*h)]

def regions():
    data=[(8,1,F(1),F(27,8),F(8),269,7495,20687,F(7,50),[36,282,145,4605,38390],F(1260,1000)),
    (4,2,F(3,2),F(3),F(8,3),368,1771,7973,F(7,20),[69,697,326,14771,171856],F(2329,1000)),
    (3,3,F(7,4),F(11,4),F(12,7),540,598,3226,F(18,25),[109,1306,663,34919,482131],F(1166,1000)),
    (3,4,F(2),F(29,10),F(3,2),637,624,3507,F(47,50),[130,1652,863,48019,701908],F(5459,1000)),
    (3,5,F(17,6),F(3),F(18,17),1121,375,2217,F(201,100),[220,3553,1944,134712,2400382],F(1321,1000))]
    for m,n,U,t,q,Fp,G,rho,Rp,M,margin in data:
        l=F(0);r=F(2)
        for _ in range(30):
            z=(l+r)/2;val=5*z*z/q+4*(1+q**-2)*z-4/q
            if val<0:l=z
            else:r=z
        Fbound=(4-l*l)**4*(1+q**-2+r/q)**2
        require(Fbound<Fp,'phase bound')
        Q0=2*(1+1/q)**2;H=F(9999,10000)*F(200,19)**2*t**5*(1-mu*Q0/m**2)**2
        require(H/Q0**2>G and H/(kap*Fp)>rho,'G rho bounds')
        Mcalc=[]
        for (name,k,mm,g,Rold),rows in zip(families,POLYS):
            bound=F(101,100*g)*max(sum(F(abs(v))*q**(-r)*F(1000)**(l-k) for poly in row for (r,s,l),v in poly.items()) for row in rows)
            Mcalc.append(int(bound)+1)
        require(Mcalc==M,f'region M {n}: {Mcalc}!={M}')
        require(max(adaptive(1/q))<Rp,'adaptive region bound')
        R=[old*F(101,200)*((1+1/q)/2)**(2*k) for name,k,mm,g,old in families]
        qs=quotients(n,m*m,m*m,F(G),F(rho),M,R,Rp)
        require(min(qs)>margin,f'region margin {n}: {float(min(qs))}')
        require(F(G,105)*n**4*m**4>1,'tail')
        print('REGION',n,'M',Mcalc,'min quotient',float(min(qs)),'junction',qs.index(min(qs)),'Fp',float(Fbound),'Gactual',float(H/Q0**2),'rhoactual',float(H/(kap*Fp)))

def s15(R,a,b):
    na=R.norm(a);nb=R.norm(b);nab=R.norm(R.sub(a,b))
    A1=ceilroot(na,8);B0=floorroot(nb,8);B1=ceilroot(nb,8);S0=15;T0=2*B0*S0
    rad={(0,1):1/B0,(0,2):F(1,S0),(0,3):1/T0,(1,2):1/(B0*S0),(1,3):1/(B0*T0),(2,3):1/(S0*T0)}
    kk={ij:1/(1+floorroot(1-v,8)) for ij,v in rad.items()}
    k=lambda i,j:kk[tuple(sorted((i,j)))]
    W=F(1,2*nb*S0**2)
    alpha=2*k(0,1)*k(0,2)*k(1,2)
    beta=2*k(1,2)*k(1,3)*k(2,3)*A1*W+F(1,2*S0*S0)*2*k(0,2)*k(0,3)*k(2,3)+F(1,2*nb)*2*k(0,1)*k(0,3)*k(1,3)
    for i,j in rad:
        l,m=[z for z in range(4) if z not in [i,j]]
        cc=2*(k(i,j)*(k(i,l)*k(j,m)+k(i,m)*k(j,l))+k(i,j)**2*k(l,m))-F(1,2)
        require(cc>0,'pair defect positive')
        beta+=cc*rad[i,j]
    beta+=(k(0,1)*k(2,3)+k(0,2)*k(1,3)+k(0,3)*k(1,2))**2*W
    target=(1-beta)/alpha
    tau=(ceilroot(0)+F((1000*target).__ceil__()-1,1000))
    require(1-alpha*tau-beta>0 and tau>2,'tau strict')
    Q0=ceilroot(F(nab,nb),8)*(1+A1/15)*(1+B1/15)
    require(1/Q0>mu/nb,'gap positivity')
    K=F(9999,100)*na*(1/Q0-mu/nb)**2;G=K*tau**5
    H=F(9999,100)*na*tau**5*(1-mu*Q0/nb)**2
    F0=F(nab,nb)*(1+A1/15)**2*(1+B1/15)**8
    rho=H/(kap*F0)
    require(K>F(7,4),'K 7/4')
    M=fixed_coeff(R,a,b)
    Rr=[old*F(101,200)*F(nab,4*nb)**k for name,k,m,g,old in families]
    Rp=max(adaptive(A1/B0))
    require(Rp==adaptive(A1/B0)[-1],'max adaptive is V')
    qs=quotients(1,nb,225,G,rho,M,Rr,Rp,start=9604,second=784)
    require(G*B0*15**3/105>1,'S15 infinite tail')
    return M,tau,K,G,rho,qs

def fixed40():
    for i,(d,a,b) in pairs.items():
        M,tau,K,G,rho,qs=s15(Ring(d),a,b)
        exp=fixed[i]
        require(M==exp[:5],f'fixed M {i} {M}!={exp[:5]}')
        require(tau*1000==exp[5],f'fixed tau {i} {tau}!={exp[5]}')
        require(min(qs)>F(exp[6],1000),f'fixed margin {i} {float(min(qs))}')
        print('S15',i,'M MATCH tau',float(tau),'K',float(K),'min quotient',float(min(qs)),'junction',qs.index(min(qs)))
    # Deliberately investigate a non-manuscript pair to assess removal of HTZ.
    M,tau,K,G,rho,qs=s15(Ring(1),(1,0),(3,0))
    print('EXTRA (1,3) S15',M,'tau',float(tau),'K',float(K),'min quotient',float(min(qs)),'junction',qs.index(min(qs)))
    require(min(qs)>1,'extra (1,3) S15 works')

if __name__=='__main__':
    inventory();regions();fixed40()
    print('ALL REQUIRED SECTION 7 EXACT CHECKS PASSED')
