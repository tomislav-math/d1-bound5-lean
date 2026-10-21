"""Apply explicitly reviewed source replacements under both existing locks."""
from pathlib import Path
from datetime import datetime, timezone
import fcntl, hashlib, json, re, sys
root=Path('/Users/tp/Lean/D1Bound5')
out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
spec=Path(sys.argv[1]).resolve()
assert spec.is_relative_to(out)
plan=json.loads(spec.read_text())
assert plan['targets']
def sha(data): return hashlib.sha256(data).hexdigest()
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 active=json.loads((work/'continuation-active.json').read_text())
 assert not active.get('active') and not active.get('protected_closure')
 qbytes=(work/'continuation-queue.json').read_bytes();q=json.loads(qbytes)
 assert q['max_parallel']==1 and q['pause_after_current'] is True
 index=(root/'.git/index').read_bytes()
 changes=[]
 for item in plan['targets']:
  n=item['module'];assert re.fullmatch(r'[A-Za-z0-9_]+',n) and n in q['names']
  p=root/'D1Bound5'/(n+'.lean');data=p.read_bytes()
  assert sha(data)==item['source_sha256'], 'Preimage changed: '+n
  s=data.decode()
  for r in item['replacements']:
   assert r['old'] and r['old']!=r['new'] and s.count(r['old'])==r['count'], 'Replacement mismatch: '+n
   s=s.replace(r['old'],r['new'])
  def headers(text):
   result=[]
   for match in re.finditer(r'^(?:@\[[^\n]*\][ \t]*)?(?:noncomputable[ \t]+)?(def|theorem)[ \t]+([^\s:(]+)',text,re.M):
    tail=text[match.end():]
    boundary=re.search(r':=\s*by\b',tail) if match.group(1)=='theorem' else re.search(r':=',tail)
    assert boundary is not None
    result.append((match.group(1),match.group(2),tail[:boundary.start()].strip()))
   return result
  assert headers(data.decode().replace('|*','| *'))==headers(s), 'Public header drift: '+n
  assert re.findall(r'^(?:import|variable|namespace|open).*$',data.decode(),re.M)==re.findall(r'^(?:import|variable|namespace|open).*$',s,re.M)
  assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s), 'Prohibited source construct: '+n
  changes.append((n,p,data,s.encode()))
 receipt=out/(spec.stem+'-APPLIED.json');assert not receipt.exists()
 backup=out/(spec.stem+'-before');backup.mkdir()
 (out/'before').mkdir(exist_ok=True)
 for n,p,data,newdata in changes:
  (backup/(n+'.lean')).write_bytes(data)
  original=out/'before'/(n+'.lean')
  if not original.exists():original.write_bytes(data)
  p.write_bytes(newdata)
 assert (work/'continuation-queue.json').read_bytes()==qbytes and (root/'.git/index').read_bytes()==index
 record={'utc':datetime.now(timezone.utc).isoformat(),'both_locks_held':True,'queue_unchanged':True,'index_unchanged':True,'targets':{n:{'before':sha(data),'after':sha(newdata)} for n,p,data,newdata in changes}}
 receipt.write_text(json.dumps(record,indent=2)+'\n')
 print(json.dumps(record))
