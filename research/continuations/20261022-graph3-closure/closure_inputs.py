"""Pure graph3 merged-source inspection and exact raw-literal partitioning.

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
OUTPUT_DIRECTORY = REPOSITORY / 'research/continuations/20261022-graph3-closure'
SOURCE_CATALOG_PATH = REPOSITORY / 'research/continuations/20261022-graph3-intake/SOURCE_CATALOG.json'
SOURCE_CATALOG_SHA = 'ac4e0093babad78ab72dfd13b046bb8e546472142e1a863b83d724fea086a416'
SOURCE_CATALOG_BYTES = 150160
SOURCE_BYTE_LIMIT = 4 * 1024 * 1024
TARGET = 'SmallPairGraphData3'
RAW = 'SmallPairRawSelectedData3'
MERGED_SHA = '07311ff8945e773cdf988ada0f87f63750db70cc8562e6c58d56c0624515d35e'
MERGED_BYTES = 2359193
ORIGINAL_PINS = {'SmallPairGraphInputs3': ('a2060547d6581e20f545c7e19b614ba81c5b621f4b74f09542728f5c0cd6e190', 931270),
 'SmallPairGraphArithmetic3': ('a5595d899d140695b2f8be811778d9ea2f78cc8ff96425eb8c43a4bc305fc489', 555),
 'SmallPairGraphWitnessData3': ('a78b10049617e1d74eafb6271f6262389571a9c140713da149c7b82e0f009eb8', 497242),
 'SmallPairGraphClosure3': ('3db79a70d33b3c18a681859cbedffe29b00c4cb8f3854c82757da5533ebdcb31', 720),
 'SmallPairRawSelectedData3': ('3cb34dbb3c8cf4ab2b603d59d6b2ff15b0c53902a93733c12e87ba7abefc3e82', 926089),
 'SmallPairLightAssembly3': ('56edac3dc1067d6b0f3c0222e535e97bb79b045082fc27258c676fd28249c84d', 2022),
 'SmallPairGraphTriangle3': ('d8a8275159088014cfa15f46761ebe17b260e8974aa1072d206bf114db69c5bf', 389),
 'SmallPairGraphData3': ('590b2dae2c18b31f2621d070caa9854c89763bc29f08e3e47b31a8e0678ee92c', 121)}
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
ORIGINAL_IMPORTS = {'SmallPairGraphInputs3': ['SmallPairGraphCheck'],
 'SmallPairGraphArithmetic3': ['SmallPairGraphInputs3', 'TwoSmallSeedDisks'],
 'SmallPairGraphWitnessData3': ['SmallPairGraphInputs3', 'PairClosureWitness'],
 'SmallPairGraphClosure3': ['SmallPairGraphWitnessData3', 'PairClosureIndexedWitness'],
 'SmallPairRawSelectedData3': ['SmallPairGraphInputs3', 'PairCachedResidues', 'SmallPairSieve_0_1'],
 'SmallPairLightAssembly3': ['SmallPairLightLeft3',
                             'SmallPairLightRight3',
                             'PairLightArithmeticBridge',
                             'SmallPairRawSelectedData3'],
 'SmallPairGraphTriangle3': ['SmallPairLightAssembly3'],
 'SmallPairGraphData3': ['SmallPairGraphArithmetic3', 'SmallPairGraphClosure3', 'SmallPairGraphTriangle3']}
MERGED_IMPORTS = ['SmallPairGraphCheck',
 'TwoSmallSeedDisks',
 'PairClosureWitness',
 'PairClosureIndexedWitness',
 'SmallPairLightLeft3',
 'SmallPairLightRight3',
 'PairLightArithmeticBridge',
 'PairCachedResidues',
 'SmallPairSieve_0_1']
MODEL_HEADERS = {'D1Bound5.smallPairA_3': 'def smallPairA_3 : QuadInt 0 1 ',
                 'D1Bound5.smallPairB_3': 'def smallPairB_3 : QuadInt 0 1 '}
ORIGINAL_RAW_HEADERS = {'SmallPairGraphInputs3': ['def smallPairA_3 : QuadInt 0 1 ',
                           'def smallPairB_3 : QuadInt 0 1 ',
                           'def smallPairClosure_3 : List (QuadInt 0 1) ',
                           'def smallPairLarge_3 : List (QuadInt 0 1) ',
                           'def colors : ℕ '],
 'SmallPairGraphArithmetic3': ['theorem smallPairSeeds_3_checked :\n'
                               '    pairSeedsCoveredBool smallPairA_3 smallPairB_3\n'
                               '      seedRootDisk_0_1 smallPairClosure_3 = true ',
                               'theorem smallPairFilter_3_checked :\n'
                               '    largePairVertices smallPairA_3 smallPairB_3 smallPairClosure_3 = '
                               'smallPairLarge_3 ',
                               'theorem smallPairLarge_3_count : smallPairLarge_3.length = 827 '],
 'SmallPairGraphWitnessData3': ['def anchorRoot : QuadInt 0 1 ',
                                'def rootPairs : List (QuadInt 0 1 × QuadInt 0 1) ',
                                'def witnesses : List (PairRootWitness 0 1) ',
                                'def destinations : List (Option ℕ × Option ℕ) '],
 'SmallPairGraphClosure3': ['theorem PairGraphPrepared3.indexed_checked :\n'
                            '    pairClosureIndexedWitnessBool smallPairA_3 smallPairB_3 anchorRoot\n'
                            '      (10^1100) smallPairClosure_3 witnesses destinations = true ',
                            'theorem smallPairClosure_3_checked :\n'
                            '    pairClosureBool smallPairA_3 smallPairB_3\n'
                            '      (10^1100) smallPairClosure_3 = true '],
 'SmallPairRawSelectedData3': ['def leftCached : List (PairResidueVertex 0 1) ',
                               'def leftRows : List (ℕ × List ℕ) ',
                               'def rightCached : List (PairResidueVertex 0 1) ',
                               'def rightRows : List (ℕ × List ℕ) '],
 'SmallPairLightAssembly3': ['theorem sieve_eq : sieve = smallPairSieve_0_1 ',
                             'theorem leftVertices_eq :\n'
                             '    leftVertices = (pairSplitByMask smallPairLarge_3 '
                             'PairGraphPrepared3.colors).1.map pairLightCoordinates ',
                             'theorem leftCached_eq :\n'
                             '    leftCached = PairSelectedPrepared3.leftCached.map '
                             'pairLightCachedCoordinates ',
                             'theorem leftRows_eq : leftRows = PairSelectedPrepared3.leftRows ',
                             'theorem left_checked :\n'
                             '    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_3 '
                             'PairGraphPrepared3.colors).1 = true ',
                             'theorem rightVertices_eq :\n'
                             '    rightVertices = (pairSplitByMask smallPairLarge_3 '
                             'PairGraphPrepared3.colors).2.map pairLightCoordinates ',
                             'theorem rightCached_eq :\n'
                             '    rightCached = PairSelectedPrepared3.rightCached.map '
                             'pairLightCachedCoordinates ',
                             'theorem rightRows_eq : rightRows = PairSelectedPrepared3.rightRows ',
                             'theorem right_checked :\n'
                             '    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_3 '
                             'PairGraphPrepared3.colors).2 = true '],
 'SmallPairGraphTriangle3': ['theorem smallPairNoTriangle_3_checked :\n'
                             '    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_3 = true '],
 'SmallPairGraphData3': []}


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
    """Check the actual catalog backing every pinned source and raw header."""
    assert type(data) is bytes and len(data) == SOURCE_CATALOG_BYTES
    assert digest(data) == SOURCE_CATALOG_SHA
    catalog = json.loads(data)
    assert catalog['status'] == 'READ_ONLY_SOURCE_CATALOG_OBSERVED'
    assert catalog['source_snapshot_stable'] is True
    assert catalog['archive_directory'] == str(ARCHIVE_DIRECTORY)
    observed = catalog['archive_comparisons']
    assert observed['marker_order'] == list(ORIGINAL_PINS)
    assert observed['exact_recognized_segment_reconstruction'] is True
    sources = catalog['sources']
    archives = catalog['archive_sources']
    sources = {item['module']: item for item in (sources.values() if isinstance(sources, dict) else sources)}
    archives = {item['module']: item for item in (archives.values() if isinstance(archives, dict) else archives)}
    assert (sources[TARGET]['sha256'], sources[TARGET]['bytes']) == (MERGED_SHA, MERGED_BYTES)
    assert sources[TARGET]['state'] == 'present' and sources[TARGET]['read_success'] is True
    for name, pin in ORIGINAL_PINS.items():
        item = archives[name]
        assert item['state'] == 'present' and item['read_success'] is True
        assert item['path'] == str(ARCHIVE_DIRECTORY / (name + '.lean'))
        assert (item['sha256'], item['bytes']) == pin
        assert [entry['raw_header'] for entry in item['lexical_observations']['syntactic_declaration_candidates']] == ORIGINAL_RAW_HEADERS[name]
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
    assert namespaces == [b'D1Bound5.PairSelectedPrepared3']
    closings = list(re.finditer(rb'^end D1Bound5\.PairSelectedPrepared3\s*$', original, re.M))
    assert len(closings) == 1 and closings[0].start() > matches[-1].start()
    end = closings[0].start()
    suffix = original[end:]
    assert re.fullmatch(rb'end D1Bound5\.PairSelectedPrepared3[ \t\r\n]*', suffix)
    blocks = {match[1].decode(): original[match.start():matches[index + 1].start()
                                         if index + 1 < len(matches) else end]
              for index, match in enumerate(matches)}
    assert prefix + b''.join(blocks.values()) + suffix == original
    assert top_imports(prefix)[0] == ['SmallPairGraphInputs3', 'PairCachedResidues', 'SmallPairSieve_0_1']
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
        ('SmallPairGraphInputs3', ['smallPairClosure_3', 'smallPairLarge_3']),
        ('SmallPairGraphWitnessData3', ['rootPairs', 'destinations']),
        (RAW, ['leftCached', 'leftRows', 'rightCached', 'rightRows']),
    ]:
        for name in names:
            rows, block = literal(originals[module], name)
            parsed = [destination_row(row) if name == 'destinations' else numeric_row(row) for row in rows]
            values[name] = parsed
            literals[name] = {'original_module': module, 'rows': len(rows),
                              'literal_sha256': digest(block), 'literal_bytes': len(block)}
    for name in ('smallPairClosure_3', 'smallPairLarge_3'):
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
    rows = len(values['smallPairClosure_3'])
    assert len(values['rootPairs']) == len(values['destinations']) == rows
    assert len(values['leftCached']) == len(values['leftRows'])
    assert len(values['rightCached']) == len(values['rightRows'])
    assert len(values['leftCached']) + len(values['rightCached']) == len(values['smallPairLarge_3'])
    indices = [item for pair in values['destinations'] for item in pair if item is not None]
    assert indices and all(0 <= item < rows for item in indices)
    fragments, raw_blocks, raw_prefix, raw_suffix = split_raw(originals[RAW])
    parts = [{'module': 'SmallPairGraphClosure3Chunk' + f'{index:02d}', 'offset': offset,
              'count': min(64, rows - offset)} for index, offset in enumerate(range(0, rows, 64))]
    assert [row for part in parts for row in range(part['offset'], part['offset'] + part['count'])] == list(range(rows))
    return {
        'schema': 1, 'status': 'ACTUAL_GRAPH3_CLOSURE_SOURCE_INSPECTION_NOT_A_KERNEL_RESULT',
        'source_catalog_sha256': SOURCE_CATALOG_SHA, 'model_parameters': [0, 1],
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
        'filtered_vertices': len(values['smallPairLarge_3']),
        'destination_index_min': min(indices), 'destination_index_max': max(indices),
        'destination_columns': [
            {'column': column, 'some_count': sum(pair[column] is not None for pair in values['destinations']),
             'none_count': sum(pair[column] is None for pair in values['destinations'])}
            for column in range(2)],
        'destination_indices_use_complete_original_closure': True,
        'raw_literal_partition': {
            'original_module': RAW, 'groups': RAW_GROUPS, 'namespace': 'D1Bound5.PairSelectedPrepared3',
            'definition_sha256': {name: digest(block) for name, block in raw_blocks.items()},
            'prefix_sha256': digest(raw_prefix), 'suffix_sha256': digest(raw_suffix),
            'source_manifest': {name: digest(data) for name, data in fragments.items()},
            'source_bytes': {name: len(data) for name, data in fragments.items()},
            'exact_byte_reconstruction': True, 'original_imports_preserved_in_each_data_module': True,
        },
        'proposed_prefix_parts': parts, 'proposed_terminal_drop': rows,
        'source_preservation_only': True, 'root_integration': False, 'main_theorem_complete': False,
    }
