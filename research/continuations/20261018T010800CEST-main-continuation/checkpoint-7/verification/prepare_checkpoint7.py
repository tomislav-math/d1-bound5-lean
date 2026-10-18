"""Seventh unaccepted research checkpoint; exact deltas only."""
from pathlib import Path
import ast,base64,datetime,gzip,hashlib,json,re,shutil,subprocess
ROOT=Path('/Users/tp/Lean/D1Bound5')
RUN=ROOT/'research/continuations/20261018T010800CEST-main-continuation'
DEST=RUN/'checkpoint-7'
git=lambda *a:subprocess.run(['git',*a],cwd=ROOT,check=True,capture_output=True,text=True).stdout.strip()
assert not DEST.exists()
assert git('rev-parse','HEAD')=='e4ddd1faf7370dbd6e21974c96cd4b85ddca300c'
assert not git('diff','--name-only') and not git('diff','--cached','--name-only')
sha=lambda b:hashlib.sha256(b).hexdigest()
stamp=datetime.datetime.now(datetime.timezone.utc).isoformat()
assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex').read_bytes())=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
old={x['source']:x for x in json.loads((RUN/'checkpoint-6/SOURCE_MAP.json').read_text())['sources']}
DEST.mkdir()
rows=[]
for name in sorted(git('ls-files','--others','--exclude-standard','D1Bound5').splitlines()):
    if not name.endswith('.lean'):continue
    data=(ROOT/name).read_bytes();previous=old.get(name)
    if previous and previous['sha256']==sha(data):
        target=ROOT/previous['stored_at'];assert target.read_bytes()==data
    else:
        target=DEST/'draft-delta'/Path(name).name
        target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(data)
    rows.append({'source':name,'stored_at':str(target.relative_to(ROOT)),'bytes':len(data),'sha256':sha(data)})
(DEST/'SOURCE_MAP.json').write_text(json.dumps({'utc':stamp,'sources':rows},indent=2)+'\n')
w=json.loads((RUN/'checkpoint7-helpers.json').read_text())
helpers=json.loads(gzip.decompress(base64.b64decode(w['data'],validate=True)))
for name,content in helpers.items():
    p=Path(name);assert not p.is_absolute() and '..' not in p.parts
    target=DEST/'helpers'/p;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(content)
runtime=['continuation_driver_parallel.py','continuation_driver_parallel_REVIEW.md',
         'continuation_driver_parallel_dummy_test.py','continuation-builds.json',
         'continuation-active.json','continuation-queue.json','prepare_checkpoint7.py','stage_checkpoint7.py',
         'bounded-two-sieve-trial.json','graph41-cached-priority.json',
         'checkpoint-6-push-receipt.json','checkpoint-6-index-review.json']
runtime += [p.name for p in RUN.glob('wave*-receipt.json') if int(re.search(r'\d+',p.name)[0])>=55]
for name in runtime:
    target=DEST/'verification'/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(RUN/name,target)
for source in (RUN/'continuation-builds').iterdir():
    parents=[RUN/'checkpoint-6/verification/continuation-builds'/source.name,
             RUN/'checkpoint-5/verification/continuation-builds'/source.name,
             RUN/'checkpoint-4/addendum/verification/continuation-builds'/source.name,
             RUN/'checkpoint-4/verification/continuation-builds'/source.name,
             RUN/'checkpoint-3/verification/continuation-builds'/source.name]
    if any(p.exists() and p.read_bytes()==source.read_bytes() for p in parents):continue
    target=DEST/'verification/continuation-builds'/source.name
    target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source,target)
tree=ast.parse((ROOT/'scripts/source_audit.py').read_text())
node=next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='remove_comments')
scope={};exec(compile(ast.Module(body=[node],type_ignores=[]),'unchanged-stripper','exec'),scope)
forbidden=re.compile(r'\b(sorry|admit|sorryAx|axiom|unsafe|native_decide|implemented_by|extern)\b|\+native\b|debug\.skipKernelTC|Lean\.ofReduce|\brun_(tac|cmd|elab)\b')
for row in rows:assert not forbidden.search(scope['remove_comments']((ROOT/row['stored_at']).read_text())),row['source']
record=ROOT/'records/runs/20261018T010800CEST-main-continuation-CHECKPOINT-7.md'
record.write_text(f'''# Main-theorem continuation: seventh research checkpoint\n\nCaptured {stamp}. **MainStatement remains UNPROVED.** The final assembly and all case endpoints are written and source-audited, but the full main-theorem dependency closure has not compiled. This snapshot is private research backup, with unchanged accepted root/configuration and frozen manuscript.\n\nLatest standalone successes include PellCFPrefixCheck, PairBipartiteCheck, PairCachedResidues, PairClosureIndexedWitness, SmallPairIndexedClosure41, and the Graph41 data, seeds, filter, and witness-data modules. Earlier checkpoints preserve the aggregate PASS for all 275 modular masks and the successful generic PairClosureWitness and PellConvergentCompleteness modules. These are specific verified gates, not a completed main theorem or finite-graph exclusion.\n\nThe original monolithic Graph41 attempt and the unindexed witness-closure attempt each reached the 600-second timeout. The indexed generic theorem passed after a parentheses repair, and its concrete Graph41 closure certificate passed in78.1968seconds. The concrete cached color certificates remain pending at this capture. A source or data-module PASS does not imply that an associated closure certificate has passed. Exact results and source fingerprints are preserved in the build receipts.\n\nThis checkpoint preserves the exact source delta, current compiler receipts, and source-only API repair/audit material since checkpoint 6. The compiler remains serial. Main closure compilation and fresh same-kernel final replay remain required. No root integration or whole-root axiom/replay claim is made.\n\nThe source map retains earlier exact drafts through stored-path references. Build logs are included only when their contents differ from all matching logs in checkpoints 6, 5, 4/addendum, 4, and 3. Logs, queue data, and active receipts are point-in-time snapshots and can include unfinished jobs. Both scheduled tasks remain paused. This record is not a push receipt.\n''')
files=sorted([p for p in DEST.rglob('*') if p.is_file()]+[record])
manifest={'utc':stamp,'scope':'UNACCEPTED RESEARCH DELTA','previous_checkpoint_head':git('rev-parse','HEAD'),
          'files':[{'path':str(p.relative_to(ROOT)),'bytes':p.stat().st_size,'sha256':sha(p.read_bytes())} for p in files]}
mp=DEST/'MANIFEST.json';mp.write_text(json.dumps(manifest,indent=2)+'\n');files.append(mp)
secret=re.compile(rb'gh[pousr]_[A-Za-z0-9_]{30,}|github_pat_[A-Za-z0-9_]{30,}|-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----')
assert not [str(p) for p in files if secret.search(p.read_bytes())]
(RUN/'checkpoint-7-reviewed-paths.json').write_text(json.dumps([{'path':str(p.relative_to(ROOT)),'sha256':sha(p.read_bytes())} for p in files],indent=2)+'\n')
print(json.dumps({'reviewed_files':len(files),'bytes':sum(p.stat().st_size for p in files),'research_sources':len(rows),'scope':'UNACCEPTED RESEARCH DELTA'}))
