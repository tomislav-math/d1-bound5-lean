"""Read-only graph46 source inspection; stdout JSON only.

Run with /Users/tp/.local/bin/python3.12 -B inspect_graph46.py.
Reads only graph46 Lean sources and the eight named original archive sources.
No driver import, lock, subprocess, Git, network, compiler, or file write.
No acceptance, provenance-commit, kernel, or runtime-performance claim.
"""
from datetime import datetime, timezone
from pathlib import Path
import ast
import hashlib
import json
import re
import sys

ROOT = Path('/Users/tp/Lean/D1Bound5')
SOURCES = ROOT / 'D1Bound5'
ARCHIVE = ROOT / 'research/continuations/20261018T010800CEST-main-continuation/prepared-light-remaining39/D1Bound5'
REQUIRED = [
    'SmallPairLightData46', 'SmallPairLightAdaptiveData46',
    'SmallPairLightAdaptiveValidation46',
    'SmallPairLightAdaptiveLeft46_000', 'SmallPairLightAdaptiveLeft46_001',
    'SmallPairLightAdaptiveRight46_000', 'SmallPairLightAdaptiveRight46_001',
    'SmallPairLightLeft46', 'SmallPairLightRight46', 'SmallPairGraphData46',
]
ORIGINALS = [
    'SmallPairGraphInputs46', 'SmallPairGraphArithmetic46',
    'SmallPairGraphWitnessData46', 'SmallPairGraphClosure46',
    'SmallPairRawSelectedData46', 'SmallPairLightAssembly46',
    'SmallPairGraphTriangle46', 'SmallPairGraphData46',
]
LIGHT_FRAGMENTS = ['SmallPairLightData46' + suffix
                   for suffix in ('Left', 'LeftRows', 'Right', 'RightRows')]
MAX_FILE_BYTES = 5 * 1024 * 1024
SMALL_SOURCE_BYTES = 16384
MARKER = rb'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n'
DECLARATION = rb'^(def|theorem|lemma|abbrev)\s+(\S+)\s*(.*?)\s*:='
PROHIBITED = rb'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b'
WHITESPACE = b' \t\r\n'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def leading_imports(data):
    prefix = []
    for line in data.splitlines(keepends=True):
        if not re.fullmatch(rb'import D1Bound5\.\w+\n', line):
            break
        prefix.append(line)
    prefix = b''.join(prefix)
    return prefix, data[len(prefix):]


def boundary_parts(data):
    first = 0
    while first < len(data) and data[first] in WHITESPACE:
        first += 1
    last = len(data)
    while last > first and data[last - 1] in WHITESPACE:
        last -= 1
    return data[:first], data[first:last], data[last:]


def declarations(data):
    matches = list(re.finditer(DECLARATION, data, re.M | re.S))
    result = []
    for number, match in enumerate(matches):
        stack, opens = [], []
        for line in data[:match.start()].decode().splitlines():
            if line.startswith('namespace '):
                stack.append(line[10:].strip())
            elif line == 'end' or line.startswith('end '):
                if not stack:
                    raise ValueError('Unbalanced namespace before declaration')
                stack.pop()
            elif line.startswith('open '):
                opens.append(line)
        namespace = '.'.join(stack)
        stop = matches[number + 1].start() if number + 1 < len(matches) else len(data)
        closing = re.search(rb'^(?:end|namespace)(?:\s|$)', data[match.end():stop], re.M)
        if closing:
            stop = match.end() + closing.start()
        kind, name = match[1].decode(), match[2].decode()
        result.append({
            'kind': kind, 'local_name': name,
            'name': namespace + '.' + name if namespace else name,
            'namespace': namespace, 'opens': list(dict.fromkeys(opens)),
            'header': match[3].decode().strip(),
            'raw_header': data[match.start():match.end() - 2].decode(),
            'start_byte': match.start(), 'header_end_byte': match.end() - 2,
            'body_start_byte': match.end(), 'source_end_byte': stop,
            'source_sha256': digest(data[match.start():stop]),
        })
    return result


