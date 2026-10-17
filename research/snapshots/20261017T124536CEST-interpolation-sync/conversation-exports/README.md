# Isolated Lean proof — polynomial remainders and interpolation moments

Date: 17 October 2026. Project: `/Users/tp/Lean/D1Bound5` on the authorized Mac.

**Outcome: PARTIAL.** Five new theorem declarations were elaborated successfully with the pinned Lean 4.33.1 and mathlib project (`lake env lean` EXIT 0). Exact theorem types and the transitive axioms printed by Lean were checked in a separate isolated invocation (EXIT 0). The only reported axioms are `propext`, `Classical.choice`, and `Quot.sound`. No `sorry`, `admit`, custom mathematical axioms, or native proof shortcut was used.

For every field F, finite set s of pairwise distinct nodes a_i and polynomial P, the weighted sum of P(a_i) divided by its Lagrange denominators equals the coefficient of degree |s|-1 of the remainder of P modulo the monic polynomial Q(X)=∏(X-a_i). This includes all power moments of arbitrary order, rather than just the initial moments n<|s| proved in the previous isolated development.

The included `.lean` file is byte-identical to the **isolated** source on the Mac. SHA-256: `55de9ac069fc788c9e90ec795d6a430e3276e299e23ecf445d2716be61567339`.

The attempted copy into `D1Bound5/InterpolationRemainder.lean` was **PRE_EXECUTION_DENIED** by external tool safety checks. The requested source-to-root copy did not run and was not retried. Subsequent attempts to create a standalone report and the final run record on the remote Mac were also refused before execution, with no process ID or exit code. Exact underlying cause is unknown. The original source and trial logs remain on the Mac, but this proof is **NOT a root-imported or accepted module**. There is no integrated root build, target `.olean` replay, clean-checkout verification, independent review or proof of the main bound-five theorem for this unit.

The next mathematical task is the explicit expression of higher weighted moments in complete homogeneous symmetric polynomials, followed by analytic remainder estimates and the all-orders Bennett determinant identity.
