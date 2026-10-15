#!/usr/bin/env python3
"""Independent reconstruction of the new {1,3} no-sextuple calculation."""
from fractions import Fraction as F
from math import isqrt
from pathlib import Path
import json
from completion_verify import Ring,pcols,enc,cutoff,pairs,coeff,mbs
R=Ring(1);a=(1,0);b=(3,0);s=(8,0)
computed=[]
for k,m,g in [(2,2,2),(3,3,4),(3,2,4),(4,3,2),(5,4,4)]:
 mat=pcols(R,a,b,k,m);P=m+2*k
 upper=max(sum(enc(F(R.norm(v),9**(P-2)),True)/1000**(k-ell) for col in row for ell,v in enumerate(col)) for row in mat)*F(101,100*g)
 computed.append(upper.numerator//upper.denominator+1)
assert computed==[12,41,25,300,1100],computed
pairs[40]=(1,a,b,1,9);coeff[40]=computed
Mbs=mbs(R,b,s,64);n0,thresholds,Kfinal=cutoff(40,s,Mbs)
assert Mbs==34 and n0==1024
assert list(thresholds.values())==[3,23,96,101,108,179,131,9,34,76,123,29,438,14]

def sqrt8(v,upper=False):
 v=F(v);N=10**8;root=isqrt(v.numerator*N*N//v.denominator)
 if upper and root*root*v.denominator!=v.numerator*N*N:root+=1
 return F(root,N)
A1=F(1);B0=B1=F(3);S0=F(15);T0=F(90);na=1;nb=9;nab=4
rr={(1,2):1/B0,(1,3):1/S0,(1,4):1/T0,(2,3):1/(B0*S0),(2,4):1/(B0*T0),(3,4):1/(S0*T0)}
kk={key:1/(1+sqrt8(1-v)) for key,v in rr.items()}
def k(i,j):return kk[tuple(sorted((i,j)))]
W=1/(2*nb*S0*S0)
alpha=2*k(1,2)*k(1,3)*k(2,3)
beta=2*k(2,3)*k(2,4)*k(3,4)*A1*W+2*k(1,3)*k(1,4)*k(3,4)/(2*S0*S0)+2*k(1,2)*k(1,4)*k(2,4)/(2*nb)
for (i,j),rad in rr.items():
 k0,l0=[z for z in (1,2,3,4) if z not in (i,j)]
 cij=2*(k(i,j)*(k(i,k0)*k(j,l0)+k(i,l0)*k(j,k0))+k(i,j)**2*k(k0,l0))-F(1,2)
 beta+=cij*rad
Q4=(k(1,2)*k(3,4)+k(1,3)*k(2,4)+k(1,4)*k(2,3))**2
beta+=Q4*W
upper=1000*(1-beta)/alpha
tau=F((upper.numerator-1)//upper.denominator,1000)
assert tau==F(2958,1000) and 1-alpha*tau-beta>0 and 1-alpha*(tau+F(1,1000))-beta<=0
mu=F(51051,400000);c0=F(9999,100);kappa=F(3535,409600)
d1=sqrt8(F(nab,nb),True);Q0=d1*(1+A1/15)*(1+B1/15)
K=c0*na*(1/Q0-mu/nb)**2;G=K*tau**5;H=c0*na*tau**5*(1-mu*Q0/nb)**2
F0=F(nab,nb)*(1+A1/15)**2*(1+B1/15)**8;rho=H/(kappa*F0)
assert 1/Q0>mu/nb and K>F(7,4)
R2,Rn,R3,R4,R5=[r*F(101,200)*F(nab,4*nb)**exponent for r,exponent in [(F(5,4),2),(F(35,32),3),(F(35,16),3),(F(63,8),4),(F(495,64),5)]]
x=F(1,3);Rp=F(15+80*x+150*x*x+280*x**3+35*x**4,256)+F(21,1024*999)*(885+1144*x+435*x*x+2634*x**3+170*x**4)
M2,Mn,M3,M4,M5=computed;Mm=F(8,9)*608**2;Rm=F(3920,81);h=F(4001,3999)
vals=[9604*3**10*F(3999,4000)/12100,784*15**4/(36*M2**2*h),G**2*3**4/(16*R2**2*2400**2*h),G**2*15**2/(16*R2**2*2400**2*h),G**2/(16*Rp**2*Mn**2*h),G**2/(16*Rp**2*M3**2*h),G**4/(16*R3**2*Mm**2*h),G**4*3**2*15**2/(16*Rm**2*Mn**2*h),G**2*3**4/(16*Rn**2*M4**2*h),G**4*3**8/(16*Rn**2*4143**2*h),rho**2/(16*M4**2*h),G**4*3**2/(144*R4**2*42**8*h),G**4/(4*M5**2*F(5,2)**8*h),G**6*3**10/(144*R5**2*42**10*h),G**6*3**4/(36*42**12*F(5,2)**10*h)]
assert all(v>6114 for v in vals)
assert G*B0*15**3/105>1
svals=[j for j in range(4,15) if isqrt(j+1)**2==j+1 and isqrt(3*j+1)**2==3*j+1]
tvals=[j for j in range(9,32) if isqrt(j+1)**2==j+1 and isqrt(3*j+1)**2==3*j+1]
assert svals==[8] and tvals==[]
out={'M':computed,'Mbs':Mbs,'N0':n0,'thresholds':thresholds,'tau':str(tau),'K_S15':str(K),'G':str(G),'rho':str(rho),'minimum_S15_overlap':str(min(vals)),'S15_minimum_decimal_for_orientation_only':float(min(vals)),'s_below15':svals,'t_between8and32':tvals,'logic':'Only excludes sextuples. The same estimates do not assert no quintuples. Apply field-independent analytic formulas directly, not the proposition restricted to the 40 listed pairs.'}
(Path(__file__).resolve().parents[2] / 'audit/checks/completion_htz_free_results.json').write_text(json.dumps(out,indent=2))
print('PASS: (1,3) coefficient bounds independently regenerated:',computed)
print('PASS: S>=15 gives all 15 overlap quotients >6114 and tail ratio>1; therefore s=8.')
print('PASS: (1,3,8) Mbs=34 and N0=1024 independently regenerated; all 14 thresholds match.')
print('PASS: t<32 and t>8 leave t=15 or24 from t+1 square, neither with 3t+1 square.')
print('CAUTION: proves no sextuple, not no quintuple; generic formulas must be applied directly to avoid invoking finite-pair classification circularly.')
