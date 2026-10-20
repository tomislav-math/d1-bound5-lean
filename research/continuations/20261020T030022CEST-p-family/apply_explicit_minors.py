"""Replace only the P determinant proof by exact explicit cofactor identities."""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, json, difflib
root=Path('/Users/tp/Lean/D1Bound5'); out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def rc(u,v): return f'(-({u}-{v})^3*(30+100*({u}+{v})*c+24*(3*{u}^2+4*{u}*{v}+3*{v}^2)*c^2))'
def tc(u,v): return f'(({u}-{v})^3*(15*(5*{u}-{v})+100*{u}*(3*{u}+{v})*c+24*(10*{u}^3+6*{u}^2*{v}+3*{u}*{v}^2+{v}^3)*c^2))'
def rl(u,v): return f'((7*{u}^2-35*{u}*{v})+(64*{u}^3-140*{u}^2*{v})*c+(72*{u}^4-120*{u}^3*{v})*c^2)'
def rr(u,v): return f'((35*{u}*{v}-7*{v}^2)+(140*{u}*{v}^2-64*{v}^3)*c+(120*{u}*{v}^3-72*{v}^4)*c^2)'
def tl(u,v): return f'((-15*{u}^3+56*{u}^2*{v}-105*{u}*{v}^2)+(-180*{u}^4+512*{u}^3*{v}-420*{u}^2*{v}^2)*c+(-240*{u}^5+576*{u}^4*{v}-360*{u}^3*{v}^2)*c^2)'
def tr(u,v): return f'((70*{u}*{v}^2-6*{v}^3)+(100*{u}*{v}^3-12*{v}^4)*c+(24*{v}^5)*c^2)'
M=[[rc('a','b'),rl('a','b'),rr('a','b'),'0'],
   [f"({rc('a','b')}+{rc('b','s')}-{rc('a','s')})",f"({rl('a','b')}-{rl('a','s')})",f"({rr('a','b')}+{rl('b','s')})",f"({rr('b','s')}-{rr('a','s')})"],
   [tc('a','b'),tl('a','b'),tr('a','b'),'0'],
   [f"({tc('a','s')}-{tc('b','s')})",tl('a','s'),f"(-{tl('b','s')})",f"({tr('a','s')}-{tr('b','s')})"]]
def determinant3(rows):
 A=[M[i][:3] for i in rows]
 return f'{A[0][0]}*{A[1][1]}*{A[2][2]} - {A[0][0]}*{A[1][2]}*{A[2][1]} - {A[0][1]}*{A[1][0]}*{A[2][2]} + {A[0][1]}*{A[1][2]}*{A[2][0]} + {A[0][2]}*{A[1][0]}*{A[2][1]} - {A[0][2]}*{A[1][1]}*{A[2][0]}'
