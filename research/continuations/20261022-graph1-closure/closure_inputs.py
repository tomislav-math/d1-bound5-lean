"""Pure graph1 merged-source inspection and exact raw-literal partitioning.

No subprocess, compiler, Git, project mutation, or proof acceptance occurs here.
The merged source and the eight archive pins were supplied by actual inspection.
"""
from pathlib import Path
import ast
import hashlib
import re


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')

TARGET = 'SmallPairGraphData1'
RAW = 'SmallPairRawSelectedData1'
MERGED_SHA = 'b0bceb6340003eab18f64c436c6a4b70f1c8eb14a7d185892b2e4c314665a808'
MERGED_BYTES = 2195796
ORIGINAL_PINS = {
    'SmallPairGraphInputs1': ('5cd545bd15a06ecc43d8cfba5534724ca9e4bb3b996df32ac26455f986ee06da', 414855),
    'SmallPairGraphArithmetic1': ('4cf70ea7f533f7bcf9c1290bafbe049be2d7c2be79e22d2ce03e1d504275229c', 555),
    'SmallPairGraphWitnessData1': ('063d9f2152729e1b0ab7730807fc92406c944c3189084df1d046e572be4c6174', 432565),
    'SmallPairGraphClosure1': ('bd41e1f8926b8f039cac203d25868ad0ec5bfaf8a02d14bebbf0f0694d38548f', 720),
    RAW: ('db148b0fb761a79b93b710ca93f37aee5d098fb0b0027f8e4d329e08a3b2dd72', 1343784),
    'SmallPairLightAssembly1': ('aa4d0f7e0c25b110a19624502dedc5a05c11705261bb7992594a13587facbf72', 2022),
    'SmallPairGraphTriangle1': ('0426ce832b04f05b1b392fd627413c51849a8a7583e14e613e0b14c9a68b6e7b', 389),
    TARGET: ('c3a89df917ce69a6a97de4d1e310bea197d359c8968e77cffbe5135810c8e559', 121),
}
RAW_GROUPS = {
    RAW + 'LeftCached': ['leftCached'],
    RAW + 'LeftRows': ['leftRows'],
    RAW + 'RightCached': ['rightCached'],
    RAW + 'RightRows': ['rightRows'],
}
MARKER = rb'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n'
PROHIBITED = rb'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b'
WHITESPACE = b' \t\r\n'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def read_source(path):
    path = Path(path)
    assert path.is_file() and not path.is_symlink(), str(path)
    return path.read_bytes()


def top_imports(data):
    """Separate the exact leading import-line bytes from all remaining bytes."""
    lines = data.splitlines(keepends=True)
    imported, modules = [], []
    for line in lines:
        match = re.fullmatch(rb'import D1Bound5\.(\w+)\n', line)
        if not match:
            break
        imported.append(line)
        modules.append(match[1].decode())
    prefix = b''.join(imported)
    body = data[len(prefix):]
    assert not re.search(rb'^import\b', body, re.M), 'Non-leading or unsupported import'
    assert prefix + body == data
    return modules, prefix, body


def boundary_parts(data):
    """Record boundary whitespace explicitly; callers never discard it silently."""
    begin = 0
    while begin < len(data) and data[begin] in WHITESPACE:
        begin += 1
    end = len(data)
    while end > begin and data[end - 1] in WHITESPACE:
        end -= 1
    return data[:begin], data[begin:end], data[end:]


def declarations(text):
    matches = list(re.finditer(r'^(def|theorem)\s+(\S+)\s*(.*?)\s*:=', text, re.M | re.S))
    result = []
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
        assert namespace == 'D1Bound5' or namespace.startswith('D1Bound5.')
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        closing = re.search(r'^end(?:\s|$)', text[match.end():end], re.M)
        if closing:
            end = match.end() + closing.start()
        result.append({'kind': match[1], 'local_name': match[2], 'name': namespace + '.' + match[2],
                       'namespace': namespace, 'opens': list(dict.fromkeys(opens)),
                       'header': match[3].strip(), 'raw_header': text[match.start():match.end() - 2],
                       'source_text': text[match.start():end]})
    names = [item['name'] for item in result]
    assert len(names) == len(set(names))
    return result


def literal(data, name):
    expression = rb'^def ' + re.escape(name.encode()) + rb'\s*:[^\n]*:= \[\n(.*?)^\]\n'
    matches = list(re.finditer(expression, data, re.M | re.S))
    assert len(matches) == 1, name
    match = matches[0]
    rows = match[1].splitlines()
    assert rows and all(row.startswith(b'  ') and row.strip() for row in rows), name
    return rows, data[match.start():match.end()]


