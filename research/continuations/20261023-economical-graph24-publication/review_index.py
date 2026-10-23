"""Read-only exact index and private-destination review; save review evidence."""
from pathlib import Path
import hashlib,json,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');O=R/'research/continuations'/sys.argv[1]
h=json.loads((O/'PUBLICATION_HASHES.json').read_text());changed=subprocess.check_output(['git','-C',str(R),'diff','--cached','--name-only'],text=True).splitlines();assert changed and set(changed)<=set(h)
for p,v in h.items():assert hashlib.sha256(subprocess.check_output(['git','-C',str(R),'show',':'+p])).hexdigest()==v
reports={}
for script in ['git_sync_preflight.py','git_sync_index_review.py']:
 a=subprocess.run(['/Users/tp/.local/bin/python3.12','-B',str(R/'scripts'/script)],capture_output=True,text=True);report=json.loads(a.stdout);assert a.returncode==0,report;reports[script]=report
(O/'INDEX_REVIEW.json').write_text(json.dumps({'reviewed_paths':len(h),'changed_paths':len(changed),'reports':reports},indent=2)+'\n')
print(json.dumps({'status':'EXACT_INDEX_AND_PRIVATE_DESTINATION_PASS','reviewed_paths':len(h),'changed_paths':len(changed),'index_fingerprint':reports['git_sync_index_review.py']['index_fingerprint']}))
