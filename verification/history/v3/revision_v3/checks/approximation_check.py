#!/usr/bin/env python3
"""Small exact checks for Section 6 of the frozen v3 manuscript.

Checks the displayed sufficient numerical comparisons at A=B=S=3, K=400,
not the finite generator expansions or global numerical enumerations.
"""
from fractions import Fraction as F
from pathlib import Path
import hashlib
import json

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT.parent / 'output' / 'D1_bound5-v3.tex'
EXPECTED_SHA256 = 'a1119af75cf623411c678ea0e9b6e7dc9a3f59a931ee67384fc98be8d8373bd5'
source_hash = hashlib.sha256(SOURCE.read_bytes()).hexdigest()
assert source_hash == EXPECTED_SHA256
A = B = S = 3
K = 400
h = F(4001, 3999)
epsilon = F(1, 4000)
Mn, M3, M4, M5 = 4143, 2265, 166000, 26859063
Mm = F(8, 9) * 608**2
Rn, R3, R4, R5 = F(35, 32), F(35, 16), F(63, 8), F(495, 64)
Rm, Rbs = F(3920, 81), F(35, 32)
rows = [
    ('G-Q', F(1024*A**20*B**10)/(12100/(1-epsilon))),
    ('Q-N2', F(256*A**16*S**4)/(36*735**2*h)),
    ('N2-P, H_P=BS^3', F(K**2*A**20*B**4)/(25*2400**2*h)),
    ('N2-P, H_P=B^3S^2', F(K**2*A**20*S**2)/(25*2400**2*h)),
    ('P-N3', F(K**2*A**20)/(16*3**2*Mn**2*h)),
    ('P-A3', F(K**2*A**20)/(16*3**2*M3**2*h)),
    ('A3-M', F(K**4*A**36)/(16*R3**2*Mm**2*h)),
    ('M-N3', F(K**4*A**34*B**2*S**2)/(16*Rm**2*Mn**2*h)),
    ('N3-A4', F(K**2*A**22*B**4)/(16*Rn**2*M4**2*h)),
    ('N3-N3bs', F(K**4*A**36*B**8)/(16*Rn**2*Mn**2*h)),
    ('N3bs-A4', F(K**2*A**14)/(16*Rbs**2*M4**2*h)),
    ('A4-O4', F(K**4*A**38*B**2)/(144*R4**2*42**8*h)),
    ('O4-A5', F(K**4*A**36)/(4*M5**2*F(5, 2)**8*h)),
    ('A5-O5', F(K**6*A**54*B**10)/(144*R5**2*42**10*h)),
    ('O5-O6', F(K**6*A**52*B**4)/(36*42**12*F(5, 2)**10*h)),
]
comparisons = []
for junction, quotient in rows:
    target = F(7, 5) if junction == 'N3bs-A4' else F(13, 10)
    assert quotient > target
    comparisons.append({'junction': junction, 'exact_quotient': str(quotient),
                        'strict_lower_bound': str(target), 'passed': True})
printed_tight_quotient = F(1224133953984, 844113475625)
assert dict(rows)['N3bs-A4'] == printed_tight_quotient
mu = F(51051, 400000)
c_star = F(9999, 10000) * F(200, 19)**2
gap_coefficient = 3**5*c_star*(F(1, 8)-mu/81)**2
printed_gap_coefficient = F(16405041495117, 40000000000)
assert gap_coefficient == printed_gap_coefficient
assert gap_coefficient > K
tail_ratio_lower_bound = F(400*3**12, 105)
assert tail_ratio_lower_bound > 1
result = {
    'source': str(SOURCE), 'sha256': source_hash,
    'scope': 'Exact checks of the sufficient Section 6 overlap inequalities, gap coefficient and tail comparison',
    'substitution': {'A': A, 'B': B, 'S': S, 'K': K},
    'overlap_comparisons': comparisons,
    'printed_tight_quotient_matches': True,
    'gap': {'exact_coefficient': str(gap_coefficient),
            'printed_value_matches': True, 'strict_lower_bound': K, 'passed': True},
    'tail': {'exact_lower_bound': str(tail_ratio_lower_bound), 'exceeds_one': True},
    'all_passed': True,
}
output = Path(__file__).with_name('approximation_check_results.json')
output.write_text(json.dumps(result, indent=2) + '\n')
print(f'{len(rows)} overlap comparisons, gap, and tail checks passed.')
print(output)
