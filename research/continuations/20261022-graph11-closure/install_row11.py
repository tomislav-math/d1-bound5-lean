"""Restore graph11 with exact raw literals and bounded full-list closure helpers.

Candidate installer only. Execution requires a separately reviewed INSTALL_BINDING
with the current commit and exact script hashes. No compiler, replay, Git mutation,
or accepted-root edit is performed. The original raw selected data is split into
four modules without changing any declaration body, namespace, or imports.
"""
from pathlib import Path
from datetime import datetime, timezone
import ast
import fcntl
import hashlib
import importlib.util
import json
import os
import re
import subprocess
import sys


R = Path('/Users/tp/Lean/D1Bound5')
C = R / 'research/continuations'
W = C / '20261018T010800CEST-main-continuation'
S = W / 'prepared-light-remaining39/D1Bound5'
O = Path(__file__).resolve().parent
TARGET = 'SmallPairGraphData11'
RAW = 'SmallPairRawSelectedData11'
PRE = 'cbc22344517903c3e7535596ee1b5d90d53228850899448677697d997639c17d'
PRE_BYTES = 2199314
DRIVER = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
COVERAGE_TEMPLATE = 'SmallPairGraphClosure29Coverage'
COVERAGE_SHA = '16bbbcfa2e81413a9c2553d413b4d7d2e2f9203e70dc18f06687328ff90afce1'
EXPECTED_ORIGINALS = {
    'SmallPairGraphInputs11': 'b499ddc749baceb1300d759c8918a3d970ddfbde887995663c13d3e413715a69',
    'SmallPairGraphArithmetic11': '364875a34ed5bd9637ca968a549dadc1fb5a5e775dc46c04000fe048f6339b2e',
    'SmallPairGraphWitnessData11': 'c142d7a8063d6c09c6a5c9423cd9f992bfdbdc5c3052c136f7da5f3d5974ac0f',
    'SmallPairGraphClosure11': 'c15c39d04c7d0fe25aa7e940e5ea38dd2fbccc731e33f5ef7b96a4fd536dc147',
    RAW: 'e6fd239f1d5f1afaba39a32e3960e25edd51393996a075641cea8f289f553f08',
    'SmallPairLightAssembly11': 'e7005de29879d0c1f756e05b4ab6bb8008ac22743be8e6172cf5d11c233a7754',
    'SmallPairGraphTriangle11': 'a31c3280b282b485f572eb3570e8e7f8b8a1e4d6551127d6471c702d3a0ea251',
    TARGET: 'b863c7932bb1f5edd3af3df7a1a006b06aaea8d7b007c52b475ad99185e99797',
}
EXPECTED_BYTES = {
    'SmallPairGraphInputs11': 414181,
    'SmallPairGraphArithmetic11': 567,
    'SmallPairGraphWitnessData11': 431420,
    'SmallPairGraphClosure11': 734,
    RAW: 1349061,
    'SmallPairLightAssembly11': 2047,
    'SmallPairGraphTriangle11': 396,
    TARGET: 124,
}
RAW_GROUPS = {
    'SmallPairRawSelectedData11LeftCached': ['leftCached'],
    'SmallPairRawSelectedData11LeftRows': ['leftRows'],
    'SmallPairRawSelectedData11RightCached': ['rightCached'],
    'SmallPairRawSelectedData11RightRows': ['rightRows'],
}
SCRIPT_NAMES = {'prepare_checks.py', 'finish_checks.py', 'bounded_build_template.py'}


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def dg(data):
    return hashlib.sha256(data).hexdigest()


def load(path):
    return json.loads(Path(path).read_text())


def put(path, data):
    if isinstance(data, str):
        data = data.encode()
    with Path(path).open('xb') as stream:
        stream.write(data)


def save(path, value):
    put(path, json.dumps(value, indent=2, sort_keys=True) + '\n')


def git(*args):
    return subprocess.check_output(['git', *args], cwd=R, text=True, timeout=30).strip()


def body(text):
    return re.sub(r'^import [^\n]*(?:\n|$)', '', text, flags=re.M).strip()


