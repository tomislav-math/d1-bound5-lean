import sympy as s
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
import json
x=s.symbols('x');R=s.Rational
L=[(5*x+10*x**2+10*x**4+5*x**5)/256,10*(x+x**4+x**5)/256,(15+80*x+150*x**2+120*x**3+35*x**4)/256,(15+80*x+150*x**2+280*x**3+35*x**4)/256]
W=[295*x+143*x**2+143*x**4+295*x**5,590*(x+x**4+x**5),885+1144*x+435*x**2+42*x**3+170*x**4,885+1144*x+435*x**2+2634*x**3+170*x**4]
# Each certificate is a sum c*x^n*(1-x^j), with j=0 meaning c*x^n.
# Coefficients c and exponents n are nonnegative; j is 0,1,or2.
# Thus every term is nonnegative for 0<=x<=1.
Lc=[[(15,0,0),(75,1,0),(140,2,0),(280,3,0),(20,4,0),(5,4,1)],[(15,0,0),(70,1,0),(150,2,0),(280,3,0),(15,4,0),(10,4,1)],[(160,3,0)]]
Wc=[[(885,0,0),(849,1,0),(292,2,0),(2339,3,0),(27,4,0),(295,3,2)],[(885,0,0),(554,1,0),(435,2,0),(1624,3,0),(420,3,1),(590,3,2)],[(2592,3,0)]]
def form(cert):return sum(co*x**n*((1-x**j) if j else 1) for co,n,j in cert)
results=[]
for index,name in enumerate(['R_ab','H','T_ab']):
 for kind,polys,certs,scale in [('L',L,Lc,256),('W',W,Wc,1)]:
  cert=certs[index]
  ok=s.expand(scale*(polys[3]-polys[index])-form(cert))==0 and all(co>=0 and n>=0 and j in (0,1,2) for co,n,j in cert)
  results.append({'difference':f'{scale}({kind}_V-{kind}_{name})','passed':ok,'nonnegative_terms':cert,'expanded_difference':str(s.expand(scale*(polys[3]-polys[index])))})
  print('PASS' if ok else 'FAIL',results[-1])
assert all(q['passed'] for q in results)
tau=R(21,1024*999)
assert L[3].subs(x,1)+tau*W[3].subs(x,1)==R(65233,28416)
(ROOT / 'audit/checks/approximation_v_dominance.json').write_text(json.dumps({'domain':'0<=x<=1','meaning_of_terms':'(co,n,j) denotes co*x^n when j=0 and co*x^n*(1-x^j) otherwise. Each is nonnegative on the domain.','certificates':results,'consequence':'For every q>=1, mathcal R(q)=L_V(1/q)+tau W_V(1/q).','at_q_1':'65233/28416'},indent=2))
print('All six symbolic dominance identities passed, including nonnegativity certificates.')
