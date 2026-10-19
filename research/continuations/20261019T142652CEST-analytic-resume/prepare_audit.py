"""Prepare source-based public declaration/type/axiom audit; no compiler or Git writes.
The exact replay list is explicit and is not silently promoted to whole-root checking.
"""
from pathlib import Path
import json,re,sys,hashlib
root=Path('/Users/tp/Lean/D1Bound5');run=Path(__file__).resolve().parent
folder=run/sys.argv[1];assert folder.parent==run and not folder.exists()
names=sys.argv[2:];assert names and len(names)==len(set(names))
decls=[]
for n in names:
    s=(root/'D1Bound5'/(n+'.lean')).read_text()
    assert re.findall(r'^namespace (\S+)',s,re.M)==['D1Bound5']
    for m in re.finditer(r'^(?:@\[[^\n]*\]\s*)?(?:noncomputable\s+)?(def|theorem|structure|abbrev)\s+([^\s:(]+)',s,re.M):
        decls.append({'module':n,'kind':m.group(1),'name':'D1Bound5.'+m.group(2)})
assert len(decls)==len({d['name'] for d in decls})
folder.mkdir()
(folder/'TARGETS.json').write_text(json.dumps(names,indent=2)+'\n')
(folder/'DECLARATIONS.json').write_text(json.dumps(decls,indent=2)+'\n')
code='\n'.join('import D1Bound5.'+n for n in names)+'\nimport Lean.Elab.Command\nimport Lean.Util.CollectAxioms\n\nopen Lean Elab Command\n\nset_option maxRecDepth 32768\n\nrun_cmd do\n  let names : List Name := [\n'+',\n'.join('    `'+d['name'] for d in decls)+']\n  for name in names do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n\n    unless bad.isEmpty do\n      throwError "Unexpected axioms in {name}: {bad}"\n    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"\n\n'+'\n'.join('#check @'+d['name'] for d in decls)+'\n'
(folder/'AnalyticAudit.lean').write_text(code)
prior=root/'research/continuations/20261019T103738CEST-pell-matching-batch/locked_checks.py'
checker=prior.read_text().replace("out/'PellCertificateAudit.lean'","out/'AnalyticAudit.lean'").replace("'pell-certificate-type-axioms'","'analytic-type-axioms'").replace('PELL_BATCH_CHECKS_PASS','ANALYTIC_CHECKS_PASS')
(folder/'locked_checks.py').write_text(checker)
print('AUDIT_PREPARED_NOT_RUN',len(names),'modules',len(decls),'public declarations')