g1='3840*a^2*b^2*c^5*s^4 + 4608*a^2*b^2*c^4*s^3 + 864*a^2*b^2*c^3*s^2 - 96*a^2*b^2*c^2*s + 18*a^2*b^2*c + 4480*a^2*b*c^4*s^4 + 5376*a^2*b*c^3*s^3 + 1008*a^2*b*c^2*s^2 - 112*a^2*b*c*s + 21*a^2*b + 1120*a^2*c^3*s^4 + 1344*a^2*c^2*s^3 + 252*a^2*c*s^2 - 28*a^2*s + 4480*a*b^2*c^4*s^4 + 5376*a*b^2*c^3*s^3 + 1008*a*b^2*c^2*s^2 - 112*a*b^2*c*s + 21*a*b^2 + 4480*a*b*c^3*s^4 + 5376*a*b*c^2*s^3 + 1008*a*b*c*s^2 - 112*a*b*s + 840*a*c^2*s^4 + 1008*a*c*s^3 + 189*a*s^2 + 1120*b^2*c^3*s^4 + 1344*b^2*c^2*s^3 + 252*b^2*c*s^2 - 28*b^2*s + 840*b*c^2*s^4 + 1008*b*c*s^3 + 189*b*s^2 + 70*c*s^4 + 84*s^3'
g3='9216*a^2*b^2*c^6*s^4 + 15360*a^2*b^2*c^5*s^3 + 6912*a^2*b^2*c^4*s^2 + 576*a^2*b^2*c^3*s - 24*a^2*b^2*c^2 + 10752*a^2*b*c^5*s^4 + 17920*a^2*b*c^4*s^3 + 8064*a^2*b*c^3*s^2 + 672*a^2*b*c^2*s - 28*a^2*b*c + 2688*a^2*c^4*s^4 + 4480*a^2*c^3*s^3 + 2016*a^2*c^2*s^2 + 168*a^2*c*s - 7*a^2 + 10752*a*b^2*c^5*s^4 + 17920*a*b^2*c^4*s^3 + 8064*a*b^2*c^3*s^2 + 672*a*b^2*c^2*s - 28*a*b^2*c + 10752*a*b*c^4*s^4 + 17920*a*b*c^3*s^3 + 8064*a*b*c^2*s^2 + 672*a*b*c*s - 28*a*b + 2016*a*c^3*s^4 + 3360*a*c^2*s^3 + 1512*a*c*s^2 + 126*a*s + 2688*b^2*c^4*s^4 + 4480*b^2*c^3*s^3 + 2016*b^2*c^2*s^2 + 168*b^2*c*s - 7*b^2 + 2016*b*c^3*s^4 + 3360*b*c^2*s^3 + 1512*b*c*s^2 + 126*b*s + 168*c^2*s^4 + 280*c*s^3 + 126*s^2'
f1=f'(-750*a*b*(a-b)^4*({g1}))'; f3=f'(-375*a*b*(a-b)^4*({g3}))'
proof=f'''  have h1 : ((finitePDividedMatrix a b s c).submatrix
      (1 : Fin 4).succAbove (3 : Fin 4).succAbove).det = {f1} := by
    rw [Matrix.det_fin_three]
    change {determinant3([0,2,3])} = _
    ring
  have h3 : ((finitePDividedMatrix a b s c).submatrix
      (3 : Fin 4).succAbove (3 : Fin 4).succAbove).det = {f3} := by
    rw [Matrix.det_fin_three]
    change {determinant3([0,1,2])} = _
    ring
  rw [finiteP_sparse_column_det _ (by rfl) (by rfl), h1, h3]
  change {M[1][3]}*{f1}+{M[3][3]}*{f3} =
    -78750*a*b*s*(a-b)^5*(a-s)*(b-s)*(7*(2*s-a-b)+6*c*(3*s^2-(a+b)*s-a*b))
  ring
'''
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 act=json.loads((work/'continuation-active.json').read_text());assert not act.get('active') and not act.get('protected_closure')
 p=root/'D1Bound5/FinitePMatrix.lean';old=p.read_text();assert old==(out/'wave03/FinitePMatrix.lean').read_text()
 start=old.index('  rw [finiteP_sparse_column_det',old.index('theorem finitePDividedMatrix_det'))
 end=old.index('\ntheorem finitePMatrix_det',start)
 new=old[:start]+proof+old[end:]
 (out/'FinitePMatrix-before-explicit-minors.lean').write_text(old);p.write_text(new)
 (out/'REPAIR04-P-explicit-minors.md').write_text('# Explicit P cofactor proof\n\n'+datetime.now().astimezone().isoformat()+'\n\nReplace the failing global simplifier by two explicit cofactor polynomial identities and their final product identity. Each coordinate expansion is required to match by Lean definitional equality via change. Each cofactor factorization and the final determinant are proved with ring in the original arbitrary commutative ring. Generated expressions are only candidates until pinned compilation and kernel checking pass. No resource setting, public statement or original matrix definition is changed.\n')
 print('EXPLICIT_COFACTOR_PROOF_SAVED',hashlib.sha256(new.encode()).hexdigest(),'chars',len(proof))
