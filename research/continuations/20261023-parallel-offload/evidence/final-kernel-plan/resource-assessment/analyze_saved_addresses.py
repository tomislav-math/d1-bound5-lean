#!/usr/bin/env python3
"""Read 88-byte official v2/v3 headers; no artifact deserialization or Lean run."""
import json
from pathlib import Path
import struct

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
proxy = json.loads((HERE / 'IMPORT_SIZE_PROXY.json').read_text())
env = json.loads((ROOT / 'lean-env.json').read_text())
roots = [Path(p) for p in env['LEAN_PATH'].split(':') if p]
regions = []
errors = []
for name, parts in proxy['module_parts'].items():
    relative = name.replace('.', '/')
    base = next(r / (relative + '.olean') for r in roots if (r / (relative + '.olean')).is_file())
    for suffix, size in parts.items():
        path = base.with_name(base.name.removesuffix('.olean') + suffix)
        with path.open('rb') as f:
            header = f.read(88)
        if len(header) != 88 or header[:5] != b'olean' or header[5] not in (2, 3):
            errors.append(str(path)); continue
        address = struct.unpack('<Q', header[80:88])[0]
        regions.append({'module': name, 'part': suffix, 'path': str(path), 'base': address,
                        'end': address + ((size + 4095) // 4096) * 4096, 'file_bytes': size})
regions.sort(key=lambda r: (r['base'], r['end'], r['path']))
active, overlaps = [], []
for region in regions:
    active = [r for r in active if r['end'] > region['base']]
    for prior in active:
        overlaps.append({'a': prior, 'b': region})
    active.append(region)
result = {'scope': 'Offline candidate-artifact address intervals in source-header proxy, rounded to4096-byte Linux mmap pages; not actual importer execution',
          'header_format': 'Official src/library/module.cpp olean_header:88 bytes, little-endian64-bit base at offset80',
          'regions': len(regions), 'header_errors': errors, 'overlapping_pairs': overlaps,
          'limitations': ['Import-level attributes may exclude some proxy parts.',
                         'The eventual clean artifacts may have different sizes.',
                         'No overlap cannot rule out runtime/library/ASLR address collisions.',
                         'A collision predicts a potential relocation fallback only if both parts are actually imported.']}
(HERE / 'SAVED_ADDRESS_PROXY.json').write_text(json.dumps(result, indent=2, sort_keys=True) + '\n')
print(json.dumps({'regions': len(regions), 'header_errors': len(errors), 'overlapping_pairs': len(overlaps),
                  'pairs': [[r['a']['module'] + r['a']['part'], r['b']['module'] + r['b']['part']] for r in overlaps]}, indent=2))
