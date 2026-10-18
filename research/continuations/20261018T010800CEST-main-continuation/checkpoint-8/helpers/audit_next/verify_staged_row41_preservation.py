from pathlib import Path
import re,json,hashlib
ROOT=Path(__file__).resolve().parents[1]
base=ROOT/'pair_witness_next/staged_all48'
original=(ROOT/'finite_next/two_small/D1Bound5/SmallPairGraphData41.lean').read_text()
inputs=(base/'common/D1Bound5/SmallPairGraphInputs41.lean').read_text()
block=original[original.index('def smallPairA_41 '):original.index('theorem smallPairSeeds_41_checked')]
assert inputs.count(block)==1
arithmetic=(base/'common/D1Bound5/SmallPairGraphArithmetic41.lean').read_text()
for n in ('smallPairSeeds_41_checked','smallPairFilter_41_checked','smallPairLarge_41_count'):
 old=re.search(rf'theorem {n}\b.*?(?=\n\ntheorem |\n\nend D1Bound5)',original,re.S).group()
 assert old in arithmetic,n
checks=[]
for path,n in [('indexed/D1Bound5/SmallPairGraphClosure41.lean','smallPairClosure_41_checked'),('membership/D1Bound5/SmallPairGraphClosure41.lean','smallPairClosure_41_checked'),('cached/D1Bound5/SmallPairGraphData41.lean','smallPairNoTriangle_41_checked')]:
 src=(base/path).read_text()
 old=re.search(rf'theorem {n}\b.*? :=',original,re.S).group()
 new=re.search(rf'theorem {n}\b.*? :=',src,re.S).group()
 assert old==new,(path,n)
 checks.append({'path':path,'public_theorem_statement_exact':n})
manifest=json.loads((base/'manifest_41_cached_staged.json').read_text())['results'][0]
for path,pin in manifest['files'].items():
 b=(base/path).read_bytes();assert len(b)==pin['bytes'] and hashlib.sha256(b).hexdigest()==pin['sha256'],path
# Old diagnostic-only color data can remain physically present; only manifest-selected files install.
report={'parser_sha256':hashlib.sha256((ROOT/'pair_witness_next/pair_staging.py').read_bytes()).hexdigest(),'generator_sha256':hashlib.sha256((ROOT/'pair_witness_next/stage_all48_witnesses.py').read_bytes()).hexdigest(),'review':'PASS for SHA-pinned current48 original formats','row41_original_declaration_block_sha256':hashlib.sha256(block.encode()).hexdigest(),'declarations':'entire original block preserved byte-for-byte exactly once','arithmetic':'all3 original theorem blocks preserved byte-for-byte','changed_proofs_same_statements':checks,'emitted_manifest':'all5 emitted source hashes and byte lengths match, including both closure alternatives','scope':'No full48 regeneration, no writes to staged files, no compiler run. Installation must select common + exactly one closure backend + exactly one color backend; stale alternative files are intentionally not selected.'}
(ROOT/'audit_next/staging_preservation_review.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
