#!/usr/bin/env python3
"""Bounded exact checks for reviewer points 2, 3, 5, 6, 7, 20(b).

No large graph enumeration is rerun. The graph matching observation is
checked algebraically and against the preserved existing per-field record.
"""
import hashlib
import json
import re
from fractions import Fraction as F
from itertools import combinations
from math import isqrt
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
source = ROOT / 'output/D1_bound5-v3.tex'
expected = 'a1119af75cf623411c678ea0e9b6e7dc9a3f59a931ee67384fc98be8d8373bd5'
digest = hashlib.sha256(source.read_bytes()).hexdigest()
assert digest == expected
text = source.read_text()
out = {'source_sha256': digest, 'status': 'PASS'}

# Point 2: the three-anchor bound is decreasing as AT increases.
f3_coefficient = lambda at: F(1, 4) / (1 - F(1, at))**3
assert f3_coefficient(9) > F(1, 3)
assert f3_coefficient(10) > F(1, 3)
assert f3_coefficient(11) == F(1331, 4000) < F(1, 3)
out['F3'] = {'at_9': str(f3_coefficient(9)),
             'at_11': str(f3_coefficient(11)),
             'margin_at_11': str(F(1, 3)-f3_coefficient(11)),
             'least_sufficient_integer_AT': 11}

# Point 3: the two discriminant cutoffs give exactly the same 21 fields.
def squarefree(n):
    return all(n % (p*p) for p in range(2, isqrt(n)+1))

def disc(d):
    return d if d % 4 == 3 else 4*d

fields60 = [d for d in range(1, 65) if squarefree(d) and disc(d) <= 60]
fields64 = [d for d in range(1, 65) if squarefree(d) and disc(d) <= 64]
assert fields60 == fields64 == [1,2,3,5,6,7,10,11,13,14,15,19,23,31,35,39,43,47,51,55,59]
out['discriminant_cutoff'] = {'fields': fields60, 'same_for_60_and_64': True}

