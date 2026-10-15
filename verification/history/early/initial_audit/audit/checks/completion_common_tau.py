#!/usr/bin/env python3
"""Independent exact audit of the proposed common S>=15 determinant bound."""
from fractions import Fraction as F
from math import isqrt
from pathlib import Path
import json
from completion_verify import Ring,pairs,coeff,rings

def root8(v,up=False):
 v=F(v);L=10**8;n=isqrt(v.numerator*L*L//v.denominator)
 if up and n*n*v.denominator!=v.numerator*L*L:n+=1
 return F(n,L)
keys=[(1,2),(1,3),(1,4),(2,3),(2,4),(3,4)]
rads=[F(1,3),F(1,15),F(1,90),F(1,45),F(1,270),F(1,1350)]
ks=[F(n,10000) for n in (5506,5087,5014,5029,5005,5001)]
rr=dict(zip(keys,rads));kk=dict(zip(keys,ks))
for r,k in zip(rads,ks):assert r*k*k<2*k-1
# This inequality certifies k>1/(1+sqrt(1-r)), and also the linearized remainder bound.
def k(i,j):return kk[tuple(sorted((i,j)))]
alpha=2*k(1,2)*k(1,3)*k(2,3)
W=F(1,4050)
beta=2*k(2,3)*k(2,4)*k(3,4)*3*W+2*k(1,3)*k(1,4)*k(3,4)/450+2*k(1,2)*k(1,4)*k(2,4)/18
for (i,j),rad in rr.items():
 l,m=[z for z in (1,2,3,4) if z not in (i,j)]
 cij=2*(k(i,j)*(k(i,l)*k(j,m)+k(i,m)*k(j,l))+k(i,j)**2*k(l,m))-F(1,2)
 assert cij>0
 beta+=cij*rad
Q=(k(1,2)*k(3,4)+k(1,3)*k(2,4)+k(1,4)*k(2,3))**2
beta+=Q*W
assert alpha==F(70428685819,250000000000)
assert beta==F(752304371871001601,4500000000000000000)
assert alpha<F(141,500) and beta<F(21,125)
tau=F(59,20)
assert F(141,500)*tau+F(21,125)==F(9999,10000)
assert alpha*tau+beta<1
pairs[40]=(1,(1,0),(3,0),1,9);coeff[40]=[12,41,25,300,1100]
mu=F(51051,400000);c0=F(9999,100);kappa=F(3535,409600);h=F(4001,3999)
Mm=F(8,9)*608**2;Rm=F(3920,81);allrows=[]
for i,(d,a,b,na,nb) in pairs.items():
 R=rings[d];nab=R.norm(R.sub(a,b));A1=root8(na,True);B0=root8(nb);B1=root8(nb,True)
 d1=root8(F(nab,nb),True);Q0=d1*(1+A1/15)*(1+B1/15)
 assert 1/Q0>mu/nb
 K=c0*na*(1/Q0-mu/nb)**2;G=K*tau**5;H=c0*na*tau**5*(1-mu*Q0/nb)**2
 F0=F(nab,nb)*(1+A1/15)**2*(1+B1/15)**8;rho=H/(kappa*F0)
 assert K>F(7,4)
 R2,Rn,R3,R4,R5=[r*F(101,200)*F(nab,4*nb)**k for r,k in [(F(5,4),2),(F(35,32),3),(F(35,16),3),(F(63,8),4),(F(495,64),5)]]
 x=A1/B0;Rp=(15+80*x+150*x*x+280*x**3+35*x**4)/256+F(21,1024*999)*(885+1144*x+435*x*x+2634*x**3+170*x**4)
 M2,Mn,M3,M4,M5=coeff[i]
 vals=[9604*nb**5*F(3999,4000)/12100,784*15**4/(36*M2**2*h),G**2*nb**2/(16*R2**2*2400**2*h),G**2*15**2/(16*R2**2*2400**2*h),G**2/(16*Rp**2*Mn**2*h),G**2/(16*Rp**2*M3**2*h),G**4/(16*R3**2*Mm**2*h),G**4*nb*15**2/(16*Rm**2*Mn**2*h),G**2*nb**2/(16*Rn**2*M4**2*h),G**4*nb**4/(16*Rn**2*4143**2*h),rho**2/(16*M4**2*h),G**4*nb/(144*R4**2*42**8*h),G**4/(4*M5**2*F(5,2)**8*h),G**6*nb**5/(144*R5**2*42**10*h),G**6*nb**2/(36*42**12*F(5,2)**10*h)]
 assert min(vals)>F(59,50),(i,float(min(vals)))
 assert G*B0*15**3/105>1
 allrows.append({'pair':i,'minimum':str(min(vals)),'decimal_for_orientation':float(min(vals)),'limiting_edge_index':vals.index(min(vals))})
minimum=min(F(x['minimum']) for x in allrows)
(Path(__file__).resolve().parents[2] / 'audit/checks/completion_common_tau_results.json').write_text(json.dumps({'tau':str(tau),'alpha':str(alpha),'beta':str(beta),'global_minimum':str(minimum),'decimal_for_orientation':float(minimum),'rows':allrows},indent=2))
print('PASS: all six rational square-root bounds, exact alpha and beta, and alpha*(59/20)+beta<1 independently verified.')
print('PASS: common tau=59/20 gives all 15 overlaps>59/50 for all 40 original pairs and (1,3); all tail ratios>1.')
print('Smallest overlap ratio (decimal only for orientation):',float(minimum))
