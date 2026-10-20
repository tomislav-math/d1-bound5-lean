"""Prepare an explicit bounded verification batch from already reviewed module names.
This does not compile, change project sources, alter the queue or mutate Git.
"""
from pathlib import Path
from datetime import datetime
import hashlib,json,re,sys
def source_code(s):
    result=[]; i=0; depth=0
    while i<len(s):
        if depth:
            if s.startswith('/-',i): depth+=1;i+=2
            elif s.startswith('-/',i):depth-=1;i+=2
            else:i+=1
        elif s.startswith('/-',i):depth=1;i+=2;result.append(' ')
        elif s.startswith('--',i):
            j=s.find('\n',i);i=len(s) if j<0 else j;result.append(' ')
        elif s[i]=='"':
            i+=1
            while i<len(s):
                if ord(s[i])==92:i+=2
                elif s[i]=='"':i+=1;break
                else:i+=1
            result.append(' ')
        else:result.append(s[i]);i+=1
    assert depth==0, 'Unterminated source comment'
    return ''.join(result)

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
    assert not re.search(r'\b(sorry|admit|sorryAx|native_decide|axiom|unsafe|implemented_by)\b',source_code(text))
    review[n]={'sha256':hashlib.sha256(data).hexdigest(),'imports':re.findall(r'^import (.+)',text,re.M),'review':'Explicitly selected, previously read source. Current hashes must still match at launch.'}
folder.mkdir()
(folder/'TARGETS.json').write_text(json.dumps(names,indent=2)+'\n')
(folder/'PRE_BUILD_SOURCE_REVIEW.json').write_text(json.dumps(review,indent=2)+'\n')
(folder/'batch_run.py').write_bytes((run/'batch_run.py').read_bytes())
print('PREPARED_ONLY',folder.name,names,datetime.now().astimezone().isoformat())
