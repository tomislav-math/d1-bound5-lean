"""Expand the exact A3/A4/A5 finite generator over Q[x,y,c].
Diagnostics propose data only. Lean ring proofs verify every matrix identity.
"""
from fractions import Fraction as F
from pathlib import Path
import json

BASE=Path('finite_a_next')
def add(*ps):
 d={}
 for p in ps:
  for e,a in p.items():d[e]=d.get(e,F(0))+a
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
def prod(*ps):
 r=cn(1)
 for p in ps:r=mul(r,p)
 return r
def choose(r,h):
 q=F(1)
 for n in range(h):q*=F(r-n,n+1)
 return q
def divide(p,q):
 r={};p=p.copy();e=max(q);a=q[e]
 while p:
  f=max(p);b=p[f];t=tuple(f[i]-e[i] for i in range(3))
  assert min(t)>=0
  v={t:b/a};r=add(r,v);p=add(p,neg(mul(v,q)))
 return r
x={(1,0,0):F(1)};y={(0,1,0):F(1)};c={(0,0,1):F(1)};delta=add(x,neg(y))
def fmt(p):
 bits=[]
 for e,a in sorted(p.items(),reverse=True):
  assert a.denominator==1
  mon='*'.join(v if n==1 else f'{v}^{n}' for v,n in zip(['x','y','c'],e) if n)
  aa=abs(a.numerator);s=str(aa) if not mon else mon if aa==1 else f'{aa}*{mon}'
  bits.append((' - ' if a<0 else ' + ')+s)
 s=''.join(bits)
 return s[3:] if s.startswith(' + ') else '-'+s[3:] if s else '0'
