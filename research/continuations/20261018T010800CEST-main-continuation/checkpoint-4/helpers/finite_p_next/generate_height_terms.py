from pathlib import Path
class P:
 def __init__(self,d):self.d=d if isinstance(d,dict) else ({(0,0,0):d} if d else {})
 def __add__(self,x):
  x=x if isinstance(x,P) else P(x);d=self.d.copy()
  for e,c in x.d.items():d[e]=d.get(e,0)+c
  return P({e:c for e,c in d.items() if c})
 __radd__=__add__
 def __neg__(self):return P({e:-c for e,c in self.d.items()})
 def __sub__(self,x):return self+(-x)
 def __mul__(self,x):
  x=x if isinstance(x,P) else P(x);d={}
  for e,c in self.d.items():
   for f,k in x.d.items():
    g=tuple(e[i]+f[i] for i in range(3));d[g]=d.get(g,0)+c*k
  return P({e:c for e,c in d.items() if c})
 __rmul__=__mul__
 def __pow__(self,n):
  r=P(1)
  for _ in range(n):r=r*self
  return r
A=P({(1,0,0):1});B=P({(0,1,0):1});T=P({(0,0,1):1})
def R(u,v):return [7*u*u-35*u*v,64*u**3-140*u*u*v,72*u**4-120*u**3*v],[35*u*v-7*v*v,140*u*v*v-64*v**3,120*u*v**3-72*v**4]
def Q(u,v):return [-15*u**3+56*u*u*v-105*u*v*v,-180*u**4+512*u**3*v-420*u*u*v*v,-240*u**5+576*u**4*v-360*u**3*v*v],[70*u*v*v-6*v**3,100*u*v**3-12*v**4,24*v**5]
rab=R(A,B);rbs=R(B,T);ras=R(A,T);tab=Q(A,B);tas=Q(A,T);tbs=Q(B,T)
rows=[[[rab[0][l],rab[1][l],0] for l in range(3)], [[rab[0][l]-ras[0][l],rab[1][l]+rbs[0][l],rbs[1][l]-ras[1][l]]for l in range(3)], [[tab[0][l],tab[1][l],0]for l in range(3)], [[tas[0][l],-tbs[0][l],tas[1][l]-tbs[1][l]]for l in range(3)]]
def arr(xs):return '!['+', '.join(xs)+']'
def terms(p):
 ts=[f'({int(c)}, {i}, {j}, {k})'for (i,j,k),c in ((p if isinstance(p,P) else P(p)).d.items()) if c!=0]
 return arr(ts+['(0, 0, 0, 0)']*(3-len(ts)))
v=arr([arr([arr([terms(rows[i][l][j])for j in range(3)])for l in range(3)])for i in range(4)])
head='''import D1Bound5.FinitePMatrix
import D1Bound5.FiniteHomogeneousTwo
import Mathlib.Tactic.GCongr
import Mathlib.Tactic.Omega
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Linarith

open Finset

namespace D1Bound5

/-- Integer coefficient and the three anchor exponents. -/
abbrev FinitePTerm := ℤ × ℕ × ℕ × ℕ

def finitePTermValue {R : Type*} [CommRing R]
    (t : FinitePTerm) (a b s : R) : R :=
  (t.1 : R)*a^t.2.1*b^t.2.2.1*s^t.2.2.2

/-- Terms are obtained after the H and V row cancellations. -/
def finitePRootTerms : Fin 4 → Fin 3 → Fin 3 → Fin 3 → FinitePTerm :=
'''
Path('finite_p_next/FinitePHeight.lean').write_text(head+'  '+v+'\n\n')
