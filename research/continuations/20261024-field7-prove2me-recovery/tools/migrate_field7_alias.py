"""Replace one stalled, unpublished definition after its verified alias succeeds.

No platform mutations. Preserve every previous action and successful identity.
Move the old job record into superseded_publications, without cancelling it.
"""
from pathlib import Path
from contextlib import ExitStack
from datetime import datetime, timezone
import argparse, copy, hashlib, json, time

import adapt_pell_literals_v5 as splitter
from batch_uploader import Halt, Uploader, validate
from global_uploader import ReceiptStore, atomic_bytes, encoded
from migrate_manifest import signature
from phase_supervisor import audit, locked

ROOT = Path(__file__).resolve().parent
OLD = 'D1Bound5_PellLightMatchingField7_Definitions'
NEW = OLD + '_RecoverySplit20261024'
CONSUMER = 'D1Bound5_PellLightAllMatchingCertificates_Definitions_001'

def require(condition, message):
    if not condition:
        raise Halt(message)

def convert_receipts(value, source, destination):
    if isinstance(value, list):
        return [convert_receipts(v, source, destination) for v in value]
    if isinstance(value, dict):
        if set(value) == {'path','sha256','bytes'}:
            return destination.put(convert_receipts(source.get(value), source, destination))
        return {k:convert_receipts(v, source, destination) for k,v in value.items()}
    return value

