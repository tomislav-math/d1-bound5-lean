from pathlib import Path
from fractions import Fraction as F
from math import isqrt
import json,re
base=Path('/workspace/scratch/40edb97fa4c0'); out=base/'first_pair_geometry_next'
src=(base/'finite_next/one_small/manuscript_source.txt').read_text()
section=src[src.index('Coefficient bounds for the forty fixed pairs.'):src.index('For the rational pair')]
M={int(v[0]):list(map(int,v[1:])) for v in re.findall(r'^(\d+)&(\d+)&(\d+)&(\d+)&(\d+)&(\d+)\\\\',section,re.M)}
M[40]=[12,41,25,300,1100]
data=json.loads((base/'finite_next/one_small/finite_data.json').read_text());pairs=data['pairs']+[dict(index=40,tau=0,nu=1,a=[1,0],b=[3,0],na=1,nb=9)]
L=10**8

def sqrtlo(v):
 v=F(v); return F(isqrt(v.numerator*L*L//v.denominator),L)
def sqrthi(v):
 a=sqrtlo(v);return a if a*a==v else a+F(1,L)
def norm(tau,nu,z):
 x,y=z;return x*x+tau*x*y+nu*y*y
mu=F(51051,400000);kap=F(3535,409600);c0=F(9999,100);t=F(59,20);h=F(4001,3999);Mm=F(8,9)*608**2;Rm=F(3920,81)
records=[]
for row in pairs:
 a,b=row['a'],row['b'];na,nb=row['na'],row['nb'];dab=norm(row['tau'],row['nu'],[a[0]-b[0],a[1]-b[1]])
 A1=sqrthi(na);B0=sqrtlo(nb);B1=sqrthi(nb);d1=sqrthi(F(dab,nb));Q0=d1*(1+A1/15)*(1+B1/15)
 K=c0*na*(1/Q0-mu/nb)**2;G=K*t**5;H=c0*na*t**5*(1-mu*Q0/nb)**2
 F0=F(dab,nb)*(1+A1/15)**2*(1+B1/15)**8;rho=H/(kap*F0)
 q=B0/A1;x=1/q
 Rp=(15+80*x+150*x*x+280*x**3+35*x**4)/256+F(21,1024*999)*(885+1144*x+435*x*x+2634*x**3+170*x**4)
 R2,Rn,R3,R4,R5=[R*F(101,200)*F(dab,4*nb)**k for R,k in [(F(5,4),2),(F(35,32),3),(F(35,16),3),(F(63,8),4),(F(495,64),5)]]
 M2,Mn,M3,M4,M5=M[row['index']]
 checks=[F(9604)*(1-F(1,4000))*nb**5/12100,
 F(784)*225**2/(36*M2*M2*h),
 G**2*nb**2/(16*R2**2*2400**2*h),G**2*225/(16*R2**2*2400**2*h),
 G**2/(16*Rp**2*Mn**2*h),G**2/(16*Rp**2*M3**2*h),
 G**4/(16*R3**2*Mm**2*h),G**4*nb*225/(16*Rm**2*Mn**2*h),
 G**2*nb**2/(16*Rn**2*M4**2*h),G**4*nb**4/(16*Rn**2*4143**2*h),
 rho**2/(16*M4**2*h),G**4*nb/(144*R4**2*42**8*h),
 G**4/(4*M5**2*F(5,2)**8*h),G**6*nb**5/(144*R5**2*42**10*h),G**6*nb**2/(36*42**12*F(5,2)**10*h)]
 tail=G*B0*15**3/105
 assert 1/Q0>mu/nb and K>F(7,4) and q>2
 assert min(checks)>F(59,50),(row['index'],float(min(checks)),checks.index(min(checks)))
 assert tail>1
 rec={**row,'a0':na,'b0':nb,'dab':dab,'A1':A1,'B0':B0,'B1':B1,'d1':d1,'Q0':Q0,'K':K,'G':G,'H':H,'F0':F0,'rho':rho,'q':q,'Rp':Rp,'R2':R2,'Rn':Rn,'R3':R3,'R4':R4,'R5':R5,'M2':M2,'Mn':Mn,'M3':M3,'M4':M4,'M5':M5,'overlaps':checks,'tail':tail}
 records.append(rec)
def serial(v):
 if isinstance(v,F):return str(v)
 if isinstance(v,list):return [serial(x)for x in v]
 if isinstance(v,dict):return {k:serial(x)for k,x in v.items()}
 return v
(out/'first_pair_geometry.json').write_text(json.dumps(serial(records),indent=2)+'\n')
minimum=min((min(r['overlaps']),r['index'],r['overlaps'].index(min(r['overlaps'])))for r in records)
print('All41 exact first-pair geometry records PASS; min overlap',float(minimum[0]),'pair',minimum[1],'junction',minimum[2])
print('MinimumK',float(min(r['K']for r in records)),'minimumtail',float(min(r['tail']for r in records)))
print('Fixed57 data covers',len(set(t['pair'] for t in data['triples'])),'of40 exceptional first pairs')
