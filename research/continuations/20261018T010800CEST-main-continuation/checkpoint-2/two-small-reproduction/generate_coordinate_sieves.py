from pathlib import Path
import json
PRIMES=[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]
models=sorted({(r['tau'],r['nu']) for p in Path('finite_next/two_small/closures').glob('pair_*.json') for r in [json.loads(p.read_text())]})
lines=['import D1Bound5.FastSquareTest','','namespace D1Bound5','set_option maxRecDepth 100000','set_option maxHeartbeats 100000000','']
for t,n in models:
 pairs=[]
 for p in PRIMES:
  squares={(x*x-n*y*y)%p*p+(2*x*y+t*y*y)%p for x in range(p) for y in range(p)}
  mask=sum(1<<i for i in squares)
  pairs.append(f'  ({p-1},{mask})')
 lines += [f'def smallPairSieve_{t}_{n} : List (ℕ × ℕ) := [\n'+',\n'.join(pairs)+'\n]',
 f'theorem smallPairSieve_{t}_{n}_valid : CoordinateSquareSieveValid {t} {n} smallPairSieve_{t}_{n} := by',
 '  decide +kernel','']
lines += ['end D1Bound5','']
Path('finite_next/two_small/D1Bound5/SmallPairSieves.lean').write_text('\n'.join(lines))
print('Wrote coordinate masks for',len(models),'models,',len(PRIMES),'moduli each.')