def headers(text):
    return [text[m.start():text.index(':=', m.start())]
            for m in re.finditer(r'^(?:def|theorem|lemma|abbrev|structure) ', text, re.M)]


def declaration_names(text):
    return re.findall(r'^(?:def|theorem|lemma|abbrev|structure)\s+(\S+)\s*:', text, re.M)


def imports(text):
    return re.findall(r'^import D1Bound5\.(\w+)\s*$', text, re.M)


def literal_rows(text, name):
    match = re.search(r'^def ' + re.escape(name) + r'\b.*?:=\s*\[\n(.*?)\n\]',
                      text, re.M | re.S)
    assert match, name
    return len([line for line in match[1].splitlines() if line.strip()])


def split_raw_literals(original):
    """Keep each original def block and its exact surrounding scope byte-identical."""
    matches = list(re.finditer(rb'^def (\w+)\s*:', original, re.M))
    wanted = [name for names in RAW_GROUPS.values() for name in names]
    assert [match[1].decode() for match in matches] == wanted
    prefix = original[:matches[0].start()]
    namespaces = re.findall(rb'^namespace (\S+)\s*$', prefix, re.M)
    assert len(namespaces) == 1 and namespaces[0].startswith(b'D1Bound5.')
    namespace = namespaces[0]
    closings = list(re.finditer(rb'^end ' + re.escape(namespace) + rb'\s*$', original, re.M))
    assert len(closings) == 1 and closings[0].start() > matches[-1].start()
    end = closings[0].start()
    suffix = original[end:]
    assert suffix.strip() == b'end ' + namespace
    blocks = {match[1].decode(): original[match.start():matches[i + 1].start()
                                         if i + 1 < len(matches) else end]
              for i, match in enumerate(matches)}
    assert prefix + b''.join(blocks.values()) + suffix == original
    assert imports(prefix.decode()) == [
        'SmallPairGraphInputs11', 'PairCachedResidues', 'SmallPairSieve_0_1']
    for name, block in blocks.items():
        assert re.match(rb'def ' + name.encode() + rb'\s*:[^\n]*:= \[\n', block), name
        assert re.search(rb'\n\]\s*\Z', block), name
        expected_type = ': List (PairResidueVertex 0 1)' if name.endswith('Cached') else ': List (ℕ × List ℕ)'
        assert ' '.join(headers(block.decode())[0].split()) == 'def ' + name + ' ' + expected_type
    fragments = {module: prefix + b''.join(blocks[name] for name in names) + suffix
                 for module, names in RAW_GROUPS.items()}
    for module, names in RAW_GROUPS.items():
        fragment = fragments[module]
        assert fragment.startswith(prefix) and fragment.endswith(suffix)
        assert imports(fragment.decode()) == imports(original.decode())
        assert headers(fragment.decode()) == [header for name in names for header in headers(blocks[name].decode())]
        assert len(fragment) <= 500000, (module, len(fragment))
    return fragments, blocks, prefix, suffix, namespace.decode()


