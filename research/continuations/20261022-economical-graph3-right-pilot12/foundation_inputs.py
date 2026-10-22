"""Pure source inspection and fail-closed input binding for graph3 foundation.

Importing this module does not access the project tree, run commands, or compile.
All graph-specific hashes, byte counts, and declaration counts come from actual
source inspection. The UNBOUND template deliberately cannot authorize a run.
"""
from pathlib import Path
import ast
import hashlib
import json
import re


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
GRAPH = 3
SOURCE_CATALOG_SHA = 'ac4e0093babad78ab72dfd13b046bb8e546472142e1a863b83d724fea086a416'
SOURCE_CATALOG_PATH = 'research/continuations/20261022-graph3-intake/SOURCE_CATALOG.json'
ORIGINAL_PINS = {'SmallPairLightData3': {'sha256': 'd3bb5d4e038c489d6e994326bcf1a9ad14094ee6afc548dc248b60db9965ecd1',
                         'bytes': 1402423},
 'SmallPairLightAdaptiveData3': {'sha256': 'f635cd4589d05fd53757fd49742c4d64e07139e743849150d36bb1a4c8ddc513',
                                 'bytes': 1380},
 'SmallPairLightAdaptiveValidation3': {'sha256': 'ecf705b62109ddfb82de5c299a3472b144926c98895c0bf88eb64f11a7bbf115',
                                       'bytes': 887}}
SOURCE_RESEARCH = {'research/continuations/20261022-graph3-intake/inspect_graph3.py': '1173222b73821aa11d738599a1a8b11fae4bf16dedf7bbacfba835f14ac7375d',
 'research/continuations/20261022-graph3-intake/REVIEW.md': '32fa356068b95fee6aa32c4fdbc4aaffc1d350e642289a8d634ee35c6c04822a',
 'research/continuations/20261022-graph3-intake/LOCAL_SOURCE_REVIEW.json': '4a53be06b65f9857d8fc4f8973fbfeffc47154dcd36599c56da8049d73368bcb',
 'research/continuations/20261022-graph3-intake/SOURCE_CATALOG.json': 'ac4e0093babad78ab72dfd13b046bb8e546472142e1a863b83d724fea086a416'}
ORIGINAL_NAMES = (
    'SmallPairLightData3',
    'SmallPairLightAdaptiveData3',
    'SmallPairLightAdaptiveValidation3',
)
GROUPS = {
    'SmallPairLightData3Left': ['sieve', 'leftVertices', 'leftCached'],
    'SmallPairLightData3LeftRows': ['leftRows'],
    'SmallPairLightData3Right': ['rightVertices', 'rightCached'],
    'SmallPairLightData3RightRows': ['rightRows'],
}
TARGETS = list(GROUPS) + list(ORIGINAL_NAMES)
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
RUNNER_SHA = 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
TOOLCHAIN_SHA = '3aac669c7a910ec2389f4e4f921b605adf6ebf2d1e0c9b9cd0be4d33f3f5db71'
LAKE_MANIFEST_SHA = '7ba6f92faaef8900c85a20ac695495111285a1b0c355cb1441a69b34ba9500f4'
NAMESPACE = b'D1Bound5.PairLightPrepared3'
PROHIBITED = rb'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b'
SCRIPT_NAMES = {'foundation_inputs.py', 'installer.py', 'bounded_build_template.py',
                'build_scope.py', 'prepare_checks.py', 'finish_checks.py'}
REPOSITORY = Path('/Users/tp/Lean/D1Bound5')
CANONICAL_ROOT_SHA = '33c5f8a0eb94b1ab1196054d8189a968dbe6da8f19ae818d962e435ea72a43c2'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def source_hash(path):
    path = Path(path)
    assert path.is_file() and not path.is_symlink(), str(path)
    return digest(path.read_bytes())


def numeric_row(data):
    """Inspect the restricted numeric literal grammar; never evaluate Lean."""
    text = data.strip().removesuffix(b',')
    assert text and re.fullmatch(rb'[0-9,()\[\]\- \t]+', text), data[:80]
    return ast.literal_eval(text.decode('ascii'))


