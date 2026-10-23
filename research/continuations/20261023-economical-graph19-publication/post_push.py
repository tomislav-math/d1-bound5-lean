"""Verify the actual ordinary push and saved blobs, then save a post-push receipt."""
from pathlib import Path
import datetime,hashlib,json,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');O=R/'research/continuations'/sys.argv[1]
def g(*a):return subprocess.check_output(['git','-C',str(R),*a],text=True).strip()
h=g('rev-parse','HEAD');remote=g('ls-remote','origin','refs/heads/main').split()[0];assert h==remote
hashes=json.loads((O/'PUBLICATION_HASHES.json').read_text())
for p,v in hashes.items():assert hashlib.sha256(subprocess.check_output(['git','-C',str(R),'show',h+':'+p])).hexdigest()==v
info=json.loads(subprocess.check_output(['/Users/tp/.local/bin/gh','repo','view','tomislav-math/d1-bound5-lean','--json','visibility']));assert info['visibility']=='PRIVATE'
review=json.loads((O/'INDEX_REVIEW.json').read_text());a={'status':'PUSH_VERIFIED','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'head':h,'remote_head':remote,'committed_paths':review['changed_paths'],'reviewed_paths':len(hashes),'main_theorem_complete':False,'graph19_complete':json.loads((O/'VERIFICATION_SUMMARY.json').read_text()).get('graph19_endpoint_complete',False)}
(O/'POST_PUSH_RECEIPT.json').write_text(json.dumps(a,indent=2)+'\n');print(json.dumps(a))
