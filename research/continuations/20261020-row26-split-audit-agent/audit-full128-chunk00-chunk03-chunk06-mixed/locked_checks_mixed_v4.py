"""ROOT ONLY: fresh 58-type audit +17 replays, with seventeen strictly exact prior passes.
This is a mixed-evidence row26 audit, NOT a final fresh main-theorem closure replay.
Supply the reviewed GUARDED_RUN_PINS.json SHA256 as the sole argument.
"""
from pathlib import Path
from datetime import datetime, timezone
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time
ROOT=Path('/Users/tp/Lean/D1Bound5'); OUT=Path(__file__).resolve().parent
WORK=ROOT/'research/continuations/20261018T010800CEST-main-continuation'
PINFILE=OUT/'GUARDED_RUN_PINS.json'
DRIVER_SHA='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
CONTROL_NAMES={'PREPARATION_REVIEW.json','AnalyticAudit.lean','TARGETS.json','REPLAY_TARGETS.json',
 'DECLARATIONS.json','REUSE_EVIDENCE.json','PREPARED_GUARDS.json','row26_reuse_checks.py','row26_reuse_checks_v3.py',
 'locked_checks_mixed_v4.py','prepare_mixed_audit.py','README.md'}
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def utc(): return datetime.now(timezone.utc).isoformat()
def load_module(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    mod=importlib.util.module_from_spec(spec); sys.modules[name]=mod; spec.loader.exec_module(mod)
    return mod
def drain(p):
    if p is None: return
    if p.poll() is None:
        try: os.killpg(p.pid,signal.SIGTERM)
        except ProcessLookupError: pass
        try: p.wait(timeout=10)
        except subprocess.TimeoutExpired:
            try: os.killpg(p.pid,signal.SIGKILL)
            except ProcessLookupError: pass
            p.wait(timeout=10)
    else: p.wait(timeout=1)
def retain_owner_until_reaped(p):
    # Exceptional recovery only: never release either caller-held lock while
    # child liveness is unknown. No further compiler is launched in this loop.
    previous={s:signal.signal(s,signal.SIG_IGN) for s in [signal.SIGINT,signal.SIGTERM]}
    try:
        while True:
            try:
                if p.poll() is not None: return
                time.sleep(2)
            except BaseException:
                # Root must inspect the owner/child, not kill this lock owner.
                continue
    finally:
        for s,handler in previous.items(): signal.signal(s,handler)
def main():
    assert len(sys.argv)==2 and len(sys.argv[1])==64,'Supply the explicitly reviewed pins SHA256.'
    pins_sha=sys.argv[1]; assert sha(PINFILE)==pins_sha
    pins=json.loads(PINFILE.read_text()); assert pins['schema']=='row26-mixed-audit-v4'
    files=pins['file_hashes']; assert set(files)==CONTROL_NAMES
    assert Path(__file__).name=='locked_checks_mixed_v4.py'
    def controls_stable(): return sha(PINFILE)==pins_sha and all(sha(OUT/n)==h for n,h in files.items())
    assert controls_stable()
    review=json.loads((OUT/'PREPARATION_REVIEW.json').read_text())
    targets=json.loads((OUT/'TARGETS.json').read_text())
    fresh=json.loads((OUT/'REPLAY_TARGETS.json').read_text())
    declarations=json.loads((OUT/'DECLARATIONS.json').read_text())
    reuse=json.loads((OUT/'REUSE_EVIDENCE.json').read_text())
    prepared=json.loads((OUT/'PREPARED_GUARDS.json').read_text())
    reviewed=dict(review['current_source_hashes'])
    assert targets==pins['targets'] and fresh==pins['fresh_replay_targets']
    assert reviewed==pins['reviewed_source_hashes'] and set(reviewed)==set(targets)
    assert review['total_declarations']==len(declarations)==58
    assert review['definitions']==14 and review['theorems']==44
    assert review['audit_kind']=='MIXED_EVIDENCE_ROW26_NOT_FINAL_FRESH_MAIN'
    assert len({d['name'] for d in declarations})==58
    checks=load_module('row26_mixed_reuse_checks',OUT/'row26_reuse_checks.py')
    assert fresh[-2:]==['SmallPairGraphClosure26','SmallPairGraphData26']
    commands=[('analytic-type-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(OUT/'AnalyticAudit.lean')])]
    commands += [(n+'-targeted-replay',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]) for n in fresh]
    assert len(commands)==18
    outputs=['TARGETED_REPLAY_GUARDS.json','TARGETED_REPLAY_RECEIPTS.json',
      'active-targeted-replay.json','MIXED_EVIDENCE_SUMMARY.json','OWNER_RETAINED_RECOVERY.json']+[label+'.log' for label,_ in commands]
    assert all(not (OUT/n).exists() for n in outputs),'Existing attempt must be preserved.'
    assert not list(OUT.glob('*.audit-v4.tmp'))
    assert sha(WORK/'continuation_driver_capacity.py')==DRIVER_SHA
    mod=load_module('row26_mixed_v4_driver',WORK/'continuation_driver_capacity.py')
    owned={}
    def write_owned(name,obj):
        path=OUT/name; b=(json.dumps(obj,indent=2)+'\n').encode()
        if name not in owned:
            with path.open('xb') as f: f.write(b); f.flush(); os.fsync(f.fileno())
        else:
            assert sha(path)==owned[name],'Audit output altered: '+name
            temp=OUT/(name+'.audit-v4.tmp')
            with temp.open('xb') as f: f.write(b); f.flush(); os.fsync(f.fileno())
            assert sha(path)==owned[name]; os.replace(temp,path)
        owned[name]=hashlib.sha256(b).hexdigest()
    with (WORK/'continuation-driver.lock').open('r+') as owner,(WORK/'continuation-intake.lock').open('r+') as intake:
        fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB); fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
        d=mod.Driver(ROOT,WORK); active=json.loads(d.active_path.read_text())
        assert not active.get('active') and not active.get('protected_closure')
        queue,names,closures,accepted,unknown,eligible=d.snapshot()
        assert not unknown and queue['max_parallel']==1 and queue['pause_after_current'] is True
        assert set(targets)<=accepted
        assert all(sha(ROOT/'D1Bound5'/(n+'.lean'))==h for n,h in reviewed.items())
        frozen={}
        for n in targets: frozen.update(closures[n])
        assert not any(n.startswith('FiniteQ') for n in frozen)
        latest=d.latest(); expected={}; by_module={}
        for n in sorted(frozen):
            manifest=d.expected_manifest(n,mod.fingerprint(closures[n]),latest)
            assert isinstance(manifest,dict) and manifest and d.manifest_matches(manifest,cached=False),n
            by_module[n]=dict(manifest)
            for p,h in manifest.items():
                assert p not in expected or expected[p]==h
                expected[p]=h
        static=dict(d.static)
        assert frozen==prepared['project_sources'] and expected==prepared['compiled_artifacts']
        assert static==prepared['immutable_inputs'] and expected and static
        coverage=checks.validate_reuse(reuse,targets,fresh,closures,by_module,static)
        queue_sha=sha(d.queue_path); active_sha=sha(d.active_path)
        def stable():
            return (controls_stable() and checks.old_evidence_stable(reuse)
              and sha(WORK/'continuation_driver_capacity.py')==DRIVER_SHA
              and sha(d.queue_path)==queue_sha and sha(d.active_path)==active_sha
              and all(sha(ROOT/'D1Bound5'/(n+'.lean'))==h for n,h in frozen.items())
              and d.manifest_matches(expected,cached=True) and d.manifest_matches(static,cached=True))
        assert stable() and all(not (OUT/n).exists() for n in outputs)
        write_owned('TARGETED_REPLAY_GUARDS.json',{'project_sources':frozen,'compiled_artifacts':expected,
          'immutable_inputs':static,'time':utc(),'run_pins_sha256':pins_sha,'pinned_control_files':files,
          'preparation_reviewed_sources':reviewed,'queue_sha256':queue_sha,'active_sha256':active_sha,
          'old_evidence_sha256':{k:v['file_hashes'] for k,v in reuse['attempts'].items()},'audit_kind':'MIXED_EVIDENCE_ROW26_NOT_FINAL_FRESH_MAIN'})
        records=[]; write_owned('TARGETED_REPLAY_RECEIPTS.json',records)
        write_owned('active-targeted-replay.json',{'active':False,'status':'prepared','time':utc()})
        for label,args in commands:
            assert stable(),'Guard drift before command.'
            p=None; timed_out=False; guard_drift=False; failure=None; start=time.monotonic()
            entry={'label':label,'command':args,'time':utc()}
            try:
                with (OUT/(label+'.log')).open('x') as stream:
                    p=subprocess.Popen(args,cwd=ROOT,env={**os.environ,'LEAN_NUM_THREADS':'1'},
                      stdin=subprocess.DEVNULL,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
                    entry['pid']=p.pid
                    write_owned('active-targeted-replay.json',{'active':True,**entry}); print(json.dumps(entry),flush=True)
                    deadline=start+240
                    while p.poll() is None:
                        if not stable():
                            guard_drift=True; raise RuntimeError('Pinned source/artifact/control/prior-evidence drift.')
                        remaining=deadline-time.monotonic()
                        if remaining<=0: timed_out=True; break
                        try: p.wait(timeout=min(2.0,remaining))
                        except subprocess.TimeoutExpired: pass
            except BaseException as exc: failure=exc
            finally:
                drain_failure=None
                try: drain(p)
                except BaseException as exc: drain_failure=exc
                try: reaped=p is None or p.poll() is not None
                except BaseException as exc:
                    reaped=False
                    if drain_failure is None: drain_failure=exc
                if drain_failure is not None and failure is None: failure=drain_failure
                try: guards_ok=stable()
                except BaseException: guards_ok=False
                result={**entry,'exit':p.returncode if p else None,'seconds':time.monotonic()-start,
                  'timed_out':timed_out,'guards_unchanged':guards_ok and not guard_drift,
                  'log':label+'.log','exception':repr(failure) if failure else None,
                  'child_reaped':reaped,'drain_exception':repr(drain_failure) if drain_failure else None}
                records.append(result)
                try:
                    try: write_owned('TARGETED_REPLAY_RECEIPTS.json',records)
                    finally: write_owned('active-targeted-replay.json',{'active':not reaped,
                      'needs_root_intervention':not reaped,'owner_pid':os.getpid(),'last':result})
                finally:
                    if not reaped:
                        # Even an output-write exception must not release these locks.
                        retain_owner_until_reaped(p)
                        reaped=True
                        write_owned('OWNER_RETAINED_RECOVERY.json',{'time':utc(),'owner_pid':os.getpid(),
                          'child_pid':p.pid,'child_reaped':True,'exit':p.returncode,
                          'both_locks_retained_until_reaped':True,'failed_receipt_preserved':True})
                        write_owned('active-targeted-replay.json',{'active':False,'recovered_after_failure':True,
                          'owner_pid':os.getpid(),'last':result})
                print(json.dumps(result),flush=True)
            if failure is not None: raise failure
            if result['exit']!=0 or timed_out or not result['guards_unchanged'] or not reaped: return 1
        assert stable() and len(records)==18
        assert [r['label'] for r in records]==[label for label,_ in commands]
        assert all(r['exit']==0 and not r['timed_out'] and r['guards_unchanged'] and r['exception'] is None
                   and r['child_reaped'] and r['drain_exception'] is None for r in records)
        checks.validate_reuse(reuse,targets,fresh,closures,by_module,static)
        summary={'status':'MIXED_ROW26_AUDIT_PASS','time':utc(),
          'fresh_exact_type_axiom_declarations':58,**coverage,'fresh_replayed_modules':fresh,
          'reused_exact_prior_modules':reuse['reused_targets'],'target_modules':targets,
          'old_attempt_status':'BOTH_PRIOR_ATTEMPTS_FAIL_REPLAY_TIMEOUT_PRESERVED','final_fresh_main_closure_replay':False,
          'pin_scope':'project sources and project build artifacts plus immutable dependency configuration',
          'external_dependency_artifact_bytes_pinned':False,
          'run_pins_sha256':pins_sha,'fresh_receipts_sha256':sha(OUT/'TARGETED_REPLAY_RECEIPTS.json'),
          'reuse_evidence_sha256':sha(OUT/'REUSE_EVIDENCE.json')}
        write_owned('MIXED_EVIDENCE_SUMMARY.json',summary)
        try: final_stable=stable()
        except BaseException: final_stable=False
        if not final_stable:
            write_owned('MIXED_EVIDENCE_SUMMARY.json',{**summary,'status':'INVALIDATED_FINAL_GUARD_DRIFT'})
            raise RuntimeError('Guard drift during final summary; summary explicitly invalidated.')
    print('MIXED_ROW26_AUDIT_PASS_NOT_FINAL_FRESH_MAIN',flush=True)
    return 0
if __name__=='__main__': sys.exit(main())

