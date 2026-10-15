"""Independent exact check of the proposed replacement for fourth-entry search.

Uses only the current manuscript's already computed N0 values, not old check
code or the fourth-entry output column. All new comparisons are rational.
"""
from pathlib import Path
from fractions import Fraction as F
from hashlib import sha256
from math import isqrt
import re,json

ROOT=Path(__file__).resolve().parents[2]
source=ROOT/'upload/D1_bound5-v1(1).tex'
digest=sha256(source.read_bytes()).hexdigest()
assert digest=='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
text=source.read_text()
pairs={}
for m in re.finditer(r'^(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\',text,re.M):
    i,d,ax,ay,bx,by,na,nb=map(int,m.groups())
    pairs[i]=(d,(ax,ay),(bx,by),na,nb)
rows=[]
for m in re.finditer(r'^(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) & (.*?) \\\\',text,re.M):
    i,x,y,ns,mbs,n0=map(int,m.groups()[:6])
    rows.append((i,(x,y),ns,n0))
assert len(pairs)==40 and len(rows)==56

def basis(d):return (1,(d+1)//4) if d%4==3 else (0,d)
def add(a,b):return (a[0]+b[0],a[1]+b[1])
def sub(a,b):return (a[0]-b[0],a[1]-b[1])
def times(n,a):return (n*a[0],n*a[1])
def mul(a,b,d):
    t,h=basis(d)
    return (a[0]*b[0]-h*a[1]*b[1],a[0]*b[1]+a[1]*b[0]+t*a[1]*b[1])
def norm(a,d):
    t,h=basis(d)
    return a[0]**2+t*a[0]*a[1]+h*a[1]**2
def lower(n):
    r=isqrt(100*n)
    assert r*r<=100*n<(r+1)**2
    return F(r,10)
def upper(n):
    r=isqrt(100*n)
    v=r+(r*r<100*n)
    assert v*v>=100*n and (v==0 or (v-1)**2<100*n)
    return F(v,10)
def fine_lower(n):return F(isqrt(n*10**20),10**10)
def fine_upper(n):
    r=isqrt(n*10**20)
    return F(r+(r*r<n*10**20),10**10)

tail_excluded=[];certificates=[]
for i,s,ns,n0 in rows:
    d,a,b,na,nb=pairs[i]
    assert norm(s,d)==ns and norm(a,d)==na and norm(b,d)==nb
    left2=4*nb*ns
    if left2>=n0:
        tail_excluded.append((i,s,ns,n0,left2));continue
    p2=norm(add((1,0),times(2,mul(b,s,d))),d)
    q2=norm(add(b,s),d)
    r2=norm(sub(mul(sub(b,s),sub(b,s),d),(4,0)),d)
    p,q,r=lower(p2),upper(q2),upper(r2)
    assert p-q>0
    def envelope(x2):
        # T² is exact. The coefficient of T is negative, so its lower
        # square-root bound gives an upper bound for F(sqrt(x2)).
        return F(x2)-2*(p-q)*lower(x2)+r+2*q+1
    right2=900 if i==7 else n0
    left_value,right_value=envelope(left2),envelope(right2)
    assert left2<right2 and left_value<0 and right_value<0
    fine_right=F(right2)-2*(fine_lower(p2)-fine_upper(q2))*fine_lower(right2)+fine_upper(r2)+2*fine_upper(q2)+1
    assert fine_lower(p2)-fine_upper(q2)>0
    if i!=7:assert fine_right < -100
    certificates.append({'pair':i,'s':s,'Ns':ns,'N0':n0,
                         'P2':p2,'Q2':q2,'R2':r2,'left2':left2,'right2':right2,
                         'left_upper':str(left_value),'right_upper':str(right_value),
                         'fine_right_upper':str(fine_right)})
assert len(tail_excluded)==38 and len(certificates)==18
assert sum(row['right2']==900 for row in certificates)==2
groups={}
for row in certificates:
    key=tuple(row[k] for k in ('pair','Ns','N0','P2','Q2','R2','left2','right2','left_upper','right_upper'))
    groups.setdefault(key,[]).append(row['s'])
assert len(groups)==14

# Final annulus. For 30<|t|<32 and x²=t+1 in Z[sqrt(-2)],
# n=N(x)=|t+1| is an integer with 29<n<33.
assert all((u*u+2*v*v)%5!=0 or (u==0 and v==0) for u in range(5) for v in range(5))
assert 7 not in {(u*u+2*v*v)%8 for u in range(8) for v in range(8)}
solutions32=[(u,v) for u in range(-isqrt(32),isqrt(32)+1)
             for v in range(-isqrt(16),isqrt(16)+1) if u*u+2*v*v==32]
assert solutions32==[(0,-4),(0,4)]
assert all(sub(mul(x,x,2),(1,0))==(-33,0) for x in solutions32)
residues16=sorted({(u*u+2*v*v)%16 for u in range(16) for v in range(16)})
assert residues16==[0,1,2,3,4,6,8,9,11,12]
assert all((u*u+2*v*v)%16 or (u%4==0 and v%4==0) for u in range(16) for v in range(16))
max_fine=max(F(row['fine_right_upper']) for row in certificates if row['pair']!=7)
assert max_fine == -F(526504132441877163783,5000000000000000000)

result={'sha256':digest,'source_rows':len(rows),'excluded_by_tail':len(tail_excluded),
        'quadratic_certificates':certificates,'distinct_certificate_rows':len(groups),
        'annulus_norms':[30,31,32],'annulus_norm32_roots':solutions32,
        'norm_residues_mod16':residues16,'maximum_16_upper_endpoints_existing_precision':str(max_fine),
        'minimum_endpoint_margin':str(min(-F(row[k]) for row in certificates for k in ('left_upper','right_upper'))),
        'tail_excluded_rows':tail_excluded}
out=ROOT/'comments_v1/determinants/structural_independent.json'
out.write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k not in ('quadratic_certificates','tail_excluded_rows')},indent=2))
