exec(open('ordinary_m_next/compute_rows.py').read().split('rows=[]')[0])
from itertools import permutations

def RR(u,v):
 return [-(u-v)**3*(30+100*(u+v)*c+24*(3*u*u+4*u*v+3*v*v)*c*c),
  7*u*u-35*u*v+(64*u**3-140*u*u*v)*c+(72*u**4-120*u**3*v)*c*c,
  35*u*v-7*v*v+(140*u*v*v-64*v**3)*c+(120*u*v**3-72*v**4)*c*c]
def TT(u,v):
 return [(u-v)**3*(15*(5*u-v)+100*u*(3*u+v)*c+24*(10*u**3+6*u*u*v+3*u*v*v+v**3)*c*c),
  -15*u**3+56*u*u*v-105*u*v*v+(-180*u**4+512*u**3*v-420*u*u*v*v)*c+(-240*u**5+576*u**4*v-360*u**3*v*v)*c*c,
  70*u*v*v-6*v**3+(100*u*v**3-12*v**4)*c+24*v**5*c*c]
rab=RR(a,b);ras=RR(a,s);rbs=RR(b,s);tab=TT(a,b);tas=TT(a,s);tbs=TT(b,s)
M=[rab+[P(0)], [rab[0]+rbs[0]-ras[0],rab[1]-ras[1],rab[2]+rbs[1],rbs[2]-ras[2]],tab+[P(0)],[tas[0]-tbs[0],tas[1],-tbs[1],tas[2]-tbs[2]]]
det=P()
for p in permutations(range(4)):
 v=P((-1)**sum(p[i]>p[j] for i in range(4) for j in range(i+1,4)))
 for i in range(4):v*=M[i][p[i]]
 det+=v
want=-78750*a*b*s*(a-b)**5*(a-s)*(b-s)*(7*(2*s-a-b)+6*c*(3*s*s-(a+b)*s-a*b))
assert not (det-want).d
print('PASS exact sparse integer-polynomial determinant identity:',len(det.d),'monomials')
