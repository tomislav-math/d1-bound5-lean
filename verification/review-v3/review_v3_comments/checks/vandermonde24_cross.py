"""Independent downstream rational checks for the optional 24-term bound."""
from fractions import Fraction as F
from itertools import permutations
from pathlib import Path
import json

out = {}
k = F(1,1000)
r = F(7,64)*(F(1000,999)**4-1)
l = (1-k)**2*(5-6*k-5*k*k)/128-r
u = (1+k)**2*(5+6*k+5*k*k)/128+r
assert F(24*101,199) < 13
assert 2400*u/99 < F(49,50)
assert 100/(201*u) > 10
assert 100/(199*l) < 17
out['new_first_coefficient'] = str(F(24*101,199))
out['new_second_coefficient'] = str(2400*u/99)
out['unchanged_zero_case_lower'] = str(100/(201*u))
out['unchanged_zero_case_upper'] = str(100/(199*l))

# Exponent rearrangement for A<=B<=S<=T: after division by BS^2T^3,
# express each monomial in ratios A/B,B/S,S/T. All exponents are >=0.
for p in permutations(range(4)):
    q = [p[0], p[0]+p[1]-1, p[0]+p[1]+p[2]-3]
    assert min(q)>=0, (p,q)
out['permutation_monomials_checked'] = 24

# Retained gap: C>1296BST, B>=3,A>=1, Z^2>k0*A^2*C^6/S^2.
k0 = F(3999,4000)
first_square = F(169)/(k0*81*1296**6)
assert first_square < F(1,10000)
out['retained_first_term_square_upper'] = str(first_square)
# New coefficient 49/50 and first summand <1/100 give Z>99/98 * ... .
assert (1-F(1,100))/F(49,50) == F(99,98)
loss = F(99,98)**2-1
assert loss == F(197,9604)
# Existing C>3ABST and A,B,S,T>=1 more than suffice for subtraction of1.
assert loss*3**8 > 1
out['retained_subtraction_margin_lower'] = str(loss*3**8-1)

# Cutoff lemma, third downstream invocation; C>=10^100, M=10^8.
M,C = 10**8,10**100
assert F(78*M**5,C) < F(1,2)
assert F(1,2)/F(49,50) == F(25,49)
coefficient = F(25,49)**2
assert (coefficient-F(1,100))*C**8 > M**6
out['cutoff_first_term_upper'] = str(F(78*M**5,C))
out['cutoff_new_leading_coefficient'] = str(coefficient)
out['cutoff_original_retained_coefficient'] = '1/100'

p = Path(__file__).with_suffix('.json')
p.write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
