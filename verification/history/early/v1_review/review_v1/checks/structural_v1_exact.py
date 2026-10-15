"""Fresh exact checks for Sections 1--3; no imported old audit code.

Run from any directory using Python 3.  Only the standard library is used.
This checks finite arithmetic and certificates, not the surrounding analytic
proofs, which are separately reconstructed in agents/structural.md.
"""
from fractions import Fraction as F
from pathlib import Path
from hashlib import sha256
from itertools import combinations
from math import isqrt
import json

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'upload/D1_bound5-v1(1).tex'
EXPECTED = '74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
assert sha256(SOURCE.read_bytes()).hexdigest() == EXPECTED
checks = []
def ck(name, condition, detail=None):
    assert condition, (name, detail)
    checks.append({'name':name, 'pass':True, 'detail':str(detail) if detail is not None else None})

ck('irregular q(B)', F(10,3)**2+F(4,9)-12 == -F(4,9))
ck('irregular q(2AB)', -1+F(7,9)+F(7,9)**2/4+F(1,81) == -F(19,324))
ck('tail root 1/12', 1-F(1,12) > F(19,20)**2)
ck('tail root 1/3', 1-F(1,3) > F(4,5)**2)
ck('tail root 1/4', 1-F(1,4) > F(6,7)**2)
ck('tail sqrtBC and sqrtB', F(24,7)**2<12 and F(12,7)**2<3)
ck('tail p relative loss', F(35,468)<F(1,13) and F(12,13)>F(24,25)**2)
ck('tail perturbation radius', (1+F(35,117))/F(48,13)==F(19,54)<F(9,25))
q=F(7,13)+F(125,216); r0=F(625,1053)
ck('tail convex endpoint A=1', F(35,108)+q/2+7*r0/48==F(12247,12636)<1)
ck('tail convex endpoint A=B', F(5,27)+7*q/24+r0/4==F(14813,22464)<1)

def squarefree(d):
    return all(d % (j*j) for j in range(2,isqrt(d)+1))
