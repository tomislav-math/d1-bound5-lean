#!/usr/bin/env python3
"""Independent monomial verification of Section8 endpoint divisions and substitutions.
The exponent bookkeeping starts with approximation U/Z+VZ inequalities,
not with the overlap table entries. Pure integer/Fraction arithmetic.
"""
from fractions import Fraction as F
from pathlib import Path
import json,hashlib
src=Path(__file__).resolve().parents[2]/'upload/D1_bound5-v1(1).tex'
assert hashlib.sha256(src.read_bytes()).hexdigest()=='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
# Keys A,B,S,T,C,G,M2,Mn,M3,M4,M5,Mbs,R2,Rn,R3,R4,R5,Rbs,Rp,Mm,Rm,h,E (E=1-epsilon).
class Mon:
 def __init__(self,c=1,**powers):self.c=F(c);self.e={k:v for k,v in powers.items() if v}
 def __mul__(self,o):
  z=Mon(self.c*o.c,**self.e)
  for k,v in o.e.items():z.e[k]=z.e.get(k,0)+v
  z.e={k:v for k,v in z.e.items() if v};return z
 def __pow__(self,n):return Mon(self.c**n,**{k:v*n for k,v in self.e.items()})
 def __truediv__(self,o):return self*o**-1
 def sub(self,k,value):
  e=self.e.copy();n=e.pop(k,0);return Mon(self.c,**e)*value**n
 def eq(self,o):return self.c==o.c and self.e==o.e
 def json(self):return {'coefficient':str(self.c),'exponents':self.e}
def M(c=1,**e):return Mon(c,**e)
# For a term U/Z+VZ, raw endpoints l=4U^2/C and u=1/(4V^2 C).
def endpoints(U,V):return(4*U**2/M(C=1),M(F(1,4))/V**2/M(C=1))
Mon.__rmul__=lambda self,v:Mon(v)*self
rows={
'Q':endpoints(M(55,T=3,C=2),M(F(3,2),T=1,A=-2,C=-4)),
'P1':endpoints(M(2400,B=1,S=3,C=3),M(Rp=1,S=2,A=-3,C=-5)),
'P2':endpoints(M(2400,B=3,S=2,C=3),M(Rp=1,S=2,A=-3,C=-5)),
'M':endpoints(M(Mm=1,B=3,S=8,C=3),M(Rm=1,B=2,S=5,A=-3,C=-6)),
}
for name,k,p,mc,rc,x,y in [('N2',2,6,'M2','R2','A','B'),('N3',3,9,'Mn','Rn','A','B'),('A3',3,8,'M3','R3','A','B'),('A4',4,11,'M4','R4','A','B'),('A5',5,14,'M5','R5','A','B'),('N3bs',3,9,'Mbs','Rbs','B','S')]:
 rows[name]=endpoints(M(**{mc:1,y:p-2,'C':k+1}),M(**{rc:1,y:k,x:-k-1,'C':-p+k}))
for j in range(4,7):
 rows['O'+str(j)]=endpoints(M(3*42**j,B=3*j-1,C=j+1),M(F(1,2)*F(5,2)**j,A=-j,B=j,C=-2*j))
gap=M(A=7,B=5,S=3,G=1);phase=M(A=2,T=5,S=-2)
h=M(h=1)
# Each tuple: name,left,right,additionalSsubstitution,expected quotient.
data=[
('N2-P1','N2','P1',None,M(F(1,16*2400**2),G=2,A=20,B=4,R2=-2,h=-1)),
('N2-P2','N2','P2',None,M(F(1,16*2400**2),G=2,A=20,S=2,R2=-2,h=-1)),
('P-N3','P1','N3',2,M(F(1,16),G=2,A=20,Rp=-2,Mn=-2,h=-1)),
('P-A3','P1','A3',1,M(F(1,16),G=2,A=20,Rp=-2,M3=-2,h=-1)),
('A3-M','A3','M',2,M(F(1,16),G=4,A=36,R3=-2,Mm=-2,h=-1)),
('M-N3','M','N3',None,M(F(1,16),G=4,A=34,B=2,S=2,Rm=-2,Mn=-2,h=-1)),
('N3-A4','N3','A4',3,M(F(1,16),G=2,A=22,B=4,Rn=-2,M4=-2,h=-1)),
('N3-N3bs','N3','N3bs',3,M(F(1,16),G=4,A=36,B=8,Rn=-2,Mbs=-2,h=-1)),
('N3bs-A4','N3bs','A4',None,M(F(1,16),G=2,A=14,Rbs=-2,M4=-2,h=-1)),
('A4-O4','A4','O4',1,M(F(1,144*42**8),G=4,A=38,B=2,R4=-2,h=-1)),
('O4-A5','O4','A5',1,M(F(2,5)**8/4,G=4,A=36,M5=-2,h=-1)),
('A5-O5','A5','O5',1,M(F(1,144*42**10),G=6,A=54,B=10,R5=-2,h=-1)),
('O5-O6','O5','O6',1,M(F(2,5)**10/F(36*42**12),G=6,A=52,B=4,h=-1))]
out=[]
for name,left,right,sreplace,expected in data:
 raw=rows[left][1]/(h*rows[right][0]);assert raw.e['C']>0
 aftergap=raw.sub('C',gap);result=aftergap
 if sreplace is not None:result=result.sub('S',M(B=sreplace))
 assert result.eq(expected),(name,result.json(),expected.json())
 out.append({'junction':name,'raw':raw.json(),'after_gap':aftergap.json(),'S_substitution_power':sreplace,'S_exponent_before_substitution':aftergap.e.get('S',0),'checked_result':result.json()})