def list_end(data, start):
    depth = 0
    for index in range(start, len(data)):
        if data[index] == ord('['):
            depth += 1
        elif data[index] == ord(']'):
            depth -= 1
            if depth == 0:
                return index + 1
    raise ValueError('Unclosed literal list')


def top_level_items(raw):
    text = raw.decode()
    if not (text.startswith('[') and text.endswith(']')):
        raise ValueError('Not a list literal')
    body, stack, begin, items = text[1:-1], [], 0, []
    pairs = {')': '(', ']': '[', '⟩': '⟨'}
    for index, character in enumerate(body):
        if character in '([⟨':
            stack.append(character)
        elif character in ')]⟩':
            if not stack or stack.pop() != pairs[character]:
                raise ValueError('Unbalanced numeric literal')
        elif character == ',' and not stack:
            item = body[begin:index].strip()
            if not item:
                raise ValueError('Empty literal item')
            items.append(item)
            begin = index + 1
    if stack:
        raise ValueError('Unbalanced numeric literal')
    last = body[begin:].strip()
    if last:
        items.append(last)
    return items


def numeric_item(text):
    text = text.replace('⟨', '(').replace('⟩', ')')
    text = re.sub(r'\bnone\b', 'None', text)
    text = re.sub(r'\bsome\s+(\d+)\b', r'\1', text)
    if not re.fullmatch(r'[\s0-9\-\[\](),]+', text.replace('None', '0')):
        raise ValueError('Unsupported literal expression; no row count inferred')
    return ast.literal_eval(text)


def integer(value):
    return type(value) is int


def pair(value, predicate=integer):
    return isinstance(value, tuple) and len(value) == 2 and all(predicate(x) for x in value)


def literal_shape(name, rows):
    nat = lambda value: integer(value) and value >= 0
    if name in ('sieve',):
        valid, shape = all(pair(row, nat) for row in rows), 'list_of_natural_pairs'
    elif name in ('leftVertices', 'rightVertices', 'smallPairClosure_46', 'smallPairLarge_46'):
        valid, shape = all(pair(row) for row in rows), 'list_of_integer_coordinates'
    elif name in ('leftCached', 'rightCached'):
        valid = all(isinstance(row, tuple) and len(row) == 2 and pair(row[0])
                    and isinstance(row[1], list) and all(pair(value) for value in row[1]) for row in rows)
        shape = 'list_of_coordinate_signature_pairs'
    elif name in ('leftRows', 'rightRows'):
        valid = all(isinstance(row, tuple) and len(row) == 2 and nat(row[0])
                    and isinstance(row[1], list) and all(nat(value) for value in row[1]) for row in rows)
        shape = 'list_of_natural_and_natural_list_pairs'
    elif name == 'rootPairs':
        valid, shape = all(pair(row, pair) for row in rows), 'list_of_coordinate_pairs'
    elif name == 'destinations':
        valid = all(pair(row, lambda value: value is None or nat(value)) for row in rows)
        shape = 'list_of_optional_natural_pairs'
    else:
        valid, shape = True, 'restricted_numeric_literal_rows'
    if not valid:
        raise ValueError('Unexpected literal shape for ' + name)
    return shape


