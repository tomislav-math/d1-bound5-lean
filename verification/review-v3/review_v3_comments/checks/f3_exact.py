"""Exact controls for reviewer comments 1, 4 and 11; no manuscript edits.

The analytic arguments themselves are supplied in agents/f3_assessment.txt.
This file checks their rational constants, the 24 rearrangement bounds,
and the effect of the reviewer's factor-ten loss on all printed cutoffs.
"""
from fractions import Fraction as F
from hashlib import sha256
from itertools import permutations
from math import isqrt
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'output/D1_bound5-v3.tex'
SHA = 'a1119af75cf623411c678ea0e9b6e7dc9a3f59a931ee67384fc98be8d8373bd5'
assert sha256(SOURCE.read_bytes()).hexdigest() == SHA
text = SOURCE.read_text()
records = []

def check(condition, description, value=None):
    assert condition, description
    records.append({'description': description, 'value': str(value) if value is not None else None})

# (1-w)(1-w^2) = 1-w-w^2+w^3 = (1-w)^2(1+w).
def mul(p, q):
    ans = [0] * (len(p) + len(q) - 1)
    for i, a in enumerate(p):
        for j, b in enumerate(q):
            ans[i+j] += a*b
    return ans
check(mul([1,-1],[1,0,-1]) == mul(mul([1,-1],[1,-1]),[1,1]), 'factor identity')
rho = F(1,4)
check((1-rho)*(1-rho*rho)/16 == F(45,1024), 'f3 lower constant', F(45,1024))
check((1+rho)*(1+rho*rho)/16 == F(85,1024), 'f3 upper constant', F(85,1024))
rho1000 = F(1,1000)
rho1000_bounds = [(1-rho1000)*(1-rho1000**2)/16, (1+rho1000)*(1+rho1000**2)/16]

parameters = []
for H, lam, U in ((32,F(1,10),F(179,10)), (48,F(19,200),F(15))):
    r = F(5,32)*(F(H,H-1)**3-1)
    low, high = F(45,1024)-r, F(85,1024)+r
    check(low > 0, f'H={H}: positive lower bound', low)
    check(100*high/99 < lam, f'H={H}: direct L3 coefficient', 100*high/99)
    check(F(100,201)/high > 5, f'H={H}: lower zero-case coefficient', F(100,201)/high)
    check(F(100,199)/low < U, f'H={H}: upper zero-case coefficient', F(100,199)/low)
    check(U*F(10001,10000) < 18, f'H={H}: nonvanishing margin', 18-U*F(10001,10000))
    parameters.append({'H': H, 'r':str(r),'l':str(low),'u':str(high)})
H = 1000
r = F(5,32)*(F(H,H-1)**3-1)
low, high = F(45,1024)-r, F(85,1024)+r
check(800*high/99 < F(3,4), 'separated-three direct bound', 800*high/99)
check(F(100,201)/high > 5, 'separated-three lower zero-case bound', F(100,201)/high)
check(F(100,199)/low < 15, 'separated-three upper zero-case bound', F(100,199)/low)

# Every determinant monomial has modulus <= B*S^2*T^3.
# Substitute A=u, B=u*v, S=u*v*w, T=u*v*w*z with v,w,z >= 1.
# The exponent of u is always 6; compare suffix sums for v,w,z.
for p in permutations(range(4)):
    powers = (sum(p[1:])-6, sum(p[2:])-5, p[3]-3)
    check(all(e <= 0 for e in powers), 'Vandermonde monomial ' + str(p), powers)

k = F(1,1000)
r4 = F(7,64)*(F(1000,999)**4-1)
l4 = (1-k)**2*(5-6*k-5*k*k)/128-r4
u4 = (1+k)**2*(5+6*k+5*k*k)/128+r4
check(F(24*101,199) < 13, 'elementary24 first L4 coefficient', F(24*101,199))
check(F(2400,99)*u4 < F(49,50), 'elementary24 second L4 coefficient', F(2400,99)*u4)
check(F(100,201)/u4 > 10, 'unchanged L4 lower zero-case coefficient', F(100,201)/u4)
check(F(100,199)/l4 < 17, 'unchanged L4 upper zero-case coefficient', F(100,199)/l4)
k0 = F(3999,4000)
check(F(169,16**6)/k0 < F(1,10000), 'elementary24 first-term square bound', F(169,16**6)/k0)
check(F(99,100)/F(49,50) == F(99,98), 'elementary24 lower bound for Z')
check((F(99,98)**2-1)*1000**2 > 1, 'elementary24 subtraction of one', (F(99,98)**2-1)*1000**2)
check(78*10**40 < 10**100, 'elementary24 Lemma7.3 first term less than one half')
check((F(25,49)**2-F(1,100))*10**200 > 1, 'elementary24 Lemma7.3 unchanged cutoff')

