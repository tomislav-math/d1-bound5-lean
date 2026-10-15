#!/usr/bin/env python3
"""Actual-v2 Sections 8–9 checks. Recompute coefficients, lists and cutoffs.
No prior result file or polynomial cache is read. No manuscript writes.
"""
import one_small_core as core
from one_small_core import *
from itertools import permutations

def fourth_gap():
    edges=[(0,1),(0,2),(0,3),(1,2),(1,3),(2,3)]
    radii=dict(zip(edges,[F(1,3),F(1,15),F(1,90),F(1,45),F(1,270),F(1,1350)]))
    ks=dict(zip(edges,[F(x,10000) for x in (5506,5087,5014,5029,5005,5001)]))
    k=lambda i,j:ks[tuple(sorted((i,j)))]
    for e in edges:require(F(1,2)<ks[e]<1 and radii[e]*ks[e]**2<2*ks[e]-1,'six rationalization inequalities')
    # Expand det(J+E) in six variables, directly by the 24 permutations.
    poly={}
    for p in permutations(range(4)):
        sign=(-1)**sum(p[i]>p[j] for i in range(4) for j in range(i+1,4))
        terms={(0,)*6:sign}
        for i,j in enumerate(p):
            if i==j:continue
            idx=edges.index(tuple(sorted((i,j))));nextterms=dict(terms)
            for ex,v in terms.items():
                ne=list(ex);ne[idx]+=1;ne=tuple(ne);nextterms[ne]=nextterms.get(ne,0)+v
            terms=nextterms
        for ex,v in terms.items():poly[ex]=poly.get(ex,0)+v
    poly={ex:v for ex,v in poly.items() if v}
    require(all(sum(ex) in (3,4) for ex in poly),'determinant has only cubic/quartic terms')
    require(sum(1 for ex in poly if sum(ex)==3)==22,'four triangles+twelve paths+six repeated-edge cubic monomials')
    # Leading cubic normalization: multiply by ab s t after setting Eij=1/(2ai aj).
    lead={}
    for ex,v in poly.items():
        if sum(ex)!=3:continue
        power=[1]*4
        for (i,j),e in zip(edges,ex):power[i]-=e;power[j]-=e
        key=tuple(power);lead[key]=lead.get(key,F(0))+F(v,8)
    expected={tuple(1 if i==j else -1 for i in range(4)):F(1,4) for j in range(4)}
    expected.update({tuple(-1 if i in e else 0 for i in range(4)):F(-1,4) for e in edges})
    lead={ex:v for ex,v in lead.items() if v}
    require(lead==expected,'exact signed leading cubic')
    W=F(1,4050);alpha=2*k(0,1)*k(0,2)*k(1,2)
    beta=6*k(1,2)*k(1,3)*k(2,3)*W+2*k(0,2)*k(0,3)*k(2,3)/450+2*k(0,1)*k(0,3)*k(1,3)/18
    defects=[]
    for i,j in edges:
        ell,m=[z for z in range(4) if z not in (i,j)]
        cc=2*(k(i,j)*(k(i,ell)*k(j,m)+k(i,m)*k(j,ell))+k(i,j)**2*k(ell,m))-F(1,2)
        require(cc>0,'all defect coefficients positive')
        defects.append(str(cc));beta+=cc*radii[i,j]
    beta+=(k(0,1)*k(2,3)+k(0,2)*k(1,3)+k(0,3)*k(1,2))**2*W
    require(alpha<F(141,500) and beta<F(21,125),'common tau constants')
    require(F(141,500)*F(59,20)+F(21,125)==F(9999,10000),'strict tau contradiction')
    return dict(alpha=str(alpha),beta=str(beta),defects=defects,determinant_terms=[dict(exponents=ex,coefficient=v) for ex,v in poly.items()])

