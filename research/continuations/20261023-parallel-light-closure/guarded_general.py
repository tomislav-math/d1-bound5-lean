#!/usr/bin/env python3
"""Pinned direct Lean builds, exact project dependency guards, no queue mutations."""
import argparse, concurrent.futures, hashlib, json, os, pathlib, re, subprocess, time
R=pathlib.Path(__file__).resolve().parent
P=R/'project'; B=P/'.lake/build/lib/lean'; BIN=R/'lean-4.33.1-linux/bin'
ENV=os.environ.copy(); ENV.update(json.loads((R/'lean-env.json').read_text()))
SEARCH=[pathlib.Path(p) for p in ENV['LEAN_PATH'].split(':')]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def src(n):return P/'D1Bound5'/(n+'.lean')
def artifact(n):return B/'D1Bound5'/(n+'.olean')
def imports(n):return [v for l in src(n).read_text().splitlines() if l.startswith('import ') for v in l[7:].split()]
def closure(n):
    out={}
    def walk(x):
        if x in out:return
        out[x]=sha(src(x))
        for i in imports(x):
            if i.startswith('D1Bound5.'):walk(i[9:])
    walk(n);return out
def external(sc):
    out={}
    for n in sc:
        for mod in imports(n):
            if mod.startswith('D1Bound5.') or mod in out:continue
            suffix=pathlib.Path(*mod.split('.')).with_suffix('.olean')
            candidates=[p/suffix for p in SEARCH if (p/suffix).exists()]
            assert candidates,'MISSING_EXTERNAL '+mod
            p=candidates[0];out[mod]={'path':str(p),'sha256':sha(p)}
    return out
def save(p,obj):
    tmp=p.with_suffix('.tmp');tmp.write_text(json.dumps(obj,indent=2,sort_keys=True)+'\n');tmp.replace(p)
def build(n,O,timeout):
    start=time.time();sc=closure(n);deps={x:sha(artifact(x)) for x in sc if x!=n};ext=external(sc)
    out=artifact(n);out.parent.mkdir(parents=True,exist_ok=True)
    cmd=[str(BIN/'lean'),'-j1','-DautoImplicit=false','-o',str(out),str(src(n))]
    row={'name':n,'source_closure':sc,'dependency_artifacts':deps,'external_import_artifacts':ext,
      'command':cmd,'toolchain':'4.33.1','lean_binary_sha256':sha(BIN/'lean'),
      'proc_path_compat_sha256':sha(R/'proc_self_exe_compat.so'),
      'mathlib_commit':'0df444a360eaa60ab8c11dca51a86af692955474','proof_status':'RUNNING',
      'utc_start':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())}
    save(O/(n+'-receipt.json'),row)
    with (O/(n+'.log')).open('w') as log:
        try:q=subprocess.run(cmd,cwd=P,env=ENV,stdout=log,stderr=subprocess.STDOUT,timeout=timeout);row['exit_code']=q.returncode
        except subprocess.TimeoutExpired:row['exit_code']=None;row['proof_status']='TIMEOUT'
    row['seconds']=time.time()-start
    assert closure(n)==sc,'SOURCE_CHANGED '+n
    assert {x:sha(artifact(x)) for x in deps}==deps,'DEPENDENCY_CHANGED '+n
    assert external(sc)==ext,'EXTERNAL_CHANGED '+n
    if row['proof_status']!='TIMEOUT':row['proof_status']='COMPILED_ONLY' if row['exit_code']==0 else 'FAILED'
    if row['exit_code']==0:row['artifact_sha256']=sha(out)
    save(O/(n+'-receipt.json'),row);print(n,row['proof_status'],round(row['seconds'],2),flush=True);return row
def main():
    a=argparse.ArgumentParser();a.add_argument('--targets',nargs='+',required=True);a.add_argument('--out',required=True)
    a.add_argument('--jobs',type=int,default=2);a.add_argument('--timeout',type=int,default=240);args=a.parse_args()
    O=R/args.out;O.mkdir(exist_ok=True);need=set()
    for n in args.targets:need.update(closure(n))
    prior={}
    for d in R.glob('results-*'):
        for f in d.glob('*-receipt.json'):
            row=json.loads(f.read_text());n=row.get('name')
            if n not in need or row.get('proof_status')!='COMPILED_ONLY' or not artifact(n).exists():continue
            if row.get('artifact_sha256')!=sha(artifact(n)) or row['source_closure']!=closure(n):continue
            if any(not artifact(x).exists() or sha(artifact(x))!=h for x,h in row.get('dependency_artifacts',{}).items()):continue
            prior[n]=row
    done=set(prior);waiting=need-done;active={};failed=[]
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        while waiting or active:
            eligible=[n for n in waiting if set(closure(n))-{n}<=done]
            for n in sorted(eligible)[:args.jobs-len(active)]:
                waiting.remove(n);active[pool.submit(build,n,O,args.timeout)]=n
            if not active:break
            futures,_=concurrent.futures.wait(active,return_when=concurrent.futures.FIRST_COMPLETED)
            for f in futures:
                n=active.pop(f);row=f.result()
                if row['proof_status']=='COMPILED_ONLY':done.add(n)
                else:failed.append(n);waiting={w for w in waiting if n not in closure(w)}
            save(O/'SUMMARY.json',{'compiled':sorted(done&need),'failed':failed,'waiting':sorted(waiting),'active':list(active.values()),'targets':args.targets,'global_main_theorem_complete':False})
    save(O/'SUMMARY.json',{'compiled':sorted(done&need),'reused':sorted(prior),'failed':failed,'uncompiled':sorted(need-done),'targets':args.targets,'global_main_theorem_complete':False})
if __name__=='__main__':main()