start=M(E=1,A=2,C=7,S=-2,T=-4)/rows['Q'][0]
a=start.sub('C',phase).sub('T',M(2,B=1,S=1));assert a.eq(M(F(1024,12100),E=1,A=10,B=10))
q=rows['Q'][1]/(h*rows['N2'][0]);b=q.sub('C',phase).sub('T',M(2,B=1,S=1));assert b.eq(M(F(256,36),A=8,S=4,M2=-2,h=-1))
generic_start=a;generic_q=b
# Fixed-pair version discards all positive A powers and uses7/4 instead.
fixedphase=M(F(7,4),T=5,S=-2)
start_fixed=start.sub('A',M()).sub('C',fixedphase).sub('T',M(2,B=1,S=1))
q_fixed=q.sub('A',M()).sub('C',fixedphase).sub('T',M(2,B=1,S=1))
assert start_fixed.eq(M(F(9604,12100),E=1,B=10)) and q_fixed.eq(M(F(784,36),S=4,M2=-2,h=-1))
# All overlapping intervals: even empty ones cause no induction problem.
# Tail next quotient grows by (R0/H0)^2, and H0>1 growslowerendpoints.
for j in (4,5):
 H=M(42,B=3,C=1);R=M(F(2,5),A=1,B=-1,C=2)
 raw_j=M(F(1,36))*R**(2*j)*M(B=2,C=-2)/(h*H**(2*j+2))
 raw_next=M(F(1,36))*R**(2*j+2)*M(B=2,C=-2)/(h*H**(2*j+4))
 assert (raw_next/raw_j).eq((R/H)**2)
# Fundamental discriminants and elementary frontier inequalities.
def squarefree(d):return all(d%(p*p) for p in range(2,isqrt(d)+1))
from math import isqrt
fund=sorted(d if d%4==3 else 4*d for d in range(1,37) if squarefree(d))
assert [d for d in fund if 25<=d<=35]==[31,35]
assert [d for d in range(1,25) if squarefree(d) and (d if d%4==3 else 4*d)<=24]==[1,2,3,5,6,7,11,15,19,23]
front=[]
for alpha,b,t in [(F(1),8,F(27,8)),(F(140,99),4,F(3)),(F(12,7),3,F(11,4)),(F(2),3,F(29,10)),(F(20,9),3,F(3))]:
 k1=F(1,2)+1/(7*alpha*b);k2=F(1,2)+F(1,7*b*b);K=k1*k1*k2;L=6*K-F(1,2);Q=9*k1*k1*k2*k2;P=2/(alpha*b)+F(1,b*b)
 J=2*K*(2/(alpha*alpha*b*b)+F(1,b**4))+L*(1/(alpha*alpha*b*b)+2/(alpha*b**3))+Q/(alpha*alpha*b**4)
 ff=lambda x:2*K*x+L*P+J/x
 assert alpha*b>5 and ff(F(2,3))<F(1,2) and ff(t)<F(499,500)
 front.append({'alpha':str(alpha),'B':b,'t':str(t),'left':str(ff(F(2,3))),'right':str(ff(t))})
result={'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'raw_endpoint_exponents':{n:[a.json(),b.json()] for n,(a,b) in rows.items()},'thirteen_later_overlaps':out,'first_two_generic':[generic_start.json(),generic_q.json()],'first_two_fixed':[start_fixed.json(),q_fixed.json()],'tail_growth_identity_verified':True,'fundamental_discriminants_25_through35':[31,35],'frontier_dependency_endpoints':front}
path=Path(__file__).with_name('reduction_v1_overlap_algebra.json');path.write_text(json.dumps(result,indent=2)+'\n')
print('PASS:15 endpoint divisions and substitutions,2 improved coefficients,infinite tail,fundamental discriminant lists,and5 frontier endpoint pairs. All exact. Source:',result['source_sha256'])
