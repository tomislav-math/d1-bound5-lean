"""Prepare joins and audit in this research directory only. No project-source edit,
compilation, queue change, or Git operation. Parent types come from the originals.
"""
from pathlib import Path
import json,re
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
prior=root/'research/continuations/20261019T175309CEST-graph-continuation'
plan=json.loads((out/'PARTITION_PLAN.json').read_text())
original=json.loads((out/'ORIGINAL_PARENTS.json').read_text())
drafts=out/'parent-drafts';drafts.mkdir()
allnames=[];decls=[];examples=[]
for item in plan:
    parent=item['parent'];side=item['side'];block=item['block'];count=item['heads'];parts=item['parts']
    lines=['import D1Bound5.PairLightArithmeticPrefixConcat']+['import D1Bound5.'+p['name'] for p in parts]
    lines+=['','namespace D1Bound5.PairLightAdaptivePrepared26','set_option maxRecDepth 100000','',
      '/-- Exact original head block; every head retains its entire remaining tail. -/',
      'theorem '+original[parent]['header']+' := by']
    for index in reversed(range(len(parts))):
        p=parts[index];offset=p['offset'];n=count-offset;m=p['length']
        statement=(f'pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve {n}\n      ({side}Cached{block}.drop {offset}) ({side}Rows{block}.drop {offset}) = true')
        head=f'  have h{offset:03d} : '+statement
        theorem=f'{side}_prefix_{block}_part{index:02d}_checked'
        if index==len(parts)-1:
            lines.append(head+' := '+theorem)
        else:
            lines += [head+' := by',f'    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve {m} {n-m}',
              f'      ({side}Cached{block}.drop {offset}) ({side}Rows{block}.drop {offset})',
              '    · exact '+theorem,f'    · simpa only [List.drop_drop] using h{offset+m:03d}']
    lines+=['  simpa only [List.drop_zero] using h000','','end D1Bound5.PairLightAdaptivePrepared26','']
    code='\n'.join(lines)
    assert code.split('theorem ',1)[1].split(' := by',1)[0]==original[parent]['header']
    (drafts/(parent+'.lean')).write_text(code)
    allnames += [p['name'] for p in parts]+[parent]
    for name in [p['name'] for p in parts]+[parent]:
        text=code if name==parent else (root/'D1Bound5'/(name+'.lean')).read_text()
        matches=re.findall(r'^theorem (\S+)\s*:(.*?) := by',text,re.M|re.S)
        assert len(matches)==1
        short,statement=matches[0];full='D1Bound5.PairLightAdaptivePrepared26.'+short
        decls.append({'module':name,'name':full,'kind':'theorem'})
        examples.append('example : '+statement.strip()+' := @'+full)
audit=out/'audit';audit.mkdir()
for fname,data in [('TARGETS.json',allnames),('REPLAY_TARGETS.json',allnames),('DECLARATIONS.json',decls)]:
    (audit/fname).write_text(json.dumps(data,indent=2)+'\n')
text='\n'.join('import D1Bound5.'+n for n in allnames)+'\nimport Lean.Elab.Command\nimport Lean.Util.CollectAxioms\n\nopen Lean Elab Command\nset_option maxRecDepth 100000\n\nrun_cmd do\n  let names : List Name := [\n'+',\n'.join('    `'+d['name'] for d in decls)+']\n  for name in names do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n\n    unless bad.isEmpty do\n      throwError "Unexpected axioms in {name}: {bad}"\n    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"\n\n'
text+='\n'.join('#check @'+d['name'] for d in decls)+'\n\nopen D1Bound5 D1Bound5.PairLightAdaptivePrepared26\n\n'+'\n\n'.join(examples)
text+='\n\n-- Exact list extents and counts, independently kernel checked.\n'
text+='example : leftCached001.length = 707 ∧ leftRows001.length = 707 ∧ rightCached001.length = 707 ∧ rightRows001.length = 707 := by decide +kernel\n'
text+='example : leftCached002.length = 648 ∧ leftRows002.length = 648 ∧ rightCached002.length = 648 ∧ rightRows002.length = 648 := by decide +kernel\n'
text+='example : ((List.range 59).map (fun i => 706-i)).sum = 39943 := by decide +kernel\n'
text+='example : ((List.range 65).map (fun i => 647-i)).sum = 39975 := by decide +kernel\n'
text+='example : 2*(39943+39975) = (159836 : Nat) := by decide +kernel\n'
(audit/'AnalyticAudit.lean').write_text(text)
(audit/'locked_checks.py').write_bytes((prior/'audit-fixed/locked_checks.py').read_bytes())
(audit/'README.md').write_text('# Scope\n\nExact original parent types and all new leaf types, transitive allowed axioms, and one targeted installed SAME-kernel replay per selected module. Not an independent review or whole-root clean-checkout test. Prepared only until matching terminal receipts exist.\n')
print('PREPARED_ONLY',len(plan),'parent joins;',len(decls),'exact theorem examples and targeted replay commands')
