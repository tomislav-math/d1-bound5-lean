from pathlib import Path
import fcntl, subprocess, json, time, os, signal, hashlib
root=Path('/Users/tp/Lean/D1Bound5'); work=root/'research/continuations/20261018T010800CEST-main-continuation';out=Path(__file__).parent
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB); fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 d=json.loads((work/'continuation-active.json').read_text()); assert not d['active'] and not d['protected_closure']
 source=root/'D1Bound5/BennettTwoResidualBound.lean'; sha=hashlib.sha256(source.read_bytes()).hexdigest(); assert sha=='ca93022505dbc1c4d74fe949e488db6dcf4bf0f1cbebbd1635b2a6e0bdfce03a'
 commands=[('type-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(out/'TwoResidualAudit.lean')]),('same-kernel-replay',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.BennettTwoResidualBound'])]
 results=[]
 for label,cmd in commands:
  log=out/(label+'.log'); start=time.monotonic()
  with log.open('w') as f:
   p=subprocess.Popen(cmd,cwd=root,stdout=f,stderr=subprocess.STDOUT,env={**os.environ,'LEAN_NUM_THREADS':'1'},start_new_session=True)
   (out/'active-check.json').write_text(json.dumps({'pid':p.pid,'cmd':cmd,'label':label,'active':True}))
   try:p.wait(timeout=240)
   except subprocess.TimeoutExpired:
    os.killpg(p.pid,signal.SIGTERM);p.wait(timeout=12)
  row={'label':label,'pid':p.pid,'exit':p.returncode,'seconds':round(time.monotonic()-start,3),'source_unchanged':hashlib.sha256(source.read_bytes()).hexdigest()==sha};results.append(row)
  (out/'checks.json').write_text(json.dumps(results,indent=2));(out/'active-check.json').write_text(json.dumps({'active':False,'last':row}));print(json.dumps(row),flush=True)
  if p.returncode!=0 or not row['source_unchanged']:break
