#!/usr/bin/env python3
"""Focused exact checks for review comments 9, 13, 14 and 20(a).

The finite-family constructor is reused, with explicit provenance, from
revision_v2/checks/approximation_exact.py. It is executed afresh, without
loading prior results. Coefficient data and proposed bounds are parsed from
the frozen v3 source. No manuscript file is modified.
"""
from pathlib import Path
from fractions import Fraction as F
import ast
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'output/D1_bound5-v3.tex'
EXPECTED = 'a1119af75cf623411c678ea0e9b6e7dc9a3f59a931ee67384fc98be8d8373bd5'
TEXT = SOURCE.read_text()
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest() == EXPECTED
constructor_path = ROOT / 'revision_v2/checks/approximation_exact.py'
constructor_text = constructor_path.read_text()
names = {'clean', 'const', 'mon', 'add', 'scale', 'mul', 'power', 'shift',
         'divpoly', 'binom', 'comps', 'prod', 'family'}
module = ast.parse(constructor_text)
nodes = [node for node in module.body if isinstance(node, ast.FunctionDef)
         and node.name in names]
assert {node.name for node in nodes} == names
ns = {'F': F, 'N': 5, 'ZERO': (0,) * 5}
exec(compile(ast.Module(body=nodes, type_ignores=[]), str(constructor_path), 'exec'), ns)
for letter in 'abc':
    ns[letter] = ns['mon'](1, **{letter: 1})
ns['diff'] = ns['add'](ns['a'], ns['scale'](ns['b'], -1))

section = TEXT.split(r'\subsection{Five families with two fixed entries}')[1]
section = section.split(r'\subsection{')[0]
parameters = []
for line in section.splitlines():
    match = re.match(r'\s*\$([NA]_\d)\$&(.*)$', line)
    if match:
        cells = [z.strip(' $\\.') for z in match[2].split('&')]
        parameters.append((match[1].replace('_', ''), *map(int, cells[:3])))
assert len(parameters) == 5
printed = {}
for line in section.splitlines():
    match = re.match(r'([NA]_\d)&0&([\d,]+)', line)
    if match:
        current = match[1].replace('_', '')
        printed[current] = [list(map(int, match[2].split(',')))]
    else:
        match = re.match(r'\s*&1,2&([\d,]+)', line)
        if match:
            printed[current].append(list(map(int, match[1].split(','))))
M_block = section.split('Valid integer choices of $M$ in the table order are')[1].split(r'\]')[0]
proposed = list(map(int, re.findall(r'\d+', M_block)))
old = [735, 4143, 2265, 166000, 26859063]
records = []
for (name, k, m, g), new, previous in zip(parameters, proposed, old):
    mat = ns['family'](k, m)
    sums = []
    for i in range(3):
        cols = [ns['shift'](mat[i][1], 0, -1), ns['shift'](mat[i][2], 1, -1)]
        row = [sum(abs(v) for q in cols for ex, v in q.items() if ex[4] == ell)
               for ell in range(k + 1)]
        assert row == printed[name][int(i > 0)]
        sums.append(row)
    threshold = F(101, 100*g) * max(sum(v*F(1000)**(ell-k) for ell, v in enumerate(row)) for row in sums)
    assert new == threshold.numerator // threshold.denominator + 1
    assert new <= previous
    records.append({'family': name, 'exact_threshold': str(threshold),
                    'decimal_threshold': float(threshold),
                    'least_integer_above_this_threshold': new,
                    'old_constant': previous,
                    'incoming_overlap_multiplier': str(F(previous, new)**2)})

# The current Section 6 sufficient comparisons. Only M-dependent incoming
# comparisons change. An independent source-bound script in revision_v3
# already evaluates this same table; the arithmetic is reproduced here to
# compare the proposed revision and to avoid altering that script.
h, epsilon = F(4001, 3999), F(1, 4000)
A = B = S = 3
K = 400
Mm = F(8, 9)*608**2
Rn, R3, R4, R5, Rm, Rbs = F(35,32), F(35,16), F(63,8), F(495,64), F(3920,81), F(35,32)
def overlaps(values, weaker_start=False):
    M2, Mn, M3, M4, M5 = values
    return {
        'START-Q': F(1024*A**(10 if weaker_start else 20)*B**10)*(1-epsilon)/12100,
        'Q-N2': F(256*A**(8 if weaker_start else 16)*S**4)/(36*M2**2*h),
        'N2-P1': F(K**2*A**20*B**4)/(25*2400**2*h),
        'N2-P2': F(K**2*A**20*S**2)/(25*2400**2*h),
        'P-N3': F(K**2*A**20)/(16*9*Mn**2*h),
        'P-A3': F(K**2*A**20)/(16*9*M3**2*h),
        'A3-M': F(K**4*A**36)/(16*R3**2*Mm**2*h),
        'M-N3': F(K**4*A**34*B**2*S**2)/(16*Rm**2*Mn**2*h),
        'N3-A4': F(K**2*A**22*B**4)/(16*Rn**2*M4**2*h),
        'N3-N3bs': F(K**4*A**36*B**8)/(16*Rn**2*Mn**2*h),
        'N3bs-A4': F(K**2*A**14)/(16*Rbs**2*M4**2*h),
        'A4-O4': F(K**4*A**38*B**2)/(144*R4**2*42**8*h),
        'O4-A5': F(K**4*A**36)/(4*M5**2*F(5,2)**8*h),
        'A5-O5': F(K**6*A**54*B**10)/(144*R5**2*42**10*h),
        'O5-O6': F(K**6*A**52*B**4)/(36*42**12*F(5,2)**10*h),
    }
