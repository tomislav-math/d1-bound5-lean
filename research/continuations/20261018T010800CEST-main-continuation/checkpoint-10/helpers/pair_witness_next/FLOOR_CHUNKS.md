# Sparse-floor row blocks

`PairCachedFloorChunks.lean` is a new, uncompiled module importing the accepted
`PairCachedFloorWitnesses`. It does not modify a previous checker, source list,
signature, sieve, floor witness, graph cutoff or theorem statement. The
coordinator remains the sole compiler and installer.

The new prefix checker runs at most `n` **head rows**. For each head it passes
the entire actual remaining vertex list to the accepted `pairCachedFloorRowBool`.
It never replaces that tail by `take n`. Therefore every unordered pair crossing
a block boundary is still checked in the block containing its earlier head.
The cached vertex list and the list of floor-witness rows advance in lockstep.

The central theorem is an exact Boolean equality, without discriminant,
signature-validity, equal-length or nonzero assumptions:

```lean
pairCachedFloorIndependentBool sieve cached rows =
  (pairCachedFloorPrefixBool sieve n cached rows &&
    pairCachedFloorIndependentBool sieve (cached.drop n) (rows.drop n))
```

Its proof is induction on `n`, splitting both lists and using Boolean
associativity in the sole nontrivial case. At `n = 0` the prefix is true and
the entire original checker remains. With positive `n`, empty/empty succeeds;
exactly one empty list rejects. Thus extra or missing witness rows are not
hidden by a cut. The accepted per-row checker still rejects extra/missing
individual floor witnesses, handles repeated vertices in the original way,
and retains its exact cached-mask and negative-integer guards.

For a reproducible production layout, choose a fixed width such as16 and use
the following deterministic sequence for one original color class:

1. Keep `cached₀` and `rows₀` equal to the original literal cached class and
   its original floor-witness rows. Define `cachedᵢ₊₁ := cachedᵢ.drop 16` and
   `rowsᵢ₊₁ := rowsᵢ.drop 16` in a shared data-only module.
2. In separate certificate modules prove each
   `pairCachedFloorPrefixBool sieve 16 cachedᵢ rowsᵢ = true` by `decide +kernel`.
   No block may use a truncated vertex tail or recomputed/reordered witness row.
3. Prove the final remainder's original checker is true, normally by `rfl`
   after both lists reduce to empty. Alternatively, the provided
   `pairCachedFloorIndependentBool_of_prefix_cover` discharges the final
   remainder from a checked covering prefix and both length bounds.
4. Apply `pairCachedFloorIndependentBool_of_prefix_drop` backwards over the
   blocks. Each use combines already-proved theorem constants; the aggregate
   must not be verified again by a fresh monolithic `decide`.
5. Reuse the unchanged original exact vertex-projection and complete signature
   validation proofs. The provided certificate/independence adapters return
   the original certificate and `pairIndependentBool`, respectively. Positive
   discriminant appears only in the final accepted sparse-checker soundness
   application, exactly as before.

The module supports every width, including zero and cuts past the end. A
deterministic generator should normally use positive widths and one final
remainder. Different block sizes affect only proof computation, not acceptance.
No concrete block certificate or performance result is claimed here. Splitting
limits the number of rows reduced in one `decide +kernel`; it does not eliminate
the full-tail work within a row or the memory needed to import original data.

The new terminal helper uses `List.drop_eq_nil_of_le`, read in the pinned
Lean4.33.1 `Init/Data/List/Basic.lean:945`. Boolean association and the exact
`Bool.and_eq_true_iff` interface follow the already reviewed chunk module.
