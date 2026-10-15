#!/usr/bin/env python3
from pathlib import Path
from fractions import Fraction as F
from math import isqrt
import re,json,hashlib
ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'upload/D1_bound5-v1(1).tex'
text=SRC.read_text();L=10**12
def sqrtlo(n):return F(isqrt(n*L*L),L)
def sqrthi(n):
 q=isqrt(n*L*L);return F(q+(q*q<n*L*L),L)
class Ring:
 def __init__(self,d):self.d=d;self.t=int(d%4==3);self.u=(d+1)//4 if self.t else d
 def add(self,x,y):return(x[0]+y[0],x[1]+y[1])
 def sub(self,x,y):return(x[0]-y[0],x[1]-y[1])
 def mul(self,x,y):return(x[0]*y[0]-self.u*x[1]*y[1],x[0]*y[1]+x[1]*y[0]+self.t*x[1]*y[1])
 def scale(self,x,k):return(x[0]*k,x[1]*k)
 def norm(self,x):return x[0]**2+self.t*x[0]*x[1]+self.u*x[1]**2
pairs={};sec=text.split('\\caption{The forty first-pair representatives')[1].split('\\end{longtable}')[0]
for m in re.finditer(r'(?m)^(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\',sec):
 i,d,ax,ay,bx,by,a0,b0=map(int,m.groups());pairs[i]=(d,(ax,ay),(bx,by),a0,b0)
sec=text.split('\\caption{All remaining triples')[1].split('\\end{longtable}')[0];rows=[]
for m in re.finditer(r'(?m)^(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) & ([^\n]+?) \\\\',sec):
 i,x,y,s0,M,N0=map(int,m.groups()[:6]);d,a,b,a0,b0=pairs[i];s=(x,y);K=Ring(d)
 q=K.add(b,s);p=K.mul(b,s);D=K.sub(K.mul(K.sub(b,s),K.sub(b,s)),(4,0));h=K.add((1,0),K.scale(p,2))
 alower=2*(sqrtlo(K.norm(h))-sqrthi(K.norm(q)))
 bupper=sqrthi(K.norm(D))+2*sqrthi(K.norm(q))+1
 tail=4*b0*s0
 f=lambda X:F(X)-alower*sqrtlo(X)+bupper
 passes=tail>=N0 or (alower>0 and f(tail)<0 and f(N0)<0)
 row={'pair':i,'d':d,'s':s,'a0':a0,'b0':b0,'s0':s0,'N0':N0,'tail':tail,'simple_tail':tail>=N0,'refined_irregular_pass':passes,'f_tail_upper':str(f(tail)),'f_cutoff_upper':str(f(N0))}
 rows.append(row)
 print(i,s,'tail',tail,'N0',N0,'pass',passes,'Ftail',float(f(tail)),'Fcutoff',float(f(N0)))
print('simple tail',sum(r['simple_tail'] for r in rows),'refined irregular',sum(r['refined_irregular_pass'] for r in rows))
(ROOT/'comments_v1/independent/irregular_gap.json').write_text(json.dumps({'source_sha256':hashlib.sha256(SRC.read_bytes()).hexdigest(),'rows':rows},indent=2))