def pair_of_ints(value):
    return isinstance(value, tuple) and len(value) == 2 and all(type(item) is int for item in value)


def literal_shape(name, values):
    if name in ('sieve', 'leftVertices', 'rightVertices'):
        assert all(pair_of_ints(value) for value in values), name
        if name == 'sieve':
            assert all(all(item >= 0 for item in value) for value in values), name
    elif name in ('leftCached', 'rightCached'):
        assert all(isinstance(value, tuple) and len(value) == 2 and pair_of_ints(value[0])
                   and isinstance(value[1], list) and all(pair_of_ints(item) for item in value[1])
                   for value in values), name
    else:
        assert name in ('leftRows', 'rightRows')
        assert all(isinstance(value, tuple) and len(value) == 2 and type(value[0]) is int and value[0] >= 0
                   and isinstance(value[1], list) and all(type(item) is int and item >= 0 for item in value[1])
                   for value in values), name


def declarations(text):
    result = []
    matches = list(re.finditer(r'^(def|theorem)\s+(\S+)\s*(.*?)\s*:=', text, re.M | re.S))
    for i, match in enumerate(matches):
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
        assert namespace.startswith('D1Bound5.')
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        closing = re.search(r'^end(?:\s|$)', text[match.end():end], re.M)
        if closing:
            end = match.end() + closing.start()
        result.append({
            'kind': match[1], 'local_name': match[2],
            'name': namespace + '.' + match[2], 'namespace': namespace,
            'opens': list(dict.fromkeys(opens)), 'header': match[3].strip(),
            'raw_header': text[match.start():match.end() - 2],
            'source_text': text[match.start():end],
        })
    names = [item['name'] for item in result]
    assert len(names) == len(set(names)), 'Duplicate original declaration'
    return result


def partition(original):
    """Return original byte blocks; never normalize, parse, or regenerate literals."""
    matches = list(re.finditer(rb'^def (\w+)\s*:', original, re.M))
    expected = [name for group in GROUPS.values() for name in group]
    assert [match[1].decode() for match in matches] == expected
    closings = list(re.finditer(rb'^end ' + re.escape(NAMESPACE) + rb'\s*$', original, re.M))
    assert len(closings) == 1 and closings[0].start() > matches[-1].start()
    end = closings[0].start()
    prefix, suffix = original[:matches[0].start()], original[end:]
    assert re.findall(rb'^import\s+(\S+)\s*$', prefix, re.M) == [b'D1Bound5.PairLightArithmetic']
    assert re.findall(rb'^namespace\s+(\S+)\s*$', prefix, re.M) == [NAMESPACE]
    assert suffix.strip() == b'end ' + NAMESPACE
    blocks = {
        match[1].decode(): original[match.start():matches[i + 1].start()
                                    if i + 1 < len(matches) else end]
        for i, match in enumerate(matches)
    }
    assert prefix + b''.join(blocks.values()) + suffix == original
    counts = {}
    for name, block in blocks.items():
        literal = re.fullmatch(rb'def ' + name.encode() + rb'\s*:[^\n]*:= \[\n(.*?)\n\]\s*', block, re.S)
        assert literal, name
        rows = literal[1].splitlines()
        assert rows and all(row.startswith(b'  ') and row.strip() for row in rows), name
        literal_shape(name, [numeric_row(row) for row in rows])
        counts[name] = len(rows)
    for side in ('left', 'right'):
        assert counts[side + 'Vertices'] == counts[side + 'Cached'] == counts[side + 'Rows'], side
    fragments = {
        name: prefix + b''.join(blocks[item] for item in group) + suffix
        for name, group in GROUPS.items()
    }
    return fragments, blocks, counts


