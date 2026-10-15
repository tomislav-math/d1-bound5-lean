"""Exact, self-contained check of a replacement for HTZ in the bound-five proof.
Investigative output, not a claim that {1,3} has no positive quintuple.
"""
from one_small import *

def least(c,p):
    lo=0;hi=1
    while c*hi**p<=1:hi*=2
    while hi-lo>1:
        mid=(lo+hi)//2
        if c*mid**p>1:hi=mid
        else:lo=mid
    require(c*hi**p>1 and c*(hi-1)**p<=1,'least positive threshold')
    return hi

def cutoff(R,a,b,s):
    na=R.norm(a);nb=R.norm(b);ns=R.norm(s)
    dab=R.norm(R.sub(a,b));das=R.norm(R.sub(a,s));dbs=R.norm(R.sub(b,s))
    q1=ceilroot(F(dab*das*dbs,nb*ns*ns),10)
    K=F(9999,100)*na*(1/q1-mu/nb)**2
    require(1/q1>mu/nb and K>1,'triple gap')
    phi=ceilroot(max(F(dbs**6,ns**6),F(nb*dbs**5,ns**6)),10)
    Rbs=kap*phi
    M2,Mn,M3,M4,M5=fixed_coeff(R,a,b)
    Mbs=fixed_coeff(R,b,s)[1]
    R2,Rn,R3,R4,R5=[old*F(101,200)*F(dab,4*nb)**k for name,k,m,g,old in families]
    Rp=max(adaptive(1/floorroot(F(nb,na),10)))
    cs=[
      ((1-eps)*K**4/(12100*ns**5),5),
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
    thresholds=[least(co,p) for co,p in cs]
    nth=least(K*K/(105**2*nb**4*ns**2),5)
    N0=max(1024,nth,*thresholds,1 if na==1 else 4*na*nb*ns+1)
    return {'K':K,'Mbs':Mbs,'thresholds':thresholds,'ntail':nth,'N0':N0,'quotients':[co*N0**p for co,p in cs]}

if __name__=='__main__':
    R=Ring(1);a=(1,0);b=(3,0);s=(8,0)
    got=cutoff(R,a,b,s)
    print('M (1,3)',fixed_coeff(R,a,b))
    print('S15 for (1,3)',[float(v) if isinstance(v,F) else v for v in s15(R,a,b)[:5]])
    print('FIXED TRIPLE (1,3,8)',{k:float(v) if isinstance(v,F) else v for k,v in got.items() if k!='quotients'})
    print('cutoff minimum quotient',float(min(got['quotients'])))
    ss=[z for z in range(3,15) if all(isqrt(k*z+1)**2==k*z+1 for k in [1,3])]
    print('positive s below15',ss)
    ts=[z for z in range(8,201) if all(isqrt(k*z+1)**2==k*z+1 for k in [1,3,8])]
    print('positive t through200',ts)
    require(ss==[8],'s=8')
    require(ts==[120],'t=120')
    require(120**2>=got['N0'],'finite complement empty')
    print('HTZ-FREE NO-SEXTUPLE FOR {1,3}: EXACT CHECKS PASS')
