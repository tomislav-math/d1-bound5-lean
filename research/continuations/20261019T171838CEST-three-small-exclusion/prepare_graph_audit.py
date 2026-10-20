"""Prepare explicit public-type/axiom and same-kernel checks for reviewed graph modules.
No compiler, Git mutation, source change or queue change is executed here.
"""
from pathlib import Path
import json,re,sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
folder=out/sys.argv[1];names=sys.argv[2:];assert names and len(names)==len(set(names)) and not folder.exists()
decls=[];examples=[]
for module in names:
    s=(root/'D1Bound5'/(module+'.lean')).read_text();ns=re.findall(r'^namespace (\S+)',s,re.M);assert len(ns)==1
    starts=list(re.finditer(r'^theorem (\S+)',s,re.M))
    for index,match in enumerate(starts):
        name=match.group(1);rest=s[match.end():starts[index+1].start() if index+1<len(starts) else len(s)]
        depth=0;proof=None;pos=None
        for i,ch in enumerate(rest):
            if ch in '({[':depth+=1
            elif ch in ')}]':depth-=1
            elif ch==':' and depth==0:
                if rest.startswith(':=',i):proof=i;break
                if pos is None:pos=i
        assert proof is not None and pos is not None,(module,name)
        binders=rest[:pos].strip();goal=rest[pos+1:proof].strip();full=ns[0]+'.'+name
        decls.append({'module':module,'kind':'theorem','name':full})
        examples.append('example : '+('∀ '+binders+',\n    ' if binders else '')+goal+' := @'+full+'\n')
assert len(decls)==len({d['name'] for d in decls})
folder.mkdir();(folder/'TARGETS.json').write_text(json.dumps(names,indent=2)+'\n');(folder/'REPLAY_TARGETS.json').write_text(json.dumps(names,indent=2)+'\n');(folder/'DECLARATIONS.json').write_text(json.dumps(decls,indent=2)+'\n')
code='\n'.join('import D1Bound5.'+n for n in names)+'\nimport Lean.Elab.Command\nimport Lean.Util.CollectAxioms\n\nopen Lean Elab Command\nset_option maxRecDepth 100000\n\nrun_cmd do\n  let names : List Name := [\n'+',\n'.join('    `'+d['name'] for d in decls)+']\n  for name in names do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n\n    unless bad.isEmpty do\n      throwError "Unexpected axioms in {name}: {bad}"\n    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"\n\n'+'\n'.join('#check @'+d['name'] for d in decls)+'\n\nopen D1Bound5 D1Bound5.PairLightAdaptivePrepared26\n\n'+'\n'.join(examples)
(folder/'AnalyticAudit.lean').write_text(code)
(folder/'locked_checks.py').write_bytes((out/'audit-independent/locked_checks.py').read_bytes())
(folder/'README.md').write_text('# Explicit graph verification scope\n\nOriginal Boolean prefix/checker statements, public transitive axioms and one targeted installed same-kernel replay for each named graph module. Not an independent reviewer or whole-root verification. The actual import guard excludes the pending Q audit.\n')
print('GRAPH_AUDIT_PREPARED_NOT_RUN',len(names),'modules',len(decls),'public theorems')
