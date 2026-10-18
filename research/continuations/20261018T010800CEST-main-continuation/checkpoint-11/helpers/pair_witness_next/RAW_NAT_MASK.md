# Exact natural-number mask arithmetic

`PairResidueMaskNat.lean` is a separate optional helper; the accepted
`PairCachedResidues.lean` is unchanged. Its endpoint is exact Boolean equality,
not only a one-sided non-square implication.

For `p = k+1`, it sets `nn = (-nu : ZMod p).val` and
`tt = (tau : ZMod p).val`. The ordinary natural polynomials are reduced modulo
`p` only at the two coordinate endpoints. Casting each polynomial to `ZMod p`
and using the cast homomorphism laws proves it equals the corresponding old
`ZMod` expression; `ZMod.val_natCast` then identifies the endpoint modulus.
`ZMod.natCast_zmod_val` recovers the original integer coefficients.

The proof applies to arbitrary natural inputs, without canonical-residue bounds.
Modulus one is included, because `k+1` is always nonzero. No mask validity,
signature validity, or discriminant assumption is introduced.

The source replaces seven `ZMod` multiplications and four `ZMod` additions in
the coordinate polynomials with seven natural multiplications and four natural
additions, followed by two coordinate moduli. The two fixed integer coefficients
still require their exact residue representations; `testBit` is unchanged.
This is a source-operation comparison, not a kernel timing measurement.

Pinned mathlib APIs inspected read-only in `Mathlib/Data/ZMod/Basic.lean`:
`val_natCast (n a : Nat)` at line 89 and `natCast_zmod_val` with `[NeZero n]`
at line 205. Compilation remains the root agent's responsibility.