def describe(module, path, data):
    decls = declarations(data)
    literals = {}
    for declaration in decls:
        if declaration['kind'] != 'def':
            continue
        start = declaration['body_start_byte']
        while start < len(data) and data[start] in WHITESPACE:
            start += 1
        if data[start:start + 1] != b'[':
            continue
        end = list_end(data, start)
        if end > declaration['source_end_byte']:
            raise ValueError('Literal crosses a declaration boundary')
        raw = data[start:end]
        parsed = [numeric_item(item) for item in top_level_items(raw)]
        name = declaration['local_name']
        record = {'rows': len(parsed), 'shape': literal_shape(name, parsed),
                  'start_byte': start, 'end_byte': end, 'bytes': len(raw),
                  'sha256': digest(raw), 'declaration_start_byte': declaration['start_byte']}
        if name in ('leftCached', 'rightCached'):
            record['signature_lengths'] = sorted({len(row[1]) for row in parsed})
            record['coordinate_sequence_sha256'] = digest(json.dumps([row[0] for row in parsed], separators=(',', ':')).encode())
        if name in ('leftVertices', 'rightVertices'):
            record['coordinate_sequence_sha256'] = digest(json.dumps(parsed, separators=(',', ':')).encode())
        if name == 'destinations':
            indices = [value for row in parsed for value in row if value is not None]
            record['destination_index_min'] = min(indices) if indices else None
            record['destination_index_max'] = max(indices) if indices else None
        literals[name] = record
    return {
        'module': module, 'path': str(path), 'exists': True, 'sha256': digest(data), 'bytes': len(data),
        'imports': re.findall(r'^import ([^\n]+)', data.decode(), re.M),
        'namespaces': re.findall(r'^namespace (.+)$', data.decode(), re.M),
        'declarations': decls,
        'declaration_counts': {kind: sum(d['kind'] == kind for d in decls) for kind in ('def', 'theorem', 'lemma', 'abbrev')},
        'literals': literals,
        'forbidden_tokens': sorted({x.decode() for x in re.findall(PROHIBITED, data)}),
        'full_text': data.decode() if len(data) <= SMALL_SOURCE_BYTES else None,
    }


def partition_offsets(data, namespace, groups):
    matches = list(re.finditer(rb'^def (\w+)\s*:', data, re.M))
    expected = [name for group in groups.values() for name in group]
    if [m[1].decode() for m in matches] != expected:
        raise ValueError('Different definition inventory; proposed partition not derived')
    closings = list(re.finditer(rb'^end ' + re.escape(namespace.encode()) + rb'[ \t\r]*$', data, re.M))
    if len(closings) != 1 or closings[0].start() <= matches[-1].start():
        raise ValueError('Different namespace closure; proposed partition not derived')
    prefix, suffix = data[:matches[0].start()], data[closings[0].start():]
    if re.findall(rb'^namespace (\S+)\s*$', prefix, re.M) != [namespace.encode()]:
        raise ValueError('Different namespace prefix; proposed partition not derived')
    blocks, offsets = {}, {}
    for index, match in enumerate(matches):
        name = match[1].decode()
        end = matches[index + 1].start() if index + 1 < len(matches) else closings[0].start()
        blocks[name] = data[match.start():end]
        offsets[name] = {'start_byte': match.start(), 'end_byte': end,
                         'bytes': end - match.start(), 'sha256': digest(blocks[name])}
    if prefix + b''.join(blocks.values()) + suffix != data:
        raise ValueError('Definition partition reconstruction failed')
    fragments = {module: prefix + b''.join(blocks[name] for name in names) + suffix
                 for module, names in groups.items()}
    return {'source_sha256': digest(data), 'exact_byte_reconstruction': True,
            'prefix': {'start_byte': 0, 'end_byte': len(prefix), 'sha256': digest(prefix), 'text': prefix.decode()},
            'suffix': {'start_byte': closings[0].start(), 'end_byte': len(data), 'sha256': digest(suffix), 'text': suffix.decode()},
            'definition_offsets': offsets,
            'proposed_fragments': {name: {'definitions': groups[name], 'bytes': len(raw), 'sha256': digest(raw)}
                                   for name, raw in fragments.items()},
            'installed': False, 'compiled': False}


