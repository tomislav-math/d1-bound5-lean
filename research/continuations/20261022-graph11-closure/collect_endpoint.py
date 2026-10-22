"""Collect seven completed graph11 audits; write only two new endpoint records.

This script never launches a compiler, kernel replay, Git, or a queue mutation.
Committed provenance is inherited from the exact, preserved scoped records;
this collector rechecks their present bytes and current driver acceptance.
"""
from pathlib import Path
from datetime import datetime, timezone
import fcntl
import hashlib
import importlib.util
import json
import re
import sys


R = Path('/Users/tp/Lean/D1Bound5')
C = R / 'research/continuations'
W = C / '20261018T010800CEST-main-continuation'
U = C / '20261020T100000CEST-work-resume'
O = Path(__file__).resolve().parent
DRIVER = W / 'continuation_driver_capacity.py'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
RUNNER = U / 'bound_scoped_audit_runner_proposal_v1.py'
RUNNER_SHA = 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
ENDPOINT = 'SmallPairGraphData11'
RAW = 'SmallPairRawSelectedData11'
MERGED_SHA = 'cbc22344517903c3e7535596ee1b5d90d53228850899448677697d997639c17d'
MERGED_BYTES = 2199314
ASSURANCE = 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
RAW_GROUPS = {
    RAW + 'LeftCached': ['leftCached'], RAW + 'LeftRows': ['leftRows'],
    RAW + 'RightCached': ['rightCached'], RAW + 'RightRows': ['rightRows'],
}
ORIGINALS = ['SmallPairGraphInputs11', 'SmallPairGraphArithmetic11',
             'SmallPairGraphWitnessData11', 'SmallPairGraphClosure11', RAW,
             'SmallPairLightAssembly11', 'SmallPairGraphTriangle11', ENDPOINT]
CHUNKS = ['SmallPairGraphClosure11Chunk' + f'{i:02d}' for i in range(12)]
COVERAGE = 'SmallPairGraphClosure11Coverage'
HELPERS = CHUNKS + [COVERAGE]
FOUNDATION = ['SmallPairLightData11Left', 'SmallPairLightData11LeftRows',
              'SmallPairLightData11Right', 'SmallPairLightData11RightRows',
              'SmallPairLightData11', 'SmallPairLightAdaptiveData11',
              'SmallPairLightAdaptiveValidation11']
SIDE_PILOTS = ['SmallPairLightAdaptiveLeft11_000Part00',
               'SmallPairLightAdaptiveRight11_000Part00']


def side_rest(side):
    prefix = 'SmallPairLightAdaptive' + side + '11_'
    return ([prefix + '000Part' + f'{i:02d}' for i in range(1, 6)]
            + [prefix + '000'] + [prefix + '001Part' + f'{i:02d}' for i in range(4)]
            + [prefix + '001', 'SmallPairLight' + side + '11'])


CLOSURE_CORE = ['SmallPairGraphInputs11', 'SmallPairGraphWitnessData11'] + HELPERS + ['SmallPairGraphClosure11']
ASSEMBLY = ['SmallPairGraphArithmetic11'] + list(RAW_GROUPS) + [RAW,
            'SmallPairLightAssembly11', 'SmallPairGraphTriangle11', ENDPOINT]
