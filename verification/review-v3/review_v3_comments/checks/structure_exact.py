"""Independent rational checks for review comments 10 and 12; no paper edits."""
from fractions import Fraction as F
from hashlib import sha256
from pathlib import Path
import json

root = Path(__file__).resolve().parents[2]
paper = root / 'output/D1_bound5-v3.tex'
expected = 'a1119af75cf623411c678ea0e9b6e7dc9a3f59a931ee67384fc98be8d8373bd5'
assert sha256(paper.read_bytes()).hexdigest() == expected
results = {'paper_sha256': expected}

def record(key, value):
    results[key] = {'exact': str(value), 'decimal': float(value)}

# Lemma 2.3, first assertion; exactly the displayed constants.
e = F(128, 8649)
s, h = F(1, 2) + 3*e, F(3, 2) + 3*e
coefficient = h*s*s*(1+F(3,36)+s/324)
assert coefficient < F(1,2)
record('first_part_coefficient', coefficient)
record('first_part_margin_below_half', F(1,2)-coefficient)

# Second assertion, using D>6C and D>18 from Lemma 2.2.
# Existing spectral bound ||E||<1/8 already yields >1.45 ABC.
coefficient = F(325,512)*(1+F(3,36)+F(5,8)/324)
assert coefficient < F(20,29)
record('second_part_existing_spectral_coefficient', coefficient)
record('second_part_existing_spectral_bound', 1/coefficient)

# Already displayed weighted rows give the stronger ||E||<11/96.
# Thus s=1/2+11/96, h=3/2+11/96. Singular values and adjugate
# estimates are exactly the same as in the existing proof.
s, h = F(59,96), F(155,96)
coefficient = h*s*s*(1+F(3,36)+s/324)
assert coefficient < F(2,3)
record('second_part_improved_spectral_coefficient', coefficient)
record('second_part_margin_below_two_thirds', F(2,3)-coefficient)
record('second_part_improved_bound', 1/coefficient)

# First of the five regions: H/(kappa F_p)>20687, not rounded equality.
cstar = F(9999,10000)*F(200,19)**2
mu, kappa = F(51051,400000), F(3535,409600)
m, t, q, fp = 8, F(27,8), F(8), 269
q0 = 2*(1+1/q)**2
h = cstar*t**5*(1-mu*q0/m**2)**2
rho_exact = h/(kappa*fp)
assert rho_exact > 20687
record('first_region_rho_exact', rho_exact)
record('first_region_rho_margin', rho_exact-20687)

# Independently transcribed integer coefficient-sum rows from section 5.2.
families = [
    ('N2',2,2,243,[[96,352,256],[100,400,480]]),
    ('N3',3,4,4143,[[1344,9408,17024,8960],[1368,8384,23168,16384]]),
    ('A3',3,4,2265,[[800,4544,10368,6144],[1288,4256,9856,8960]]),
    ('A4',4,2,165763,[[10944,86784,350208,482304,215040],[18128,80512,276096,561920,327680]]),
    ('A5',5,4,3113013,[[156000,1601280,9707520,22379520,22087680,7864320],[262152,1463264,6707712,22437888,28452864,12300288]])
]
for name,k,g,m,rows in families:
    bound = F(101,100*g)*max(sum(F(l,1000**(k-i)) for i,l in enumerate(row)) for row in rows)
    assert 0 < m-bound < 1
    record(name+'_M_bound',bound)
    record(name+'_M_margin',m-bound)

path = Path(__file__).with_suffix('.json')
path.write_text(json.dumps(results,indent=2)+'\n')
print(json.dumps(results,indent=2))
