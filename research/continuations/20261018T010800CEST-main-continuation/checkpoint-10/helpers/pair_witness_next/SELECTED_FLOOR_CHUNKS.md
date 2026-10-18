# Selected-mask/floor row blocks

`PairSelectedFloorChunks.lean` is a separate uncompiled adaptation of
`PairCachedFloorChunks.lean`. It imports the existing
`PairSelectedFloorWitnesses` and changes no previous source or concrete data.

The row payload is now `(code, ks) : ℕ × List ℕ`. A checked prefix consumes at
most `n` complete rows, invoking the unchanged `pairSelectedFloorRowBool` on
the head's **entire remaining vertex tail**, its complete packed mask word,
and its complete floor list. A row is never split inside its word. Thus every
cross-block pair, leading-zero mask tag, repeated-vertex test, integer guard,
floor inequality and end-of-row leftover check remains exactly as before.

The exact factorization holds for all list lengths and all cuts:

```lean
pairSelectedFloorIndependentBool sieve cached rows =
  (pairSelectedFloorPrefixBool sieve n cached rows &&
    pairSelectedFloorIndependentBool sieve (cached.drop n) (rows.drop n))
```

The proof is the same induction on `n` as in the previous floor chunk module,
with the one extra product destructuring `rcases item with ⟨code, ks⟩`.
Empty/empty succeeds; unequal lengths reject when encountered. A zero-width
prefix leaves the full original checker in the remainder, so it cannot hide a
malformed row. A final covering prefix has checked both lengths before the
remaining lists become empty.

For memory-bounded certificates, use the deterministic drop chain described
in `FLOOR_CHUNKS.md`: fixed positive block width, one independent
`decide +kernel` prefix theorem per block, a certified final remainder, then
backwards composition by `pairSelectedFloorIndependentBool_of_prefix_drop`.
The outer vertex-projection and complete signature validation remain unchanged.
The final provided adapter reaches exactly the original `pairIndependentBool`.

No data generator, concrete prefix certificate, compiler invocation or memory
benchmark is included. The predecessor source and the selected-mask traversal
remain frozen; this is a fallback proof-computation layout only. The only list
API beyond the predecessor's induction is the same pinned
`List.drop_eq_nil_of_le` already verified in Lean4.33.1 Basic:945.
