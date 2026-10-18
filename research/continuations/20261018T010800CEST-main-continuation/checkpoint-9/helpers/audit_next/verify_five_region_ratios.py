"""Independent diagnostic: parse literal Lean coefficients, verify decompositions,
and check all 75 row-wise rational comparisons. This is not a kernel proof."""
from pathlib import Path
from fractions import Fraction as Q
import ast, hashlib, json, re
from collections import defaultdict
ROOT=Path(__file__).resolve().parents[1]
ratios=[Q(1,8),Q(3,8),Q(7,12),Q(2,3),Q(17,18)]
class Poly:
    def __init__(self,d):self.d={m:v for m,v in d.items() if v}
    @staticmethod
    def cast(v):return v if isinstance(v,Poly) else Poly({(0,0,0):v})
    def __add__(self,b):
        b=Poly.cast(b);d=defaultdict(int,self.d)
        for m,v in b.d.items():d[m]+=v
        return Poly(d)
    __radd__=__add__
    def __neg__(self):return Poly({m:-v for m,v in self.d.items()})
    def __sub__(self,b):return self+-Poly.cast(b)
    def __mul__(self,b):
        b=Poly.cast(b);d=defaultdict(int)
        for m,v in self.d.items():
            for n,w in b.d.items():d[tuple(u+t for u,t in zip(m,n))]+=v*w
        return Poly(d)
    __rmul__=__mul__
    def __pow__(self,k):
        assert isinstance(k,int) and k>=0
        q=Poly.cast(1)
        for _ in range(k):q=q*self
        return q
x,y,c=[Poly({tuple(int(i==j) for i in range(3)):1}) for j in range(3)]

def body(text,name):
    start=re.search(r'\bdef '+name+r'\b[^\n]*:=',text).end()
    start=text.index('![',start)+1
    depth=0
    for p in range(start,len(text)):
        if text[p]=='[': depth+=1
        elif text[p]==']':
            depth-=1
            if depth==0:return text[start:p+1]
    raise ValueError(name)

def expr(text):
    assert re.fullmatch(r'[0-9xyc+*^()\s\-]+',text),text
    def visit(t):
        if isinstance(t,ast.Constant) and isinstance(t.value,int):return t.value
        if isinstance(t,ast.Name):return {'x':x,'y':y,'c':c}[t.id]
        if isinstance(t,ast.UnaryOp) and isinstance(t.op,ast.USub):return -visit(t.operand)
        if isinstance(t,ast.BinOp):
            a,b=visit(t.left),visit(t.right)
            if isinstance(t.op,ast.Add):return a+b
            if isinstance(t.op,ast.Sub):return Poly.cast(a)-b
            if isinstance(t.op,ast.Mult):return a*b
            if isinstance(t.op,ast.Pow):return a**b
        raise ValueError(ast.dump(t))
    return Poly.cast(visit(ast.parse('('+text.replace('^','**').strip()+')',mode='eval').body))

out=[]
for name,k,d0,base in [('N2',2,2,'finite_n2_next'),('N3',3,4,'finite_n3_next'),('A3',3,3,'finite_a_next'),('A4',4,5,'finite_a_next'),('A5',5,7,'finite_a_next')]:
    cp=ROOT/base/f'Finite{name}{"Coefficients" if name.startswith("A") else "Height"}.lean'
    mp=ROOT/base/f'Finite{name}Matrix.lean'
    rp=ROOT/'five_regions_next'/f'Finite{name}RatioHeight.lean'
    coeff=[ast.literal_eval(body(cp.read_text(),f'finite{name}Coeff{ell}').replace('![','[')) for ell in range(k+1)]
    heights=ast.literal_eval(body(rp.read_text(),f'fiveRegion{name}Height'))
    for j,side in enumerate(['Left','Right']):
        actual=[expr(t) for t in body(mp.read_text(),f'finite{name}{side}')[1:-1].split(',')]
        assert len(actual)==3
        for i in range(3):
            reconstructed=0
            for ell in range(k+1):
                v=coeff[ell][i][j]
                assert len(v)==d0+ell+1
                reconstructed+=sum(z*x**h*y**(d0+ell-h)*c**ell for h,z in enumerate(v))
            assert not (actual[i]-reconstructed).d,(name,i,j)
    for region,(ratio,height) in enumerate(zip(ratios,heights)):
        values=[]
        for i in range(3):
            weights=[sum(abs(z)*ratio**h for j in range(2) for h,z in enumerate(coeff[ell][i][j])) for ell in range(k+1)]
            v=Q(101,100)*sum(w/Q(1000)**(k-ell) for ell,w in enumerate(weights))
            assert v<height,(name,region,i,v,height)
            values.append(v)
        vmax=max(values)
        out.append(dict(family=name,region=region,ratio=str(ratio),height=height,maximum=str(vmax),slack=str(height-vmax),max_row=values.index(vmax)))
    print(name,'all6 polynomial identities and15 strict bounds PASS; minimum slack',float(min(Q(z['slack']) for z in out if z['family']==name)))
files=[ROOT/'five_regions_next'/'FiniteHomogeneousRatio.lean']+[ROOT/'five_regions_next'/f'Finite{n}RatioHeight.lean' for n in ['N2','N3','A3','A4','A5']]
report={'scope':'Independent diagnostic only; not compiler or kernel acceptance','polynomial_identities':30,'strict_row_bounds':75,'summarized_bounds':out,'sources':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}}
(ROOT/'audit_next'/'five_region_ratio_review.json').write_text(json.dumps(report,indent=2)+'\n')
