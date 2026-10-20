"""Prepare a source-based exact declaration and axiom audit. Does not compile.
Only explicitly selected modules are inspected. Final actual process receipts
and source/artifact guards are required before any verification claim.
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
decls=[];source_map={};headers={}
folder.mkdir()
for n in names:
    data=(root/'D1Bound5'/(n+'.lean')).read_bytes();s=data.decode()
    assert re.findall(r'^namespace (\S+)',s,re.M)==['D1Bound5'],n
    for m in re.finditer(r'^(?:@\[[^\n]*\]\s*)?(?:noncomputable\s+)?(def|theorem|structure|abbrev)\s+([^\s:(]+)',s,re.M):
        decls.append({'module':n,'kind':m.group(1),'name':'D1Bound5.'+m.group(2)})
    before=run/'before'/(n+'.lean')
    pattern=re.compile(r'^(?:@\[[^\n]*\][ \t]*)?(?:noncomputable[ \t]+)?(def|theorem)[ \t]+([^\s:(]+)',re.M)
    def public_headers(text):
        headers=[]
        for match in pattern.finditer(text):
            tail=text[match.end():]
            boundary=re.search(r':=\s*by\b',tail) if match.group(1)=='theorem' else re.search(r':=',tail)
            assert boundary is not None, match.group(2)
            headers.append((match.group(1),match.group(2),tail[:boundary.start()].strip()))
        return headers
    old_headers=public_headers(before.read_text())
    current_headers=public_headers(s)
    assert old_headers==current_headers, 'Original public headers changed: '+n
    headers[n]={'unchanged':True,'count':len(old_headers)}
    (folder/(n+'.lean')).write_bytes(data)
    source_map[n]={'source':'D1Bound5/'+n+'.lean','snapshot':str((folder/(n+'.lean')).relative_to(root)),'sha256':hashlib.sha256(data).hexdigest()}
assert len(decls)==len({d['name'] for d in decls})
for n,v in [('TARGETS.json',names),('DECLARATIONS.json',decls),('SOURCE_MAP.json',source_map),('HEADER_REVIEW.json',headers)]:
    (folder/n).write_text(json.dumps(v,indent=2)+'\n')
code='\n'.join('import D1Bound5.'+n for n in names)+'\nimport Lean.Elab.Command\nimport Lean.Util.CollectAxioms\nopen Lean Elab Command\nopen scoped NumberField\nopen Module\nset_option maxRecDepth 32768\nrun_cmd do\n  let names : List Name := [\n'+',\n'.join('    `'+d['name'] for d in decls)+']\n  for name in names do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n\n    unless bad.isEmpty do\n      throwError "Unexpected axioms in {name}: {bad}"\n    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"\n\n'+'\n'.join('#check @'+d['name'] for d in decls)+'\n'
(folder/'AnalyticAudit.lean').write_text(code)
(folder/'locked_checks.py').write_bytes((root/'research/continuations/20261019T211452CEST-analytic-final-branches/retained-audit/locked_checks.py').read_bytes())
print('PUBLIC_AUDIT_PREPARED_NOT_RUN',folder.name,len(names),'modules',len(decls),'public declarations',datetime.now().astimezone().isoformat())