SCOPES = [
    ('20261022-graph11-foundation', 'foundation', FOUNDATION, 19, 4, 'GRAPH11_FOUNDATION_AXIOMS_PASS '),
    ('20261022-graph11-sides', 'sides-pilot', SIDE_PILOTS, 0, 2, 'GRAPH11_SIDES_AXIOMS_PASS '),
    ('20261022-graph11-sides', 'left-rest', side_rest('Left'), 0, 15, 'GRAPH11_SIDES_AXIOMS_PASS '),
    ('20261022-graph11-sides', 'right-rest', side_rest('Right'), 0, 15, 'GRAPH11_SIDES_AXIOMS_PASS '),
    ('20261022-graph11-closure', 'closure-pilot',
     ['SmallPairGraphInputs11', 'SmallPairGraphWitnessData11', CHUNKS[0], COVERAGE], 9, 2, 'GRAPH11_CLOSURE_AXIOMS_PASS '),
    ('20261022-graph11-closure', 'closure-rest', CHUNKS[1:] + ['SmallPairGraphClosure11'], 0, 13, 'GRAPH11_CLOSURE_AXIOMS_PASS '),
    ('20261022-graph11-closure', 'assembly', ASSEMBLY, 4, 13, 'GRAPH11_CLOSURE_AXIOMS_PASS '),
]
EXPECTED_TOTALS = {'definitions': 32, 'theorems': 64, 'declarations': 96,
                   'guarded_builds': 58, 'targeted_same_kernel_replays': 58,
                   'analytic_type_axiom_audits': 7}


def load(path):
    return json.loads(Path(path).read_text())


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def digest(data):
    return hashlib.sha256(data).hexdigest()


def fingerprint(value):
    return digest(json.dumps(value, sort_keys=True, separators=(',', ':')).encode())


def relative(value):
    path = Path(value)
    assert not path.is_absolute() and '..' not in path.parts
    return path


def repo_file(value):
    path = Path(value)
    if not path.is_absolute():
        path = R / relative(value)
    assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(R.resolve())
    return path


def merge(destination, values):
    for key, value in values.items():
        assert re.fullmatch(r'[0-9a-f]{64}', value), key
        assert key not in destination or destination[key] == value, key
        destination[key] = value


def protect(files, path, expected=None):
    path = repo_file(path)
    actual = sha(path)
    assert expected is None or actual == expected, str(path)
    merge(files, {str(path.relative_to(R)): actual})
    return path


def declarations(text):
    result = []
    matches = list(re.finditer(r'^(def|theorem)\s+(\S+)\s*(.*?)\s*:=', text, re.M | re.S))
    for index, match in enumerate(matches):
        stack, opens = [], []
        for line in text[:match.start()].splitlines():
            if line.startswith('namespace '):
                stack.append(line[10:].strip())
            elif line.startswith('end '):
                assert stack
                stack.pop()
            elif line.startswith('open '):
                opens.append(line)
        namespace = '.'.join(stack)
        assert namespace.startswith('D1Bound5')
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        close = re.search(r'^end(?:\s|$)', text[match.end():end], re.M)
        if close:
            end = match.end() + close.start()
        result.append({'kind': match[1], 'local_name': match[2], 'name': namespace + '.' + match[2],
                       'namespace': namespace, 'opens': list(dict.fromkeys(opens)),
                       'header': match[3].strip(), 'raw_header': text[match.start():match.end() - 2],
                       'source_text': text[match.start():end]})
    return result


def headers(text):
    return [item['raw_header'] for item in declarations(text)]


def body(text):
    return re.sub(r'^import [^\n]*(?:\n|$)', '', text, flags=re.M).strip()


def literal_count(text, name):
    match = re.search(r'^def ' + re.escape(name) + r'\b.*?:=\s*\[\n(.*?)\n\]', text, re.M | re.S)
    assert match, name
    return len([line for line in match[1].splitlines() if line.strip()])


