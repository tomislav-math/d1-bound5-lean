"""Bind graph11 closure scopes to exact original declarations and source provenance."""
from pathlib import Path
import fcntl, hashlib, importlib.util, json, re, subprocess, sys

R = Path('/Users/tp/Lean/D1Bound5')
C = R / 'research/continuations'
W = C / '20261018T010800CEST-main-continuation'
U = C / '20261020T100000CEST-work-resume'
O = Path(__file__).resolve().parent
RAW = 'SmallPairRawSelectedData11'
RAW_GROUPS = {
    RAW + 'LeftCached': ['leftCached'], RAW + 'LeftRows': ['leftRows'],
    RAW + 'RightCached': ['rightCached'], RAW + 'RightRows': ['rightRows'],
}
ORIGINALS = {'SmallPairGraphInputs11', 'SmallPairGraphArithmetic11',
             'SmallPairGraphWitnessData11', 'SmallPairGraphClosure11', RAW,
             'SmallPairLightAssembly11', 'SmallPairGraphTriangle11', 'SmallPairGraphData11'}
HELPERS = ['SmallPairGraphClosure11Chunk' + f'{i:02d}' for i in range(12)] + ['SmallPairGraphClosure11Coverage']
SCOPES = {
    'closure-pilot': ['SmallPairGraphInputs11', 'SmallPairGraphWitnessData11', HELPERS[0], HELPERS[-1]],
    'closure-rest': HELPERS[1:12] + ['SmallPairGraphClosure11'],
    'assembly': ['SmallPairGraphArithmetic11'] + list(RAW_GROUPS) + [RAW,
                 'SmallPairLightAssembly11', 'SmallPairGraphTriangle11', 'SmallPairGraphData11'],
}
COUNTS = {'closure-pilot': (9, 2), 'closure-rest': (0, 13), 'assembly': (4, 13)}


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def load(path):
    return json.loads(Path(path).read_text())


