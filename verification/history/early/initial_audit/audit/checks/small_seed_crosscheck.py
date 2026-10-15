#!/usr/bin/env python3
"""Independent bounded-root enumeration crosscheck of all seed square tests.
Uses a precomputed set of literal root squares, not the norm criterion.
"""
from small_verify import Ring,sf,BASE
import json
out=[]
for d in range(1,36):
    if not sf(d):continue
    r=Ring(d)
    anchors=[z for z in r.disk(3) if 0<r.norm(z)<9]
    # |a*z+1| < 3*33+1=100 for |z|<=33. A root q has
    # |q|^2=|a*z+1|<100, so the radius-10 root disk is complete.
    literal_squares={r.mul(q,q) for q in r.disk(10)}
    tests=0
    for z in r.disk(33):
        for a in anchors:
            w=r.add(r.mul(a,z),(2,0))
            assert (w in literal_squares)==(r.root(w) is not None),(d,a,z,w)
            tests+=1
    out.append({'d':d,'anchors':len(anchors),'literal_root_squares':len(literal_squares),'tested_anchor_extension_pairs':tests})
(BASE/'small_seed_crosscheck_results.json').write_text(json.dumps(out,indent=2))
print('Literal-root seed comparisons passed:',sum(x['tested_anchor_extension_pairs'] for x in out))
