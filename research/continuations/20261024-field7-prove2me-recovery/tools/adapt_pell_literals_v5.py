"""Exact, narrowly scoped Pell literal slices; no API, credentials or ledger writes."""
from __future__ import annotations

import ast
import copy
import re

from adapt_large_data import AdaptationError, canonical, digest, literal_rows
from adapt_cached_literals import append_expression, split_rows, token_count

TARGETS = {
    'D1Bound5_PellLightMatchingField23_Definitions': {
        'pellMagnitudes_23': 'List Int',
        'pellWitnesses_23': 'List (List (Nat × Nat))',
    },
    'D1Bound5_PellLightPrefixData1_Definitions_001': {
        'magnitudes_' + str(n): 'List Int' for n in (7, 15, 23, 31, 39, 47, 55, 71, 79)
    },
}
SHAPE = 'exact-pell-literal-split-v1'
BYTE_BUDGET = 20_000
TOKEN_BUDGET = 4_000
DIR = 'adaptations/pell-literals-v5/Definitions/'


def tables(source, target):
    if target not in TARGETS:
        raise AdaptationError('Unexpected Pell target')
    result = []
    for name, lean_type in TARGETS[target].items():
        pattern = (r'(?m)^[ \t]*(?P<modifier>noncomputable[ \t]+)?def[ \t]+'
                   + re.escape(name) + r'\s*:\s*' + re.escape(lean_type) + r'\s*:=\s*')
        found = list(re.finditer(pattern, source))
        if len(found) != 1:
            raise AdaptationError('Missing or ambiguous exact typed declaration: ' + name)
        match = found[0]
        start = match.end()
        if source[start:start+1] != '[':
            raise AdaptationError('Expected original literal list: ' + name)
        depth, end = 0, None
        for offset in range(start, len(source)):
            if source[offset] == '[':
                depth += 1
            elif source[offset] == ']':
                depth -= 1
                if depth == 0:
                    end = offset + 1
                    break
        if end is None:
            raise AdaptationError('Unterminated literal: ' + name)
        literal = source[start:end]
        if not literal.isascii() or re.search(r'[^0-9\s,\[\]()-]', literal):
            raise AdaptationError('Unsupported literal token: ' + name)
        expression = ast.parse(literal, mode='eval').body
        def natural(value):
            return isinstance(value, ast.Constant) and type(value.value) is int and value.value >= 0
        def integer(value):
            return natural(value) or (isinstance(value, ast.UnaryOp) and isinstance(value.op, ast.USub) and natural(value.operand))
        def row_valid(value):
            if lean_type == 'List Int':
                return integer(value)
            return (isinstance(value, ast.List) and all(
                isinstance(pair, ast.Tuple) and len(pair.elts) == 2 and all(natural(v) for v in pair.elts)
                for pair in value.elts))
        if not isinstance(expression, ast.List) or not all(row_valid(row) for row in expression.elts):
            raise AdaptationError('Wrong numeric literal shape: ' + name)
        if not expression.elts:
            continue  # Preserve each original empty list verbatim.
        rows = [ast.get_source_segment(literal, row) for row in expression.elts]
        if any(row is None for row in rows):
            raise AdaptationError('Missing exact literal row source')
        chunks = split_rows(rows, BYTE_BUDGET, TOKEN_BUDGET)
        if [row for chunk in chunks for row in chunk] != rows:
            raise AdaptationError('Row order changed')
        if ast.literal_eval(literal_rows([row for chunk in chunks for row in chunk])) != ast.literal_eval(literal):
            raise AdaptationError('Literal value changed')
        result.append(dict(target=target, name=name, lean_type=lean_type, noncomputable=bool(match.group('modifier')),
                           start=start, end=end, literal=literal, rows=rows, chunks=chunks))
    return sorted(result, key=lambda table: table['start'])


def helper_parts(table, rows, index):
    literal = literal_rows(rows)
    identifier = digest(canonical([table['target'], table['name'], index, table['lean_type'], table['noncomputable'], literal]))[:20]
    constant = 'pellSlice_' + identifier
    name = 'D1Bound5_Prove2MeTransfer_' + constant
    lean_name = 'D1Bound5.Prove2MeTransfer.' + constant
    unit = 'pell_slice_' + identifier
    body = ('import Init\n\nnamespace D1Bound5.Prove2MeTransfer\n'
            'set_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n'
            + ('noncomputable ' if table['noncomputable'] else '')
            + 'def ' + constant + ' : ' + table['lean_type'] + ' :=\n'
            + literal + '\n\nend D1Bound5.Prove2MeTransfer\n')
    return name, lean_name, unit, body


