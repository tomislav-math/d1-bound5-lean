"""Exact symbolic derivation of the fixed-edge determinant identity.

Exploratory alternative, not the recommended manuscript proof.
"""
from pathlib import Path
from hashlib import sha256
import sympy as S
import json
ROOT=Path(__file__).resolve().parents[2]
digest=sha256((ROOT/'upload/D1_bound5-v1(1).tex').read_bytes()).hexdigest()
assert digest=='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
p,q,r,x,y,z=S.symbols('p q r x y z')
M=S.Matrix([[1,1+p,1+q,1+x],[1+p,1,1+r,1+y],[1+q,1+r,1,1+z],[1+x,1+y,1+z,1]])
linear=[-2*r*(p+q-r),-2*q*(p-q+r),-2*p*(-p+q+r)]
H=S.Matrix([[r*(r+2),p-q-r-q*r,q-p-r-p*r],
            [p-q-r-q*r,q*(q+2),r-p-q-p*q],
            [q-p-r-p*r,r-p-q-p*q,p*(p+2)]])
v=S.Matrix([x,y,z])
polynomial=2*p*q*r+sum(linear[i]*v[i] for i in range(3))+(v.T*H*v)[0]
assert S.expand(M.det()-polynomial)==0
a,b,c,t=S.symbols('a b c t')
base=(a+b+c+2*a*b*c)**2-4*(a*b+1)*(a*c+1)*(b*c+1)
assert S.expand(base-(c*c-2*(a+b)*c+(a-b)**2-4))==0
result={'sha256':digest,'fixed_edge_identity_verified':True,
        'mutation_product_verified':True,'linear_coefficients':[str(v) for v in linear],
        'quadratic_matrix':[[str(H[i,j]) for j in range(3)] for i in range(3)],
        'normalized_leading_coefficient':str(2*p*q*r)}
(ROOT/'comments_v1/determinants/terminal_identity.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