def vec(xs):return '!['+','.join(map(str,xs))+']'
def family(k,m,g,cdet,expectedL):
 p=[m,k,k];Q=[]
 for i in range(3):
  row=[]
  for j in range(3):
   terms=[]
   for h0 in range(k+1):
    for h1 in range(k+1):
     for h2 in range(k+1):
      h=[h0,h1,h2]
      if sum(h)!=p[j]+(i==j)-1:continue
      b=4**k*choose(F(2*k+1,2),h[j])
      for ell in range(3):
       if ell!=j:b*=choose(-p[ell]-int(i==ell),h[ell])
      d1=int(i==1);d2=int(i==2)
      if j==0:t=prod(cn((-1)**(2*k+d1+d2+h1+h2)),pw(x,d1+h1),pw(y,d2+h2),pw(c,k-h0),pw(delta,2*k))
      elif j==1:t=prod(cn((-1)**(k+d2+h2)),pw(x,m),pw(y,d2+h2),pw(add(mul(x,c),cn(1)),k-h1),pw(delta,k-d2-h2))
      else:t=prod(pw(y,m),pw(x,d1+h1),pw(add(mul(y,c),cn(1)),k-h2),pw(delta,k-d1-h1))
      terms.append(mul(cn(b),t))
   row.append(divide(add(*terms),mul(cn(g),[delta,x,y][i])))
  Q.append(row)
 roots=[[divide(Q[i][j],[x,y][j-1]) for j in(1,2)]for i in range(3)]
 det=add(prod(Q[0][0],Q[1][1],Q[2][2]),prod(Q[0][1],Q[1][2],Q[2][0]),prod(Q[0][2],Q[1][0],Q[2][1]),neg(prod(Q[0][2],Q[1][1],Q[2][0])),neg(prod(Q[0][1],Q[1][0],Q[2][2])),neg(prod(Q[0][0],Q[1][2],Q[2][1])))
 dc=F(cdet,g**3);assert dc.denominator==1
 assert det==prod(cn(dc),pw(x,m-1),pw(y,m-1),pw(c,k-m),pw(delta,4*k-1))
 L=[[sum(abs(a)*g for root in roots[i] for e,a in root.items() if e[2]==ell)for ell in range(k+1)]for i in range(3)]
 assert L==[list(map(F,expectedL[0])),list(map(F,expectedL[1])),list(map(F,expectedL[1]))]
 name=f'finiteA{k}';constant=[]
 for i in range(3):
  ep=2*k-1 if i==0 else 2*k
  cp=k-m if i==0 else k-m+1
  rest=divide(Q[i][0],prod(pw(delta,ep),pw(c,cp)))
  constant.append(f'(x-y)^{ep}*c^{cp}*({fmt(rest)})')
 src='''import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic

namespace D1Bound5
variable {R : Type*} [CommRing R]
'''
 src+=f'\ndef {name}Constant (x y c : R) : Fin 3 → R :=\n  '+vec(constant)+'\n'
 src+=f'\ndef {name}Left (x y c : R) : Fin 3 → R :=\n  '+vec([fmt(r[0])for r in roots])+'\n'
 src+=f'\ndef {name}Right (x y c : R) : Fin 3 → R :=\n  '+vec([fmt(r[1])for r in roots])+'\n'
 src+=f'''
def {name}DividedMatrix (x y c : R) : Matrix (Fin 3) (Fin 3) R :=
  Matrix.of fun i j => ![{name}Constant x y c i,{name}Left x y c i,{name}Right x y c i] j

def {name}Matrix (x y c : R) : Matrix (Fin 3) (Fin 3) R :=
  {name}DividedMatrix x y c * Matrix.diagonal ![1,x,y]

def {name}RowFactor (x y : R) : Fin 3 → R := ![x-y,x,y]

@[simp] theorem {name}Matrix_zero (x y c : R) (i : Fin 3) :
    {name}Matrix x y c i 0 = {name}Constant x y c i := by
  simp [{name}Matrix,{name}DividedMatrix,Matrix.mul_diagonal]
@[simp] theorem {name}Matrix_one (x y c : R) (i : Fin 3) :
    {name}Matrix x y c i 1 = x*{name}Left x y c i := by
  simp [{name}Matrix,{name}DividedMatrix,Matrix.mul_diagonal,mul_comm]
@[simp] theorem {name}Matrix_two (x y c : R) (i : Fin 3) :
    {name}Matrix x y c i 2 = y*{name}Right x y c i := by
  simp [{name}Matrix,{name}DividedMatrix,Matrix.mul_diagonal,mul_comm]

set_option maxHeartbeats 12000000 in
/-- Exact determinant of the actual integral polynomial matrix. -/
theorem {name}DividedMatrix_det (x y c : R) :
    ({name}DividedMatrix x y c).det = {int(dc)}*(x*y)^{m-2}*c^{k-m}*(x-y)^{4*k-1} := by
  simp [{name}DividedMatrix,{name}Constant,{name}Left,{name}Right,
    Matrix.det_succ_row_zero,Fin.sum_univ_succ,Matrix.submatrix]
  <;> ring

theorem {name}Matrix_det (x y c : R) :
    ({name}Matrix x y c).det = {int(dc)}*(x*y)^{m-1}*c^{k-m}*(x-y)^{4*k-1} := by
  rw [{name}Matrix,Matrix.det_mul,{name}DividedMatrix_det,Matrix.det_diagonal]
  simp [Fin.prod_univ_succ]
  <;> ring

theorem {name}DividedMatrix_det_ne_zero
    {{F : Type*}} [Field F] [CharZero F] (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) :
    ({name}DividedMatrix x y c).det ≠ 0 := by
  rw [{name}DividedMatrix_det]
  norm_num [mul_eq_zero,sub_eq_zero,hx,hy,hc,hxy]

end D1Bound5
'''
 (BASE/f'FiniteA{k}Matrix.lean').write_text(src)
 d0=m+k-2
 coeff=[]
 for ell in range(k+1):
  deg=d0+ell;block=[]
  for i in range(3):
   row=[]
   for j in range(2):
    pp=roots[i][j]
    assert all(e[0]+e[1]==deg for e in pp if e[2]==ell)
    row.append([int(pp.get((r,deg-r,ell),0))for r in range(deg+1)])
   block.append(row)
  coeff.append(block)
 src=f'import D1Bound5.FiniteA{k}Matrix\nimport D1Bound5.FiniteHomogeneousTwo\n\nnamespace D1Bound5\n'
 for ell,block in enumerate(coeff):
  src+=f'\ndef {name}Coeff{ell} : Fin 3 → Fin 2 → Fin {d0+ell+1} → ℤ :=\n  '+vec([vec([vec(v)for v in row])for row in block])+'\n'
 src+=f'\ndef {name}RootCoeff {{R : Type*}} [CommRing R] (x y : R) (i : Fin 3) (j : Fin 2) : Fin {k+1} → R :=\n  '
 src+=vec([f'finiteHomogeneousTwo {d0+ell} ({name}Coeff{ell} i j) x y'for ell in range(k+1)])+'\n'
 src+=f'''
theorem {name}_root_coeff_decomposition {{R : Type*}} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![{name}Left x y c i,{name}Right x y c i] j =
      ∑ ell : Fin {k+1}, {name}RootCoeff x y i j ell*c^(ell : ℕ) := by
  fin_cases i <;> fin_cases j
  all_goals
    norm_num [{name}Left,{name}Right,{name}RootCoeff,
      {','.join(name+'Coeff'+str(ell)for ell in range(k+1))},finiteHomogeneousTwo,Fin.sum_univ_succ]
    <;> ring
'''
 src+=f'\ndef {name}CoefficientSums : Fin 3 → Fin {k+1} → ℤ :=\n  '+vec([vec([int(a/g)for a in row])for row in L])+'\n'
 for ell in range(k+1):
  src+=f'''
theorem {name}_coefficient_sums_{ell} (i : Fin 3) :
    (∑ r, |({name}Coeff{ell} i 0 r : ℝ)|)+
      (∑ r, |({name}Coeff{ell} i 1 r : ℝ)|) = {name}CoefficientSums i {ell} := by
  fin_cases i <;> norm_num [{name}Coeff{ell},{name}CoefficientSums,Fin.sum_univ_succ]
'''
 src+='\nend D1Bound5\n';(BASE/f'FiniteA{k}Coefficients.lean').write_text(src)
 (BASE/f'a{k}_coefficients.json').write_text(json.dumps(dict(k=k,m=m,g=g,Q=[[[[list(e),int(a)]for e,a in sorted(p.items())]for p in row]for row in Q],L=[[int(a)for a in row]for row in L]),indent=2)+'\n')
 print(f'A{k}: det={int(dc)}*(xy)^{m-1}*c^{k-m}*delta^{4*k-1}; exact coefficients and table PASS')

if __name__=='__main__':
 family(3,2,4,-156800,[[800,4544,10368,6144],[1288,4256,9856,8960]])
 family(4,3,2,23284800,[[10944,86784,350208,482304,215040],[18128,80512,276096,561920,327680]])
 family(5,4,4,-3995671680,[[156000,1601280,9707520,22379520,22087680,7864320],[262152,1463264,6707712,22437888,28452864,12300288]])
