from fractions import Fraction as F
from math import isqrt
import json
from itertools import permutations, combinations
from collections import defaultdict

def enum_ring(q,limit):
 t,h=(1,(q+1)//4) if q%4==3 else (0,q)
 disc=4*h-t*t
 els=[]
 ymax=isqrt(4*limit//disc)
 for y in range(-ymax,ymax+1):
  radius=isqrt(4*limit-disc*y*y)
  for xx in range(-radius,radius+1):
   if (xx-t*y)%2==0:
    x=(xx-t*y)//2
    n=x*x+t*x*y+h*y*y
    assert n<=limit
    els.append((x,y))
 return els

def norm(a,t,h):
 x,y=a;return x*x+t*x*y+h*y*y

def mul(a,b,t,h):
 x,y=a;u,v=b;return (x*u-h*y*v,x*v+y*u+t*y*v)
def add(a,b): return (a[0]+b[0],a[1]+b[1])
def neg(a):return (-a[0],-a[1])
def conj(a,t):return (a[0]+t*a[1],-a[1])
def scale(a,s):return (s*a[0],s*a[1])

def finite_tail_check():
 qs=[q for q in range(1,65) if all(q%(p*p) for p in range(2,isqrt(q)+1)) and (q if q%4==3 else 4*q)<=64]
 specified=[1,2,3,5,6,7,10,11,13,14,15,19,23,31,35,39,43,47,51,55,59]
 assert qs==specified
 pairs=tails=prelast=passing=0
 raw=[];byfield={}
 for q in qs:
  t,h=(1,(q+1)//4) if q%4==3 else (0,q)
  els=enum_ring(q,15)
  sq={mul(r,r,t,h):r for r in enum_ring(q,70)}
  ann=[x for x in els if 9<=norm(x,t,h)<=15]
  pp=tt=aa=0
  for ix,b in enumerate(ann):
   for c in ann[ix+1:]:
    bc1=add(mul(b,c,t,h),(1,0))
    if bc1 not in sq:continue
    pp+=1
    B=norm(b,t,h); C=norm(c,t,h)
    if B>C:bb,cc=c,b; B,C=C,B
    else:bb,cc=b,c
    r=sq[bc1]
    for d in set(add(add(bb,cc),scale(r,s)) for s in [-2,2]):
     if d in [(0,0),bb,cc] or norm(d,t,h)<C:continue
     tt+=1
     for a in els:
      if a in [(0,0),bb,cc,d] or norm(a,t,h)>B:continue
      if add(mul(a,bb,t,h),(1,0)) not in sq or add(mul(a,cc,t,h),(1,0)) not in sq:continue
      aa+=1
      value=add(mul(a,d,t,h),(1,0))
      raw.append((q,a,bb,cc,d,value))
      if value in sq:passing+=1
  pairs+=pp;tails+=tt;prelast+=aa
  byfield[q]=[pp,tt,aa]
 assert [pairs,tails,prelast,passing]==[90,118,16,0]
 listed=[(2,(-1,0),(-3,0),(3,0),(0,-4),(1,4)),(2,(-1,0),(2,-2),(3,0),(11,-4),(-10,4)),(3,(-1,2),(-1,-3),(4,-3),(7,-14),(22,0)),(6,(-2,0),(3,-1),(3,1),(14,0),(-27,0)),(11,(-1,0),(3,1),(4,-1),(15,0),(-14,0)),(35,(-3,0),(2,1),(3,-1),(13,0),(-38,0))]
 def canon(row):
  q,a,b,c,d,val=row;t=1 if q%4==3 else 0
  candidates=[]
  for sign in [-1,1]:
   for cj in [False,True]:
    transform=lambda x:scale(conj(x,t) if cj else x,sign)
    aa,bb,cc,dd=map(transform,[a,b,c,d])
    bb,cc=sorted([bb,cc])
    candidates.append((q,aa,bb,cc,dd))
  return min(candidates)
 assert {canon(x) for x in raw}=={canon(x) for x in listed}
 assert len({canon(x) for x in raw})==6
 return {'field_list':qs,'counts':[pairs,tails,prelast,passing],'per_field':byfield,'raw_candidates':raw,'canonical_rows_verified':True}

def rational_checks():
 out={}
 def check(key,lhs,rhs):
  assert lhs<rhs,(key,lhs,rhs)
  out[key]={'lhs':str(lhs),'rhs':str(rhs),'margin':str(rhs-lhs)}
 q=F(7,13)+F(125,216);r0=F(625,1053)
 check('tail_endpoint_A1',F(35,108)+q/2+F(7,48)*r0,1)
 check('tail_endpoint_AB',F(5,27)+F(7,24)*q+r0/4,1)
 assert F(35,108)+q/2+F(7,48)*r0==F(12247,12636)
 assert F(5,27)+F(7,24)*q+r0/4==F(14813,22464)
 e=F(128,8649);s=F(1,2)+3*e;h=F(3,2)+3*e
 check('product4_all_large',h*s*s*(1+F(3,36)+s/324),F(1,2))
 check('product4_mixed',F(95225,36864),F(8,3))
 check('lastcol_E',F(625,264627),F(1,400))
 check('product5_inverse_f',F(203,225),F(11,12))
 check('product5_det_F',F(3,16)+F(3,2)*F(7,192)+9*F(7,192)**2,F(33,128))
 check('product5_det_G',F(33,128)*(1+F(11,54)+F(505,11664)+F(1,2916)),F(1,3))
 check('product5_nonsingular',F(1,8)+F(67,300)+F(201,200)**2/2916,F(1,2))
 rows=[(F(1),F(8),F(27,8)),(F(140,99),F(4),F(3)),(F(12,7),F(3),F(11,4)),(F(2),F(3),F(29,10)),(F(20,9),F(3),F(3))]
 for i,(a,b,t) in enumerate(rows):
  k1=F(1,2)+1/(7*a*b);k2=F(1,2)+1/(7*b*b);K=k1*k1*k2;L=6*K-F(1,2);Q=9*k1*k1*k2*k2
  P=2/(a*b)+1/(b*b)
  J=2*K*(2/(a*a*b*b)+1/b**4)+L*(1/(a*a*b*b)+2/(a*b**3))+Q/(a*a*b**4)
  fx=lambda x:2*K*x+L*P+J/x
  check('frontier_left_'+str(i),fx(F(2,3)),F(1,2))
  check('frontier_right_'+str(i),fx(t),F(499,500))
  if i==1:assert fx(t)==F(964921210337222547,967173115740160000)
 for H,lam,U in [(32,F(1,10),F(179,10)),(48,F(19,200),F(15))]:
  check('L2_'+str(H),F(200,99)*(F(25,128)+F(1,4)*((F(H,H-1))**2-1)),F(1,2))
  r=F(5,32)*(F(H,H-1)**3-1);l=F(45,1024)-r;u=F(85,1024)+r
  assert l>0
  check('L3_direct_'+str(H),100*u/99,lam)
  check('L3_zero_lower_'+str(H),F(5),100/(201*u))
  check('L3_zero_upper_'+str(H),100/(199*l),U)
 H=1000;r=F(5,32)*(F(H,H-1)**3-1);l=F(45,1024)-r;u=F(85,1024)+r
 check('separated3_direct',800*u/99,F(3,4));check('separated3_zero_lower',F(5),100/(201*u));check('separated3_zero_upper',100/(199*l),15)
 k=F(1,1000);r=F(7,64)*(F(1000,999)**4-1);l=(1-k)**2*(5-6*k-5*k*k)/128-r;u=(1+k)**2*(5+6*k+5*k*k)/128+r
 assert l>0
 check('direct4_direct',1600*u/99,F(4,5));check('direct4_zero_lower',F(10),100/(201*u));check('direct4_zero_upper',100/(199*l),17)
 mu=F(51051,400000);alpha_min=10*(F(1,8)-mu/9)
 check('retained_alpha',F(1),alpha_min);check('retained_strength',F(1),F(9999,10000)*alpha_min**2)
 check('retained_X0_enclosure',F(10001,10000)/F(3999,4000),F(1001,1000)**2)
 check('retained_L4_first',1/(9*F(3999,4000)*3**4),F(1,100))
 return out

def symbolic_checks():
 out={}
 def clean(p):return {k:v for k,v in p.items() if v}
 def plus(*ps):
  r=defaultdict(F)
  for p in ps:
   for k,v in p.items():r[k]+=v
  return clean(r)
 def times(p,q):
  r=defaultdict(F)
  for k,v in p.items():
   for l,w in q.items():r[tuple(a+b for a,b in zip(k,l))]+=v*w
  return clean(r)
 def scale(p,s):return clean({k:s*v for k,v in p.items()})
 def prod(ps,dim):
  r={(0,)*dim:F(1)}
  for p in ps:r=times(r,p)
  return r
 def var(i,dim):return {tuple(int(j==i) for j in range(dim)):F(1)}
 def const(c,dim):return {(0,)*dim:F(c)}
 def det(mat,dim):
  return plus(*[scale(prod([mat[i][p[i]] for i in range(len(p))],dim),(-1)**sum(p[i]>p[j] for i in range(len(p)) for j in range(i+1,len(p)))) for p in permutations(range(len(mat)))])
 es=list(combinations(range(4),2));ed={e:var(j,6) for j,e in enumerate(es)}
 edge=lambda i,j:ed[tuple(sorted((i,j)))]
 E=[[{} if i==j else edge(i,j) for j in range(4)] for i in range(4)]
 M=[[plus(const(1,6),E[i][j]) for j in range(4)] for i in range(4)]
 determinant=det(M,6)
 cub={e:v for e,v in determinant.items() if sum(e)==3}
 triangles=plus(*[prod([edge(i,j),edge(i,k),edge(j,k)],6) for i,j,k in combinations(range(4),3)])
 paths=plus(*[prod([edge(p[0],p[1]),edge(p[1],p[2]),edge(p[2],p[3])],6) for p in permutations(range(4)) if p[0]<p[3]])
 repeats={}
 for i,j in es:
  k,l=[v for v in range(4) if v not in [i,j]]
  repeats=plus(repeats,prod([edge(i,j),edge(i,j),edge(k,l)],6))
 assert cub==plus(scale(triangles,2),scale(paths,-2),scale(repeats,2))
 assert determinant==plus(cub,det(E,6))
 # Laurent-polynomial substitution of z_ij/2 followed by a*b*s*t.
 leading=defaultdict(F)
 for powers,v in cub.items():
  exps=[1]*4
  for k,(i,j) in enumerate(es):exps[i]-=powers[k];exps[j]-=powers[k]
  leading[tuple(exps)]+=v/F(2)**sum(powers)
 target=defaultdict(F)
 for i in range(4):target[tuple(1 if j==i else -1 for j in range(4))]+=F(1,4)
 for i,j in es:target[tuple(-1 if k in [i,j] else 0 for k in range(4))]-=F(1,4)
 assert clean(leading)==clean(target)
 out['cubic_determinant_identity']='exact symbolic identity verified by 24 determinant permutations'
 out['leading_cubic_weights']='exact Laurent-polynomial identity verified'
 x,y=var(0,2),var(1,2);xm=plus(x,scale(y,-1))
 def bino(n):
  v=F(1)
  for i in range(n):v*=F(1,2)-i;v/=i+1
  return v
 fns={n:{(i,n-i):bino(i)*bino(n-i) for i in range(n+1)} for n in [2,3,4]}
 targets={2:scale(times(xm,xm),F(-1,8)),3:scale(times(plus(times(x,x),scale(times(y,y),-1)),xm),F(1,16)),4:scale(times(times(xm,xm),plus(scale(times(x,x),5),scale(times(x,y),6),scale(times(y,y),5))),F(-1,128))}
 for n in fns:assert fns[n]==targets[n]
 out['f2_f3_f4']='exact polynomial identities verified'
 a,b,c=[var(i,3) for i in range(3)]
 main=plus(a,b,c,scale(prod([a,b,c],3),2))
 extension=plus(times(main,main),scale(prod([plus(times(a,b),const(1,3)),plus(times(a,c),const(1,3)),plus(times(b,c),const(1,3))],3),-4))
 expected=plus(times(a,a),times(b,b),times(c,c),scale(times(a,b),-2),scale(times(a,c),-2),scale(times(b,c),-2),const(-4,3))
 assert extension==expected
 out['regular_extension_product']='exact polynomial identity verified'
 a,b,p,q=[var(i,4) for i in range(4)]
 c1=const(1,4)
 pq=times(p,q)
 term=plus(scale(times(a,pq),2),p,q,a,scale(b,-1))
 elimination=plus(times(term,term),scale(prod([plus(pq,c1),plus(times(a,p),c1),plus(times(a,q),c1)],4),-4))
 diff=plus(a,b,scale(p,-1),scale(q,-1))
 target=plus(times(diff,diff),scale(times(plus(times(a,b),c1),plus(pq,c1)),-4))
 assert elimination==target
 qcenter=plus(a,b,p,scale(prod([a,b,p],4),2))
 qdisc=scale(prod([plus(times(a,b),c1),plus(times(a,p),c1),plus(times(b,p),c1)],4),4)
 assert target==plus(times(plus(q,scale(qcenter,-1)),plus(q,scale(qcenter,-1))),scale(qdisc,-1))
 out['L2_zero_elimination_and_roots']='exact polynomial identities verified'
 # Rank-two determinant, with r=1/d.
 h,p0,q0,r=[var(i,4) for i in range(4)]
 rr=times(r,r)
 mat=[[plus(c1,scale(times(r,h),-1)),scale(times(r,p0),-1)],[plus(scale(times(r,q0),-1),scale(times(rr,h),-1)),plus(c1,scale(times(r,h),-1),scale(times(rr,p0),-1))]]
 target=plus(c1,scale(times(r,h),-2),times(rr,plus(times(h,h),scale(times(p0,q0),-1),scale(p0,-1))))
 assert det(mat,4)==target
 out['product5_rank_two_identity']='exact polynomial identity verified'
 return out

if __name__=='__main__':
 results={'finite_tail':finite_tail_check(),'rational':rational_checks(),'symbolic':symbolic_checks()}
 with open('audit/checks/structural_results.json','w') as f:json.dump(results,f,indent=2)
 print('PASS: 90 pairs, 118 tails, 16 candidates, 6 symmetry classes, 0 valid quadruples')
 print('PASS:',len(results['rational']),'strict exact rational comparisons')
 print('PASS:',len(results['symbolic']),'symbolic identity groups')
