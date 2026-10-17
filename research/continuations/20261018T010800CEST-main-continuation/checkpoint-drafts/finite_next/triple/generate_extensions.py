from pathlib import Path
from math import isqrt
import json

def norm(t,n,z):
 x,y=z;return x*x+t*x*y+n*y*y

def mul(t,n,z,w):
 x,y=z;u,v=w;return x*u-n*y*v,x*v+y*u+t*y*v

def add(z,w):return z[0]+w[0],z[1]+w[1]
def scale(c,z):return c*z[0],c*z[1]
def root(t,n,z):
 N=norm(t,n,z);h=isqrt(N);p=2*z[0]+t*z[1];D=4*n-t*t
 if h*h!=N or 2*h+p<0 or 2*h-p<0:return None
 E=isqrt(2*h+p);F=isqrt((2*h-p)//D)
 if z[1]<0:F=-F
 q=((E-t*F)//2,F)
 return q if mul(t,n,q,q)==z else None

def disk(t,n,M):
 D=4*n-t*t;r=isqrt(4*M)
 for y in range(-isqrt(4*M//D),isqrt(4*M//D)+1):
  for e in range(-r,r+1):
   if (e-t*y)%2==0 and e*e+D*y*y<=4*M:yield ((e-t*y)//2,y)

rows=[
 (0,1,[(-2,-2),(-2,2),(2,0)],(0,2),(60,0)),
 (0,1,[(-2,-1),(0,-1),(2,-1)],(0,1),(0,15)),
 (0,1,[(-2,-1),(0,2),(2,-1)],(0,1),(0,-40)),
 (0,1,[(-2,0),(-1,-2),(1,0)],(0,2),(4,12)),
 (0,2,[(-2,0),(1,-1),(1,1)],(1,2),(-24,0)),
 (1,1,[(-1,-1),(-2,1),(1,0)],(0,2),(8,0)),
 (1,1,[(-1,-1),(2,-3),(1,0)],(0,2),(-16,8)),
 (1,1,[(0,-1),(1,-2),(1,-1)],(0,1),None),
 (1,2,[(-2,-1),(-3,1),(1,0)],(0,2),(24,0)),
 (1,2,[(-2,-1),(-1,2),(3,-1)],(0,1),(32,-64)),
]
expected=[61,89,64,105,71,112,112,57,83,55]
R2=10**80
result=[]
for rowidx,(t,n,triple,(ia,ib),expected_ext) in enumerate(rows):
 a,b=triple[ia],triple[ib]
 compat=lambda x,z:root(t,n,add(mul(t,n,x,z),(1,0))) is not None
 seed=sorted(z for z in disk(t,n,33**2) if compat(a,z) and compat(b,z))
 S=set(seed);Q=list(seed)
 r0=root(t,n,add(mul(t,n,a,b),(1,0)));assert r0 is not None
 for z in Q:
  r=root(t,n,add(mul(t,n,a,z),(1,0)))
  s=root(t,n,add(mul(t,n,b,z),(1,0)))
  assert r is not None and s is not None
  mid=add(add(a,b),mul(t,n,add(scale(2,mul(t,n,a,b)),(1,0)),z))
  rr=scale(2,mul(t,n,r0,mul(t,n,r,s)))
  for sign in (-1,1):
   w=add(mid,scale(sign,rr))
   assert compat(a,w) and compat(b,w)
   if norm(t,n,w)<=R2 and w not in S:S.add(w);Q.append(w)
 assert len(S)==expected[rowidx],(rowidx+1,len(S))
 ext=sorted(z for z in S if z!=(0,0) and z not in triple and all(compat(c,z) for c in triple))
 assert ext==([] if expected_ext is None else [expected_ext]),(rowidx+1,ext)
 result.append(dict(row=rowidx+1,tau=t,nu=n,triple=triple,anchors=[a,b],seed=seed,vertices=sorted(S),extension=ext))
 print(rowidx+1,'seed',len(seed),'closure',len(S),'extensions',ext)
Path('finite_next/triple/extensions.json').write_text(json.dumps(result,indent=2)+'\n')
