"""Pure graph43 merged-source inspection and exact raw-literal partitioning.

No subprocess, compiler, Git, project mutation, or proof acceptance occurs here.
The merged source and the eight archive pins were supplied by actual inspection.
"""
from pathlib import Path
import ast
import hashlib
import re


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')

TARGET = 'SmallPairGraphData43'
RAW = 'SmallPairRawSelectedData43'
MERGED_SHA = 'c8b0e4d07c00c5f0487a39f9e38ea0985ad50064dcbbaff514849bf0dc886ec2'
MERGED_BYTES = 2201748
ORIGINAL_PINS = {'SmallPairGraphInputs43': ('4f8fe115d6404e1d98e2072adad71686b983e444069ed6e86739c4ba59ead417', 555035), 'SmallPairGraphArithmetic43': ('e5f34b379ce5169c43ac116b737d74c40f2d6c8e9799f87b666db23e5ef5c3f2', 567), 'SmallPairGraphWitnessData43': ('9dedcb1381b8d96deb7061067833410f8e6c6541ff04be6c3d57d380c7f29cd8', 578095), 'SmallPairGraphClosure43': ('d73ec88844775660cbbcbe575180e6aaf2bd2865d9392acaecd7f4d36b13fdb2', 734), 'SmallPairRawSelectedData43': ('4ec9cdf67e2fc91216a258db43373d2698e83460bab30b291ebfb01d36752cc9', 1063966), 'SmallPairLightAssembly43': ('a1f93b85259f267bea1466e442343da00fa48b8f5128ef4939b965627b146f42', 2047), 'SmallPairGraphTriangle43': ('9e0618e09278664bac7c07fe4f54e9091267acb082d3de0ff1ed1edd484a6733', 396), 'SmallPairGraphData43': ('2d3c77d61e5d29b44efddfd3692b2666c7300f104de89a8dd27cb3839201bc1a', 124)}
RAW_GROUPS = {
    RAW + 'LeftCached': ['leftCached'],
    RAW + 'LeftRows': ['leftRows'],
    RAW + 'RightCached': ['rightCached'],
    RAW + 'RightRows': ['rightRows'],
}
MARKER = rb'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n'
PROHIBITED = rb'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b'
WHITESPACE = b' \t\r\n'

# These pins and shape expectations come from the actual broad inspection.
BROAD_INSPECTION_SHA = 'e9b86f5e1a724aa5863847cb67e854001317217dccce294418f35d4216565a95'
ORIGINAL_IMPORTS = {
    'SmallPairGraphInputs43': ['SmallPairGraphCheck'],
    'SmallPairGraphArithmetic43': ['SmallPairGraphInputs43', 'TwoSmallSeedDisks'],
    'SmallPairGraphWitnessData43': ['SmallPairGraphInputs43', 'PairClosureWitness'],
    'SmallPairGraphClosure43': ['SmallPairGraphWitnessData43', 'PairClosureIndexedWitness'],
    'SmallPairRawSelectedData43': ['SmallPairGraphInputs43', 'PairCachedResidues', 'SmallPairSieve_1_3'],
    'SmallPairLightAssembly43': ['SmallPairLightLeft43', 'SmallPairLightRight43', 'PairLightArithmeticBridge', 'SmallPairRawSelectedData43'],
    'SmallPairGraphTriangle43': ['SmallPairLightAssembly43'],
    'SmallPairGraphData43': ['SmallPairGraphArithmetic43', 'SmallPairGraphClosure43', 'SmallPairGraphTriangle43'],
}
MERGED_IMPORTS = ['SmallPairGraphCheck', 'TwoSmallSeedDisks', 'PairClosureWitness', 'PairClosureIndexedWitness', 'SmallPairLightLeft43', 'SmallPairLightRight43', 'PairLightArithmeticBridge', 'PairCachedResidues', 'SmallPairSieve_1_3']
MODEL_HEADERS = {'D1Bound5.smallPairA_43': 'def smallPairA_43 : QuadInt 1 3 ', 'D1Bound5.smallPairB_43': 'def smallPairB_43 : QuadInt 1 3 '}
LITERAL_COUNTS = {'smallPairClosure_43': 963, 'smallPairLarge_43': 962, 'rootPairs': 963, 'destinations': 963, 'leftCached': 482, 'leftRows': 482, 'rightCached': 480, 'rightRows': 480}
RAW_FRAGMENT_PINS = {'SmallPairRawSelectedData43LeftCached': ('070aef3a188f91cd8c1ec4b85034d7273e97c06a5ad549b82be27a8dd9255ef3', 246097), 'SmallPairRawSelectedData43LeftRows': ('c2b14d55a337e9e05b1d5988980c7cbd76574c79751c03469e78dba65990429d', 203477), 'SmallPairRawSelectedData43RightCached': ('7395475905116615d3c5e7962d7a2a4e914f0be7bea282fe75087ba89291a8a6', 244911), 'SmallPairRawSelectedData43RightRows': ('ced6f0b5f25503683fed8ff2a06cb6e877ad331fee2dd443d13cd287c7f83316', 370138)}


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
    assert text and re.fullmatch(r'[0-9 \t\-\[\](),]+', text), 'Non-numeric literal expression'
    return ast.literal_eval(text)


def pair_of_ints(value):
    return isinstance(value, tuple) and len(value) == 2 and all(type(item) is int for item in value)


