"""Expand the paper's finite N2 generator over Q[x,y,c].
The output only proposes explicit definitions; Lean ring proofs must verify
all mathematical identities before this generation is accepted.
"""
from fractions import Fraction as F
import json

def add(*ps):
    d={}
    for p in ps:
        for e,a in p.items(): d[e]=d.get(e,F(0))+a
    return {e:a for e,a in d.items() if a}
def mul(p,q):
    d={}
    for e,a in p.items():
        for f,b in q.items():
            t=tuple(e[i]+f[i] for i in range(3));d[t]=d.get(t,F(0))+a*b
    return {e:a for e,a in d.items() if a}
def cn(a):return {(0,0,0):F(a)} if a else {}
def neg(p):return {e:-a for e,a in p.items()}
def pw(p,n):
    r=cn(1)
    for _ in range(n):r=mul(r,p)
    return r
def prod(*p):
    r=cn(1)
    for q in p:r=mul(r,q)
    return r
def choose(r,h):
    q=F(1)
    for n in range(h):q*=F(r-n,n+1)
    return q
x={(1,0,0):F(1)};y={(0,1,0):F(1)};c={(0,0,1):F(1)}
diff=add(x,neg(y))
def divide(p,q):
    # Single-divisor exact lexicographic multivariate long division.
    r={};p=p.copy();e=max(q);a=q[e]
    while p:
        f=max(p);b=p[f]
        t=tuple(f[i]-e[i] for i in range(3))
        assert min(t)>=0,(p,q)
        v={t:b/a};r=add(r,v);p=add(p,neg(mul(v,q)))
    return r
Q=[]
for i in range(3):
    row=[]
    for j in range(3):
        terms=[]
        for h0 in range(3):
            for h1 in range(3):
                for h2 in range(3):
                    h=[h0,h1,h2]
                    if sum(h)!=2+(i==j)-1:continue
                    b=16*choose(F(5,2),h[j])
                    for l in range(3):
                        if l!=j:b*=choose(-2-int(i==l),h[l])
                    d1=int(i==1);d2=int(i==2)
                    if j==0:t=prod(cn((-1)**(4+d1+d2+h1+h2)),pw(x,d1+h1),pw(y,d2+h2),pw(c,2-h0),pw(diff,4))
                    elif j==1:t=prod(cn((-1)**(2+d2+h2)),pw(x,2),pw(y,d2+h2),pw(add(mul(x,c),cn(1)),2-h1),pw(diff,2-d2-h2))
                    else:t=prod(pw(y,2),pw(x,d1+h1),pw(add(mul(y,c),cn(1)),2-h2),pw(diff,2-d1-h1))
                    terms.append(mul(cn(b),t))
        row.append(divide(add(*terms),mul(cn(2),[diff,x,y][i])))
    Q.append(row)
def fmt(p):
    bits=[]
    for e,a in sorted(p.items(),reverse=True):
        assert a.denominator==1
        mon=' * '.join(v if n==1 else f'{v} ^ {n}' for v,n in zip(['x','y','c'],e) if n)
        aa=abs(a.numerator);s=str(aa) if not mon else mon if aa==1 else f'{aa} * {mon}'
        bits.append((' - ' if a<0 else ' + ')+s)
    s=''.join(bits)
    return s[3:] if s.startswith(' + ') else '-'+s[3:] if s else '0'
for i in range(3):
    for j in range(3):
        q=Q[i][j] if j==0 else divide(Q[i][j],[cn(1),x,y][j])
        print(i,j)
        for n in range(3):
            p={(e[0],e[1],0):a for e,a in q.items() if e[2]==n}
            print(n,fmt(p))
det=add(prod(Q[0][0],Q[1][1],Q[2][2]),prod(Q[0][1],Q[1][2],Q[2][0]),prod(Q[0][2],Q[1][0],Q[2][1]),neg(prod(Q[0][2],Q[1][1],Q[2][0])),neg(prod(Q[0][1],Q[1][0],Q[2][2])),neg(prod(Q[0][0],Q[1][2],Q[2][1])))
assert det==prod(cn(-225),x,y,pw(diff,7))
with open('finite_n2_next/n2_coefficients.json','w') as out:json.dump([[[[list(e),int(a)] for e,a in sorted(p.items())]for p in row]for row in Q],out,indent=2)
print('det = -225*x*y*(x-y)^7')