def inspect_sources(raw):
    assert set(raw) == set(ORIGINAL_NAMES)
    for name, data in raw.items():
        assert type(data) is bytes, name
        assert len(data) == ORIGINAL_PINS[name]['bytes'], name
        assert digest(data) == ORIGINAL_PINS[name]['sha256'], name
        assert not re.search(PROHIBITED, data), name
    fragments, blocks, counts = partition(raw[ORIGINAL_NAMES[0]])
    found = {name: declarations(raw[name].decode()) for name in ORIGINAL_NAMES}
    all_declarations = [item for name in ORIGINAL_NAMES for item in found[name]]
    assert len({item['name'] for item in all_declarations}) == len(all_declarations)
    return {
        'source_catalog_sha256': SOURCE_CATALOG_SHA,
        'original_source_manifest': {name: digest(raw[name]) for name in ORIGINAL_NAMES},
        'original_source_bytes': {name: len(raw[name]) for name in ORIGINAL_NAMES},
        'original_imports': {
            name: re.findall(r'^import\s+(\S+)\s*$', raw[name].decode(), re.M)
            for name in ORIGINAL_NAMES
        },
        'literal_row_counts': counts,
        'original_data_definition_sha256': {name: digest(block) for name, block in blocks.items()},
        'fragment_source_bytes': {name: len(data) for name, data in fragments.items()},
        'fragment_source_manifest': {name: digest(data) for name, data in fragments.items()},
        'original_declaration_names': {
            name: [item['local_name'] for item in found[name]] for name in ORIGINAL_NAMES
        },
        'declaration_counts': {
            'total': len(all_declarations),
            'definitions': sum(item['kind'] == 'def' for item in all_declarations),
            'theorems': sum(item['kind'] == 'theorem' for item in all_declarations),
        },
        'declaration_headers': {
            name: [{key: value for key, value in item.items() if key != 'source_text'}
                   for item in found[name]] for name in ORIGINAL_NAMES
        },
        'declaration_source_sha256': {item['name']: digest(item['source_text'].encode()) for item in all_declarations},
        'numeric_literal_shapes_verified': True,
        'definition_partition_exact': True,
    }


def candidate_sources(raw):
    """Construct only the exact literal partition and unchanged small modules."""
    evidence = inspect_sources(raw)
    candidates, blocks, counts = partition(raw[ORIGINAL_NAMES[0]])
    candidates[ORIGINAL_NAMES[0]] = ''.join('import D1Bound5.' + name + '\n' for name in GROUPS).encode()
    for name in ORIGINAL_NAMES[1:]:
        candidates[name] = raw[name]
    assert list(candidates) == TARGETS
    origins = {name: {'original_module': ORIGINAL_NAMES[0], 'names': group} for name, group in GROUPS.items()}
    origins[ORIGINAL_NAMES[0]] = {'original_module': ORIGINAL_NAMES[0], 'names': []}
    for name in ORIGINAL_NAMES[1:]:
        origins[name] = {'original_module': name, 'names': evidence['original_declaration_names'][name]}
    before = {name: declarations(raw[name].decode()) for name in ORIGINAL_NAMES}
    assigned = {name: [] for name in ORIGINAL_NAMES}
    for name, data in candidates.items():
        origin = origins[name]
        available = {item['local_name']: item for item in before[origin['original_module']]}
        selected = [available[local] for local in origin['names']]
        assert declarations(data.decode()) == selected, name
        assigned[origin['original_module']].extend(origin['names'])
        assert not re.search(PROHIBITED, data), name
    assert assigned == evidence['original_declaration_names']
    assert sum(len(item['names']) for item in origins.values()) == evidence['declaration_counts']['total']
    return candidates, blocks, counts, origins


def prepared_plan(binding, binding_sha, candidates, blocks, counts):
    source = binding['source_evidence']
    return {
        'status': 'EXACT_GRAPH3_LITERAL_PARTITION_PREPARED_NOT_INSTALLED',
        'base_commit': binding['base_commit'],
        'source_manifest': {name: digest(candidates[name]) for name in TARGETS},
        'original_source_manifest': source['original_source_manifest'], 'targets': TARGETS,
        'original_data_definition_sha256': {name: digest(data) for name, data in blocks.items()},
        'literal_row_counts': counts, 'queue_before_sha256': binding['queue_before_sha256'],
        'configuration': binding['configuration'], 'definition_partition_exact': True,
        'original_public_declarations': source['declaration_counts']['total'],
        'declaration_counts': source['declaration_counts'],
        'source_bytes': {name: len(candidates[name]) for name in TARGETS},
        'input_binding_sha256': binding_sha,
        'source_inspection_sha256': binding['source_inspection_sha256'],
        'provenance_binding_sha256': binding['provenance_binding_sha256'],
        'main_theorem_complete': False, 'root_integration': False,
        'canonical_root_sha256': binding['canonical_root_sha256'],
    }