# Fresh enumeration of the small tail case, independent of the stored record.
# Coordinates are the integral-basis coordinates used in Lemma 2.2.
records = []
for d in fields60:
    tau, nu = (1, (d+1)//4) if d % 4 == 3 else (0, d)
    def norm(z):
        return z[0]**2 + tau*z[0]*z[1] + nu*z[1]**2
    def add(z,w):
        return z[0]+w[0], z[1]+w[1]
    def mul(z,w):
        return z[0]*w[0]-nu*z[1]*w[1], z[0]*w[1]+z[1]*w[0]+tau*z[1]*w[1]
    def disk(bound):
        ymax = isqrt(4*bound//disc(d))
        # This deliberately uses a bounding box followed by the exact norm test.
        xmax = isqrt(bound)+ymax+1
        return sorted(((x,y) for x in range(-xmax,xmax+1)
                       for y in range(-ymax,ymax+1) if norm((x,y)) <= bound),
                      key=lambda z: (norm(z), z))
    one = (1,0)
    small = disk(15)
    roots_by_square = {}
    for r in disk(70):
        roots_by_square.setdefault(mul(r,r), []).append(r)
    local = [0,0,0,0]
    for b,c in combinations([z for z in small if 9 <= norm(z) <= 15],2):
        roots = roots_by_square.get(add(mul(b,c),one), [])
        if not roots:
            continue
        local[0] += 1
        for r in roots:
            fourth = add(add(b,c),(2*r[0],2*r[1]))
            if fourth in [(0,0),b,c] or norm(fourth) < norm(c):
                continue
            local[1] += 1
            for a in small:
                if a in [(0,0),b,c,fourth] or norm(a) > norm(b):
                    continue
                if any(add(mul(a,z),one) not in roots_by_square for z in (b,c)):
                    continue
                local[2] += 1
                local[3] += int(add(mul(a,fourth),one) in roots_by_square)
    records.append({'field_parameter': d, 'counts': local})
totals = [sum(r['counts'][i] for r in records) for i in range(4)]
assert totals == [90,118,16,0]
out['fresh_tail_enumeration'] = {'totals': totals, 'per_field': records}

# Point 5. Pell gives u/v > sqrt(d), hence u/v+sqrt(d)>2sqrt(d).
# d >= 7 implies 2sqrt(d)>4, checked by squaring positive sides.
assert 4*7 > 4**2
out['Legendre'] = {'d_lower_bound': 7, 'squared_comparison': '28 > 16'}

# Point 6: the zero-root case x=1 gives d=2, u=0, v=+-1.
assert (1-1, 3*1-1) == (2*0**2, 2*1**2)
out['negative_entry_minus_one'] = {'x': 1, 'd': 2, 'u': 0, 'v': [-1,1]}

# Point 7: both t and T currently valid because the branch is explicitly positive.
assert 'additional pair $(1,3)$ consists of positive rational integers.' in text
assert 'and $n_\\infty=14$. Thus $t<32$' in text
out['t_versus_T'] = 'Both agree on this positive-rational branch; T is optional consistency.'

# Point 20(b): exhaustive integer bounds are |u|<=5 and |v|<=4.
solutions = [(u,v,u*u+2*v*v) for u in range(-5,6) for v in range(-4,5)
             if u*u+2*v*v in (30,31,32)]
assert solutions == [(0,-4,32),(0,4,32)]
square_residues = {u*u % 16 for u in range(16)}
form_residues = {(a+2*b) % 16 for a in square_residues for b in square_residues}
assert 30 % 16 not in form_residues and 31 % 16 not in form_residues
assert all(u % 4 == v % 4 == 0 for u in range(16) for v in range(16)
           if (u*u+2*v*v) % 16 == 0)
out['last_two_triples'] = {'solutions': solutions,
                         'existing_mod16_proof_correct': True}

# New graph observation: x=u^2-1, dv^2=u^2-2 gives
# 1-x^2 = -u^2(u^2-2) = -d*u^2*v^2 = (uv sqrt(-d))^2.
# We check the polynomial identity by its integer coefficients, with X=u^2.
# 1-(X-1)^2 + X(X-2) is the zero polynomial.
assert [1-1, 2-2, -1+1] == [0,0,0]
pell_path = ROOT/'revision_v2/checks/small_v2_pell.json'
pell = json.loads(pell_path.read_text())
assert pell['totals'] == [1016,409,19612,9806,0]
assert all(row[1] == 2*row[2] and row[3] == 0 for row in pell['rows'])
# The complete unit-pair proof is unchanged from the checked final v2.
def unit_pair_body(s):
    return s.split('\\begin{lemma}\\label{sm:bs7-unit-pair}',1)[1].split(
        '\\begin{lemma}\\label{sm:bs7-eisenstein}',1)[0]
assert unit_pair_body(text) == unit_pair_body((ROOT/'output/D1_bound5-v2.tex').read_text())
out['Pell_graph_observation'] = {
    'algebraic_identity_checked': True,
    'all_1016_existing_rows_have_E_equals_V_over_2': True,
    'record_sha256': hashlib.sha256(pell_path.read_bytes()).hexdigest(),
    'record_source_sha256': pell['hash'],
    'unit_pair_proof_identical_to_final_v2': True,
    'large_graphs_rerun_this_review': False,
    'scope': 'Matching conclusion is for the computed bounded graphs only.'}

aux = (ROOT/'revision_v3/build/D1_bound5-v3.aux').read_text()
labels = ['lem:tail-irregular','sm:bs7-cutoff','sm:bs7-descent',
          'sm:bs7-unit-pair','lem:pr-one-three']
out['actual_numbers'] = {label: re.search(
    r'\\newlabel\{'+re.escape(label)+r'\}\{\{([^}]+)',aux).group(1)
    for label in labels}

dest = ROOT/'review_v3_comments/checks/small_results.json'
dest.write_text(json.dumps(out, indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k != 'fresh_tail_enumeration'},indent=2))
print('Fresh tail enumeration:', totals)