def put(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


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


def public_record(declaration):
    return {key: value for key, value in declaration.items() if key != 'source_text'}


def check_origins(plan):
    """Partition every original declaration once; preserve relocated raw bodies exactly."""
    origins_path = O / 'DECLARATION_ORIGINS.json'
    origins = load(origins_path)
    assert origins == plan['origins']
    all_targets = {name for group in SCOPES.values() for name in group}
    assert len(all_targets) == 25 and set(origins) == set(plan['source_manifest']) == all_targets
    assert len(plan['build_order']) == 25 and set(plan['build_order']) == all_targets
    original_manifest = plan['original_source_manifest']
    helper_manifest = plan['reviewed_helper_source_manifest']
    assert set(original_manifest) == ORIGINALS and set(helper_manifest) == set(HELPERS)
    assert len(helper_manifest) == 13 and plan['original_public_declarations'] == 28
    assert plan['closure_rows'] == 719 and plan['filtered_vertices'] == 718
    assert plan['root_integration'] is False and plan['main_theorem_complete'] is False
    partition = plan['raw_literal_partition']
    assert partition['original_module'] == RAW and partition['groups'] == RAW_GROUPS
    assert partition['exact_byte_reconstruction'] and partition['original_imports_preserved_in_each_data_module']
    manifests = {**original_manifest, **helper_manifest}
    raw = {}
    for name, digest in manifests.items():
        path = O / 'originals' / (name + '.lean')
        assert path.is_file() and not path.is_symlink() and sha(path) == digest, name
        raw[name] = declarations(path.read_text())
        assert len(raw[name]) == len({item['local_name'] for item in raw[name]})
    original_declarations = [item for name in ORIGINALS for item in raw[name]]
    assert len(original_declarations) == 28
    assert sorted(item['raw_header'] for item in original_declarations) == sorted(plan['original_public_headers'])
    selected, assigned = {}, {name: [] for name in manifests}
    for name in plan['build_order']:
        origin = origins[name]
        expected_origin = RAW if name in RAW_GROUPS or name == RAW else name
        expected_mode = ('exact_declaration_source' if name in RAW_GROUPS else
                         'imports_only_wrapper' if name == RAW else
                         'original_headers_only' if name == 'SmallPairGraphClosure11' else
                         'new_reviewed_helper' if name in HELPERS else 'exact_module_bytes')
        expected_names = (RAW_GROUPS[name] if name in RAW_GROUPS else [] if name == RAW else
                          [item['local_name'] for item in raw[expected_origin]])
        assert origin == {'original_module': expected_origin, 'names': expected_names,
                          'preservation': expected_mode}, name
        available = {item['local_name']: item for item in raw[expected_origin]}
        before = [available[local_name] for local_name in expected_names]
        assigned[expected_origin].extend(expected_names)
        candidate = O / 'candidates' / (name + '.lean')
        assert sha(candidate) == plan['source_manifest'][name], name
        candidate_bytes = candidate.read_bytes()
        after = declarations(candidate_bytes.decode())
        assert [public_record(item) for item in before] == [public_record(item) for item in after], name
        if expected_mode == 'original_headers_only':
            assert len(before) == 2 and before[1]['source_text'] == after[1]['source_text'], name
        elif expected_mode == 'imports_only_wrapper':
            assert not before and candidate_bytes == ''.join(
                'import D1Bound5.' + module + '\n' for module in RAW_GROUPS).encode()
        else:
            assert before == after, name
            if expected_mode in ('exact_module_bytes', 'new_reviewed_helper'):
                assert candidate_bytes == (O / 'originals' / (expected_origin + '.lean')).read_bytes(), name
            else:
                original_text = (O / 'originals' / (RAW + '.lean')).read_text()
                assert re.findall(r'^import [^\n]*', candidate_bytes.decode(), re.M) == re.findall(
                    r'^import [^\n]*', original_text, re.M)
                for item in before:
                    assert hashlib.sha256(item['source_text'].encode()).hexdigest() == partition['definition_sha256'][item['local_name']]
        assert not re.search(rb'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b', candidate_bytes), name
        selected[name] = before
    for name, names in assigned.items():
        assert names == [item['local_name'] for item in raw[name]], name
    declarations_all = [item for name in plan['build_order'] for item in selected[name]]
    assert len(declarations_all) == len({item['name'] for item in declarations_all}) == 41
    assert sum(item['kind'] == 'def' for item in declarations_all) == 13
    assert sum(item['kind'] == 'theorem' for item in declarations_all) == 28
    return origins, manifests, selected


assert O == C / '20261022-graph11-closure'
assert len(sys.argv) == 2 and sys.argv[1] in SCOPES
scope = sys.argv[1]
targets = load(O / (scope + '-TARGETS.json'))
assert targets == SCOPES[scope]
A = U / ('pro-graph11-' + scope + '-audit')
assert sha(W / 'continuation_driver_capacity.py') == 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'

with (W / 'continuation-driver.lock').open('r+') as owner, (W / 'continuation-intake.lock').open('r+') as intake:
    for lock in (owner, intake):
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    active = load(W / 'continuation-active.json')
    assert not active.get('active') and not active.get('protected_closure')
    assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=R)
    base = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=R, text=True).strip()
    spec = importlib.util.spec_from_file_location('graph11_closure_prepare_driver', W / 'continuation_driver_capacity.py')
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    driver = mod.Driver(R, W)
    latest = driver.latest()
    plan = load(O / 'PLAN.json')
    origins, original_manifest, selected = check_origins(plan)
    origin_sha = sha(O / 'DECLARATION_ORIGINS.json')
    provenance_binding = load(O / 'PROVENANCE_BINDING.json')
    required_maps = {str(C.relative_to(R) / '20261022-graph11-foundation/foundation-SOURCE_MAP.json')}
    required_maps |= {str(C.relative_to(R) / '20261022-graph11-sides' / (unit + '-SOURCE_MAP.json'))
                      for unit in ('sides-pilot', 'left-rest', 'right-rest')}
    assert required_maps <= {binding['path'] for binding in provenance_binding['source_maps']}
    used_maps, oldmap = {}, {}
    for relative in ['20261020-completed-checkpoint', '20261021-pro-graph33', '20261021-pro-one-small',
                     '20261021-pro-graph17-left000', '20261021-pro-graph17-left-complete', '20261021-pro-graph17-right-complete']:
        for name, item in load(C / relative / 'SOURCE_MAP.json')['sources'].items():
            oldmap[(name, item['sha256'])] = item
    for binding in provenance_binding['source_maps']:
        if scope not in binding['scopes']:
            continue
        relative, expected = Path(binding['path']), binding['sha256']
        assert not relative.is_absolute() and '..' not in relative.parts
        assert isinstance(expected, str) and re.fullmatch(r'[0-9a-f]{64}', expected)
        assert sha(R / relative) == expected, str(relative)
        committed = subprocess.check_output(['git', 'show', base + ':' + str(relative)], cwd=R, timeout=15)
        assert hashlib.sha256(committed).hexdigest() == expected, 'Provenance map must be committed: ' + str(relative)
        assert str(relative) not in used_maps
        used_maps[str(relative)] = expected
        for name, item in load(R / relative)['sources'].items():
            oldmap[(name, item['sha256'])] = item
    assert not A.exists()
    A.mkdir()
    all_decls, smap, rmap, records, union = [], {}, {}, [], {}
    for name in targets:
        source = R / 'D1Bound5' / (name + '.lean')
        digest = sha(source)
        assert digest == plan['source_manifest'][name] == sha(O / 'candidates' / (name + '.lean'))
        row = load(O / (name + '-BUILD_RECEIPT.json'))
        closure = load(O / (name + '-SOURCE_CLOSURE.json'))
        assert row['accepted_build'] and row['exit'] == 0 and not row['timed_out'] and not row['interrupted']
        assert row['closure_unchanged'] and row['shared_artifacts_unchanged'] and row['name'] == name
        assert row['source_sha256'] == digest and driver.closure(name) == closure
        assert mod.fingerprint(closure) == row['fingerprint'] and driver.artifacts(name) == row['artifacts']
        assert (O / (name + '.lean')).read_bytes() == source.read_bytes()
        for key, value in closure.items():
            assert key not in union or union[key] == value
            union[key] = value
        origin = origins[name]
        original = O / 'originals' / (origin['original_module'] + '.lean')
        assert sha(original) == original_manifest[origin['original_module']]
        before = selected[name]
        assert [public_record(item) for item in before] == [public_record(item) for item in declarations(source.read_text())]
        source_hashes = {item['name']: hashlib.sha256(item['source_text'].encode()).hexdigest() for item in before}
        declaration_records = [public_record(item) for item in before]
        (A / (name + '.lean')).write_bytes(source.read_bytes())
        smap[name] = {'source': str(source.relative_to(R)), 'snapshot': str((A / (name + '.lean')).relative_to(R)), 'sha256': digest}
        rmap[name] = {'receipt': str((O / (name + '-BUILD_RECEIPT.json')).relative_to(R)),
                     'closure': str((O / (name + '-SOURCE_CLOSURE.json')).relative_to(R))}
        records.append({'module': name, 'original_path': str(original), 'original_source_path': str(original),
                        'original_sha256': sha(original), 'current_sha256': digest,
                        'raw_original_module': origin['original_module'], 'preservation': origin['preservation'],
                        'origin_map_path': str(O / 'DECLARATION_ORIGINS.json'), 'origin_map_sha256': origin_sha,
                        'declaration_source_sha256': source_hashes, 'normalizations': [], 'declarations': declaration_records})
        all_decls.extend(declaration_records)
    names = [item['name'] for item in all_decls]
    definitions, theorems = COUNTS[scope]
    assert len(names) == len(set(names)) == definitions + theorems
    assert sum(item['kind'] == 'def' for item in all_decls) == definitions
    assert sum(item['kind'] == 'theorem' for item in all_decls) == theorems
    harness = ''.join('import D1Bound5.' + name + '\n' for name in targets)
    harness += 'import Lean.Elab.Command\nimport Lean.Util.CollectAxioms\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n'
    harness += 'run_cmd do\n  let names : List Lean.Name := [\n    ' + ',\n    '.join('`' + name for name in names) + ']\n'
    harness += ('  for name in names do\n    let ax ← Lean.collectAxioms name\n'
                '    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n\n'
                '    unless bad.isEmpty do\n      Lean.throwError "Unexpected axioms in {name}: {bad}"\n'
                '    Lean.logInfo m!"GRAPH11_CLOSURE_AXIOMS_PASS {name}: {ax}"\n\n')
    for item in all_decls:
        harness += ('namespace ' + item['namespace'] + '\n' + '\n'.join(item['opens']) + '\nexample\n'
                    + item['header'] + ' :=\n  _root_.' + item['name'] + '\nend ' + item['namespace'] + '\n\n')
    harness += ''.join('#check @_root_.' + name + '\n' for name in names)
    assert re.findall(r'^example\s*(.*?)\s*:=', harness, re.M | re.S) == [item['header'] for item in all_decls]
    (A / 'AnalyticAudit.lean').write_text(harness)
    for filename, value in [('TARGETS.json', targets), ('REPLAY_TARGETS.json', targets), ('SOURCE_MAP.json', smap),
                            ('BUILD_RECEIPT_MAP.json', rmap), ('SCOPED_ORIGINAL_DECLARATIONS.json', records), ('DECLARATION_NAMES.json', names)]:
        put(A / filename, value)
    put(A / 'PROVENANCE_BINDING_USED.json', {'binding_sha256': sha(O / 'PROVENANCE_BINDING.json'), 'source_maps': used_maps})
    source_map, evidence = {}, {}
    for name, digest in sorted(union.items()):
        key = mod.fingerprint(driver.closure(name))
        artifacts = driver.expected_manifest(name, key, latest)
        assert artifacts and driver.artifacts(name) == artifacts, name
        if name in plan['source_manifest']:
            assert sha(O / 'candidates' / (name + '.lean')) == digest
            source_map[name] = {'path': 'D1Bound5/' + name + '.lean', 'sha256': digest,
                                'payload_path': str((O / 'candidates' / (name + '.lean')).relative_to(R)),
                                'assurance': 'guarded_build_pass_current_audit_pending'}
        else:
            item = oldmap[(name, digest)]
            commit, path = ((base, item['payload_path']) if 'payload_path' in item else (item['base_commit'], item['base_path']))
            blob = subprocess.check_output(['git', 'show', commit + ':' + path], cwd=R, timeout=15)
            assert hashlib.sha256(blob).hexdigest() == digest
            source_map[name] = {'path': 'D1Bound5/' + name + '.lean', 'sha256': digest, 'base_commit': commit,
                                'base_path': path, 'assurance': 'reused_accepted_source_and_artifacts'}
        evidence[name] = {'fingerprint': key, 'artifacts': artifacts, 'original_receipt': latest.get((name, key)),
                          'baseline_entry': None if (name, key) in latest else driver.baseline['accepted'][name]}
    assert sha(O / 'DECLARATION_ORIGINS.json') == origin_sha
    assert all(sha(O / 'originals' / (name + '.lean')) == digest for name, digest in original_manifest.items())
    put(O / (scope + '-SOURCE_MAP.json'), {'base_commit': base, 'sources': source_map})
    put(O / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'), evidence)
    summary = {'targets': targets, 'declarations': len(names), 'theorems': theorems, 'definitions': definitions,
               'source_closure_modules': len(union), 'audit': str(A.relative_to(R)), 'public_headers_exact': True,
               'base_commit': base, 'root_integration': False, 'main_theorem_complete': False}
    put(O / (scope + '-PREPARATION.json'), summary)
    print(json.dumps({'status': 'ACCEPTED_UNIT_PREPARED_FOR_AUDIT', **summary}), flush=True)
