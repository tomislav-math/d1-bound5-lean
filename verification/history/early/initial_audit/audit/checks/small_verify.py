#!/usr/bin/env python3
"""Independent exact audit of Section 8 small-entry tables.
All coordinates represent (u+v sqrt(-d))/2. No floats are used.
"""
from math import isqrt
from itertools import combinations
from collections import deque
import json,re,time,sys
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'audit/checks'
TEX=ROOT/'upload/D1_bound5_complete.tex'

def sf(d):
    return all(d%(p*p) for p in range(2,isqrt(d)+1))

class Ring:
    def __init__(self,d):self.d=d
    def valid(self,z):
        a,b=z
        return (a-b)%2==0 if self.d%4==3 else a%2==b%2==0
    def norm(self,z):
        a,b=z
        n=a*a+self.d*b*b
        assert n%4==0
        return n//4
    def add(self,x,y):return (x[0]+y[0],x[1]+y[1])
    def neg(self,x):return (-x[0],-x[1])
    def mul(self,x,y):
        a,b=x;c,e=y
        u=a*c-self.d*b*e;v=a*e+b*c
        assert u%2==v%2==0
        return u//2,v//2
    def root(self,z):
        a,b=z;n=self.norm(z);h=isqrt(n)
        if h*h!=n:return None
        rr=2*h+a;ss=2*h-a
        if rr<0 or ss<0 or ss%self.d:return None
        r=isqrt(rr);s=isqrt(ss//self.d)
        if r*r!=rr or self.d*s*s!=ss or r*s!=abs(b):return None
        ans=(r,s if b>=0 else -s)
        if not self.valid(ans):return None
        assert self.mul(ans,ans)==z
        return ans
    def cp(self,x,y):return self.root(self.add(self.mul(x,y),(2,0)))
    def disk(self,R):
        for v in range(-2*R//isqrt(self.d)-1,2*R//isqrt(self.d)+2):
            rem=4*R*R-self.d*v*v
            if rem<0:continue
            lim=isqrt(rem)
            for u in range(-lim,lim+1):
                z=u,v
                if self.valid(z):yield z
    def close(self,a,b,R):
        seeds={z for z in self.disk(33) if self.cp(a,z)!=None and self.cp(b,z)!=None}
        r0=self.cp(a,b);assert r0 not in [None,(0,0)]
        ab=self.mul(a,b); coeff=self.add((2*ab[0],2*ab[1]),(2,0));a_b=self.add(a,b)
        known=set(seeds);q=deque(seeds);steps=0
        while q:
            z=q.popleft();r=self.cp(a,z);s=self.cp(b,z)
            assert r is not None and s is not None
            base=self.add(a_b,self.mul(coeff,z));rr=self.mul(r0,self.mul(r,s));delta=(2*rr[0],2*rr[1])
            for w in (self.add(base,delta),self.add(base,self.neg(delta))):
                if self.norm(w)<=R*R and w not in known:
                    assert self.cp(a,w)!=None and self.cp(b,w)!=None
                    known.add(w);q.append(w)
            steps+=1
        return known,len(seeds),steps
    def graph(self,verts):
        verts=list(sorted(verts));N=len(verts);nbr=[set() for _ in verts]
        primes=[3,5,7,11,13,17,19]
        sq=[];vmods=[]
        for p in primes:
            sq.append({((x*x-self.d*y*y)%p,(2*x*y)%p) for x in range(p) for y in range(p)})
            inv=(p+1)//2
            vmods.append([((u*inv)%p,(v*inv)%p) for u,v in verts])
        checks=0;edges=0
        for i in range(N):
            for j in range(i):
                ok=True
                for k,p in enumerate(primes):
                    x,y=vmods[k][i];u,v=vmods[k][j]
                    if ((x*u-self.d*y*v+1)%p,(x*v+y*u)%p) not in sq[k]:
                        ok=False;break
                if ok:
                    checks+=1
                    if self.cp(verts[i],verts[j]) is not None:
                        nbr[i].add(j);nbr[j].add(i);edges+=1
        triangles=[]
        for i in range(N):
            for j in nbr[i]:
                if i<j:
                    triangles.extend((i,j,k) for k in nbr[i]&nbr[j] if j<k)
        return edges,triangles,checks

def canonical(items):
    opts=[]
    for neg in [1,-1]:
        for conj in [1,-1]:opts.append(tuple(sorted((neg*u,neg*conj*v) for u,v in items)))
    return min(opts)

def small_classification():
    classes=[];trips=[];four=[]
    for d in range(1,36):
        if not sf(d):continue
        r=Ring(d);v=sorted(z for z in r.disk(3) if 0<r.norm(z)<9)
        edges={tuple(sorted((x,y))) for x,y in combinations(v,2) if r.cp(x,y)!=None}
        pairs={canonical(e) for e in edges}
        classes.extend((d,p) for p in sorted(pairs))
        tlist=[t for t in combinations(v,3) if all(tuple(sorted(e)) in edges for e in combinations(t,2))]
        orbits={canonical(t) for t in tlist}
        trips.extend((d,t,sum(canonical(s)==t for s in tlist)) for t in sorted(orbits))
        four.extend((d,t,x) for t in tlist for x in v if x not in t and all(tuple(sorted((x,y))) in edges for y in t))
    assert len(classes)==72,(len(classes),classes)
    assert len(trips)==10 and sum(x[2] for x in trips)==24
    assert not four
    report={'classes':classes,'small_triples':trips,'small_quadruples':four}
    (BASE/'small_classification.json').write_text(json.dumps(report,indent=2))
    return classes,trips

def pairs():
    classes,_=small_classification();rows=[]
    tex=TEX.read_text();pattern=r'^(\d+) & \$\((-?\d+),(-?\d+)\)\$ & \$\((-?\d+),(-?\d+)\)\$ & (\d+) & (\d+)'
    expected={ (d,((a,b),(c,e))):(nv,ne) for d,a,b,c,e,nv,ne in (tuple(map(int,m)) for m in re.findall(pattern,tex,re.M))}
    assert len(expected)==48
    for d,pair in classes:
        a,b=pair;r=Ring(d)
        if r.cp(a,b)==(0,0):continue
        start=time.monotonic();known,seeds,steps=r.close(a,b,10**550)
        verts={z for z in known if r.norm(z)>=9 and z not in pair}
        nv=len(verts);assert nv==expected[d,pair][0],(d,pair,nv,expected[d,pair])
        ne,tri,checks=r.graph(verts)
        assert ne==expected[d,pair][1],(d,pair,ne,expected[d,pair])
        assert not tri,(d,pair,tri)
        row={'d':d,'pair':pair,'seed_count':seeds,'closed_count':steps,'vertices':nv,'edges':ne,'triangles':len(tri),'exact_pair_checks':checks,'seconds':round(time.monotonic()-start,3)}
        rows.append(row);print(json.dumps(row),flush=True)
        (BASE/'small_pairs_results.json').write_text(json.dumps(rows,indent=2))
    assert len(rows)==48
    assert sum(x['vertices'] for x in rows)==36931
    assert sum(x['edges'] for x in rows)==36854

def triples():
    # Manuscript representatives and pair choices, independently entered.
    data=[(1,[(-4,-4),(-4,4),(4,0)],(0,2),[(120,0)],61),
          (1,[(-4,-2),(0,-2),(4,-2)],(0,1),[(0,30)],89),
          (1,[(-4,-2),(0,4),(4,-2)],(0,1),[(0,-80)],64),
          (1,[(-4,0),(-2,-4),(2,0)],(0,2),[(8,24)],105),
          (2,[(-4,0),(2,-2),(2,2)],(1,2),[(-48,0)],71),
          (3,[(-3,-1),(-3,1),(2,0)],(0,2),[(16,0)],112),
          (3,[(-3,-1),(1,-3),(2,0)],(0,2),[(-24,8)],112),
          (3,[(-1,-1),(0,-2),(1,-1)],(0,1),[],57),
          (7,[(-5,-1),(-5,1),(2,0)],(0,2),[(48,0)],83),
          (7,[(-5,-1),(0,2),(5,-1)],(0,1),[(0,-64)],55)]
    _,cl=small_classification();expected={(d,canonical(t)):n for d,t,n in cl}
    out=[]
    for d,t,(i,j),ext,num in data:
        assert (d,canonical(t)) in expected
        r=Ring(d);known,seeds,steps=r.close(t[i],t[j],10**40)
        got=sorted(z for z in known if z!=(0,0) and z not in t and all(r.cp(z,a)!=None for a in t))
        assert got==ext,(d,t,got,ext)
        assert len(known)==num,(d,t,len(known),num)
        out.append({'d':d,'triple':t,'seeds':seeds,'closed_count':steps,'extensions':got,'orbit_size':expected[d,canonical(t)]})
        print(json.dumps(out[-1]),flush=True)
    (BASE/'small_triples_results.json').write_text(json.dumps(out,indent=2))

def pell():
    rows=[];lim=isqrt(10**550+1)
    for d in range(7,10000,8):
        if not sf(d):continue
        a0=isqrt(d);m=0;q=1;a=a0;u0,u1=0,1;v0,v1=1,0;nums=[];iterations=0
        while True:
            u=a*u1+u0;v=a*v1+v0;iterations+=1
            if u>lim:break
            if v>0 and u*u-d*v*v==2:nums.append(u*u-1)
            u0,u1=u1,u;v0,v1=v1,v
            m=q*a-m;q=(d-m*m)//q;a=(a0+m)//q
        verts=[(2*s*x,0) for x in nums for s in [-1,1]]
        r=Ring(d);ne,tri,checks=r.graph(verts)
        assert not tri,(d,tri)
        rows.append({'d':d,'vertices':len(verts),'edges':ne,'triangles':len(tri),'cf_iterations':iterations,'exact_pair_checks':checks})
        if len(rows)%100==0:print('Pell fields processed',len(rows),flush=True)
    totals={'fields':len(rows),'nonempty':sum(x['vertices']>0 for x in rows),'vertices':sum(x['vertices'] for x in rows),'edges':sum(x['edges'] for x in rows),'triangles':sum(x['triangles'] for x in rows)}
    assert totals=={'fields':1016,'nonempty':409,'vertices':19612,'edges':9806,'triangles':0},totals
    (BASE/'small_pell_results.json').write_text(json.dumps({'totals':totals,'fields':rows},indent=2))
    print(json.dumps(totals),flush=True)

if __name__=='__main__':
    {'classify':small_classification,'triples':triples,'pairs':pairs,'pell':pell}[sys.argv[1]]()