def verify_restored_sources(files, targets):
    """Recheck the original merged source, exact relocation, and closure boundaries."""
    installation = load(protect(files, O / 'INSTALL_BINDING.json'))
    plan = load(protect(files, O / 'PLAN.json'))
    origins = load(protect(files, O / 'DECLARATION_ORIGINS.json'))
    assert origins == plan['origins']
    assert plan['build_order'] == CLOSURE_CORE + ASSEMBLY
    assert set(plan['source_manifest']) == set(origins) == set(CLOSURE_CORE + ASSEMBLY)
    assert set(plan['source_manifest']) <= set(targets)
    assert installation['original_merged_sha256'] == plan['original_merged_sha256'] == MERGED_SHA
    assert installation['original_merged_bytes'] == MERGED_BYTES
    expected_originals = installation['original_module_sha256']
    assert expected_originals == plan['original_source_manifest'] and set(expected_originals) == set(ORIGINALS)
    assert set(plan['reviewed_helper_source_manifest']) == set(HELPERS)
    before = protect(files, O / 'installation' / (ENDPOINT + '.before.lean'), MERGED_SHA)
    assert before.stat().st_size == MERGED_BYTES
    merged = before.read_text()
    markers = list(re.finditer(
        r'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n', merged, re.M))
    assert len(markers) == 8 and {match[1] for match in markers} == set(ORIGINALS)
    originals, public = {}, []
    for index, match in enumerate(markers):
        name = match[1]
        path = protect(files, O / 'originals' / (name + '.lean'), expected_originals[name])
        assert sha(path) == match[2]
        originals[name] = path.read_bytes()
        end = markers[index + 1].start() if index + 1 < len(markers) else len(merged)
        assert body(originals[name].decode()) == merged[match.end():end].strip()
        public.extend(headers(originals[name].decode()))
    assert public == headers(merged) == plan['original_public_headers']
    assert len(public) == plan['original_public_declarations'] == 28
    assert sum(' '.join(header.split()) == 'theorem smallPairLarge_11_count : smallPairLarge_11.length = 718'
               for header in public) == 1

    raw = originals[RAW]
    matches = list(re.finditer(rb'^def (\w+)\s*:', raw, re.M))
    wanted = [name for names in RAW_GROUPS.values() for name in names]
    assert [match[1].decode() for match in matches] == wanted
    prefix = raw[:matches[0].start()]
    namespaces = re.findall(rb'^namespace (\S+)\s*$', prefix, re.M)
    assert len(namespaces) == 1 and namespaces[0].startswith(b'D1Bound5.')
    namespace = namespaces[0]
    endings = list(re.finditer(rb'^end ' + re.escape(namespace) + rb'\s*$', raw, re.M))
    assert len(endings) == 1 and endings[0].start() > matches[-1].start()
    end = endings[0].start()
    suffix = raw[end:]
    assert suffix.strip() == b'end ' + namespace
    blocks = {match[1].decode(): raw[match.start():matches[i + 1].start() if i + 1 < len(matches) else end]
              for i, match in enumerate(matches)}
    assert prefix + b''.join(blocks.values()) + suffix == raw
    partition = plan['raw_literal_partition']
    assert partition['original_module'] == RAW and partition['groups'] == RAW_GROUPS
    assert partition['namespace'] == namespace.decode()
    assert partition['definition_sha256'] == {name: digest(data) for name, data in blocks.items()}
    assert partition['prefix_sha256'] == digest(prefix) and partition['suffix_sha256'] == digest(suffix)
    assert partition['exact_byte_reconstruction'] and partition['original_imports_preserved_in_each_data_module']

    for name in HELPERS:
        path = protect(files, O / 'originals' / (name + '.lean'), plan['reviewed_helper_source_manifest'][name])
        originals[name] = path.read_bytes()
    assigned = {name: [] for name in originals}
    all_declarations = []
    for name in plan['build_order']:
        candidate = protect(files, O / 'candidates' / (name + '.lean'), plan['source_manifest'][name])
        current = repo_file('D1Bound5/' + name + '.lean')
        data = candidate.read_bytes()
        assert sha(current) == sha(candidate) and current.read_bytes() == data
        origin = RAW if name in RAW_GROUPS or name == RAW else name
        names = RAW_GROUPS[name] if name in RAW_GROUPS else [] if name == RAW else [
            item['local_name'] for item in declarations(originals[name].decode())]
        mode = ('exact_declaration_source' if name in RAW_GROUPS else 'imports_only_wrapper' if name == RAW else
                'original_headers_only' if name == 'SmallPairGraphClosure11' else
                'new_reviewed_helper' if name in HELPERS else 'exact_module_bytes')
        assert origins[name] == {'original_module': origin, 'names': names, 'preservation': mode}
        assigned[origin].extend(names)
        if name in RAW_GROUPS:
            assert data == prefix + b''.join(blocks[item] for item in names) + suffix
        elif name == RAW:
            assert data == ''.join('import D1Bound5.' + item + '\n' for item in RAW_GROUPS).encode()
        elif name == 'SmallPairGraphClosure11':
            old, new = originals[name].decode(), data.decode()
            old_decl, new_decl = declarations(old), declarations(new)
            assert len(old_decl) == len(new_decl) == 2 and headers(old) == headers(new)
            assert body(old[:old.index('theorem ')]) == body(new[:new.index('theorem ')])
            assert old[old.index('theorem smallPairClosure_11_checked'):] == new[new.index('theorem smallPairClosure_11_checked'):]
        else:
            assert data == originals[name]
        assert not re.search(rb'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b', data), name
        all_declarations.extend(declarations(data.decode()))
    for name, names in assigned.items():
        assert names == [item['local_name'] for item in declarations(originals[name].decode())]
    assert len(all_declarations) == len({item['name'] for item in all_declarations}) == 41
    assert sum(item['kind'] == 'def' for item in all_declarations) == 13
    assert sum(item['kind'] == 'theorem' for item in all_declarations) == 28

    for name, declaration, count in [('SmallPairGraphInputs11', 'smallPairClosure_11', 719),
                                      ('SmallPairGraphInputs11', 'smallPairLarge_11', 718),
                                      ('SmallPairGraphWitnessData11', 'rootPairs', 719),
                                      ('SmallPairGraphWitnessData11', 'destinations', 719)]:
        assert literal_count((R / 'D1Bound5' / (name + '.lean')).read_text(), declaration) == count
    expected_parts = [{'module': name, 'offset': 64 * index, 'count': 64 if index < 11 else 15}
                      for index, name in enumerate(CHUNKS)]
    assert plan['prefix_parts'] == expected_parts
    assert [i for part in expected_parts for i in range(part['offset'], part['offset'] + part['count'])] == list(range(719))
    for part in expected_parts:
        item = declarations((R / 'D1Bound5' / (part['module'] + '.lean')).read_text())
        assert len(item) == 1
        expected = ('pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot '
                    '(10^1100) smallPairClosure_11 ' + str(part['count']) +
                    ' (witnesses.drop ' + str(part['offset']) + ') (destinations.drop ' + str(part['offset']) + ') = true')
        assert ' '.join(item[0]['header'].lstrip(':').split()) == expected
    assert plan['closure_rows'] == 719 and plan['filtered_vertices'] == 718
    assert plan['root_integration'] is False and plan['main_theorem_complete'] is False
    protect(files, R / 'D1Bound5.lean', plan['canonical_root_sha256'])
    return public, plan['canonical_root_sha256']


