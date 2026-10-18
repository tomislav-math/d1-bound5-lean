"""Exact scalar/floor-witness diagnostic of frozen Left41 fallback pairs.

Only Python diagnostics are written. No Lean source, compilation, or remote work.
"""
from pathlib import Path
from math import isqrt
from collections import Counter
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'audit_next/left41_norm_fallback_diagnostic.json'
BASE_SHA = 'e013b6d22626ade79504a23f0a05da7f8db7e86dabded467969ea017f106f0ef'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(BASE) == BASE_SHA
base = json.loads(BASE.read_text())
for name, expected in base['inputs_sha256'].items():
    assert sha(ROOT / name) == expected, name
pilot = (ROOT / 'finite_fast_next/graphs/SmallPairBipartitePilotData41.lean').read_text()
literal = re.search(r'def smallPairPilotLarge_41 .*? := \[(.*?)\n\]', pilot, re.S).group(1)
vertices = [tuple(map(int, p)) for p in re.findall(r'⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩', literal)]
assert len(vertices) == 372
routine = ROOT / 'finite_next/two_small/generate_pair_closures.py'
spec = importlib.util.spec_from_file_location('frozen_exact_trace_diagnostic', routine)
exact = importlib.util.module_from_spec(spec)
spec.loader.exec_module(exact)

def floor_witness(x):
    assert x >= 0
    h = isqrt(x)
    assert h*h <= x < (h+1)*(h+1)
    return {'value': x, 'floor': h, 'square': h*h == x,
            'lower_gap': x - h*h, 'upper_gap': (h+1)*(h+1) - x,
            'bit_length': x.bit_length()}

def range_summary(xs):
    if not xs:
        return None
    return {'min': min(xs), 'max': max(xs),
            'min_bit_length': min(x.bit_length() for x in xs),
            'max_bit_length': max(x.bit_length() for x in xs)}

