"""Local-only deterministic packet for completed cp12 helpers; no remote/Git/build."""
from pathlib import Path, PurePosixPath
import base64, datetime, gzip, hashlib, json, re
ROOT=Path(__file__).resolve().parent
EXPLICIT=[
 'pair_light_next/PairLightArithmetic.lean',
 'pair_light_next/PairLightArithmeticBridge.lean',
 'pair_light_next/README.md','pair_light_next/SOURCE_MANIFEST.json',
 'pair_light_next/LIGHT34_DATA_REPAIR.json',
 'pair_light_next/prepare_light34.py','pair_light_next/prepare_light34_v2.py',
 'pair_light_next/history/PairLightArithmeticBridge-35ced624.lean',
 'pair_light_next/history/PairLightArithmeticBridge-91befed.lean',
 'pair_light_next/left34/SmallPairLightLeft34.lean',
 'pair_light_next/left34/SmallPairLightAssembly34.lean',
 'pair_light_next/left34/manifest.json','pair_light_next/left34/assembly_manifest.json',
 'pair_light_next/left34_v2/SmallPairLightLeft34.lean',
 'pair_light_next/left34_v2/SmallPairLightAssembly34.lean',
 'pair_light_next/left34_v2/manifest.json',
 'pair_selected_scale_next/prepare_selected_rows.py',
 'pair_selected_scale_next/materialize_inputs.py',
 'pair_selected_scale_next/regenerate_missing_floors.py',
 'pair_selected_scale_next/input_requirements.json',
 'pair_selected_scale_next/test_materialize_inputs.py',
 'pair_selected_scale_next/README.md','pair_selected_scale_next/MATERIALIZER.md',
 'pair_selected_scale_next/REGENERATE_FLOORS.md',
 'pair_selected_scale_next/handoff.json',
 'pair_selected_scale_next/dry_inventory/manifest.json',
 'pair_selected_scale_next/pilot47/manifest.json',
 'audit_next/LIGHT34_DATA_REPAIR.json',
 'audit_next/checkpoint12_independent_review.json',
 'audit_next/light34_data_assembly_review.json','audit_next/light34_data_failure.json',
 'audit_next/pair_light_arithmetic_review.json',
 'audit_next/pair_light_bridge_review.json',
 'audit_next/pair_light_bridge_91befed_review.json',
 'audit_next/pair_light_bridge_74989ea_review.json',
 'audit_next/prepare_light34_source_review.json',
 'audit_next/regenerate_missing_floors_review.json',
 'audit_next/review_selected_scale.py',
 'audit_next/selected_input_materializer_review.json',
 'audit_next/selected_input_materializer_source_audit.json',
 'audit_next/selected_requirements_owner_review.json',
 'audit_next/selected_scale_source_review.json',
 'audit_next/verify_light34_data.py','audit_next/verify_selected_input_requirements.py',
 'prepare_checkpoint12.py','stage_checkpoint12.py',
 'checkpoint12-prepare-from11.patch','checkpoint12-stage-from11.patch',
 'checkpoint12-script-review.json','prepare_checkpoint12_helpers.py',
]
PILOT_STEMS=['SmallPairGraphArithmetic47','SmallPairGraphClosure47',
 'SmallPairGraphData47','SmallPairGraphInputs47','SmallPairGraphTriangle47',
 'SmallPairGraphWitnessData47','SmallPairRawSelectedData47',
 'SmallPairRawSelectedLeft47','SmallPairRawSelectedRight47']
EXPLICIT += [f'pair_selected_scale_next/pilot47/D1Bound5/{n}.lean' for n in PILOT_STEMS]
EXPLICIT += [f'analytic_repairs_20261018/frontier_retry2/{n}' for n in [
 'FrontierScalarReduction.before.txt','FrontierScalarReduction.lean',
 'repair.json','repair.patch','actual-failure.log','independent-review.json']]
EXPLICIT += [f'unit_pair_repairs_20261018/{n}' for n in [
 'FullRingUnitPairPell.before.lean','FullRingUnitPairPell.lean',
 'FullRingUnitPairPell.compile-failure.log','FullRingUnitPairPell.manifest.json',
 'FullRingUnitPairPell.patch']]

