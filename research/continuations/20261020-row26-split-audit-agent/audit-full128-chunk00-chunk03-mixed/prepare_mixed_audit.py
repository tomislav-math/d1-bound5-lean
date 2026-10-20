"""ROOT ONLY: prepare, but never execute, the 54-type /20-fresh /10-reused audit.
Requires the chunk03 repair and all 30 exact current guarded builds to have passed.
Original monolith types/definition bodies use the previously reviewed parser unchanged.
"""
from pathlib import Path
from datetime import datetime, timezone
import ast, fcntl, hashlib, importlib.util, json, os, re, sys
ROOT=Path('/Users/tp/Lean/D1Bound5'); HERE=Path(__file__).resolve().parent
WORK=ROOT/'research/continuations/20261018T010800CEST-main-continuation'
AGENT=ROOT/'research/continuations/20261020-row26-split-audit-agent'
OUT=AGENT/'audit-full128-chunk00-chunk03-mixed'
OLD=AGENT/'audit-full128-chunk00'
DECOMP=ROOT/'research/continuations/20261020-graph-decomposition-agent'
SPLIT=DECOMP/'failed-chunk03-replay'
DRIVER_SHA='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PARSER_SHA='9af61b7eae1c50d76d1fc2e0934ee4f656a545659df5d61afb3fcf3e7b809998'
PREIMAGE_SHA='a57bbf27d4c0d04db067f51a9830c4d995c29a0840abdbe2442719493ae3ee85'
HELPER_SHA='29488713ab2248b4e724873977d8278f8e302994a76dfd2d1c47bf8aa3e6e226'
PLAN_SHA='6ddca2790ea45ca3257ee3f3b9a18f62793a9575eed7c8396d9da8019a054636'
SCOPE_SHA='90dbd3e79c59d411105b5a95c8386e3c034a160ff64c7660148c7e7a9d4e3d46'
REUSE_CODE_SHA='cb7b3210764909841c7baf36737e6e1454e83a8d244144abdb7916c193368cec'
RUNNER_SHA='0cbefe7f53c93661f1cf29e993cbc29c4daaca70a99dec410598addd36f74331'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def utc(): return datetime.now(timezone.utc).isoformat()
def canonical(n): return ROOT/'D1Bound5'/(n+'.lean')
def put(p,b):
    if isinstance(b,str): b=b.encode()
    with p.open('xb') as f: f.write(b); f.flush(); os.fsync(f.fileno())
def save(p,x): put(p,json.dumps(x,indent=2)+'\n')
def load_module(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    mod=importlib.util.module_from_spec(spec); sys.modules[name]=mod; spec.loader.exec_module(mod)
    return mod
assert not OUT.exists(),'Preserve any previous preparation/attempt; do not overwrite.'
parser=AGENT/'prepare_full128_chunk00_audit.py'
preimage=DECOMP/'complete/SmallPairGraphData26.preimage.lean'
helper=DECOMP/'complete/optional-indexed-chunks/PairClosureIndexedChunks.lean'
input_pins={str(parser):PARSER_SHA,str(preimage):PREIMAGE_SHA,str(helper):HELPER_SHA,
 str(SPLIT/'PLAN.json'):PLAN_SHA,str(SPLIT/'AUDIT_SCOPE_PROPOSAL.json'):SCOPE_SHA,
 str(HERE/'row26_reuse_checks.py'):REUSE_CODE_SHA,str(HERE/'locked_checks_mixed_v3.py'):RUNNER_SHA,
 str(WORK/'continuation_driver_capacity.py'):DRIVER_SHA,str(Path(__file__).resolve()):sha(Path(__file__))}
assert all(sha(Path(p))==h for p,h in input_pins.items())
# Extract only the pinned parser function: never execute the old preparer's top level.
tree=ast.parse(parser.read_text()); nodes=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='declarations']
assert len(nodes)==1
namespace={'re':re}; exec(compile(ast.Module(body=nodes,type_ignores=[]),str(parser),'exec'),namespace)
declarations=namespace['declarations']
plan=json.loads((SPLIT/'PLAN.json').read_text()); scope=json.loads((SPLIT/'AUDIT_SCOPE_PROPOSAL.json').read_text())
assert plan['failed_audit_evidence']==scope['old_attempt_evidence_sha256']
assert all(sha(OLD/n)==h for n,h in plan['failed_audit_evidence'].items())
old_decl=json.loads((OLD/'DECLARATIONS.json').read_text())
expected={d['name']:d for d in old_decl}; assert len(old_decl)==len(expected)==50
original=declarations(preimage.read_text(),'SmallPairGraphData26')
helper_decls=declarations(helper.read_text(),'PairClosureIndexedChunks')
assert len(original)==28 and sum(d['kind']=='def' for d in original)==13
assert len(helper_decls)==5 and sum(d['kind']=='def' for d in helper_decls)==1
for d in original+helper_decls:
    for k in ['kind','namespace','binders','statement']: assert d[k]==expected[d['name']][k]
    expected[d['name']]=d