def destination_row(row):
    match = re.fullmatch(rb'  \((none|some [0-9]+), (none|some [0-9]+)\),?', row)
    assert match, row[:100]
    return tuple(None if item == b'none' else int(item[5:]) for item in match.groups())


def split_raw(original):
    matches = list(re.finditer(rb'^def (\w+)\s*:', original, re.M))
    names = [name for group in RAW_GROUPS.values() for name in group]
    assert [match[1].decode() for match in matches] == names
    prefix = original[:matches[0].start()]
    namespaces = re.findall(rb'^namespace (\S+)\s*$', prefix, re.M)
    assert namespaces == [b'D1Bound5.PairSelectedPrepared43']
    closings = list(re.finditer(rb'^end D1Bound5\.PairSelectedPrepared43\s*$', original, re.M))
    assert len(closings) == 1 and closings[0].start() > matches[-1].start()
    end = closings[0].start()
    suffix = original[end:]
    assert re.fullmatch(rb'end D1Bound5\.PairSelectedPrepared43[ \t\r\n]*', suffix)
    blocks = {match[1].decode(): original[match.start():matches[index + 1].start()
                                         if index + 1 < len(matches) else end]
              for index, match in enumerate(matches)}
    assert prefix + b''.join(blocks.values()) + suffix == original
    assert top_imports(prefix)[0] == ['SmallPairGraphInputs43', 'PairCachedResidues', 'SmallPairSieve_1_3']
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
    assert merged_imports == MERGED_IMPORTS
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
        assert imports == ORIGINAL_IMPORTS[name], name
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
    actual_headers = {name: raw_header for _, name, raw_header in headers}
    assert all(actual_headers[name] == expected for name, expected in MODEL_HEADERS.items())
    values, literals = {}, {}
    for module, names in [
        ('SmallPairGraphInputs43', ['smallPairClosure_43', 'smallPairLarge_43']),
        ('SmallPairGraphWitnessData43', ['rootPairs', 'destinations']),
        (RAW, ['leftCached', 'leftRows', 'rightCached', 'rightRows']),
    ]:
        for name in names:
            rows, block = literal(originals[module], name)
            parsed = [destination_row(row) if name == 'destinations' else numeric_row(row) for row in rows]
            values[name] = parsed
            literals[name] = {'original_module': module, 'rows': len(rows),
                              'literal_sha256': digest(block), 'literal_bytes': len(block)}
    for name in ('smallPairClosure_43', 'smallPairLarge_43'):
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
    assert {name: len(parsed) for name, parsed in values.items()} == LITERAL_COUNTS
    rows = len(values['smallPairClosure_43'])
    assert len(values['rootPairs']) == len(values['destinations']) == rows
    assert len(values['leftCached']) == len(values['leftRows'])
    assert len(values['rightCached']) == len(values['rightRows'])
    assert len(values['leftCached']) + len(values['rightCached']) == len(values['smallPairLarge_43'])
    indices = [item for pair in values['destinations'] for item in pair if item is not None]
    assert indices and all(0 <= item < rows for item in indices)
    fragments, raw_blocks, raw_prefix, raw_suffix = split_raw(originals[RAW])
    assert {name: (digest(data), len(data)) for name, data in fragments.items()} == RAW_FRAGMENT_PINS
    parts = [{'module': 'SmallPairGraphClosure43Chunk' + f'{index:02d}', 'offset': offset,
              'count': min(64, rows - offset)} for index, offset in enumerate(range(0, rows, 64))]
    assert [row for part in parts for row in range(part['offset'], part['offset'] + part['count'])] == list(range(rows))
    return {
        'schema': 1, 'status': 'ACTUAL_GRAPH43_CLOSURE_SOURCE_INSPECTION_NOT_A_KERNEL_RESULT',
        'broad_inspection_sha256': BROAD_INSPECTION_SHA,
        'original_merged_sha256': digest(merged), 'original_merged_bytes': len(merged),
        'merged_prefix_sha256': digest(merged_prefix), 'merged_prefix': merged_prefix.decode(),
        'merged_external_imports': merged_imports, 'exact_merged_reconstruction': True,
        'original_source_manifest': {name: expected for name, (expected, _) in ORIGINAL_PINS.items()},
        'original_source_bytes': {name: size for name, (_, size) in ORIGINAL_PINS.items()},
        'merged_segments': records, 'original_declarations': original_records,
        'declaration_counts': {'total': 28, 'definitions': 13, 'theorems': 15},
        'literal_evidence': literals, 'closure_rows': rows,
        'filtered_vertices': len(values['smallPairLarge_43']),
        'destination_index_min': min(indices), 'destination_index_max': max(indices),
        'raw_literal_partition': {
            'original_module': RAW, 'groups': RAW_GROUPS, 'namespace': 'D1Bound5.PairSelectedPrepared43',
            'definition_sha256': {name: digest(block) for name, block in raw_blocks.items()},
            'prefix_sha256': digest(raw_prefix), 'suffix_sha256': digest(raw_suffix),
            'source_manifest': {name: digest(data) for name, data in fragments.items()},
            'source_bytes': {name: len(data) for name, data in fragments.items()},
            'exact_byte_reconstruction': True, 'original_imports_preserved_in_each_data_module': True,
        },
        'proposed_prefix_parts': parts, 'proposed_terminal_drop': rows,
        'source_preservation_only': True, 'root_integration': False, 'main_theorem_complete': False,
    }
