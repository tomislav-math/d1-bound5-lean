#!/usr/bin/env python3
"""Fresh exact Section 6 interval audit and proposed stronger-gap check.
All Fraction calculations; no prior audit imports. Does not edit source.
"""
from pathlib import Path
from fractions import Fraction as F
import json,hashlib
ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'upload/D1_bound5-v1(1).tex'
eps=F(1,4000); h=F(4001,3999); mu=F(51051,400000)
cs=F(9999,10000)*F(200,19)**2
beta=F(3456); kap=F(3535,409600); phase=F(8,5)**4*F(12,5)**6
Mn=4143; M3=2265; M4=166000; M5=26859063
Rn=F(35,32); R3=F(35,16); R4=F(63,8); R5=F(495,64)
Mm=F(8,9)*608**2; Rm=F(3920,81)
checks=0

def check(ok,note):
    global checks
    checks+=1
    if not ok: raise AssertionError(note)

oldgap=32*cs*(1-8*mu/81)**2
check(oldgap==F(5468347165039,1582031250) and oldgap>3456,'original gap')
check(phase>16,'phase small distance')
# Polynomial log derivative: -4/(2-x)+6/(2+x)=(4-10x)/(4-x*x).
check(F(4,1)-10*F(2,5)==0,'phase stationary point')

def original_ratios(K, phase_residual=True):
    A=B=S=F(3)
    output=[
     ('start-Q',1024*A**20*B**10*(1-eps)/12100),
     ('Q-N2',256*A**16*S**4/(36*735**2*h)),
     ('N2-P-BS3',K*K*A**20*B**4/(25*2400**2*h)),
     ('N2-P-B3S2',K*K*A**20*S**2/(25*2400**2*h)),
     ('N2-P0-S4',K*K*A**20*B**4/(4*25*39000**2*h)),
     ('N2-P0-B5',K*K*A**20*B**2/(25*39000**2*h)),
     ('P-N3',K*K*A**20/(16*145**2*Mn**2*h)),
     ('P-A3',K*K*A**20/(16*145**2*M3**2*h)),
     ('P0-A3',K*K*A**20/(16*300**2*M3**2*h)),
     ('A3-M',K**4*A**36/(16*R3**2*Mm**2*h)),
     ('M-N3',K**4*A**34*B**2*S**2/(16*Rm**2*Mn**2*h)),
     ('N3-A4',K*K*A**22*B**4/(16*Rn**2*M4**2*h)),
     ('N3-N3bs',K**4*A**36*B**8/(16*Rn**2*Mn**2*h)),
     ('N3bs-A4',(beta**2/(kap**2*phase**2) if phase_residual else K*K/Rn**2)*A**14/(16*M4**2*h)),
     ('A4-O4',K**4*A**38*B**2/(144*R4**2*42**8*h)),
     ('O4-A5',K**4*A**36/(4*M5**2*F(5,2)**8*h)),
     ('A5-O5',K**6*A**54*B**10/(144*R5**2*42**10*h)),
     ('O5-O6',K**6*A**52*B**4/(36*42**12*F(5,2)**10*h))]
    for name,ratio in output: check(ratio>1,name)
    return output
old=original_ratios(F(54))
check(dict(old)['N3bs-A4']==F(4003515472412109375,3611631944665923584),'printed tight ratio')
check(all(v>F(13,10) for n,v in old if n!='N3bs-A4'),'other original margins')
check(F(54,105)*3**12>1,'original ordinary tail')

# Independent exponent divisions for every original junction.
# Variables A,B,S,T,C; coefficients exclude h until ratios are formed.
def mon(co,A=0,B=0,S=0,T=0,C=0): return F(co),(A,B,S,T,C)
def div(a,b): return a[0]/b[0],tuple(x-y for x,y in zip(a[1],b[1]))
def replace_var(m,at,repl):
    co,ex=m; c,rex=repl; ex=list(ex); power=ex[at]; ex[at]=0
    return co*c**power,tuple(v+power*w for v,w in zip(ex,rex))
def ogap(m,K=54): return replace_var(m,4,mon(K,A=7,B=5,S=3))
def reduce_S(m,p):
    # Replace S by B^p at sign-directed branch, whose required direction is recorded below.
    return replace_var(m,2,mon(1,B=p))
def O(j):
    return mon(36*42**(2*j),B=6*j-2,C=2*j+1),mon(F(2,5)**(2*j),A=2*j,B=-2*j,C=4*j-1)
