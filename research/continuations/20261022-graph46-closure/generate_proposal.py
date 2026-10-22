"""Prepare graph46 closure candidate files without touching the project tree.

Usage: python3 -B generate_proposal.py MERGED ARCHIVES COVERAGE_TEMPLATE NEW_OUTPUT
The complete output is an uninstalled source proposal, never a proof result.
"""
from pathlib import Path
import json
import re
import sys

from closure_inputs import (
    ORIGINAL_PINS, PROHIBITED, RAW, RAW_GROUPS, TARGET, declarations,
    digest, inspect, read_source, split_raw, top_imports,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')

COVERAGE_TEMPLATE_SHA = '16bbbcfa2e81413a9c2553d413b4d7d2e2f9203e70dc18f06687328ff90afce1'
COVERAGE = 'SmallPairGraphClosure46Coverage'
CLOSURE = 'SmallPairGraphClosure46'


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
    assert evidence['closure_rows'] == 719 and evidence['filtered_vertices'] == 718
    input_declarations = {item['local_name']: item for item in declarations(archived['SmallPairGraphInputs46'].decode())}
    witness_declarations = {item['local_name']: item for item in declarations(archived['SmallPairGraphWitnessData46'].decode())}
    assert input_declarations['smallPairA_46']['header'] == ': QuadInt 1 6'
    assert input_declarations['smallPairB_46']['header'] == ': QuadInt 1 6'
    assert input_declarations['smallPairClosure_46']['header'] == ': List (QuadInt 1 6)'
    assert input_declarations['smallPairLarge_46']['header'] == ': List (QuadInt 1 6)'
    assert witness_declarations['anchorRoot']['header'] == ': QuadInt 1 6'
    assert witness_declarations['rootPairs']['header'] == ': List (QuadInt 1 6 × QuadInt 1 6)'
    assert witness_declarations['witnesses']['header'] == ': List (PairRootWitness 1 6)'
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
    assert [part['count'] for part in parts] == [64] * 11 + [15]
    for index, part in enumerate(parts):
        name, offset, count = part['module'], part['offset'], part['count']
        text = f"""import D1Bound5.SmallPairGraphWitnessData46
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared46
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk{index:02d}_checked :
    pairIndexedWitnessesPrefixBool smallPairA_46 smallPairB_46 anchorRoot
      (10^1100) smallPairClosure_46 {count}
      (witnesses.drop {offset}) (destinations.drop {offset}) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared46
"""
        candidates[name] = originals[name] = text.encode()
    coverage = coverage_template.decode()
    assert coverage.count('QuadInt 1 1') == 3
    for old, new in [('SmallPairGraphWitnessData29', 'SmallPairGraphWitnessData46'),
                     ('PairGraphPrepared29', 'PairGraphPrepared46'),
                     ('smallPairA_29', 'smallPairA_46'), ('smallPairB_29', 'smallPairB_46'),
                     ('smallPairClosure_29', 'smallPairClosure_46')]:
        assert old in coverage
        coverage = coverage.replace(old, new)
    coverage = coverage.replace('QuadInt 1 1', 'QuadInt 1 6')
    assert coverage.count('QuadInt 1 6') == 3 and '29' not in coverage
    candidates[COVERAGE] = originals[COVERAGE] = coverage.encode()
    assert re.search(rb'^def witnesses[^\n]*:=\n  List\.zipWith', archived['SmallPairGraphWitnessData46'], re.M)

    old = archived[CLOSURE].decode()
    starts = list(re.finditer(r'^theorem ', old, re.M))
    assert len(starts) == 2
    original_imports, original_import_bytes, original_body = top_imports(archived[CLOSURE])
    assert original_imports == ['SmallPairGraphWitnessData46', 'PairClosureIndexedWitness']
    prefix = old[len(original_import_bytes):starts[0].start()]
    first_header = old[starts[0].start():old.index(':=', starts[0].start())]
    unchanged_suffix = old[starts[1].start():]
    assert first_header.startswith('theorem PairGraphPrepared46.indexed_checked :')
    assert unchanged_suffix.startswith('theorem smallPairClosure_46_checked :')
    proof = f"""  apply pairClosureIndexedWitnessBool_of_checked_parts
    smallPairA_46 smallPairB_46 anchorRoot (10^1100) smallPairClosure_46
    witnesses destinations indexed_coverage_checked
  have h{rows:03d} : pairIndexedWitnessesCheckedBool smallPairA_46 smallPairB_46 anchorRoot
      (10^1100) smallPairClosure_46 (witnesses.drop {rows}) (destinations.drop {rows}) = true := by
    rfl
"""
    for index, part in reversed(list(enumerate(parts))):
        offset, count = part['offset'], part['count']
        proof += f"""  have h{offset:03d} : pairIndexedWitnessesCheckedBool smallPairA_46 smallPairB_46 anchorRoot
      (10^1100) smallPairClosure_46 (witnesses.drop {offset}) (destinations.drop {offset}) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_46 smallPairB_46 anchorRoot (10^1100) smallPairClosure_46 {count}
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
    assert candidates[CLOSURE].decode()[candidates[CLOSURE].decode().index('theorem smallPairClosure_46_checked'):] == unchanged_suffix
    for name in set(ORIGINAL_PINS) - {RAW, CLOSURE}:
        assert candidates[name] == archived[name], name

    core = ['SmallPairGraphInputs46', 'SmallPairGraphWitnessData46'] + [part['module'] for part in parts] + [COVERAGE, CLOSURE]
    assembly = ['SmallPairGraphArithmetic46'] + list(RAW_GROUPS) + [RAW, 'SmallPairLightAssembly46', 'SmallPairGraphTriangle46', TARGET]
    order = core + assembly
    assert len(order) == len(set(order)) and set(order) == set(candidates)
    pilot = ['SmallPairGraphInputs46', 'SmallPairGraphWitnessData46', parts[0]['module'], COVERAGE]
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
    plan = {
        'status': 'REVIEWED_GRAPH46_CLOSURE_SOURCE_PROPOSAL_NOT_INSTALLED',
        'source_manifest': {name: digest(candidates[name]) for name in order}, 'build_order': order,
        'source_bytes': {name: len(candidates[name]) for name in order},
        'original_source_manifest': evidence['original_source_manifest'],
        'reviewed_helper_source_manifest': {name: digest(data) for name, data in originals.items() if name not in ORIGINAL_PINS},
        'original_public_declarations': len(original_headers), 'original_public_headers': original_headers,
        'origins': origins, 'prefix_parts': parts, 'closure_rows': rows,
        'filtered_vertices': evidence['filtered_vertices'], 'raw_literal_partition': evidence['raw_literal_partition'],
        'original_merged_sha256': evidence['original_merged_sha256'],
        'original_merged_bytes': evidence['original_merged_bytes'], 'scopes': scopes, 'scope_counts': scope_counts,
        'coverage_template_sha256': COVERAGE_TEMPLATE_SHA, 'model': {'tau': 1, 'nu': 6},
        'exact_merged_reconstruction': True, 'all_original_literal_definitions_byte_identical': True,
        'both_mutation_signs_and_global_indices_preserved': True,
        'requires_completed_foundation_and_sides': True, 'root_integration': False, 'main_theorem_complete': False,
    }
    return evidence, originals, candidates, plan


def main():
    assert len(sys.argv) == 5
    merged_path, archive, template_path, output = map(Path, sys.argv[1:])
    assert not output.exists() and not output.is_symlink()
    merged = read_source(merged_path)
    archived = {name: read_source(archive / (name + '.lean')) for name in ORIGINAL_PINS}
    template = read_source(template_path)
    evidence, originals, candidates, plan = build_candidates(merged, archived, template)
    assert read_source(merged_path) == merged and read_source(template_path) == template
    assert all(read_source(archive / (name + '.lean')) == data for name, data in archived.items())
    output.mkdir()
    (output / 'originals').mkdir()
    (output / 'candidates').mkdir()
    put(output / 'SmallPairGraphData46.merged.before.lean', merged)
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
        'source_sha256': {str(merged_path.resolve()): digest(merged), str(template_path.resolve()): digest(template),
                         **{str((archive / (name + '.lean')).resolve()): digest(data) for name, data in archived.items()}},
    })
    manifest = {str(path.relative_to(output)): digest(path.read_bytes()) for path in output.rglob('*') if path.is_file()}
    save(output / 'PAYLOAD_SHA256.json', manifest)
    print(json.dumps({'status': plan['status'], 'plan_sha256': digest((output / 'PLAN.json').read_bytes()),
                      'payload_sha256': digest((output / 'PAYLOAD_SHA256.json').read_bytes()),
                      'targets': len(plan['build_order']), 'scope_counts': plan['scope_counts'],
                      'closure_rows': plan['closure_rows'], 'filtered_vertices': plan['filtered_vertices'],
                      'prefix_counts': [part['count'] for part in plan['prefix_parts']]}), flush=True)


if __name__ == '__main__':
    main()
