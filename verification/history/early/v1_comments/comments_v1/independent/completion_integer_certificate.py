#!/usr/bin/env python3
"""Exact short replacement for Section 9's fourth-entry enumeration.
No floating-point decisions. No manuscript changes. Source-bound output.
"""
from pathlib import Path
from math import isqrt
from fractions import Fraction as F
import re,json,hashlib
ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'upload/D1_bound5-v1(1).tex'; text=SRC.read_text()
class Ring:
 def __init__(self,d):self.t=int(d%4==3);self.nu=(d+1)//4 if self.t else d
 def add(self,x,y):return(x[0]+y[0],x[1]+y[1])
 def sub(self,x,y):return(x[0]-y[0],x[1]-y[1])
 def mul(self,x,y):return(x[0]*y[0]-self.nu*x[1]*y[1],x[0]*y[1]+x[1]*y[0]+self.t*x[1]*y[1])
 def norm(self,x):return x[0]**2+self.t*x[0]*x[1]+self.nu*x[1]**2
 def scale(self,x,k):return(x[0]*k,x[1]*k)
J=lambda n:isqrt(100*n)
pairs={}; section=text.split('\\caption{The forty first-pair representatives')[1].split('\\end{longtable}')[0]
for m in re.finditer(r'(?m)^(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\',section):
 i,d,ax,ay,bx,by,a0,b0=map(int,m.groups());pairs[i]=(d,(ax,ay),(bx,by),a0,b0)
section=text.split('\\caption{All remaining triples')[1].split('\\end{longtable}')[0]
rows=[];direct=[];certified=[];exception=[]
for m in re.finditer(r'(?m)^(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) & ([^\n]+?) \\\\',section):
 i,x,y,s0,M,N0=map(int,m.groups()[:6]);d,a,b,a0,b0=pairs[i];s=(x,y);R=Ring(d)
 assert R.norm(s)==s0 and R.norm(a)==a0 and R.norm(b)==b0
 q=R.add(b,s);h=R.add((1,0),R.scale(R.mul(b,s),2));delta=R.sub(R.mul(R.sub(b,s),R.sub(b,s)),(4,0))
 nq=R.norm(q);nh=R.norm(h);nd=R.norm(delta);P=J(nh)-J(nq)-1
 assert P>0
 def E(X):return 50*X-P*J(X)+5*J(nd)+10*J(nq)+65
 tail=4*b0*s0
 kind='direct' if tail>=N0 else 'exception' if i==7 else 'certificate'
 right=900 if kind=='exception' else N0
 row={'row':len(rows)+1,'pair':i,'d':d,'a':a,'b':b,'s':s,'a0':a0,'b0':b0,'s0':s0,'N0':N0,'tail':tail,'q':q,'h':h,'delta':delta,'nq':nq,'nh':nh,'nd':nd,'P':P,'E_tail':E(tail),'right':right,'E_right':E(right),'kind':kind}
 rows.append(row)
 if kind=='direct':direct.append(row)
 else:
  assert E(tail)<0 and E(right)<0,row
  if kind=='exception':
   assert (d,a,b,s0,N0)==(2,(1,0),(-3,0),12,1024)
   assert s in [(-2,-2),(-2,2)]
   assert (nq,nh,nd,P,E(900))==(33,457,153,155,-250)
   exception.append(row)
  else:
   # Also use the existing Section 9 precision, without introducing new article notation.
   scale=10**10
   def lower(n):return F(isqrt(n*scale*scale),scale)
   def upper(n):
    k=isqrt(n*scale*scale);return F(k+(k*k<n*scale*scale),scale)
   alpha=2*(lower(nh)-upper(nq));beta=upper(nd)+2*upper(nq)+1
   assert alpha>0
   upper_value=F(N0)-alpha*lower(N0)+beta
   assert upper_value < -100
   row['existing_enclosure_upper']=str(upper_value)
   certified.append(row)
 print(kind.upper(),row['row'],i,s,'M',tail,'N0',N0,'P',P,'E(M)',E(tail),'E(right)',E(right))
assert len(rows)==56 and len(direct)==38 and len(certified)==16 and len(exception)==2
# The annulus obstruction only uses t+1 being a square in Z[sqrt(-2)].
residues=sorted({(u*u+2*v*v)%16 for u in range(16) for v in range(16)})
assert 30%16 not in residues and 31%16 not in residues
solutions32=[(u,v) for u in range(-5,6) for v in range(-4,5) if u*u+2*v*v==32]
assert solutions32==[(0,-4),(0,4)]
annulus=[];nearby=[]
for u in range(-5,6):
 for v in range(-4,5):
  if u*u+2*v*v>32:continue
  x=u*u-2*v*v-1;y=2*u*v;n=x*x+2*y*y
  if 900<n<1024:annulus.append((u,v,x,y,n))
  if n>900:nearby.append((u,v,x,y,n))
assert not annulus
# Exact regular completion witness for each exceptional triple.
R=Ring(2);tt=(0,1);aa=(1,0);bb=(-3,0);ss=(-2,2)
roots=[tt,(1,1),(3,-1)]
for root,target in zip(roots,[R.add(R.mul(aa,bb),(1,0)),R.add(R.mul(aa,ss),(1,0)),R.add(R.mul(bb,ss),(1,0))]):assert R.mul(root,root)==target
base=R.add(R.add(R.add(aa,bb),ss),R.scale(R.mul(R.mul(aa,bb),ss),2))
prod=R.scale(R.mul(R.mul(roots[0],roots[1]),roots[2]),2)
completions=[R.add(base,prod),R.sub(base,prod)]
assert completions==[(0,0),(16,-20)] and R.norm(completions[1])==1056
report={'source_sha256':hashlib.sha256(SRC.read_bytes()).hexdigest(),'rows':rows,'counts':{'direct':38,'certificate':16,'annulus':2},'max_existing_enclosure_upper':str(max(F(r['existing_enclosure_upper']) for r in certified)),'max_E_nonexception':max(max(r['E_tail'],r['E_right']) for r in certified),'max_E_all_remaining':max(max(r['E_tail'],r['E_right']) for r in certified+exception),'norm_residues_mod16':residues,'norm32_root_solutions':solutions32,'annulus_candidates':annulus,'regular_completions':completions}
(ROOT/'comments_v1/independent/completion_integer_certificate.json').write_text(json.dumps(report,indent=2))
print('SOURCE',report['source_sha256'])
print('PASS',report['counts'],'max E16',report['max_E_nonexception'],'max E18',report['max_E_all_remaining'])
print('EXISTING ENCLOSURE maximum',report['max_existing_enclosure_upper'],'<−100')
print('ANNULUS norm residues mod16',residues,'norm32 solutions',solutions32,'no900<N(t)<1024')
print('EXCEPTIONAL regular completions',completions,'nonzero norm1056')