def archive_matches(merged, originals):
    markers = list(re.finditer(MARKER, merged, re.M))
    found, rebuilt = {}, []
    if not markers:
        return {'markers_found': False, 'all_matches': False, 'segments': {}}
    rebuilt.append(merged[:markers[0].start()])
    for index, marker in enumerate(markers):
        name = marker[1].decode()
        stop = markers[index + 1].start() if index + 1 < len(markers) else len(merged)
        segment = merged[marker.end():stop]
        leading, core, trailing = boundary_parts(segment)
        record = {'declared_original_sha256': marker[2].decode(),
                  'marker_start_byte': marker.start(), 'body_start_byte': marker.end(), 'body_end_byte': stop,
                  'merged_core_sha256': digest(core), 'merged_segment_sha256': digest(segment),
                  'merged_leading_whitespace': leading.decode(), 'merged_trailing_whitespace': trailing.decode(),
                  'archive_available': name in originals}
        if name in originals:
            original = originals[name]
            import_prefix, body = leading_imports(original)
            old_leading, old_core, old_trailing = boundary_parts(body)
            record.update(actual_original_sha256=digest(original), original_bytes=len(original),
                          original_import_prefix=import_prefix.decode(),
                          original_body_leading_whitespace=old_leading.decode(),
                          original_body_trailing_whitespace=old_trailing.decode(),
                          original_hash_matches_marker=digest(original) == marker[2].decode(),
                          original_core_matches_merged=old_core == core)
            rebuilt.extend((merged[marker.start():marker.end()], leading + old_core + trailing))
        else:
            rebuilt.extend((merged[marker.start():marker.end()], segment))
        found[name] = record
    names = [marker[1].decode() for marker in markers]
    complete = names == ORIGINALS and len(names) == len(set(names))
    complete = complete and all(row.get('original_hash_matches_marker') and row.get('original_core_matches_merged')
                                for row in found.values()) and b''.join(rebuilt) == merged
    return {'markers_found': True, 'marker_order': names, 'all_matches': complete,
            'exact_merged_reconstruction': complete,
            'merged_external_imports': re.findall(r'^import ([^\n]+)', merged[:markers[0].start()].decode(), re.M),
            'segments': found}


def adaptive_metadata(current):
    source = current.get('SmallPairLightAdaptiveData46', b'')
    definitions = {}
    for match in re.finditer(rb'^def (\w+)\s*:[^\n]*:= ([^\n]+)', source, re.M):
        definitions[match[1].decode()] = match[2].decode().strip()
    def offset(name, expected, seen=()):
        if name in seen:
            raise ValueError('Cyclic adaptive drop definitions')
        expression = definitions[name]
        if expression == 'PairLightPrepared46.' + expected:
            return 0
        match = re.fullmatch(r'(\w+)\.drop (\d+)', expression)
        if not match:
            raise ValueError('Unsupported adaptive offset expression: ' + name)
        return offset(match[1], expected, seen + (name,)) + int(match[2])
    blocks = []
    for module, data in sorted(current.items()):
        name_match = re.fullmatch(r'SmallPairLightAdaptive(Left|Right)46_(\d{3})', module)
        if not name_match:
            continue
        side = name_match[1].lower()
        for declaration in declarations(data):
            normalized = ' '.join(declaration['header'].split())
            match = re.fullmatch(r': pairLightSelectedFloorPrefixBool (\d+) (\d+) PairLightPrepared46\.sieve (\d+) (\w+) (\w+) = true', normalized)
            if not match:
                raise ValueError('Unsupported original adaptive parent header: ' + module)
            start = offset(match[4], side + 'Cached')
            row_start = offset(match[5], side + 'Rows')
            if start != row_start:
                raise ValueError('Cached/row adaptive offsets differ: ' + module)
            count = int(match[3])
            blocks.append({'module': module, 'side': side, 'block': name_match[2],
                           'tau': int(match[1]), 'nu': int(match[2]), 'head_count': count,
                           'global_start': start, 'global_end_exclusive': start + count,
                           'cached_definition': match[4], 'rows_definition': match[5],
                           'original_public_header': declaration['raw_header']})
    return {'definitions': definitions, 'blocks': blocks,
            'head_totals_by_side': {side: sum(b['head_count'] for b in blocks if b['side'] == side)
                                  for side in ('left', 'right')}}


