#!/usr/bin/env python3
"""Independent exact audit of final 56-triple enumeration and cutoffs.
Only Python standard library; all decisions use integer/Fraction arithmetic.
"""
from fractions import Fraction as F
from math import isqrt, comb
from pathlib import Path
import re, json, hashlib
BASE=Path(__file__).resolve().parents[2]
text=(BASE/'upload/D1_bound5_complete.tex').read_text()

def section(label,nextmarker='\\end{longtable}'):
    return text.split('\\label{'+label+'}',1)[1].split(nextmarker,1)[0]
pairs={}
for line in section('tab:pr-forty-pairs').splitlines():
    m=re.fullmatch(r'(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\',line.strip())
    if m:
        i,d,ax,ay,bx,by,a0,b0=map(int,m.groups());pairs[i]=(d,(ax,ay),(bx,by),a0,b0)
coeff={}
for line in section('tab:pr-forty-coefficients').splitlines():
    m=re.fullmatch(r'(\d+(?:&\d+){7})\\\\',line.strip())
    if m:
        vals=list(map(int,m.group(1).split('&')));coeff[vals[0]]=vals[1:6]
rows=[]
for line in section('tab:fixed56').splitlines():
    m=re.fullmatch(r'(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) & (\d+|--) \\\\',line.strip())
    if m:
        vals=m.groups();rows.append(tuple(map(int,vals[:6]))+(None if vals[6]=='--' else int(vals[6]),))
assert len(pairs)==40 and len(coeff)==40 and len(rows)==56

class Ring:
    def __init__(self,d):
        self.d=d; self.t=d%4==3;self.v=(d+1)//4 if self.t else d;self.disc=4*self.v-int(self.t)
    def norm(self,a):return a[0]**2+self.t*a[0]*a[1]+self.v*a[1]**2
    def add(self,a,b):return (a[0]+b[0],a[1]+b[1])
    def neg(self,a):return (-a[0],-a[1])
    def sub(self,a,b):return self.add(a,self.neg(b))
    def scale(self,a,q):return (a[0]*q,a[1]*q)
    def mul(self,a,b):return (a[0]*b[0]-self.v*a[1]*b[1],a[0]*b[1]+a[1]*b[0]+self.t*a[1]*b[1])
    def conj(self,a):return (a[0]+self.t*a[1],-a[1])
    def div(self,a,b):return self.scale(self.mul(a,self.conj(b)),F(1,self.norm(b)))
    def pow(self,a,n):
        out=(1,0)
        for _ in range(n):out=self.mul(out,a)
        return out
    def ball(self,m):
        for v in range(-isqrt(4*m//self.disc),isqrt(4*m//self.disc)+1):
            b=isqrt(4*m-self.disc*v*v)
            for e in range(-b,b+1):
                if (e-self.t*v)%2==0:yield ((e-self.t*v)//2,v)
    def issquare(self,z):
        n2=self.norm(z);n=isqrt(n2)
        if n*n!=n2:return False
        p=2*z[0]+self.t*z[1];e2=2*n+p;df2=2*n-p
        if e2<0 or df2<0 or df2%self.disc:return False
        e=isqrt(e2);f2=df2//self.disc;f=isqrt(f2)
        if e*e!=e2 or f*f!=f2:return False
        for ff in (f,-f):
            if e*ff==z[1] and (e-self.t*ff)%2==0:
                root=((e-self.t*ff)//2,ff)
                assert self.mul(root,root)==z
                return True
        return False
    def from_root(self,a,r):
        q=self.div(self.sub(self.mul(r,r),(1,0)),a)
        if all(v.denominator==1 for v in q):return tuple(map(int,q))
        return None
    def extends(self,x,y):return self.issquare(self.add(self.mul(x,y),(1,0)))

rings={d:Ring(d) for d, *_ in pairs.values()}
L=10**10

def enc(v,up):
    v=F(v);n=isqrt(v.numerator*L*L//v.denominator)
    assert n*n*v.denominator<=v.numerator*L*L<(n+1)*(n+1)*v.denominator
    if up and n*n*v.denominator!=v.numerator*L*L:n+=1
    return F(n,L)

def binom(q,n):
    r=F(1)
    for j in range(n):r*=F(q-j,j+1)
    return r

def pcols(R,x,y,k=3,m=3):
    """Direct specialization of ff-generator, retaining c-coefficients exactly."""
    p=(m,k,k);diff=R.sub(x,y);answer=[]
    for i in range(3):
        row=[]
        for j in (1,2):
            out=[(0,0) for _ in range(k+1)]
            nt=p[j]+int(i==j)-1
            for h0 in range(nt+1):
                for h1 in range(nt-h0+1):
                    h=(h0,h1,nt-h0-h1)
                    b=4**k*binom(F(2*k+1,2),h[j])
                    for ell in range(3):
                        if ell!=j:b*=binom(-p[ell]-int(i==ell),h[ell])
                    if j==1:
                        pref=R.mul(R.pow(x,m),R.pow(y,int(i==2)+h[2]))
                        pref=R.mul(pref,R.pow(diff,k-int(i==2)-h[2]))
                        pref=R.scale(pref,(-1)**(k+int(i==2)+h[2]));var=x;power=k-h[1]
                    else:
                        pref=R.mul(R.pow(y,m),R.pow(x,int(i==1)+h[1]))
                        pref=R.mul(pref,R.pow(diff,k-int(i==1)-h[1]));var=y;power=k-h[2]
                    for ell in range(power+1):
                        term=R.scale(R.mul(pref,R.pow(var,ell)),b*comb(power,ell))
                        out[ell]=R.add(out[ell],term)
            divisor=R.mul((diff,x,y)[i],(x,y)[j-1])
            out=[R.div(v,divisor) for v in out]
            assert all(z.denominator==1 for v in out for z in v)
            row.append([tuple(map(int,v)) for v in out])
        answer.append(row)
    return answer

def mbs(R,b,s,s0):
    matrix=pcols(R,b,s)
    sums=[]
    for row in matrix:
        val=F(0)
        for col in row:
            for ell,p in enumerate(col):
                if s0<=25:val+=enc(F(R.norm(p),s0**7),True)/1000**(3-ell)
                else:val+=enc(F(R.norm(p),s0**(10-ell)),True)/200**(3-ell)
        sums.append(val)
    upper=F(101,400)*max(sums)
    return upper.numerator//upper.denominator+1

def least_power(c,p):
    n=1
    while c*n**p<=1:n*=2
    low=n//2
    while n-low>1:
        mid=(n+low)//2
        if c*mid**p>1:n=mid
        else:low=mid
    assert c*n**p>1 and c*(n-1)**p<=1
    return n

def cutoff(i,s,Mbs):
    d,a,b,a0,b0=pairs[i];R=rings[d];s0=R.norm(s)
    dab=R.norm(R.sub(a,b));das=R.norm(R.sub(a,s));dbs=R.norm(R.sub(b,s))
    mu=F(51051,400000)
    q1=enc(F(dab*das*dbs,b0*s0**2),True)
    assert 1/q1>mu/b0
    K=F(9999,100)*a0*(1/q1-mu/b0)**2
    assert K>1
    phi=enc(max(F(dbs**6,s0**6),F(b0*dbs**5,s0**6)),True)
    Rbs=F(3535,409600)*phi
    M2,Mn,M3,M4,M5=coeff[i]
    Rs=[r*F(101,200)*F(dab,4*b0)**k for r,k in [(F(5,4),2),(F(35,32),3),(F(35,16),3),(F(63,8),4),(F(495,64),5)]]
    R2,Rn,R3,R4,R5=Rs
    q=enc(F(b0,a0),False); xx=1/q; tau=F(21,1024*999)
    ll=[(5*xx+10*xx**2+10*xx**4+5*xx**5)/256,10*(xx+xx**4+xx**5)/256,(15+80*xx+150*xx**2+120*xx**3+35*xx**4)/256,(15+80*xx+150*xx**2+280*xx**3+35*xx**4)/256]
    ww=[295*xx+143*xx**2+143*xx**4+295*xx**5,590*(xx+xx**4+xx**5),885+1144*xx+435*xx**2+42*xx**3+170*xx**4,885+1144*xx+435*xx**2+2634*xx**3+170*xx**4]
    Rp=max(v+tau*w for v,w in zip(ll,ww));Mm=F(8,9)*608**2;Rm=F(3920,81);h=F(4001,3999);eps=F(1,4000)
    expressions=[
      ('start-Q',(1-eps)*K**4/(12100*s0**5),5),
      ('Q-N2',K**2/(36*M2**2*b0**4*s0**2*h),4),
      ('N2-P-1',K**2/(16*R2**2*2400**2*b0**3*s0**5*h),5),
      ('N2-P-2',K**2/(16*R2**2*2400**2*b0**5*s0**4*h),5),
      ('P-A3',K**2/(16*Rp**2*M3**2*b0**6*s0**4*h),5),
      ('A3-M',K**4/(16*R3**2*Mm**2*b0**6*s0**12*h),10),
      ('M-N3',K**4/(16*Rm**2*Mn**2*b0**9*s0**9*h),10),
      ('N3-N3bs',K**4/(16*Rn**2*Mbs**2*b0**3*s0**11*h),10),
      ('N3bs-A4',K**2/(16*Rbs**2*M4**2*b0**5*s0**5*h),5),
      ('A4-O4',K**4/(144*R4**2*42**8*b0**15*s0**4*h),10),
      ('O4-A5',F(2,5)**8*K**4/(4*M5**2*b0**16*s0**4*h),10),
      ('A5-O5',K**6/(144*R5**2*42**10*b0**19*s0**6*h),15),
      ('O5-O6',F(2,5)**10*K**6/(36*42**12*b0**22*s0**6*h),15),
      ('tail',K**2/(105**2*b0**4*s0**2),5)]
    witnesses={label:least_power(c,p) for label,c,p in expressions}
    eta=1 if a0==1 else 4*a0*b0*s0+1
    n0=max(1024,eta,*witnesses.values())
    assert all(c*n0**p>1 for _,c,p in expressions)
    return n0,witnesses,str(K)

# First-pair arithmetic, complete third-entry enumeration by two independent domains.
thirds={};fourths_by_pair={};witnesses=[]
for i,(d,a,b,a0,b0) in pairs.items():
    R=rings[d]
    assert R.norm(a)==a0 and R.norm(b)==b0 and R.extends(a,b)
    root_set=set()
    for r in R.ball(23):
        s=R.from_root(a,r)
        if s is not None and s not in (a,b) and b0<=R.norm(s)<=224 and R.extends(b,s):root_set.add(s)
    direct_set={s for s in R.ball(224) if s not in (a,b) and b0<=R.norm(s) and R.extends(a,s) and R.extends(b,s)}
    assert root_set==direct_set,(i,'third enumeration differs')
    thirds[i]=root_set
    tt=set()
    for r in R.ball(284):
        z=R.from_root(a,r)
        if z is not None and z not in (a,b) and b0<=R.norm(z)<=40000 and R.extends(b,z):tt.add(z)
    direct_tt={z for z in R.ball(40000) if z not in (a,b) and b0<=R.norm(z) and R.extends(a,z) and R.extends(b,z)}
    assert tt==direct_tt,(i,'fourth pair enumeration differs')
    fourths_by_pair[i]=tt
assert sum(map(len,thirds.values()))==57
listed={(i,(u,v)) for i,u,v,*_ in rows}
generated={(i,s) for i,ss in thirds.items() for s in ss}
extra=generated-listed
assert extra=={(7,(3,0))},extra
assert not listed-generated

for i,u,v,s0,claimed_mbs,claimed_n0,claimed_fourth in rows:
    R=rings[pairs[i][0]];s=(u,v)
    assert R.norm(s)==s0
    computed_mbs=mbs(R,pairs[i][2],s,s0)
    assert computed_mbs==claimed_mbs,(i,s,'Mbs',computed_mbs,claimed_mbs)
    computed_n0,ne,K=cutoff(i,s,computed_mbs)
    assert computed_n0==claimed_n0,(i,s,'N0',computed_n0,claimed_n0)
    tt=sorted(z for z in fourths_by_pair[i] if z!=s and R.norm(z)>=s0 and R.extends(s,z))
    norms=sorted(R.norm(z) for z in tt)
    assert norms==([] if claimed_fourth is None else [claimed_fourth]),(i,s,'fourth',norms,claimed_fourth)
    assert all(n>=computed_n0 for n in norms)
    witnesses.append({'pair':i,'s':s,'norm_s':s0,'Mbs':computed_mbs,'N0':computed_n0,'overlap_thresholds':ne,'K':K,'fourth_elements':tt,'fourth_norms':norms})
assert max(x['N0'] for x in witnesses)==21270
output={'source_sha256':hashlib.sha256(text.encode()).hexdigest(),'method':'All comparisons exact. Independent root-ball and full norm-ball enumerations agree.','pairs':len(pairs),'thirds_before_exclusion':sum(map(len,thirds.values())),'excluded_extra':list(extra),'rows_verified':len(witnesses),'largest_cutoff':max(x['N0'] for x in witnesses),'witnesses':witnesses}
(BASE/'audit/checks/completion_results.json').write_text(json.dumps(output,indent=2))
print('PASS: 40 pair norms and pair-square conditions; 57 third entries by two independent domains; all 56 table rows, Mbs, N0, and fourth complements verified exactly.')
print('PASS: each fourth-extension enumeration through norm 40000 agrees with a direct full norm-ball search; maximum N0 = 21270.')
print('PASS: 56 x 14 least-power thresholds have strict success and predecessor-failure certificates.')
