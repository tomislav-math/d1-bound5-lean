from pathlib import Path
from itertools import product
import sys, re, json
sys.path.insert(0, 'finite_next/two_small')
from generate_pair_closures import norm, mul, add, root, disk

base=Path('finite_next/one_small')
source=(base/'manuscript_source.txt').read_text()
pairs=[]
for match in re.finditer(r'^(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\',source,re.M):
    i,d,ax,ay,bx,by,na,nb=map(int,match.groups())
    t,n=(1,(d+1)//4) if d%4==3 else (0,d)
    a,b=(ax,ay),(bx,by)
    assert norm(t,n,a)==na and norm(t,n,b)==nb
    pairs.append(dict(index=i,d=d,tau=t,nu=n,a=a,b=b,na=na,nb=nb))
assert len(pairs)==40 and [p['index'] for p in pairs]==list(range(40))
triples=[]
for match in re.finditer(r'^(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) \\\\',source,re.M):
    i,x,y,ns,mbs,n0=map(int,match.groups())
    p=pairs[i];s=(x,y)
    assert norm(p['tau'],p['nu'],s)==ns
    triples.append(dict(index=len(triples),pair=i,s=s,ns=ns,mbs=mbs,n0=n0))
assert len(triples)==56

def compat(t,n,a,b):return root(t,n,add(mul(t,n,a,b),(1,0))) is not None
def candidate(t,n,a,q):
    w=add(mul(t,n,q,q),(-1,0)); den=norm(t,n,a)
    numer=mul(t,n,(a[0]+t*a[1],-a[1]),w)
    if numer[0]%den or numer[1]%den:return None
    return numer[0]//den,numer[1]//den
def sym(t,a,sgn,conj):
    x,y=a
    return sgn*(x+t*y if conj else x),sgn*(-y if conj else y)

# Exhaustive pair coverage in all 16 coordinate orders, before maximality.
allpairs={};models=[(t,n) for t in (0,1) for n in range(1,9)]
for t,n in models:
    found=set()
    for a in disk(t,n,2):
        na=norm(t,n,a)
        if not na:continue
        for q in disk(t,n,8):
            b=candidate(t,n,a,q)
            if b is None:continue
            nb=norm(t,n,b)
            if (na==1 and 9<=nb<=63) or (na==2 and 9<=nb<=15):
                if (a,b) not in [((1,0),(3,0)),((-1,0),(-3,0))]:found.add((a,b))
    allpairs[t,n]=sorted(found)
    reps=[p for p in pairs if (p['tau'],p['nu'])==(t,n)]
    covered={(sym(t,p['a'],sgn,c),sym(t,p['b'],sgn,c)) for p in reps for sgn,c in product((-1,1),(False,True))}
    if reps:assert covered==found,(t,n,len(covered),len(found))
    elif (t,n) not in [(0,3),(0,4),(0,7),(0,8),(1,7)]:assert not found,(t,n,found)

# Third entries retain equal moduli and every orientation of the representative.
thirds={}
for p in pairs:
    i,t,n,a,b=p['index'],p['tau'],p['nu'],p['a'],p['b']
    found=sorted(s for s in disk(t,n,224) if s not in (a,b) and norm(t,n,s)>=p['nb'] and compat(t,n,a,s) and compat(t,n,b,s))
    expected=sorted(tuple(r['s']) for r in triples if r['pair']==i)
    if i==7:expected.append((3,0));expected.sort()
    assert found==expected,(i,found,expected)
    thirds[i]=found

# Each bounded fourth entry, reconstructed from a root, lies below the
# strict lower bound provided by tail irregularity. Zero is kept explicitly.
extensions={}
for r in triples:
    p=pairs[r['pair']];t,n,a,b=p['tau'],p['nu'],p['a'],p['b'];s=tuple(r['s'])
    found=set()
    for q in disk(t,n,300):
        z=candidate(t,n,a,q)
        if z is None or norm(t,n,z)>=r['n0']:continue
        if compat(t,n,b,z) and compat(t,n,s,z):found.add(z)
    assert all(norm(t,n,z)<=4*p['nb']*r['ns'] for z in found),(r,found)
    extensions[r['index']]=sorted(found)

data=dict(pairs=pairs,triples=triples,
          pair_tables=[dict(tau=t,nu=n,rows=allpairs[t,n]) for t,n in models],
          third_entries=thirds,bounded_extensions=extensions)
(base/'finite_data.json').write_text(json.dumps(data,indent=2)+'\n')
print('40 pairs and 56 triples parsed from the frozen manuscript.')
print('Pair orbit sizes:',[(t,n,len(v)) for (t,n),v in allpairs.items()])
print('Third-entry count:',sum(map(len,thirds.values())),'(56 + exceptional (1,-3,3)).')
print('Bounded fourth-extension counts:',[len(extensions[r['index']]) for r in triples])
print('All bounded fourth extensions satisfy N(t) <= 4 N(b) N(s).')
