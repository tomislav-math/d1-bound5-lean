"""Fourth research snapshot; never changes accepted proof/root files."""
from pathlib import Path
import ast
import base64
import datetime
import gzip
import hashlib
import json
import re
import shutil
import subprocess

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT/'research/continuations/20261018T010800CEST-main-continuation'
DEST = RUN/'checkpoint-4'
assert not DEST.exists(), 'Review the existing snapshot instead of replacing it'
git = lambda *args: subprocess.run(['git',*args],cwd=ROOT,check=True,text=True,capture_output=True).stdout.strip()
assert git('rev-parse','HEAD') == 'b69d073ef5fb99dc9a4d62d47efc12e92e9c66da'
assert not git('diff','--name-only')
assert not git('diff','--cached','--name-only')
sha = lambda b: hashlib.sha256(b).hexdigest()
assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex').read_bytes()) == '776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
stamp = datetime.datetime.now(datetime.timezone.utc).isoformat()
DEST.mkdir()
old = {x['source']:x for x in json.loads((RUN/'checkpoint-3/SOURCE_MAP.json').read_text())['sources']}
source_map = []
for name in sorted(git('ls-files','--others','--exclude-standard','D1Bound5').splitlines()):
    if not name.endswith('.lean'): continue
    data = (ROOT/name).read_bytes()
    previous = old.get(name)
    if previous and previous['sha256'] == sha(data):
        target = ROOT/previous['stored_at']
        assert target.read_bytes() == data
    else:
        target = DEST/'draft-delta'/Path(name).name
        target.parent.mkdir(parents=True,exist_ok=True)
        target.write_bytes(data)
    source_map.append({'source':name,'stored_at':str(target.relative_to(ROOT)),
                       'bytes':len(data),'sha256':sha(data)})

helpers = {}
for pack, count in [(0,3),(1,9)]:
    encoded = ''.join((RUN/f'checkpoint4-helpers-{pack}-part{i}.txt').read_text() for i in range(count))
    wrapper = json.loads(encoded)
    assert wrapper['encoding'] == 'gzip-base64'
    part = json.loads(gzip.decompress(base64.b64decode(wrapper['data'],validate=True)))
    assert not set(helpers)&set(part)
    helpers.update(part)
for name, text in helpers.items():
    path = Path(name)
    assert not path.is_absolute() and '..' not in path.parts
    target = DEST/'helpers'/path
    target.parent.mkdir(parents=True,exist_ok=True)
    target.write_text(text)

runtime = ['continuation_driver.py','continuation_driver_parallel.py',
           'continuation_driver_parallel_REVIEW.md','continuation_driver_parallel_dummy_test.py',
           'intake_continuation.py','prepare_parallel_baseline.py','prepare_checkpoint4.py',
           'continuation-queue.json','continuation-builds.json','continuation-active.json',
           'continuation-trusted-baseline.json','checkpoint-3-push-receipt.json',
           'pair-seed-benchmark-interruption.json','pell-reproduction-receipt.json']
runtime += [p.name for p in RUN.glob('wave*-receipt.json')]
for name in runtime:
    source = RUN/name
    if not source.exists(): continue
    target = DEST/'verification'/name
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(source,target)
for source in (RUN/'continuation-builds').iterdir():
    previous = RUN/'checkpoint-3/verification/continuation-builds'/source.name
    if previous.exists() and previous.read_bytes() == source.read_bytes(): continue
    target = DEST/'verification/continuation-builds'/source.name
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(source,target)

# Reuse the unchanged audit's nested-comment stripper without executing its
# root-reachability check: these are explicitly unintegrated research files.
tree = ast.parse((ROOT/'scripts/source_audit.py').read_text())
node = next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='remove_comments')
scope = {}
exec(compile(ast.Module(body=[node],type_ignores=[]),'existing-audit-stripper','exec'),scope)
forbidden = re.compile(r'\b(sorry|admit|sorryAx|axiom|unsafe|native_decide|implemented_by|extern)\b|\+native\b|debug\.skipKernelTC|Lean\.ofReduce|\brun_(tac|cmd|elab)\b')
for row in source_map:
    assert not forbidden.search(scope['remove_comments']((ROOT/row['stored_at']).read_text())), row['source']
