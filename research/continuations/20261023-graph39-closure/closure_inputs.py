"""Pure graph39 merged-source inspection and exact raw-literal partitioning.

No subprocess, compiler, Git, project mutation, or proof acceptance occurs here.
The merged source and the eight archive pins were supplied by actual inspection.
"""
from pathlib import Path
import ast
import hashlib
import json
import os
import re
import stat


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')

REPOSITORY = Path('/Users/tp/Lean/D1Bound5')
ARCHIVE_DIRECTORY = Path('/Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation/prepared-light-remaining39/D1Bound5')
OUTPUT_DIRECTORY = Path('/Users/tp/Lean/D1Bound5/research/continuations/20261023-graph39-closure')
SOURCE_CATALOG_PATH = Path('/Users/tp/Lean/D1Bound5/research/continuations/20261023-graph39-closure/SOURCE_CATALOG.json')
SOURCE_CATALOG_SHA = '252abee9997b7098628caafa9f316d189acd18c82f3da580713e5063b3d53643'
SOURCE_CATALOG_BYTES = 4376
SOURCE_BYTE_LIMIT = 4 * 1024 * 1024
TARGET = 'SmallPairGraphData39'
RAW = 'SmallPairRawSelectedData39'
MERGED_SHA = '6976f83483d1c3da31e5c4aef54dfded87ee84ea446b7e6814a9507ee3cc20c4'
MERGED_BYTES = 2572232
ORIGINAL_PINS = {'SmallPairGraphInputs39': ('160ac97a2be982c0553d704358797eadd21a266d2cb5d58956a449f97594fc59', 1028038), 'SmallPairGraphArithmetic39': ('b31dee9314b58b7e1aa4f8295deb3f5469a078126ebe0065fab4650a4c915254', 567), 'SmallPairGraphWitnessData39': ('8279eddba1b02932ce68189214e8f3636fc9c49d76a941c27d8b689054060203', 486319), 'SmallPairGraphClosure39': ('613b75c1c896359342f81d172dd4dfb45fb92968e356a7d7d6b60d2847367188', 734), 'SmallPairRawSelectedData39': ('814ec46a4ae4b4535892d2aba3d318d99fece431059657184a8ee1c721ce6833', 1053223), 'SmallPairLightAssembly39': ('ae9b1a9efdeed04c72a03b7178601eaf72f5411bc35132f12586e6972c401a38', 2047), 'SmallPairGraphTriangle39': ('6ba31aeed73a718da30579365140eb35418ee40fe1778338a54181540bf6f81e', 396), 'SmallPairGraphData39': ('e1a94c92ff2b512536e523fdabc91d0fe92019ea31c476b47983164906948158', 124)}
RAW_GROUPS = {
    RAW + 'LeftCached': ['leftCached'],
    RAW + 'LeftRows': ['leftRows'],
    RAW + 'RightCached': ['rightCached'],
    RAW + 'RightRows': ['rightRows'],
}
MARKER = rb'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n'
PROHIBITED = rb'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b'
WHITESPACE = b' \t\r\n'