def sha(data):return hashlib.sha256(data).hexdigest()
def stable(path):
 p=ROOT/path
 assert p.is_file() and not p.is_symlink() and p.resolve().is_relative_to(ROOT)
 a=p.stat();b=p.read_bytes();c=p.stat()
 sig=lambda s:(s.st_dev,s.st_ino,s.st_size,s.st_mtime_ns,s.st_ctime_ns)
 assert sig(a)==sig(c) and len(b)==c.st_size,path
 return b

assert len(EXPLICIT)==len(set(EXPLICIT))
for n in EXPLICIT:
 p=PurePosixPath(n)
 assert not p.is_absolute() and '..' not in p.parts and str(p)==n
 assert not any(ord(c)<32 for c in n)
 assert 'right34/' not in n and 'prepare_light_right34' not in n
 assert not n.endswith('SmallPairLightData34.lean')
raw={n:stable(n) for n in sorted(EXPLICIT)}
helpers={n:b.decode('utf-8') for n,b in raw.items()}
# Cross-check every included concrete pilot against its frozen generator manifest.
pilot=json.loads(raw['pair_selected_scale_next/pilot47/manifest.json'])
prospective=next(r['files'] for r in pilot['results'] if r['row']==47)
assert len(prospective)==9
for n,pin in prospective.items():
 key='pair_selected_scale_next/pilot47/'+n
 assert sha(raw[key])==pin['sha256'] and len(raw[key])==pin['bytes']
assert sha(raw['prepare_checkpoint12.py'])=='481b96aa453fba73186b9850970854e5a2cc78746b4ea16757c5133e7597db6c'
assert sha(raw['stage_checkpoint12.py'])=='8c4a74e5b2588dc8fa1f404bf72679b05f42998153efe746fef5a8078b490ece'
secret=re.compile(rb'gh[pousr]_[A-Za-z0-9_]{30,}|github_pat_[A-Za-z0-9_]{30,}|-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----')
for name,data in raw.items():
 assert not secret.search(data),name
 if name.endswith('.json'):json.loads(data)
payload=json.dumps(helpers,sort_keys=True,ensure_ascii=False,separators=(',',':')).encode()
compressed=gzip.compress(payload,compresslevel=9,mtime=0)
packet=(json.dumps({'encoding':'gzip-base64','data':base64.b64encode(compressed).decode()},separators=(',',':'))+'\n').encode()
# Decode independently through the same format expected by reviewed prepare12.
parsed=json.loads(gzip.decompress(base64.b64decode(json.loads(packet)['data'],validate=True)))
assert set(parsed)==set(raw)
for n,b in raw.items():assert parsed[n].encode()==b and stable(n)==b,n
manifest={'scope':'Stable completed cp12 helper/source review packet; unaccepted research only',
 'encoding':'gzip-base64','packet_file':'checkpoint12-helpers.json',
 'packet_sha256':sha(packet),'packet_bytes':len(packet),'gzip_bytes':len(compressed),
 'helper_count':len(raw),'helper_bytes':sum(map(len,raw.values())),
 'prepared_pilot47_lean_count':9,'prepared_pilot47_source_bytes':sum(len(raw['pair_selected_scale_next/pilot47/'+n]) for n in prospective),
 'checks':['Unique safe relative UTF-8 paths','Stable before/after source reads','Every pilot47 file matches frozen manifest bytes/SHA','All JSON parsed','No credential/private-key patterns','Gzip/base64 round-trip preserves every exact file byte','Reviewed cp12 scripts retain exact frozen hashes'],
 'intentional_exclusions':['Large SmallPairLightData34 literals are already backed in waves86/87; their manifests/reviews remain included','New right34, all-row lightweight work and other active drafts are outside this frozen allowlist','No accepted/project source, remote directory, Git index or compiler is modified'],
 'files':[{'path':n,'bytes':len(b),'sha256':sha(b)} for n,b in raw.items()]}
(ROOT/'checkpoint12-helpers.json').write_bytes(packet)
(ROOT/'checkpoint12-helper-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({k:manifest[k] for k in ['packet_sha256','packet_bytes','helper_count','helper_bytes','prepared_pilot47_lean_count','prepared_pilot47_source_bytes']},indent=2))
print('manifest_sha256',sha((ROOT/'checkpoint12-helper-manifest.json').read_bytes()))
