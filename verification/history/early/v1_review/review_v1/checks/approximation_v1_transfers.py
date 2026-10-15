#!/usr/bin/env python3
"""Independent exact checks of approximation-to-height conversions used later."""
from fractions import Fraction as F
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parents[2];SOURCE=ROOT/'upload/D1_bound5-v1(1).tex';SHA='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==SHA
checks=[]
def ck(name,c,detail=None):
 assert c,(name,detail)
 checks.append({'name':name,'passed':True,**({'detail':detail} if detail is not None else {})})
def envelope(h,r,u):
 t=h-r;beta=4*u+8*h-4*r;gamma=2*u*r+beta*t
 return t,beta,gamma
ck('uniform envelope exact parameters',envelope(F(31,10),F(-9,10),F(17,5))==(4,F(42),F(4047,25)))
ck('small triple envelope exact parameters',envelope(F(3),F(-2),F(4))==(5,F(48),F(224)))
ck('unit pair envelope exact parameters',envelope(F(163,100),F(-2,5),F(241,100))==(F(203,100),F(607,25),F(118401,2500)))
# Integer power comparisons establish all quoted logarithmic parameter bounds.
for name,left,right in [('1134',1134**10,10**31),('15/2',15**10,2**10*10**9),('2277',2277**5,10**17),('42',42**100,10**163),('5/2',5**5,2**5*10**2),('253',253**100,10**241),('small H',42**2*8**3,10**6),('small u',253*8,10**4)]:ck('log parameter '+name,left<right)
def g(x):return 7*x+F(212,5)+F(4047,25)/(x-4)
ck('g(8)<139',g(8)<139);ck('g(49) exact',g(49)==389-F(1,375));ck('g(72)<549',g(72)<549)
ck('49 difference exact',49-F(227,5)-F(4047,25)/45==F(1,375))
ck('72 difference positive',72-F(347,5)-F(4047,25)/68>0)
ck('bounded C envelope 60',F(212,5)+F(4047,25)/96<60)
ck('small triple envelope 60',48+F(224,35)+F(2,5)<60)
ck('unit cubic comparison at 4',80-F(717,25)-F(118401,4925)>0)
# Coarse and epsilon conversion coefficients independently expanded.
M=F(8,9)*608**2;V=F(3920,81)
ck('ordinary-three lower coefficient',8*M*M==F(512,81)*608**4)
ck('ordinary-three upper coefficient',8*V*V==2*28**4*F(10,81)**2)
for name,left,right in [('four root U',(8192*F(8011,8000))**2*F(25*1001,16000),10300**2),('four root V',192**2*F(1000,999)**7,193**2),('bounded three lower',F(512,81)*608**4*3**6,10**15),('bounded three upper',2*28**4*F(10,81)**2*3**4,10**7),('small triple lower',F(512,81)*608**4*3**22,10**40),('small triple upper',2*28**4*F(10,81)**2*3**14,10**22),('small fourth lower',2*10300**2*3**12*85**12,10**38),('small fourth upper',2*193**2*3**8*85**10,10**29)]:ck(name,left<right)
# Epsilon closed endpoints are exact algebra, including equality cases.
eps=F(1,4000)
for U,V,C in [(F(3),F(7),F(11)),(F(608**2*8,9),F(3920,81),F(1000))]:
 low=4*U**2/(C*(1-eps));high=1/(4*V**2*C*(1+eps))
 ck('lower endpoint makes U/Z at most 1/2',C*(1-eps)*low==4*U**2)
 ck('upper endpoint makes VZ at most 1/2',V**2*C*(1+eps)*high==F(1,4))
# Correct contour numerator jump: for integer k, upper/lower values are
# (+i)(-1)^k t^(k+1/2) and (-i)(-1)^k t^(k+1/2).
for k in range(1,6):
 upper=(0,(-1)**k);lower=(0,-upper[1])
 ck(f'branch jump k={k}',sum(x*x for x in upper)==sum(x*x for x in lower)==1 and sum((x-y)**2 for x,y in zip(upper,lower))==4)
(ROOT/'review_v1/checks/approximation_v1_transfers_results.json').write_text(json.dumps({'source_sha256':SHA,'checks':checks,'check_count':len(checks)},indent=2)+'\n')
print('PASS',len(checks),'height-transfer checks')