rows={
'Q':(mon(12100,T=6,C=3),mon(F(1,9),A=4,T=-2,C=7)),
'N2':(mon(4*735**2,B=8,C=5),mon(F(4,25),A=6,B=-4,C=7)),
'P-BS3':(mon(4*2400**2,B=2,S=6,C=5),mon(F(1,4*145**2),A=6,S=-4,C=9)),
'P-B3S2':(mon(4*2400**2,B=6,S=4,C=5),mon(F(1,4*145**2),A=6,S=-4,C=9)),
'P0-S4':(mon(4*39000**2,S=8,C=5),mon(F(1,4*300**2),A=6,B=-4,C=9)),
'P0-B5':(mon(4*39000**2,B=10,C=5),mon(F(1,4*300**2),A=6,B=-4,C=9)),
'A3':(mon(4*M3**2,B=12,C=7),mon(1/(4*R3**2),A=8,B=-6,C=9)),
'M':(mon(4*Mm**2,B=6,S=16,C=5),mon(1/(4*Rm**2),A=6,B=-4,S=-10,C=11)),
'N3':(mon(4*Mn**2,B=14,C=7),mon(1/(4*Rn**2),A=8,B=-6,C=11)),
'N3bs':(mon(4*Mn**2,S=14,C=7),mon(1/(4*Rn**2),B=8,S=-6,C=11)),
'A4':(mon(4*M4**2,B=18,C=9),mon(1/(4*R4**2),A=10,B=-8,C=13)),
'A5':(mon(4*M5**2,B=24,C=11),mon(1/(4*R5**2),A=12,B=-10,C=17)),
'O4':O(4),'O5':O(5),'O6':O(6)}
# Expected reduced exponents A,B,S for the gap-based divisions.
cases=[('N2','P-BS3',None,(20,4,0)),('N2','P-B3S2',None,(20,0,2)),
('N2','P0-S4',1,(20,4,0)),('N2','P0-B5',1,(20,2,0)),
('P-BS3','N3',2,(20,0,0)),('P-BS3','A3',1,(20,0,0)),
('P0-S4','A3',1,(20,0,0)),('A3','M',2,(36,0,0)),
('M','N3',None,(34,2,2)),('N3','A4',3,(22,4,0)),
('N3','N3bs',3,(36,8,0)),('N3bs','A4',None,(14,0,0)),
('A4','O4',1,(38,2,0)),('O4','A5',1,(36,0,0)),
('A5','O5',1,(54,10,0)),('O5','O6',1,(52,4,0))]
for left,right,p,expected in cases:
    rat=ogap(div(rows[left][1],rows[right][0]))
    if p is not None: rat=reduce_S(rat,p)
    check(rat[1]==expected+(0,0),f'exponent reduction {left}-{right}')
    if (left,right)!=('N3bs','A4'):
        numerical=rat[0]*F(3)**sum(rat[1])/h
        if (left,right)==('N2','P0-S4'): numerical/=4
        alias={('P-BS3','N3'):'P-N3',('P-BS3','A3'):'P-A3',('P0-S4','A3'):'P0-A3'}
        name=alias.get((left,right),left+'-'+right)
        check(numerical==dict(old)[name],f'exact derived original coefficient {name}')

# The S<2B coefficient 1/4 in N2->P0-S4 is accounted in original_ratios.

# Proposed simplification: establish T>3ABS from the existing determinant inequality.
k=F(65,126); K1=k**3; L1=6*K1-F(1,2); Q1=9*k**4
P0=F(1,3)
J0=2*K1*F(3,81)+L1*F(3,81)+Q1/F(729)
def determinant_bound(t): return 2*K1*t+L1*P0+J0/t
check(determinant_bound(F(2))==F(27298839409,40831674912),'new F2')
check(determinant_bound(F(3))==F(57530072833,61247512368),'new F3')
check(determinant_bound(F(2))<1 and determinant_bound(F(3))<1 and J0>0,'convexity endpoints')
# Q<=8 and A2B2>=81, directly after T>3ABS.
newgap=3**5*cs*(F(1,8)-mu/81)**2
check(newgap>400,'new K=400')
new=original_ratios(F(400),False)
newcritical=dict(new)['N3bs-A4']
required_K_squared=16*Rn**2*M4**2*h/F(3**14)
check(332**2<required_K_squared<333**2,'new critical K range')
check(newcritical>F(7,5),'new critical margin >1.4')
check(F(400,105)*3**12>1,'new ordinary tail')
out={'source_sha256':hashlib.sha256(SRC.read_bytes()).hexdigest(),'checks':checks,
 'original_ratios':{k:str(v) for k,v in old},
 'original_minimum':str(min(v for _,v in old)),
 'proposed':{'F2':str(determinant_bound(F(2))),'F3':str(determinant_bound(F(3))),
 'gap_coefficient':str(newgap),'K':400,'uniform_Rbs':str(Rn),'critical_K_squared':str(required_K_squared),
 'ratios':{k:str(v) for k,v in new},'minimum':str(min(v for _,v in new))}}
(ROOT/'review_v1/checks/completion_v1_all_large_results.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({'status':'PASS','checks':checks,'original_minimum':out['original_minimum'],'new_gap':str(newgap),'new_minimum':out['proposed']['minimum']},indent=2))
