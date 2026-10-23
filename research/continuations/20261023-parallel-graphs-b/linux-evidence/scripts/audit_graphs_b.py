#!/usr/bin/env python3
"""Original exact types, strict transitive axioms and explicitly scoped kernel milestones."""
import argparse, hashlib, json, pathlib, re, subprocess, time
import guarded_general_b as G

R=pathlib.Path(__file__).resolve().parent

def freeze(n):
    sc=G.closure(n)
    return {'source_closure':sc,
      'artifact_closure':{x:G.sha(G.artifact(x)) for x in sc},
      'external_import_artifacts':G.external(sc)}

def main():
    ap=argparse.ArgumentParser();ap.add_argument('graph',type=int,choices=[14,15,21,28,36]);ap.add_argument('--timeout',type=int,default=600);a=ap.parse_args();g=a.graph
    O=R/f'results-graph{g}-endpoint-audit';O.mkdir(exist_ok=True)
    audit=R/f'graph{g}-OriginalTypesAxioms.lean'
    plan=json.loads((R/f'graph{g}-AUDIT_PLAN.json').read_text())
    assert G.sha(audit)==plan['audit_sha256'],'AUDIT_CHANGED'
    endpoint=f'SmallPairGraphData{g}';pinned=freeze(endpoint)
    mods=[f'SmallPairLightLeft{g}',f'SmallPairLightRight{g}',f'SmallPairPureClosureAdapter{g}',f'SmallPairGraphClosure{g}',f'SmallPairGraphTriangle{g}',endpoint]
    commands=[('original-types-axioms',[str(G.BIN/'lean'),'-j1','-DautoImplicit=false',str(audit)])]
    commands += [(n+'-kernel',[str(G.BIN/'leanchecker'),'--verbose','D1Bound5.'+n]) for n in mods]
    results=[]
    for label,cmd in commands:
        out=O/(label+'-receipt.json')
        if out.exists():
            old=json.loads(out.read_text())
            if old.get('exit_code')==0 and old.get('pins')==pinned and old.get('audit_sha256')==plan['audit_sha256']:
                results.append(old);print('REUSED',label,flush=True);continue
            oldpath=out.with_name(out.stem+'.previous-'+str(time.time_ns())+'.json');out.rename(oldpath)
        assert freeze(endpoint)==pinned,'PRECHECK_CHANGED'
        start=time.time();row={'label':label,'command':cmd,'pins':pinned,'audit_sha256':plan['audit_sha256'],'status':'RUNNING','utc_start':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())};G.save(out,row)
        try:
            with (O/(label+'.log')).open('w') as log:q=subprocess.run(cmd,cwd=G.P,env=G.ENV,stdout=log,stderr=subprocess.STDOUT,timeout=a.timeout)
            row['exit_code']=q.returncode
        except subprocess.TimeoutExpired:row['exit_code']=None
        row['seconds']=time.time()-start
        assert freeze(endpoint)==pinned,'POSTCHECK_CHANGED'
        assert G.sha(audit)==plan['audit_sha256'],'AUDIT_CHANGED'
        row['status']='PASS' if row['exit_code']==0 else ('TIMEOUT' if row['exit_code'] is None else 'FAILED')
        if label=='original-types-axioms' and row['exit_code']==0:
            text=(O/(label+'.log')).read_text();row['axiom_pass_markers']=text.count('TYPE_AXIOMS_PASS ')
            assert row['axiom_pass_markers']==plan['axiom_checks'],row['axiom_pass_markers']
        if label.endswith('-kernel') and row['exit_code']==0:
            row['actually_replayed_modules']=re.findall(r'^replaying (\S+)$',(O/(label+'.log')).read_text(),re.M)
            assert row['actually_replayed_modules']==[cmd[-1]],row['actually_replayed_modules']
        G.save(out,row);results.append(row);print(label,row['status'],round(row['seconds'],2),flush=True)
        if row['status']!='PASS':raise SystemExit(1)
    G.save(O/'VERIFICATION_SUMMARY.json',{'status':'SCOPED_ENDPOINT_VERIFICATION_PASS','graph':g,'original_type_examples':plan['original_type_checks'],'strict_transitive_axiom_checks':plan['axiom_checks'],'allowed_axioms':['propext','Classical.choice','Quot.sound'],'kernel_milestone_modules':mods,'kernel_mode':'explicit modules, one process at a time, installed Lean leanchecker; not --fresh and not all helper modules','pins':pinned,'audit_sha256':plan['audit_sha256'],'source_original_pins':plan['original_source_sha256'],'main_theorem_complete':False,'toolchain':'4.33.1','lean_binary_sha256':G.sha(G.BIN/'lean'),'leanchecker_binary_sha256':G.sha(G.BIN/'leanchecker')})

if __name__=='__main__':main()
