"""Prepare an explicit bounded verification batch from already reviewed module names.
This does not compile, change project sources, alter the queue or mutate Git.
"""
from pathlib import Path
from datetime import datetime
import hashlib,json,re,sys
root=Path('/Users/tp/Lean/D1Bound5')
run=Path(__file__).resolve().parent
folder=run/sys.argv[1]
assert folder.parent==run and not folder.exists()
names=sys.argv[2:]
assert names and len(names)==len(set(names))
assert all(re.fullmatch('[A-Za-z0-9_]+',n) for n in names)
review={}
for n in names:
    p=root/'D1Bound5'/(n+'.lean');data=p.read_bytes();text=data.decode()
    assert not re.search(r'\b(sorry|admit|sorryAx|native_decide|axiom|unsafe)\b',text)
    review[n]={'sha256':hashlib.sha256(data).hexdigest(),'imports':re.findall(r'^import (.+)',text,re.M),'review':'Explicitly selected, previously read source. Current hashes must still match at launch.'}
folder.mkdir()
(folder/'TARGETS.json').write_text(json.dumps(names,indent=2)+'\n')
(folder/'PRE_BUILD_SOURCE_REVIEW.json').write_text(json.dumps(review,indent=2)+'\n')
(folder/'batch_run.py').write_bytes((run/'wave01/batch_run.py').read_bytes())
print('PREPARED_ONLY',folder.name,names,datetime.now().astimezone().isoformat())