def numeric_row(row):
    text = row.decode().strip().removesuffix(',').replace('⟨', '(').replace('⟩', ')')
    assert re.fullmatch(r'[\s\d\-\[\](),]+', text), 'Non-numeric literal expression'
    return ast.literal_eval(text)


def pair_of_ints(value):
    return isinstance(value, tuple) and len(value) == 2 and all(type(item) is int for item in value)


def destination_row(row):
    match = re.fullmatch(rb'  \((none|some \d+), (none|some \d+)\),?', row)
    assert match, row[:100]
    return tuple(None if item == b'none' else int(item[5:]) for item in match.groups())


def split_raw(original):
    matches = list(re.finditer(rb'^def (\w+)\s*:', original, re.M))
    names = [name for group in RAW_GROUPS.values() for name in group]
    assert [match[1].decode() for match in matches] == names
    prefix = original[:matches[0].start()]
    namespaces = re.findall(rb'^namespace (\S+)\s*$', prefix, re.M)
    assert namespaces == [b'D1Bound5.PairSelectedPrepared1']
    closings = list(re.finditer(rb'^end D1Bound5\.PairSelectedPrepared1\s*$', original, re.M))
    assert len(closings) == 1 and closings[0].start() > matches[-1].start()
    end = closings[0].start()
    suffix = original[end:]
    assert re.fullmatch(rb'end D1Bound5\.PairSelectedPrepared1[ \t\r\n]*', suffix)
    blocks = {match[1].decode(): original[match.start():matches[index + 1].start()
                                         if index + 1 < len(matches) else end]
              for index, match in enumerate(matches)}
    assert prefix + b''.join(blocks.values()) + suffix == original
    assert top_imports(prefix)[0] == ['SmallPairGraphInputs1', 'PairCachedResidues', 'SmallPairSieve_0_1']
    fragments = {module: prefix + b''.join(blocks[name] for name in names) + suffix
                 for module, names in RAW_GROUPS.items()}
    for module, selected in RAW_GROUPS.items():
        before = {item['local_name']: item for item in declarations(original.decode())}
        assert declarations(fragments[module].decode()) == [before[name] for name in selected]
        assert top_imports(fragments[module])[0] == top_imports(original)[0]
    return fragments, blocks, prefix, suffix


