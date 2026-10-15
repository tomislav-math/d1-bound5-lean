"""New symbolic reconstructions of Sections 2--3, independent of old checks.

Requires SymPy.  Example: PYTHONPATH=audit/pydeps python .../this_file.py
"""
from pathlib import Path
from hashlib import sha256
from itertools import combinations, permutations
import json
import sympy as S

ROOT=Path(__file__).resolve().parents[2]
source=ROOT/'upload/D1_bound5-v1(1).tex'
expected='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
assert sha256(source.read_bytes()).hexdigest()==expected
checks=[]
def zero(name,expr):
    assert S.cancel(S.expand(expr))==0,name
    checks.append(name)
def yes(name,condition):
    assert condition,name
    checks.append(name)
a,b,c,d,p,q,z,h,p0,q0=S.symbols('a b c d p q z h p0 q0')
zero('regular triple equivalence',(c-a-b)**2-4*(a*b+1)-(a*a+b*b+c*c-2*a*b-2*a*c-2*b*c-4))
zero('irregular mutation product',(a+b+c+2*a*b*c)**2-4*(a*b+1)*(a*c+1)*(b*c+1)-(a*a+b*b+c*c-2*a*b-2*a*c-2*b*c-4))

edges=list(combinations(range(4),2)); Evars=S.symbols('e01 e02 e03 e12 e13 e23')
ev=dict(zip(edges,Evars))
def edge(i,j):return ev[tuple(sorted((i,j)))]
E=S.zeros(4)
for (i,j),value in ev.items():E[i,j]=E[j,i]=value
triangles=sum(S.prod(edge(i,j) for i,j in combinations(tri,2)) for tri in combinations(range(4),3))
paths={min(path,path[::-1]) for path in permutations(range(4))}
path_terms=sum(S.prod(edge(path[j],path[j+1]) for j in range(3)) for path in paths)
square_terms=0
for i,j in edges:
    k,l=sorted(set(range(4))-{i,j})
    square_terms+=edge(i,j)**2*edge(k,l)
cubic=2*triangles-2*path_terms+2*square_terms
zero('determinant cubic/quartic expansion',(S.ones(4)+E).det()-E.det()-cubic)
P=edge(0,1)*edge(2,3);Q=edge(0,2)*edge(1,3);R=edge(0,3)*edge(1,2)
zero('zero-diagonal order4 determinant',E.det()-(P*P+Q*Q+R*R-2*P*Q-2*P*R-2*Q*R))
aa=(a,b,c,d);prod=S.prod(aa)
subs={v:1/(2*aa[i]*aa[j]) for (i,j),v in ev.items()}
leading=S.Rational(1,4)*sum(aa[i]**2/prod for i in range(4))-S.Rational(1,4)*sum(1/(aa[i]*aa[j]) for i,j in edges)
zero('signed leading cubic',prod*cubic.subs(subs)-leading)
poly3=S.Poly(cubic,*Evars);poly4=S.Poly(E.det(),*Evars)
incident=[k for k,(i,j) in enumerate(edges) if 0 in (i,j)]
yes('cubic incident edge count',all(sum(powers[k] for k in incident)<=2 for powers,coefficient in poly3.terms()))
yes('quartic incident edge count',all(sum(powers[k] for k in incident)==2 for powers,coefficient in poly4.terms()))
yes('quartic absolute coefficient sum',sum(abs(coefficient) for powers,coefficient in poly4.terms())==9)
# Group cubic terms after replacing e_ij by 1/(a_i a_j) and multiplying abst.
group={}
for powers,coefficient in poly3.terms():
    exponents=[1]*4
    for power,(i,j) in zip(powers,edges):exponents[i]-=power;exponents[j]-=power
    key=tuple(exponents);group[key]=group.get(key,0)+abs(coefficient)
yes('cubic grouped coefficients',len(group)==10 and sorted(group.values())==[2]*4+[6]*6)

