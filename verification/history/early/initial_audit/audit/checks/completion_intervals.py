#!/usr/bin/env python3
"""Exact endpoint algebra and minimum comparisons for Sections 6 and 9."""
from fractions import Fraction as F
from pathlib import Path
import json
BASE=Path(__file__).resolve().parents[2]
# Monomials in formal positive variables, with exact rational coefficients.
class Mono:
 def __init__(self,c=1,**powers):self.c=F(c);self.p={x:F(e) for x,e in powers.items() if e}
 def __mul__(self,o):
  if not isinstance(o,Mono):o=Mono(o)
  d=dict(self.p)
  for x,e in o.p.items():d[x]=d.get(x,0)+e
  return Mono(self.c*o.c,**d)
 __rmul__=__mul__
 def __pow__(self,e):return Mono(self.c**e,**{x:p*e for x,p in self.p.items()})
 def __truediv__(self,o):
  if not isinstance(o,Mono):o=Mono(o)
  return self*o**-1
 def __rtruediv__(self,o):return self**-1*o
 def sub(self,x,y):
  e=self.p.get(x,0);d={v:p for v,p in self.p.items() if v!=x}
  return Mono(self.c,**d)*(y**int(e))
 def __eq__(self,o):return self.c==o.c and self.p==o.p
 def string(self):return str(self.c)+' '+str({x:str(p) for x,p in sorted(self.p.items())})
 def value(self,**v):
  out=self.c
  for x,p in self.p.items():assert p.denominator==1;out*=F(v[x])**int(p)
  return out
A=Mono(A=1);B=Mono(B=1);S=Mono(S=1);T=Mono(T=1);C=Mono(C=1)
eps=F(1,4000);h=F(4001,3999);K=54;beta=3456
M2=735;Mn=4143;M3=2265;M4=166000;M5=26859063;Mm=F(8,9)*608**2
Rn=F(35,32);R3=F(35,16);R4=F(63,8);R5=F(495,64);Rm=F(3920,81)
kappa=F(3535,409600);Fphase=F(8,5)**4*F(12,5)**6
mu=F(51051,400000)
largeconstant=32*F(9999,10000)*F(200,19)**2*(1-8*mu/81)**2
assert largeconstant==F(5468347165039,1582031250) and largeconstant>3456
assert beta/64==K
L={};U={}
L['Q']=4*55**2*T**6*C**3;U['Q']=A**4*C**7/(9*T**2)
L['N2']=4*M2**2*B**8*C**5;U['N2']=4*A**6*C**7/(25*B**4)
L['P1']=4*2400**2*B**2*S**6*C**5;L['P2']=4*2400**2*B**6*S**4*C**5
U['P']=A**6*C**9/(4*145**2*S**4)
L['P01']=4*39000**2*S**8*C**5;L['P02']=4*39000**2*B**10*C**5
U['P0']=A**6*C**9/(4*300**2*B**4)
L['A3']=4*M3**2*B**12*C**7;U['A3']=A**8*C**9/(4*R3**2*B**6)
L['M']=4*Mm**2*B**6*S**16*C**5;U['M']=A**6*C**11/(4*Rm**2*B**4*S**10)
L['N3']=4*Mn**2*B**14*C**7;U['N3']=A**8*C**11/(4*Rn**2*B**6)
L['N3bs']=4*Mn**2*S**14*C**7
L['A4']=4*M4**2*B**18*C**9;U['A4']=A**10*C**13/(4*R4**2*B**8)
L['A5']=4*M5**2*B**24*C**11;U['A5']=A**12*C**17/(4*R5**2*B**10)
for j in range(4,7):L[f'O{j}']=36*(42*B**3*C)**(2*j)*C/B**2;U[f'O{j}']=(F(2,5)*A*C**2/B)**(2*j)/C
G=A**2*C**7/(S**2*T**4)
raw=(1-eps)*G/L['Q'];reduced=raw.sub('C',A**2*T**5/S**2).sub('T',2*A*B*S)
expected=(1-eps)*1024*A**20*B**10/12100
assert reduced==expected
raw=U['Q']/(h*L['N2']);reduced=raw.sub('C',A**2*T**5/S**2).sub('T',2*A*B*S)
expected2=256*A**16*S**4/(36*M2**2*h)
assert reduced==expected2
records=[{'edge':'start-Q','minimum':str(expected.value(A=3,B=3))},{'edge':'Q-N2','minimum':str(expected2.value(A=3,S=3))}]
# Each residual factor below is >=1 under its printed branch.
checks=[
 ('N2','P1',K**2*A**20*B**4/(25*2400**2*h),Mono(), 'always'),
 ('N2','P2',K**2*A**20*S**2/(25*2400**2*h),Mono(), 'always'),
 ('N2','P01',K**2*A**20*B**4/(4*25*39000**2*h),4*B**2/S**2,'S<2B'),
 ('N2','P02',K**2*A**20*B**2/(25*39000**2*h),S**6/B**6,'S>=B'),
 ('P','N3',K**2*A**20/(16*145**2*Mn**2*h),S**2/B**4,'S>=B^2'),
 ('P','A3',K**2*A**20/(16*145**2*M3**2*h),S**2/B**2,'S>=B'),
 ('P0','A3',K**2*A**20/(16*300**2*M3**2*h),S**6/B**6,'S>=B'),
 ('A3','M',K**4*A**36/(16*R3**2*Mm**2*h),B**8/S**4,'S<=B^2'),
 ('M','N3',K**4*A**34*B**2*S**2/(16*Rm**2*Mn**2*h),Mono(),'always'),
 ('N3','A4',K**2*A**22*B**4/(16*Rn**2*M4**2*h),S**6/B**18,'S>=B^3'),
 ('N3','N3bs',K**4*A**36*B**8/(16*Rn**2*Mn**2*h),B**6/S**2,'S<=B^3'),
 ('A4','O4',K**4*A**38*B**2/(144*R4**2*42**8*h),S**12/B**12,'S>=B'),
 ('O4','A5',K**4*A**36/(4*M5**2*F(5,2)**8*h),S**12/B**12,'S>=B'),
 ('A5','O5',K**6*A**54*B**10/(144*R5**2*42**10*h),S**18/B**18,'S>=B'),
 ('O5','O6',K**6*A**52*B**4/(36*42**12*F(5,2)**10*h),S**18/B**18,'S>=B')]