rows = json.loads((DEST/'verification/continuation-builds.json').read_text())
latest = {(r['name'],r['fingerprint']):r for r in rows}
def closure(name, seen=None):
    seen = {} if seen is None else seen
    if name in seen: return seen
    data = (ROOT/'D1Bound5'/(name+'.lean')).read_bytes()
    seen[name] = sha(data)
    for dep in re.findall(rb'^import D1Bound5\.([A-Za-z0-9_]+)\s*$',data,re.M):closure(dep.decode(),seen)
    return seen
passed=[]
for name in json.loads((DEST/'verification/continuation-queue.json').read_text())['names']:
    key = sha(json.dumps(closure(name),sort_keys=True).encode())
    if latest.get((name,key),{}).get('accepted_build',False):passed.append(name)
(DEST/'SOURCE_MAP.json').write_text(json.dumps({'utc':stamp,'sources':source_map},indent=2)+'\n')
record = ROOT/'records/runs/20261018T010800CEST-main-continuation-CHECKPOINT-4.md'
record.write_text(f'''# Main-theorem continuation: fourth research checkpoint

Captured {stamp}. **MainStatement remains UNPROVED.** This is research backup, not accepted-root integration. All tracked accepted mathematical sources, the accepted root and configuration, and the frozen manuscript remain unchanged.

The source map records {len(source_map)} current research Lean files with exact hashes and storage in earlier checkpoints or the new delta. {len(helpers)} supporting scripts, notes and small generated records are preserved. Large finite data remain backed by exact generated Lean sources and reproducible generators.

Current successful standalone target fingerprints at capture: {', '.join(passed)}. This does not assert final root reachability, global axiom acceptance or full fresh kernel replay for these drafts. The previously accepted baseline remains107 modules,484 explicit public declarations,922 globally audited D1 declarations, with earlier root build and same-kernel replay PASS.

New source chains supply actual uniform and adaptive P, Q, M, N2, N3 and A3/A4/A5 matrices, integral row selection, root transfer and closed exclusion windows. Source-level final contradictions now exist for the all-large branch, nondegenerate exactly-two-small branch, unit-pair branch and three-small branch. The fixed one-small cutoff chain and first-pair geometry have concrete implementations; final one-small classification and universal rational(1,3,8) joins are still being completed. These are uncompiled or partially compiled research statements, not claims of theorem completion.

The full 1016-field Pell source data were reproduced exactly. The generic Pell matching checker and small matching pilot have compiled; full field certificates and48 graph families remain gated by benchmarks. The new pure-list disk bridge and four seed-disk certificates compiled in about31 seconds for the seed target, replacing a finite-set calculation interrupted after about20 minutes. All mathematical certificates use ordinary kernel checking; no custom axioms, sorry/admit or native_decide occur in these proposed sources.

The serial worker was stopped at a completed-target boundary. An independently reviewed and dummy-process-tested two-slot coordinator now protects the union of active source closures, immutable accepted artifacts and configuration; intakes share its lock. Its trusted-baseline hashes carry earlier successful-build provenance and are scheduling trust, not additional mathematical acceptance. Logs, exact source snapshots and failure records are preserved. Active logs may be partial at this snapshot.

Remaining gates: complete all source joins, compile every dependency and finite certificate, integrate the genuine main statement into the accepted root, inspect its type and axioms, update proof/manifest records and run fresh root verification. Both user-requested automations remain paused. This record is not a push receipt.
''')
files=sorted([p for p in DEST.rglob('*') if p.is_file()]+[record])
manifest={'utc':stamp,'scope':'UNACCEPTED RESEARCH DELTA','previous_checkpoint_head':git('rev-parse','HEAD'),
          'files':[{'path':str(p.relative_to(ROOT)),'bytes':p.stat().st_size,'sha256':sha(p.read_bytes())} for p in files]}
(DEST/'MANIFEST.json').write_text(json.dumps(manifest,indent=2)+'\n')
files.append(DEST/'MANIFEST.json')
secrets=re.compile(rb'gh[pousr]_[A-Za-z0-9_]{30,}|github_pat_[A-Za-z0-9_]{30,}|-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----')
assert not [str(p) for p in files if secrets.search(p.read_bytes())]
review=[{'path':str(p.relative_to(ROOT)),'sha256':sha(p.read_bytes())} for p in files]
(RUN/'checkpoint-4-reviewed-paths.json').write_text(json.dumps(review,indent=2)+'\n')
print(json.dumps({'files':len(files),'bytes':sum(p.stat().st_size for p in files),
                  'all_current_drafts':len(source_map),'current_standalone_passes':passed,
                  'policy_scan':'PASS for research mathematical sources only',
                  'scope':'UNACCEPTED RESEARCH DELTA'}))