check(F(64*101,199) < 33, 'reviewer64 first L4 coefficient', F(64*101,199))
check(F(6400,99)*u4 < F(13,5), 'reviewer64 second L4 coefficient', F(6400,99)*u4)
check(F(121,81*3**4)/k0 < F(1,49), 'reviewer64 first-term square bound', F(121,81*3**4)/k0)
check((F(30,91)**2-F(1,10))*1000**2 > 1, 'reviewer64 subtraction of one')
check(F(1024*3**10*3999,4000*12100*10) > 1, 'reviewer64 common start-Q quotient still >1', F(1024*3**10*3999,4000*12100*10))

def table(start):
    p = text.index(start)
    return text[p:text.index('\\end{',p)]
pairs = {int(i):(int(d),(int(ax),int(ay)),(int(bx),int(by)),int(na),int(nb))
         for i,d,ax,ay,bx,by,na,nb in re.findall(
             r'(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\', table('0&1&$(0,1)$'))}
rows = [tuple(map(int,v)) for v in re.findall(
    r'(\d+)\s*&\s*(-?\d+)\s*&\s*(-?\d+)\s*&\s*(\d+)\s*&\s*(\d+)\s*&\s*(\d+)\s*\\\\', table('0 & -4 & -2 & 20'))]
check(len(rows) == 56 and len(pairs) == 40, 'all printed row data read')

def sqrt_upper(v):
    L = 10**10
    n = isqrt(v.numerator*L*L//v.denominator)
    return F(n+(n*n*v.denominator != v.numerator*L*L),L)

def threshold(c):
    lo,hi = 0,1
    while c*hi**5 <= 1:
        hi *= 2
    while hi-lo > 1:
        mid = (lo+hi)//2
        if c*mid**5 > 1:
            hi = mid
        else:
            lo = mid
    assert c*hi**5 > 1 and c*(hi-1)**5 <= 1
    return hi

cutoffs = []
for row in rows:
    i,sx,sy,ns,mb,N0 = row
    d,a,b,na,nb = pairs[i]
    t,h = (1,(d+1)//4) if d%4 == 3 else (0,d)
    def norm(x):
        return x[0]**2+t*x[0]*x[1]+h*x[1]**2
    def diff(x,y):
        return x[0]-y[0],x[1]-y[1]
    s = sx,sy
    check(norm(s) == ns, 'norm for row ' + str(row[:3]))
    q = sqrt_upper(F(norm(diff(a,b))*norm(diff(a,s))*norm(diff(b,s)),nb*ns**2))
    K = F(9999,100)*na*(1/q-F(51051,400000*nb))**2
    c = F(3999,4000)*K**4/(12100*ns**5)
    old,new = threshold(c),threshold(c/10)
    check(new <= N0, 'reviewer64 unchanged final N0 for ' + str(row[:3]), new)
    cutoffs.append({'row':row[:3], 'old_start_n':old, 'new_start_n':new, 'printed_N0':N0})
q138 = sqrt_upper(F(4*49*25,9*64**2))
K138 = F(9999,100)*(1/q138-F(51051,400000*9))**2
c138 = F(3999,4000)*K138**4/(12100*64**5)
check((threshold(c138),threshold(c138/10)) == (3,4), 'reviewer64 (1,3,8) start n changes 3 to 4')
check(threshold(c138/10) < 1024, 'reviewer64 (1,3,8) N0 unchanged')

# Independent cross-review of the structure agent's product bound.
first_weighted_row = 3*F(1,18)/F(3,2)
other_weighted_rows = F(1,18)*F(3,2)+2*F(1,64)
check(first_weighted_row == F(1,9), 'product3/2 first weighted row')
check(other_weighted_rows == F(11,96), 'product3/2 remaining weighted rows')
check(max(first_weighted_row,other_weighted_rows) == F(11,96), 'product3/2 norm majorant')
s,h = F(59,96),F(155,96)
det_coefficient = h*s*s*(1+F(3,36)+s/324)
check(det_coefficient == F(18212679025,27518828544), 'product3/2 exact determinant coefficient',det_coefficient)
check(det_coefficient < F(2,3), 'product3/2 determinant margin',F(2,3)-det_coefficient)
check(sha256(SOURCE.read_bytes()).hexdigest() == SHA, 'source unchanged')

result = {'source':str(SOURCE),'sha256':SHA,'status':'PASS','check_count':len(records),
          'scope':'Rational constants and bounded cutoff effects only; analytic proofs are in the companion assessment.',
          'f3_H_parameters':parameters,'f3_rho_1_over_1000_bounds':list(map(str,rho1000_bounds)),
          'four_anchor_u':str(u4),'four_anchor_l':str(l4),
          'reviewer64_cutoffs':cutoffs,'max_new_start_n':max(r['new_start_n'] for r in cutoffs),
          'checks':records}
Path(__file__).with_name('f3_exact_results.json').write_text(json.dumps(result,indent=2)+'\n')
print(f'PASS: {len(records)} exact controls, all 56 printed N0 values unchanged even under factor-ten start loss; optional elementary24 proof preserves every gap and cutoff formula.')
