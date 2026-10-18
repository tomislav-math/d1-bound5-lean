"""Append the final source assembly and performance fixes to checkpoint four."""
from pathlib import Path
import ast, base64, datetime, gzip, hashlib, json, re, shutil, subprocess

ROOT=Path('/Users/tp/Lean/D1Bound5')
RUN=ROOT/'research/continuations/20261018T010800CEST-main-continuation'
DEST=RUN/'checkpoint-4'
ADD=DEST/'addendum'
assert DEST.exists() and not ADD.exists()
git=lambda *args:subprocess.run(['git',*args],cwd=ROOT,check=True,capture_output=True,text=True).stdout.strip()
assert git('rev-parse','HEAD')=='b69d073ef5fb99dc9a4d62d47efc12e92e9c66da'
assert not git('diff','--name-only') and not git('diff','--cached','--name-only')
sha=lambda b:hashlib.sha256(b).hexdigest()
stamp=datetime.datetime.now(datetime.timezone.utc).isoformat()
assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex').read_bytes())=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
old={x['source']:x for x in json.loads((DEST/'SOURCE_MAP.json').read_text())['sources']}
ADD.mkdir()
rows=[]
for name in sorted(git('ls-files','--others','--exclude-standard','D1Bound5').splitlines()):
    if not name.endswith('.lean'):continue
    data=(ROOT/name).read_bytes()
    previous=old.get(name)
    if previous and previous['sha256']==sha(data):
        target=ROOT/previous['stored_at']
        assert target.read_bytes()==data
    else:
        target=ADD/'draft-delta'/Path(name).name
        target.parent.mkdir(parents=True,exist_ok=True)
        target.write_bytes(data)
    rows.append({'source':name,'stored_at':str(target.relative_to(ROOT)),'bytes':len(data),'sha256':sha(data)})
(ADD/'SOURCE_MAP.json').write_text(json.dumps({'utc':stamp,'sources':rows},indent=2)+'\n')
wrapper=json.loads((RUN/'checkpoint4-addendum-helpers.json').read_text())
helpers=json.loads(gzip.decompress(base64.b64decode(wrapper['data'],validate=True)))
for name,content in helpers.items():
    p=Path(name)
    assert not p.is_absolute() and '..' not in p.parts
    target=ADD/'helpers'/p
    target.parent.mkdir(parents=True,exist_ok=True)
    target.write_text(content)
runtime=['continuation_driver_parallel.py','continuation_driver_parallel_REVIEW.md',
         'continuation_driver_parallel_dummy_test.py','continuation-builds.json',
         'continuation-active.json','continuation-queue.json','checkpoint4_addendum.py']
runtime += [p.name for p in RUN.glob('wave*-receipt.json')]
for name in runtime:
    target=ADD/'verification'/name
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(RUN/name,target)
for source in (RUN/'continuation-builds').iterdir():
    previous=DEST/'verification/continuation-builds'/source.name
    previous3=RUN/'checkpoint-3/verification/continuation-builds'/source.name
    if any(p.exists() and p.read_bytes()==source.read_bytes() for p in [previous,previous3]):continue
    target=ADD/'verification/continuation-builds'/source.name
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(source,target)
tree=ast.parse((ROOT/'scripts/source_audit.py').read_text())
node=next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='remove_comments')
scope={}
exec(compile(ast.Module(body=[node],type_ignores=[]),'unchanged-source-audit-stripper','exec'),scope)
forbidden=re.compile(r'\b(sorry|admit|sorryAx|axiom|unsafe|native_decide|implemented_by|extern)\b|\+native\b|debug\.skipKernelTC|Lean\.ofReduce|\brun_(tac|cmd|elab)\b')
for row in rows:
    assert not forbidden.search(scope['remove_comments']((ROOT/row['stored_at']).read_text())),row['source']
record=ROOT/'records/runs/20261018T010800CEST-main-continuation-CHECKPOINT-4.md'
with record.open('a') as f:
    f.write(f'''\n## Final assembly addendum, {stamp}\n\nThe complete source-level assembly `main_statement : MainStatement.{{u}}` now exists, including the final five-region and one-small joins. Independent source/type audits found no extra analytic premises or narrowing of the full-ring target. This is **not a compiled proof of the main theorem**: most dependencies and large finite certificates still require compilation, followed by root integration, global axiom audit and fresh kernel replay. The addendum source map supersedes the earlier capture for current research files and preserves earlier versions.\n\nThe two-slot experiment caused excessive memory pressure and slower compilation. The coordinator was drained cleanly, restored to one slot and amended to cache scheduling artifact hashes by full stat identity. Launch now compares fresh artifact hashes against the previously accepted manifests, and completion rechecks the protected bytes in full. Nine dummy-process tests passed; the implementation and review are preserved. Seven two-small seed disk certificates passed a standalone build in about34 seconds. The old aggregate square-mask certificate timed out; unchanged masks are now split into smaller kernel-checkable obligations with a generic soundness bridge, still awaiting compilation. Both scheduled tasks remain disabled.\n''')
manifest_path=DEST/'MANIFEST.json'
files=sorted([p for p in DEST.rglob('*') if p.is_file() and p!=manifest_path]+[record])
manifest={'utc':stamp,'scope':'UNACCEPTED RESEARCH DELTA','previous_checkpoint_head':git('rev-parse','HEAD'),
          'files':[{'path':str(p.relative_to(ROOT)),'bytes':p.stat().st_size,'sha256':sha(p.read_bytes())} for p in files]}
manifest_path.write_text(json.dumps(manifest,indent=2)+'\n')
files.append(manifest_path)
secret=re.compile(rb'gh[pousr]_[A-Za-z0-9_]{30,}|github_pat_[A-Za-z0-9_]{30,}|-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----')
assert not [str(p) for p in files if secret.search(p.read_bytes())]
review=[{'path':str(p.relative_to(ROOT)),'sha256':sha(p.read_bytes())} for p in files]
(RUN/'checkpoint-4-reviewed-paths.json').write_text(json.dumps(review,indent=2)+'\n')
print(json.dumps({'reviewed_files':len(files),'bytes':sum(p.stat().st_size for p in files),
                  'current_research_sources':len(rows),'helpers':len(helpers),'policy_scan':'PASS','scope':'UNACCEPTED RESEARCH DELTA'}))
