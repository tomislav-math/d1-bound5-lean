"""Prepare graph24 closure candidate files without touching the project tree.

Usage: python3 -B generate_proposal.py MERGED ARCHIVES COVERAGE_TEMPLATE NEW_OUTPUT
All paths are the fixed graph24 project/archive paths and historical graph29
coverage source; NEW_OUTPUT must be the new graph24 closure proposal directory.
The actual pinned catalog and narrow inspection are rechecked before output.
The complete output is an uninstalled source proposal, never a proof result.
"""
from pathlib import Path
import json
import re
import sys

sys.dont_write_bytecode = True

from closure_inputs import (
    ARCHIVE_DIRECTORY, MERGED_BYTES, MERGED_SHA, ORIGINAL_PINS,
    OUTPUT_DIRECTORY, PROHIBITED, RAW, RAW_GROUPS, REPOSITORY,
    SOURCE_CATALOG_BYTES, SOURCE_CATALOG_PATH, SOURCE_CATALOG_SHA,
    TARGET, declarations, digest, inspect, read_source, split_raw,
    top_imports, verify_catalog,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')

COVERAGE_TEMPLATE_SHA = '16bbbcfa2e81413a9c2553d413b4d7d2e2f9203e70dc18f06687328ff90afce1'
SOURCE_INSPECTION_SHA = '7efb7dc28cc3753d98937cfd99cb48de34f7a86310aab373f29f29c2238d3348'
SOURCE_INSPECTION_BYTES = 32805
COVERAGE = 'SmallPairGraphClosure24Coverage'
CLOSURE = 'SmallPairGraphClosure24'


def put(path, data):
    if isinstance(data, str):
        data = data.encode()
    with path.open('xb') as stream:
        stream.write(data)


def save(path, value):
    put(path, json.dumps(value, indent=2, sort_keys=True) + '\n')


def public_headers(data):
    return [item['raw_header'] for item in declarations(data.decode())]


def build_candidates(merged, archived, coverage_template):
    evidence = inspect(merged, archived)
    evidence_bytes = (json.dumps(evidence, indent=2, sort_keys=True) + '\n').encode()
    assert digest(evidence_bytes) == SOURCE_INSPECTION_SHA
    assert len(evidence_bytes) == SOURCE_INSPECTION_BYTES
    assert evidence['source_catalog_sha256'] == SOURCE_CATALOG_SHA
    assert evidence['model_parameters'] == [1, 1]
    assert evidence['closure_rows'] == 894 and evidence['filtered_vertices'] == 892
    assert evidence['declaration_counts'] == {'definitions': 13, 'theorems': 15, 'total': 28}
    assert {name: item['rows'] for name, item in evidence['literal_evidence'].items()} == {
        'smallPairClosure_24': 894, 'smallPairLarge_24': 892,
        'rootPairs': 894, 'destinations': 894,
        'leftCached': 446, 'leftRows': 446, 'rightCached': 446, 'rightRows': 446,
    }
    input_declarations = {item['local_name']: item for item in declarations(archived['SmallPairGraphInputs24'].decode())}
    witness_declarations = {item['local_name']: item for item in declarations(archived['SmallPairGraphWitnessData24'].decode())}
    assert input_declarations['smallPairA_24']['header'] == ': QuadInt 1 1'
    assert input_declarations['smallPairB_24']['header'] == ': QuadInt 1 1'
    assert input_declarations['smallPairClosure_24']['header'] == ': List (QuadInt 1 1)'
    assert input_declarations['smallPairLarge_24']['header'] == ': List (QuadInt 1 1)'
    assert witness_declarations['anchorRoot']['header'] == ': QuadInt 1 1'
    assert witness_declarations['rootPairs']['header'] == ': List (QuadInt 1 1 × QuadInt 1 1)'
    assert witness_declarations['witnesses']['header'] == ': List (PairRootWitness 1 1)'
    assert digest(coverage_template) == COVERAGE_TEMPLATE_SHA
    originals, candidates = dict(archived), dict(archived)
    fragments, raw_blocks, prefix, suffix = split_raw(archived[RAW])
    assert {name: digest(data) for name, data in fragments.items()} == evidence['raw_literal_partition']['source_manifest']
    assert {name: len(data) for name, data in fragments.items()} == evidence['raw_literal_partition']['source_bytes']
    assert all(declarations(data.decode()) == [item for item in declarations(archived[RAW].decode())
                                               if item['local_name'] in RAW_GROUPS[name]]
               for name, data in fragments.items())
    candidates.update(fragments)
    candidates[RAW] = ''.join('import D1Bound5.' + name + '\n' for name in RAW_GROUPS).encode()
    parts = evidence['proposed_prefix_parts']
    rows = evidence['closure_rows']
    assert [part['count'] for part in parts] == [64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 62]
    assert [row for part in parts for row in range(part['offset'], part['offset'] + part['count'])] == list(range(rows))
    assert evidence['proposed_terminal_drop'] == rows
    for index, part in enumerate(parts):
        name, offset, count = part['module'], part['offset'], part['count']
        text = f"""import D1Bound5.SmallPairGraphWitnessData24
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared24
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk{index:02d}_checked :
    pairIndexedWitnessesPrefixBool smallPairA_24 smallPairB_24 anchorRoot
      (10^1100) smallPairClosure_24 {count}
      (witnesses.drop {offset}) (destinations.drop {offset}) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared24
"""
        candidates[name] = originals[name] = text.encode()
    coverage = coverage_template.decode()
    assert coverage.count('QuadInt 1 1') == 3
    for old, new in [('SmallPairGraphWitnessData29', 'SmallPairGraphWitnessData24'),
                     ('PairGraphPrepared29', 'PairGraphPrepared24'),
                     ('smallPairA_29', 'smallPairA_24'), ('smallPairB_29', 'smallPairB_24'),
                     ('smallPairClosure_29', 'smallPairClosure_24')]:
        assert old in coverage
        coverage = coverage.replace(old, new)
    # Original coverage template already uses the exact original model (1,1).
    assert coverage.count('QuadInt 1 1') == 3 and '29' not in coverage
    candidates[COVERAGE] = originals[COVERAGE] = coverage.encode()
    assert re.search(rb'^def witnesses[^\n]*:=\n  List\.zipWith', archived['SmallPairGraphWitnessData24'], re.M)

    old = archived[CLOSURE].decode()
    starts = list(re.finditer(r'^theorem ', old, re.M))
    assert len(starts) == 2
    original_imports, original_import_bytes, original_body = top_imports(archived[CLOSURE])
    assert original_imports == ['SmallPairGraphWitnessData24', 'PairClosureIndexedWitness']
    prefix = old[len(original_import_bytes):starts[0].start()]
    first_header = old[starts[0].start():old.index(':=', starts[0].start())]
    unchanged_suffix = old[starts[1].start():]
    assert first_header.startswith('theorem PairGraphPrepared24.indexed_checked :')
    assert unchanged_suffix.startswith('theorem smallPairClosure_24_checked :')
    proof = f"""  apply pairClosureIndexedWitnessBool_of_checked_parts
    smallPairA_24 smallPairB_24 anchorRoot (10^1100) smallPairClosure_24
    witnesses destinations indexed_coverage_checked
  have h{rows:03d} : pairIndexedWitnessesCheckedBool smallPairA_24 smallPairB_24 anchorRoot
      (10^1100) smallPairClosure_24 (witnesses.drop {rows}) (destinations.drop {rows}) = true := by
    rfl
"""
    for index, part in reversed(list(enumerate(parts))):
        offset, count = part['offset'], part['count']
        proof += f"""  have h{offset:03d} : pairIndexedWitnessesCheckedBool smallPairA_24 smallPairB_24 anchorRoot
      (10^1100) smallPairClosure_24 (witnesses.drop {offset}) (destinations.drop {offset}) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_24 smallPairB_24 anchorRoot (10^1100) smallPairClosure_24 {count}
      (witnesses.drop {offset}) (destinations.drop {offset}) indexed_chunk{index:02d}_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h{offset + count:03d}
"""
    proof += '  simpa only [List.drop_zero] using h000\n\n'
    candidates[CLOSURE] = (
        'import D1Bound5.' + COVERAGE + '\n'
        + ''.join('import D1Bound5.' + part['module'] + '\n' for part in parts)
        + prefix + first_header + ':= by\n' + proof + unchanged_suffix
    ).encode()
    assert public_headers(candidates[CLOSURE]) == public_headers(archived[CLOSURE])
    assert candidates[CLOSURE].decode()[candidates[CLOSURE].decode().index('theorem smallPairClosure_24_checked'):] == unchanged_suffix
    for name in set(ORIGINAL_PINS) - {RAW, CLOSURE}:
        assert candidates[name] == archived[name], name

    core = ['SmallPairGraphInputs24', 'SmallPairGraphWitnessData24'] + [part['module'] for part in parts] + [COVERAGE, CLOSURE]
    assembly = ['SmallPairGraphArithmetic24'] + list(RAW_GROUPS) + [RAW, 'SmallPairLightAssembly24', 'SmallPairGraphTriangle24', TARGET]
    order = core + assembly
    assert len(order) == len(set(order)) and set(order) == set(candidates)
    pilot = ['SmallPairGraphInputs24', 'SmallPairGraphWitnessData24', parts[0]['module'], COVERAGE]
    scopes = {'closure-pilot': pilot, 'closure-rest': [name for name in core if name not in pilot], 'assembly': assembly}
    origins = {}
    for name in order:
        if name in RAW_GROUPS:
            origins[name] = {'original_module': RAW, 'names': RAW_GROUPS[name], 'preservation': 'exact_declaration_source'}
        elif name == RAW:
            origins[name] = {'original_module': RAW, 'names': [], 'preservation': 'imports_only_wrapper'}
        else:
            origins[name] = {'original_module': name,
                             'names': [item['local_name'] for item in declarations(originals[name].decode())],
                             'preservation': 'original_headers_only' if name == CLOSURE else
                                             'new_reviewed_helper' if name not in ORIGINAL_PINS else 'exact_module_bytes'}
    for name in ORIGINAL_PINS:
        assigned = [local for target in order if origins[target]['original_module'] == name for local in origins[target]['names']]
        assert assigned == [item['local_name'] for item in declarations(archived[name].decode())], name
    original_headers = [header for name in ORIGINAL_PINS for header in public_headers(archived[name])]
    assert len(original_headers) == evidence['declaration_counts']['total']
    assert sum(len(item['names']) for item in origins.values()) == len(original_headers) + len(parts) + 1
    seen, external = set(), set()
    for name in order:
        dependencies = set(top_imports(candidates[name])[0])
        assert dependencies & set(order) <= seen, name
        external |= dependencies - set(order)
        seen.add(name)
        assert not re.search(PROHIBITED, candidates[name]), name
    assert external == (set(evidence['merged_external_imports']) - {'PairClosureIndexedWitness'}) | {'PairClosureIndexedChunks'}
    scope_counts = {}
    for scope, targets in scopes.items():
        found = [item for name in targets for item in declarations(candidates[name].decode())]
        scope_counts[scope] = {'targets': len(targets), 'definitions': sum(item['kind'] == 'def' for item in found),
                               'theorems': sum(item['kind'] == 'theorem' for item in found), 'declarations': len(found)}
    assert scope_counts == {
        'closure-pilot': {'targets': 4, 'definitions': 9, 'theorems': 2, 'declarations': 11},
        'closure-rest': {'targets': 14, 'definitions': 0, 'theorems': 15, 'declarations': 15},
        'assembly': {'targets': 9, 'definitions': 4, 'theorems': 13, 'declarations': 17},
    }
    plan = {
        'status': 'REVIEWED_GRAPH24_CLOSURE_SOURCE_PROPOSAL_NOT_INSTALLED',
        'source_inspection_sha256': SOURCE_INSPECTION_SHA,
        'source_catalog_sha256': SOURCE_CATALOG_SHA,
        'source_manifest': {name: digest(candidates[name]) for name in order}, 'build_order': order,
        'source_bytes': {name: len(candidates[name]) for name in order},
        'original_source_manifest': evidence['original_source_manifest'],
        'reviewed_helper_source_manifest': {name: digest(data) for name, data in originals.items() if name not in ORIGINAL_PINS},
        'original_public_declarations': len(original_headers), 'original_public_headers': original_headers,
        'origins': origins, 'prefix_parts': parts, 'closure_rows': rows,
        'filtered_vertices': evidence['filtered_vertices'], 'raw_literal_partition': evidence['raw_literal_partition'],
        'original_merged_sha256': evidence['original_merged_sha256'],
        'original_merged_bytes': evidence['original_merged_bytes'], 'scopes': scopes, 'scope_counts': scope_counts,
        'coverage_template_sha256': COVERAGE_TEMPLATE_SHA, 'model': {'tau': 1, 'nu': 1},
        'exact_merged_reconstruction': True, 'all_original_literal_definitions_byte_identical': True,
        'both_mutation_signs_and_global_indices_preserved': True,
        'requires_completed_foundation_and_sides': True, 'root_integration': False, 'main_theorem_complete': False,
    }
    return evidence, originals, candidates, plan


def main():
    assert len(sys.argv) == 5
    merged_path, archive, template_path, output = map(Path, sys.argv[1:])
    assert merged_path == REPOSITORY / 'D1Bound5' / (TARGET + '.lean')
    assert archive == ARCHIVE_DIRECTORY
    assert template_path == REPOSITORY / 'D1Bound5/SmallPairGraphClosure29Coverage.lean'
    assert output == OUTPUT_DIRECTORY / 'proposal'
    assert OUTPUT_DIRECTORY.is_dir() and not OUTPUT_DIRECTORY.is_symlink()
    assert not output.exists() and not output.is_symlink()
    catalog_bytes = read_source(SOURCE_CATALOG_PATH, SOURCE_CATALOG_SHA, SOURCE_CATALOG_BYTES)
    verify_catalog(catalog_bytes)
    inspection_path = OUTPUT_DIRECTORY / 'SOURCE_INSPECTION.json'
    inspection_bytes = read_source(inspection_path, SOURCE_INSPECTION_SHA, SOURCE_INSPECTION_BYTES)
    merged = read_source(merged_path, MERGED_SHA, MERGED_BYTES)
    archived = {name: read_source(archive / (name + '.lean'), expected, size)
                for name, (expected, size) in ORIGINAL_PINS.items()}
    template = read_source(template_path)
    evidence, originals, candidates, plan = build_candidates(merged, archived, template)
    assert (json.dumps(evidence, indent=2, sort_keys=True) + '\n').encode() == inspection_bytes
    assert read_source(merged_path, MERGED_SHA, MERGED_BYTES) == merged
    assert read_source(template_path) == template
    assert all(read_source(archive / (name + '.lean'), *ORIGINAL_PINS[name]) == data
               for name, data in archived.items())
    assert read_source(SOURCE_CATALOG_PATH, SOURCE_CATALOG_SHA, SOURCE_CATALOG_BYTES) == catalog_bytes
    assert read_source(inspection_path, SOURCE_INSPECTION_SHA, SOURCE_INSPECTION_BYTES) == inspection_bytes
    output.mkdir()
    (output / 'originals').mkdir()
    (output / 'candidates').mkdir()
    put(output / 'SmallPairGraphData24.merged.before.lean', merged)
    put(output / 'COVERAGE_TEMPLATE.before.lean', template)
    for name, data in originals.items():
        put(output / 'originals' / (name + '.lean'), data)
    for name in plan['build_order']:
        put(output / 'candidates' / (name + '.lean'), candidates[name])
    save(output / 'SOURCE_INSPECTION.json', evidence)
    save(output / 'PLAN.json', plan)
    save(output / 'DECLARATION_ORIGINS.json', plan['origins'])
    for scope, targets in plan['scopes'].items():
        save(output / (scope + '-TARGETS.json'), targets)
    save(output / 'INPUT_PROVENANCE.json', {
        'merged_path': str(merged_path.resolve()), 'archive_directory': str(archive.resolve()),
        'coverage_template_path': str(template_path.resolve()),
        'source_catalog_path': str(SOURCE_CATALOG_PATH),
        'source_inspection_path': str(inspection_path),
        'source_sha256': {str(merged_path.resolve()): digest(merged), str(template_path.resolve()): digest(template),
                         str(SOURCE_CATALOG_PATH): digest(catalog_bytes), str(inspection_path): digest(inspection_bytes),
                         **{str((archive / (name + '.lean')).resolve()): digest(data) for name, data in archived.items()}},
    })
    manifest = {str(path.relative_to(output)): digest(path.read_bytes()) for path in output.rglob('*') if path.is_file()}
    save(output / 'PAYLOAD_SHA256.json', manifest)
    print(json.dumps({'status': plan['status'], 'plan_sha256': digest((output / 'PLAN.json').read_bytes()),
                      'payload_sha256': digest((output / 'PAYLOAD_SHA256.json').read_bytes()),
                      'targets': len(plan['build_order']), 'scope_counts': plan['scope_counts'],
                      'closure_rows': plan['closure_rows'], 'filtered_vertices': plan['filtered_vertices'],
                      'prefix_counts': [part['count'] for part in plan['prefix_parts']],
                      'source_snapshot_stable': True,
                      'stability_scope': 'two sequential equal-byte reads of pinned inputs; not atomic',
                      'kernel_result': False, 'proof_or_queue_mutated': False}), flush=True)


if __name__ == '__main__':
    main()
