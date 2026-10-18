from fractions import Fraction as F
from math import isqrt
from pathlib import Path
import json,re
BASE=Path('/workspace/scratch/40edb97fa4c0')
data=json.loads((BASE/'finite_next/one_small/finite_data.json').read_text())
source=(BASE/'finite_next/one_small/manuscript_source.txt').read_text()
start=source.index('Coefficient bounds for the forty fixed pairs.')
end=source.index('\\end{longtable}',start)
M={int(v[0]):list(map(int,v[1:])) for v in re.findall(r'^(\d+)&(\d+)&(\d+)&(\d+)&(\d+)&(\d+)\\\\',source[start:end],re.M)}
assert len(M)==40
L=10**10

def rootlo(v):
 v=F(v); return F(isqrt(v.numerator*L*L//v.denominator),L)
def roothi(v):
 v=F(v); lo=rootlo(v); return lo if lo*lo==v else lo+F(1,L)
def norm(z,tau,nu):
 u,v=z; return u*u+tau*u*v+nu*v*v
def diff(x,y): return [x[0]-y[0],x[1]-y[1]]
def least(c,p):
 n=1
 while c*n**p<=1:n*=2
 lo=0;hi=n
 while lo+1<hi:
  m=(lo+hi)//2
  if c*m**p>1:hi=m
  else:lo=m
 assert c*hi**p>1 and c*(hi-1)**p<=1
 return hi
pairs=data['pairs']
triples=data['triples']+[dict(index=56,pair=40,s=[8,0],ns=64,mbs=34,n0=1024)]
pairs=pairs+[dict(index=40,tau=0,nu=1,a=[1,0],b=[3,0],na=1,nb=9)]
M[40]=[12,41,25,300,1100]
mu=F(51051,400000);kappa=F(3535,409600);h=F(4001,3999)
Mm=F(8,9)*608**2; Rm=F(3920,81)
records=[]
for row in triples:
 pair=pairs[row['pair']]; a,b,s=pair['a'],pair['b'],row['s'];tau,nu=pair['tau'],pair['nu']
 na,nb,ns=pair['na'],pair['nb'],row['ns']
 assert norm(a,tau,nu)==na and norm(b,tau,nu)==nb and norm(s,tau,nu)==ns
 dab,das,dbs=(norm(diff(x,y),tau,nu) for x,y in [(a,b),(a,s),(b,s)])
 qsq=F(dab*das*dbs,nb*ns**2); phisq=max(F(dbs**6,ns**6),F(nb*dbs**5,ns**6))
 q1=roothi(qsq); phi1=roothi(phisq); q=rootlo(F(nb,na));x=1/q
 assert q1>0 and q1*q1>=qsq and phi1*phi1>=phisq and q>2
 assert 1/q1>mu/nb
 K=F(9999,100)*na*(1/q1-mu/nb)**2
 assert K>1
 Rbs=kappa*phi1
 R2,Rn,R3,R4,R5=[r*F(101,200)*F(dab,4*nb)**k for r,k in [(F(5,4),2),(F(35,32),3),(F(35,16),3),(F(63,8),4),(F(495,64),5)]]
 Rp=F(1,256)*(15+80*x+150*x*x+280*x**3+35*x**4)+F(21,1024*999)*(885+1144*x+435*x*x+2634*x**3+170*x**4)
 M2,Mn,M3,M4,M5=M[row['pair']];Mbs=row['mbs']
 coeffs=[
  ((1-F(1,4000))*K**4/(12100*ns**5),5),
  (K**2/(36*M2**2*nb**4*ns**2*h),4),
  (K**2/(16*R2**2*2400**2*nb**3*ns**5*h),5),
  (K**2/(16*R2**2*2400**2*nb**5*ns**4*h),5),
  (K**2/(16*Rp**2*M3**2*nb**6*ns**4*h),5),
  (K**4/(16*R3**2*Mm**2*nb**6*ns**12*h),10),
  (K**4/(16*Rm**2*Mn**2*nb**9*ns**9*h),10),
  (K**4/(16*Rn**2*Mbs**2*nb**3*ns**11*h),10),
  (K**2/(16*Rbs**2*M4**2*nb**5*ns**5*h),5),
  (K**4/(144*R4**2*42**8*nb**15*ns**4*h),10),
  (F(2,5)**8*K**4/(4*M5**2*nb**16*ns**4*h),10),
  (K**6/(144*R5**2*42**10*nb**19*ns**6*h),15),
  (F(2,5)**10*K**6/(36*42**12*nb**22*ns**6*h),15)]
 ns_e=[least(c,p) for c,p in coeffs]
 ni=least(K*K/(105**2*nb**4*ns**2),5)
 eta=1 if na==1 else 4*na*nb*ns+1
 computed=max(1024,ni,eta,*ns_e)
 assert computed==row['n0'], (row['index'],row['n0'],computed,ns_e,ni,eta)
 assert all(c*row['n0']**p>1 for c,p in coeffs)
 rec=dict(index=row['index'],pair=row['pair'],na=na,nb=nb,ns=ns,dab=dab,das=das,dbs=dbs,cutoff=row['n0'],q1=str(q1),phi1=str(phi1),q=str(q),K=str(K),Rp=str(Rp),Rbs=str(Rbs),R2=str(R2),Rn=str(Rn),R3=str(R3),R4=str(R4),R5=str(R5),M2=M2,Mn=Mn,M3=M3,M4=M4,M5=M5,Mbs=Mbs,thresholds=ns_e,tail_threshold=ni,eta=eta)
 records.append(rec)
(BASE/'one_small_analytic_next/fixed_cutoff_certificates.json').write_text(json.dumps(records,indent=2)+'\n')
print(f'All {len(records)} exact cutoff formulas match the manuscript; 13 overlaps and ordinary-tail checks pass for each row.')
print('Rational triple thresholds:',records[-1]['thresholds'],'tail:',records[-1]['tail_threshold'])