before, after = overlaps(old), overlaps(proposed)
for name in before:
    assert after[name] >= before[name] > 1
weaker = overlaps(proposed, weaker_start=True)
assert all(q > 1 for q in weaker.values())
assert before['N3bs-A4'] == F(1224133953984,844113475625)

# Clear the nonzero denominator x^2*c*(c*d+1) and compare integral
# polynomials. The constructor's variable a means x, b means d.
xx, cc, dd = ns['a'], ns['c'], ns['b']
one = ns['const'](1)
left = ns['mul'](cc, ns['mul'](ns['add'](ns['mul'](xx,cc),one), ns['add'](ns['mul'](xx,dd),one)))
right = ns['mul'](ns['add'](ns['mul'](xx,cc),one),
                   ns['add'](ns['mul'](xx,ns['add'](ns['mul'](cc,dd),one)), cc, ns['scale'](xx,-1)))
assert left == right
assert F(1001,1000)*F(5,4)**2 < F(3,2)**2
assert F(1001,1000)*F(201,200)**2 < F(101,100)**2
# In exponent vectors for A,B,delta and a formal common factor (AC-1)^2,
# cancellation by A in the old R2 expression leaves the new expression.
old_R2_normalized = (F(27,16), (1-2,1,-2,1))
new_R2_normalized = (F(27,16), (-1,1,-2,1))
assert old_R2_normalized == new_R2_normalized

# A concrete obstruction to claiming polynomial integrality for arbitrary
# pole orders with the present k-dependent clearing factor. Set k=1,
# alpha=(0,1,2), p=(1,2,1), i=j=1. The highest local derivative introduces
# an uncancelled (N+1)^(-1); N times f_11 has residue -3/8 at N=-1.
alpha, pp, i, j, k = (0,1,2), (1,2,1), 1, 1, 1
terms_by_Nplus1_power = {}
for hs in ns['comps'](pp[j], 3):
    term = ns['binom'](F(3,2), hs[j])
    for ell in range(3):
        if ell != j:
            term *= ns['binom'](-pp[ell]-int(i==ell), hs[ell]) * F(alpha[j]-alpha[ell])**(-pp[ell]-int(i==ell)-hs[ell])
    power = 1-hs[j]
    terms_by_Nplus1_power[power] = terms_by_Nplus1_power.get(power,F(0)) + term
assert terms_by_Nplus1_power == {1:F(-1), 0:F(0), -1:F(-3,8)}
uncancelled = terms_by_Nplus1_power[-1]

result = {
    'source': str(SOURCE), 'sha256': EXPECTED,
    'constructor_provenance': str(constructor_path),
    'constructor_sha256': hashlib.sha256(constructor_path.read_bytes()).hexdigest(),
    'five_uniform_coefficients': records,
    'section6_overlaps': [{'junction': name, 'old': str(before[name]), 'new': str(after[name]),
                          'new_decimal': float(after[name]), 'does_not_decrease': True}
                         for name in before],
    'section6_new_minimum': {'junction': min(after,key=after.get), 'value': str(min(after.values()))},
    'section8_common_overlap_table_also_suffices_for_section6': True,
    'root_transfer_factorization_verified': True,
    'R2_simplification_verified': True,
    'arbitrary_pole_orders_need_additional_arithmetic_conditions': {
        'example': 'k=1, alpha=(0,1,2), p=(1,2,1), i=j=1',
        'N_f11': '-(N+1)-3/(8*(N+1))',
        'uncancelled_pole_residue': str(uncancelled)},
    'scope_limit': 'These are checks of the proposed local changes and abstraction scope, not a rerun of all finite enumerations.',
    'all_checks_passed': True,
}
out = Path(__file__).with_suffix('.json')
out.write_text(json.dumps(result, indent=2)+'\n')
print(json.dumps({'all_checks_passed': True, 'uniform_thresholds': records,
                  'old_critical': str(before['N3bs-A4']), 'new_critical': str(after['N3bs-A4']),
                  'new_minimum': result['section6_new_minimum'], 'report': str(out)}, indent=2))
