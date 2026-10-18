#!/usr/bin/env python3
"""Generate an optional eight-module, full-tail LEFT34 computation.

No data is copied or modified. Every module refers to the frozen pure data34.
The separate proof module composes exactly the original certificate.
"""
import argparse
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
DATA_SHA = '6eb18ec1ec46c6b05910af2bed24ce3e93897cf152ae676aa67eb92e8f49689c'
HELPERS = {
    'PairLightArithmeticChunks.lean': 'f6567fcbc7792894e8607b67148594c393fe089550470cc632f4beffbdcfaca7',
    'PairLightArithmeticChunkProofs.lean': '658b9d78aa5789e1a26cdcfc58f5960c552bb3ae7fdeda34961f362a081828a4',
}
N = 229
WIDTH = 32
BLOCKS = (N + WIDTH - 1) // WIDTH
NS = 'D1Bound5.PairLightChunkedPilot34'
HEADER = f'namespace {NS}\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n'
FOOTER = f'\nend {NS}\n'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def render():
    out = {}
    common = ('import D1Bound5.SmallPairLightData34\n'
              'import D1Bound5.PairLightArithmeticChunks\n\n' + HEADER)
    common += 'def cached00 : List PairLightCachedVertex := PairLightPilot34.leftCached\n'
    common += 'def rows00 : List (Nat × List Nat) := PairLightPilot34.leftRows\n\n'
    for j in range(1, BLOCKS + 1):
        common += f'def cached{j:02} : List PairLightCachedVertex := cached{j-1:02}.drop {WIDTH}\n'
        common += f'def rows{j:02} : List (Nat × List Nat) := rows{j-1:02}.drop {WIDTH}\n\n'
    out['SmallPairLightChunkData34.lean'] = common + FOOTER
    out['SmallPairLightChunkValidation34.lean'] = (
        'import D1Bound5.SmallPairLightChunkData34\n\n' + HEADER +
        '/-- The complete ordered vertex projection, with no trusted data alignment. -/\n'
        'theorem left_coverage_checked :\n'
        '    decide (PairLightPilot34.leftCached.map Prod.fst = PairLightPilot34.leftVertices) = true := by\n'
        '  decide +kernel\n\n'
        '/-- Every canonical residue signature is retained and checked once. -/\n'
        'theorem left_signatures_checked :\n'
        '    (PairLightPilot34.leftCached.all fun x =>\n'
        '      decide (x.2 = pairLightCoordinateSignature PairLightPilot34.sieve x.1)) = true := by\n'
        '  decide +kernel\n' + FOOTER)
    for j in range(BLOCKS):
        lo, hi = j * WIDTH, min((j + 1) * WIDTH, N) - 1
        out[f'SmallPairLightChunkLeft34_{j:02}.lean'] = (
            'import D1Bound5.SmallPairLightChunkData34\n\n' + HEADER +
            f'/-- Heads {lo} through {hi}; each is checked against its entire actual tail. -/\n'
            f'theorem left_prefix_{j:02}_checked :\n'
            f'    pairLightSelectedFloorPrefixBool 1 2 PairLightPilot34.sieve {WIDTH}\n'
            f'      cached{j:02} rows{j:02} = true := by\n'
            '  decide +kernel\n' + FOOTER)
    proof = 'import D1Bound5.PairLightArithmeticChunkProofs\n'
    proof += 'import D1Bound5.SmallPairLightChunkValidation34\n'
    proof += ''.join(f'import D1Bound5.SmallPairLightChunkLeft34_{j:02}\n' for j in range(BLOCKS))
    proof += '\n' + HEADER
    proof += ('/-- Both lists are exhausted after all eight prefixes. -/\n'
              f'theorem left_remainder_{BLOCKS:02}_checked :\n'
              '    pairLightSelectedFloorIndependentBool 1 2 PairLightPilot34.sieve\n'
              f'      cached{BLOCKS:02} rows{BLOCKS:02} = true := by\n  rfl\n\n')
    for j in reversed(range(BLOCKS)):
        proof += (f'theorem left_remainder_{j:02}_checked :\n'
                  '    pairLightSelectedFloorIndependentBool 1 2 PairLightPilot34.sieve\n'
                  f'      cached{j:02} rows{j:02} = true :=\n'
                  f'  pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 PairLightPilot34.sieve {WIDTH}\n'
                  f'    cached{j:02} rows{j:02} left_prefix_{j:02}_checked left_remainder_{j+1:02}_checked\n\n')
    proof += ('/-- Assemble checked proof constants; do not evaluate the complete pair computation again. -/\n'
              'theorem left_certificate_checked :\n'
              '    pairLightSelectedFloorIndependentCertificateBool 1 2 PairLightPilot34.sieve\n'
              '      PairLightPilot34.leftVertices PairLightPilot34.leftCached PairLightPilot34.leftRows = true :=\n'
              '  pairLightSelectedFloorIndependentCertificateBool_of_checked_parts 1 2 PairLightPilot34.sieve\n'
              '    PairLightPilot34.leftVertices PairLightPilot34.leftCached PairLightPilot34.leftRows\n'
              '    left_coverage_checked left_signatures_checked left_remainder_00_checked\n')
    out['SmallPairLightChunkedLeft34.lean'] = proof + FOOTER
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--data-file', type=Path,
                        default=ROOT / 'pair_light_next/left34_v2/SmallPairLightData34.lean')
    parser.add_argument('--helper-dir', type=Path, default=HERE)
    parser.add_argument('--output-dir', type=Path, default=HERE / 'generated')
    args = parser.parse_args()
    if sha(args.data_file.read_bytes()) != DATA_SHA:
        raise SystemExit('Frozen pure data34 SHA mismatch; nothing emitted.')
    for name, expected in HELPERS.items():
        if sha((args.helper_dir / name).read_bytes()) != expected:
            raise SystemExit(f'Helper SHA mismatch: {name}; nothing emitted.')
    if args.output_dir.exists():
        raise SystemExit('Output directory must be new; nothing overwritten.')
    sources = render()
    pair_counts = [sum(N - 1 - i for i in range(j * WIDTH, min((j + 1) * WIDTH, N)))
                   for j in range(BLOCKS)]
    assert sum(pair_counts) == N * (N - 1) // 2 == 26106
    manifest = {
        'status': 'Optional uncompiled chunk source; no performance or original theorem claim',
        'generator_sha256': sha(Path(__file__).read_bytes()),
        'pure_data_sha256': DATA_SHA,
        'helper_sha256': HELPERS,
        'vertices': N,
        'width': WIDTH,
        'blocks': BLOCKS,
        'head_ranges_exclusive': [[j * WIDTH, min((j + 1) * WIDTH, N)] for j in range(BLOCKS)],
        'pairs_by_block': pair_counts,
        'pairs_total': sum(pair_counts),
        'full_tail_per_head': True,
        'all_coverage_and_signatures_retained': True,
        'copied_coordinate_or_signature_records': 0,
        'files': {name: {'sha256': sha(content.encode()), 'bytes': len(content.encode())}
                  for name, content in sources.items()},
    }
    args.output_dir.mkdir(parents=True)
    for name, content in sources.items():
        (args.output_dir / name).write_text(content)
    (args.output_dir / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    print(json.dumps({'files': len(sources), 'pairs_by_block': pair_counts,
                      'manifest_sha256': sha((args.output_dir / 'manifest.json').read_bytes())}))


if __name__ == '__main__':
    main()
