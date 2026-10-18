"""Write the row CSV and exact norm-floor witnesses for six nonreal cases."""
import csv
import json
import math
import re
from classify_pair_survivors import ROOT, OUT, inputs, sha

report = json.loads((OUT / "PAIR_SURVIVOR_CLASSIFICATION.json").read_text())
nonreal = []
for row in report["rows"]:
    if not row["counts"].get("nonreal_remaining_no_root_recomputation", 0):
        continue
    k, tau, nu = row["row"], row["tau"], row["nu"]
    name = f"finite_next/two_small/D1Bound5/SmallPairGraphData{k}.lean"
    assert sha((ROOT / name).read_bytes()) == inputs[k]["files"][name]
    source = (ROOT / name).read_text()
    body = re.search(rf"def smallPairLarge_{k} .*? := \[(.*?)\n\]", source, re.S).group(1)
    vs = [tuple(map(int, z)) for z in re.findall(r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩", body)]
    for i, j in row["after_guard_pairs"]:
        a, b = vs[i]
        c, d = vs[j]
        re_z, im_z = a*c-nu*b*d+1, a*d+b*c+tau*b*d
        if not im_z:
            continue
        norm = re_z*re_z + tau*re_z*im_z + nu*im_z*im_z
        f = math.isqrt(norm)
        assert f*f < norm < (f+1)*(f+1)
        nonreal.append(dict(row=k, tau=tau, nu=nu, indices=[i,j], x=list(vs[i]), y=list(vs[j]),
            radicand=[re_z,im_z], norm=norm, norm_floor=f, norm_is_square=False,
            strict_norm_floor_obstruction=True))
assert len(nonreal) == 6
(OUT / "PAIR_SURVIVOR_NONREAL.json").write_text(json.dumps(dict(
    scope="Exact Python integer norm diagnostic only, not a Lean certificate", cases=nonreal), indent=2)+"\n")

fields = ["row","tau","nu","large_vertices","same_color_unordered_pairs","sieve_survivors",
    "real_positive","real_negative","real_zero","nonreal_re_positive","nonreal_re_negative",
    "nonreal_re_zero","negative_integer_divisibility_reject","after_negative_integer_guard",
    "positive_integer_strict_floor_obstruction","negative_integer_scaled_strict_floor_obstruction",
    "nonreal_remaining_no_root_recomputation"]
with (OUT / "PAIR_SURVIVOR_CLASSIFICATION.csv").open("w") as f:
    w = csv.DictWriter(f, fieldnames=fields)
    w.writeheader()
    for row in report["rows"]:
        w.writerow({k:row.get(k,row["counts"].get(k,0)) for k in fields})
print("CSV48rows; all6 nonreal norms have exact strict floor witnesses.")
