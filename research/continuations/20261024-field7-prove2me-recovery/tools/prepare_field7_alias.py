"""Prepare exact Field 7 slices after the renamed publication hit the scanner timeout."""
from pathlib import Path
import copy, hashlib, json, sys
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
import adapt_pell_literals_v5 as splitter
from batch_uploader import validate
from global_uploader import encoded, atomic_bytes

def main():
    recovery = ROOT / 'alias-recovery-20261024'
    old_manifest = json.loads((recovery / 'MANIFEST.json').read_text())
    old_state = json.loads((recovery / 'UPLOAD_STATE.json').read_text())
    old = old_manifest['nodes'][0]
    receipt = old_state['entries'][old['name']]['publish_receipt']
    assert receipt['status'] == 'FAILED'
    assert 'Token scanner timed out after 10s' in receipt['error_message']
    original = copy.deepcopy(old)
    name = 'D1Bound5_PellLightMatchingField7_Definitions_RecoverySplit20261024'
    original['name'] = name
    original['payload']['definition_name'] = name
    original['payload']['definition_title'] = 'Pell Light Matching Field7 — verified data slices'
    original['unit_id'] = 'definition_field7_alias_split_20261024'
    assert original['payload']['definition'] == old['payload']['definition']
    splitter.TARGETS = {name: {'pellMagnitudes_7':'List Int',
                              'pellWitnesses_7':'List (List (Nat × Nat))'}}
    splitter.DIR = 'Definitions/'
    revised, helpers, provenance = splitter.expected(original)
    verification = splitter.verify_adaptation(original, revised, helpers, provenance)
    result_dir = recovery / 'split'
    result_dir.mkdir(exist_ok=True)
    assert not (result_dir / 'UPLOAD_STATE.json').exists()
    manifest = {'schema':'p2m-stalled-definition-sliced-replacement-v1',
                'private':True,'env':old_manifest['env'],'ready_for_upload':True,
                'nodes':list(helpers.values()) + [revised],
                'existing':old_manifest['existing']}
    for node in manifest['nodes']:
        file = result_dir / node['definition_file']
        atomic_bytes(file, node['payload']['definition'].encode())
    validate(manifest, result_dir)
    atomic_bytes(result_dir / 'MANIFEST.json', encoded(manifest))
    atomic_bytes(result_dir / 'PROVENANCE.json', encoded({
        'utc':datetime.now(timezone.utc).isoformat(),
        'old_global_name':'D1Bound5_PellLightMatchingField7_Definitions',
        'new_name':name, 'failed_alias_name':old['name'],
        'source_code_sha256':hashlib.sha256(original['payload']['definition'].encode()).hexdigest(),
        'original_source':original, 'adaptation':provenance, 'verification':verification,
        'reason':'Exact alias failed token scanner. Typed ordered list slices preserve all values; original theorem bodies are unchanged.',
        'global_ledger_unchanged':True}))
    print(json.dumps({'status':'VERIFIED_SLICES_PREPARED','helpers':len(helpers),
                      'main_bytes':len(revised['payload']['definition'].encode()),
                      'max_helper_bytes':max(len(n['payload']['definition'].encode()) for n in helpers.values()),
                      'verification':verification}))
if __name__ == '__main__':
    main()
