"""Pure Python diagnostic of the frozen cached Left41 fallback pairs.

No Lean source is emitted. This is not kernel certificate acceptance.
"""
from pathlib import Path
from math import isqrt
from collections import Counter
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / 'pair_witness_next/cached_pilot41/cached_pilot41_manifest.json'
manifest = json.loads(MANIFEST.read_text())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
inputs = {}
for name, expected in manifest['inputs'].items():
    path = ROOT / name
    digest = sha(path)
    assert digest == expected, (name, digest, expected)
    inputs[name] = digest
inputs[str(MANIFEST.relative_to(ROOT))] = sha(MANIFEST)
inputs['pair_witness_next/generate_cached_pilot41.py'] = sha(ROOT / 'pair_witness_next/generate_cached_pilot41.py')
for name, meta in manifest['files'].items():
    path = MANIFEST.parent / name
    assert sha(path) == meta['sha256'], name
    inputs[str(path.relative_to(ROOT))] = sha(path)

pilot = (ROOT / 'finite_fast_next/graphs/SmallPairBipartitePilotData41.lean').read_text()
sieve_source = (ROOT / 'finite_fast_next/sieves/SmallPairSieve_1_2.lean').read_text()
literal = re.search(r'def smallPairPilotLarge_41 .*? := \[(.*?)\n\]', pilot, re.S).group(1)
pattern = r'⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩'
vertices = [tuple(map(int, p)) for p in re.findall(pattern, literal)]
assert len(vertices) == 372
assert re.sub(pattern, '', literal).replace(',', '').strip() == ''
colors = int(re.search(r'def smallPairPilotColors_41 : ℕ := (\d+)', pilot).group(1))
mask_values = {name: int(value) for name, value in re.findall(r'def (smallPairMask_1_2_\d+) : ℕ := (\d+)', sieve_source)}
sieve_literal = re.search(r'def smallPairSieve_1_2 .*? := \[(.*?)\n\]', sieve_source, re.S).group(1)
sieve = [(int(k) + 1, mask_values[name]) for k, name in re.findall(r'\((\d+),\s*(smallPairMask_1_2_\d+)\)', sieve_literal)]
assert len(sieve) == 25
left = [i for i in range(len(vertices)) if (colors >> i) & 1 == 0]
assert len(left) == 186
routine = ROOT / 'finite_next/two_small/generate_pair_closures.py'
spec = importlib.util.spec_from_file_location('frozen_exact_pair_diagnostic', routine)
exact = importlib.util.module_from_spec(spec)
spec.loader.exec_module(exact)

rows = []
pairs_tested = 0
for off, i in enumerate(left):
    for j in left[off + 1:]:
        pairs_tested += 1
        x, y = vertices[i]
        u, v = vertices[j]
        product = (x*u - 2*y*v + 1, x*v + y*u + y*v)
        assert product == exact.add(exact.mul(1, 2, vertices[i], vertices[j]), (1, 0))
        if any(not (mask >> ((product[0] % m)*m + product[1] % m)) & 1 for m, mask in sieve):
            continue
        a, b = product
        norm = a*a + a*b + 2*b*b
        assert norm == exact.norm(1, 2, product)
        assert norm >= 0
        h = isqrt(norm)
        square = h*h == norm
        assert exact.root(1, 2, product) is None
        rows.append({'i': i, 'j': j, 'norm': norm, 'norm_is_square': square,
                     'norm_bit_length': norm.bit_length()})
assert pairs_tested == 17205
assert len(rows) == 884

# Enumerating all m in increasing order gives the least positive modulus
# (not merely the least tested prime) whenever a witness is found.
remaining = [r for r in rows if not r['norm_is_square']]
max_search = 10000
for m in range(2, max_search + 1):
    squares = {x*x % m for x in range(m)}
    keep = []
    for r in remaining:
        residue = r['norm'] % m
        if residue not in squares:
            r['least_nonsquare_modulus'] = m
            r['norm_residue'] = residue
        else:
            keep.append(r)
    remaining = keep
    if not remaining:
        break

square_rows = [r for r in rows if r['norm_is_square']]
for r in rows:
    del r['norm']
summary = {
    'status': 'Python exact-integer diagnostic only; no Lean changes or kernel acceptance',
    'inputs_sha256': inputs,
    'diagnostic_script_sha256': sha(Path(__file__)),
    'tau': 1, 'nu': 2, 'class': 'Left (mask bit 0)',
    'vertices': len(left), 'unordered_pairs': pairs_tested, 'fallback_pairs': len(rows),
    'norm_nonsquares': len(rows) - len(square_rows), 'norm_perfect_squares': len(square_rows),
    'all_original_quadratic_root_tests_reject': True,
    'least_modulus_histogram': dict(sorted(Counter(r['least_nonsquare_modulus'] for r in rows if 'least_nonsquare_modulus' in r).items())),
    'max_least_nonsquare_modulus': max((r['least_nonsquare_modulus'] for r in rows if 'least_nonsquare_modulus' in r), default=None),
    'unresolved_nonsquare_norm_count': len(remaining), 'modulus_search_limit': max_search,
    'norm_bit_length_min': min(r['norm_bit_length'] for r in rows),
    'norm_bit_length_max': max(r['norm_bit_length'] for r in rows),
    'fallback_pair_diagnostics': rows,
}
out = ROOT / 'audit_next/left41_norm_fallback_diagnostic.json'
out.write_text(json.dumps(summary, indent=2) + '\n')
print(json.dumps({k:v for k,v in summary.items() if k not in ['inputs_sha256','fallback_pair_diagnostics']}, indent=2))
print('OUTPUT', out, 'SHA256', sha(out))