def main():
    assert O == C / '20261022-graph11-closure'
    binding_bytes = (O / 'INSTALL_BINDING.json').read_bytes()
    binding = json.loads(binding_bytes)
    base = binding['base_commit']
    assert re.fullmatch(r'[0-9a-f]{40}', base)
    assert binding['original_merged_sha256'] == PRE and binding['original_merged_bytes'] == PRE_BYTES
    assert binding['original_module_sha256'] == EXPECTED_ORIGINALS
    script_pins = binding['script_pins']
    assert set(script_pins) == SCRIPT_NAMES
    assert all(isinstance(value, str) and re.fullmatch(r'[0-9a-f]{64}', value)
               for value in script_pins.values())
    assert all(sha(O / name) == value for name, value in script_pins.items())
    assert sha(W / 'continuation_driver_capacity.py') == DRIVER

    pre = (R / 'D1Bound5' / (TARGET + '.lean')).read_bytes()
    assert dg(pre) == PRE and len(pre) == PRE_BYTES
    merged = pre.decode()
    marks = list(re.finditer(
        r'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n',
        merged, re.M))
    assert len(marks) == 8 and body(merged[:marks[0].start()]) == ''
    originals, blobs, public, provenance = {}, {}, [], {}
    for i, match in enumerate(marks):
        name = match[1]
        assert name in EXPECTED_ORIGINALS and name not in originals
        path = S / (name + '.lean')
        data = path.read_bytes()
        end = marks[i + 1].start() if i + 1 < len(marks) else len(merged)
        assert dg(data) == EXPECTED_ORIGINALS[name] == match[2]
        assert len(data) == EXPECTED_BYTES[name]
        assert body(data.decode()) == merged[match.end():end].strip()
        originals[name] = data
        blobs[name] = data
        public.extend(headers(data.decode()))
        provenance[str(path)] = dg(data)
    assert set(originals) == set(EXPECTED_ORIGINALS)
    assert public == headers(merged) and len(public) == 28
    for module, name in [('SmallPairGraphInputs11', 'smallPairClosure_11'),
                         ('SmallPairGraphWitnessData11', 'rootPairs'),
                         ('SmallPairGraphWitnessData11', 'destinations')]:
        assert literal_rows(blobs[module].decode(), name) == 719, name
    assert literal_rows(blobs['SmallPairGraphInputs11'].decode(), 'smallPairLarge_11') == 718
    for name in ['smallPairA_11', 'smallPairB_11']:
        assert re.search(r'^def ' + name + r'\s*:\s*QuadInt 0 1\s*:=',
                         blobs['SmallPairGraphInputs11'].decode(), re.M)
    assert re.search(r'^def anchorRoot\s*:\s*QuadInt 0 1\s*:=',
                     blobs['SmallPairGraphWitnessData11'].decode(), re.M)

    raw_fragments, raw_blocks, raw_prefix, raw_suffix, raw_namespace = split_raw_literals(originals[RAW])
    blobs.update(raw_fragments)
    blobs[RAW] = ''.join('import D1Bound5.' + name + '\n' for name in RAW_GROUPS).encode()
    assert not headers(blobs[RAW].decode())

    chunks = []
    for number, offset in enumerate(range(0, 719, 64)):
        name = f'SmallPairGraphClosure11Chunk{number:02d}'
        count = min(64, 719 - offset)
        chunks.append({'module': name, 'offset': offset, 'count': count})
        text = f"""import D1Bound5.SmallPairGraphWitnessData11
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared11
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk{number:02d}_checked :
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 {count}
      (witnesses.drop {offset}) (destinations.drop {offset}) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared11
"""
        blobs[name] = text.encode()
        originals[name] = blobs[name]
    assert [part['count'] for part in chunks] == [64] * 11 + [15]
    assert [i for part in chunks for i in range(part['offset'], part['offset'] + part['count'])] == list(range(719))
    cov = R / 'D1Bound5' / (COVERAGE_TEMPLATE + '.lean')
    assert sha(cov) == COVERAGE_SHA
    cov_text = cov.read_text()
    assert cov_text.count('QuadInt 1 1') == 3
    for old, new in [('SmallPairGraphWitnessData29', 'SmallPairGraphWitnessData11'),
                     ('PairGraphPrepared29', 'PairGraphPrepared11'),
                     ('smallPairA_29', 'smallPairA_11'), ('smallPairB_29', 'smallPairB_11'),
                     ('smallPairClosure_29', 'smallPairClosure_11')]:
        cov_text = cov_text.replace(old, new)
    cov_text = cov_text.replace('QuadInt 1 1', 'QuadInt 0 1')
    assert cov_text.count('QuadInt 0 1') == 3 and 'QuadInt 1 1' not in cov_text and '29' not in cov_text
    coverage_name = 'SmallPairGraphClosure11Coverage'
    blobs[coverage_name] = cov_text.encode()
    originals[coverage_name] = blobs[coverage_name]
    provenance[str(cov)] = COVERAGE_SHA
    assert 'List.zipWith' in blobs['SmallPairGraphWitnessData11'].decode()

    closure_name = 'SmallPairGraphClosure11'
    old = originals[closure_name].decode()
    starts = list(re.finditer(r'^theorem ', old, re.M))
    assert len(starts) == 2
    prefix = re.sub(r'^import [^\n]*(?:\n|$)', '', old[:starts[0].start()], flags=re.M).lstrip('\n')
    first = old[starts[0].start():old.index(':=', starts[0].start())]
    suffix = old[starts[1].start():]
    proof = """  apply pairClosureIndexedWitnessBool_of_checked_parts
    smallPairA_11 smallPairB_11 anchorRoot (10^1100) smallPairClosure_11
    witnesses destinations indexed_coverage_checked
  have h719 : pairIndexedWitnessesCheckedBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 (witnesses.drop 719) (destinations.drop 719) = true := by
    rfl
"""
    for number, part in reversed(list(enumerate(chunks))):
        offset, count = part['offset'], part['count']
        proof += f"""  have h{offset:03d} : pairIndexedWitnessesCheckedBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 (witnesses.drop {offset}) (destinations.drop {offset}) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_11 smallPairB_11 anchorRoot (10^1100) smallPairClosure_11 {count}
      (witnesses.drop {offset}) (destinations.drop {offset}) indexed_chunk{number:02d}_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h{offset + count:03d}
"""
    proof += '  simpa only [List.drop_zero] using h000\n\n'
    new = ('import D1Bound5.' + coverage_name + '\n'
           + ''.join('import D1Bound5.' + part['module'] + '\n' for part in chunks)
           + '\n' + prefix + first + ':= by\n' + proof + suffix)
    assert headers(new) == headers(old)
    assert new[new.index('theorem smallPairClosure_11_checked'):] == suffix
    blobs[closure_name] = new.encode()
    for name in set(EXPECTED_ORIGINALS) - {RAW, closure_name}:
        assert blobs[name] == originals[name], name

    core = ['SmallPairGraphInputs11', 'SmallPairGraphWitnessData11'] + [part['module'] for part in chunks] + [coverage_name, closure_name]
    assembly = ['SmallPairGraphArithmetic11'] + list(RAW_GROUPS) + [RAW, 'SmallPairLightAssembly11', 'SmallPairGraphTriangle11', TARGET]
    order = core + assembly
    assert len(core) == 16 and len(assembly) == 9 and len(order) == 25
    assert set(order) == set(blobs) and len(set(order)) == 25
    origins = {}
    for name in order:
        if name in RAW_GROUPS:
            origins[name] = {'original_module': RAW, 'names': RAW_GROUPS[name], 'preservation': 'exact_declaration_source'}
        elif name == RAW:
            origins[name] = {'original_module': RAW, 'names': [], 'preservation': 'imports_only_wrapper'}
        else:
            origins[name] = {'original_module': name, 'names': declaration_names(originals[name].decode()),
                             'preservation': 'original_headers_only' if name == closure_name else
                                             'new_reviewed_helper' if name not in EXPECTED_ORIGINALS else
                                             'exact_module_bytes'}
    for name in EXPECTED_ORIGINALS:
        assigned = [item for target in order if origins[target]['original_module'] == name
                    for item in origins[target]['names']]
        assert assigned == declaration_names(originals[name].decode()), name
    assert sum(len(origins[name]['names']) for name in order
               if origins[name]['original_module'] in EXPECTED_ORIGINALS) == 28
    assert sum(len(headers(blobs[name].decode())) for name in order) == 41
    seen, external = set(), set()
    for name in order:
        text = blobs[name].decode()
        deps = set(imports(text))
        assert deps & set(order) <= seen, name
        external |= deps - set(order)
        seen.add(name)
        assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b', text), name
    old_external = set(imports(merged[:marks[0].start()]))
    assert external == (old_external - {'PairClosureIndexedWitness'}) | {'PairClosureIndexedChunks'}

    pins = {name: dg(blobs[name]) for name in order}
    wrapper = (O / 'bounded_build_template.py').read_text()
    assert len(re.findall(r'^PINS = .*$', wrapper, re.M)) == 1
    wrapper = re.sub(r'^PINS = .*$', 'PINS = ' + repr(pins), wrapper, flags=re.M)
    ast.parse(wrapper)
    pilot = ['SmallPairGraphInputs11', 'SmallPairGraphWitnessData11',
             'SmallPairGraphClosure11Chunk00', coverage_name]
    rest = [name for name in core if name not in pilot]
    assert len(pilot) == 4 and len(rest) == 12 and len(assembly) == 9
    scopes = [('closure-pilot', pilot), ('closure-rest', rest), ('assembly', assembly)]

    spec = importlib.util.spec_from_file_location('graph11_restore_driver', W / 'continuation_driver_capacity.py')
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    with (W / 'continuation-driver.lock').open('r+') as owner, (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in [owner, intake]:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert git('rev-parse', 'HEAD') == base and git('branch', '--show-current') == 'main'
        assert not git('diff', '--cached', '--name-only')
        processes = subprocess.check_output(['ps', '-axo', 'pid=,comm='], text=True)
        assert not any(Path(fields[-1]).name in ('lean', 'lake', 'leanchecker')
                       for line in processes.splitlines() if (fields := line.split()))
        driver = module.Driver(R, W)
        active_bytes = driver.active_path.read_bytes()
        assert not load(driver.active_path).get('active') and not load(driver.active_path).get('protected_closure')
        queue, names, closures, accepted, unknown, eligible = driver.snapshot()
        assert not unknown and queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        new_names = [name for name in order if name != TARGET]
        assert TARGET in names and TARGET not in accepted
        assert all(not (R / 'D1Bound5' / (name + '.lean')).exists() and name not in names for name in new_names)
        assert not any(TARGET in closures[name] for name in accepted)
        required = set(closures[TARGET]) - {TARGET}
        for name in external | {COVERAGE_TEMPLATE, 'SmallPairGraphData29', 'SmallPairGraphData25', 'SmallPairGraphData12'}:
            required.update(driver.closure(name))
        assert required <= accepted
        for key, value in queue.items():
            if key == 'blocked_modules' or key.startswith('held_until_'):
                assert not set(value) & (required | set(order))
        latest, artifacts, evidence, sources = driver.latest(), {}, {}, {}
        for name in sorted(required):
            closure = driver.closure(name)
            key = module.fingerprint(closure)
            manifest = driver.expected_manifest(name, key, latest)
            assert manifest and driver.artifacts(name) == manifest, name
            sources[name] = closure[name]
            evidence[name] = {'fingerprint': key, 'artifacts': manifest,
                              'original_receipt': latest.get((name, key)),
                              'baseline_entry': None if (name, key) in latest else driver.baseline['accepted'][name]}
            for path, value in manifest.items():
                assert path not in artifacts or artifacts[path] == value
                artifacts[path] = value
        configuration = dict(driver.static)
        queue_bytes = driver.queue_path.read_bytes()
        index = sha(R / '.git/index')
        root_sha = sha(R / 'D1Bound5.lean')

        def stable():
            assert git('rev-parse', 'HEAD') == base and sha(R / '.git/index') == index
            assert driver.queue_path.read_bytes() == queue_bytes and driver.active_path.read_bytes() == active_bytes
            assert all(sha(R / 'D1Bound5' / (name + '.lean')) == value for name, value in sources.items())
            assert all(sha(path) == value for path, value in provenance.items())
            assert driver.manifest_matches(artifacts, cached=False) and driver.manifest_matches(configuration, cached=False)
            assert sha(R / 'D1Bound5' / (TARGET + '.lean')) == PRE and sha(R / 'D1Bound5.lean') == root_sha
            assert (O / 'INSTALL_BINDING.json').read_bytes() == binding_bytes
            assert all(sha(O / name) == value for name, value in script_pins.items())

        stable()
        installation = O / 'installation'
        temporary = R / 'D1Bound5/SmallPairGraphData11.partition.tmp'
        assert not temporary.exists() and not temporary.is_symlink(), temporary
        for path in [installation, O / 'candidates', O / 'originals', O / 'PLAN.json',
                     O / 'DECLARATION_ORIGINS.json', O / 'bounded_build.py'] + [
                         O / (scope + '-TARGETS.json') for scope, _ in scopes]:
            assert not path.exists(), path
        installation.mkdir()
        (O / 'candidates').mkdir()
        (O / 'originals').mkdir()
        put(installation / (TARGET + '.before.lean'), pre)
        put(installation / 'QUEUE_BEFORE.json', queue_bytes)
        put(installation / 'ACTIVE_BEFORE.json', active_bytes)
        put(installation / 'INSTALL_BINDING_USED.json', binding_bytes)
        save(installation / 'SCRIPT_PINS.json', script_pins)
        for name, data in originals.items():
            put(O / 'originals' / (name + '.lean'), data)
        for name in order:
            put(O / 'candidates' / (name + '.lean'), blobs[name])
        plan = {
            'status': 'REVIEWED_GRAPH11_RESTORATION_NOT_BUILT', 'base_commit': base,
            'source_manifest': pins, 'build_order': order, 'source_bytes': {name: len(blobs[name]) for name in order},
            'original_source_manifest': EXPECTED_ORIGINALS,
            'reviewed_helper_source_manifest': {name: dg(data) for name, data in originals.items() if name not in EXPECTED_ORIGINALS},
            'original_public_declarations': 28, 'original_public_headers': public,
            'origins': origins, 'prefix_parts': chunks, 'closure_rows': 719, 'filtered_vertices': 718,
            'raw_literal_partition': {
                'original_module': RAW, 'groups': RAW_GROUPS, 'namespace': raw_namespace,
                'definition_sha256': {name: dg(data) for name, data in raw_blocks.items()},
                'prefix_sha256': dg(raw_prefix), 'suffix_sha256': dg(raw_suffix),
                'exact_byte_reconstruction': True, 'original_imports_preserved_in_each_data_module': True,
            },
            'source_provenance': provenance, 'original_merged_sha256': PRE,
            'canonical_root_sha256': root_sha, 'root_integration': False, 'main_theorem_complete': False,
        }
        save(O / 'PLAN.json', plan)
        save(O / 'DECLARATION_ORIGINS.json', origins)
        save(installation / 'GUARDS_BEFORE.json', {
            'head': base, 'index_sha256': index, 'accepted_sources': sources,
            'accepted_artifacts': artifacts, 'configuration': configuration,
            'original_target_closure': closures[TARGET], 'canonical_root_sha256': root_sha})
        save(installation / 'ACCEPTED_INPUT_EVIDENCE.json', evidence)
        stable()
        for name in new_names:
            put(R / 'D1Bound5' / (name + '.lean'), blobs[name])
        assert not temporary.exists()
        put(temporary, blobs[TARGET])
        assert sha(R / 'D1Bound5' / (TARGET + '.lean')) == PRE
        os.replace(temporary, R / 'D1Bound5' / (TARGET + '.lean'))
        queue_after = json.loads(queue_bytes)
        queue_after['names'] += new_names
        assert {key: value for key, value in queue_after.items() if key != 'names'} == {
            key: value for key, value in queue.items() if key != 'names'}
        module.atomic_json(driver.queue_path, queue_after)
        assert all(sha(R / 'D1Bound5' / (name + '.lean')) == value for name, value in pins.items())
        assert all(sha(R / 'D1Bound5' / (name + '.lean')) == value for name, value in sources.items())
        assert driver.manifest_matches(artifacts, cached=False) and driver.manifest_matches(configuration, cached=False)
        assert driver.active_path.read_bytes() == active_bytes and git('rev-parse', 'HEAD') == base
        assert sha(R / '.git/index') == index and sha(R / 'D1Bound5.lean') == root_sha
        save(installation / 'QUEUE_AFTER.json', queue_after)
        put(O / 'bounded_build.py', wrapper)
        for scope, targets in scopes:
            save(O / (scope + '-TARGETS.json'), targets)
        result = {
            'status': 'GRAPH11_RESTORED_UNCOMPILED', 'utc': datetime.now(timezone.utc).isoformat(),
            'new_modules': new_names, 'original_declarations_preserved': 28,
            'complete_rows': 719, 'filtered_vertices': 718,
            'partition_counts': [part['count'] for part in chunks],
            'raw_data_modules': list(RAW_GROUPS), 'all_original_literal_definitions_byte_identical': True,
            'both_mutation_signs_and_global_indices_preserved': True,
            'both_locks_held': True, 'compiler_started': False, 'root_integration': False,
            'main_theorem_complete': False,
        }
        save(installation / 'APPLICATION_RECEIPT.json', result)
        print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