def main(apply=False):
    state_path = ROOT / 'GLOBAL_UPLOAD_STATE.json'
    old_path = ROOT / 'full-payloads/MANIFEST_PELL_V9_FINAL.json'
    new_path = ROOT / 'full-payloads/MANIFEST_FIELD7_RECOVERY_V10.json'
    alias_dir = ROOT / 'alias-recovery-20261024/split'
    alias_state_path = alias_dir / 'UPLOAD_STATE.json'
    with ExitStack() as stack:
        for path in [str(state_path)+'.supervisor.lock', str(state_path)+'.lock',
                     str(alias_state_path)+'.lock']:
            stack.enter_context(locked(path))
        state_raw = state_path.read_bytes()
        state = json.loads(state_raw)
        old_manifest = json.loads(old_path.read_text())
        old_nodes, old_existing = validate(old_manifest, old_path.parent)
        alias_manifest = json.loads((alias_dir/'MANIFEST.json').read_text())
        aliases, alias_existing = validate(alias_manifest, alias_dir)
        alias_state = json.loads(alias_state_path.read_text())
        provenance = json.loads((alias_dir/'PROVENANCE.json').read_text())
        require(all(x.get('private') is True and x.get('env') == state['env']
                    for x in [state,old_manifest,alias_manifest,alias_state]), 'Privacy/environment mismatch')
        require(OLD in state['entries'] and NEW not in state['entries'], 'Already migrated or unexpected ledger')
        require(all(a.get('stage')=='recorded' for s in [state,alias_state]
                    for a in s['actions'].values()), 'Unresolved mutation action')
        require(all(state['entries'][n].get('manifest_sha256') == signature(node)
                    for n,node in old_nodes.items()), 'Source manifest/ledger mismatch')
        old_entry = state['entries'][OLD]
        require(old_entry.get('publish_status') == 'COMPILING'
                and not old_entry.get('theorem_id') and not old_entry.get('submission_id'),
                'Old job is no longer the expected stalled unpublished definition')
        require(all(not Uploader.is_active(e) for n,e in state['entries'].items() if n != OLD),
                'Another global job is active')
        require(not (set(aliases) & set(state['entries'])), 'Replacement node collision')
        require(all(alias_state['entries'][n].get('publish_status')=='PUBLISHED'
                    and alias_state['entries'][n].get('theorem_id') for n in aliases),
                'Replacement and every helper must have succeeded')
        require(all(not Uploader.is_active(e) for e in alias_state['entries'].values()),
                'Replacement uploader has pending jobs')
        for n,binding in alias_existing.items():
            require(state['entries'][n].get('theorem_id') == binding['id'], 'Dependency identity mismatch')
        source = provenance['original_source']
        require(source['name']==NEW and source['payload']['definition']==old_nodes[OLD]['payload']['definition'],
                'Replacement is not derived from the exact original code')
        splitter.TARGETS = {NEW:{'pellMagnitudes_7':'List Int','pellWitnesses_7':'List (List (Nat × Nat))'}}
        splitter.DIR = 'Definitions/'
        verification = splitter.verify_adaptation(source, aliases[NEW], aliases, provenance['adaptation'])
        require(set(aliases)==set(verification['helper_names'])|{NEW}, 'Unexpected replacement helpers')
        source_store = ReceiptStore(alias_state_path)
        for n,node in aliases.items():
            e = alias_state['entries'][n]
            require(e.get('manifest_sha256')==signature(node), 'Replacement ledger signature mismatch')
            receipt = source_store.get(e['publish_receipt'])
            require(receipt.get('status')=='PUBLISHED'
                    and receipt.get('theorem_id')==e['theorem_id']
                    and receipt.get('theorem_name')==n
                    and receipt.get('visibility')=='private'
                    and receipt.get('definitions')==node['payload']['definition'],
                    'Replacement publication receipt mismatch: '+n)
        consumer = copy.deepcopy(old_nodes[CONSUMER])
        ce = state['entries'][CONSUMER]
        require(not any(ce.get(k) for k in ['job_id','submission_id','theorem_id','publish_status']),
                'Consumer was already submitted')
        require(not any(CONSUMER in a.get('names',[]) for a in state['actions'].values()),
                'Consumer has mutation history')
        old_import = 'import Definitions.Def_'+OLD+'\n'
        new_import = 'import Definitions.Def_'+NEW+'\n'
        body = consumer['payload']['definition']
        require(body.count(old_import)==1, 'Unexpected consumer import')
        consumer['payload']['definition'] = body.replace(old_import,new_import)
        for key in ['publish_dependencies','proof_dependencies']:
            require(consumer[key].count(OLD)==1, 'Unexpected consumer dependency')
            consumer[key] = [NEW if d==OLD else d for d in consumer[key]]
        consumer['definition_file'] = 'adaptations/field7-recovery-v10/Def_'+CONSUMER+'.lean'
        consumer['definition_sha256'] = hashlib.sha256(consumer['payload']['definition'].encode()).hexdigest()
        new_manifest = copy.deepcopy(old_manifest)
        prepared_aliases = []
        for node in alias_manifest['nodes']:
            node = copy.deepcopy(node)
            node['definition_file'] = 'adaptations/field7-recovery-v10/'+node['definition_file']
            prepared_aliases.append(node)
        new_manifest['nodes'] = prepared_aliases + [
            consumer if n['name']==CONSUMER else n for n in old_manifest['nodes'] if n['name'] != OLD]
        for node in new_manifest['nodes']:
            require(OLD not in node.get('publish_dependencies',[])+node.get('proof_dependencies',[]),
                    'Old dependency survives')
            require(old_import not in node['payload'].get('definition',node['payload'].get('preamble','')),
                    'Old import survives')
            if node.get('solution'):
                path = Path(node['solution'])
                if not path.is_absolute(): path = old_path.parent/path
                require(old_import not in path.read_text(), 'An existing proof imports old module')
        for node in prepared_aliases+[consumer]:
            atomic_bytes(old_path.parent/node['definition_file'],node['payload']['definition'].encode())
        new_nodes, new_existing = validate(new_manifest, old_path.parent)
        require(old_existing==new_existing, 'Existing platform bindings changed')
        for n in old_nodes.keys()-{OLD,CONSUMER}:
            require(old_nodes[n]==new_nodes[n], 'An unrelated node changed: '+n)
        atomic_bytes(new_path,encoded(new_manifest))
        store = ReceiptStore(state_path)
        converted_alias = convert_receipts(alias_state, source_store, store)
        revised = copy.deepcopy(state)
        del revised['entries'][OLD]
        revised['entries'][CONSUMER]['manifest_sha256'] = signature(new_nodes[CONSUMER])
        for n in aliases:
            revised['entries'][n] = copy.deepcopy(converted_alias['entries'][n])
            require(revised['entries'][n]['manifest_sha256']==signature(new_nodes[n]),
                    'Replacement signature changed while moving source files')
        require(not (set(state['actions']) & set(alias_state['actions'])), 'Action ID collision')
        revised['actions'].update(converted_alias['actions'])
        revised.setdefault('superseded_publications',{})[OLD] = {
            'entry':copy.deepcopy(old_entry),'replacement_name':NEW,
            'server_job_cancelled':False,
            'reason':'Author requested replacement of stalled job; published replacement verified before rerouting.'}
        require(all(revised['entries'][n]==e for n,e in state['entries'].items() if n not in {OLD,CONSUMER}),
                'An unrelated ledger entry changed')
        require(all(revised['actions'][k]==v for k,v in state['actions'].items()), 'Existing action changed')
        report = {
            'schema':'p2m-stalled-alias-replacement-v1',
            'utc':datetime.now(timezone.utc).isoformat(),'old_name':OLD,'new_name':NEW,
            'old_manifest_path':str(old_path),'new_manifest_path':str(new_path),
            'old_manifest_sha256':hashlib.sha256(old_path.read_bytes()).hexdigest(),
            'new_manifest_sha256':hashlib.sha256(new_path.read_bytes()).hexdigest(),
            'state_before_sha256':hashlib.sha256(state_raw).hexdigest(),
            'old_state_receipt':store.put(state),'alias_state_receipt':store.put(converted_alias),
            'verified_provenance_receipt':store.put(provenance),
            'redirected_consumers':[CONSUMER], 'preserved_entry_count':len(state['entries'])-2,
            'replacement_definition_id':revised['entries'][NEW]['theorem_id'],
            'old_job_id':old_entry['job_id'],'old_server_job_cancelled':False,
            'helper_count':len(aliases)-1,'exact_ordered_data_preserved':True,
            'original_lean_source_files_modified':0}
        revised.setdefault('alias_recoveries',[]).append(store.put(report))
        revised['updated_unix'] = time.time()
        candidate = ROOT/'alias-recovery-20261024/migration-validation/GLOBAL_UPLOAD_STATE.json'
        candidate.parent.mkdir(exist_ok=True)
        receipt_link = Path(str(candidate)+'.receipts')
        if not receipt_link.exists():
            receipt_link.symlink_to(store.directory, target_is_directory=True)
        require(receipt_link.resolve()==store.directory.resolve(), 'Unexpected audit receipt location')
        atomic_bytes(candidate,encoded(revised))
        _, verified = audit(new_path,candidate,{},100)
        require(state_path.read_bytes()==state_raw, 'Live ledger changed during migration')
        if apply:
            atomic_bytes(state_path,candidate.read_bytes())
            require(state_path.read_bytes()==candidate.read_bytes(), 'Committed state differs from audited state')
        result = {'mode':'APPLIED' if apply else 'DRY_RUN',
                  'manifest':str(new_path),'registered':verified['registered'],
                  'entries':verified['entries'],'active':verified['active'],
                  'verified_receipts':verified['verified_receipts'],
                  'redirected_consumers':[CONSUMER],'helpers':len(aliases)-1,
                  'preserved_entries':report['preserved_entry_count'],
                  'old_job_preserved_as_superseded':old_entry['job_id']}
        atomic_bytes(ROOT/'alias-recovery-20261024/MIGRATION_RESULT.json',encoded(result))
        print(json.dumps(result),flush=True)

if __name__ == '__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply',action='store_true')
    main(parser.parse_args().apply)