def main():
    if not __debug__:
        raise RuntimeError('Do not disable inspection assertions')
    if len(sys.argv) != 1:
        raise SystemExit('Usage: python3.12 -B inspect_graph46.py; stdout JSON only')
    read_bytes, missing, errors = {}, set(), []
    def read(path):
        if path.is_symlink():
            raise ValueError('Symlink source rejected: ' + str(path))
        if not path.exists():
            missing.add(path)
            return None
        if not path.is_file() or path.stat().st_size > MAX_FILE_BYTES:
            raise ValueError('Unexpected source type or size: ' + str(path))
        if not path.resolve().is_relative_to(ROOT.resolve()):
            raise ValueError('Source outside fixed project: ' + str(path))
        data = path.read_bytes()
        if len(data) > MAX_FILE_BYTES or b'\0' in data:
            raise ValueError('Unexpected source contents: ' + str(path))
        data.decode()
        read_bytes[path] = data
        return data
    def attempt(label, operation):
        try:
            return operation()
        except (OSError, ValueError, SyntaxError, KeyError, UnicodeError, RecursionError) as error:
            errors.append({'check': label, 'error_type': type(error).__name__, 'detail': str(error)})
            return None
    names = list(dict.fromkeys(REQUIRED + LIGHT_FRAGMENTS + ORIGINALS))
    # Enumerate only graph46 adaptive siblings, so an unexpected extra original
    # block or prior partition is reported without scanning unrelated sources.
    adaptive_siblings = sorted(path for path in SOURCES.glob('SmallPairLightAdaptive*46_*.lean')
                               if re.fullmatch(r'SmallPairLightAdaptive(?:Left|Right)46_\d{3}(?:Part\d+[A-Za-z0-9_]*)?\.lean', path.name))
    names += [path.stem for path in adaptive_siblings if path.stem not in names]
    current, archived, records, archive_records = {}, {}, {}, {}
    for module in names:
        path = SOURCES / (module + '.lean')
        data = attempt('read:' + module, lambda path=path: read(path))
        if data is None:
            records[module] = {'path': str(path), 'exists': False}
        else:
            current[module] = data
            records[module] = attempt('source:' + module, lambda module=module, path=path, data=data: describe(module, path, data))
    for module in ORIGINALS:
        path = ARCHIVE / (module + '.lean')
        data = attempt('archive_read:' + module, lambda path=path: read(path))
        if data is None:
            archive_records[module] = {'path': str(path), 'exists': False}
        else:
            archived[module] = data
            archive_records[module] = attempt('archive_source:' + module, lambda module=module, path=path, data=data: describe(module, path, data))
    light_groups = {
        'SmallPairLightData46Left': ['sieve', 'leftVertices', 'leftCached'],
        'SmallPairLightData46LeftRows': ['leftRows'],
        'SmallPairLightData46Right': ['rightVertices', 'rightCached'],
        'SmallPairLightData46RightRows': ['rightRows'],
    }
    raw_groups = {'SmallPairRawSelectedData46' + side + kind: [side.lower() + kind]
                  for side in ('Left', 'Right') for kind in ('Cached', 'Rows')}
    light_partition = attempt('light_data_partition', lambda: partition_offsets(current['SmallPairLightData46'], 'D1Bound5.PairLightPrepared46', light_groups))
    raw_partition = attempt('raw_selected_partition', lambda: partition_offsets(archived['SmallPairRawSelectedData46'], 'D1Bound5.PairSelectedPrepared46', raw_groups))
    original_match = attempt('archive_matches', lambda: archive_matches(current['SmallPairGraphData46'], archived))
    adaptive = attempt('adaptive_blocks', lambda: adaptive_metadata(current))
    model = {}
    graph = current.get('SmallPairGraphData46', b'')
    for label in ('A', 'B'):
        match = re.search(rb'^def smallPair' + label.encode() + rb'_46\s*:\s*QuadInt (\d+) (\d+)\s*:=\s*([^\n]+)', graph, re.M)
        if match:
            model[label] = {'tau': int(match[1]), 'nu': int(match[2]), 'term': match[3].decode().strip(),
                            'definition_line': match[0].decode()}
        else:
            errors.append({'check': 'model_' + label, 'detail': 'Original scalar pair definition not found'})
    counts = {module: {name: record['rows'] for name, record in item.get('literals', {}).items()}
              for module, item in records.items() if item is not None and item.get('exists')}
    archive_counts = {module: {name: record['rows'] for name, record in item.get('literals', {}).items()}
                      for module, item in archive_records.items() if item is not None and item.get('exists')}
    checks = {}
    light = records.get('SmallPairLightData46') or {}
    if light.get('literals') and adaptive:
        for side in ('left', 'right'):
            lists = light['literals']
            values = [lists.get(side + kind, {}).get('rows') for kind in ('Vertices', 'Cached', 'Rows')]
            blocks = [block for block in adaptive['blocks'] if block['side'] == side]
            expected_start = 0
            contiguous = True
            for block in blocks:
                contiguous = contiguous and block['global_start'] == expected_start
                expected_start = block['global_end_exclusive']
            cached_coordinates = lists.get(side + 'Cached', {}).get('coordinate_sequence_sha256')
            vertex_coordinates = lists.get(side + 'Vertices', {}).get('coordinate_sequence_sha256')
            checks[side] = {'list_counts': values, 'all_three_lengths_equal': None not in values and len(set(values)) == 1,
                            'adaptive_blocks_contiguous_from_zero': contiguous and bool(blocks),
                            'adaptive_coverage_equals_literal_length': expected_start == values[0] and bool(blocks),
                            'cached_coordinates_match_vertices': isinstance(cached_coordinates, str)
                                and isinstance(vertex_coordinates, str) and cached_coordinates == vertex_coordinates}
    required_missing = [module for module in REQUIRED if module not in current]
    stable = True
    for path, data in read_bytes.items():
        if path.is_symlink() or not path.is_file() or path.read_bytes() != data:
            stable = False
            errors.append({'check': 'source_changed_during_inspection', 'path': str(path)})
    for path in missing:
        if path.exists() or path.is_symlink():
            stable = False
            errors.append({'check': 'missing_source_appeared_during_inspection', 'path': str(path)})
    incomplete = bool(errors or required_missing or not stable or not original_match or not original_match.get('all_matches'))
    result = {
        'schema': 1, 'status': 'READ_ONLY_SOURCE_INSPECTION_INCOMPLETE' if incomplete else 'READ_ONLY_SOURCE_INSPECTION_COMPLETE',
        'utc': datetime.now(timezone.utc).isoformat(), 'root': str(ROOT), 'archive_directory': str(ARCHIVE),
        'read_only': True, 'graph': 46, 'sources': records, 'archive_sources': archive_records,
        'original_archive_matches': original_match, 'model': model, 'adaptive_blocks': adaptive,
        'literal_counts': counts, 'archive_literal_counts': archive_counts,
        'light_data_partition_offsets': light_partition, 'raw_selected_partition_offsets': raw_partition,
        'side_consistency': checks, 'required_sources_missing': required_missing,
        'existing_light_fragments': [name for name in LIGHT_FRAGMENTS if name in current],
        'adaptive_sibling_modules': [path.stem for path in adaptive_siblings],
        'source_snapshot_stable': stable, 'read_source_sha256': {str(path): digest(data) for path, data in sorted(read_bytes.items())},
        'errors': errors, 'driver_state_obtained': False, 'locks_acquired': False,
        'lean_compiled': False, 'kernel_replayed': False, 'acceptance_claimed': False,
        'main_theorem_complete': False, 'root_integration': False,
    }
    print(json.dumps(result, ensure_ascii=False, separators=(',', ':')), flush=True)
    raise SystemExit(1 if incomplete else 0)


if __name__ == '__main__':
    main()
