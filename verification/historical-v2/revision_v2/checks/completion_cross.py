"""Cross-compare the two independently generated v2 cutoff certificates."""
from pathlib import Path
from hashlib import sha256
from fractions import Fraction as F
import json
ROOT=Path(__file__).resolve().parents[2]
DIR=ROOT/'revision_v2/checks'
source_hash=sha256((ROOT/'output/D1_bound5-v2.tex').read_bytes()).hexdigest()
a=json.loads((DIR/'completion_exact.json').read_text())
b=json.loads((DIR/'one_small_v2_results.json').read_text())
assert a['sha256']==b['source_sha256']==source_hash
other={(row['pair'],tuple(row['s'])):row for row in b['fixed56']}
other[(40,(8,0))]=b['rational']
checks=0
for row in a['cutoffs']:
    r=other[(row['pair'],tuple(row['s']))]
    for name in ('Mbs','N0','eta','thresholds','K','q1'):
        assert row[name]==r[name],(row['pair'],row['s'],name)
        checks+=1
    assert row['n_infinity']==r['ntail'];checks+=1
    assert F(row['minimum_overlap_at_N0'])==min(map(F,r['quotients']));checks+=1
assert len(other)==57
result={'source_sha256':source_hash,'cutoffs_cross_compared':57,'scalar_or_list_comparisons':checks,'files':['completion_exact.json','one_small_v2_results.json'],'independence':'The two implementations separately generate/evaluate the finite N3 rows and compute all threshold integers. The completion implementation takes the five fixed-pair M coefficients from the manuscript; the one-small implementation independently regenerated those 200 coefficient cells.'}
(DIR/'completion_cross.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
