# Product-five growth theorem for an actual ordered tuple — 17 October 2026

## Mathematical statement

The theorem `IsD1Tuple.productFive_growth` applies to every imaginary quadratic
number field and its FULL ring of integers. Given an injective, nonzero
D(1)-tuple `a : Fin 5 → 𝓞 K` ordered by complex modulus, with the second
modulus at least 3, it proves

```text
3 * (∏ i : Fin 4, ‖phi (a (Fin.castAdd 1 i) : K)‖)
  < ‖phi (a 4 : K)‖.
```

The lower bound 1 on the first modulus is obtained from integrality and
nonvanishing within the proof. The result does not assume that any off-diagonal
square root is nonzero or that distinct entries have distinct moduli.

## Proof dependencies and closure

1. The tuple produces one compatible symmetric original-ring signed root
   matrix. One and the same matrix realizes the prefix determinant bound
   `|det F| < 33/128` and all last-column estimates.
2. The actual last-four tuple satisfies `D > 2 B C S` by the previously proved
   large-entry product-four theorem. The new prefix L2 lemma gives
   `‖w‖₂ < |d|/9` and the previously proved scalar estimate gives `|d| ≥ 54`.
3. Prefix operator control gives `‖F-H‖₂ ≤ 11/96 < 1/8`, hence
   `det F ≠ 0`. The inverse last-column vector norm is `< 11/12`.
4. The complex bilinear estimates yield `|h/d| < 11/108`,
   `|p| < 1`, `|q/d²| < 8/243`, and `|p/d²| < 1/2916`.
   Matrix symmetry and bilinear (not Hermitian) Cauchy–Schwarz justify the
   cross term without any conjugate-transpose assumption.
5. The existing rank-two determinant identity and exact rational margin give
   `|det G| < 1/3`. The newly integrated actual-tuple Schur lemma provides
   `‖G-H‖₂ < 1/2` for the SAME matrix.
6. The previously verified full-ring arithmetic endpoint proves the strict
   product-five inequality, deriving all determinant nonvanishing internally.

Three source modules contain seven theorems:
`ProductFivePrefixSizeCross`, `ProductFiveTupleSchur` and
`ProductFiveTupleGrowth`.

The original manuscript and external handoff remain frozen. The main
bound-five theorem, arbitrary-order Bennett determinant, full interpolation,
certified finite exhaustion/descent, and final sextuple exclusions remain
UNPROVED.

## Verification scope

Isolated `lake env lean D1Bound5/ProductFiveTupleGrowth.lean` trial01 EXIT 1
because the selected existing determinant lemma required a smaller radius.
Trial02 replaced that use with the exact already-proved half-radius criterion
and EXIT 0. The two dependency modules' targeted pinned Lake build EXIT 0
(3023 jobs). Integrated build, axiom audit, kernel replay, source/import audit,
and source fingerprints are recorded independently after execution; no outcome
is claimed in advance here.