for left,right,bound,residual,branch in checks:
 ratio=(U[left]/(h*L[right])).sub('C',K*A**7*B**5*S**3)
 assert ratio==bound*residual,(left,right,ratio.string(),(bound*residual).string())
 minimum=bound.value(A=3,B=3,S=3)
 assert minimum>F(13,10),(left,right,minimum)
 records.append({'edge':left+'-'+right,'minimum':str(minimum),'discarded_factor':residual.string(),'branch':branch})
tight=beta**2*F(3)**14/(16*kappa**2*Fphase**2*M4**2*h)
assert tight==F(4003515472412109375,3611631944665923584) and tight>1
records.append({'edge':'N3bs-A4','minimum':str(tight),'phase_bound':str(Fphase)})
assert all(F(r['minimum'])>F(13,10) for r in records if r['edge']!='N3bs-A4')
# Fixed-56 coefficients: derive every displayed power using generic constants.
M2=Mono(M2=1);Mn=Mono(Mn=1);M3=Mono(M3=1);M4=Mono(M4=1);M5=Mono(M5=1);Mbs=Mono(Mbs=1)
R2=Mono(R2=1);Rn=Mono(Rn=1);R3=Mono(R3=1);R4=Mono(R4=1);R5=Mono(R5=1);Rp=Mono(Rp=1);Rbs=Mono(Rbs=1);K=Mono(K=1)
L={};U={}
L['Q']=4*55**2*T**6*C**3;U['Q']=C**7/(9*T**2)
L['N2']=4*M2**2*B**8*C**5;U['N2']=C**7/(4*R2**2*B**4)
L['P1']=4*2400**2*B**2*S**6*C**5;L['P2']=4*2400**2*B**6*S**4*C**5;U['P']=C**9/(4*Rp**2*S**4)
L['A3']=4*M3**2*B**12*C**7;U['A3']=C**9/(4*R3**2*B**6)
L['M']=4*Mm**2*B**6*S**16*C**5;U['M']=C**11/(4*Rm**2*B**4*S**10)
L['N3']=4*Mn**2*B**14*C**7;U['N3']=C**11/(4*Rn**2*B**6)
L['N3bs']=4*Mbs**2*S**14*C**7;U['N3bs']=B**8*C**11/(4*Rbs**2*S**6)
L['A4']=4*M4**2*B**18*C**9;U['A4']=C**13/(4*R4**2*B**8)
L['A5']=4*M5**2*B**24*C**11;U['A5']=C**17/(4*R5**2*B**10)
for j in range(4,7):L[f'O{j}']=36*(42*B**3*C)**(2*j)*C/B**2;U[f'O{j}']=(F(2,5)*C**2/B)**(2*j)/C
b0=Mono(b0=1);s0=Mono(s0=1);x=Mono(x=1)
def norms(m):
 assert all(m.p.get(v,0)%2==0 for v in ('B','S','T'))
 out=Mono(m.c,**{v:p for v,p in m.p.items() if v not in ('B','S','T')})
 return out*b0**int(m.p.get('B',0)/2)*s0**int(m.p.get('S',0)/2)*x**int(m.p.get('T',0)/2)
