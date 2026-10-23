#!/usr/bin/env python3
"""Isolated Linux Lean 4.33.1 proof compilation with immutable source/artifact guards."""
import argparse, concurrent.futures, hashlib, json, os, pathlib, re, subprocess, time
R=pathlib.Path(__file__).resolve().parent
P=R/'project'; B=P/'.lake/build/lib/lean'; BIN=R/'lean-4.33.1-linux/bin'
ENV=os.environ.copy();ENV.update(PATH=str(BIN)+':'+ENV['PATH'],LEAN_PATH=str(B),LD_PRELOAD=str(R/'proc_self_exe_compat.so'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def src(n):return P/'D1Bound5'/(n+'.lean')
def artifact(n):return B/'D1Bound5'/(n+'.olean')
def imports(n):
    return [s for line in src(n).read_text().splitlines() if line.startswith('import ') for s in line[7:].split()]
def closure(n):
    out={}
    def walk(x):
        if x in out:return
        out[x]=sha(src(x))
        for i in imports(x):
            if i.startswith('D1Bound5.'):walk(i[9:])
            elif i!='Init':raise ValueError('Non-Init import '+i+' in '+x)
    walk(n);return out
def save(p,obj):
    tmp=p.with_suffix('.tmp');tmp.write_text(json.dumps(obj,indent=2,sort_keys=True));tmp.replace(p)
def build(n,O,timeout):
    start=time.time();sc=closure(n);deps={x:sha(artifact(x)) for x in sc if x!=n}
    out=artifact(n);out.parent.mkdir(parents=True,exist_ok=True)
    cmd=[str(BIN/'lean'),'-j1','-DautoImplicit=false','-o',str(out),str(src(n))]
    row={'name':n,'source_closure':sc,'dependency_artifacts':deps,'command':cmd,'toolchain':'4.33.1','proof_status':'RUNNING','utc_start':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())}
    save(O/(n+'-receipt.json'),row)
    with (O/(n+'.log')).open('w') as log:
        try:p=subprocess.run(cmd,cwd=P,env=ENV,stdout=log,stderr=subprocess.STDOUT,timeout=timeout);row['exit_code']=p.returncode
        except subprocess.TimeoutExpired:row['exit_code']=None;row['proof_status']='TIMEOUT'
    row['seconds']=time.time()-start
    assert closure(n)==sc,'SOURCE_CHANGED '+n
    assert {x:sha(artifact(x)) for x in deps}==deps,'DEPENDENCY_CHANGED '+n
    if row['proof_status']!='TIMEOUT':row['proof_status']='COMPILED_ONLY' if row['exit_code']==0 else 'FAILED'
    if row['exit_code']==0:row['artifact_sha256']=sha(out)
    save(O/(n+'-receipt.json'),row)
    print(n,row['proof_status'],round(row['seconds'],2),flush=True)
    return row
def main():
    a=argparse.ArgumentParser();a.add_argument('--targets',nargs='+',required=True);a.add_argument('--out',required=True);a.add_argument('--jobs',type=int,default=2);a.add_argument('--timeout',type=int,default=240);args=a.parse_args()
    O=R/args.out;O.mkdir(exist_ok=True);targets=args.targets;need=set()
    for n in targets:need.update(closure(n))
    prior={}
    for d in R.glob('results-*'):
        for f in d.glob('*-receipt.json'):
            r=json.loads(f.read_text());n=r['name']
            if n not in need:continue
            if (r.get('proof_status')=='COMPILED_ONLY' and artifact(n).exists()
                and r.get('artifact_sha256')==sha(artifact(n))
                and r['source_closure']==closure(n)
                and all(artifact(d).exists() and sha(artifact(d))==h
                        for d,h in r.get('dependency_artifacts',{}).items())):
                prior[n]=r
    done=set(prior);waiting=need-done;active={};failed=[];rows=[]
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        while waiting or active:
            eligible=[n for n in waiting if set(closure(n))-{n}<=done]
            for n in sorted(eligible)[:args.jobs-len(active)]:waiting.remove(n);active[pool.submit(build,n,O,args.timeout)]=n
            if not active:
                if waiting:print('BLOCKED',sorted(waiting),flush=True)
                break
            futures,_=concurrent.futures.wait(active,return_when=concurrent.futures.FIRST_COMPLETED)
            for f in futures:
                n=active.pop(f);r=f.result();rows.append(r)
                if r['proof_status']=='COMPILED_ONLY':done.add(n)
                else:failed.append(n);waiting={w for w in waiting if n not in closure(w)}
            save(O/'SUMMARY.json',{'compiled':sorted(done&need),'failed':failed,'waiting':sorted(waiting),'active':list(active.values()),'targets':targets,'global_main_theorem_complete':False})
    save(O/'SUMMARY.json',{'compiled':sorted(done&need),'failed':failed,'uncompiled':sorted(need-done),'targets':targets,'global_main_theorem_complete':False})
if __name__=='__main__':main()
