from pathlib import Path
import json,time
from generate_pair_closures import mul,root,add
PRIMES=[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]

def modular_tables(t,n,vertices,primes):
 tables=[]
 for p in primes:
  classes=sorted({(x%p,y%p) for x,y in vertices});index={z:i for i,z in enumerate(classes)}
  vclass=[index[(x%p,y%p)] for x,y in vertices]
  squares={(a*a-n*b*b)%p*p+(2*a*b+t*b*b)%p for a in range(p) for b in range(p)}
  masks=[]
  for a,b in classes:
   mask=0
   for j,(c,d) in enumerate(classes):
    u=(a*c-n*b*d+1)%p;v=(a*d+b*c+t*b*d)%p
    if u*p+v in squares:mask|=1<<j
   masks.append(mask)
  tables.append((vclass,masks))
 return tables

def triangle(adjacency):
 for i,ns in enumerate(adjacency):
  for j in ns:
   if j>i:
    both=ns.intersection(adjacency[j])
    if both:return (i,j,min(both))
 return None

if __name__=='__main__':
 started=time.time();dest=Path('finite_next/two_small/graphs');dest.mkdir(exist_ok=True)
 summary=[]
 for file in sorted(Path('finite_next/two_small/closures').glob('pair_*.json')):
  row=json.loads(file.read_text());vs=[tuple(v) for v in row['large']];t,n=row['tau'],row['nu'];tables=modular_tables(t,n,vs,PRIMES)
  candidates=[];adj=[set() for _ in vs]
  for i in range(len(vs)):
   for j in range(i+1,len(vs)):
    if all((m[cs[i]]>>cs[j])&1 for cs,m in tables):
     candidates.append((i,j));adj[i].add(j);adj[j].add(i)
  mod_triangle=triangle(adj)
  edges=[]
  for i,j in candidates:
   if root(t,n,add(mul(t,n,vs[i],vs[j]),(1,0))) is not None:edges.append((i,j))
  exactadj=[set() for _ in vs]
  for i,j in edges:exactadj[i].add(j);exactadj[j].add(i)
  assert len(edges)==row['expected_edges'],(row['row'],len(edges),row['expected_edges'])
  assert triangle(exactadj) is None,row['row']
  (dest/file.name).write_text(json.dumps(dict(row=row['row'],moduli=PRIMES,modular_edges=candidates,exact_edges=edges,modular_triangle=mod_triangle),separators=(',',':'))+'\n')
  summary.append([row['row'],len(vs),len(candidates),len(edges),mod_triangle])
 Path('finite_next/two_small/graph_counts.json').write_text(json.dumps(summary,indent=2)+'\n')
 print('All48exact graphs match article counts and have no triangles; exact edges',sum(r[3] for r in summary))
 print('Modular graphs already trianglefree:',sum(r[4] is None for r in summary),'of48; excess modular edges:',sum(r[2]-r[3] for r in summary))
 print('seconds',round(time.time()-started,2))
