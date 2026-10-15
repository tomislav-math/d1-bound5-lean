"""Exact verification of the uniform fourth-entry estimate used in S<15.
This is an improvement proposal, not part of the frozen manuscript.
"""
from one_small import *

def determinant_constants():
    edges=[(0,1),(0,2),(0,3),(1,2),(1,3),(2,3)]
    rad=dict(zip(edges,[F(1,3),F(1,15),F(1,90),F(1,45),F(1,270),F(1,1350)]))
    ks=dict(zip(edges,[F(v,10000) for v in [5506,5087,5014,5029,5005,5001]]))
    k=lambda i,j:ks[tuple(sorted((i,j)))]
    for e in edges:
        require(F(1,2)<ks[e]<1 and rad[e]*ks[e]**2<2*ks[e]-1,f'rationalization {e}')
    W=F(1,4050)
    alpha=2*k(0,1)*k(0,2)*k(1,2)
    beta=2*k(1,2)*k(1,3)*k(2,3)*3*W+F(1,450)*2*k(0,2)*k(0,3)*k(2,3)+F(1,18)*2*k(0,1)*k(0,3)*k(1,3)
    for i,j in edges:
        l,m=[z for z in range(4) if z not in [i,j]]
        cc=2*(k(i,j)*(k(i,l)*k(j,m)+k(i,m)*k(j,l))+k(i,j)**2*k(l,m))-F(1,2)
        beta+=cc*rad[i,j]
    beta+=(k(0,1)*k(2,3)+k(0,2)*k(1,3)+k(0,3)*k(1,2))**2*W
    require(alpha<F(141,500) and beta<F(21,125),'universal simple constants')
    require(F(141,500)*F(59,20)+F(21,125)==F(9999,10000),'tau contradiction')
    print('alpha =',alpha,'<141/500; beta =',beta,'<21/125')
    print('UNIFORM T > (59/20)ABS for A<3, B>=3, S>=15 PASSED')
    return alpha,beta

def all41():
    output=[]
    for i,d,a,b in [(i,*v) for i,v in pairs.items()]+[('rational',1,(1,0),(3,0))]:
        R=Ring(d);M,tau,K,G,rho,qs=s15(R,a,b)
        factor=(F(59,20)/tau)**5
        G*=factor;rho*=factor
        na=R.norm(a);nb=R.norm(b);nab=R.norm(R.sub(a,b))
        A1=ceilroot(na,8);B0=floorroot(nb,8)
        rs=[old*F(101,200)*F(nab,4*nb)**k for name,k,m,g,old in families]
        Rp=max(adaptive(A1/B0))
        qs=quotients(1,nb,225,G,rho,M,rs,Rp,start=9604,second=784)
        require(min(qs)>F(59,50),f'uniform margin59/50 {i}')
        require(G*B0*15**3/105>1,f'tail {i}')
        output.append({'pair':i,'min':str(min(qs)),'min_decimal':float(min(qs)),'junction':qs.index(min(qs)),'M':M})
        print('PAIR',i,'min quotient',float(min(qs)),'at',qs.index(min(qs)))
    (OUT/'one_small_uniform_results.json').write_text(json.dumps(output,indent=2))
    print('ALL 615 EXACT OVERLAP INEQUALITIES > 59/50; ALL 41 TAIL CHECKS PASSED')

if __name__=='__main__':
    determinant_constants();all41()
