"""Prepare an offline, exact split of the 1,016 certificate records."""
from pathlib import Path
import copy, hashlib, json, re
from batch_uploader import validate
from global_uploader import atomic_bytes, encoded
from adapt_cached_literals import append_expression

ROOT=Path(__file__).resolve().parent
TARGET='D1Bound5_PellFiniteFieldCoverageData_Definitions'

def main():
    old=ROOT/'full-payloads/MANIFEST_FIELD7_RECOVERY_V10.json'
    manifest=json.loads(old.read_text()); nodes={n['name']:n for n in manifest['nodes']}
    node=nodes[TARGET]; source=node['payload']['definition']
    marker='def pellCertifiedFields : List (Σ d : ℤ, PellFiniteCertificate d (10^275)) :='
    begin=source.index('[',source.index(marker)+len(marker))
    end=source.index(']',begin)+1
    literal=source[begin:end]
    matches=list(re.finditer(r'⟨([0-9]+),pellFiniteCertificate_([0-9]+)⟩',literal))
    rows=[m.group(0) for m in matches]
    assert len(rows)==1016 and all(m.group(1)==m.group(2) for m in matches)
    assert re.sub(r'\s+','',literal)=='['+','.join(rows)+']'
    owners={}
    for dep in node['publish_dependencies']:
        if '_PellLightAllFiniteCertificates_Definitions_' not in dep:continue
        for field in re.findall(r'(?m)^def pellFiniteCertificate_([0-9]+)\b',nodes[dep]['payload']['definition']):
            assert field not in owners
            owners[field]=dep
    assert all(m.group(1) in owners for m in matches)
    helpers=[]; records=[]; all_rows=[]
    for idx,start in enumerate(range(0,len(rows),64)):
        part=rows[start:start+64]; all_rows.extend(part)
        fields=[m.group(1) for m in matches[start:start+64]]
        deps=sorted({'D1Bound5_PellFiniteCertificate_Definitions'}|{owners[f] for f in fields})
        ident='pellCertifiedFieldsSlice'+str(idx).zfill(2)+'_20261024'
        name='D1Bound5_Prove2MeTransfer_'+ident
        body='import Init\n'+''.join('import Definitions.Def_'+d+'\n' for d in deps)
        body+='\nnamespace D1Bound5\nset_option maxRecDepth 32768\nset_option maxHeartbeats 12000000\n\n'
        body+='def Prove2MeTransfer.'+ident+' : List (Σ d : ℤ, PellFiniteCertificate d (10^275)) :=\n  ['+',\n   '.join(part)+']\n\nend D1Bound5\n'
        helper={'name':name,'kind':'definition','unit_id':'coverage_slice_'+str(idx),
                'payload':{'definition_name':name,'definition_title':'Exact Pell certificate records '+str(start+1)+'–'+str(start+len(part)),
                           'definition':body,'env':manifest['env'],'private':True,
                           'natural_language_statement':'The exact consecutive certificate records '+str(start+1)+' through '+str(start+len(part))+' of pellCertifiedFields. Their ordered concatenation preserves the original dependent pairs and certificates.',
                           'source':node['payload']['source'],'tags':node['payload'].get('tags',[])},
                'publish_dependencies':deps,'proof_dependencies':deps,
                'definition_file':'adaptations/coverage-slices-v11/Def_'+name+'.lean',
                'definition_sha256':hashlib.sha256(body.encode()).hexdigest()}
        assert name not in nodes
        helpers.append(helper);records.append({'name':name,'lean_name':'D1Bound5.Prove2MeTransfer.'+ident,'rows':part,'start':start,'end':start+len(part),'fields':fields})
    assert all_rows==rows
    revised=copy.deepcopy(node)
    imports=''.join('import Definitions.Def_'+n['name']+'\n' for n in helpers)
    expression=append_expression([r['lean_name'] for r in records])
    body=imports+source[:begin]+expression+source[end:]
    assert body[len(imports):].replace(expression,literal,1)==source
    revised['payload']['definition']=body
    revised['definition_file']='adaptations/coverage-slices-v11/Def_'+TARGET+'.lean'
    revised['definition_sha256']=hashlib.sha256(body.encode()).hexdigest()
    for key in ['publish_dependencies','proof_dependencies']:
        revised[key]=sorted(set(node[key])|{n['name'] for n in helpers})
    new=copy.deepcopy(manifest)
    new['nodes']=helpers+[revised if n['name']==TARGET else n for n in manifest['nodes']]
    for n in helpers+[revised]:
        atomic_bytes(old.parent/n['definition_file'],n['payload']['definition'].encode())
    checked,_=validate(new,old.parent)
    for name,n in nodes.items():
        if name!=TARGET:assert checked[name]['payload']==n['payload']
    target=old.parent/'MANIFEST_COVERAGE_SLICES_V11.json'
    atomic_bytes(target,encoded(new))
    report={'schema':'p2m-exact-dependent-certificate-slices-v1','target':TARGET,
            'old_manifest_path':str(old),'old_manifest_sha256':hashlib.sha256(old.read_bytes()).hexdigest(),
            'new_manifest_path':str(target),'new_manifest_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),
            'old_definition_sha256':hashlib.sha256(source.encode()).hexdigest(),
            'new_definition_sha256':hashlib.sha256(body.encode()).hexdigest(),
            'rows':len(rows),'helpers':records,'helper_names':[n['name'] for n in helpers],
            'exact_row_order_preserved':True,'all_other_source_text_preserved':True,
            'all_original_proof_files_unchanged':True,'global_ledger_unchanged':True,
            'equality_reason':'List.append unfolds to the original ordered List.cons values, with the identical dependent pairs and certificate constants.'}
    atomic_bytes(ROOT/'COVERAGE_SLICES_V11_PREPARATION.json',encoded(report))
    print(json.dumps({'status':'OFFLINE_FALLBACK_PREPARED','helpers':len(helpers),
                      'rows':len(rows),'main_bytes':len(body.encode()),
                      'maximum_helper_bytes':max(len(n['payload']['definition'].encode()) for n in helpers),
                      'network_mutations':0,'global_ledger_changed':False}),flush=True)
if __name__=='__main__':main()
