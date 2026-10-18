"""Repair only the final elaboration step of the mixed retained gap."""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, json, difflib
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
source=root/'D1Bound5/CoherentRetainedMixedGap.lean'
old='  exact ⟨hret,(by simpa only [one_mul] using hh).trans hret⟩'
new='  exact ⟨hret, by simpa only [one_mul] using hh.trans hret⟩'
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
 fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 active=json.loads((work/'continuation-active.json').read_text())
 assert not active.get('active') and not active.get('protected_closure'), 'Active owner'
 before=source.read_text()
 pre=hashlib.sha256(source.read_bytes()).hexdigest()
 assert pre=='2fffa8ff61ad4388a2c7ee7bf5ff257646e13250395da51ae5c2bb49297c760b'
 assert before.count(old)==1 and not (out/'CoherentRetainedMixedGap-before-repair.lean').exists()
 after=before.replace(old,new)
 (out/'CoherentRetainedMixedGap-before-repair.lean').write_bytes(source.read_bytes())
 (out/'CoherentRetainedMixedGap-repair.patch').write_text(''.join(difflib.unified_diff(before.splitlines(True),after.splitlines(True),fromfile='before',tofile='after')))
 source.write_text(after)
 post=hashlib.sha256(source.read_bytes()).hexdigest()
 record={'time':datetime.now().astimezone().isoformat(),'source_before':pre,'source_after':post,'change':'Move transitivity inside the expected-type-provided proof. No theorem header, hypothesis, constant, import or resource limit changed.'}
 (out/'REPAIR.json').write_text(json.dumps(record,indent=2)+'\n')
 print(json.dumps(record),flush=True)
