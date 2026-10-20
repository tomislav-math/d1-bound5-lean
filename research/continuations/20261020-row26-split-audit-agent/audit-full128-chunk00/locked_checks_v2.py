"""Run the SAME 1+26 row26 audit commands under explicit immutable run pins.
Root-only proposal. The required argument is the reviewed SHA256 of
GUARDED_RUN_PINS.json; prior attempts are preserved and never overwritten.
"""
from pathlib import Path
from datetime import datetime,timezone
import fcntl,hashlib,importlib.util,json,os,signal,subprocess,sys,time
ROOT=Path('/Users/tp/Lean/D1Bound5')
WORK=ROOT/'research/continuations/20261018T010800CEST-main-continuation'
OUT=Path(__file__).resolve().parent
PINFILE=OUT/'GUARDED_RUN_PINS.json'
DRIVER_SHA='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
CONTROL_NAMES={'PREPARATION_REVIEW.json','AnalyticAudit.lean','TARGETS.json',
 'REPLAY_TARGETS.json','DECLARATIONS.json','locked_checks.py','locked_checks_v2.py'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def utc():return datetime.now(timezone.utc).isoformat()
def drain(p):
    if p is None:return
    if p.poll() is None:
        try:os.killpg(p.pid,signal.SIGTERM)
        except ProcessLookupError:pass
        try:p.wait(timeout=10)
        except subprocess.TimeoutExpired:
            try:os.killpg(p.pid,signal.SIGKILL)
            except ProcessLookupError:pass
            p.wait()
    else:p.wait()
def main():
    assert len(sys.argv)==2 and len(sys.argv[1])==64,'Supply the reviewed run-pins SHA256.'
    pins_sha=sys.argv[1]
    assert sha(PINFILE)==pins_sha,'Run pins do not match the explicit approved hash.'
    pins=json.loads(PINFILE.read_text())
    assert pins['schema']=='row26-guarded-audit-v2'
    files=pins['file_hashes']
    assert set(files)==CONTROL_NAMES and Path(__file__).name=='locked_checks_v2.py'
    def controls_stable():
        return sha(PINFILE)==pins_sha and all(sha(OUT/n)==h for n,h in files.items())
    assert controls_stable()
    review=json.loads((OUT/'PREPARATION_REVIEW.json').read_text())
    targets=json.loads((OUT/'TARGETS.json').read_text())
    replays=json.loads((OUT/'REPLAY_TARGETS.json').read_text())
    declarations=json.loads((OUT/'DECLARATIONS.json').read_text())
    reviewed_sources=dict(review['current_source_hashes'])
    assert targets==replays==pins['targets'] and len(targets)==len(set(targets))==26
    assert set(reviewed_sources)==set(targets)
    assert reviewed_sources==pins['reviewed_source_hashes']
    assert review['total_declarations']==len(declarations)==50
    assert review['definitions']==14 and review['theorems']==36
    assert sha(WORK/'continuation_driver_capacity.py')==DRIVER_SHA
    commands=[('analytic-type-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(OUT/'AnalyticAudit.lean')])]
    commands += [(n+'-targeted-replay',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]) for n in replays]
    assert len(commands)==27
    output_names=['TARGETED_REPLAY_GUARDS.json','TARGETED_REPLAY_RECEIPTS.json',
                  'active-targeted-replay.json']+[label+'.log' for label,_ in commands]
    # Any earlier attempt, even an incomplete one, needs a new reviewed directory.
    assert all(not (OUT/n).exists() for n in output_names),'Prior audit attempt exists: preserve it.'
    assert not list(OUT.glob('*.audit-v2.tmp')),'Incomplete earlier output transaction.'
    spec=importlib.util.spec_from_file_location('row26_guarded_audit_v2_driver',WORK/'continuation_driver_capacity.py')
    mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
    owned={}
    def write_owned(name,obj):
        path=OUT/name;b=(json.dumps(obj,indent=2)+'\n').encode()
        if name not in owned:
            with path.open('xb') as f:f.write(b);f.flush();os.fsync(f.fileno())
        else:
            assert sha(path)==owned[name],'Audit output altered by another writer: '+name
            temp=OUT/(name+'.audit-v2.tmp')
            with temp.open('xb') as f:f.write(b);f.flush();os.fsync(f.fileno())
            assert sha(path)==owned[name]
            os.replace(temp,path)
        owned[name]=hashlib.sha256(b).hexdigest()
    with (WORK/'continuation-driver.lock').open('r+') as owner,(WORK/'continuation-intake.lock').open('r+') as intake:
        fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
        fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
        d=mod.Driver(ROOT,WORK)
        active=json.loads(d.active_path.read_text())
        assert not active.get('active') and not active.get('protected_closure')
        queue,names,closures,accepted,unknown,eligible=d.snapshot()
        assert not unknown and queue['max_parallel']==1 and queue['pause_after_current'] is True
        assert set(targets)<=accepted
        assert all(sha(ROOT/'D1Bound5'/(n+'.lean'))==h for n,h in reviewed_sources.items())
        frozen={}
        for n in targets:frozen.update(closures[n])
        assert not any(n.startswith('FiniteQ') for n in frozen)
        latest=d.latest();expected={}
        for n in sorted(frozen):
            manifest=d.expected_manifest(n,mod.fingerprint(closures[n]),latest)
            assert isinstance(manifest,dict) and manifest,'Missing trusted artifact manifest: '+n
            assert d.manifest_matches(manifest,cached=False),n
            for path,digest in manifest.items():
                assert path not in expected or expected[path]==digest,'Conflicting artifact manifests.'
                expected[path]=digest
        expected=dict(expected);static=dict(d.static);frozen=dict(frozen)
        queue_sha=sha(d.queue_path);active_sha=sha(d.active_path)
        assert expected and static
        def stable():
            return (controls_stable() and sha(WORK/'continuation_driver_capacity.py')==DRIVER_SHA
              and sha(d.queue_path)==queue_sha and sha(d.active_path)==active_sha
              and all(sha(ROOT/'D1Bound5'/(n+'.lean'))==h for n,h in frozen.items())
              and d.manifest_matches(expected,cached=True) and d.manifest_matches(static,cached=True))
        assert stable()
        assert all(not (OUT/n).exists() for n in output_names),'Another audit attempt appeared.'
        write_owned('TARGETED_REPLAY_GUARDS.json',{'project_sources':frozen,
          'compiled_artifacts':expected,'immutable_inputs':static,'time':utc(),
          'run_pins_sha256':pins_sha,'pinned_control_files':files,
          'preparation_reviewed_sources':reviewed_sources,'queue_sha256':queue_sha,'active_sha256':active_sha})
        records=[]
        write_owned('TARGETED_REPLAY_RECEIPTS.json',records)
        write_owned('active-targeted-replay.json',{'active':False,'status':'prepared','time':utc()})
        for label,args in commands:
            assert stable(),'Guard drift before command.'
            p=None;timed_out=False;guard_drift=False;failure=None;start=time.monotonic()
            entry={'label':label,'command':args,'time':utc()}
            try:
                with (OUT/(label+'.log')).open('x') as stream:
                    p=subprocess.Popen(args,cwd=ROOT,env={**os.environ,'LEAN_NUM_THREADS':'1'},
                      stdin=subprocess.DEVNULL,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
                    entry['pid']=p.pid
                    write_owned('active-targeted-replay.json',{'active':True,**entry})
                    print(json.dumps(entry),flush=True)
                    deadline=start+240
                    while p.poll() is None:
                        if not stable():
                            guard_drift=True
                            raise RuntimeError('Pinned input/source/artifact drift during command.')
                        remaining=deadline-time.monotonic()
                        if remaining<=0:
                            timed_out=True
                            break
                        try:p.wait(timeout=min(2.0,remaining))
                        except subprocess.TimeoutExpired:pass
            except BaseException as exc:
                failure=exc
            finally:
                # This runs even if logging, guard verification or receipt writing fails.
                drain(p)
                try:guards_ok=stable()
                except BaseException:guards_ok=False
                result={**entry,'exit':p.returncode if p else None,
                  'seconds':time.monotonic()-start,'timed_out':timed_out,
                  'guards_unchanged':guards_ok and not guard_drift,'log':label+'.log',
                  'exception':repr(failure) if failure else None}
                records.append(result)
                try:write_owned('TARGETED_REPLAY_RECEIPTS.json',records)
                finally:write_owned('active-targeted-replay.json',{'active':False,'last':result})
                print(json.dumps(result),flush=True)
            if failure is not None:raise failure
            if result['exit']!=0 or timed_out or not result['guards_unchanged']:return 1
        assert stable(),'Final guard drift.'
    print('ANALYTIC_CHECKS_PASS',flush=True)
    return 0
if __name__=='__main__':sys.exit(main())
