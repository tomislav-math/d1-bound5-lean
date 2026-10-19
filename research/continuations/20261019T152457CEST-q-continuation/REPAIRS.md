# Exact proof repairs

2026-10-19T15:33:21.048215+02:00

FiniteQMatrix: the first pinned attempt failed only at the default tactic recursion-depth limit during expansion of the explicit five-by-five determinant. Scope maxRecDepth=8192 to that theorem alone. The 240-second process cap, original statement and heartbeat limit are unchanged. This adjusts elaboration capacity, not kernel trust or mathematical hypotheses. The failed exact source and log remain in wave01.

## Sparse determinant factorization

2026-10-19T15:38:27.334022+02:00

The local recursion-only trial reached the unchanged 240-second cap. Do not repeat that fingerprint. First prove the generic sparse 5x5 determinant with fifteen independent entries, then substitute the actual row polynomials and use ring. The exact generic identity was also sanity-checked symbolically outside Lean, which is evidence only. Both parts must pass pinned Lean before acceptance. Original public headers and all mathematical hypotheses remain unchanged.

## Explicit finite-index reduction

2026-10-19T15:41:50.285849+02:00

The sparse determinant trial reduced to its correct polynomial identity with unreduced Fin.succAbove numeral applications. Unfold the actual pinned definition of succAbove and Fin.lt_def in the sparse expansion. No mathematical formula changes. Failed wave03 is retained.

## Separate combinatorial expansion and index evaluation

2026-10-19T15:44:11.711092+02:00

Unfolding succAbove throughout recursive determinant expansion hit the recursion limit. Restore the successful generic determinant expansion from wave03 and normalize the remaining literal indices only afterwards using norm_num [Fin.succAbove], before ring. This keeps separate finite combinatorial and polynomial phases. All earlier attempts remain recorded.

## Kernel-proved literal index equalities

2026-10-19T15:46:43.058887+02:00

The separate norm_num pass still left literal Fin comparisons opaque. Provide forty local Fin.succAbove numeral equalities, each proved by ordinary decide, covering all positions in dimensions one through four. Rewrite these exact equalities while expanding the generic sparse determinant. No trusted evaluation or new global assumptions are introduced. These local index lemmas are not counted as paper results.

## Half-coefficient token separation

2026-10-19T15:51:31.004116+02:00

FiniteQResidualIdentity: the parser tokenized the adjacent absolute-value close and multiplication as |*. Insert a space in the proof body, leaving every public statement unchanged. This source is outside the currently protected integral-row import closure. The failed parser attempt is preserved in wave06.

## Ring-hom numeral images

2026-10-19T15:53:20.144134+02:00

FiniteQIntegralRows: simp leaves f(3), f(4), f(5), f(8). The pinned map_ofNat theorem is deliberately not a simp lemma. Add it explicitly to the three polynomial transport proofs. The rest of the integral-row proof already elaborated; all public statements are preserved.