def fixed41():
    output=[];tau=F(59,20)
    for i,d,a,b in [(i,*row) for i,row in pairs.items()]+[('rational',1,(1,0),(3,0))]:
        R=Ring(d);na=R.norm(a);nb=R.norm(b);nab=R.norm(R.sub(a,b))
        M=fixed_coeff(R,a,b)
        printed=fixed[i] if i!='rational' else [12,41,25,300,1100]
        require(M==printed if i!='rational' else all(x<=y for x,y in zip(M,printed)),f'actual source coefficient tuple {i}')
        A1=ceilroot(na,8);B0=floorroot(nb,8);B1=ceilroot(nb,8)
        Q0=ceilroot(F(nab,nb),8)*(1+A1/15)*(1+B1/15)
        require(1/Q0>mu/nb,'positive fixed-pair gap coefficient')
        K=F(9999,100)*na*(1/Q0-mu/nb)**2;G=K*tau**5
        require(K>F(7,4),'K>7/4 each41')
        H=F(9999,100)*na*tau**5*(1-mu*Q0/nb)**2
        F0=F(nab,nb)*(1+A1/15)**2*(1+B1/15)**8;rho=H/(kap*F0)
        require(B0/A1>2,'adaptive pair ratio>2')
        Rs=[old*F(101,200)*F(nab,4*nb)**k for _,k,_,_,old in families]
        Rp=max(adaptive(A1/B0));require(Rp==adaptive(A1/B0)[3],'combined V dominates residual')
        qs=quotients(1,nb,225,G,rho,printed,Rs,Rp,start=9604,second=784)
        require(min(qs)>F(59,50),'every41 pair every15 margin')
        tail=G*B0*15**3/105;require(tail>1,'every41 infinite tail')
        output.append(dict(pair=i,coefficient_minima=M,printed=printed,K=str(K),G=str(G),rho=str(rho),quotients=[str(q) for q in qs],minimum=str(min(qs)),tail=str(tail)))
    return output

def least(c,p):
    low=0;high=1
    while c*high**p<=1:high*=2
    while high-low>1:
        mid=(low+high)//2
        if c*mid**p>1:high=mid
        else:low=mid
    require(c*high**p>1 and c*(high-1)**p<=1,'minimal strict threshold')
    return high

def cutoff(R,a,b,s,M):
    na,nb,ns=map(R.norm,(a,b,s));dab=R.norm(R.sub(a,b));das=R.norm(R.sub(a,s));dbs=R.norm(R.sub(b,s))
    q1=ceilroot(F(dab*das*dbs,nb*ns*ns),10)
    require(1/q1>mu/nb,'fixed-triple positive difference')
    K=F(9999,100)*na*(1/q1-mu/nb)**2;require(K>1,'fixed-triple K>1')
    phi=ceilroot(max(F(dbs**6,ns**6),F(nb*dbs**5,ns**6)),10);Rbs=kap*phi
    M2,Mn,M3,M4,M5=M;Mbs=fixed_coeff(R,b,s)[1]
    R2,Rn,R3,R4,R5=[old*F(101,200)*F(dab,4*nb)**k for _,k,_,_,old in families]
    Rp=max(adaptive(1/floorroot(F(nb,na),10)))
    cs=[((1-eps)*K**4/(12100*ns**5),5),
      (K**2/(36*M2**2*nb**4*ns**2*h),4),
      (K**2/(16*R2**2*2400**2*nb**3*ns**5*h),5),
      (K**2/(16*R2**2*2400**2*nb**5*ns**4*h),5),
      (K**2/(16*Rp**2*M3**2*nb**6*ns**4*h),5),
      (K**4/(16*R3**2*Mm**2*nb**6*ns**12*h),10),
      (K**4/(16*Rm**2*Mn**2*nb**9*ns**9*h),10),
      (K**4/(16*Rn**2*Mbs**2*nb**3*ns**11*h),10),
      (K**2/(16*Rbs**2*M4**2*nb**5*ns**5*h),5),
      (K**4/(144*R4**2*42**8*nb**15*ns**4*h),10),
      (F(2,5)**8*K**4/(4*M5**2*nb**16*ns**4*h),10),
      (K**6/(144*R5**2*42**10*nb**19*ns**6*h),15),
      (F(2,5)**10*K**6/(36*42**12*nb**22*ns**6*h),15)]
    thresholds=[least(c,p) for c,p in cs]
    ntail=least(K*K/(105**2*nb**4*ns**2),5)
    eta=1 if na==1 else 4*na*nb*ns+1
    N0=max(1024,ntail,*thresholds,eta)
    return dict(q1=str(q1),K=str(K),Mbs=Mbs,thresholds=thresholds,ntail=ntail,eta=eta,N0=N0,quotients=[str(c*N0**p) for c,p in cs])

