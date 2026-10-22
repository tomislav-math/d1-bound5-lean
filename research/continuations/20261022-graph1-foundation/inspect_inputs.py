"""Inspect actual graph1 source files locally; no compiler, subprocess, or Git.

Usage: python3 -B inspect_inputs.py SOURCE_DIRECTORY OUTPUT_JSON
The output records evidence only; it never marks the remote run binding as bound.
"""
from pathlib import Path
import json
import sys

from foundation_inputs import ORIGINAL_NAMES, inspect_sources


def main():
    assert len(sys.argv) == 3
    directory, output = map(Path, sys.argv[1:])
    raw = {}
    for name in ORIGINAL_NAMES:
        path = directory / (name + '.lean')
        assert path.is_file() and not path.is_symlink(), str(path)
        raw[name] = path.read_bytes()
    evidence = inspect_sources(raw)
    with output.open('x') as stream:
        stream.write(json.dumps(evidence, indent=2, sort_keys=True) + '\n')
    print(json.dumps({'status': 'LOCAL_SOURCE_INSPECTION_NOT_A_KERNEL_RESULT',
                      'output': str(output.resolve()),
                      'original_source_manifest': evidence['original_source_manifest'],
                      'original_source_bytes': evidence['original_source_bytes'],
                      'literal_row_counts': evidence['literal_row_counts'],
                      'declaration_counts': evidence['declaration_counts']}), flush=True)


if __name__ == '__main__':
    main()
