"""Bind every exact finite graph to the formally verified Pell CF algorithm."""
from pathlib import Path
import hashlib, json

BASE=Path('finite_next/unit_pell')
DEST=BASE/'prefixes'
DEST.mkdir(exist_ok=True)
X=10**275
fields=[json.loads(path.read_text()) for path in sorted((BASE/'data').glob('*.json'))]
graph_manifest=json.loads((BASE/'graph_source_manifest.json').read_text())
graph_file={d:Path(r['file']).stem for r in graph_manifest for d in r['fields']}

def validate(d):
    s=[0,1,d['a0'],1,d['a0'],0,1]
    solutions=[]
    for i,(m,Q,a) in enumerate(d['states']):
        assert s[:3]==[m,Q,a]
        assert Q>0 and a*Q<=d['a0']+m<(a+1)*Q
        _,_,_,pp,p,qq,q=s
        if 0<p<=X and 0<q and p*p-d['d']*q*q==2: solutions.append([p,q])
        if i+1<len(d['states']):
            mn=Q*a-m
            Qn=(d['d']-mn*mn)//Q
            an=(d['a0']+mn)//Qn
            assert Q*Qn==d['d']-mn*mn
            s=[mn,Qn,an,p,an*p+pp,q,an*q+qq]
    assert s[4]>X and [s[4],s[6]]==d['stop']
    assert solutions==d['solutions']
    assert [p*p-1 for p,q in solutions]==d['magnitudes']

def field_source(data):
    validate(data)
    d=data['d']
    graph=f'pellGraphCertificate_{d}' if data['magnitudes'] else f'pellEmptyMatchingCertificate {d}'
    return f'''\ndef pellFiniteCertificate_{d} : PellFiniteCertificate {d} (10^275) where
  a0 := {data['a0']}
  lastIndex := {len(data['states'])-1}
  graph := {graph}
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel
'''

def write_block(name,block):
    imports=['D1Bound5.PellFiniteCertificate']
    imports+=sorted({'D1Bound5.'+graph_file[data['d']] for data in block if data['magnitudes']})
    src=''.join('import '+i+'\n' for i in imports)
    src+='\nnamespace D1Bound5\nset_option maxRecDepth 32768\nset_option maxHeartbeats 12000000\n'
    src+=''.join(field_source(data) for data in block)+'\nend D1Bound5\n'
    path=DEST/f'{name}.lean';path.write_text(src)
    return dict(file=str(path.relative_to(BASE)),fields=[data['d'] for data in block],
                bytes=len(src.encode()),sha256=hashlib.sha256(src.encode()).hexdigest())

pilot=next(data for data in fields if data['d']==4519)
records=[write_block('PellFinitePilot',[pilot])]
remaining=[data for data in fields if data['d']!=4519]
for k in range(0,len(remaining),16):
    records.append(write_block(f'PellFiniteData{k//16+1}',remaining[k:k+16]))
(BASE/'prefix_source_manifest.json').write_text(json.dumps(records,indent=2)+'\n')

# Bounded exhaustive parameter coverage needs no unverified squarefree test:
# every omitted parameter comes with an explicit square divisor >=4.
ds={data['d'] for data in fields}
factors=[]
for k in range(1250):
    d=7+8*k
    p=0 if d in ds else next(p for p in range(2,100) if d%(p*p)==0)
    assert d in ds or p>=2 and d%(p*p)==0
    factors.append(p)
src=''.join('import D1Bound5.'+Path(r['file']).stem+'\n' for r in records)
src+='import Mathlib.Algebra.Group.Int.Units\n\nnamespace D1Bound5\n'
src+='set_option maxRecDepth 32768\nset_option maxHeartbeats 12000000\n\n'
src+='def pellCertifiedFields : List (Σ d : ℤ, PellFiniteCertificate d (10^275)) :=\n  ['
src+=',\n   '.join(f'⟨{data["d"]},pellFiniteCertificate_{data["d"]}⟩' for data in fields)+']\n\n'
src+='def pellExcludedFactors : List ℤ :=\n  ['+','.join(map(str,factors))+']\n\n'
src+='''theorem pellFieldCoverage_checked :
    ∀ k : Fin 1250,
      let d : ℤ := 7+8*(k.val : ℤ)
      let p := pellExcludedFactors.getD k.val 0
      d ∈ pellCertifiedFields.map Sigma.fst ∨ (2 ≤ p ∧ p*p ∣ d) := by
  decide +kernel

/-- All 1016 eligible parameters have complete, kernel-checked certificates.
The excluded cases have explicit nonunit square divisors, so the coverage
proof does not trust the Python squarefree predicate. -/
theorem pellFiniteCertificate_exists (d : ℤ) (hd : 7 ≤ d) (hupper : d < 10000)
    (hmod : d % 8 = 7) (hsq : Squarefree d) :
    Nonempty (PellFiniteCertificate d (10^275)) := by
  have hk0 : 0 ≤ d/8 := by omega
  have hklt : (d/8).toNat < 1250 := by omega
  let k : Fin 1250 := ⟨(d/8).toNat,hklt⟩
  have heq : 7+8*(k.val : ℤ) = d := by dsimp [k]; omega
  have hc := pellFieldCoverage_checked k
  dsimp only at hc
  rw [heq] at hc
  rcases hc with hmem | hbad
  · obtain ⟨r,_,hr⟩ := List.mem_map.mp hmem
    cases hr
    exact ⟨r.2⟩
  · have hu : IsUnit (pellExcludedFactors.getD k.val 0) := hsq _ hbad.2
    have hh := Int.isUnit_iff.mp hu
    omega

end D1Bound5
'''
path=BASE/'PellFiniteFields.lean';path.write_text(src)
print(dict(files=len(records)+1,fields=len(fields),bytes=sum(r['bytes'] for r in records)+len(src.encode()),
           field_sha256=hashlib.sha256(src.encode()).hexdigest()))
