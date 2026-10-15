#!/usr/bin/env python3
"""Independent endpoint algebra for the proposed P-only chain; no article writes."""
from pathlib import Path
from fractions import Fraction as F
import hashlib, json, re

ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).resolve().parent
SRC=ROOT/'upload/D1_bound5-v1(1).tex'
SHA='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
assert hashlib.sha256(SRC.read_bytes()).hexdigest()==SHA
original=SRC.read_text()
checks=[]
def check(name, flag):
    assert flag, name
    checks.append(name)

# Monomials in A,B,S,T,C, constructed directly from the printed endpoint table.
class M:
    def __init__(self,c=1,**p):
        self.c=F(c); self.p={k:v for k,v in p.items() if v}
    def __mul__(self,o):
        p=self.p.copy()
        for k,v in o.p.items():p[k]=p.get(k,0)+v
        return M(self.c*o.c,**p)
    def __pow__(self,n):return M(self.c**n,**{k:v*n for k,v in self.p.items()})
    def __truediv__(self,o):return self*o**-1
    def sub(self,k,o):
        p=self.p.copy();n=p.pop(k,0)
        return M(self.c,**p)*o**n
    def low(self,k,o):
        assert self.p.get(k,0)>0
        return self.sub(k,o)
    def upper(self,k,o):
        assert self.p.get(k,0)<0
        return self.sub(k,o)
    def at3(self):
        assert set(self.p)<=set('ABS') and all(v>=0 for v in self.p.values())
        return self.c*3**sum(self.p.values())
    def record(self):return {'coefficient':str(self.c),'powers':self.p,'lower_at_3':str(self.at3())}

eps=F(1,4000); h=F(4001,3999)
Mn,M3,M4,M5=4143,2265,166000,26859063
Rn,R3,R4,R5=F(35,32),F(35,16),F(63,8),F(495,64)
Mm,Rm=F(8,9)*608**2,F(3920,81)
L={
 'Q':M(4*55**2,T=6,C=3),
 'N2':M(4*735**2,B=8,C=5),
 'P_BS3':M(4*2400**2,B=2,S=6,C=5),
 'P_B3S2':M(4*2400**2,B=6,S=4,C=5),
 'A3':M(4*M3**2,B=12,C=7),
 'M':M(4*Mm**2,B=6,S=16,C=5),
 'N3':M(4*Mn**2,B=14,C=7),
 'N3bs':M(4*Mn**2,S=14,C=7),
 'A4':M(4*M4**2,B=18,C=9),
 'A5':M(4*M5**2,B=24,C=11),
}
U={
 'Q':M(F(1,9),A=4,C=7,T=-2),
 'N2':M(F(4,25),A=6,C=7,B=-4),
 'P':M(F(1,4*3**2),A=6,C=9,S=-4),
 'A3':M(1/(4*R3**2),A=8,C=9,B=-6),
 'M':M(1/(4*Rm**2),A=6,C=11,B=-4,S=-10),
 'N3':M(1/(4*Rn**2),A=8,C=11,B=-6),
 'N3bs':M(1/(4*Rn**2),B=8,C=11,S=-6),
 'A4':M(1/(4*R4**2),A=10,C=13,B=-8),
 'A5':M(1/(4*R5**2),A=12,C=17,B=-10),
}
for j in [4,5,6]:
    L['O'+str(j)]=M(36*42**(2*j),B=6*j-2,C=2*j+1)
    U['O'+str(j)]=M(F(2,5)**(2*j),A=2*j,C=4*j-1,B=-2*j)
def raw(a,b):return U[a]/L[b]/M(h)

# Check the residue constant directly from all four printed polynomials at x=1.
tau=F(21,1024*999)
res=[F(30,256)+tau*876,F(30,256)+tau*1770,
     F(400,256)+tau*2676,F(560,256)+tau*5268]
check('R(1) is V and is below 3',max(res)==F(65233,28416)<3)
check('rank contradiction',6*200>7*(2+1+1))

