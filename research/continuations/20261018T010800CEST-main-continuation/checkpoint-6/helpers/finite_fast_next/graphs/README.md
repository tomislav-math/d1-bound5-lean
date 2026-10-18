# Isolated two-color graph pilot

This is a local alternative for the triangle certificate only. Original seed,
closure, filtering, norm cutoff, and full-ring transfer files are unchanged.
All 48 diagnostic exact graphs admit two colors. This diagnostic observation is
not a proof input: for each actual data list the kernel must accept independent
checks of both color classes. Any arbitrary natural-number bit mask covers every
original list occurrence, by `pairSplitByMask_covers`.

`PairBipartiteCheck.lean` proves that the two checked independent classes imply
exactly the existing `pairGraphTriangleFreeBool = true`. The triangular checker
examines each unordered pair once, skips only equality of the two actual values,
and permits all square roots including zero. Duplicate vertices and overlapping
classes are harmless. The graph's cross-color pairs need not be evaluated.

Pilot41 copies the original372-entry large list exactly, with one372-bit color
mask. The two186-entry classes require17,205 unordered checks each. Diagnostic
modular filtering leaves1,694 total exact-root rejections. The old lazy triangle
algorithm invokes the fast square test413,292 times on this graph.

Suggested serial compile order:
1. PairBipartiteCheck
2. SmallPairBipartitePilotData41
3. SmallPairBipartitePilotLeft41
4. SmallPairBipartitePilotRight41
5. SmallPairBipartitePilot41

`generate_bipartite_pilot.py` reproduces only these isolated pilot artifacts,
verifies exact agreement of the source literal with the existing closure JSON,
and writes SHA256 fingerprints. It does not overwrite any existing graph or
disk module. Both color-check theorems use `decide +kernel`; neither native
execution nor an assumed graph property is accepted.

Source_audit independently reviewed the full generic source: mathematical PASS.
All new Lean files remain subject to the coordinator's compiler gate.
