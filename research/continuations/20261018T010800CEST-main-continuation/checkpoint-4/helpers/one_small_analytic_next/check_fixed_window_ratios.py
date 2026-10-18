"""Exact symbolic Laurent-monomial audit of the fixed endpoint joins.
No numerical sampling, floating arithmetic, or CAS dependency is used.
"""
from fractions import Fraction as F
from dataclasses import dataclass

@dataclass(frozen=True)
class Monomial:
    coefficient: F
    exponents: tuple
    @staticmethod
    def scalar(x): return Monomial(F(x), ())
    @staticmethod
    def var(x): return Monomial(F(1), ((x,1),))
    def __mul__(self,other):
        if not isinstance(other,Monomial): other=Monomial.scalar(other)
        d=dict(self.exponents)
        for x,n in other.exponents: d[x]=d.get(x,0)+n
        return Monomial(self.coefficient*other.coefficient,tuple(sorted((x,n) for x,n in d.items() if n)))
    __rmul__=__mul__
    def __pow__(self,n):return Monomial(self.coefficient**n,tuple((x,k*n) for x,k in self.exponents if k*n))
    def __truediv__(self,other):
        if not isinstance(other,Monomial):other=Monomial.scalar(other)
        return self*other**(-1)
    def substitute(self,x,v):
        d=dict(self.exponents);n=d.pop(x,0)
        return Monomial(self.coefficient,tuple(sorted(d.items())))*v**n

names='B S T C K M2 Mn M3 M4 M5 Mbs R2 Rn R3 R4 R5 Rbs Rp'
B,S,T,C,K,M2,Mn,M3,M4,M5,Mbs,R2,Rn,R3,R4,R5,Rbs,Rp=map(Monomial.var,names.split())
e=F(1,4000);h=(1+e)/(1-e);mm=F(8,9)*608**2;rm=F(3920,81)
LQ=4*55**2*T**6*C**3/(1-e);UQ=C**7/(9*T**2*(1+e))
LN2=4*M2**2*B**8*C**5/(1-e);UN2=C**7/(4*R2**2*B**4*(1+e))
LP1=4*2400**2*B**2*S**6*C**5/(1-e);LP2=4*2400**2*B**6*S**4*C**5/(1-e);UP=C**9/(4*Rp**2*S**4*(1+e))
LA3=4*M3**2*B**12*C**7/(1-e);UA3=C**9/(4*R3**2*B**6*(1+e))
LM=4*mm**2*B**6*S**16*C**5/(1-e);UM=C**11/(4*rm**2*B**4*S**10*(1+e))
LN3=4*Mn**2*B**14*C**7/(1-e);UN3=C**11/(4*Rn**2*B**6*(1+e))
LBS=4*Mbs**2*S**14*C**7/(1-e);UBS=B**8*C**11/(4*Rbs**2*S**6*(1+e))
LA4=4*M4**2*B**18*C**9/(1-e);UA4=C**13/(4*R4**2*B**8*(1+e))
LA5=4*M5**2*B**24*C**11/(1-e);UA5=C**17/(4*R5**2*B**10*(1+e))
OL=lambda k:36*(42*B**3*C)**(2*k)*C/(B**2*(1-e))
OU=lambda k:(2*C**2/(5*B))**(2*k)/(C*(1+e))
ratios=[(C**7/(S**2*T**4))/LQ,UQ/LN2,UN2/LP1,UN2/LP2,UP/LA3,UA3/LM,UM/LN3,UN3/LBS,UBS/LA4,UA4/OL(4),OU(4)/LA5,UA5/OL(5),OU(5)/OL(6)]
expected=[(1-e)*K**4*T**10/(12100*S**10),K**2*T**8/(36*M2**2*B**8*S**4*h),K**2*T**10/(16*R2**2*2400**2*B**6*S**10*h),K**2*T**10/(16*R2**2*2400**2*B**10*S**8*h),K**2*T**10/(16*Rp**2*M3**2*B**12*S**8*h),K**4*T**20/(16*R3**2*mm**2*B**12*S**24*h),K**4*T**20/(16*rm**2*Mn**2*B**18*S**18*h),K**4*T**20/(16*Rn**2*Mbs**2*B**6*S**22*h),K**2*T**10/(16*Rbs**2*M4**2*B**10*S**10*h),K**4*T**20/(144*R4**2*42**8*B**30*S**8*h),F(2,5)**8*K**4*T**20/(4*M5**2*B**32*S**8*h),K**6*T**30/(144*R5**2*42**10*B**38*S**12*h),F(2,5)**10*K**6*T**30/(36*42**12*B**44*S**12*h)]
for i,(ratio,certificate) in enumerate(zip(ratios,expected)):
    assert ratio.substitute('C',K*T**5/S**2)==certificate,(i,ratio,certificate)
rate=(2*C**2/(5*B))/(42*B**3*C)
assert rate.substitute('C',K*T**5/S**2)**2==K**2*T**10/(105**2*B**8*S**4)
print('PASS: all13 fixed window ratios and squared ordinary-tail rate match exactly as symbolic Laurent monomials.')