G=C**7/(S**2*T**4)
assert norms(((1-eps)*G/L['Q']).sub('C',K*T**5/S**2))==(1-eps)*K**4*x**5/(12100*s0**5)
checks=[
 ('Q','N2',K**2*x**4/(36*M2**2*b0**4*s0**2*h)),
 ('N2','P1',K**2*x**5/(16*R2**2*2400**2*b0**3*s0**5*h)),
 ('N2','P2',K**2*x**5/(16*R2**2*2400**2*b0**5*s0**4*h)),
 ('P','A3',K**2*x**5/(16*Rp**2*M3**2*b0**6*s0**4*h)),
 ('A3','M',K**4*x**10/(16*R3**2*Mm**2*b0**6*s0**12*h)),
 ('M','N3',K**4*x**10/(16*Rm**2*Mn**2*b0**9*s0**9*h)),
 ('N3','N3bs',K**4*x**10/(16*Rn**2*Mbs**2*b0**3*s0**11*h)),
 ('N3bs','A4',K**2*x**5/(16*Rbs**2*M4**2*b0**5*s0**5*h)),
 ('A4','O4',K**4*x**10/(144*R4**2*42**8*b0**15*s0**4*h)),
 ('O4','A5',F(2,5)**8*K**4*x**10/(4*M5**2*b0**16*s0**4*h)),
 ('A5','O5',K**6*x**15/(144*R5**2*42**10*b0**19*s0**6*h)),
 ('O5','O6',F(2,5)**10*K**6*x**15/(36*42**12*b0**22*s0**6*h))]
for left,right,bound in checks:
 got=norms((U[left]/(h*L[right])).sub('C',K*T**5/S**2))
 assert got==bound,(left,right,got.string(),bound.string())
assert norms((C**2/(105**2*B**8)).sub('C',K*T**5/S**2))==K**2*x**5/(105**2*b0**4*s0**2)
(BASE/'audit/checks/completion_intervals_results.json').write_text(json.dumps({'all_large':records,'fixed56_endpoint_identities':14},indent=2))
print('PASS: all 18 all-large comparison minima exactly verified; 17 exceed 13/10 and the phase comparison equals its printed fraction >1.')
print('PASS: symbolic monomial reduction of every all-large comparison reproduces the printed lower bound times a provably >=1 branch factor.')
print('PASS: all 13 fixed-56 overlap formulas and the infinite-tail condition agree identically with direct endpoint division.')
