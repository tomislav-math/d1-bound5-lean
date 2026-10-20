"""Read-only validation of ten exact earlier targeted replays, never fallback."""
from pathlib import Path
import hashlib, json
OLD_AUDIT='/Users/tp/Lean/D1Bound5/research/continuations/20261020-row26-split-audit-agent/audit-full128-chunk00'
PARENT='SmallPairGraphClosure26Chunk128_03'
RECEIPTS_SHA='c90778b7e1ef3974628f1a1ed4edaf657672f71d665f758b58805654666830ff'
GUARDS_SHA='b09fc633ede830a0a9a49080fd1364d09f4934587d6d82324110b98eadb9c137'
REUSED=['PairClosureIndexedChunks','SmallPairGraphInputs26','SmallPairGraphArithmetic26',
 'SmallPairGraphWitnessData26','SmallPairRawSelectedData26','SmallPairLightAssembly26',
 'SmallPairGraphTriangle26','SmallPairGraphClosure26Chunk128_00',
 'SmallPairGraphClosure26Chunk128_01','SmallPairGraphClosure26Chunk128_02']
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def old_evidence_stable(e):
    assert e['old_audit']==OLD_AUDIT
    return all(sha(Path(OLD_AUDIT)/n)==h for n,h in e['old_file_hashes'].items())
def validate_reuse(e,targets,fresh,closures,by_module,static):
    assert e['schema']=='row26-exact-prior-replay-reuse-v1'
    assert e['reused_targets']==REUSED and set(e['entries'])==set(REUSED)
    assert len(targets)==len(set(targets))==30 and len(fresh)==len(set(fresh))==20
    assert not set(REUSED)&set(fresh) and set(REUSED)|set(fresh)==set(targets)
    assert old_evidence_stable(e),'Prior attempt changed; no silent replay/rebaseline fallback.'
    files=e['old_file_hashes']; old=Path(OLD_AUDIT)
    assert files['TARGETED_REPLAY_RECEIPTS.json']==RECEIPTS_SHA
    assert files['TARGETED_REPLAY_GUARDS.json']==GUARDS_SHA
    rs=json.loads((old/'TARGETED_REPLAY_RECEIPTS.json').read_text())
    guards=json.loads((old/'TARGETED_REPLAY_GUARDS.json').read_text())
    required={'TARGETED_REPLAY_RECEIPTS.json','TARGETED_REPLAY_GUARDS.json','active-targeted-replay.json',
      'GUARDED_RUN_PINS.json','PREPARATION_REVIEW.json','DECLARATIONS.json','TARGETS.json',
      'REPLAY_TARGETS.json','AnalyticAudit.lean','locked_checks.py','locked_checks_v2.py'}
    assert set(files)==required|{r['log'] for r in rs}
    assert len(rs)==13 and rs[-1]==e['failed_receipt']
    failed=rs[-1]
    assert failed['label']==PARENT+'-targeted-replay' and failed['timed_out'] is True
    assert failed['exit']==-15 and failed['guards_unchanged'] is True and failed['exception'] is None
    assert json.loads((old/'active-targeted-replay.json').read_text())=={'active':False,'last':failed}
    assert all(r['exit']==0 and not r['timed_out'] and r['guards_unchanged'] and r['exception'] is None for r in rs[:-1])
    successes={r['label'].removesuffix('-targeted-replay'):r for r in rs[1:-1]}
    assert static==e['immutable_inputs']==guards['immutable_inputs'] and static
    for n in REUSED:
        item=e['entries'][n]; receipt=item['receipt']
        assert receipt==successes[n]
        assert receipt['command']==['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]
        assert item['project_sources']==closures[n] and PARENT not in closures[n]
        assert all(guards['project_sources'].get(k)==h for k,h in closures[n].items())
        manifest={}
        for dep in closures[n]:
            m=by_module[dep]; assert isinstance(m,dict) and m
            for p,h in m.items():
                assert p not in manifest or manifest[p]==h
                manifest[p]=h
        assert manifest==item['compiled_artifacts'] and manifest
        assert all(guards['compiled_artifacts'].get(p)==h for p,h in manifest.items())
    return {'reused_exact_prior_passes':10,'fresh_targeted_replays':20,'covered_modules':30}
