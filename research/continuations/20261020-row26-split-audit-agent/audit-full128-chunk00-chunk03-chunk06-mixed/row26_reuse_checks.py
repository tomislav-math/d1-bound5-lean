"""Seventeen exact prior passes from TWO preserved failed attempts; no fallback."""
from pathlib import Path
import hashlib, importlib.util, json, sys
BASE=Path('/Users/tp/Lean/D1Bound5/research/continuations/20261020-row26-split-audit-agent')
FIRST=BASE/'audit-full128-chunk00'
SECOND=BASE/'audit-full128-chunk00-chunk03-mixed'
PARENT='SmallPairGraphClosure26Chunk128_06'
LEGACY_SHA='cb7b3210764909841c7baf36737e6e1454e83a8d244144abdb7916c193368cec'
RECEIPTS_SHA='b9bbcb74990ffb2f28ef1eb691690948d27a6f68c8eedc02e9beb5fc335b57e1'
GUARDS_SHA='de96e3bb0bc7ea09057507b64cdef5a0727a67d4cac4490a5357cf4bc7245c07'
PINS_SHA='a62c1158a800e80eb29dc5a465eab222e44aa5ad2ab7c15780d347612c9c3b73'
NEW_REUSED=[f'SmallPairGraphClosure26Chunk128_03Part{i}' for i in range(4)]+[
 'SmallPairGraphClosure26Chunk128_03','SmallPairGraphClosure26Chunk128_04','SmallPairGraphClosure26Chunk128_05']
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def old_evidence_stable(e):
    assert set(e['attempts'])=={'first','second'}
    assert e['attempts']['first']['directory']==str(FIRST) and e['attempts']['second']['directory']==str(SECOND)
    return (all(sha(Path(a['directory'])/n)==h for a in e['attempts'].values() for n,h in a['file_hashes'].items())
      and not (SECOND/'MIXED_EVIDENCE_SUMMARY.json').exists() and not (SECOND/'OWNER_RETAINED_RECOVERY.json').exists())
def validate_reuse(e,targets,fresh,closures,by_module,static):
    assert e['schema']=='row26-exact-two-attempt-replay-reuse-v2'
    assert old_evidence_stable(e),'Prior attempt changed; no silent replay/rebaseline fallback.'
    path=Path(__file__).with_name('row26_reuse_checks_v3.py'); assert sha(path)==LEGACY_SHA
    spec=importlib.util.spec_from_file_location('row26_unchanged_v3_reuse',path)
    legacy=importlib.util.module_from_spec(spec); sys.modules[spec.name]=legacy; spec.loader.exec_module(legacy)
    previous=e['legacy_first_reuse_evidence']
    assert previous==json.loads((SECOND/'REUSE_EVIDENCE.json').read_text())
    assert e['attempts']['first']=={'directory':previous['old_audit'],'file_hashes':previous['old_file_hashes'],
      'failed_receipt':previous['failed_receipt'],'reused_targets':previous['reused_targets']}
    # Keep the reviewed first-ten validation unchanged; its historical 30/20
    # manifests are not reinterpreted as a completed historical whole audit.
    legacy.validate_reuse(previous,json.loads((SECOND/'TARGETS.json').read_text()),
      json.loads((SECOND/'REPLAY_TARGETS.json').read_text()),closures,by_module,static)
    reused=legacy.REUSED+NEW_REUSED
    assert e['reused_targets']==reused and set(e['entries'])==set(reused)
    assert len(targets)==len(set(targets))==34 and len(fresh)==len(set(fresh))==17
    assert not set(reused)&set(fresh) and set(reused)|set(fresh)==set(targets)
    a=e['attempts']['second']; files=a['file_hashes']
    assert files['TARGETED_REPLAY_RECEIPTS.json']==RECEIPTS_SHA
    assert files['TARGETED_REPLAY_GUARDS.json']==GUARDS_SHA and files['GUARDED_RUN_PINS.json']==PINS_SHA
    rs=json.loads((SECOND/'TARGETED_REPLAY_RECEIPTS.json').read_text())
    guards=json.loads((SECOND/'TARGETED_REPLAY_GUARDS.json').read_text())
    pins=json.loads((SECOND/'GUARDED_RUN_PINS.json').read_text())
    required=set(pins['file_hashes'])|{'GUARDED_RUN_PINS.json','TARGETED_REPLAY_RECEIPTS.json',
      'TARGETED_REPLAY_GUARDS.json','active-targeted-replay.json'}|{r['log'] for r in rs}
    assert set(files)==required and all(files[n]==h for n,h in pins['file_hashes'].items())
    assert len(rs)==9 and rs[-1]==a['failed_receipt']
    failed=rs[-1]; active=json.loads((SECOND/'active-targeted-replay.json').read_text())
    assert failed['label']==PARENT+'-targeted-replay' and failed['timed_out'] is True and failed['exit']==-15
    assert failed['guards_unchanged'] and failed['exception'] is None
    assert not active['active'] and not active['needs_root_intervention'] and active['last']==failed
    assert all(r['child_reaped'] and r['drain_exception'] is None for r in rs)
    assert all(r['exit']==0 and not r['timed_out'] and r['guards_unchanged'] and r['exception'] is None for r in rs[:-1])
    successes={r['label'].removesuffix('-targeted-replay'):r for r in rs[1:-1]}
    assert list(successes)==a['reused_targets']==NEW_REUSED
    assert static==e['immutable_inputs']==guards['immutable_inputs']
    for n in legacy.REUSED:
        assert e['entries'][n]=={'attempt':'first',**previous['entries'][n]}
    for n in NEW_REUSED:
        item=e['entries'][n]; assert item['attempt']=='second' and item['receipt']==successes[n]
        assert item['receipt']['command']==['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]
        assert item['project_sources']==closures[n]
        assert all(guards['project_sources'].get(k)==h for k,h in closures[n].items())
        manifest={}
        for dep in closures[n]:
            m=by_module[dep]; assert isinstance(m,dict) and m
            for p,h in m.items():
                assert p not in manifest or manifest[p]==h
                manifest[p]=h
        assert manifest==item['compiled_artifacts'] and manifest
        assert all(guards['compiled_artifacts'].get(p)==h for p,h in manifest.items())
    assert all(PARENT not in closures[n] for n in reused)
    return {'reused_exact_prior_passes':17,'fresh_targeted_replays':17,'covered_modules':34}
