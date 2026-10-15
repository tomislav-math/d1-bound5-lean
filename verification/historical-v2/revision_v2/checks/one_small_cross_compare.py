"""Compare already independent final-source audits; no calculation is shared."""
from pathlib import Path
from fractions import Fraction
import json, hashlib

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
source = ROOT / 'output/D1_bound5-v2.tex'
sha = hashlib.sha256(source.read_bytes()).hexdigest()
assert sha == '5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70'
a = json.loads((HERE / 'one_small_v2_results.json').read_text())
b = json.loads((HERE / 'completion_exact.json').read_text())
assert a['source_sha256'] == b['sha256'] == sha
own = {(r['pair'], tuple(r['s'])): r for r in a['fixed56']}
own[(40, (8, 0))] = a['rational']
other = {(r['pair'], tuple(r['s'])): r for r in b['cutoffs']}
assert own.keys() == other.keys() and len(own) == 57
n = 0
for key, r in own.items():
    s = other[key]
    for field in ('Mbs', 'N0', 'thresholds', 'eta', 'K', 'q1'):
        assert r[field] == s[field], (key, field)
        n += 1
    assert r['ntail'] == s['n_infinity'], key
    assert min(map(Fraction, r['quotients'])) == Fraction(s['minimum_overlap_at_N0']), key
    n += 2
assert a['maximum_quadratic_upper'] == b['quadratic_worst_regular_upper']
assert a['completion_counts'] == {'tail': len(b['finite_tail_rows']),
                                 'quadratic': 16, 'quadratic+annulus': 2}
print('SOURCE', sha)
print('PASS: all 57 row keys and', n, 'independent cutoff fields agree exactly.')
print('PASS: exact worst quadratic endpoint and completion partition agree.')
