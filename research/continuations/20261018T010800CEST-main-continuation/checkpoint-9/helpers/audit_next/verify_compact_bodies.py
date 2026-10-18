"""Independent exact namespace-body reconstruction for compact staging samples."""
from pathlib import Path
import hashlib
import json
import re

ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'pair_backend_next/compact_review_samples'
sha=lambda b:hashlib.sha256(b).hexdigest()
manifest=json.loads((BASE/'manifest.json').read_text())
frozen=json.loads((ROOT/'pair_backend_next/all47_dry/manifest.json').read_text())
oldrows={r['row']:r for r in frozen['results']}

def body_segments(text):
    """Extract balanced outer namespace blocks, independent of the bundler."""
    lines=text.splitlines(keepends=True)
    stack=[]; blocks=[]; current=[]
    for line in lines:
        start=re.fullmatch(r'namespace (\S+)\s*\n?',line)
        end=re.fullmatch(r'end (\S+)\s*\n?',line)
        if not stack:
            if start: current=[]
            else:
                assert not line.strip() or line.startswith('import '),line
                continue
        current.append(line)
        if start: stack.append(start.group(1))
        if end:
            assert stack and stack.pop()==end.group(1),line
            if not stack: blocks.append(''.join(current).strip())
    assert not stack
    return blocks

results=[]
for row in manifest['results']:
    k=row['row']; backend=row['backend']
    original=(ROOT/f'finite_next/two_small/D1Bound5/SmallPairGraphData{k}.lean').read_text()
    assert sha(original.encode())==row['original_source_sha256']
    tau,nu=re.search(rf'def smallPairA_{k} : QuadInt (\d+) (\d+)',original).groups()
    def mod(stem):return f'D1Bound5.{stem}{k}'
    inputs,witness,arithmetic,closure,cached,left,right,triangle,data=[mod('SmallPairGraph'+s) for s in ['Inputs','WitnessData','Arithmetic','Closure','CachedData','Left','Right','Triangle','Data']]
    sieve=f'D1Bound5.SmallPairSieve_{tau}_{nu}'
    generic='D1Bound5.PairCachedFloorWitnesses' if backend=='sparse_floor' else 'D1Bound5.PairCachedIntegerObstruction'
    floors=mod('SmallPairFloorWitnessData')
    # Original reviewed expanded import lists, reconstructed without calling either producer.
    import_map={inputs:['D1Bound5.SmallPairGraphCheck'],
        witness:[inputs,'D1Bound5.PairClosureWitness'],
        arithmetic:[inputs,'D1Bound5.TwoSmallSeedDisks'],
        closure:[witness,'D1Bound5.PairClosureIndexedWitness'],
        data:[arithmetic,closure,triangle]}
    if backend=='structural':
        import_map[triangle]=[inputs,'D1Bound5.PairTraceZeroGraph',sieve]
    else:
        import_map[cached]=[inputs,'D1Bound5.PairCachedResidues',sieve]
        import_map[left]=[cached,generic]+([floors] if backend=='sparse_floor' else [])
        import_map[right]=import_map[left]
        import_map[triangle]=[left,right]
        if backend=='sparse_floor':import_map[floors]=['Mathlib.Data.List.Basic']
    expanded_hashes=oldrows[k]['files']
    assert expanded_hashes==row['expanded_files']
    reconstructed={}
    compact_sources={}
    for owner,ownership in row['body_ownership'].items():
        path=owner.replace('.','/')+'.lean'
        text=(BASE/path).read_text();compact_sources[path]=text
        pin=row['compact_files'][path]
        assert sha(text.encode())==pin['sha256'] and len(text.encode())==pin['bytes']
        blocks=iter(body_segments(text))
        for name in ownership['original_bodies']:
            body='' if name==data else next(blocks)
            assert sha(body.encode())==ownership['body_hashes'][name]
            full=''.join(f'import {x}\n' for x in import_map[name])
            if body:full+='\n'+body+'\n'
            oldpin=expanded_hashes[name.replace('.','/')+'.lean']
            assert sha(full.encode())==oldpin['sha256'] and len(full.encode())==oldpin['bytes'],name
            assert name not in reconstructed
            reconstructed[name]=full
        assert list(blocks)==[]
    assert set(reconstructed)==set(import_map)
    joined='\n'.join(compact_sources.values())
    declarations=original[original.index(f'def smallPairA_{k} '):original.index(f'theorem smallPairSeeds_{k}_checked')]
    assert sum(text.count(declarations) for text in compact_sources.values())==1
    for name in [f'smallPairSeeds_{k}_checked',f'smallPairFilter_{k}_checked',f'smallPairLarge_{k}_count',f'smallPairClosure_{k}_checked',f'smallPairNoTriangle_{k}_checked']:
        pat=rf'theorem {name}\b(.*?) :='
        assert re.findall(pat,original,re.S)==re.findall(pat,joined,re.S)
    results.append(dict(row=k,backend=backend,compact_modules=len(compact_sources),
        exact_reconstructed_expanded_modules=len(reconstructed),
        every_whole_namespace_body_byte_identical=True,
        every_data_proof_and_predicate_argument_byte_identical=True,
        original_public_declarations_occurrences=1,five_public_types_unchanged=True))

report=dict(status='Independent source reconstruction PASS; no generator execution or Lean compilation',
    compact_generator_sha256=sha((ROOT/'pair_backend_next/stage_pair_compact.py').read_bytes()),
    compact_manifest_sha256=sha((BASE/'manifest.json').read_bytes()),
    frozen_expanded_manifest_sha256=sha((ROOT/'pair_backend_next/all47_dry/manifest.json').read_bytes()),
    method='Parse balanced namespace blocks from actual compact Lean files; reconstruct every complete original expanded source using independent original import mapping; require byte-count and SHA equality with frozen expanded manifest. Thus all data, proofs and predicate arguments are preserved.',
    scope='Concrete samples2,8,22 cover cached-integer, sparse-floor and structural backends. Full45 generation is producer-owned; not independently rerun here.',
    results=results)
dest=ROOT/'audit_next/compact_bodies_review.json'
dest.write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