new_names=[]
for part in plan['parts']:
    n=part['module']; p=SPLIT/(n+'.lean'); assert sha(p)==plan['source_manifest'][n]
    input_pins[str(p)]=sha(p); new_names.append(n)
    ds=declarations(p.read_text(),n); assert len(ds)==1 and ds[0]['kind']=='theorem'
    assert ds[0]['name'] not in expected; expected[ds[0]['name']]=ds[0]
assert len(expected)==54 and sum(d['kind']=='def' for d in expected.values())==14
targets=json.loads((OLD/'TARGETS.json').read_text())+new_names
fresh=new_names+['SmallPairGraphClosure26Chunk128_03']
fresh += [f'SmallPairGraphClosure26Chunk128_{i:02d}' for i in range(4,11)]
fresh += ['SmallPairGraphClosure26Tail128','SmallPairGraphClosure26Coverage']
fresh += [f'SmallPairGraphClosure26Chunk128_00Part{i}' for i in range(4)]
fresh += ['SmallPairGraphClosure26','SmallPairGraphData26']
assert set(fresh)==set(scope['fresh_replay_targets']) and len(fresh)==20
source_expected=dict(json.loads((OLD/'PREPARATION_REVIEW.json').read_text())['current_source_hashes'])
source_expected.update(plan['source_manifest']); assert set(source_expected)==set(targets)
old_guards=json.loads((OLD/'TARGETED_REPLAY_GUARDS.json').read_text())
old_receipts=json.loads((OLD/'TARGETED_REPLAY_RECEIPTS.json').read_text())
reuse={'schema':'row26-exact-prior-replay-reuse-v1','old_audit':str(OLD),
 'old_file_hashes':plan['failed_audit_evidence'],'failed_receipt':old_receipts[-1],
 'reused_targets':scope['reusable_successes'],'entries':scope['reuse_evidence'],
 'immutable_inputs':old_guards['immutable_inputs']}
