"""Guarded exact-row split of the graph39 cached literal after bounded timeout."""
from pathlib import Path
import hashlib, json
R = Path(__file__).resolve().parents[1]
T = R/'graph39-transfer'
P = R/'project/D1Bound5'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p, value): p.write_text(json.dumps(value,indent=2,sort_keys=True)+'\n')
n = 'SmallPairLightData39LeftCached'
failure = json.loads((R/'results-graph39-recovery'/f'{n}-receipt.json').read_text())
assert failure['proof_status'] == 'TIMEOUT', failure['proof_status']
f = P/(n+'.lean')
assert sha(f) == '6a387ea0e18f508d5545c09ae1e5894d8b14cff9fe9cf20155dd911219323ef0'
original = T/'failures'/f'{n}.original.lean'
s = original.read_text()
prefix, body = s.split('def leftCached : List PairLightCachedVertex := [\n',1)
body, suffix = body.split('\n]\n',1)
rows = body.splitlines()
assert len(rows)==458 and all(row.startswith('  ((') for row in rows)
assert all(row.endswith('),') for row in rows[:-1]) and rows[-1].endswith(')')
literal_rows = [row.removesuffix(',') for row in rows]
new = {}
for i,offset in enumerate(range(0,len(rows),128)):
    name=n+f'Chunk{i:02d}'
    chunk_rows=literal_rows[offset:offset+128]
    text=('import D1Bound5.PairLightArithmetic\n\nnamespace D1Bound5.PairLightPrepared39\n'
        'set_option autoImplicit false\nset_option maxRecDepth 100000\n'
        'set_option maxHeartbeats 0\n\nnoncomputable\n'
        f'def leftCachedChunk{i:02d} : List PairLightCachedVertex := [\n'
        +'\n'.join(row+',' for row in chunk_rows)+'\n]\n\nend D1Bound5.PairLightPrepared39\n')
    dest=P/(name+'.lean')
    assert not dest.exists()
    dest.write_text(text)
    new[dest.name]=sha(dest)
chunks=[f'leftCachedChunk{i:02d}' for i in range(4)]
text=(''.join(f'import D1Bound5.{n}Chunk{i:02d}\n' for i in range(4))
    +'\nnamespace D1Bound5.PairLightPrepared39\nset_option autoImplicit false\n\n'
    +'noncomputable\ndef leftCached : List PairLightCachedVertex :=\n  '
    +' ++ '.join(chunks)+'\n\nend D1Bound5.PairLightPrepared39\n')
(T/'failures'/f'{n}.noncomputable.lean').write_text(f.read_text())
f.write_text(text)
recovered=[]
for i in range(4):
    txt=(P/(n+f'Chunk{i:02d}.lean')).read_text()
    b=txt.split(':= [\n',1)[1].split('\n]\n',1)[0]
    recovered.extend(row.removesuffix(',') for row in b.splitlines())
assert recovered==literal_rows
new[f.name]=sha(f)
manifest=json.loads((T/'effective_manifest.json').read_text())
manifest.update(new)
save(T/'effective_manifest.json',manifest)
save(T/'LEFT_CACHED_SPLIT.json',{
    'reason':'Original literal and modifier-only noncomputable version each exceeded bounded240s Linux compile.',
    'original_source_sha256':sha(original),
    'noncomputable_source_sha256':sha(T/'failures'/f'{n}.noncomputable.lean'),
    'ordered_literal_rows':458,'chunk_sizes':[128,128,128,74],
    'ordered_rows_byte_equal_ignoring_optional_terminal_comma':True,
    'public_type_preserved':'leftCached : List PairLightCachedVertex',
    'kernel_equality_expected':'PairLightPrepared39.leftCached_eq proves equality to exact original raw selected cached data',
    'new_source_hashes':new,
    'changes_only_representation':True,'main_theorem_complete':False})
print(json.dumps({'sources':new,'exact_ordered_rows':458},indent=2))
