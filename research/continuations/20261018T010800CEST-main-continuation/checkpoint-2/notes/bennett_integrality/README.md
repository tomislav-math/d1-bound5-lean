# Bennett coefficient denominator bounds

Status: uncompiled local proof draft. The coordinator is the sole remote writer and compiler.

`BennettBinomialIntegrality.lean` proves, with explicit integer witnesses, that

`4^h * Ring.choose (k + 1/2) h`

is an integer for every natural `k,h`. The theorem is first proved over the rationals and then transported to every characteristic-zero field. There is no `h <= k` restriction on the exact denominator theorem. A uniform-power corollary gives the usual `4^K` denominator whenever `h <= K`.

The proof is constructive at the level of its displayed integer numerators:

1. Derive `(n+2)*Catalan(n+1)=2*(2n+1)*Catalan(n)` from the actual mathlib central-binomial recurrence and its proved Catalan formula.
2. Combine this with the generalized choose recurrence to prove
   `4^(n+1)*choose(1/2,n+1)=(-1)^n*2*Catalan(n)`.
3. Apply the actual Chu–Vandermonde theorem. An antidiagonal term with `u+v=h` splits `4^h` exactly into `4^u*4^v`; both factors then have explicit integer witnesses.
4. Apply `Ring.map_choose` to the rational-to-field homomorphism.

Negative integer upper parameters require no new factorial argument: `Ring.map_choose (Int.castRingHom F)` transports the actual integer-valued binomial-ring coefficient from `ℤ`. Thus every reciprocal-pole binomial factor `choose(-k,h)` is integral in every degree, including `k=0`.

Useful interfaces:

- `bennett_shifted_half_choose_scaled_eq_int k h` gives equality to the cast of `bennettScaledHalfShiftInt k h`.
- `bennett_shifted_half_choose_scaled_is_integer k h` gives an existential integer witness at scale `4^h`.
- `bennett_shifted_half_choose_uniform_is_integer k h K hh` gives an integer witness at scale `4^K`, assuming `hh : h <= K`.
- `bennett_integer_choose_eq_int z h` gives the exact integer-cast coefficient for arbitrary `z : ℤ`.
- `bennett_negative_choose_is_integer k h` gives the existential negative-pole interface.

The source of `Mathlib.Combinatorics.Enumerative.Catalan.Basic` was inspected directly in the pinned mathlib tree. The proof uses its actual `succ_mul_catalan_eq_centralBinom` and `Nat.succ_mul_centralBinom_succ`, not an asserted Catalan formula. This module discharges only the generalized-binomial denominator factors; the full Bennett matrix-entry normalizing factor and polynomial denominator cancellation remain the separate integrality bridge.

An independent mathematical review by the all-order agent confirmed the recurrence constants, signs, Vandermonde scaling and cast transport. No compiler has been run by this worker.
