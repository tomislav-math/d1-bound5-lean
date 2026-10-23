"""Write independent original-type and transitive-axiom audits from preserved original sources."""
from pathlib import Path
import hashlib,json,re,sys
O=Path(__file__).resolve().parent
H=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def declarations(text):
 result=[]
 for m in re.finditer(r'^(?:noncomputable )?(def|theorem)\s+(\S+)\s*(.*?)\s*:=',text,re.M|re.S):
  stack=[];opens=[]
  for line in text[:m.start()].splitlines():
   if line.startswith('namespace '):stack.append(line[10:].strip())
   elif line.startswith('end '):stack.pop()
   elif line.startswith('open '):opens.append(line)
  result.append({'kind':m[1],'local_name':m[2],'namespace':'.'.join(stack),'name':'.'.join(stack)+'.'+m[2],'header':m[3],'opens':opens})
 return result
for i in map(int,sys.argv[1:]):
 d=O/f'graph{i}';p=json.loads((d/'PLAN.json').read_text());decl={};pins={}
 for f in sorted((d/'originals').glob('*.lean')):
  pins[f.name]=H(f)
  for x in declarations(f.read_text()):
   if x['name'] in decl:assert {k:v for k,v in x.items() if k!='opens'}=={k:v for k,v in decl[x['name']].items() if k!='opens'},x['name']
   decl[x['name']]=x
 text=f'import D1Bound5.SmallPairGraphData{i}\nimport Lean.Util.CollectAxioms\nimport Lean.Elab.Command\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\nnoncomputable section\n\n'
 for x in decl.values():
  assert x['header'].lstrip().startswith(':')
  text+=f'namespace {x["namespace"]}\n'+''.join(v+'\n' for v in x['opens'])+f'example {x["header"]} := {x["local_name"]}\nend {x["namespace"]}\n\n'
 names=set(decl)
 for n in p['build_order']:
  if (d/'PURE_CLOSURE_PLAN.json').exists() and re.fullmatch(f'SmallPairGraphClosure{i}Chunk[0-9]+',n):continue
  for x in declarations((d/'candidates'/(n+'.lean')).read_text()):names.add(x['name'])
 for f in (d/'pure-closure-sources').glob('*.lean'):
  for x in declarations(f.read_text()):names.add(x['name'])
 text+='run_cmd do\n  for name in (['+', '.join('`'+n for n in sorted(names))+'] : List Lean.Name) do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n\n    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"\n    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"\n'
 old=d/'OriginalTypesAxioms.lean';back=d/'OriginalTypesAxioms_before_open_context.lean'
 if old.exists() and not back.exists():back.write_bytes(old.read_bytes())
 old.write_text(text)
 (d/'ORIGINAL_TYPE_DECLARATIONS.json').write_text(json.dumps(list(decl.values()),indent=2,sort_keys=True)+'\n')
 (d/'AUDIT_PLAN.json').write_text(json.dumps({'status':'PREPARED_NOT_RUN','required_closure_backend':'pure' if (d/'PURE_CLOSURE_PLAN.json').exists() else 'original','original_type_checks':len(decl),'axiom_checks':len(names),'original_source_sha256':pins,'audit_sha256':H(d/'OriginalTypesAxioms.lean')},indent=2,sort_keys=True)+'\n')
 p['original_public_theorem_headers_preserved']=p.pop('original_header_preservation',p.get('original_public_theorem_headers_preserved'));p['all_definition_headers_byte_identical']=False;p['definition_modifier_changes']='noncomputable cached chunks, concatenated public cached data, and dependent adaptive cached aliases'
 (d/'PLAN.json').write_text(json.dumps(p,indent=2,sort_keys=True)+'\n')
 print(json.dumps({'graph':i,'original_types':len(decl),'axiom_checks':len(names)}),flush=True)