def expected(old_node):
    target = old_node['name']
    if old_node['kind'] != 'definition' or old_node.get('existing_binding'):
        raise AdaptationError('Original must be an unpublished definition')
    source = old_node['payload']['definition']
    found = tables(source, target)
    helpers, records = {}, []
    for table in found:
        first, slices = 0, []
        for index, rows in enumerate(table['chunks']):
            name, lean_name, unit, body = helper_parts(table, rows, index)
            derived = dict(parent=target, declaration=table['name'], rows=[first, first+len(rows)],
                           original_literal_sha256=digest(table['literal'].encode()))
            helper = dict(name=name, kind='definition', unit_id=unit,
                payload=dict(definition_name=name, definition_title='Exact Pell data slice ' + unit.removeprefix('pell_slice_'),
                    definition=body, env=old_node['payload']['env'], private=True,
                    natural_language_statement=f"Exact consecutive entries {first+1}–{first+len(rows)} of {table['name']}. The original list is the ordered concatenation of these slices.",
                    source=old_node['payload']['source'] + f". Exact entries {first+1}-{first+len(rows)} of {table['name']}; original literal SHA-256 {derived['original_literal_sha256']}.",
                    tags=list(old_node['payload'].get('tags', []))),
                publish_dependencies=[], proof_dependencies=[], source_blocks=[],
                definition_file=DIR+'Def_'+name+'.lean', definition_sha256=digest(body.encode()),
                metadata_status='EXACT_LITERAL_DATA_SLICE', source_derived_from=derived)
            if name in helpers and helpers[name] != helper:
                raise AdaptationError('Helper collision')
            helpers[name] = helper
            slices.append(dict(name=name, rows=derived['rows'], source_sha256=digest(body.encode()),
                               ordered_rows_sha256=digest(canonical(rows))))
            first += len(rows)
        records.append(dict(declaration=table['name'], declared_type=table['lean_type'],
            noncomputable=table['noncomputable'], literal_sha256=digest(table['literal'].encode()),
            rows=len(table['rows']), ordered_rows_sha256=digest(canonical(table['rows'])), slices=slices,
            original_literal_bytes=len(table['literal'].encode()), original_literal_tokens=token_count(table['literal']),
            chunk_rows=[len(rows) for rows in table['chunks']],
            max_chunk_literal_bytes=max(len(literal_rows(rows).encode()) for rows in table['chunks']),
            max_chunk_literal_tokens=max(token_count(literal_rows(rows)) for rows in table['chunks'])))
    body = source
    for table in reversed(found):
        names = [helper_parts(table, rows, index)[1] for index, rows in enumerate(table['chunks'])]
        body = body[:table['start']] + append_expression(names) + body[table['end']:]
    body = ''.join('import Definitions.Def_' + name + '\n' for name in helpers) + body
    if len(body.encode()) >= len(source.encode()):
        raise AdaptationError('Target did not shrink')
    revised = copy.deepcopy(old_node)
    revised['payload']['definition'] = body
    revised['definition_file'] = DIR + 'Def_' + target + '.lean'
    revised['definition_sha256'] = digest(body.encode())
    for key in ('publish_dependencies', 'proof_dependencies'):
        revised[key] = sorted(set(revised.get(key, [])) | set(helpers))
    provenance = dict(shape=SHAPE, byte_budget=BYTE_BUDGET, token_budget=TOKEN_BUDGET,
                      old_source_sha256=digest(source.encode()), new_source_sha256=digest(body.encode()),
                      declarations=records)
    return revised, helpers, provenance


def verify_adaptation(old_node, new_node, all_new_nodes, provenance):
    revised, helpers, exact_provenance = expected(old_node)
    if provenance != exact_provenance or canonical(revised) != canonical(new_node):
        raise AdaptationError('Pell literal replacement/provenance differs from exact reconstruction')
    registry = all_new_nodes if isinstance(all_new_nodes, dict) else {n['name']: n for n in all_new_nodes}
    for name, helper in helpers.items():
        if canonical(registry.get(name)) != canonical(helper):
            raise AdaptationError('Pell helper differs from original numeric rows: ' + name)
    return dict(helper_names=list(helpers), declarations=len(provenance['declarations']), exact_source_reconstruction=True)


def patch_manifest(manifest):
    if manifest.get('private') is not True:
        raise AdaptationError('Manifest must remain private')
    originals = {n['name']: n for n in manifest['nodes']}
    if len(originals) != len(manifest['nodes']) or not set(TARGETS) <= originals.keys():
        raise AdaptationError('Duplicate or missing target')
    new = copy.deepcopy(manifest)
    replacements, additions, changes, artifacts = {}, {}, [], {}
    for name in TARGETS:
        revised, helpers, provenance = expected(originals[name])
        if set(helpers) & (originals.keys() | additions.keys()):
            raise AdaptationError('New helper identity collision')
        replacements[name] = revised
        additions.update(helpers)
        changes.append(dict(name=name, reason='Repeated terminal scanner timeout; exact bounded typed literal slices',
            old_source_bytes=len(originals[name]['payload']['definition'].encode()),
            new_source_bytes=len(revised['payload']['definition'].encode()), adaptation_provenance=provenance))
        for node in [*helpers.values(), revised]:
            artifacts[node['definition_file']] = node['payload']['definition']
    new['nodes'] = list(additions.values()) + [replacements.get(n['name'], n) for n in new['nodes']]
    registry = {n['name']: n for n in new['nodes']}
    for name in TARGETS:
        provenance = next(c['adaptation_provenance'] for c in changes if c['name'] == name)
        verify_adaptation(originals[name], registry[name], registry, provenance)
    report = dict(schema='p2m-pell-literal-adaptation-v5', reason='Two repeated token-scanner timeouts; exact typed literal slices without original declaration or proof changes',
        changed_nodes=changes, added_nodes=list(additions), unchanged_nodes_verified=len(originals)-len(TARGETS),
        original_source_files_modified=0, all_original_context_types_proofs_preserved=True,
        equality_reason='Init List.append unfolds to the exact original ordered List.cons values; helpers use the same original declared element types.',
        artifacts={path:dict(bytes=len(body.encode()),sha256=digest(body.encode())) for path,body in artifacts.items()})
    return new, artifacts, report
