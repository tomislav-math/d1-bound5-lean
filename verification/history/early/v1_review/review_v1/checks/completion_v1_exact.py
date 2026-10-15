#!/usr/bin/env python3
"""Independent v1 finite reconstruction; standard-library exact arithmetic only.
No imports from prior audit scripts or result files. No manuscript writes.
"""
from pathlib import Path
from fractions import Fraction as F
from math import isqrt, comb
from collections import defaultdict
import re, json, hashlib
ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'upload/D1_bound5-v1(1).tex'
TEXT=SOURCE.read_text()
checks=0

def check(ok, note):
    global checks
    checks+=1
    if not ok: raise AssertionError(note)

def binom(a,n):
    out=F(1)
    for i in range(n): out*=F(a-i,i+1)
    return out

def sqrtbound(q, up=True, digits=10):
    q=F(q); L=10**digits
    n=isqrt(q.numerator*L*L//q.denominator)
    if up and n*n*q.denominator<q.numerator*L*L: n+=1
    return F(n,L)

class Ring:
    def __init__(self,d):
        self.d=d; self.t=d%4==3; self.u=(d+1)//4 if self.t else d
        self.delta=4*self.u-int(self.t)
    def add(self,a,b): return (a[0]+b[0],a[1]+b[1])
    def sub(self,a,b): return (a[0]-b[0],a[1]-b[1])
    def mul(self,a,b): return (a[0]*b[0]-self.u*a[1]*b[1],a[0]*b[1]+a[1]*b[0]+self.t*a[1]*b[1])
    def conj(self,a): return (a[0]+self.t*a[1],-a[1])
    def norm(self,a): return a[0]**2+self.t*a[0]*a[1]+self.u*a[1]**2
    def power(self,a,n):
        out=(1,0)
        for _ in range(n): out=self.mul(out,a)
        return out
    def ball(self,M):
        for y in range(-isqrt(4*M//self.delta),isqrt(4*M//self.delta)+1):
            emax=isqrt(4*M-self.delta*y*y)
            for e in range(-emax,emax+1):
                if (e-self.t*y)%2==0:
                    yield ((e-self.t*y)//2,y)
    def root(self,z):
        n=isqrt(self.norm(z))
        if n*n!=self.norm(z): return None
        p=2*z[0]+self.t*z[1]; q=z[1]
        if 2*n+p<0 or 2*n-p<0: return None
        e=isqrt(2*n+p)
        if e*e!=2*n+p or (2*n-p)%self.delta: return None
        f=isqrt((2*n-p)//self.delta)
        if self.delta*f*f!=2*n-p: return None
        if e and q<0: f=-f
        if e*f!=q or (e-self.t*f)%2: return None
        r=((e-self.t*f)//2,f)
        check(self.mul(r,r)==z,'square witness')
        return r
    def compatible(self,a,b): return self.root(self.add(self.mul(a,b),(1,0))) is not None
    def candidate(self,a,r):
        num=self.mul(self.conj(a),self.sub(self.mul(r,r),(1,0)))
        n=self.norm(a)
        if any(x%n for x in num): return None
        return tuple(x//n for x in num)

# Generate only the two root columns, AFTER row division and anchor division,
# BEFORE division by g, by independently expanding each finite summand.
def polys(k,m):
    p=(m,k,k); rows=[]
    for i in range(3):
        cols=[]
        for j in (1,2):
            poly=defaultdict(F)
            total=p[j]+(i==j)-1
            for h0 in range(total+1):
                for h1 in range(total-h0+1):
                    h=(h0,h1,total-h0-h1)
                    fac=4**k*binom(F(2*k+1,2),h[j])
                    for l in range(3):
                        if l!=j: fac*=binom(-p[l]-(i==l),h[l])
                    if j==1:
                        r=m; s=(i==2)+h[2]; zpow=k-h[1]
                        dpow=k-(i==2)-h[2]; fac*=(-1)**(k+(i==2)+h[2])
                    else:
                        r=(i==1)+h[1]; s=m; zpow=k-h[2]
                        dpow=k-(i==1)-h[1]
                    if i==0: dpow-=1
                    if i==1: r-=1
                    if i==2: s-=1
                    if j==1: r-=1
                    if j==2: s-=1
                    check(min(r,s,zpow,dpow)>=0,'generator exponent')
                    for ell in range(zpow+1):
                        for z in range(dpow+1):
                            ex=(r+dpow-z+(ell if j==1 else 0),s+z+(ell if j==2 else 0),ell)
                            poly[ex]+=fac*comb(zpow,ell)*comb(dpow,z)*(-1)**z
            check(all(v.denominator==1 for v in poly.values()),'integral generated coefficients')
            poly={ex:int(v) for ex,v in poly.items() if v}
            check(all(ex[0]+ex[1]==ex[2]+m+k-2 for ex in poly),'weighted degree')
            cols.append(poly)
        rows.append(cols)
    return rows

PARAMS=[('N2',2,2,2,F(5,4)),('N3',3,3,4,F(35,32)),('A3',3,2,4,F(35,16)),('A4',4,3,2,F(63,8)),('A5',5,4,4,F(495,64))]
POLYS={name:polys(k,m) for name,k,m,g,R in PARAMS}
for name,k,m,g,R in PARAMS:
    check(all(v%g==0 for row in POLYS[name] for col in row for v in col.values()),'normalization g divisibility')

def coefficient(ring,x,y,par):
    name,k,m,g,_=par; P=m+2*k; ny=ring.norm(y)
    values=[]
    for row in POLYS[name]:
        rowval=F(0)
        for col in row:
            coeffs=defaultdict(lambda:(0,0))
            for (r,s,ell),coef in col.items():
                z=ring.mul(ring.power(x,r),ring.power(y,s))
                coeffs[ell]=ring.add(coeffs[ell],tuple(coef*v for v in z))
            for ell,z in coeffs.items():
                rem=k-ell
                if ny<=25: val=sqrtbound(F(ring.norm(z),ny**(P-2)))/1000**rem
                else: val=sqrtbound(F(ring.norm(z),ny**(P-2+rem)))/200**rem
                rowval+=val
        values.append(F(101,100*g)*rowval)
    bound=max(values)
    return bound.numerator//bound.denominator+1, values

pairs=[]
pat=r'^(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\$'
for z in re.finditer(pat,TEXT,re.M):
    ix,d,ax,ay,bx,by,na,nb=map(int,z.groups()); pairs.append((ix,Ring(d),(ax,ay),(bx,by),na,nb))
check(len(pairs)==40,'40 source pairs')
# Reconstruct the finite first-pair list and the allowed symmetry quotient.
rep_sets={}; raw_counts={}
for d in (1,2,3,5,6,7,11,15,19,23):
    ring=Ring(d); raw=set()
    for a in ring.ball(2):
        na=ring.norm(a)
        if na not in (1,2): continue
        for r in ring.ball(8):
            b=ring.candidate(a,r)
            if b is None: continue
            nb=ring.norm(b)
            if not (9<=nb<=(63 if na==1 else 15)): continue
            if (a,b) in (((1,0),(3,0)),((-1,0),(-3,0))): continue
            raw.add((a,b))
    def key(pair):
        a,b=pair
        return (2*a[0]+ring.t*a[1]<0,a[1]<0,2*b[0]+ring.t*b[1]<0,b[1]<0,*a,*b)
    def canonical(pair):
        a,b=pair; ca,cb=ring.conj(a),ring.conj(b)
        neg=lambda z:tuple(-v for v in z)
        return min(((a,b),(ca,cb),(neg(a),neg(b)),(neg(ca),neg(cb))),key=key)
    reps={canonical(pair) for pair in raw}
    check(reps=={(a,b) for _,ri,a,b,_,_ in pairs if ri.d==d},'first-pair orbit reconstruction')
    rep_sets[d]=len(reps); raw_counts[d]=len(raw)
check(list(rep_sets.values())==[9,3,15,2,2,2,2,2,2,1],'pair orbit counts')
check(list(raw_counts.values())==[30,10,58,6,6,8,8,8,8,4],'pair raw counts')

Mtable={}
start=TEXT.index('\\caption{Coefficient bounds for the forty fixed pairs.')
end=TEXT.index('\\end{longtable}',start)
for z in re.finditer(r'^(\d+)&(\d+)&(\d+)&(\d+)&(\d+)&(\d+)\\\\$',TEXT[start:end],re.M):
    vals=list(map(int,z.groups())); Mtable[vals[0]]=vals[1:]
check(len(Mtable)==40,'40 coefficient rows')
Ttable=[]
for z in re.finditer(r'^(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) & (\d+|--) \\\\$',TEXT,re.M):
    vals=z.groups(); Ttable.append((int(vals[0]),(int(vals[1]),int(vals[2])),*map(int,vals[3:6]),None if vals[6]=='--' else int(vals[6])))
check(len(Ttable)==56,'56 source final rows')

# Exact endpoint construction, independent of printed overlap table.
# Monomials use exponents of B,S,T,C.
def mono(c,B=0,S=0,T=0,C=0): return F(c),(B,S,T,C)
def divide(a,b): return a[0]/b[0],tuple(x-y for x,y in zip(a[1],b[1]))
def ratio_after_gap(a,b,K,b0,s0,factor=F(1)):
    val,ex=divide(a,b); B,S,T,C=ex
    S-=2*C; T+=5*C; val*=K**C*factor
    check(B%2==S%2==T%2==0,'even overlap powers')
    return val*F(b0)**(B//2)*F(s0)**(S//2),T//2

def ordinary(j):
    return mono(36*42**(2*j),B=6*j-2,C=2*j+1),mono(F(2,5)**(2*j),B=-2*j,C=4*j-1)

def overlap_data(K,b0,s0,Ms,Mbs,Rs,Rbs,Rp):
    M2,Mn,M3,M4,M5=Ms; R2,Rn,R3,R4,R5=Rs
    Mm=F(8,9)*608**2; Rm=F(3920,81)
    rows={
      'Q':(mono(12100,T=6,C=3),mono(F(1,9),T=-2,C=7)),
      'N2':(mono(4*M2*M2,B=8,C=5),mono(1/(4*R2*R2),B=-4,C=7)),
      'Pfirst':(mono(4*2400**2,B=2,S=6,C=5),mono(1/(4*Rp*Rp),S=-4,C=9)),
      'Psecond':(mono(4*2400**2,B=6,S=4,C=5),mono(1/(4*Rp*Rp),S=-4,C=9)),
      'A3':(mono(4*M3*M3,B=12,C=7),mono(1/(4*R3*R3),B=-6,C=9)),
      'M':(mono(4*Mm*Mm,B=6,S=16,C=5),mono(1/(4*Rm*Rm),B=-4,S=-10,C=11)),
      'N3':(mono(4*Mn*Mn,B=14,C=7),mono(1/(4*Rn*Rn),B=-6,C=11)),
      'N3bs':(mono(4*Mbs*Mbs,S=14,C=7),mono(1/(4*Rbs*Rbs),B=8,S=-6,C=11)),
      'A4':(mono(4*M4*M4,B=18,C=9),mono(1/(4*R4*R4),B=-8,C=13)),
      'A5':(mono(4*M5*M5,B=24,C=11),mono(1/(4*R5*R5),B=-10,C=17)),
      'O4':ordinary(4),'O5':ordinary(5),'O6':ordinary(6)}
    edges=[('Q','N2'),('N2','Pfirst'),('N2','Psecond'),('Pfirst','A3'),('A3','M'),('M','N3'),('N3','N3bs'),('N3bs','A4'),('A4','O4'),('O4','A5'),('A5','O5'),('O5','O6')]
    coeff=[ratio_after_gap(mono(1,S=-2,T=-4,C=7),rows['Q'][0],K,b0,s0,F(3999,4000))]
    for a,b in edges: coeff.append(ratio_after_gap(rows[a][1],rows[b][0],K,b0,s0,F(3999,4001)))
    h=F(4001,3999)
    expected=[
      (F(3999,4000)*K**4/(12100*s0**5),5),
      (K**2/(36*M2**2*b0**4*s0**2*h),4),
      (K**2/(16*R2**2*2400**2*b0**3*s0**5*h),5),
      (K**2/(16*R2**2*2400**2*b0**5*s0**4*h),5),
      (K**2/(16*Rp**2*M3**2*b0**6*s0**4*h),5),
      (K**4/(16*R3**2*Mm**2*b0**6*s0**12*h),10),
      (K**4/(16*Rm**2*Mn**2*b0**9*s0**9*h),10),
      (K**4/(16*Rn**2*Mbs**2*b0**3*s0**11*h),10),
      (K**2/(16*Rbs**2*M4**2*b0**5*s0**5*h),5),
      (K**4/(144*R4**2*42**8*b0**15*s0**4*h),10),
      (F(2,5)**8*K**4/(4*M5**2*b0**16*s0**4*h),10),
      (K**6/(144*R5**2*42**10*b0**19*s0**6*h),15),
      (F(2,5)**10*K**6/(36*42**12*b0**22*s0**6*h),15)]
    check(coeff==expected,'all thirteen independently divided overlaps')
    return coeff

def least_integer(c,p):
    lo=0; hi=1
    while c*hi**p<=1: lo,hi=hi,2*hi
    while hi-lo>1:
        mid=(hi+lo)//2
        if c*mid**p>1: hi=mid
        else: lo=mid
    check(c*hi**p>1 and c*(hi-1)**p<=1,'strict least threshold')
    return hi

def cutoff(ring,a,b,s,Ms):
    a0,b0,s0=map(ring.norm,(a,b,s))
    dab,das,dbs=(ring.norm(ring.sub(v,w)) for v,w in ((a,b),(a,s),(b,s)))
    q1=sqrtbound(F(dab*das*dbs,b0*s0*s0))
    mu=F(51051,400000)
    check(1/q1>mu/b0,'positive retained coefficient')
    K=F(9999,100)*a0*(1/q1-mu/b0)**2
    check(K>1,'K>1')
    phi=sqrtbound(max(F(dbs**6,s0**6),F(b0*dbs**5,s0**6)))
    Rbs=F(3535,409600)*phi
    Mbs,_=coefficient(ring,b,s,PARAMS[1])
    Rs=[old*F(101,200)*F(dab,4*b0)**k for _,k,_,_,old in PARAMS]
    q=sqrtbound(F(b0,a0),False); x=1/q
    Rp=(15+80*x+150*x*x+280*x**3+35*x**4)/256+F(21,1024*999)*(885+1144*x+435*x*x+2634*x**3+170*x**4)
    coeff=overlap_data(K,b0,s0,Ms,Mbs,Rs,Rbs,Rp)
    ns=[least_integer(c,p) for c,p in coeff]
    ni=least_integer(K*K/(105**2*b0**4*s0*s0),5)
    eta=1 if a0==1 else 4*a0*b0*s0+1
    N0=max(1024,ni,*ns,eta)
    return dict(q1=str(q1),K=str(K),Mbs=Mbs,N0=N0,thresholds=ns,infinite=ni,eta=eta,
                threshold_ratios_at_N0=[str(c*N0**p) for c,p in coeff])

out={'source_sha256':hashlib.sha256(SOURCE.read_bytes()).hexdigest(),'coefficient_checks':[],'triples':[],'first_pair_orbits':rep_sets,'first_pair_raw_counts':raw_counts}
for ix,ring,a,b,na,nb in pairs:
    check((ring.norm(a),ring.norm(b))==(na,nb),'pair norms')
    check(ring.compatible(a,b),'pair compatibility')
    Ms=[coefficient(ring,a,b,par)[0] for par in PARAMS]
    check(Ms==Mtable[ix],f'fixed coefficient {ix}: {Ms} != {Mtable[ix]}')
    out['coefficient_checks'].append(dict(pair=ix,reconstructed=Ms))

# Enumerate every third entry directly in its disk, independently of root-first loops.
all_triples=[]
for ix,ring,a,b,na,nb in pairs:
    direct={s for s in ring.ball(224) if ring.norm(s)>=nb and s not in (a,b) and ring.compatible(a,s) and ring.compatible(b,s)}
    via_roots=set()
    for r in ring.ball(23):
        s=ring.candidate(a,r)
        if s is not None and nb<=ring.norm(s)<=224 and s not in (a,b) and ring.compatible(b,s): via_roots.add(s)
    check(direct==via_roots,'direct/root third search equality')
    all_triples += [(ix,s) for s in sorted(direct)]
check(len(all_triples)==57,'57 triples')
check((7,(3,0)) in all_triples,'exceptional (1,-3,3)')
check(set(all_triples)-{(7,(3,0))}=={(z[0],z[1]) for z in Ttable},'exact 56 final triple list')

for ix,s,s0,Mbs,N0,fourth in Ttable:
    _,ring,a,b,na,nb=pairs[ix]
    check(ring.norm(s)==s0,'third norm')
    data=cutoff(ring,a,b,s,Mtable[ix])
    check(data['Mbs']==Mbs,f'Mbs pair {ix} s{s}')
    check(data['N0']==N0,f'N0 pair {ix} s{s}: {data["N0"]} != {N0}')
    candidates=set()
    for r in ring.ball(284):
        t=ring.candidate(a,r)
        if t is not None and s0<=ring.norm(t)<=40000 and t not in (a,b,s) and ring.compatible(b,t) and ring.compatible(s,t): candidates.add(t)
    observed=sorted(ring.norm(t) for t in candidates)
    check(observed==([] if fourth is None else [fourth]),f'fourth list {ix} s{s}: {observed}')
    check(all(n>=N0 for n in observed),'finite complement empty')
    # Independent target square-set test and all six root witnesses for survivors.
    squares={ring.mul(r,r) for r in ring.ball(3001)}
    for t in candidates:
        vertices=(a,b,s,t)
        for j in range(4):
            for k in range(j):
                z=ring.add(ring.mul(vertices[j],vertices[k]),(1,0))
                check(z in squares,'independent enumerated root witness')
    data.update(pair=ix,s=s,snorm=s0,fourths=[dict(coordinates=t,norm=ring.norm(t)) for t in sorted(candidates)])
    out['triples'].append(data)

rr=Ring(1)
rational_M=[coefficient(rr,(1,0),(3,0),par)[0] for par in PARAMS]
check(all(x<=y for x,y in zip(rational_M,[12,41,25,300,1100])),'rational fixed coefficient bounds')
out['rational_fixed_coefficient_minima']=rational_M
rational=cutoff(rr,(1,0),(3,0),(8,0),[12,41,25,300,1100])
check(rational['q1']=='1822916667/5000000000','rational q1')
check(F(rational['K'])>744,'rational K')
check(rational['Mbs']==34 and rational['N0']==1024,'rational Mbs cutoff')
check(rational['thresholds']==[3,23,96,101,108,179,131,9,34,76,123,29,438],'rational thresholds')
check(rational['infinite']==14,'rational infinite')
check([s for s in range(4,15) if isqrt(s+1)**2==s+1 and isqrt(3*s+1)**2==3*s+1]==[8],'rational third list')
out['rational']=rational
out['counts']=dict(checks=checks,triples=len(all_triples),retained=len(Ttable),finite_fourths=sum(len(z['fourths']) for z in out['triples']),max_cutoff=max(z['N0'] for z in out['triples']))
(ROOT/'review_v1/checks/completion_v1_exact_results.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({'status':'PASS','source_sha256':out['source_sha256'],**out['counts']},indent=2))
