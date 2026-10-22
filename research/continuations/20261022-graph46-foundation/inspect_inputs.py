"""Inspect exact graph46 foundation sources without commands or compilation.

Usage: python3 -B inspect_inputs.py SOURCE_DIRECTORY NEW_OUTPUT_JSON
This writes source evidence only; it does not bind or install a continuation.
"""
from pathlib import Path
import json
import sys

from foundation_inputs import ORIGINAL_NAMES, inspect_sources, source_hash, digest


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True


def main():
    assert len(sys.argv) == 3
    directory, output = map(Path, sys.argv[1:])
    assert not output.exists() and not output.is_symlink()
    raw, paths = {}, {}
    for name in ORIGINAL_NAMES:
        path = directory / (name + '.lean')
        assert path.is_file() and not path.is_symlink(), str(path)
        paths[name] = path
        raw[name] = path.read_bytes()
    evidence = inspect_sources(raw)
    assert all(source_hash(paths[name]) == digest(data) and paths[name].read_bytes() == data
               for name, data in raw.items())
    with output.open('x') as stream:
        stream.write(json.dumps(evidence, indent=2, sort_keys=True) + '\n')
    print(json.dumps({'status': 'ACTUAL_GRAPH46_FOUNDATION_SOURCE_INSPECTION_NOT_A_KERNEL_RESULT',
                      'output': str(output.resolve()),
                      'original_source_manifest': evidence['original_source_manifest'],
                      'original_source_bytes': evidence['original_source_bytes'],
                      'literal_row_counts': evidence['literal_row_counts'],
                      'fragment_source_bytes': evidence['fragment_source_bytes'],
                      'declaration_counts': evidence['declaration_counts'],
                      'source_snapshot_stable': True}), flush=True)


if __name__ == '__main__':
    main()
