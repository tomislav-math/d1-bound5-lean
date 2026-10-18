"""Read-only independent byte-preservation review of expanded row22 fallback."""
from pathlib import Path
import hashlib, json, re
ROOT = Path(__file__).resolve().parents[1]
EXP = ROOT / 'pair_backend_next/expanded22_timeout_fallback'
COMPACT = ROOT / 'pair_backend_next/compact_review_samples/D1Bound5/SmallPairGraphData22.lean'
ORIGINAL = ROOT / 'finite_next/two_small/D1Bound5/SmallPairGraphData22.lean'
sha = lambda b: hashlib.sha256(b).hexdigest()

def blocks(text):
    stack=[]; result=[]; cur=[]
    for line in text.splitlines(keepends=True):
        begin=re.fullmatch(r'namespace (\S+)\s*\n?',line)
        end=re.fullmatch(r'end (\S+)\s*\n?',line)
        if not stack:
            if begin: cur=[]
            else:
                assert not line.strip() or line.startswith('import '),line
                continue
        cur.append(line)
        if begin: stack.append(begin.group(1))
        if end:
            assert stack and stack.pop()==end.group(1)
            if not stack: result.append(''.join(cur).strip())
    assert not stack
    return result

manifest=json.loads((EXP/'manifest.json').read_text())
frozen=json.loads((ROOT/'pair_backend_next/all47_dry/manifest.json').read_text())
row=manifest['results'][0]
old=next(x for x in frozen['results'] if x['row']==22)
assert row['files']==old['files']
assert sha((EXP/'manifest.json').read_bytes())=='8dbdf530c318fd2d4f52149ebb78af2ababf65e18ce4205e0c2c50044bbddc20'
assert sha(COMPACT.read_bytes())=='7f3b5e833822d8bcfd43d7d77cd7783eb0744df33978ffa97a5b11ff25e7b0e9'
expected_imports={
 'Inputs':['D1Bound5.SmallPairGraphCheck'],
 'WitnessData':['D1Bound5.SmallPairGraphInputs22','D1Bound5.PairClosureWitness'],
 'Arithmetic':['D1Bound5.SmallPairGraphInputs22','D1Bound5.TwoSmallSeedDisks'],
 'Closure':['D1Bound5.SmallPairGraphWitnessData22','D1Bound5.PairClosureIndexedWitness'],
 'Triangle':['D1Bound5.SmallPairGraphInputs22','D1Bound5.PairTraceZeroGraph','D1Bound5.SmallPairSieve_1_1'],
 'Data':['D1Bound5.SmallPairGraphArithmetic22','D1Bound5.SmallPairGraphClosure22','D1Bound5.SmallPairGraphTriangle22'],
}
compact_blocks=blocks(COMPACT.read_text()); assert len(compact_blocks)==5
sources={}; comparisons=[]
for i,(stem,imports) in enumerate(expected_imports.items()):
    path=f'D1Bound5/SmallPairGraph{stem}22.lean'
    raw=(EXP/path).read_bytes(); s=raw.decode(); sources[stem]=s
    assert row['files'][path]==dict(sha256=sha(raw),bytes=len(raw))
    assert re.findall(r'^import (.+)$',s,re.M)==imports
    found=blocks(s)
    if stem=='Data': assert found==[]
    else:
        assert len(found)==1 and found[0]==compact_blocks[i],stem
    comparisons.append(dict(file=path,sha256=sha(raw),bytes=len(raw),
        namespace_body_byte_identical_to_compact=stem!='Data',imports_exact=True))
assert sum(x['bytes'] for x in comparisons)==1664487
original=ORIGINAL.read_text(); joined='\n'.join(sources.values()); compact=COMPACT.read_text()
assert sha(ORIGINAL.read_bytes())==row['original_source_sha256']
original_data=original[original.index('def smallPairA_22 '):original.index('theorem smallPairSeeds_22_checked')]
assert joined.count(original_data)==compact.count(original_data)==1
public=['smallPairSeeds_22_checked','smallPairFilter_22_checked','smallPairLarge_22_count','smallPairClosure_22_checked','smallPairNoTriangle_22_checked']
for name in public:
    pat=rf'theorem {name}\b(.*?) :='
    a=re.findall(pat,original,re.S);b=re.findall(pat,joined,re.S);c=re.findall(pat,compact,re.S)
    assert len(a)==1 and a==b==c,name
for name in public[:3]:
    pat=rf'theorem {name}\b.*?(?=\n(?:theorem |end D1Bound5))'
    assert re.search(pat,original,re.S).group().strip()==re.search(pat,sources['Arithmetic'],re.S).group().strip()
# Every generated declaration has one owner; all local dependencies precede owners.
all_decls=re.findall(r'^(?:def|theorem) ([^\s:]+)',joined,re.M)
assert len(all_decls)==len(set(all_decls))
position={f'D1Bound5.SmallPairGraph{s}22':i for i,s in enumerate(expected_imports)}
for owner,imports in expected_imports.items():
    for dep in imports:
        if dep in position: assert position[dep]<position[f'D1Bound5.SmallPairGraph{owner}22']
report=dict(status='Independent source/byte-preservation PASS; no Lean compilation or remote mutation',
 local_regeneration='Frozen expanded generator rerun locally with --rows 22 and frozen all47 expected manifest; all six source hashes match.',
 regenerated_manifest_sha256=sha((EXP/'manifest.json').read_bytes()),
 root_reported_manifest_matches=True,
 compact_source_sha256=sha(COMPACT.read_bytes()),original_source_sha256=sha(ORIGINAL.read_bytes()),
 generator_sha256=sha((ROOT/'pair_backend_next/stage_pair_backends.py').read_bytes()),
 exact_original_data_block_once=True, five_public_theorem_types_exact=True,
 original_three_arithmetic_proof_blocks_exact=True,
 compact_all_five_namespace_bodies_byte_identical=True,
 root_witnesses_destinations_and_indexed_closure_preserved=True,
 trace_zero_triangle_checker_and_arguments_preserved=True,
 generated_declaration_owners_unique=True,generated_import_graph_acyclic=True,
 module_count=6,total_source_bytes=1664487,files=comparisons,
 limitation='This only splits the same source/data/certificates into files. It neither proves new mathematics nor predicts each computation will finish. Root must compile every source/dependency and final GraphData22 endpoint. The prior compact timeout is not a kernel pass; MainStatement remains unproved.')
out=ROOT/'audit_next/expanded22_fallback_review.json';out.write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(dict(status=report['status'],report=str(out.relative_to(ROOT)),report_sha256=sha(out.read_bytes()),manifest_sha256=report['regenerated_manifest_sha256'],module_count=6,total_source_bytes=1664487),indent=2))