# Exact imports and raw public headers were observed in the pinned source catalog.
# Literal counts and fragment hashes are deliberately measured by inspect().
ORIGINAL_IMPORTS = {'SmallPairGraphInputs39': ['SmallPairGraphCheck'], 'SmallPairGraphArithmetic39': ['SmallPairGraphInputs39', 'TwoSmallSeedDisks'], 'SmallPairGraphWitnessData39': ['SmallPairGraphInputs39', 'PairClosureWitness'], 'SmallPairGraphClosure39': ['SmallPairGraphWitnessData39', 'PairClosureIndexedWitness'], 'SmallPairRawSelectedData39': ['SmallPairGraphInputs39', 'PairCachedResidues', 'SmallPairSieve_1_2'], 'SmallPairLightAssembly39': ['SmallPairLightLeft39', 'SmallPairLightRight39', 'PairLightArithmeticBridge', 'SmallPairRawSelectedData39'], 'SmallPairGraphTriangle39': ['SmallPairLightAssembly39'], 'SmallPairGraphData39': ['SmallPairGraphArithmetic39', 'SmallPairGraphClosure39', 'SmallPairGraphTriangle39']}
MERGED_IMPORTS = ['SmallPairGraphCheck', 'TwoSmallSeedDisks', 'PairClosureWitness', 'PairClosureIndexedWitness', 'SmallPairLightLeft39', 'SmallPairLightRight39', 'PairLightArithmeticBridge', 'PairCachedResidues', 'SmallPairSieve_1_2']
MODEL_HEADERS = {'D1Bound5.smallPairA_39': 'def smallPairA_39 : QuadInt 1 2 ', 'D1Bound5.smallPairB_39': 'def smallPairB_39 : QuadInt 1 2 '}
ORIGINAL_RAW_HEADERS = {'SmallPairGraphInputs39': ['def smallPairA_39 : QuadInt 1 2 ', 'def smallPairB_39 : QuadInt 1 2 ', 'def smallPairClosure_39 : List (QuadInt 1 2) ', 'def smallPairLarge_39 : List (QuadInt 1 2) ', 'def colors : ℕ '], 'SmallPairGraphArithmetic39': ['theorem smallPairSeeds_39_checked :\n    pairSeedsCoveredBool smallPairA_39 smallPairB_39\n      seedRootDisk_1_2 smallPairClosure_39 = true ', 'theorem smallPairFilter_39_checked :\n    largePairVertices smallPairA_39 smallPairB_39 smallPairClosure_39 = smallPairLarge_39 ', 'theorem smallPairLarge_39_count : smallPairLarge_39.length = 914 '], 'SmallPairGraphWitnessData39': ['def anchorRoot : QuadInt 1 2 ', 'def rootPairs : List (QuadInt 1 2 × QuadInt 1 2) ', 'def witnesses : List (PairRootWitness 1 2) ', 'def destinations : List (Option ℕ × Option ℕ) '], 'SmallPairGraphClosure39': ['theorem PairGraphPrepared39.indexed_checked :\n    pairClosureIndexedWitnessBool smallPairA_39 smallPairB_39 anchorRoot\n      (10^1100) smallPairClosure_39 witnesses destinations = true ', 'theorem smallPairClosure_39_checked :\n    pairClosureBool smallPairA_39 smallPairB_39\n      (10^1100) smallPairClosure_39 = true '], 'SmallPairRawSelectedData39': ['def leftCached : List (PairResidueVertex 1 2) ', 'def leftRows : List (ℕ × List ℕ) ', 'def rightCached : List (PairResidueVertex 1 2) ', 'def rightRows : List (ℕ × List ℕ) '], 'SmallPairLightAssembly39': ['theorem sieve_eq : sieve = smallPairSieve_1_2 ', 'theorem leftVertices_eq :\n    leftVertices = (pairSplitByMask smallPairLarge_39 PairGraphPrepared39.colors).1.map pairLightCoordinates ', 'theorem leftCached_eq :\n    leftCached = PairSelectedPrepared39.leftCached.map pairLightCachedCoordinates ', 'theorem leftRows_eq : leftRows = PairSelectedPrepared39.leftRows ', 'theorem left_checked :\n    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_39 PairGraphPrepared39.colors).1 = true ', 'theorem rightVertices_eq :\n    rightVertices = (pairSplitByMask smallPairLarge_39 PairGraphPrepared39.colors).2.map pairLightCoordinates ', 'theorem rightCached_eq :\n    rightCached = PairSelectedPrepared39.rightCached.map pairLightCachedCoordinates ', 'theorem rightRows_eq : rightRows = PairSelectedPrepared39.rightRows ', 'theorem right_checked :\n    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_39 PairGraphPrepared39.colors).2 = true '], 'SmallPairGraphTriangle39': ['theorem smallPairNoTriangle_39_checked :\n    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_39 = true '], 'SmallPairGraphData39': []}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def open_directory(path):
    """Anchor each directory component to a no-follow descriptor from '/'."""
    path = Path(path)
    assert path.is_absolute() and '..' not in path.parts
    flags = os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW
    descriptor = os.open('/', flags)
    try:
        for component in path.parts[1:]:
            following = os.open(component, flags, dir_fd=descriptor)
            os.close(descriptor)
            descriptor = following
        return descriptor
    except Exception:
        os.close(descriptor)
        raise


