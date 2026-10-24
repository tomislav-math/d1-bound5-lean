"""Build a proof-level closure that never imports all certificate data at once."""
from pathlib import Path
import copy, hashlib, json, re
from batch_uploader import validate
from global_uploader import atomic_bytes, encoded

ROOT=Path(__file__).resolve().parent
BASE='D1Bound5_PellFiniteCertificate_Definitions'
LIGHT='D1Bound5_PellFiniteFieldCoverageLight_Definitions'
EXISTS='D1Bound5.pellFiniteCertificate_exists'

def main():
    old=json.loads((ROOT/'full-payloads/MANIFEST_COVERAGE_SLICES_V11.json').read_text())
    ns={n['name']:n for n in old['nodes']}
    state=json.loads((ROOT/'GLOBAL_UPLOAD_STATE.json').read_text())
    pieces=json.loads((ROOT/'COVERAGE_SLICES_V11_PREPARATION.json').read_text())['helpers']
    out=ROOT/'logical-closure-20261024'
    out.mkdir(exist_ok=True)
    assert not (out/'UPLOAD_STATE.json').exists()
    environment=old['env']
    created=[]; lists=[]; claims=[]
    template=ns[EXISTS]['payload']
    def preamble(deps,extra=''):
        return 'import Mathlib.Tactic\n'+extra+''.join(('import Definitions.Def_' if k=='definition' else 'import Theorems.Thm_')+n.replace('.','_')+'\n' for n,k in deps)
    context='\nsection\nnamespace D1Bound5\nset_option maxRecDepth 32768\nset_option maxHeartbeats 12000000\n\n'
    ending='\nend D1Bound5\nend\n'
    def theorem(name,title,statement,proof,publish_deps,proof_deps,summary):
        pp=preamble(publish_deps)
        sp=preamble(proof_deps)
        source=sp+context+'theorem _root_.solution '+statement+' := by\n'+proof+ending
        path='Solutions/'+name.replace('.','_')+'.lean'
        atomic_bytes(out/path,source.encode())
        node={'name':name,'kind':'theorem','unit_id':'logical_'+name.replace('.','_'),
              'payload':{'theorem_name':name,'theorem_title':title,'preamble':pp,
                         'formal_statement':context+'theorem _root_.'+name+' '+statement+' := by sorry\n'+ending,
                         'natural_language_statement':summary,'source':template['source'],
                         'tags':template.get('tags',[]),'private':True,'env':environment},
              'publish_dependencies':[n for n,k in publish_deps],
              'proof_dependencies':[n for n,k in proof_deps],
              'solution':path,'solution_sha256':hashlib.sha256(source.encode()).hexdigest(),
              'explanation':summary+' The submitted Lean proof checks the stated claim without additional axioms or unfinished proof terms.'}
        return node
    for i,piece in enumerate(pieces):
        values=[int(f) for f in piece['fields']]
        literal='(['+','.join(str(v) for v in values)+'] : List ℤ)'
        lists.append(literal)
        name='D1Bound5.Prove2MeTransfer.pellCertificateMembership'+str(i).zfill(2)+'_20261024'
        claims.append(name)
        statement='(d : ℤ) (hd : d ∈ '+literal+') : Nonempty (PellFiniteCertificate d (10^275))'
        proof=('  have he : '+piece['lean_name']+'.map Sigma.fst = '+literal+' := by rfl\n'
               '  rw [← he] at hd\n'
               '  obtain ⟨r, _, hr⟩ := List.mem_map.mp hd\n'
               '  cases hr\n'
               '  exact ⟨r.2⟩\n')
        created.append(theorem(name,'Pell certificate existence, records '+str(piece['start']+1)+'–'+str(piece['end']),
                       statement,proof,[(BASE,'definition')],[(BASE,'definition'),(piece['name'],'definition')],
                       'Every integer parameter in the displayed list has a complete finite Pell certificate at cutoff 10^275. The proof extracts it from the corresponding already verified block of the original 1,016 certificate records.'))
    light00='D1Bound5.Prove2MeTransfer.pellCoverageLightBlock00_20261024'
    created.append(theorem(light00,'Exact light coverage of indices 0–49',
                   ': ∀ k : Fin 50, PellFieldCoverageLightAt (0+k.val)','  decide +kernel\n',
                   [(LIGHT,'definition')],[(LIGHT,'definition')],
                   'For indices 0 through 49, the original integer parameter list or an explicit nonunit square divisor verifies the field-coverage test. This is the light-data form of the first coverage block.'))
    blocks=['D1Bound5.pellFieldCoverageBlock'+str(i).zfill(2)+'_checked' for i in range(1,25)]
    proof_deps=[(BASE,'definition'),(LIGHT,'definition')]+[(n,'theorem') for n in claims+[light00]+blocks]
    root=copy.deepcopy(ns[EXISTS])
    appended=lists[-1]
    for literal in reversed(lists[:-1]):appended='('+literal+' ++ '+appended+')'
    parameters=re.search(r'def pellFieldCoverageParameters[^:]*:\s*List Int\s*:=\s*(\[[^\]]*\])',ns[LIGHT]['payload']['definition'])
    if parameters is None:
        parameters=re.search(r'def pellFieldCoverageParameters\s*:\s*List ℤ\s*:=\s*(\[[^\]]*\])',ns[LIGHT]['payload']['definition'])
    assert parameters is not None
    assert json.loads(parameters.group(1))==[int(f) for piece in pieces for f in piece['fields']]
    source=preamble(proof_deps,'import Mathlib.Algebra.Squarefree.Basic\nimport Mathlib.Algebra.Group.Int.Units\n')+context
    source+='private theorem transfer_certificate_of_mem (d : ℤ) (hd : d ∈ pellFieldCoverageParameters) :\n    Nonempty (PellFiniteCertificate d (10^275)) := by\n'
    source+='  have he : pellFieldCoverageParameters = '+appended+' := by rfl\n'
    source+='  rw [he] at hd\n  simp only [List.mem_append] at hd\n'
    source+='  rcases hd with '+' | '.join('h'+str(i) for i in range(16))+'\n'
    source+=''.join('  · exact '+name+' d h'+str(i)+'\n' for i,name in enumerate(claims))
    source+='\nprivate theorem transfer_coverage_blocks (b : Fin 25) (r : Fin 50) :\n    PellFieldCoverageLightAt (50*b.val+r.val) := by\n  fin_cases b\n'
    source+='  · exact '+light00+' r\n'
    source+=''.join('  · exact '+name+' r\n' for name in blocks)
    source+='\nprivate theorem transfer_coverage_all (k : Fin 1250) : PellFieldCoverageLightAt k.val := by\n'
    source+='  let b : Fin 25 := ⟨k.val/50, by omega⟩\n  let r : Fin 50 := ⟨k.val%50, Nat.mod_lt _ (by decide)⟩\n'
    source+='  have h := transfer_coverage_blocks b r\n  have he : 50*b.val+r.val = k.val := by\n    dsimp [b,r]\n    omega\n  simpa only [he] using h\n'
    source+='\ntheorem _root_.solution (d : ℤ) (hd : 7 ≤ d) (hupper : d < 10000)\n    (hmod : d % 8 = 7) (hsq : Squarefree d) :\n    Nonempty (PellFiniteCertificate d (10^275)) := by\n'
    source+='  have hk0 : 0 ≤ d/8 := by omega\n  have hklt : (d/8).toNat < 1250 := by omega\n'
    source+='  let k : Fin 1250 := ⟨(d/8).toNat,hklt⟩\n  have heq : 7+8*(k.val : ℤ) = d := by dsimp [k]; omega\n'
    source+='  have hc := transfer_coverage_all k\n  dsimp only [PellFieldCoverageLightAt] at hc\n'
    source+='  change 7+8*(k.val : ℤ) ∈ pellFieldCoverageParameters ∨ (2 ≤ pellFieldCoverageFactors.getD k.val 0 ∧ (pellFieldCoverageFactors.getD k.val 0)*(pellFieldCoverageFactors.getD k.val 0) ∣ 7+8*(k.val : ℤ)) at hc\n'
    source+='  rw [heq] at hc\n  rcases hc with hmem | hbad\n  · exact transfer_certificate_of_mem d hmem\n'
    source+='  · have hu : IsUnit (pellFieldCoverageFactors.getD k.val 0) := hsq _ hbad.2\n    have hh := Int.isUnit_iff.mp hu\n    omega\n'+ending
    root['solution']='Solutions/pellFiniteCertificate_exists_logical_closure.lean'
    atomic_bytes(out/root['solution'],source.encode())
    root['solution_sha256']=hashlib.sha256(source.encode()).hexdigest()
    root['proof_dependencies']=[n for n,k in proof_deps]
    root['explanation']='The original target is proved from 16 separately checked certificate-existence statements and the original light numerical coverage blocks. Each certificate block imports only its own table slice. The final proof imports their theorem statements, never the combined proof-valued certificate data.'
    assert root['payload']==ns[EXISTS]['payload']
    created.append(root)
    all_created={n['name'] for n in created}
    required={EXISTS}|{d for n in created for key in ['publish_dependencies','proof_dependencies'] for d in n[key] if d not in all_created}
    assert all(state['entries'][n].get('theorem_id') for n in required)
    existing=[{'name':n,'kind':state['entries'][n]['kind'],'id':state['entries'][n]['theorem_id']} for n in sorted(required)]
    manifest={'schema':'p2m-proof-level-pell-closure-v1','private':True,'env':environment,'ready_for_upload':True,'nodes':created,'existing':existing}
    validate(manifest,out)
    assert all('sorry' not in (out/n['solution']).read_text() for n in created)
    atomic_bytes(out/'MANIFEST.json',encoded(manifest))
    atomic_bytes(out/'PREPARATION.json',encoded({'new_theorems':17,'existing_target':EXISTS,
        'target_id':state['entries'][EXISTS]['theorem_id'],'target_payload_unchanged':True,
        'certificate_parameters':1016,'exact_original_parameter_order':True,
        'final_proof_imports_only_light_data_and_theorem_statements':True,
        'original_mathematical_source_files_modified':0,'status':'PREPARED_NOT_YET_PLATFORM_VERIFIED'}))
    print(json.dumps({'status':'LOGICAL_CLOSURE_PREPARED','new_theorems':17,'existing_target_id':state['entries'][EXISTS]['theorem_id'],
                      'existing_bindings':len(existing),'root_proof_bytes':len(source.encode())}),flush=True)
if __name__=='__main__':main()
