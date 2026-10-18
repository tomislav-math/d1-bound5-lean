# Coherent forms: arithmetic bridge and two-anchor nonvanishing

All files in this directory are local drafts for the root agent's serial Lean compilation. This agent did not mutate the remote checkout, run a remote compiler, or touch Git.

## Dependency order

1. `CoherentIntegralForms.lean`
2. `CoherentPolynomialWeights.lean` (independent of 1)
3. `CoherentQuotientForms.lean` (imports 1 and 2)
4. `CoherentTwoVanishing.lean` (imports 1)
5. `CoherentTwoSize.lean` (imports 3 and 4)

They use the already accepted `D1Bound5.CoherentAnalyticInterpolation` and existing full-ring norm theorem.

## New mathematical scope

The analytic terminal and anchor roots are proved to lift into the source ring from actual `IsD1` square witnesses. The auxiliary square root `eta` is not assumed integral. Vanishing tuple square roots are allowed. All coherent forms with integral polynomial weights therefore lift to the ring. In a full imaginary quadratic integer ring, their nonzero complex images have modulus at least one.

For 2, 3, and 4 anchors, explicit polynomial weights are proved equal to exactly the manuscript's Vandermonde quotient weights, including orientation signs. Consequently the three specialized quotient-form norm bounds no longer assume coefficient integrality or root integrality. They do still explicitly require the form to be nonzero, as they must without further size assumptions.

The two-anchor vanishing lemma then proves the exact regular-quadruple equation by cancellation only of `a-b`. No square root is cancelled. The size file derives the usual two extensions of the triple and bounds their moduli. If `A >= 1`, `B >= 3`, and `P >= 5B`, then `AB >= 3`, `AP >= 15`, `BP >= 45`, and

`norm(r*s*t)^2 <= (2944/2025) * (A*B*P)^2 < (5/4 * A*B*P)^2`.

Also `A+B+P <= (19/45) * A*B*P`. Thus a regular quadruple has

`Q < (19/45 + 2 + 5/2) * A*B*P = (443/90) * A*B*P < 5*A*B*P`.

The endpoint `full_ring_coherent_two_nonzero_and_one_le_norm` therefore derives both `L2 != 0` and `1 <= norm L2` from actual tuple entries, distinctness, `B >= 3`, `P >= 5B`, and `Q >= 5ABP`. It derives `A >= 1` from the full integer ring. This endpoint has no conditional nonvanishing premise.

## Not claimed

This unit does not yet combine the analytic upper bound with the two-anchor nonvanishing to prove the strong gap `Q > A^2 P^3 / h0`. It does not prove simultaneous three-anchor nonvanishing, the later interpolation height estimates, the Bennett approximation theorem, or the final main statement.

The source auditor independently approved the mathematical structure of the first four files before the size file was submitted for its separate review. Compiler acceptance remains the root agent's responsibility and must be recorded from actual results.