def read_source(path, expected_sha256=None, expected_bytes=None):
    """Bounded no-follow read; optional actual pins are checked on those bytes."""
    path = Path(path)
    assert path.is_absolute() and '..' not in path.parts and path.name
    assert (expected_sha256 is None) == (expected_bytes is None)
    if expected_bytes is not None:
        assert type(expected_bytes) is int and 0 < expected_bytes <= SOURCE_BYTE_LIMIT
        assert re.fullmatch(r'[0-9a-f]{64}', expected_sha256)
    directory_fd, source_fd = None, None
    try:
        directory_fd = open_directory(path.parent)
        source_fd = os.open(path.name, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK,
                            dir_fd=directory_fd)
        before = os.fstat(source_fd)
        assert stat.S_ISREG(before.st_mode) and 0 <= before.st_size <= SOURCE_BYTE_LIMIT, str(path)
        if expected_bytes is not None:
            assert before.st_size == expected_bytes, str(path)
        limit = expected_bytes if expected_bytes is not None else SOURCE_BYTE_LIMIT
        with os.fdopen(source_fd, 'rb') as stream:
            source_fd = None
            data = stream.read(limit + 1)
            after = os.fstat(stream.fileno())
        assert len(data) <= limit
        assert (before.st_dev, before.st_ino, before.st_size, before.st_mtime_ns, before.st_ctime_ns) == (
            after.st_dev, after.st_ino, after.st_size, after.st_mtime_ns, after.st_ctime_ns), str(path)
        if expected_bytes is not None:
            assert len(data) == expected_bytes and digest(data) == expected_sha256, str(path)
        return data
    finally:
        if source_fd is not None:
            os.close(source_fd)
        if directory_fd is not None:
            os.close(directory_fd)


def verify_catalog(data):
    assert type(data) is bytes and len(data)==SOURCE_CATALOG_BYTES and digest(data)==SOURCE_CATALOG_SHA
    catalog=json.loads(data)
    assert catalog['schema']==1 and catalog['status']=='ACTUAL_PINNED_GRAPH39_SOURCE_CATALOG_NOT_A_PROOF'
    assert catalog['merged']=={'module':TARGET,'sha256':MERGED_SHA,'bytes':MERGED_BYTES}
    assert catalog['archive']==str(ARCHIVE_DIRECTORY) and list(catalog['originals'])==sorted(ORIGINAL_PINS)
    for name,(expected,size) in ORIGINAL_PINS.items():
        assert catalog['originals'][name]=={'sha256':expected,'bytes':size,'headers':ORIGINAL_RAW_HEADERS[name]}
    return catalog


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
    assert namespaces == [b'D1Bound5.PairSelectedPrepared39']
    closings = list(re.finditer(rb'^end D1Bound5\.PairSelectedPrepared39\s*$', original, re.M))
    assert len(closings) == 1 and closings[0].start() > matches[-1].start()
    end = closings[0].start()
    suffix = original[end:]
    assert re.fullmatch(rb'end D1Bound5\.PairSelectedPrepared39[ \t\r\n]*', suffix)
    blocks = {match[1].decode(): original[match.start():matches[index + 1].start()
                                         if index + 1 < len(matches) else end]
              for index, match in enumerate(matches)}
    assert prefix + b''.join(blocks.values()) + suffix == original
    assert top_imports(prefix)[0] == ['SmallPairGraphInputs39', 'PairCachedResidues', 'SmallPairSieve_1_2']
    fragments = {module: prefix + b''.join(blocks[name] for name in names) + suffix
                 for module, names in RAW_GROUPS.items()}
    for module, selected in RAW_GROUPS.items():
        before = {item['local_name']: item for item in declarations(original.decode())}
        assert declarations(fragments[module].decode()) == [before[name] for name in selected]
        assert top_imports(fragments[module])[0] == top_imports(original)[0]
    return fragments, blocks, prefix, suffix


