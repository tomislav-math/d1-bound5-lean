"""Inspect the pinned graph3 merged source and eight exact archived originals.

Usage: python3 -B inspect_inputs.py MERGED_FILE ARCHIVE_DIRECTORY OUTPUT_JSON
Only the fixed new graph3 closure SOURCE_INSPECTION.json may be created. No
source is installed; no command, compiler, queue action, or proof acceptance runs.
"""
from pathlib import Path
import json
import os
import sys


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True

from closure_inputs import (
    ARCHIVE_DIRECTORY, MERGED_BYTES, MERGED_SHA, ORIGINAL_PINS, OUTPUT_DIRECTORY,
    REPOSITORY, SOURCE_CATALOG_BYTES, SOURCE_CATALOG_PATH, SOURCE_CATALOG_SHA,
    TARGET, digest, inspect, open_directory, read_source, verify_catalog,
)


def main():
    assert len(sys.argv) == 4
    merged_path, archive, output = map(Path, sys.argv[1:])
    assert merged_path == REPOSITORY / 'D1Bound5' / (TARGET + '.lean')
    assert archive == ARCHIVE_DIRECTORY
    assert output == OUTPUT_DIRECTORY / 'SOURCE_INSPECTION.json'
    catalog_bytes = read_source(SOURCE_CATALOG_PATH, SOURCE_CATALOG_SHA, SOURCE_CATALOG_BYTES)
    verify_catalog(catalog_bytes)
    merged = read_source(merged_path, MERGED_SHA, MERGED_BYTES)
    originals = {name: read_source(archive / (name + '.lean'), expected, size)
                 for name, (expected, size) in ORIGINAL_PINS.items()}
    evidence = inspect(merged, originals)
    assert read_source(merged_path, MERGED_SHA, MERGED_BYTES) == merged
    assert all(read_source(archive / (name + '.lean'), *ORIGINAL_PINS[name]) == data
               for name, data in originals.items())
    assert read_source(SOURCE_CATALOG_PATH, SOURCE_CATALOG_SHA, SOURCE_CATALOG_BYTES) == catalog_bytes
    payload = (json.dumps(evidence, indent=2, sort_keys=True) + '\n').encode('utf-8')
    assert len(payload) <= 1024 * 1024, 'Unexpectedly large source-only inspection'
    directory_fd, output_fd = None, None
    try:
        directory_fd = open_directory(OUTPUT_DIRECTORY)
        output_fd = os.open(output.name, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW,
                            0o644, dir_fd=directory_fd)
        with os.fdopen(output_fd, 'wb') as stream:
            output_fd = None
            stream.write(payload)
            stream.flush()
    finally:
        if output_fd is not None:
            os.close(output_fd)
        if directory_fd is not None:
            os.close(directory_fd)
    print(json.dumps({
        'status': evidence['status'], 'output': str(output),
        'output_sha256': digest(payload), 'output_bytes': len(payload),
        'source_catalog_sha256': SOURCE_CATALOG_SHA,
        'original_merged_sha256': evidence['original_merged_sha256'],
        'original_merged_bytes': evidence['original_merged_bytes'],
        'declaration_counts': evidence['declaration_counts'],
        'closure_rows': evidence['closure_rows'], 'filtered_vertices': evidence['filtered_vertices'],
        'literal_rows': {name: item['rows'] for name, item in evidence['literal_evidence'].items()},
        'raw_fragment_bytes': evidence['raw_literal_partition']['source_bytes'],
        'prefix_counts': [part['count'] for part in evidence['proposed_prefix_parts']],
        'source_snapshot_stable': True,
        'stability_scope': 'two sequential equal-byte reads of pinned sources and catalog; not atomic',
        'proof_or_queue_mutated': False, 'kernel_result': False,
    }), flush=True)


if __name__ == '__main__':
    main()