def write_new(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


def main():
    assert O == C / '20261022-graph11-closure'
    assert len(sys.argv) == 1
    outputs = [O / 'ENDPOINT_PROOF_STATE.json', O / 'ENDPOINT_VERIFICATION.json']
    assert all(not path.exists() and not path.is_symlink() for path in outputs)
    assert sha(DRIVER) == DRIVER_SHA and sha(RUNNER) == RUNNER_SHA
    spec = importlib.util.spec_from_file_location('graph11_endpoint_collection_driver', DRIVER)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        driver = module.Driver(R, W)
        runtime = {str(path): sha(path) for path in [driver.queue_path, driver.active_path,
                                                   driver.state_path, driver.baseline_path]}
        active = load(driver.active_path)
        assert not active.get('active') and not active.get('protected_closure')
        queue, _, closures, accepted, _, _ = driver.snapshot()
        assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        latest = driver.latest()
        targets, declaration_names = [], []
        source_guards, artifact_guards, file_guards, scope_evidence = {}, {}, {}, {}
        protect(file_guards, DRIVER, DRIVER_SHA)
        protect(file_guards, RUNNER, RUNNER_SHA)
        protect(file_guards, __file__)
        totals = {key: 0 for key in EXPECTED_TOTALS}
        for unit, scope, expected_targets, definitions, theorems, marker in SCOPES:
            folder = C / unit
            summary_path = protect(file_guards, folder / (scope + '-VERIFICATION_SUMMARY.json'))
            summary = load(summary_path)
            assert summary['status'] == 'SCOPED_VERIFICATION_PASS' and summary['public_headers_exact'] is True
            assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
            assert summary['whole_graph11_complete'] is False
            unit_targets = summary['targets']
            assert unit_targets == expected_targets == load(protect(file_guards, folder / (scope + '-TARGETS.json')))
            assert len(unit_targets) == len(set(unit_targets)) and not set(targets) & set(unit_targets)
            targets.extend(unit_targets)
            unit_plan = load(protect(file_guards, folder / 'PLAN.json'))
            assert set(unit_targets) <= set(unit_plan['source_manifest'])
            audit = R / relative(summary['audit'])
            assert audit == U / ('pro-graph11-' + scope + '-audit')
            assert not load(protect(file_guards, audit / 'active-targeted-replay.json'))['active']
            final = load(protect(file_guards, audit / 'BOUND_AUDIT_FINAL.json'))
            receipts = load(protect(file_guards, audit / 'TARGETED_REPLAY_RECEIPTS.json'))
            assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
            assert final['main_theorem_claim'] is False
            assert [row['label'] for row in receipts] == ['analytic-type-axioms'] + [name + '-targeted-replay' for name in unit_targets]
            assert all(row['exit'] == 0 and not row['timed_out'] and row['guards_unchanged']
                       and not row['binding_drift_paths'] for row in receipts)
            for row in receipts:
                log = relative(row['log'])
                assert len(log.parts) == 1
                protect(file_guards, audit / log)
            assert (audit / 'analytic-type-axioms.log').read_text().count(marker) == definitions + theorems
            binding_path = protect(file_guards, audit / 'PREPARATION_BINDINGS.json', final['binding_sha256'])
            binding = load(binding_path)
            assert binding['schema'] == 1 and binding['audit_folder'] == str(audit.resolve())
            assert binding['targets'] == binding['replays'] == unit_targets
            assert load(audit / 'TARGETS.json') == load(audit / 'REPLAY_TARGETS.json') == unit_targets
            assert final['source_map_sha256'] == sha(audit / 'SOURCE_MAP.json')
            for path, value in binding['files'].items():
                protect(file_guards, path, value)
            records = load(audit / 'SCOPED_ORIGINAL_DECLARATIONS.json')
            assert [record['module'] for record in records] == unit_targets
            actual_declarations = []
            for name, record in zip(unit_targets, records):
                current = repo_file('D1Bound5/' + name + '.lean')
                protect(file_guards, folder / 'candidates' / (name + '.lean'), unit_plan['source_manifest'][name])
                assert sha(current) == unit_plan['source_manifest'][name] == record['current_sha256']
                protect(file_guards, record['original_path'], record['original_sha256'])
                if 'origin_map_path' in record:
                    protect(file_guards, record['origin_map_path'], record['origin_map_sha256'])
                current_declarations = declarations(current.read_text())
                assert len(current_declarations) == len(record['declarations'])
                for old, new in zip(record['declarations'], current_declarations):
                    assert all(key in new and new[key] == value for key, value in old.items()), name
                actual_declarations.extend(record['declarations'])
            names = [item['name'] for item in actual_declarations]
            assert names == load(audit / 'DECLARATION_NAMES.json') and len(names) == len(set(names))
            assert not set(declaration_names) & set(names)
            declaration_names.extend(names)
            assert sum(item['kind'] == 'def' for item in actual_declarations) == definitions
            assert sum(item['kind'] == 'theorem' for item in actual_declarations) == theorems
            assert summary['definitions'] == definitions and summary['theorems'] == theorems
            assert summary['declarations'] == len(names) == definitions + theorems

            source_map_path = protect(file_guards, folder / (scope + '-SOURCE_MAP.json'))
            evidence_path = protect(file_guards, folder / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'))
            source_map, evidence = load(source_map_path), load(evidence_path)
            sources = source_map['sources']
            assert source_map['base_commit'] == summary['base_commit']
            assert re.fullmatch(r'[0-9a-f]{40}', summary['base_commit'])
            assert set(sources) == set(evidence) and len(sources) == summary['source_closure_modules']
            assert binding['project_sources'] == {name: item['sha256'] for name, item in sources.items()}
            scope_artifacts = {}
            for name, item in sources.items():
                assert item['path'] == 'D1Bound5/' + name + '.lean'
                assert sha(repo_file(item['path'])) == item['sha256'] and name in accepted, name
                closure = driver.closure(name)
                key = module.fingerprint(closure)
                expected = driver.expected_manifest(name, key, latest)
                assert expected and key == evidence[name]['fingerprint'], name
                assert expected == evidence[name]['artifacts'] == driver.artifacts(name), name
                merge(source_guards, {name: item['sha256']})
                merge(scope_artifacts, expected)
                if 'payload_path' in item:
                    protect(file_guards, R / relative(item['payload_path']), item['sha256'])
                else:
                    assert re.fullmatch(r'[0-9a-f]{40}', item['base_commit'])
                    relative(item['base_path'])
                if name in unit_targets:
                    assert item['assurance'] == ASSURANCE
            merge(artifact_guards, scope_artifacts)
            assert all(scope_artifacts.get(path) == value for path, value in binding['target_artifacts'].items())
            configuration = load(protect(file_guards, folder / 'CONFIGURATION.json'))
            assert configuration == driver.static and driver.manifest_matches(configuration, cached=False)
            guards = load(protect(file_guards, audit / 'TARGETED_REPLAY_GUARDS.json'))
            assert guards['project_sources'] == binding['project_sources']
            assert guards['compiled_artifacts'] == scope_artifacts and guards['immutable_inputs'] == configuration
            for path, value in guards['preparation_files'].items():
                protect(file_guards, path, value)
            state_path = protect(file_guards, folder / (scope + '-PROOF_STATE.json'))
            state = load(state_path)
            expected_state = {
                'sources': [[name, item['sha256']] for name, item in sorted(sources.items())],
                'configuration': configuration,
                'build_fingerprints': {name: evidence[name]['fingerprint'] for name in unit_targets},
                'artifact_fingerprints': {name: evidence[name]['artifacts'] for name in unit_targets},
                'audit_harness_sha256': sha(audit / 'AnalyticAudit.lean'),
                'accepted_checks': [{key: row[key] for key in ('label', 'exit', 'guards_unchanged')} for row in receipts],
            }
            assert state == expected_state and fingerprint(state) == summary['proof_fingerprint']
            assert summary['guarded_builds'] == summary['targeted_same_kernel_replays'] == len(unit_targets)
            if 'pilot_reuse_evidence' in summary:
                reuse = load(protect(file_guards, R / relative(summary['pilot_reuse_evidence']), summary['pilot_reuse_evidence_sha256']))
                pilot_path = str((C / '20261022-graph11-sides/sides-pilot-VERIFICATION_SUMMARY.json').relative_to(R))
                assert reuse['summary_path'] == pilot_path and reuse['targets'] == SIDE_PILOTS
                assert reuse['proof_fingerprint'] == scope_evidence[pilot_path]['proof_fingerprint']
                for path, value in reuse['protected_files'].items():
                    protect(file_guards, path, value)
            provenance_used = audit / 'PROVENANCE_BINDING_USED.json'
            if unit == '20261022-graph11-closure':
                used = load(protect(file_guards, provenance_used))
                protect(file_guards, O / 'PROVENANCE_BINDING.json', used['binding_sha256'])
                for path, value in used['source_maps'].items():
                    protect(file_guards, R / relative(path), value)
            protect(file_guards, folder / (scope + '-PREPARATION.json'))
            for key in ('definitions', 'theorems', 'declarations', 'guarded_builds', 'targeted_same_kernel_replays'):
                totals[key] += summary[key]
            totals['analytic_type_axiom_audits'] += 1
            scope_evidence[str(summary_path.relative_to(R))] = {
                'sha256': sha(summary_path), 'proof_fingerprint': summary['proof_fingerprint'],
                'proof_state_sha256': sha(state_path), 'bound_audit_sha256': sha(audit / 'BOUND_AUDIT_FINAL.json'),
                'binding_sha256': sha(binding_path), 'base_commit': summary['base_commit'],
                'targets': unit_targets, 'definitions': definitions, 'theorems': theorems,
            }

        assert len(targets) == len(set(targets)) == 58 and set(targets) <= accepted
        assert len(declaration_names) == len(set(declaration_names)) == 96
        assert totals == EXPECTED_TOTALS and len(scope_evidence) == 7
        endpoint_closure = driver.closure(ENDPOINT)
        assert endpoint_closure == closures[ENDPOINT]
        assert set(endpoint_closure) <= accepted and ENDPOINT in targets
        assert all(source_guards.get(name) == value for name, value in endpoint_closure.items())
        endpoint_key = module.fingerprint(endpoint_closure)
        endpoint_artifacts = driver.expected_manifest(ENDPOINT, endpoint_key, latest)
        assert endpoint_artifacts and driver.artifacts(ENDPOINT) == endpoint_artifacts
        public, root_sha = verify_restored_sources(file_guards, targets)
        assert all(sha(repo_file(path)) == value for path, value in file_guards.items())
        assert all(sha(R / 'D1Bound5' / (name + '.lean')) == value for name, value in source_guards.items())
        assert driver.manifest_matches(artifact_guards, cached=False) and driver.manifest_matches(driver.static, cached=False)
        assert all(sha(path) == value for path, value in runtime.items())
        assert all(not path.exists() and not path.is_symlink() for path in outputs)
        proof_state = {
            'schema': 1, 'module': ENDPOINT, 'targets': targets, 'declaration_names': declaration_names,
            'module_and_check_totals': totals, 'endpoint_source_closure': endpoint_closure,
            'endpoint_build_fingerprint': endpoint_key, 'endpoint_artifacts': endpoint_artifacts,
            'verified_sources': source_guards, 'verified_artifacts': artifact_guards,
            'verified_files': file_guards, 'configuration': driver.static, 'scope_evidence': scope_evidence,
            'original_public_headers_sha256': fingerprint(public), 'canonical_root_sha256': root_sha,
            'closure_rows': 719, 'filtered_vertices': 718, 'model': {'tau': 0, 'nu': 1},
            'whole_graph11_complete': True, 'root_integration': False, 'main_theorem_complete': False,
        }
        result = {
            'schema': 1, 'status': 'GRAPH11_WORKING_ENDPOINT_SCOPED_VERIFIED',
            'utc': datetime.now(timezone.utc).isoformat(), 'module': ENDPOINT,
            'closure_rows': 719, 'filtered_vertices': 718, 'original_public_declarations_preserved': 28,
            'scope_count': 7, 'unique_target_count': 58, 'module_and_check_totals': totals,
            'source_closure_modules': len(endpoint_closure), 'scope_evidence': scope_evidence,
            'proof_fingerprint': fingerprint(proof_state), 'whole_graph11_complete': True,
            'root_integration': False, 'main_theorem_complete': False,
            'publication': 'PREPARED_NOT_YET_PUSHED', 'compiler_run_by_collector': False,
            'git_run_by_collector': False, 'proof_or_queue_mutated_by_collector': False,
        }
        write_new(outputs[0], proof_state)
        result['proof_state_sha256'] = sha(outputs[0])
        write_new(outputs[1], result)
        print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
