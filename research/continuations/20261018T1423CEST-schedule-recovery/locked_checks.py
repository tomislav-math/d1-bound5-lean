"""Sequential targeted checks with the existing exclusive proof-owner lock."""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,json,os,signal,subprocess,sys,time
r=Path('/Users/tp/Lean/D1Bound5')
w=r/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
source=r/'D1Bound5/BennettCoefficientMajorant.lean'
expected=json.loads((out/'BUILD_RECEIPT.json').read_text())['source_sha256']
commands=[('type-axiom-audit',['/Users/tp/.elan/bin/lake','env','lean',str(out/'BennettCoefficientMajorantAudit.lean')]),('kernel-replay',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.BennettCoefficientMajorant'])]
records=[]
with (w/'continuation-driver.lock').open('a+') as owner:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
 if json.loads((w/'continuation-active.json').read_text()).get('active'):raise RuntimeError('Other proof active')
 for label,args in commands:
  if hashlib.sha256(source.read_bytes()).hexdigest()!=expected:raise RuntimeError('Source changed')
  start=time.monotonic(); log=out/(label+'.log')
  with log.open('w') as stream:
   p=subprocess.Popen(args,cwd=r,env={**os.environ,'LEAN_NUM_THREADS':'1'},stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
   active={'label':label,'pid':p.pid,'command':args,'utc':datetime.now().astimezone().isoformat()}
   (out/'active-check.json').write_text(json.dumps(active,indent=2)+'\n')
   print(json.dumps(active),flush=True)
   timed_out=False
   try:p.wait(timeout=180)
   except subprocess.TimeoutExpired:
    timed_out=True;os.killpg(p.pid,signal.SIGTERM)
    try:p.wait(timeout=10)
    except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
  unchanged=hashlib.sha256(source.read_bytes()).hexdigest()==expected
  rec={**active,'exit':p.returncode,'seconds':time.monotonic()-start,'timed_out':timed_out,'source_unchanged':unchanged,'log':log.name}
  records.append(rec);(out/'CHECK_RECEIPTS.json').write_text(json.dumps(records,indent=2)+'\n')
  (out/'active-check.json').write_text(json.dumps({'active':False,'last':rec},indent=2)+'\n')
  print(json.dumps(rec),flush=True)
  if p.returncode or timed_out or not unchanged:sys.exit(1)
print('TARGETED_CHECKS_PASS',flush=True)
