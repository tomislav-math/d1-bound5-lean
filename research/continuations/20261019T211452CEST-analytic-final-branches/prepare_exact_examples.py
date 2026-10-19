"""Append exact original theorem statements as independently elaborated examples.
The signature scanner preserves let-bindings inside result types, and requires
explicit proof boundaries. This helper itself never compiles or mutates sources.
"""
from pathlib import Path
from datetime import datetime
import json,re,sys
root=Path('/Users/tp/Lean/D1Bound5');run=Path(__file__).resolve().parent
out=run/sys.argv[1]
assert out.parent==run
names=json.loads((out/'TARGETS.json').read_text())
examples=[];report=[]
pat=re.compile(r'^(?:@\[[^\n]*\]\s*)?(theorem|def|abbrev|structure)\s+([^\s:(]+)',re.M)
def theorem_headers(s):
    hits=list(pat.finditer(s));result={}
    for index,m in enumerate(hits):
        if m.group(1)!='theorem':continue
        stop=hits[index+1].start() if index+1<len(hits) else len(s)
        seg=s[m.end():stop]
        by=re.search(r':=\s*by\b',seg)
        if by:header=seg[:by.start()].rstrip()
        else:
            first=seg.find(':=');assert first>=0,m.group(2)
            header=seg[:first].rstrip()
            assert not re.search(r'\blet\b',header), 'Manual exact example required'
        result[m.group(2)]=header
    return result
def explicit_args(h):
    stack=[];start=None;args=[];match={')':'(',']':'[','}':'{'}
    for i,c in enumerate(h):
        if c==':' and not stack:break
        if c in '([{':
            if not stack:start=i
            stack.append(c)
        elif c in ')]}':
            assert stack and stack.pop()==match[c]
            if not stack and h[start]=='(':
                group=h[start+1:i];assert ':' in group,group
                binders=group.split(':',1)[0].strip().split()
                assert all(re.fullmatch(r"[^\W\d][\w']*",b) and b!='_' for b in binders),binders
                args.extend(binders)
    return ' '.join(args)
for n in names:
    source=(root/'D1Bound5'/(n+'.lean')).read_text();original=(run/'before'/(n+'.lean')).read_text()
    old=theorem_headers(original);new=theorem_headers(source);assert old==new,n
    variables=re.findall(r'^variable[^\n]*(?:\n[ \t]+[^\n]+)*',original,re.M)
    examples.append('section\n'+'\n'.join(variables)+'\n')
    for name,h in old.items():
        args=explicit_args(h)
        examples.append('example'+h+' := by\n  exact '+name+(' '+args if args else '')+'\n')
        report.append({'module':n,'name':'D1Bound5.'+name,'original_signature':h,'explicit_arguments':args})
    examples.append('end\n')
with (out/'AnalyticAudit.lean').open('a') as f:
    f.write('\nopen Finset Polynomial\nnamespace D1Bound5\n'+'\n'.join(examples)+'\nend D1Bound5\n')
(out/'EXACT_ORIGINAL_STATEMENT_EXAMPLES.json').write_text(json.dumps(report,indent=2)+'\n')
print('EXACT_ORIGINAL_EXAMPLES_PREPARED',len(report),datetime.now().astimezone().isoformat())
