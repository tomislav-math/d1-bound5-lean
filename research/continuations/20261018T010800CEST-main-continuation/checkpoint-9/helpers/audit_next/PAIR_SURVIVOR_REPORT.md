# All48 modular survivor diagnostic

This is exact local Python evidence, not a Lean/kernel certificate. No Lean source, remote file or accepted audit was changed. The existing cp7 source_audit.md remains frozen.

All8,063,266 same-color unordered pairs were independently re-enumerated from pinned current Lean masks and frozen vertex data using cached small-residue bitsets. Every resulting pair set equals the frozen recorded set, row by row: exactly68,640 survivors. The classification then rechecks each survivor against every current mask and evaluates its exact integer radicand coordinates. No quadratic-field square-root routine was called.

| Disposition | Count |
|---|---:|
| Negative rational, rejected by the proposed divisibility guard |40,026|
| Positive rational, strictly between successive integer squares |12,443|
| Negative rational, divisible by guard modulus, scaled magnitude strictly between squares |16,165|
| Nonreal, integer norm strictly between successive squares |6|
| Total |68,640|

Thus the cheap guard leaves28,614 checks. All remaining28,608 real cases admit ordinary integer floor witnesses; all6 nonreal cases admit integer norm-floor witnesses. There are no zero radicands or actual square exceptions among the same-color survivors. These are diagnostic conclusions; any new formal rejection mechanism still requires its own soundness proof and kernel certificates.

The guard modulus is nu for tau=0, and4nu−1 for tau=1. It rejects only im=0,re<0 with modulus not dividing re. Negative divisible cases use the nonnegative integer quotient−re/modulus for the floor test. Positive cases use re. The6 norm tests use re²+tau*re*im+nu*im². Exact isqrt was called28,608times for real residuals and6times for nonreal norms; no complete field-root recomputation was performed.

## Counts by model

| tau | nu | Survivors | Guard rejects | Positive floor | Negative scaled floor | Nonreal norm floor | After guard |
|---:|---:|---:|---:|---:|---:|---:|---:|
|0|1|15515|0|926|14587|2|15515|
|0|2|9985|7524|2461|0|0|2461|
|0|5|1186|1186|0|0|0|0|
|0|6|1555|1555|0|0|0|0|
|1|1|17613|14008|2290|1314|1|3605|
|1|2|12980|11091|1886|0|3|1889|
|1|3|1414|660|706|48|0|754|
|1|4|0|0|0|0|0|0|
|1|5|0|0|0|0|0|0|
|1|6|5128|2363|2549|216|0|2765|
|1|8|3264|1639|1625|0|0|1625|

## Remaining work by row

Only17rows retain any work after the guard; all other31rows clear completely. The CSV contains all48rows and real/nonreal signs.

| Row | Model(tau,nu) | Before guard | After guard | Positive floor | Negative scaled floor | Nonreal |
|---:|---|---:|---:|---:|---:|---:|
|1|(0,1)|2779|2779|925|1854|0|
|6|(0,1)|6592|6592|0|6592|0|
|8|(0,1)|3|3|1|0|2|
|9|(0,1)|1340|1340|0|1340|0|
|11|(0,1)|2789|2789|0|2789|0|
|12|(0,1)|2012|2012|0|2012|0|
|15|(0,2)|3535|1063|1063|0|0|
|17|(0,2)|2689|1398|1398|0|0|
|23|(1,1)|4760|2086|772|1314|0|
|24|(1,1)|1|1|0|0|1|
|30|(1,1)|3060|1518|1518|0|0|
|33|(1,2)|2965|1135|1135|0|0|
|34|(1,2)|3|3|0|0|3|
|40|(1,2)|1524|751|751|0|0|
|43|(1,3)|1414|754|706|48|0|
|46|(1,6)|5128|2765|2549|216|0|
|48|(1,8)|3264|1625|1625|0|0|

Graph41 has1,694 survivors, all negative rational with re modulo7 equal1; its two color classes contribute884 and810. All are rejected by the cheap guard.

The6nonreal exceptions are zero-based vertex pairs in the original large lists: row8(794,1147),(795,1146); row24(244,480); row34(49,439),(178,408),(396,456). Their full exact radicands, norms and strict floor witnesses are in PAIR_SURVIVOR_NONREAL.json.

## Reproduction

Run from the workspace root:

```sh
python audit_next/classify_pair_survivors.py
python audit_next/verify_pair_survivor_completeness.py
python audit_next/summarize_pair_survivors.py
```

The first script checks all frozen source/graph input hashes and all current sieve pins. The second re-enumerates complete same-color candidate sets using current masks. The third writes the48row CSV and six exact norm-floor witnesses. Timings are diagnostic and may vary; observed classification about2seconds, full small-residue re-enumeration about3.44seconds.
