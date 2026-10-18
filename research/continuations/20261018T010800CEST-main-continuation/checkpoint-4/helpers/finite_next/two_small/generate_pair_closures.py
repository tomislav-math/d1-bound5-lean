from pathlib import Path
from math import isqrt
import json,time

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

def compute_closure(row,index,radius_power=550):
 d,u,v,x,y,expected_vertices,expected_edges=row
 if d%4==3:t,n=1,(d+1)//4;a,b=((u-v)//2,v),((x-y)//2,y)
 else:t,n=0,d;a,b=(u//2,v//2),(x//2,y//2)
 compat=lambda x,z:root(t,n,add(mul(t,n,x,z),(1,0))) is not None
 seed=sorted(z for z in disk(t,n,33**2) if compat(a,z) and compat(b,z))
 S=set(seed);Q=list(seed)
 r0=root(t,n,add(mul(t,n,a,b),(1,0)));assert r0 is not None
 R2=10**(2*radius_power)
 for z in Q:
  r=root(t,n,add(mul(t,n,a,z),(1,0)))
  s=root(t,n,add(mul(t,n,b,z),(1,0)))
  assert r is not None and s is not None
  mid=add(add(a,b),mul(t,n,add(scale(2,mul(t,n,a,b)),(1,0)),z))
  rr=scale(2,mul(t,n,r0,mul(t,n,r,s)))
  for sign in (-1,1):
   w=add(mid,scale(sign,rr))
   if norm(t,n,w)<=R2 and w not in S:S.add(w);Q.append(w)
 vertices=sorted(S)
 large=[z for z in vertices if z!=(0,0) and z not in [a,b] and norm(t,n,z)>=9]
 assert len(large)==expected_vertices,(index,len(large),expected_vertices)
 return dict(row=index,d=d,tau=t,nu=n,anchors=[a,b],seed=seed,closure=vertices,large=large,expected_edges=expected_edges)

if __name__=='__main__':
 started=time.time();table=json.loads(Path('finite_next/two_small/pair_table.json').read_text())
 dest=Path('finite_next/two_small/closures');dest.mkdir(exist_ok=True)
 counts=[]
 for i,row in enumerate(table,1):
  result=compute_closure(row,i)
  (dest/f'pair_{i:02}.json').write_text(json.dumps(result,separators=(',',':'))+'\n')
  counts.append([i,result['d'],len(result['seed']),len(result['closure']),len(result['large']),result['expected_edges']])
 Path('finite_next/two_small/closure_counts.json').write_text(json.dumps(counts,indent=2)+'\n')
 print('All48closure counts matched article; large vertices total',sum(r[4] for r in counts),'seconds',round(time.time()-started,2))
 print('Full closure vertices including zero/anchors:',sum(r[3] for r in counts))
