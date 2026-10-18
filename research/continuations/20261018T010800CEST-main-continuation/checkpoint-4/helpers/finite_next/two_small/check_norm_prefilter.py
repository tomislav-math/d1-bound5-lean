from pathlib import Path
import json,time
MODULI=[64,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]
for rowid in [1,26,41]:
 row=json.loads(Path(f'finite_next/two_small/closures/pair_{rowid:02}.json').read_text());vs=row['large'];t,n=row['tau'],row['nu'];tables=[]
 for p in MODULI:
  classes=sorted({(x%p,y%p) for x,y in vs});index={z:i for i,z in enumerate(classes)};cs=[index[(x%p,y%p)] for x,y in vs];sq={k*k%p for k in range(p)};masks=[]
  for a,b in classes:
   mask=0
   for j,(c,d) in enumerate(classes):
    u=(a*c-n*b*d+1)%p;v=(a*d+b*c+t*b*d)%p
    if (u*u+t*u*v+n*v*v)%p in sq:mask|=1<<j
   masks.append(mask)
  tables.append((cs,masks))
 candidates=sum(all((m[cs[i]]>>cs[j])&1 for cs,m in tables) for i in range(len(vs)) for j in range(i+1,len(vs)))
 print(rowid,'pairs',len(vs)*(len(vs)-1)//2,'pass',candidates,'edges',row['expected_edges'])
