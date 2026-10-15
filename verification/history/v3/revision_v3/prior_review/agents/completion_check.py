"""Fresh bounded checks for the read-only Armstrong completion review.

Does not import prior audit code/results or regenerate large extension graphs.
Run from the project root. All assertions use integers/Fraction.
"""
from pathlib import Path
from fractions import Fraction as F
from math import isqrt
import hashlib
import json
import re

SOURCE = Path('armstrong_v2/input/D1_bound5-v2.tex')
SHA = '5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70'
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest() == SHA
src = SOURCE.read_text()

def table(start):
    p = src.index(start)
    return src[p:src.index('\\end{', p)]

pt = table('0&1&$(0,1)$')
pairs = {int(i): (int(d), (int(ax), int(ay)), (int(bx), int(by)), int(na), int(nb))
         for i,d,ax,ay,bx,by,na,nb in re.findall(
             r'(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\', pt)}
rows = [tuple(map(int, v)) for v in re.findall(
    r'(\d+)\s*&\s*(-?\d+)\s*&\s*(-?\d+)\s*&\s*(\d+)\s*&\s*(\d+)\s*&\s*(\d+)\s*\\\\',
    table('0 & -4 & -2 & 20'))]
assert len(pairs) == 40 and len(rows) == 56

def ring(d):
    t,u = (1,(d+1)//4) if d%4 == 3 else (0,d)
    def add(a,b): return a[0]+b[0], a[1]+b[1]
    def mul(a,b):
        x,y = a; v,w = b
        return x*v-u*y*w, x*w+y*v+t*y*w
    def norm(a):
        x,y = a
        return x*x+t*x*y+u*y*y
    def conj(a): return a[0]+t*a[1], -a[1]
    def elements(L):
        D = 4*u-t*t
        for y in range(-isqrt(4*L//D), isqrt(4*L//D)+1):
            E = isqrt(4*L-D*y*y)
            for e in range(-E,E+1):
                if (e-t*y)%2 == 0:
                    yield (e-t*y)//2,y
    def canon(a,b):
        orbit = []
        for aa,bb in ((a,b),(conj(a),conj(b))):
            for sg in (1,-1):
                a2 = tuple(sg*x for x in aa); b2 = tuple(sg*x for x in bb)
                x,y = a2; v,w = b2
                key = (2*x+t*y<0,y<0,2*v+t*w<0,w<0,x,y,v,w)
                orbit.append((key,a2,b2))
        _,a2,b2 = min(orbit)
        return a2,b2
    return add,mul,norm,conj,elements,canon

counts = []; found = set(); third = set()
for d in (1,2,3,5,6,7,11,15,19,23):
    add,mul,norm,conj,els,canon = ring(d)
    allpairs = set()
    for a in els(2):
        na = norm(a)
        if na not in (1,2): continue
        for r in els(8):
            r2 = mul(r,r); num = mul(conj(a),(r2[0]-1,r2[1]))
            if any(v%na for v in num): continue
            b = tuple(v//na for v in num); nb = norm(b)
            if not 9 <= nb <= (63 if na == 1 else 15): continue
            if (a,b) in (((1,0),(3,0)),((-1,0),(-3,0))): continue
            allpairs.add((a,b))
    canonical = {canon(a,b) for a,b in allpairs}
    counts.append((d,len(canonical),len(allpairs)))
    found |= {(d,a,b) for a,b in canonical}
    # Root-first square test, independent of the manuscript's p,q equations.
    # |bs+1| <= sqrt(63*224)+1 < 121, and the as bound is smaller.
    squares = {mul(r,r) for r in els(121)}
    for i,(dd,a,b,na,nb) in pairs.items():
        if dd != d: continue
        for s in els(224):
            if norm(s) < nb or s in (a,b): continue
            if add(mul(a,s),(1,0)) in squares and add(mul(b,s),(1,0)) in squares:
                third.add((i,s))
assert found == {(d,a,b) for d,a,b,_,_ in pairs.values()}
assert len(third) == 57 and (7,(3,0)) in third
third.remove((7,(3,0)))
assert third == {(i,(sx,sy)) for i,sx,sy,_,_,_ in rows}

def sqrt_bounds(v):
    v = F(v); L = 10**10
    n = isqrt(v.numerator*L*L//v.denominator)
    return F(n,L), F(n if n*n*v.denominator == v.numerator*L*L else n+1,L)

parts = [[],[],[]]; ends = []
for row in rows:
    i,sx,sy,ns,mb,N0 = row; d,a,b,na,nb = pairs[i]
    add,mul,norm,conj,els,canon = ring(d); s = (sx,sy)
    assert norm(s) == ns
    if 4*nb*ns >= N0:
        parts[0].append(row); continue
    q = add(b,s); bs = mul(b,s); h = (1+2*bs[0],2*bs[1])
    diff = (b[0]-s[0],b[1]-s[1]); delta = mul(diff,diff)
    delta = (delta[0]-4,delta[1])
    hl,_ = sqrt_bounds(norm(h)); _,qu = sqrt_bounds(norm(q))
    _,du = sqrt_bounds(norm(delta)); xl,_ = sqrt_bounds(N0)
    upper = N0-2*(hl-qu)*xl+du+2*qu+1
    if hl-qu > 0 and upper < -100:
        parts[1].append(row); ends.append(upper)
    else:
        parts[2].append(row)
        assert i == 7 and (sx,abs(sy)) == (-2,2) and N0 == 1024
        assert (norm(q),norm(h),norm(delta)) == (33,457,153)
assert tuple(map(len,parts)) == (38,16,2)
assert F(901)-60*F(213,10)+62*F(29,5)+F(62,5) == -5
assert {(u*u+2*v*v)%16 for u in range(16) for v in range(16)} == {0,1,2,3,4,6,8,9,11,12}
assert all(u%4 == 0 and v%4 == 0 for u in range(16) for v in range(16) if (u*u+2*v*v)%16 == 0)
assert {(u,v) for u in range(-6,7) for v in range(-4,5) if u*u+2*v*v == 32} == {(0,4),(0,-4)}

regional = [line.removesuffix('\\\\').split('&') for line in table('1&8&1&1&27/8&8&269&7495').strip().splitlines()]
coeffs = [list(map(F,line.removesuffix('\\\\').split('&')[1:])) for line in table('1&36&282&145&4605&38390&1.260').strip().splitlines()]
e = F(1,4000); h = F(4001,3999); mu = F(51051,400000)
kappa = F(3535,409600); Mm = F(8,9)*608**2; Rm = F(3920,81)
regional_results = []
for reg,(M2,Mn,M3,M4,M5,margin) in zip(regional,coeffs):
    label = reg[0]; m,n,U,t,q,Fp,G,rho,Rp = map(F,reg[1:])
    assert q == m/U and U*U >= n and t*n*m*m >= 54
    lo = F(0); hi = F(2)
    for _ in range(30):
        x = (lo+hi)/2
        if 5*x*x/q+4*(1+q**-2)*x-4/q < 0: lo = x
        else: hi = x
    assert (4-lo*lo)**4*(1+q**-2+hi/q)**2 < Fp
    Q0 = 2*(1+1/q)**2
    H = F(9999,10000)*F(200,19)**2*t**5*(1-mu*Q0/m**2)**2
    assert H/Q0**2 > G and H/(kappa*Fp) > rho
    x = 1/q; ta = F(21,1024*999)
    residuals = [
        (5*x+10*x*x+10*x**4+5*x**5)/256+ta*(295*x+143*x*x+143*x**4+295*x**5),
        10*(x+x**4+x**5)/256+ta*590*(x+x**4+x**5),
        (15+80*x+150*x*x+120*x**3+35*x**4)/256+ta*(885+1144*x+435*x*x+42*x**3+170*x**4),
        (15+80*x+150*x*x+280*x**3+35*x**4)/256+ta*(885+1144*x+435*x*x+2634*x**3+170*x**4)]
    assert max(residuals) < Rp
    R2,Rn,R3,R4,R5 = [R*F(101,200)*((1+1/q)/2)**(2*k) for R,k in
        [(F(5,4),2),(F(35,32),3),(F(35,16),3),(F(63,8),4),(F(495,64),5)]]
    qs = [1024*n**5*m**10*(1-e)/12100, 256*n**4*m**4/(36*M2**2*h),
          G**2*n**10*m**4/(16*R2**2*2400**2*h), G**2*n**10*m**2/(16*R2**2*2400**2*h),
          G**2*n**10/(16*Rp**2*Mn**2*h), G**2*n**10/(16*Rp**2*M3**2*h),
          G**4*n**18/(16*R3**2*Mm**2*h), G**4*n**17*m**4/(16*Rm**2*Mn**2*h),
          G**2*n**11*m**4/(16*Rn**2*M4**2*h), G**4*n**18*m**8/(16*Rn**2*4143**2*h),
          rho**2*n**7/(16*M4**2*h), G**4*n**19*m**2/(144*R4**2*42**8*h),
          G**4*n**18/(4*M5**2*F(5,2)**8*h), G**6*n**27*m**10/(144*R5**2*42**10*h),
          G**6*n**26*m**4/(36*42**12*F(5,2)**10*h)]
    assert min(qs) > margin and (G/105)*n**4*m**4 > 1
    regional_results.append({'region':label,'minimum':str(min(qs)), 'printed_margin':str(margin), 'minimum_junction':qs.index(min(qs))+1})

result = {'source':str(SOURCE), 'sha256':SHA, 'status':'PASS',
          'limits':'Uses printed M coefficients and N0 cutoffs as inputs. Does not regenerate finite-family polynomials or large extension graphs.',
          'pair_counts':counts,'third_count_before_exception':57,'listed_triples':56,
          'complement_partition':list(map(len,parts)), 'largest_quadratic_upper':str(max(ends)),
          'two_exception_rows':parts[2], 'regional_checks':regional_results,
          'rational_third_entries':[s for s in range(4,15) if isqrt(s+1)**2 == s+1 and isqrt(3*s+1)**2 == 3*s+1]}
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest() == SHA
Path('armstrong_v2/agents/completion_check.json').write_text(json.dumps(result,indent=2)+'\n')
print('PASS: 40 pairs, 57 third entries, 56 listed triples, 38/16/2 complement, and all five regional phase/gap/residual/overlap/tail checks.')
