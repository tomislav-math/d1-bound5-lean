"""Historical-import-aware analytic completion with cooperative boundary controls.

Run only after the original analytic session has stopped and imports have been
installed/finalized. CONTROL_ANALYTIC.json supports stop, jobs (1..3), defer,
and timeout. A stop completes active module builds before returning.
"""
from pathlib import Path
import concurrent.futures, importlib.util, json, os, sys
from provenance_gate import Registry

R=Path(__file__).resolve().parent.parent
spec=importlib.util.spec_from_file_location('integration_resume_guards',R/'guarded_general.py')
g=importlib.util.module_from_spec(spec)
sys.modules[spec.name]=g
spec.loader.exec_module(g)
O=R/'results-integration-analytic-resume'
O.mkdir(exist_ok=True)
TARGETS=['AllLargeImpossible','OneSmallImpossible','ThreeSmallExclusion',
         'DegeneratePairImpossible','TwoSmallFifthBound','MainCaseReduction']
CONTROL=Path(__file__).resolve().parent/'CONTROL_ANALYTIC.json'
if not CONTROL.exists():g.save(CONTROL,{'stop':False,'jobs':1,'defer':[],'timeout':300})

def controls():
    d=json.loads(CONTROL.read_text())
    assert isinstance(d.get('stop',False),bool)
    assert 1<=d.get('jobs',1)<=3
    assert isinstance(d.get('defer',[]),list)
    return d

frozen={}
for n in TARGETS:frozen.update(g.closure(n))
registry=Registry(g,frozen)
initial=registry.report(set(frozen))
g.save(O/'INITIAL_PROVENANCE.json',initial)
g.save(O/'SOURCE_GUARDS.json',frozen)
done=set(registry.selected)
waiting=set(frozen)-done
active={}
failed={}
stopped=False
reservation=R/'reservations/integration.json'

def status():
    g.save(O/'SUMMARY.json',{'targets':TARGETS,'needed':len(frozen),'compiled_or_accepted':sorted(done),
        'waiting':sorted(waiting),'active':list(active.values()),'failed':failed,
        'cooperative_stop_requested':stopped,'main_theorem_complete':False})

print('ANALYTIC_RESUME',len(frozen),'REQUIRED',len(done),'ACCEPTED',len(waiting),'PENDING',flush=True)
with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:
    while waiting or active:
        control=controls()
        stopped=stopped or control.get('stop',False)
        limit=control.get('jobs',1)
        deferred=set(control.get('defer',[]))
        g.save(reservation,{'owner':'integration','active':True,'pid':os.getpid(),
            'reserved_modules':sorted(waiting|set(active.values())),'jobs':limit,
            'cooperative_stop_requested':stopped,'control_path':str(CONTROL)})
        eligible=sorted(n for n in waiting if n not in deferred and
            set(registry.closure(n))-{n}<=done)
        if not stopped:
            for n in eligible[:max(0,limit-len(active))]:
                assert g.closure(n)==registry.closure(n),'SOURCE_CHANGED_BEFORE_LAUNCH '+n
                waiting.remove(n)
                active[pool.submit(g.build,n,O,control.get('timeout',300))]=n
        status()
        if not active:break
        finished,_=concurrent.futures.wait(active,timeout=2,
            return_when=concurrent.futures.FIRST_COMPLETED)
        for future in finished:
            n=active.pop(future)
            try:
                row=future.result()
                assert row['proof_status']=='COMPILED_ONLY',row['proof_status']
                registry.candidates.setdefault(n,[]).insert(0,(O/(n+'-receipt.json'),row))
                registry.rejected.clear()
                assert registry.validate(n),'NEW_COMPILER_RECEIPT_INVALID'
                done.add(n)
            except BaseException as exc:
                failed[n]=repr(exc)
                waiting={w for w in waiting if n not in registry.closure(w)}
status()
g.save(reservation,{'owner':'integration','active':False,'reserved_modules':[],
    'completed':sorted(done),'failed':failed,'cooperative_stop':stopped})
g.save(O/'FINAL_PROVENANCE.json',registry.report(set(frozen)))
print('ANALYTIC_RESUME_FINISHED',len(done),'FAILED',failed,
      'TARGETS_COMPLETE',set(TARGETS)<=done,'COOPERATIVE_STOP',stopped,flush=True)
