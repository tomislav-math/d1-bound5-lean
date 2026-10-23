#!/usr/bin/env python3
"""Install reviewed pure-closure proof only after guarded adapter compilation, retaining public types."""
from pathlib import Path
import argparse,hashlib,json,re,time
import guarded_general_b as G
R=Path(__file__).resolve().parent
a=argparse.ArgumentParser();a.add_argument('graph',type=int,choices=[14,15,21,28,36]);g=a.parse_args().graph
name=f'SmallPairGraphClosure{g}';adapter=f'SmallPairPureClosureAdapter{g}'
plan=json.loads((R/f'graph{g}-plan.json').read_text())
target=G.src(name);proposal=R/f'graph{g}-ORIGINAL_CLOSURE_REPLACEMENT.lean'
oldhash=plan['source_manifest'][name];newhash=G.sha(proposal)
assert G.sha(target) in [oldhash,newhash],'CLOSURE_SOURCE_CHANGED'
receipts=[]
for f in R.glob(f'results-*/{adapter}-receipt.json'):
 row=json.loads(f.read_text())
 if (row.get('proof_status')=='COMPILED_ONLY' and row['source_closure']==G.closure(adapter)
   and row['artifact_sha256']==G.sha(G.artifact(adapter))
   and all(G.sha(G.artifact(n))==h for n,h in row['dependency_artifacts'].items())
   and row.get('external_import_artifacts')==G.external(G.closure(adapter))):receipts.append((str(f),G.sha(f)))
assert receipts,'NO_VALIDATED_ADAPTER_RECEIPT'
O=R/f'results-graphs-b-closure-install-{g}';O.mkdir(exist_ok=True)
saved=O/(name+'-fallback.lean')
if not saved.exists():
 assert G.sha(target)==oldhash,'MISSING_PRIOR_SOURCE'
 saved.write_bytes(target.read_bytes())
assert G.sha(saved)==oldhash
headers=lambda s:re.findall(r'^theorem\s+(\S+)\s*([\s\S]*?)\s*:=',s,re.M)
oldheaders=headers(saved.read_text());newheaders=headers(proposal.read_text())
assert oldheaders==newheaders,'ORIGINAL_PUBLIC_THEOREM_TYPES_CHANGED'
target.write_bytes(proposal.read_bytes())
row={'status':'PURE_CLOSURE_SUCCESSOR_INSTALLED_ADAPTER_COMPILED_ENDPOINT_PENDING','graph':g,'module':name,'prior_sha256':oldhash,'successor_sha256':newhash,'original_public_headers_unchanged':oldheaders,'adapter_receipts':receipts,'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'main_theorem_complete':False}
G.save(O/'INSTALL_RECEIPT.json',row);print(json.dumps(row))
