"""Exact modular matching certificates; no external computation is trusted by Lean."""
from pathlib import Path
import json, hashlib

BASE = Path('finite_next/unit_pell')
DEST = BASE / 'graphs'
DEST.mkdir(exist_ok=True)

def liststr(xs):
    return '[' + ','.join(map(str, xs)) + ']'

def field_source(data):
    d = data['d']
    xs = data['magnitudes']
    used = sorted({p for w in data['witnesses'] for p in w})
    index = {p:i for i,p in enumerate(used)}
    masks = []
    for p in used:
        sq = {r*r % p for r in range(p)}
        ordinary = sum(1 << r for r in sq)
        scaled = sum(1 << (d*r % p) for r in {0}) if False else sum(1 << r for r in {d*s % p for s in sq})
        assert all(ordinary >> (r*r % p) & 1 for r in range(p))
        assert all(scaled >> (d*r*r % p) & 1 for r in range(p))
        masks.append(f'⟨{p-1},{ordinary},{scaled}⟩')
    rows = []
    for i in range(len(xs)):
        row = []
        for j in range(i+1, len(xs)):
            pp, pn = data['witnesses'][j*(j-1)//2+i]
            # Check the exact same lookup and residue operations as the Lean checker.
            assert (xs[i]*xs[j]+1) % pp not in {r*r % pp for r in range(pp)}
            assert (xs[i]*xs[j]-1) % pn not in {d*r*r % pn for r in range(pn)}
            row.append(f'({index[pp]},{index[pn]})')
        rows.append(liststr(row))
    return f'''\ndef pellMagnitudes_{d} : List ℤ :=
  {liststr(xs)}

def pellMasks_{d} : List PellSquareMasks :=
  {liststr(masks)}

def pellWitnesses_{d} : List (List (ℕ × ℕ)) :=
  {liststr(rows)}

theorem pellMasks_{d}_valid : ∀ m ∈ pellMasks_{d}, m.Valid {d} := by
  decide +kernel

theorem pellMatching_{d}_checked :
    pellMatchingCheck pellMasks_{d} pellMagnitudes_{d} pellWitnesses_{d} = true := by
  decide +kernel

theorem pellMagnitudes_{d}_large : ∀ x ∈ pellMagnitudes_{d}, 2 ≤ x := by
  decide +kernel

def pellGraphCertificate_{d} : PellMatchingCertificate {d} where
  magnitudes := pellMagnitudes_{d}
  masks := pellMasks_{d}
  witnesses := pellWitnesses_{d}
  masks_valid := pellMasks_{d}_valid
  checked := pellMatching_{d}_checked
  large := pellMagnitudes_{d}_large
'''

def write_block(name, fields):
    src = '''import D1Bound5.PellMatchingCheck

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000
'''
    src += ''.join(field_source(data) for data in fields)
    src += '\nend D1Bound5\n'
    path = DEST / f'{name}.lean'
    path.write_text(src)
    return dict(file=str(path.relative_to(BASE)), fields=[d['d'] for d in fields],
                bytes=len(src.encode()), sha256=hashlib.sha256(src.encode()).hexdigest())

fields = [json.loads(path.read_text()) for path in sorted((BASE/'data').glob('*.json'))]
nonempty = [data for data in fields if data['magnitudes']]
pilot = next(data for data in nonempty if data['d'] == 4519)
records = [write_block('PellMatchingPilot', [pilot])]
remaining = [data for data in nonempty if data['d'] != 4519]
for k in range(0, len(remaining), 16):
    records.append(write_block(f'PellMatchingData{k//16+1}', remaining[k:k+16]))
(BASE/'graph_source_manifest.json').write_text(json.dumps(records, indent=2)+'\n')
print(dict(files=len(records), fields=sum(len(r['fields']) for r in records),
           bytes=sum(r['bytes'] for r in records), pilot_bytes=records[0]['bytes']))
