from pathlib import Path
import json,sys,datetime,hashlib,shutil,re
P=Path('/Users/tp/Lean/D1Bound5/research/continuations/20261023-prove2me-full-upload')
R=Path('/Users/tp/Lean/D1Bound5-github-closeout-20261023')
L=P/'logical-closure-20261024'
D=R/'research/continuations/20261024-prove2me-main-statement-proved'
sys.path.insert(0,str(P))
import p2m_client as api
assert not D.exists(), 'Review existing destination before any overwrite'
root=json.loads((L/'ROOT_FINAL_THEOREM_RECEIPT.json').read_text())
assert root['status']=='Proved'
m=json.loads((L/'MANIFEST.json').read_text())
g=json.loads((P/'full-payloads/MANIFEST_COVERAGE_SLICES_V11.json').read_text())
s=json.loads((L/'UPLOAD_STATE.json').read_text())
gs=json.loads((P/'GLOBAL_UPLOAD_STATE.json').read_text())
gn={n['name']:n for n in g['nodes']}
assert all(s['entries'][n['name']]['proof_status'] in ('ACCEPTED','SKETCH_ACCEPTED') for n in m['nodes'])
target=next(n for n in m['nodes'] if n['name']=='D1Bound5.pellFiniteCertificate_exists')
assert target['payload']==gn[target['name']]['payload']
oldpath=P/gs['entries']['D1Bound5.main_statement']['existing_receipt']['path']
old=json.loads(oldpath.read_text())
def dicts(x):
    if isinstance(x,dict):
        yield x
        for v in x.values(): yield from dicts(v)
    elif isinstance(x,list):
        for v in x: yield from dicts(v)
prior=next(x for x in dicts(old) if x.get('theorem_id')==root['theorem_id'] and 'formal_statement' in x)
assert prior['formal_statement']==root['formal_statement']
assert prior['preamble']==root['preamble']
checks=[]
for n in m['nodes']:
    tid=s['entries'][n['name']]['theorem_id']
    r=api.request('/theorems/'+tid)
    assert r['status']=='Proved',(n['name'],r['status'])
    checks.append({'theorem_id':tid,'theorem_name':r['theorem_name'],'status':r['status']})
print('ALL_LOGICAL_THEOREMS_PROVED',len(checks),flush=True)
D.mkdir(parents=True)
shutil.copytree(L,D/'logical-closure',ignore=shutil.ignore_patterns('*.lock','OPEN_BRANCH_AUDIT.json'))
shutil.copy2(oldpath,D/'ROOT_ORIGINAL_EXISTING_RECEIPT.json')
(D/'coverage-slices/Definitions').mkdir(parents=True)
helpers=[]
for n in g['nodes']:
    if re.fullmatch('D1Bound5_Prove2MeTransfer_pellCertifiedFieldsSlice[0-9][0-9]_20261024',n['name']):
        code=n['payload']['definition']
        fn=n['name']+'.lean'
        (D/'coverage-slices/Definitions'/fn).write_text(code)
        c=dict(n);c['definition_file']='Definitions/'+fn;helpers.append(c)
assert len(helpers)==16
(D/'coverage-slices/DEFINITION_PAYLOADS.json').write_text(json.dumps(helpers,ensure_ascii=False,indent=2)+'\n')
shutil.copy2(P/'COVERAGE_SLICES_V11_PREPARATION.json',D/'coverage-slices/PREPARATION.json')
(D/'tools').mkdir()
for f in ['prepare_logical_closure.py','prepare_coverage_slices_v11.py','archive_logical_completion.py']:
    shutil.copy2(P/f,D/'tools'/f)
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
finish={'schema':1,'status':'ROOT_PROVED_CONFIRMED','checked_at':now,'first_confirmed_at':'2026-10-24T07:35:53+00:00','root_theorem_id':root['theorem_id'],'root_theorem_name':root['theorem_name'],'root_status':root['status'],'root_url':'https://prove2.me/theorems/'+root['theorem_id'],'root_formal_statement_and_preamble_unchanged_from_original_receipt':True,'finite_certificate_target_payload_unchanged':True,'logical_route_theorems':checks,'all_18_logical_route_theorems_proved':True,'unused_old_route':'The failed combined proof-valued coverage definition and its two unsubmitted consumer theorems are not dependencies of the successful certificate-existence proof. They remain archived; do not resume them.','previous_recovery_commit':'057b93ac5b23958da8de46770eab2df8f4e697fd','mathematical_source_files_changed':False}
(D/'COMPLETION.json').write_text(json.dumps(finish,ensure_ascii=False,indent=2)+'\n')
(P/'COMPLETION.json').write_text(json.dumps(finish,ensure_ascii=False,indent=2)+'\n')
coord=json.loads((P/'ACTIVE_MANUAL_CONTINUATION.json').read_text())
coord.update({'utc':now,'active_manual_continuation':False,'completed':True,'root_status':'Proved','mode':'COMPLETE','next_action':'No further uploads. Root is Proved. Do not resume obsolete combined-data routes.','completion_record':'COMPLETION.json'})
(P/'ACTIVE_MANUAL_CONTINUATION.json').write_text(json.dumps(coord,indent=2)+'\n')
(D/'README.md').write_text("""# Prove2Me root theorem proved

At 2026-10-24 07:35:53 UTC, the platform returned `Proved` for
`D1Bound5.main_statement` (ID `4bb5d407-713b-46ac-967d-97d7abf88598`).
All six immediate proof branches also returned `Proved`. The root statement
and preamble match its original registration receipt. The original
`pellFiniteCertificate_exists` target payload was unchanged.

## Final transfer route

The original combined coverage definition exceeded the platform compilation
timeout. Merely splitting its data left the combined dependency load too large.
The successful route proves certificate existence separately for 16 exact
consecutive slices of the original 1,016 certificate records. A lightweight
coverage theorem handles the first 50 parameters; the other 24 coverage
blocks were already proved. The final proof combines these theorem statements
without importing all certificate data into one compilation.

All 17 newly introduced helper theorems and the existing certificate-existence
theorem have been checked with platform status `Proved`. Their solution files,
exact submitted payloads, uploader ledger and receipts are under
`logical-closure/`. The historical final submission status `SKETCH_ACCEPTED`
records the proof reduction at submission time; the subsequent theorem
receipt records the now closed status `Proved`.

The 16 supporting definition payloads are under `coverage-slices/`.
`COMPLETION.json` records the final theorem IDs and checks. Raw root and
root-decomposition responses are under `logical-closure/`. All mathematical
source files in the canonical proof were left unchanged. This record concerns
platform completion; the earlier full local Lean kernel replay remains
separate evidence.

Old failed combined-data publications remain archived. Their unsubmitted
consumer nodes are not on the successful proof route and must not be resumed.
No repository or mission visibility was changed.
""")
files=sorted(p for p in D.rglob('*') if p.is_file())
(D/'SHA256SUMS.txt').write_text(''.join(hashlib.sha256(f.read_bytes()).hexdigest()+'  '+str(f.relative_to(D))+'\n' for f in files))
print('ARCHIVE_CREATED',str(D),'FILES',len(files)+1,'BYTES',sum(f.stat().st_size for f in D.rglob('*') if f.is_file()),flush=True)
print('COORDINATION_COMPLETE',flush=True)