def prepared_payload_paths():
    """Explicit immutable inputs; mutable command logs are never captured."""
    paths = set(SCRIPT_NAMES) | {'inspect_inputs.py', 'bind_inputs.py', 'GRAPH3_BINDING.json',
        'PROVENANCE_BINDING.json', 'SOURCE_INSPECTION.json', 'REVIEWED_SCRIPT_PINS.json',
        'PLAN.json', 'DECLARATION_ORIGINS.json', 'foundation-TARGETS.json', 'bounded_build.py',
        'installation/GRAPH3_BINDING_USED.json', 'installation/continuation-queue.before.json'}
    paths |= {'installation/' + name + '.before.lean' for name in ORIGINAL_NAMES}
    paths |= {'candidates/' + name + '.lean' for name in TARGETS}
    return sorted(paths)


def verify_prepared(directory):
    """Verify frozen preparation from bound originals; run no subprocess."""
    directory = Path(directory)
    binding = load_binding(directory)
    binding_path = directory / 'GRAPH3_BINDING.json'
    assert (directory / 'installation/GRAPH3_BINDING_USED.json').read_bytes() == binding_path.read_bytes()
    assert json.loads((directory / 'REVIEWED_SCRIPT_PINS.json').read_text()) == binding['script_pins']
    raw = {}
    for name in ORIGINAL_NAMES:
        path = directory / 'installation' / (name + '.before.lean')
        assert source_hash(path) == binding['source_evidence']['original_source_manifest'][name]
        raw[name] = path.read_bytes()
    assert inspect_sources(raw) == binding['source_evidence']
    candidates, blocks, counts, origins = candidate_sources(raw)
    plan = json.loads((directory / 'PLAN.json').read_text())
    assert plan == prepared_plan(binding, source_hash(binding_path), candidates, blocks, counts)
    assert json.loads((directory / 'DECLARATION_ORIGINS.json').read_text()) == origins
    assert json.loads((directory / 'foundation-TARGETS.json').read_text()) == TARGETS
    assert source_hash(directory / 'installation/continuation-queue.before.json') == binding['queue_before_sha256']
    for name, data in candidates.items():
        path = directory / 'candidates' / (name + '.lean')
        assert source_hash(path) == digest(data) and path.read_bytes() == data, name
    template = (directory / 'bounded_build_template.py').read_text()
    assert template.count('__REVIEWED_SOURCE_PINS__') == 1
    pins = {name: plan['source_manifest'][name] for name in TARGETS}
    worker = template.replace('__REVIEWED_SOURCE_PINS__', repr(pins)).encode()
    ast.parse(worker.decode())
    assert (directory / 'bounded_build.py').read_bytes() == worker
    payload = json.loads((directory / 'PREPARED_PAYLOAD_SHA256.json').read_text())
    assert set(payload) == set(prepared_payload_paths())
    assert payload == {relative: source_hash(directory / relative) for relative in prepared_payload_paths()}
    return binding, plan, payload


