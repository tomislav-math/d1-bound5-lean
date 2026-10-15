#!/usr/bin/env python3
"""Exact Fraction/integer checks used in the small-entry section audit."""
from fractions import Fraction as F
from math import prod
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]

out=[]
def check(label,condition):
    assert condition,label
    out.append({'claim':label,'verified':True})

check('crossblock denominator > 7/8',1-F(1,9)-F(1,81)-F(1,729)>F(7,8))
check('crossblock 49/324 > 1/7',F(49,324)>F(1,7))
check('four-root determinant constant',4**5*prod(F(1,2)-v for v in range(-1,4))==-1440)
check('four-root 10300 majorant',(8192*(1+F(11,8000)))**2*F(25*1001,16000)<10300**2)
check('four-root 193 majorant',192**2*F(1000,999)**7<193**2)
check('V lower endpoint constant',100/(1-F(1,4000))<101)
check('V upper endpoint constant',4/(9*(1+F(1,4000)))>F(2,5))
check('general-three upper endpoint constant',36*(1+F(1,4000))<37)
check('cutoff h parameter',1134**10<10**31)
check('cutoff r parameter',F(15,2)**10<10**9)
check('cutoff u parameter',2277**5<10**17)
check('cutoff C^5 coefficient',F(2,5)*F(3,8)**5==F(243,81920)>F(1,400))
def f(x):return 7*x+F(212,5)+F(4047,25)/(x-4)
check('cutoff f(8)',f(8)<139)
check('cutoff f(49)',f(49)==389-F(1,375))
check('cutoff crossing at 49',49-F(227,5)-F(4047,25)/45==F(1,375))
check('cutoff crossing at 72',72-F(347,5)-F(4047,25)/68>0)
check('cutoff f(72)',f(72)<549)
check('cutoff f(100)',f(100)<7*100+60)
check('cutoff 259*S^3 < 10^27 when S<10^8',259*10**24<10**27)
check('cutoff bounded-four lower constant',F(512,81)*608**4*3**6<10**15)
check('cutoff bounded-four upper constant',2*28**4*F(10,81)**2*3**4<10**7)
check('descent contraction q>5',28>F(676,25))
check('descent 6+14sqrt(2)<26',14**2*2<20**2)
check('descent at radius 33',F(33,5)+26<33)
check('unit cubic constant',F(16,15)**2*F(81,80)**3<2)
check('unit h parameter',42**100<10**163)
check('unit r parameter',F(5,2)**5<100)
check('unit u parameter',253**100<10**241)
check('unit denominator exponent',2**13<10000)
check('unit contradiction at S=10^4',80-F(717,25)-F(118401,4925)>0)
check('three-small F3 estimate',F(1000,999)**3<4)
check('three-small general contradiction',F(270,1000)+F(27,1000**2)<1)
check('three-small nonzero lower E',F(4,81)-F(1,1000**6)>F(1,100))
check('three-small envelope h',42**2*8**3<10**6)
check('three-small envelope u',253*8<10**4)
check('three-small envelope r',F(2,15)>F(1,100))
check('three-small envelope at R',48+F(224,35)+F(2,5)<60)
check('three-small order-two lower endpoint',F(512,81)*608**4*3**22<10**40)
check('three-small order-two upper endpoint',2*28**4*F(10,81)**2*3**14<10**22)
check('four-fixed lower endpoint',2*10300**2*3**12*85**12<10**38)
check('four-fixed upper endpoint',2*193**2*3**8*85**10<10**29)
check('three-large upper/lower contradiction',10**120>2000*10**60)
check('three-large zero-zero contradiction',10**40>100*405**3)
check('four-fixed nonvanishing bound',10**80>32*3*3*85)
check('four-fixed first summand',F(216750,10**40)<F(1,2))
check('four-fixed lower W',F(1,260100)-F(1,10**240)>F(1,10**6))
check('four-fixed lower W above forbidden endpoint',10**80>10**44)
check('four-fixed intervals overlap',10**80>10**69)
check('four-fixed envelope below forbidden endpoint',10**160>10**82)
(ROOT/'audit/checks/small_constants_results.json').write_text(json.dumps(out,indent=2))
print(f'{len(out)} exact integer/rational inequalities passed.')