variants={}
agent_results=json.loads((ROOT/'comments_v1/approximation/results.json').read_text())
for K in [54,400]:
    gap=M(K,A=7,B=5,S=3)
    def coarse(a,b):return raw(a,b).low('C',gap)
    ratios={}
    G=M(A=2,C=7,S=-2,T=-4)
    ratios['start-Q']=(G/L['Q']*M(1-eps)).low('C',M(A=2,T=5,S=-2)).low('T',M(2,A=1,B=1,S=1))
    ratios['Q-N2']=raw('Q','N2').low('C',M(A=2,T=5,S=-2)).low('T',M(2,A=1,B=1,S=1))
    ratios['N2-P-BS3']=coarse('N2','P_BS3')
    ratios['N2-P-B3S2']=coarse('N2','P_B3S2')
    ratios['P-N3']=coarse('P','N3').low('S',M(B=2))
    ratios['P-A3']=coarse('P','A3').low('S',M(B=1))
    ratios['A3-M']=coarse('A3','M').upper('S',M(B=2))
    ratios['M-N3']=coarse('M','N3')
    ratios['N3-A4']=coarse('N3','A4').low('S',M(B=3))
    ratios['N3-N3bs']=coarse('N3','N3bs').upper('S',M(B=3))
    if K==400:
        ratios['N3bs-A4']=coarse('N3bs','A4')
    else:
        # C > beta*A^7 B^5 S^3/Q^2, R_bs=kappa*Phi and Q^2*Phi<=phase.
        beta=3456; kappa=F(3535,409600);phase=F(8,5)**4*F(12,5)**6
        ratios['N3bs-A4']=M(F(beta**2)/(16*kappa**2*phase**2*M4**2*h),A=14)
    for a,b in [('A4','O4'),('O4','A5'),('A5','O5'),('O5','O6')]:
        ratios[a+'-'+b]=coarse(a,b).low('S',M(B=1))
    check(f'K{K}: exactly 15 comparisons',len(ratios)==15)
    for name,m in ratios.items():check(f'K{K}: {name}',m.at3()>1)
    got={k:str(v.at3()) for k,v in ratios.items()}
    check(f'K{K}: agrees with separately authored checker',got==agent_results['variants'][f'K{K}_P_only_clean']['ratios'])
    tail=M(F(1,105),A=1,C=1,B=-4).low('C',gap)
    check(f'K{K}: ordinary tail grows',tail.at3()>1)
    variants[str(K)]={'ratios':{k:v.record() for k,v in ratios.items()},'ordinary_tail':tail.record()}

proposal_controls={}
for name in ['current','with_P02']:
    base=original
    if name=='with_P02':
        for e in json.loads((ROOT/'review_v1/agents/P02_combined.json').read_text())['edits']:
            check('P02 unique old string',base.count(e['old'])==1)
            base=base.replace(e['old'],e['replacement'])
    candidate=base
    pp=json.loads((ROOT/f'comments_v1/approximation/{name}_proposal.json').read_text())
    for e in pp['edits']:
        check(name+' unique old string',candidate.count(e['old'])==1)
        candidate=candidate.replace(e['old'],e['replacement'])
    for stale in ['eq:ff-p0rows','eq:ff-p0det','eq:ff-P0','eq:ff-allSrank']:
        check(name+' absent obsolete label '+stale,stale not in candidate)
    sec6=candidate.split('\\section{Exclusion when every entry',1)[1].split('\\section{Tuples with',1)[0]
    check(name+' no universal P0 in Section6',all(x not in sec6 for x in ['P_0','H_0','145','300']))
    # Preserve the unrelated scalar and the complete existing finite-form guards.
    scalar='P_0=\\frac2{\\alpha B_0}'
    check(name+' structural scalar unchanged',candidate.count(scalar)==base.count(scalar)==1)
    guard='C\\ge200S,\\qquad AC\\ge1000,\\qquad C\\ge1000.'
    check(name+' quadratic guards retained',candidate.count(guard)==base.count(guard)==1)
    labels=set(re.findall(r'\\label\{([^}]+)\}',candidate))
    refs=set(re.findall(r'\\(?:eqref|ref|pageref)\{([^}]+)\}',candidate))
    check(name+' no undefined references',refs<=labels)
    proposal_controls[name]={'guarded_edits':len(pp['edits']),'undefined_references':sorted(refs-labels),'article_written':False}

check('authoritative source unchanged',hashlib.sha256(SRC.read_bytes()).hexdigest()==SHA)
output={'status':'PASS','source_sha256':SHA,'check_count':len(checks),'checks':checks,'variants':variants,'proposal_controls':proposal_controls}
(HERE/'rank_cross_check.json').write_text(json.dumps(output,indent=2)+'\n')
print(json.dumps({'status':'PASS','check_count':len(checks),'source_sha256':SHA,'proposal_controls':proposal_controls},indent=2))
