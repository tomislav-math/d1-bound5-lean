"""Inspect exact merged graph1 and archived originals; never compile or install.

Usage: python3 -B inspect_inputs.py MERGED_FILE ARCHIVE_DIRECTORY OUTPUT_JSON
The only write is exclusive creation of OUTPUT_JSON. All source bytes are reread
and compared before that write; the output makes no kernel or acceptance claim.
"""
from pathlib import Path
import json
import sys

from closure_inputs import ORIGINAL_PINS, inspect, read_source


def main():
    assert len(sys.argv) == 4
    merged_path, archive, output = map(Path, sys.argv[1:])
    merged = read_source(merged_path)
    originals = {name: read_source(archive / (name + '.lean')) for name in ORIGINAL_PINS}
    evidence = inspect(merged, originals)
    assert read_source(merged_path) == merged
    assert all(read_source(archive / (name + '.lean')) == data for name, data in originals.items())
    with output.open('x') as stream:
        stream.write(json.dumps(evidence, indent=2, sort_keys=True) + '\n')
    print(json.dumps({'status': evidence['status'], 'closure_rows': evidence['closure_rows'],
                      'filtered_vertices': evidence['filtered_vertices'],
                      'literal_rows': {name: item['rows'] for name, item in evidence['literal_evidence'].items()},
                      'raw_fragment_bytes': evidence['raw_literal_partition']['source_bytes'],
                      'prefix_counts': [part['count'] for part in evidence['proposed_prefix_parts']],
                      'output': str(output.resolve())}), flush=True)


if __name__ == '__main__':
    main()