def load_binding(directory):
    path = Path(directory) / 'GRAPH3_BINDING.json'
    assert path.is_file() and not path.is_symlink()
    value = json.loads(path.read_text())
    assert value['schema'] == 1 and value['graph'] == GRAPH
    assert value['status'] == 'GRAPH3_INPUTS_BOUND', 'Graph3 inputs remain explicitly unbound'
    assert re.fullmatch(r'[0-9a-f]{40}', value['base_commit'])
    assert all(isinstance(value[key], str) and re.fullmatch(r'[0-9a-f]{64}', value[key])
               for key in ('queue_before_sha256', 'canonical_root_sha256',
                           'source_inspection_sha256', 'provenance_binding_sha256'))
    assert source_hash(Path(directory) / 'SOURCE_INSPECTION.json') == value['source_inspection_sha256']
    assert source_hash(Path(directory) / 'PROVENANCE_BINDING.json') == value['provenance_binding_sha256']
    provenance = json.loads((Path(directory) / 'PROVENANCE_BINDING.json').read_text())
    assert provenance['schema'] == 1 and provenance['status'] == 'COMMITTED_PROVENANCE_BOUND'
    assert provenance['base_commit'] == value['base_commit'] and provenance['source_maps']
    paths = set()
    for item in provenance['source_maps']:
        relative = Path(item['path'])
        assert not relative.is_absolute() and '..' not in relative.parts and str(relative) not in paths
        paths.add(str(relative))
        path = REPOSITORY / relative
        assert path.resolve().is_relative_to(REPOSITORY.resolve())
        assert re.fullmatch(r'[0-9a-f]{64}', item['sha256']) and source_hash(path) == item['sha256']
    assert set(value['script_pins']) == SCRIPT_NAMES
    assert all(re.fullmatch(r'[0-9a-f]{64}', expected) and source_hash(Path(directory) / filename) == expected
               for filename, expected in value['script_pins'].items())
    assert value['target_timeout_seconds'] == 240 and value['max_parallel'] == 1
    assert value['canonical_root_sha256'] == CANONICAL_ROOT_SHA
    assert value['root_integration'] is False and value['main_theorem_complete'] is False
    assert value['source_research_files'] == SOURCE_RESEARCH
    assert all(source_hash(REPOSITORY / relative) == expected for relative, expected in SOURCE_RESEARCH.items())
    assert value['driver_sha256'] == DRIVER_SHA and value['audit_runner_sha256'] == RUNNER_SHA
    assert value['lean_toolchain_sha256'] == TOOLCHAIN_SHA
    assert value['lake_manifest_sha256'] == LAKE_MANIFEST_SHA
    assert isinstance(value['configuration'], dict) and value['configuration']
    assert value['configuration']['lean-toolchain'] == TOOLCHAIN_SHA
    assert value['configuration']['lake-manifest.json'] == LAKE_MANIFEST_SHA
    source = value['source_evidence']
    assert isinstance(source, dict), 'Actual graph3 source evidence is missing'
    assert json.loads((Path(directory) / 'SOURCE_INSPECTION.json').read_text()) == source
    assert source['source_catalog_sha256'] == SOURCE_CATALOG_SHA
    assert source['original_source_manifest'] == {name: ORIGINAL_PINS[name]['sha256'] for name in ORIGINAL_NAMES}
    assert source['original_source_bytes'] == {name: ORIGINAL_PINS[name]['bytes'] for name in ORIGINAL_NAMES}
    assert set(source['original_source_manifest']) == set(ORIGINAL_NAMES)
    assert all(isinstance(item, str) and re.fullmatch(r'[0-9a-f]{64}', item)
               for item in source['original_source_manifest'].values())
    assert set(source['original_source_bytes']) == set(ORIGINAL_NAMES)
    assert all(type(item) is int and item > 0 for item in source['original_source_bytes'].values())
    assert set(source['literal_row_counts']) == {name for group in GROUPS.values() for name in group}
    assert all(type(item) is int and item > 0 for item in source['literal_row_counts'].values())
    assert set(source['original_declaration_names']) == set(ORIGINAL_NAMES)
    assert source['original_declaration_names'][ORIGINAL_NAMES[0]] == [name for group in GROUPS.values() for name in group]
    assert set(source['declaration_counts']) == {'total', 'definitions', 'theorems'}
    assert all(type(item) is int and item >= 0 for item in source['declaration_counts'].values())
    assert source['declaration_counts']['total'] == source['declaration_counts']['definitions'] + source['declaration_counts']['theorems']
    assert source['declaration_counts']['total'] == sum(len(names) for names in source['original_declaration_names'].values())
    assert set(source['fragment_source_manifest']) == set(source['fragment_source_bytes']) == set(GROUPS)
    assert all(re.fullmatch(r'[0-9a-f]{64}', expected) for expected in source['fragment_source_manifest'].values())
    assert all(type(count) is int and count > 0 for count in source['fragment_source_bytes'].values())
    assert source['numeric_literal_shapes_verified'] is True
    assert source['definition_partition_exact'] is True
    return value
