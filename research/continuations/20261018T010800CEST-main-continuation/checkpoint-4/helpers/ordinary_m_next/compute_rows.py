from itertools import product
from collections import defaultdict
from fractions import Fraction
from pathlib import Path
import json
N=4
class P:
 def __init__(self,x=0): self.d=x.d.copy() if isinstance(x,P) else (x if isinstance(x,dict) else ({(0,)*N:x} if x else {}))
 def __add__(self,y):
  y=P(y);d=defaultdict(int,self.d)
  for m,c in y.d.items():d[m]+=c
  return P({m:c for m,c in d.items() if c})
 __radd__=__add__
 def __neg__(self):return P({m:-c for m,c in self.d.items()})
 def __sub__(self,y):return self+-P(y)
 def __rsub__(self,y):return P(y)+-self
 def __mul__(self,y):
  y=P(y);d=defaultdict(int)
  for m,c in self.d.items():
   for n,e in y.d.items():d[tuple(i+j for i,j in zip(m,n))]+=c*e
  return P({m:c for m,c in d.items() if c})
 __rmul__=__mul__
 def __pow__(self,k):
  assert k>=0
  r=P(1)
  for _ in range(k):r=r*self
  return r
vs=[P({tuple(int(i==j) for j in range(N)):1}) for i in range(N)]
a,b,s,c=vs;anchors=[a,b,s];dif=[a-b,a-s,b-s]
# alpha=(0,bs,as,ab). Factor every alpha_j-alpha_l into a sign,
# powers of a,b,s, and one oriented anchor difference if present.
factors={
(0,1):(-1,[0,1,1],None),(0,2):(-1,[1,0,1],None),(0,3):(-1,[1,1,0],None),
(1,0):(1,[0,1,1],None),(1,2):(-1,[0,0,1],0),(1,3):(-1,[0,1,0],1),
(2,0):(1,[1,0,1],None),(2,1):(1,[0,0,1],0),(2,3):(-1,[1,0,0],2),
(3,0):(1,[1,1,0],None),(3,1):(1,[0,1,0],1),(3,2):(1,[1,0,0],2)}
def choose(x,n):
 r=Fraction(1)
 for m in range(n):r*=Fraction(x-m,m+1)
 return r
rows=[]
for i in range(4):
 row=[]
 for j in range(4):
  value=P()
  for h in product(range(3),repeat=4):
   if sum(h)!=1+(i==j):continue
   coeff=16*choose(Fraction(5,2),h[j])
   ex=[4,4,4];dx=[4,4,4];power=2-h[j]
   if j==0:
    ex=[x+power for x in ex];tail=c**power
   else:
    for q in range(3):
     if q!=j-1:ex[q]+=power
    tail=(anchors[j-1]*c+1)**power
   for l in range(4):
    if l==j:continue
    p=2+(i==l)
    coeff*=choose(-p,h[l]);e=p+h[l]
    sign,mons,idx=factors[j,l];coeff*=sign**e
    ex=[x-e*m for x,m in zip(ex,mons)]
    if idx is not None:dx[idx]-=e
   # row divisions d0=Delta,d1=a(b-s),d2=b(a-s),d3=s(a-b)
   if i==0:dx=[x-1 for x in dx]
   else:
    ex[i-1]-=1;dx[{1:2,2:1,3:0}[i]]-=1
   # divided root columns P_j=R_j/a_j
   if j>0:ex[j-1]-=1
   assert min(ex+dx)>=0,(i,j,h,ex,dx)
   assert coeff.denominator==1
   term=P(int(coeff))*tail
   for x,e in zip(anchors,ex):term*=x**e
   for x,e in zip(dif,dx):term*=x**e
   value+=term
  row.append(value)
 rows.append(row)
for i,row in enumerate(rows):
 sums=[sum(abs(c) for p in row[1:] for m,c in p.d.items() if m[3]==l) for l in range(3)]
 bad=[m for p in row[1:] for m in p.d if m[2]>8 or sum(m[:3])>11]
 print('row',i,'terms',[len(p.d) for p in row], 'absolute coefficient sums by c degree',sums,'total',sum(sums),'bad weight exponents',bad[:4])
Path('ordinary_m_next/rows.json').write_text(json.dumps([[sorted([[list(m),int(c)] for m,c in p.d.items()]) for p in row] for row in rows],indent=2))
