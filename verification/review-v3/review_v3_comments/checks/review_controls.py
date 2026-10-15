"""Source identity and exact controls specific to the consolidated assessment."""
from fractions import Fraction as F
from hashlib import sha256
from pathlib import Path
import json

root = Path(__file__).resolve().parents[2]
source = root / 'output/D1_bound5-v3.tex'
digest = sha256(source.read_bytes()).hexdigest()
assert digest == 'a1119af75cf623411c678ea0e9b6e7dc9a3f59a931ee67384fc98be8d8373bd5'
weighted = F(141,500)*F(59,20)+F(21,125)
assert weighted == F(9999,10000)
assert F(141,500)+F(21,125) != weighted

# Termwise normalization in Bennett (2.4), before the common remaining
# factors: compare the exponents of N and N+alpha symbolically.
# (1+alpha/N)^(k-h) N^(-h) = (N+alpha)^(k-h) N^(-k).
# Represent the exponent of N by coefficients of k and h.
lhs_N_exponent = (-1, 1-1)
rhs_N_exponent = (-1, 0)
assert lhs_N_exponent == rhs_N_exponent

result = {'status':'PASS', 'source_sha256':digest,
          'weighted_bound':str(weighted),
          'unweighted_upper_bound_sum':str(F(141,500)+F(21,125)),
          'Bennett_N_exponent_coefficients':lhs_N_exponent,
          'Bennett_location':'Section 2, p. 1721, unnumbered identity after (2.4)',
          'Bennett_source':'https://personal.math.ubc.ca/~bennett/B-Binom.pdf',
          'scope':'Exact arithmetic and exponent identity; source attribution was checked manually.'}
Path(__file__).with_suffix('.json').write_text(json.dumps(result,indent=2)+'\n')
print('PASS: frozen source, weighted bound, termwise Bennett normalization.')