def inspect(merged, originals):
    assert type(merged) is bytes and digest(merged) == MERGED_SHA and len(merged) == MERGED_BYTES
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
        assert type(data) is bytes, name
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
        assert [item['raw_header'] for item in found] == ORIGINAL_RAW_HEADERS[name], name
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
    assert len(headers) == sum(len(items) for items in ORIGINAL_RAW_HEADERS.values())
    actual_headers = {name: raw_header for _, name, raw_header in headers}
    assert all(actual_headers[name] == expected for name, expected in MODEL_HEADERS.items())
    values, literals = {}, {}
    for module, names in [
        ('SmallPairGraphInputs39', ['smallPairClosure_39', 'smallPairLarge_39']),
        ('SmallPairGraphWitnessData39', ['rootPairs', 'destinations']),
        (RAW, ['leftCached', 'leftRows', 'rightCached', 'rightRows']),
    ]:
        for name in names:
            rows, block = literal(originals[module], name)
            parsed = [destination_row(row) if name == 'destinations' else numeric_row(row) for row in rows]
            values[name] = parsed
            literals[name] = {'original_module': module, 'rows': len(rows),
                              'literal_sha256': digest(block), 'literal_bytes': len(block)}
    for name in ('smallPairClosure_39', 'smallPairLarge_39'):
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
    rows = len(values['smallPairClosure_39'])
    assert len(values['rootPairs']) == len(values['destinations']) == rows
    assert len(values['leftCached']) == len(values['leftRows'])
    assert len(values['rightCached']) == len(values['rightRows'])
    assert len(values['leftCached']) + len(values['rightCached']) == len(values['smallPairLarge_39'])
    indices = [item for pair in values['destinations'] for item in pair if item is not None]
    assert indices and all(0 <= item < rows for item in indices)
    fragments, raw_blocks, raw_prefix, raw_suffix = split_raw(originals[RAW])
    parts = [{'module': 'SmallPairGraphClosure39Chunk' + f'{index:02d}', 'offset': offset,
              'count': min(64, rows - offset)} for index, offset in enumerate(range(0, rows, 64))]
    assert [row for part in parts for row in range(part['offset'], part['offset'] + part['count'])] == list(range(rows))
    return {
        'schema': 1, 'status': 'ACTUAL_GRAPH39_CLOSURE_SOURCE_INSPECTION_NOT_A_KERNEL_RESULT',
        'source_catalog_sha256': SOURCE_CATALOG_SHA, 'model_parameters': [1, 2],
        'original_merged_sha256': digest(merged), 'original_merged_bytes': len(merged),
        'merged_prefix_sha256': digest(merged_prefix), 'merged_prefix': merged_prefix.decode(),
        'merged_external_imports': merged_imports, 'exact_merged_reconstruction': True,
        'original_source_manifest': {name: expected for name, (expected, _) in ORIGINAL_PINS.items()},
        'original_source_bytes': {name: size for name, (_, size) in ORIGINAL_PINS.items()},
        'merged_segments': records, 'original_declarations': original_records,
        'declaration_counts': {'total': len(headers),
                               'definitions': sum(item[0] == 'def' for item in headers),
                               'theorems': sum(item[0] == 'theorem' for item in headers)},
        'literal_evidence': literals, 'closure_rows': rows,
        'filtered_vertices': len(values['smallPairLarge_39']),
        'destination_index_min': min(indices), 'destination_index_max': max(indices),
        'destination_columns': [
            {'column': column, 'some_count': sum(pair[column] is not None for pair in values['destinations']),
             'none_count': sum(pair[column] is None for pair in values['destinations'])}
            for column in range(2)],
        'destination_indices_use_complete_original_closure': True,
        'raw_literal_partition': {
            'original_module': RAW, 'groups': RAW_GROUPS, 'namespace': 'D1Bound5.PairSelectedPrepared39',
            'definition_sha256': {name: digest(block) for name, block in raw_blocks.items()},
            'prefix_sha256': digest(raw_prefix), 'suffix_sha256': digest(raw_suffix),
            'source_manifest': {name: digest(data) for name, data in fragments.items()},
            'source_bytes': {name: len(data) for name, data in fragments.items()},
            'exact_byte_reconstruction': True, 'original_imports_preserved_in_each_data_module': True,
        },
        'proposed_prefix_parts': parts, 'proposed_terminal_drop': rows,
        'source_preservation_only': True, 'root_integration': False, 'main_theorem_complete': False,
    }