fields=[d for d in range(1,65) if squarefree(d) and (d if d%4==3 else 4*d)<=64]
ck('tail discriminant field list', fields==[1,2,3,5,6,7,10,11,13,14,15,19,23,31,35,39,43,47,51,55,59],fields)
def basis(d): return (1,(d+1)//4) if d%4==3 else (0,d)
def add(x,y): return (x[0]+y[0],x[1]+y[1])
def neg(x): return (-x[0],-x[1])
def scale(n,x): return (n*x[0],n*x[1])
def mult(x,y,d):
    t,h=basis(d)
    return (x[0]*y[0]-h*x[1]*y[1], x[0]*y[1]+x[1]*y[0]+t*x[1]*y[1])
def conj(x,d):
    t,h=basis(d); return (x[0]+t*x[1],-x[1])
def norm(x,d):
    t,h=basis(d); return x[0]**2+t*x[0]*x[1]+h*x[1]**2
def ball(d,L):
    t,h=basis(d); disc=4*h-t*t
    out=[]
    for y in range(-isqrt(4*L//disc),isqrt(4*L//disc)+1):
        lim=isqrt(4*L-disc*y*y)
        for e in range(-lim,lim+1):
            if (e-t*y)%2==0: out.append(((e-t*y)//2,y))
    return out
def canonical(row,d):
    a,b,c,v=row; variants=[]
    for conjugate in (False,True):
        for sign in (1,-1):
            z=tuple(scale(sign,conj(x,d) if conjugate else x) for x in row)
            variants += [z,(z[0],z[2],z[1],z[3])]
    return min(variants)

pairs_count=triples_count=0; candidates=[]; finals=[]; perfield=[]
for d in fields:
    elements=ball(d,15)
    # A root of each target has N(root)=|target|. Store witnesses, including zero.
    roots={mult(v,v,d):v for v in ball(d,70)}
    def compat(a,b): return add(mult(a,b,d),(1,0)) in roots
    large=sorted((x for x in elements if norm(x,d)>=9),key=lambda x:(norm(x,d),x))
    pc=tc=cc=0
    for b,c in combinations(large,2):
        target=add(mult(b,c,d),(1,0))
        if target not in roots: continue
        pc+=1; root=roots[target]
        for v in {add(add(b,c),scale(s,root)) for s in (2,-2)}:
            if v in ((0,0),b,c) or norm(v,d)<norm(c,d): continue
            tc+=1
            for a in elements:
                if a in ((0,0),b,c,v) or norm(a,d)>norm(b,d): continue
                if not compat(a,b) or not compat(a,c): continue
                candidates.append((d,a,b,c,v));cc+=1
                if compat(a,v): finals.append((d,a,b,c,v))
    pairs_count+=pc;triples_count+=tc;perfield.append((d,pc,tc,cc))
classes={(d,canonical(row,d)) for d,*row in candidates}
printed=[(2,(-1,0),(-3,0),(3,0),(0,-4),(1,4)),
 (2,(-1,0),(2,-2),(3,0),(11,-4),(-10,4)),
 (3,(-1,2),(-1,-3),(4,-3),(7,-14),(22,0)),
 (6,(-2,0),(3,-1),(3,1),(14,0),(-27,0)),
 (11,(-1,0),(3,1),(4,-1),(15,0),(-14,0)),
 (35,(-3,0),(2,1),(3,-1),(13,0),(-38,0))]
ck('tail finite raw counts', (pairs_count,triples_count,len(candidates))==(90,118,16),(pairs_count,triples_count,len(candidates)))
ck('tail candidate symmetry classes',classes=={(d,canonical((a,b,c,v),d)) for d,a,b,c,v,target in printed},len(classes))
for d,a,b,c,v,target in printed:
    ck(f'tail printed final target d={d},a={a},b={b}',add(mult(a,v,d),(1,0))==target,target)
ck('tail complete final failures',not finals,finals)
ck('tail first two nonsquare norms',norm((1,4),2)==33 and norm((-10,4),2)==132)

e=F(128,8649);s=F(1,2)+3*e;h=F(3,2)+3*e
ck('product4 root bound',1-F(1,9)>F(15,16)**2)
ck('product4 determinant coefficient',h*s*s*(1+F(3,36)+s/324)<F(1,2),h*s*s*(1+F(3,36)+s/324))
ck('product4 row bounds',F(25,486)<F(1,18) and e<F(1,64))
ck('product4 weighted rows',F(3,18)/F(3,2)==F(1,9) and F(3,2)/18+F(2,64)==F(11,96)<F(1,8))
ck('product4 singular product constants',F(13,8)*F(5,8)**3==F(1625,4096) and F(13,8)*F(5,8)**2==F(325,512))
ck('product4 weak determinant',F(325,512)*(4+F(5,72))==F(95225,36864)<F(8,3))
ck('product5 final-column root bound',1-F(1,54)>F(49,50)**2)
ck('product5 final-column perturbation',F(50,99)**2/108==F(625,264627)<F(1,400))
ck('product5 inverse-vector bound',F(2,3)+F(8,3)*(F(1,200)+F(1,12))==F(203,225)<F(11,12))
ck('product5 paired product perturbation',F(1,2)*(F(1,18)+F(1,64))+F(1,18*64)==F(7,192))
ck('product5 detF bound',F(3,16)+F(3,2)*F(7,192)+9*F(7,192)**2<F(33,128))
ck('product5 p0 bound',F(11,12)*F(201,200)<1)
ck('product5 detG bound',F(33,128)*(1+F(11,54)+F(505,11664)+F(1,2916))<F(1,3))
ck('product5 nonsingularity',F(1,8)+F(67,300)+F(201,200)**2/2916<F(1,2))
ck('frontier k certificate',F(7)-28*F(1,5)-4*F(1,5)**2>0 and (F(1,2)+F(1,35))**2<F(2,7))

def frontier(A,B,t):
    k1=F(1,2)+1/(7*A*B);k2=F(1,2)+1/(7*B*B)
    K=k1*k1*k2;L=6*K-F(1,2);Q=9*k1*k1*k2*k2
    P=2/(A*B)+1/(B*B)
    J=2*K*(2/(A*A*B*B)+1/B**4)+L*(1/(A*A*B*B)+2/(A*B**3))+Q/(A*A*B**4)
    return 2*K*t+L*P+J/t
frontier_values=[]
for A,B,t,n in [(F(1),F(8),F(27,8),1),(F(140,99),F(4),F(3),2),(F(12,7),F(3),F(11,4),3),(F(2),F(3),F(29,10),4),(F(20,9),F(3),F(3),5)]:
    ck(f'frontier lower anchor n={n}',A*A<=n and A*B>5)
    left,right=frontier(A,B,F(2,3)),frontier(A,B,t)
    ck(f'frontier endpoints n={n}',left<F(1,2) and right<F(499,500),(left,right))
    frontier_values.append(right)
ck('frontier printed maximum',max(frontier_values)==F(964921210337222547,967173115740160000))
improvement = {str(t):str(frontier(F(3),F(3),F(t))) for t in (2,3)}
ck('optional all-large factor3',all(frontier(F(3),F(3),F(t))<1 for t in (2,3)),improvement)

def interpolation3(H):
    r=F(5,32)*((F(H,H-1))**3-1)
    return F(45,1024)-r,F(85,1024)+r
for H,lam,U,fraction_left,fraction_right in [(32,F(1,10),F(179,10),F(610119680,120943911),F(122023936,6879629)),(48,F(19,200),F(15),F(2126295040,398301399),F(2126295040,142842001))]:
    ck(f'two anchor coefficient H={H}',F(202,199)<F(21,20) and F(200,99)*(F(25,128)+F(1,4)*(F(H,H-1)**2-1))<F(1,2))
    lo,up=interpolation3(H)
    ck(f'three anchor comparisons H={H}',lo>0 and F(101,199)<F(51,100) and 100*up/99<lam and 100/(201*up)>5 and 100/(199*lo)<U)
    ck(f'three anchor printed fractions H={H}',100/(201*up)==fraction_left and 100/(199*lo)==fraction_right)
ck('strong-two nonvanishing comparison',4*F(4,3)*F(16,15)*F(46,45)<(5-2-F(19,45))**2)
ck('strong-two first term',F(21,20)**2/159<F(1,4))
ck('general-three coefficient',4*F(37,36)*F(36,71)==F(148,71) and F(296,71)<5 and 2*F(36,35)*F(9,8)**3==F(6561,2240)<3)
lo,up=interpolation3(1000)
ck('separated-three comparisons',F(808,199)<5 and 800*up/99<F(3,4) and 100/(201*up)>5 and 100/(199*lo)<15)
ck('four-anchor contradiction boundary',32-1>F(121,4))
k=F(1,1000);r=F(7,64)*(F(1000,999)**4-1)
lo=(1-k)**2*(5-6*k-5*k*k)/128-r
up=(1+k)**2*(5+6*k+5*k*k)/128+r
ck('direct-four comparisons',lo>0 and F(16*101,199)<9 and 1600*up/99<F(4,5) and 100/(201*up)>10 and 100/(199*lo)<17)
h0=F(10001,10000);k=F(3999,4000);mu=F(51051,400000)
ck('retained guard constants',27*32==864 and 486*32>10000 and 9*32>200 and 18**3/h0>1000 and 36>5*h0 and 18>F(179,10)*h0)
ck('retained X0 rounding',h0/k<F(1001,1000)**2)
ck('retained mu',F(51,500)*F(5005,4000)==mu)
strong_coefficient=F(9999,10000)*F(200,19)**2*3**5*(F(1,8)-mu/81)**2
ck('optional all-large coarse coefficient',strong_coefficient==F(16405041495117,40000000000)>400,strong_coefficient)
alpha=10*(F(1,8)-mu/9)
ck('retained alpha lower bound',alpha>1 and F(9999,10000)*alpha**2>1,alpha)
ck('retained subtraction',18**4>10000)
ck('retained fourth first term',1/(9*k*3**4)<F(1,100))
ck('retained fourth subtraction boundary',F(17,64)*3**8*3**8*3**6>1)

result={'source':str(SOURCE.relative_to(ROOT)),'sha256':EXPECTED,'checks':checks,
        'tail_per_field':perfield,'tail_candidates':candidates,'optional_all_large_endpoints':improvement}
out=ROOT/'review_v1/checks/structural_v1_exact.json'
out.write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'sha256':EXPECTED,'checks_passed':len(checks),'tail_counts':[pairs_count,triples_count,len(candidates),len(classes),len(finals)],'all_large_endpoints':improvement},indent=2))