rows = []
counts = Counter()
for original in base['fallback_pair_diagnostics']:
    i, j = original['i'], original['j']
    z = exact.add(exact.mul(1, 2, vertices[i], vertices[j]), (1, 0))
    a, b = z
    N = a*a + a*b + 2*b*b
    n = isqrt(N)
    assert n*n == N
    T = 2*a + b
    trace_value = T + 2*n
    imag_numerator = 2*n - T
    assert trace_value >= 0 and imag_numerator >= 0
    E = floor_witness(trace_value)
    divisible = imag_numerator % 7 == 0
    F = floor_witness(imag_numerator // 7) if divisible else None
    counts['trace_square' if E['square'] else 'trace_nonsquare'] += 1
    counts['negative_rational_product' if b == 0 and a < 0 else 'other_product'] += 1
    counts['real_coordinate_nonzero_mod_7' if a % 7 else 'real_coordinate_zero_mod_7'] += 1
    counts['imag_numerator_divisible_by_7' if divisible else 'imag_numerator_not_divisible_by_7'] += 1
    if F is not None:
        counts['imag_square' if F['square'] else 'imag_nonsquare'] += 1
    parity = []
    roots = []
    if E['square'] and F is not None and F['square']:
        for t in sorted({-E['floor'], E['floor']}):
            for y in sorted({-F['floor'], F['floor']}):
                even = (t-y) % 2 == 0
                parity.append({'trace': t, 'im': y, 'coordinate_parity_ok': even})
                if even:
                    x = (t-y)//2
                    if exact.mul(1,2,(x,y),(x,y)) == z:
                        roots.append((x,y))
        counts['all_scalar_squares_parity_possible' if any(p['coordinate_parity_ok'] for p in parity) else 'all_scalar_squares_parity_impossible'] += 1
    assert roots == []
    assert exact.root(1,2,z) is None
    if not E['square']:
        obstruction = 'trace_nonsquare'
    elif not divisible:
        obstruction = 'imaginary_numerator_not_divisible_by_7'
    elif not F['square']:
        obstruction = 'imaginary_coordinate_nonsquare'
    elif not any(p['coordinate_parity_ok'] for p in parity):
        obstruction = 'coordinate_parity'
    else:
        obstruction = 'remaining_sign_or_product_constraint'
    counts['first_obstruction_' + obstruction] += 1
    rows.append({'i':i,'j':j,'product_re':a,'product_im':b,
                 'product_re_mod_7':a%7,'norm':N,'norm_root':n,'trace':T,
                 'trace_square_test':E,'imaginary_numerator':imag_numerator,
                 'imaginary_numerator_mod_7':imag_numerator % 7,
                 'imaginary_square_test':F,'parity_candidates':parity,
                 'first_obstruction':obstruction})

# For nonsquare trace targets, also find the least practical modular witness.
# Supplied floor witnesses already certify all nonsquares without this search.
remaining = [r for r in rows if not r['trace_square_test']['square']]
for m in range(2,10001):
    sq = {u*u % m for u in range(m)}
    keep=[]
    for r in remaining:
        residue=r['trace_square_test']['value'] % m
        if residue not in sq:
            r['least_trace_nonsquare_modulus']=m
            r['trace_residue']=residue
        else:
            keep.append(r)
    remaining=keep
    if not remaining:
        break

summary={
 'status':'Python exact-integer diagnostics only; no Lean changes or kernel acceptance',
 'base_diagnostic_sha256':BASE_SHA,'inputs_sha256':base['inputs_sha256'],
 'diagnostic_script_sha256':sha(Path(__file__)),
 'tau':1,'nu':2,'discriminant_positive':7,'fallback_pairs':len(rows),
 'counts':dict(sorted(counts.items())),
 'product_real_coordinate_range':range_summary([r['product_re'] for r in rows]),
 'product_imaginary_coordinate_range':range_summary([r['product_im'] for r in rows]),
 'product_real_mod_7_histogram':dict(sorted(Counter(r['product_re_mod_7'] for r in rows).items())),
 'imaginary_numerator_mod_7_histogram':dict(sorted(Counter(r['imaginary_numerator_mod_7'] for r in rows).items())),
 'norm_root_range':range_summary([r['norm_root'] for r in rows]),
 'trace_value_range':range_summary([r['trace_square_test']['value'] for r in rows]),
 'trace_floor_range':range_summary([r['trace_square_test']['floor'] for r in rows]),
 'trace_nonsquare_lower_gap_range':range_summary([r['trace_square_test']['lower_gap'] for r in rows if not r['trace_square_test']['square']]),
 'trace_upper_gap_range':range_summary([r['trace_square_test']['upper_gap'] for r in rows]),
 'imaginary_numerator_range':range_summary([r['imaginary_numerator'] for r in rows]),
 'trace_modulus_histogram':dict(sorted(Counter(r['least_trace_nonsquare_modulus'] for r in rows if 'least_trace_nonsquare_modulus' in r).items())),
 'max_least_trace_nonsquare_modulus':max((r['least_trace_nonsquare_modulus'] for r in rows if 'least_trace_nonsquare_modulus' in r),default=None),
 'unresolved_modular_trace_count':len(remaining),
 'all_floor_witnesses_verified':True,
 'pairs':rows,
}
out=ROOT/'audit_next/left41_trace_fallback_diagnostic.json'
out.write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k in ['status','fallback_pairs','counts','product_real_mod_7_histogram','imaginary_numerator_mod_7_histogram','trace_modulus_histogram','max_least_trace_nonsquare_modulus','unresolved_modular_trace_count','all_floor_witnesses_verified']},indent=2))
for key in ['norm_root_range','trace_value_range','trace_floor_range','trace_nonsquare_lower_gap_range','trace_upper_gap_range','imaginary_numerator_range']:
    value=summary[key]
    print(key, 'bits', (value['min_bit_length'],value['max_bit_length']) if value else None)
print('OUTPUT',out,'SHA256',sha(out),'BYTES',out.stat().st_size)