def inspect(merged, originals):
    assert digest(merged) == MERGED_SHA and len(merged) == MERGED_BYTES
    assert list(originals) == list(ORIGINAL_PINS)
    assert not re.search(PROHIBITED, merged)
    markers = list(re.finditer(MARKER, merged, re.M))
    assert [match[1].decode() for match in markers] == list(ORIGINAL_PINS)
    merged_prefix = merged[:markers[0].start()]
    merged_imports, prefix_import_bytes, prefix_remaining = top_imports(merged_prefix)
    assert all(byte in WHITESPACE for byte in prefix_remaining)
    rebuilt = [merged_prefix]
    records, headers, original_records = {}, [], {}
    for index, match in enumerate(markers):
        name = match[1].decode()
        data = originals[name]
        expected, size = ORIGINAL_PINS[name]
        assert digest(data) == expected == match[2].decode() and len(data) == size, name
        assert not re.search(PROHIBITED, data), name
        imports, import_bytes, archive_body = top_imports(data)
        archive_leading, archive_core, archive_trailing = boundary_parts(archive_body)
        stop = markers[index + 1].start() if index + 1 < len(markers) else len(merged)
        segment = merged[match.end():stop]
        segment_leading, segment_core, segment_trailing = boundary_parts(segment)
        assert archive_core == segment_core, name
        assert import_bytes + archive_leading + archive_core + archive_trailing == data
        rebuilt_segment = segment_leading + archive_core + segment_trailing
        assert rebuilt_segment == segment
        rebuilt.extend((merged[match.start():match.end()], rebuilt_segment))
        found = declarations(data.decode())
        public = [{key: value for key, value in item.items() if key != 'source_text'} for item in found]
        original_records[name] = public
        headers.extend((item['kind'], item['name'], item['raw_header']) for item in found)
        records[name] = {
            'original_sha256': expected, 'original_bytes': size, 'original_imports': imports,
            'original_import_prefix': import_bytes.decode(),
            'archive_body_leading_whitespace': archive_leading.decode(),
            'archive_body_trailing_whitespace': archive_trailing.decode(),
            'preserved_core_sha256': digest(archive_core), 'preserved_core_bytes': len(archive_core),
            'merged_marker_start': match.start(), 'merged_body_start': match.end(), 'merged_body_end': stop,
            'merged_marker': merged[match.start():match.end()].decode(),
            'merged_segment_sha256': digest(segment), 'merged_segment_bytes': len(segment),
            'merged_segment_leading_whitespace': segment_leading.decode(),
            'merged_segment_trailing_whitespace': segment_trailing.decode(),
            'exact_reconstruction': True,
            'declaration_source_sha256': {item['name']: digest(item['source_text'].encode()) for item in found},
        }
    assert b''.join(rebuilt) == merged
    merged_headers = [(item['kind'], item['name'], item['raw_header']) for item in declarations(merged.decode())]
    assert headers == merged_headers
    assert len(headers) == 28 and sum(item[0] == 'def' for item in headers) == 13
    assert sum(item[0] == 'theorem' for item in headers) == 15
    values, literals = {}, {}
    for module, names in [
        ('SmallPairGraphInputs1', ['smallPairClosure_1', 'smallPairLarge_1']),
        ('SmallPairGraphWitnessData1', ['rootPairs', 'destinations']),
        (RAW, ['leftCached', 'leftRows', 'rightCached', 'rightRows']),
    ]:
        for name in names:
            rows, block = literal(originals[module], name)
            parsed = [destination_row(row) if name == 'destinations' else numeric_row(row) for row in rows]
            values[name] = parsed
            literals[name] = {'original_module': module, 'rows': len(rows),
                              'literal_sha256': digest(block), 'literal_bytes': len(block)}
    for name in ('smallPairClosure_1', 'smallPairLarge_1'):
        assert all(pair_of_ints(value) for value in values[name]), name
    assert all(isinstance(value, tuple) and len(value) == 2 and all(pair_of_ints(item) for item in value)
               for value in values['rootPairs'])
    for name in ('leftCached', 'rightCached'):
        assert all(isinstance(value, tuple) and len(value) == 2 and pair_of_ints(value[0])
                   and isinstance(value[1], list) and all(pair_of_ints(item) for item in value[1])
                   for value in values[name]), name
    for name in ('leftRows', 'rightRows'):
        assert all(isinstance(value, tuple) and len(value) == 2 and type(value[0]) is int and value[0] >= 0
                   and isinstance(value[1], list) and all(type(item) is int and item >= 0 for item in value[1])
                   for value in values[name]), name
    rows = len(values['smallPairClosure_1'])
    assert len(values['rootPairs']) == len(values['destinations']) == rows
    assert len(values['leftCached']) == len(values['leftRows'])
    assert len(values['rightCached']) == len(values['rightRows'])
    assert len(values['leftCached']) + len(values['rightCached']) == len(values['smallPairLarge_1'])
    indices = [item for pair in values['destinations'] for item in pair if item is not None]
    assert indices and all(0 <= item < rows for item in indices)
    fragments, raw_blocks, raw_prefix, raw_suffix = split_raw(originals[RAW])
    parts = [{'module': 'SmallPairGraphClosure1Chunk' + f'{index:02d}', 'offset': offset,
              'count': min(64, rows - offset)} for index, offset in enumerate(range(0, rows, 64))]
    assert [row for part in parts for row in range(part['offset'], part['offset'] + part['count'])] == list(range(rows))
    return {
        'schema': 1, 'status': 'ACTUAL_GRAPH1_CLOSURE_SOURCE_INSPECTION_NOT_A_KERNEL_RESULT',
        'original_merged_sha256': digest(merged), 'original_merged_bytes': len(merged),
        'merged_prefix_sha256': digest(merged_prefix), 'merged_prefix': merged_prefix.decode(),
        'merged_external_imports': merged_imports, 'exact_merged_reconstruction': True,
        'original_source_manifest': {name: expected for name, (expected, _) in ORIGINAL_PINS.items()},
        'original_source_bytes': {name: size for name, (_, size) in ORIGINAL_PINS.items()},
        'merged_segments': records, 'original_declarations': original_records,
        'declaration_counts': {'total': 28, 'definitions': 13, 'theorems': 15},
        'literal_evidence': literals, 'closure_rows': rows,
        'filtered_vertices': len(values['smallPairLarge_1']),
        'destination_index_min': min(indices), 'destination_index_max': max(indices),
        'raw_literal_partition': {
            'original_module': RAW, 'groups': RAW_GROUPS, 'namespace': 'D1Bound5.PairSelectedPrepared1',
            'definition_sha256': {name: digest(block) for name, block in raw_blocks.items()},
            'prefix_sha256': digest(raw_prefix), 'suffix_sha256': digest(raw_suffix),
            'source_manifest': {name: digest(data) for name, data in fragments.items()},
            'source_bytes': {name: len(data) for name, data in fragments.items()},
            'exact_byte_reconstruction': True, 'original_imports_preserved_in_each_data_module': True,
        },
        'proposed_prefix_parts': parts, 'proposed_terminal_drop': rows,
        'source_preservation_only': True, 'root_integration': False, 'main_theorem_complete': False,
    }
