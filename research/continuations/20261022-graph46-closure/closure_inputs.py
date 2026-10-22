"""Pure graph46 merged-source inspection and exact raw-literal partitioning.

No subprocess, compiler, Git, project mutation, or proof acceptance occurs here.
The merged source and the eight archive pins were supplied by actual inspection.
"""
from pathlib import Path
import ast
import hashlib
import re


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')

TARGET = 'SmallPairGraphData46'
RAW = 'SmallPairRawSelectedData46'
MERGED_SHA = 'cbc0aecb61786cf910cf6f7e987d1dc255fcae3a9df10a4700def2ab8b8d6870'
MERGED_BYTES = 2184936
ORIGINAL_PINS = {
    'SmallPairGraphInputs46': ('6333b204dd3536bbffa2ef809a533bc9064ac2358a86f4c3b384d25e4845bf29', 413862),
    'SmallPairGraphArithmetic46': ('f9a32640a9b051fd190da9bbb41a14d597818d62631e660bf974bcf2f782f93c', 567),
    'SmallPairGraphWitnessData46': ('3841afc95893ed26ac8e5c9ad4bf6731084ca03aafa55c9acf04ebf8bcf99989', 431078),
    'SmallPairGraphClosure46': ('8cc3f88cd6dfbaabd0b7f1a56e28f8e00098fa11519f9c612ea82df4bcfbf41c', 734),
    'SmallPairRawSelectedData46': ('fe085f12e6515d75b7568d0ddcbb303a1ef09f78cf9e4113a5646865de391f6c', 1335344),
    'SmallPairLightAssembly46': ('6e234132c97201897fc0a7fb8b6edd79e6ed62c8792a7bf0786831c44ea7aefb', 2047),
    'SmallPairGraphTriangle46': ('0c226230f87956ec57f7eb8e4aeb385d0b852d01223caa9557f0af7d6cb178d7', 396),
    'SmallPairGraphData46': ('f552150b39fb7f4c65bc718d1ecc68fa3fcd70343e8c3d734861c1d523266d4a', 124),
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

# These pins and shape expectations come from the actual broad inspection.
BROAD_INSPECTION_SHA = 'f2d3955f2af8d40917f33e1697a825c786fb8a8f2a2f09720628f5a0cc0b2b54'
ORIGINAL_IMPORTS = {
    'SmallPairGraphInputs46': ['SmallPairGraphCheck'],
    'SmallPairGraphArithmetic46': ['SmallPairGraphInputs46', 'TwoSmallSeedDisks'],
    'SmallPairGraphWitnessData46': ['SmallPairGraphInputs46', 'PairClosureWitness'],
    'SmallPairGraphClosure46': ['SmallPairGraphWitnessData46', 'PairClosureIndexedWitness'],
    'SmallPairRawSelectedData46': ['SmallPairGraphInputs46', 'PairCachedResidues', 'SmallPairSieve_1_6'],
    'SmallPairLightAssembly46': ['SmallPairLightLeft46', 'SmallPairLightRight46', 'PairLightArithmeticBridge', 'SmallPairRawSelectedData46'],
    'SmallPairGraphTriangle46': ['SmallPairLightAssembly46'],
    'SmallPairGraphData46': ['SmallPairGraphArithmetic46', 'SmallPairGraphClosure46', 'SmallPairGraphTriangle46'],
}
MERGED_IMPORTS = ['SmallPairGraphCheck', 'TwoSmallSeedDisks', 'PairClosureWitness', 'PairClosureIndexedWitness', 'SmallPairLightLeft46', 'SmallPairLightRight46', 'PairLightArithmeticBridge', 'PairCachedResidues', 'SmallPairSieve_1_6']
MODEL_HEADERS = {'D1Bound5.smallPairA_46': 'def smallPairA_46 : QuadInt 1 6 ', 'D1Bound5.smallPairB_46': 'def smallPairB_46 : QuadInt 1 6 '}
LITERAL_COUNTS = {'smallPairClosure_46': 719, 'smallPairLarge_46': 718, 'rootPairs': 719, 'destinations': 719, 'leftCached': 360, 'leftRows': 360, 'rightCached': 358, 'rightRows': 358}
RAW_FRAGMENT_PINS = {
    'SmallPairRawSelectedData46LeftCached': ('f823be5f37e88e084cc22dd4653de386f557856f9cc1111a58e23d50ee434e5f', 183870),
    'SmallPairRawSelectedData46LeftRows': ('9045d24265a2235b1784d04ea3ec7a5320fa7df4da966a378e1c1dcbfcab7455', 350897),
    'SmallPairRawSelectedData46RightCached': ('40c91455704070272672e21a26d19ff39f582e48128ad57287d7a496a4ec62e2', 182650),
    'SmallPairRawSelectedData46RightRows': ('1f12438dde9e65bd1df99f594096e8d0c017811b860982dd94614c9c201614cb', 618584),
}


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
    assert namespaces == [b'D1Bound5.PairSelectedPrepared46']
    closings = list(re.finditer(rb'^end D1Bound5\.PairSelectedPrepared46\s*$', original, re.M))
    assert len(closings) == 1 and closings[0].start() > matches[-1].start()
    end = closings[0].start()
    suffix = original[end:]
    assert re.fullmatch(rb'end D1Bound5\.PairSelectedPrepared46[ \t\r\n]*', suffix)
    blocks = {match[1].decode(): original[match.start():matches[index + 1].start()
                                         if index + 1 < len(matches) else end]
              for index, match in enumerate(matches)}
    assert prefix + b''.join(blocks.values()) + suffix == original
    assert top_imports(prefix)[0] == ['SmallPairGraphInputs46', 'PairCachedResidues', 'SmallPairSieve_1_6']
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
        ('SmallPairGraphInputs46', ['smallPairClosure_46', 'smallPairLarge_46']),
        ('SmallPairGraphWitnessData46', ['rootPairs', 'destinations']),
        (RAW, ['leftCached', 'leftRows', 'rightCached', 'rightRows']),
    ]:
        for name in names:
            rows, block = literal(originals[module], name)
            parsed = [destination_row(row) if name == 'destinations' else numeric_row(row) for row in rows]
            values[name] = parsed
            literals[name] = {'original_module': module, 'rows': len(rows),
                              'literal_sha256': digest(block), 'literal_bytes': len(block)}
    for name in ('smallPairClosure_46', 'smallPairLarge_46'):
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
    rows = len(values['smallPairClosure_46'])
    assert len(values['rootPairs']) == len(values['destinations']) == rows
    assert len(values['leftCached']) == len(values['leftRows'])
    assert len(values['rightCached']) == len(values['rightRows'])
    assert len(values['leftCached']) + len(values['rightCached']) == len(values['smallPairLarge_46'])
    indices = [item for pair in values['destinations'] for item in pair if item is not None]
    assert indices and all(0 <= item < rows for item in indices)
    fragments, raw_blocks, raw_prefix, raw_suffix = split_raw(originals[RAW])
    assert {name: (digest(data), len(data)) for name, data in fragments.items()} == RAW_FRAGMENT_PINS
    parts = [{'module': 'SmallPairGraphClosure46Chunk' + f'{index:02d}', 'offset': offset,
              'count': min(64, rows - offset)} for index, offset in enumerate(range(0, rows, 64))]
    assert [row for part in parts for row in range(part['offset'], part['offset'] + part['count'])] == list(range(rows))
    return {
        'schema': 1, 'status': 'ACTUAL_GRAPH46_CLOSURE_SOURCE_INSPECTION_NOT_A_KERNEL_RESULT',
        'broad_inspection_sha256': BROAD_INSPECTION_SHA,
        'original_merged_sha256': digest(merged), 'original_merged_bytes': len(merged),
        'merged_prefix_sha256': digest(merged_prefix), 'merged_prefix': merged_prefix.decode(),
        'merged_external_imports': merged_imports, 'exact_merged_reconstruction': True,
        'original_source_manifest': {name: expected for name, (expected, _) in ORIGINAL_PINS.items()},
        'original_source_bytes': {name: size for name, (_, size) in ORIGINAL_PINS.items()},
        'merged_segments': records, 'original_declarations': original_records,
        'declaration_counts': {'total': 28, 'definitions': 13, 'theorems': 15},
        'literal_evidence': literals, 'closure_rows': rows,
        'filtered_vertices': len(values['smallPairLarge_46']),
        'destination_index_min': min(indices), 'destination_index_max': max(indices),
        'raw_literal_partition': {
            'original_module': RAW, 'groups': RAW_GROUPS, 'namespace': 'D1Bound5.PairSelectedPrepared46',
            'definition_sha256': {name: digest(block) for name, block in raw_blocks.items()},
            'prefix_sha256': digest(raw_prefix), 'suffix_sha256': digest(raw_suffix),
            'source_manifest': {name: digest(data) for name, data in fragments.items()},
            'source_bytes': {name: len(data) for name, data in fragments.items()},
            'exact_byte_reconstruction': True, 'original_imports_preserved_in_each_data_module': True,
        },
        'proposed_prefix_parts': parts, 'proposed_terminal_drop': rows,
        'source_preservation_only': True, 'root_integration': False, 'main_theorem_complete': False,
    }