checks=load_module('row26_mixed_prepare_reuse',HERE/'row26_reuse_checks.py')
mod=load_module('row26_mixed_prepare_driver',WORK/'continuation_driver_capacity.py')
with (WORK/'continuation-driver.lock').open('r+') as owner,(WORK/'continuation-intake.lock').open('r+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB); fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    d=mod.Driver(ROOT,WORK); active_bytes=d.active_path.read_bytes(); active=json.loads(active_bytes)
    assert not active.get('active') and not active.get('protected_closure')
    q,names,closures,accepted,unknown,eligible=d.snapshot()
    assert not unknown and q['max_parallel']==1 and q['pause_after_current'] is True
    assert set(targets)<=accepted,'All 30 current guarded builds are mandatory.'
    current=[]; source_hashes={}
    for n in targets:
        p=canonical(n); source_hashes[n]=sha(p); current+=declarations(p.read_text(),n)
    assert source_hashes==source_expected
    assert len(current)==54 and len({x['name'] for x in current})==54
    assert {x['name'] for x in current}==set(expected)
    definitions={}
    for item in current:
        prior=expected[item['name']]
        for k in ['kind','namespace','binders','statement']: assert item[k]==prior[k],(item['name'],k)
        if item['kind']=='def':
            assert item['body']==prior['body'],item['name']
            definitions[item['name']]=hashlib.sha256(item['body'].encode()).hexdigest()
    assert len(definitions)==14
    frozen={}
    for n in targets: frozen.update(closures[n])
    latest=d.latest(); artifacts={}; by_module={}
    for n in sorted(frozen):
        manifest=d.expected_manifest(n,mod.fingerprint(closures[n]),latest)
        assert isinstance(manifest,dict) and manifest and d.manifest_matches(manifest,cached=False),n
        by_module[n]=dict(manifest)
        for p,h in manifest.items():
            assert p not in artifacts or artifacts[p]==h
            artifacts[p]=h
    static=dict(d.static); coverage=checks.validate_reuse(reuse,targets,fresh,closures,by_module,static)
    queue_bytes=d.queue_path.read_bytes(); assert json.loads(queue_bytes)==q
    def stable():
        return (all(sha(Path(p))==h for p,h in input_pins.items()) and checks.old_evidence_stable(reuse)
          and all(sha(canonical(n))==h for n,h in frozen.items())
          and d.manifest_matches(artifacts,cached=False) and d.manifest_matches(static,cached=False)
          and d.queue_path.read_bytes()==queue_bytes and d.active_path.read_bytes()==active_bytes)
    assert stable() and not OUT.exists()
    decls=[{k:v for k,v in item.items() if k!='body'} for item in current]
    text='import D1Bound5.SmallPairGraphData26\nimport Lean.Elab.Command\nimport Lean.Util.CollectAxioms\n\nopen Lean Elab Command\nset_option autoImplicit false\nset_option maxRecDepth 100000\n\nrun_cmd do\n  let names : List Name := [\n'
    text+=',\n'.join('    `'+item['name'] for item in decls)+']\n'
    text+='  for name in names do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n\n    unless bad.isEmpty do\n      throwError "Unexpected axioms in {name}: {bad}"\n    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"\n\n'
    text+='\n'.join('#check @'+item['name'] for item in decls)+'\n\n'
    for item in decls:
        prior=expected[item['name']]
        text+='namespace '+prior['namespace']+'\nopen D1Bound5 QuadInt D1Bound5.PairGraphPrepared26\n'
        text+='example : ('+prior['type_expression']+') := @'+prior['name']+'\nend '+prior['namespace']+'\n\n'
    assert len(text)<40000
    OUT.mkdir()
    for filename,value in [('TARGETS.json',targets),('REPLAY_TARGETS.json',fresh),('DECLARATIONS.json',decls),('REUSE_EVIDENCE.json',reuse)]: save(OUT/filename,value)
    save(OUT/'PREPARED_GUARDS.json',{'project_sources':frozen,'compiled_artifacts':artifacts,'immutable_inputs':static})
    put(OUT/'AnalyticAudit.lean',text)
    for n in ['row26_reuse_checks.py','locked_checks_mixed_v3.py']: put(OUT/n,(HERE/n).read_bytes())
    put(OUT/'prepare_mixed_audit.py',Path(__file__).read_bytes())
    save(OUT/'PREPARATION_REVIEW.json',{'utc':utc(),'status':'PREPARED_NOT_RUN',
      'audit_kind':'MIXED_EVIDENCE_ROW26_NOT_FINAL_FRESH_MAIN','original_monolith_sha256':PREIMAGE_SHA,
      'current_source_hashes':source_hashes,'total_declarations':54,'definitions':14,'theorems':40,
      'original_public_declarations':28,'original_definition_bodies':13,'new_helper_definition_bodies':1,
      'definition_body_hashes':definitions,'original_statement_texts_preserved':True,
      'chunk03_parent_public_type_unchanged':True,'namespace_contexts_preserved':True,
      'input_pins':input_pins,'embedded_literal_payloads':False,'prior_attempt_status':'FAIL_REPLAY_TIMEOUT_PRESERVED',
      **coverage,'fresh_replay_targets':fresh,'reused_exact_prior_targets':reuse['reused_targets'],
      'pin_scope':'project sources and project build artifacts plus immutable dependency configuration',
      'external_dependency_artifact_bytes_pinned':False,'compiler_started':False})
    put(OUT/'README.md','# Mixed-evidence row26 audit\n\nA fresh exact-type/transitive-axiom phase covers 54 declarations (14 definitions,40 theorems), preserving the original 28 types and 13 definition bodies. Twenty targeted installed SAME-kernel replays are fresh; ten earlier successful targeted replays count only under exact project-source/project-artifact closure and immutable dependency-configuration matches. External mathlib/dependency artifact bytes are not claimed pinned. Stale reuse is rejected, never silently replaced. The former 50-type audit attempt remains explicitly failed/incomplete and untouched. This is not a final fresh main-theorem closure replay or independent implementation.\n\nExceptional recovery: SIGTERM and SIGKILL waits are each bounded to ten seconds. If the child remains unreaped or liveness is unknown, a failed receipt and active=true status are recorded and the owner retains BOTH locks, polling only for actual reaping. SIGINT/SIGTERM are ignored during that recovery interval. No further compiler starts. Root must inspect the owner and child and must not kill the owner before the child is gone. Actual reaping is recorded separately; the failed audit still exits failure and never produces a PASS summary. No canonical runtime schema is modified.\n')
    control_names=['PREPARATION_REVIEW.json','AnalyticAudit.lean','TARGETS.json','REPLAY_TARGETS.json',
      'DECLARATIONS.json','REUSE_EVIDENCE.json','PREPARED_GUARDS.json','row26_reuse_checks.py',
      'locked_checks_mixed_v3.py','prepare_mixed_audit.py','README.md']
    files={n:sha(OUT/n) for n in control_names}
    pins={'schema':'row26-mixed-audit-v3','utc':utc(),'file_hashes':files,'targets':targets,
      'fresh_replay_targets':fresh,'reviewed_source_hashes':source_hashes,
      'audit_kind':'MIXED_EVIDENCE_ROW26_NOT_FINAL_FRESH_MAIN','compiler_started':False}
    save(OUT/'GUARDED_RUN_PINS.json',pins)
    assert stable() and all(sha(OUT/n)==h for n,h in files.items())
    pins_sha=sha(OUT/'GUARDED_RUN_PINS.json')
    print(json.dumps({'status':'PREPARED_NOT_RUN','audit':str(OUT),'pins_sha256':pins_sha,
      'runner_sha256':RUNNER_SHA,'modules':30,'declarations':54,**coverage,
      'root_reviewed_command':'/Users/tp/.local/bin/python3.12 '+str(OUT/'locked_checks_mixed_v3.py')+' '+pins_sha},indent=2),flush=True)