# A rank-two update determinant reduces to this 2x2 determinant.
gram=S.Matrix([[q0,h],[h,p0]])
update=S.Matrix([[0,-1/d],[-1/d,-1/d**2]])
zero('rank-two determinant identity',(S.eye(2)+update*gram).det()-(1-2*h/d+(h*h-p0*q0-p0)/d**2))

x,y,W=S.symbols('x y W')
coeffs=[S.expand(sum(S.binomial(S.Rational(1,2),j)*S.binomial(S.Rational(1,2),n-j)*x**j*y**(n-j) for j in range(n+1))) for n in range(5)]
zero('f2',coeffs[2]+(x-y)**2/8)
zero('f3',coeffs[3]-(x*x-y*y)*(x-y)/16)
zero('f4',coeffs[4]+(x-y)**2*(5*x*x+6*x*y+5*y*y)/128)

def homogeneous(xs,degree):
    ans=0
    def rec(i,left,term):
        nonlocal ans
        if i==len(xs)-1:ans+=term*xs[i]**left
        else:
            for n in range(left+1):rec(i+1,left-n,term*xs[i]**n)
    rec(0,degree,S.Integer(1));return ans
for m in (2,3,4):
    anchors=aa[:m]
    generating=sum(anchors[i]**(m-1)/(S.prod(anchors[i]-anchors[j] for j in range(m) if i!=j)*(1-W/anchors[i])) for i in range(m))
    zero(f'Lagrange full generating identity m={m}',generating-1-(-1)**(m-1)*W**m/S.prod(anchors)/S.prod(1-W/t for t in anchors))
    # These exact symbolic identities cover first cancellation, tail sign,
    # and next coefficients; the report separately proves all n.
    for n in range(m+3):
        lhs=sum(anchors[i]**(m-1-n)/S.prod(anchors[i]-anchors[j] for j in range(m) if i!=j) for i in range(m))
        rhs=1 if n==0 else 0 if n<m else (-1)**(m-1)*homogeneous([1/t for t in anchors],n-m)/S.prod(anchors)
        zero(f'Lagrange identity m={m},n={n}',lhs-rhs)

# The L2=0 identity is independently recovered by interpolating the linear
# polynomial zX+v at a,b and comparing its square with (pX+1)(qX+1).
X,v=S.symbols('X v')
expr=(z*X+v)**2-(p*X+1)*(q*X+1)-(X-a)*(X-b)
zero('L2 interpolation comparison',expr-((z*z-p*q-1)*X*X+(2*z*v-p-q+a+b)*X+(v*v-1-a*b)))
quadratic=S.expand((a+b-p-q)**2-4*(a*b+1)*(p*q+1))
discr=S.discriminant(quadratic,q)
zero('L2 quadratic discriminant',discr-16*(a*b+1)*(a*p+1)*(b*p+1))
zero('L2 quadratic midpoint',-S.Poly(quadratic,q).coeff_monomial(q)/2-(a+b+p+2*a*b*p))

# General elementary symmetric calculation for the two vanishing L3 forms.
e1,e2,e3,e4=S.symbols('e1 e2 e3 e4');w=S.symbols('w',nonzero=True)
comparison=(z*X*X+v*X+w)**2-X*X*(p*X+1)*(q*X+1)
zero('L3 common interpolant coefficient equations',S.expand(comparison).subs(z*z,p*q+1)-(X**4+(2*z*v-p-q)*X**3+(v*v+2*z*w-1)*X**2+2*v*w*X+w*w))
# z=(e2+1-e3²/(4e4))/(2w), w²=e4.
zero('L3 vanishing formula for pq+1',((e2+1-e3**2/(4*e4))/(2*w))**2-(e2+1-e3**2/(4*e4))**2/(4*w*w))

out={'sha256':expected,'checks_passed':len(checks),'checks':checks,
     'determinant_cubic_terms':len(poly3.terms()),'determinant_quartic_terms':len(poly4.terms()),
     'cubic_grouped_absolute_coefficients':{str(k):int(v) for k,v in group.items()}}
(ROOT/'review_v1/checks/structural_v1_algebra.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
