"""Make the local scalar target explicit before the final simplification."""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, json, difflib
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
source=root/'D1Bound5/CoherentRetainedMixedGap.lean'
old='  exact ⟨hret, by simpa only [one_mul] using hh.trans hret⟩'
new='  refine ⟨hret, ?_⟩\n  change A^2*P^5/S^2 < C\n  simpa only [one_mul] using hh.trans hret'
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
 fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 active=json.loads((work/'continuation-active.json').read_text())
 assert not active.get('active') and not active.get('protected_closure')
 before=source.read_text();pre=hashlib.sha256(source.read_bytes()).hexdigest()
 assert pre=='e6e5cb0fe1bc8561a75325376a6874eb26bf81a343ea357fff9b64184b4c5f33'
 assert before.count(old)==1 and not (out/'CoherentRetainedMixedGap-before-repair02.lean').exists()
 after=before.replace(old,new)
 (out/'CoherentRetainedMixedGap-before-repair02.lean').write_bytes(source.read_bytes())
 (out/'CoherentRetainedMixedGap-repair02.patch').write_text(''.join(difflib.unified_diff(before.splitlines(True),after.splitlines(True),fromfile='before',tofile='after')))
 source.write_text(after)
 post=hashlib.sha256(source.read_bytes()).hexdigest()
 record={'time':datetime.now().astimezone().isoformat(),'source_before':pre,'source_after':post,'change':'Explicitly change to the definitionally equal local scalar goal before simp. Theorem statements unchanged.'}
 (out/'REPAIR02.json').write_text(json.dumps(record,indent=2)+'\n');print(json.dumps(record),flush=True)