def complement(R,b,s,ns,N0):
    nb=R.norm(b);tail=4*nb*ns
    if tail>=N0:return dict(method='tail',tail=tail)
    q=R.add(b,s);hh=R.add((1,0),R.mul((2,0),R.mul(b,s)));delta=R.sub(R.power(R.sub(b,s),2),(4,0))
    nq,nh,nd=map(R.norm,(q,hh,delta))
    A=2*(floorroot(nh,10)-ceilroot(nq,10));B=ceilroot(nd,10)+2*ceilroot(nq,10)+1
    require(A>0,'quadratic lower linear coefficient')
    bound=F(N0)-A*floorroot(N0,10)+B
    if bound<-100:return dict(method='quadratic',tail=tail,norms=[nq,nh,nd],upper=str(bound))
    require((R.d,b,ns,N0)==(2,(-3,0),12,1024),'exact exceptional pair only')
    require(s in [(-2,-2),(-2,2)],'exact exceptional third only')
    require((nq,nh,nd)==(33,457,153),'exceptional norms')
    require(F(213,10)**2<457 and F(29,5)**2>33 and F(62,5)**2>153,'exceptional exact radical bounds')
    require(901-60*F(213,10)+62*F(29,5)+F(62,5)==-5,'f(30)<-5')
    residues={(u*u+2*v*v)%16 for u in range(16) for v in range(16)}
    require(14 not in residues and 15 not in residues,'annulus30,31 mod16')
    require(all(u%4==0 and v%4==0 for u in range(16) for v in range(16) if (u*u+2*v*v)%16==0),'annulus32 divisibility by4')
    solutions=[(u,v) for u in range(-5,6) for v in range(-4,5) if u*u+2*v*v==32]
    require(solutions==[(0,-4),(0,4)],'annulus32 root list')
    return dict(method='quadratic+annulus',tail=tail,norms=[nq,nh,nd],f30_upper='-5',residues=sorted(residues),solutions32=solutions)

if __name__=='__main__':
    print('SOURCE',SOURCE_HASH,flush=True)
    report=dict(source_sha256=SOURCE_HASH)
    triples=inventory();report['triples_before_exclusion']=len(triples)
    report['regions']=regions()
    report['fourth_gap']=fourth_gap()
    report['fixed41']=fixed41()
    table=TEX.split('All remaining triples and the common cutoff procedure.')[1].split('\\end{longtable}')[0]
    rows=[]
    for m in re.finditer(r'^(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) \\\\',table,re.M):
        i,x,y,ns,mbs,n0=map(int,m.groups());d,a,b=pairs[i];R=Ring(d);s=(x,y)
        require(R.norm(s)==ns,'source final third norm')
        data=cutoff(R,a,b,s,fixed[i]);require(data['Mbs']==mbs and data['N0']==n0,f'source printed Mbs/N0 {i,s}')
        data.update(pair=i,s=s,snorm=ns,complement=complement(R,b,s,ns,n0));rows.append(data)
    require(len(rows)==56,'six-column final table exactly56')
    report['fixed56']=rows
    methods={kind:sum(z['complement']['method']==kind for z in rows) for kind in ('tail','quadratic','quadratic+annulus')}
    require(list(methods.values())==[38,16,2],'new finite complement partition')
    report['completion_counts']=methods
    rational=cutoff(Ring(1),(1,0),(3,0),(8,0),[12,41,25,300,1100])
    require(rational['q1']=='1822916667/5000000000' and F(rational['K'])>744,'rational q1 K')
    require(rational['Mbs']==34 and rational['N0']==1024,'rational Mbs cutoff')
    require(rational['thresholds']==[3,23,96,101,108,179,131,9,34,76,123,29,438] and rational['ntail']==14,'all rational thresholds')
    require([s for s in range(4,15) if isqrt(s+1)**2==s+1 and isqrt(3*s+1)**2==3*s+1]==[8],'rational third8')
    require(32<2*3*8,'rational tail contradiction')
    report['rational']=rational
    report['minimum_41_overlap']=str(min(F(z['minimum']) for z in report['fixed41']))
    report['maximum_quadratic_upper']=str(max(F(z['complement']['upper']) for z in rows if z['complement']['method']=='quadratic'))
    require(hashlib.sha256(SOURCE.read_bytes()).hexdigest()==SOURCE_HASH,'source unchanged during run')
    report['checks']=core.COUNTER
    (OUT/'one_small_v2_results.json').write_text(json.dumps(report,indent=2))
    print('PASS',core.COUNTER,'exact checks')
    print('41-pair minimum overlap',report['minimum_41_overlap'],'>',F(59,50))
    print('All56 Mbs/N0 reproduced, maximumN0',max(z['N0'] for z in rows),'and rational N0',rational['N0'])
    print('Completion partition',methods,'max upper',report['maximum_quadratic_upper'])
