"""Read frozen mask literals; emit identical masks with List-range certificates.
Does not overwrite the existing SmallPairSieves or any seed disks."""
from pathlib import Path
import ast,hashlib,json,re
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
source=ROOT/'finite_next/two_small/D1Bound5/SmallPairSieves.lean'
text=source.read_text()
models=[]
for m in re.finditer(r'def smallPairSieve_(\d+)_(\d+) : List \(ℕ × ℕ\) := (\[.*?\])',text,re.S):
 t,n=map(int,m.group(1,2));pairs=ast.literal_eval(m.group(3));models.append((t,n,pairs))
for t,n,pairs in models:
 lines=['import D1Bound5.CoordinateSquareMaskCheck','','namespace D1Bound5','set_option maxRecDepth 100000','set_option maxHeartbeats 0','']
 for i,(k,mask) in enumerate(pairs):
  mn=f'smallPairMask_{t}_{n}_{i}'
  lines += [f'def {mn} : ℕ := {mask}',f'theorem {mn}_valid : CoordinateSquareMaskValid {t} {n} {k} {mn} := by',f'  apply coordinateSquareMaskCheck_sound','  decide +kernel','']
  p=k+1
  assert all(mask>>(((x*x-n*y*y)%p)*p+(2*x*y+t*y*y)%p)&1 for x in range(p) for y in range(p))
 lines += [f'def smallPairSieve_{t}_{n} : List (ℕ × ℕ) := [',',\n'.join(f'  ({k},smallPairMask_{t}_{n}_{i})' for i,(k,_) in enumerate(pairs)),']','',f'theorem smallPairSieve_{t}_{n}_valid : CoordinateSquareSieveValid {t} {n} smallPairSieve_{t}_{n} := by','  exact']
 for i in range(len(pairs)):lines += ['    '+('  '*i)+f'coordinateSquareSieveValid_cons smallPairMask_{t}_{n}_{i}_valid (']
 lines += ['    '+('  '*len(pairs))+f'coordinateSquareSieveValid_nil {t} {n}'+')'*len(pairs),'','end D1Bound5','']
 (HERE/f'SmallPairSieve_{t}_{n}.lean').write_text('\n'.join(lines))
(HERE/'SmallPairSieves.lean').write_text('\n'.join(f'import D1Bound5.SmallPairSieve_{t}_{n}' for t,n,_ in models)+'\n')
t,n,pairs=models[0];k,mask=pairs[-1]
(HERE/'CoordinateSquareMaskPilot.lean').write_text(f'''import D1Bound5.CoordinateSquareMaskCheck

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def coordinateSquareMaskPilot : ℕ := {mask}

/-- Largest modulus from the unchanged Gaussian mask table: 97^2 checks. -/
theorem coordinateSquareMaskPilot_valid :
    CoordinateSquareMaskValid {t} {n} {k} coordinateSquareMaskPilot := by
  apply coordinateSquareMaskCheck_sound
  decide +kernel

end D1Bound5
''')
report={'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'models':len(models),'masks':sum(len(z) for _,_,z in models),'residue_pairs':sum((k+1)**2 for _,_,pairs in models for k,_ in pairs),'data':'Every (k,mask) tuple copied unchanged; all modular-square bits independently verified in Python.','sources':[{'file':p.name,'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}for p in sorted(HERE.glob('*.lean'))]}
(HERE/'SOURCE_MANIFEST.json').write_text(json.dumps(report,indent=2)+'\n')
print('Unchanged masks:',report['masks'],'in',report['models'],'fields;',report['residue_pairs'],'residue pairs verified; generated',len(report['sources']),'Lean files.')
