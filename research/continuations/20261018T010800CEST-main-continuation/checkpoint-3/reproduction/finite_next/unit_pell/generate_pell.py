from pathlib import Path
from math import isqrt
import json,hashlib,time

BASE=Path('finite_next/unit_pell')
R=10**550;X=10**275
assert X==isqrt(R+1)

def squarefree(d):return all(d%(p*p) for p in range(2,isqrt(d)+1))
def issq(n):return n>=0 and isqrt(n)**2==n
def primes(n):return [p for p in range(2,n+1) if all(p%q for q in range(2,isqrt(p)+1))]
MODULI=[16,9]+[p for p in primes(997) if p not in (2,3)]
SQUARES={p:{x*x%p for x in range(p)} for p in MODULI}

def cf_prefix(d):
 a0=isqrt(d);m=0;Q=1;a=a0
 p2,p1=0,1;q2,q1=1,0;states=[];solutions=[]
 while True:
  assert Q>0 and a>=1
  lo=a*Q-m;hi=(a+1)*Q-m
  assert lo>=0 and lo*lo<=d<hi*hi
  p=a*p1+p2;q=a*q1+q2
  assert p>p1 and q>0
  states.append([m,Q,a])
  if p>X:break
  if p*p-d*q*q==2:solutions.append([p,q])
  p2,p1=p1,p;q2,q1=q1,q
  m1=Q*a-m;numerator=d-m1*m1
  assert numerator>0 and numerator%Q==0
  Q1=numerator//Q;a1=(a0+m1)//Q1
  m,Q,a=m1,Q1,a1
 return dict(d=d,a0=a0,states=states,stop=[p,q],solutions=solutions,
             magnitudes=[p*p-1 for p,q in solutions])

def graph_witnesses(data):
 d=data['d'];xs=data['magnitudes'];n=len(xs)
 masks={p:{d*s%p for s in SQUARES[p]} for p in MODULI}
 residues={p:[x%p for x in xs] for p in MODULI}
 witnesses=[];uncovered=[];largest=0
 for i,x in enumerate(xs):
  for j in range(i):
   y=xs[j]
   pair=[]
   for plus in (True,False):
    found=0
    for p in MODULI:
     val=(residues[p][i]*residues[p][j]+(1 if plus else -1))%p
     if val not in (SQUARES[p] if plus else masks[p]):found=p;break
    if not found:
     w=x*y+1 if plus else (x*y-1)//d
     assert plus or (x*y-1)%d==0
     assert not issq(w),(d,i,j,plus,'Unexpected actual edge')
     uncovered.append([i,j,plus])
    largest=max(largest,found);pair.append(found)
   witnesses.append(pair)
 assert all(issq((x*x-1)//d) and (x*x-1)%d==0 for x in xs)
 return dict(witnesses=witnesses,uncovered=uncovered,max_modulus=largest)

if __name__=='__main__':
 started=time.perf_counter();dest=BASE/'data';dest.mkdir(exist_ok=True)
 expected=json.loads((BASE/'reference/pell_graphs.json').read_text())['rows']
 summary=[];counts=[0,0,0,0,0];maxmod=0;uncovered=0;maxbytes=0
 for d in range(7,10000,8):
  if not squarefree(d):continue
  data=cf_prefix(d);graph=graph_witnesses(data);data.update(graph)
  n=len(data['magnitudes']);i=len(summary)
  assert expected[i]==[d,2*n,n,0,len(data['states'])]
  counts[0]+=1;counts[1]+=bool(n);counts[2]+=2*n;counts[3]+=n
  uncovered+=len(graph['uncovered']);maxmod=max(maxmod,graph['max_modulus'])
  raw=json.dumps(data,separators=(',',':'))+'\n';(dest/f'd_{d:04}.json').write_text(raw)
  maxbytes=max(maxbytes,len(raw))
  summary.append(dict(d=d,steps=len(data['states']),solutions=n,
                      max_modulus=graph['max_modulus'],uncovered=len(graph['uncovered']),
                      sha256=hashlib.sha256(raw.encode()).hexdigest(),bytes=len(raw)))
 assert counts==[1016,409,19612,9806,0]
 report=dict(totals=counts,cf_steps=sum(r['steps'] for r in summary),
             max_modulus=maxmod,uncovered=uncovered,total_bytes=sum(r['bytes'] for r in summary),
             max_file_bytes=maxbytes,seconds=time.perf_counter()-started,fields=summary)
 (BASE/'generation_report.json').write_text(json.dumps(report,indent=2)+'\n')
 print({k:v for k,v in report.items() if k!='fields'})
