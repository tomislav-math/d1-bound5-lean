# Mixed retained scalar gaps

These are real-variable implications used by the full-ring proof. Their premises are explicit growth bounds, terminal-root inequalities and bounds on a nonzero linear form. Neither module asserts the final cardinality theorem or assumes its conclusion. Exact hypotheses are in the preserved Lean sources and elaborated-type audit.

## Four-anchor first term and seventh-power consequence

Let A >= 1, B >= 3, S,T,Z > 0, C > 16BST, D > A^2 C^5/S^2, and (3999/4000)CD < Z^2. Then

    13 B S^2 T^3/Z < 1/100.

Indeed, the growth and root bounds give (3999/4000) A^2 (16BST)^6 < Z^2 S^2. Since A^2 B^4 >= 81, the coefficient comparison yields (100 * 13 B S^2 T^3)^2 < Z^2. Positivity then gives the claimed first-term estimate.

Suppose also S,T <= C, C > 1000, Z^2 <= CD+1, and a real L satisfies

    1 <= L < 13 B S^2 T^3/Z + (49/50) S T^2 Z/(A C^4).

The second term exceeds 99/100. Set Y = A C^4/(ST^2). It follows that Z > (99/98)Y, while Y >= C > 1000. Thus the excess ((99/98)^2-1)Y^2 exceeds 1, so Y^2 < Z^2-1 <= CD. Dividing by positive C proves

    A^2 C^7/(S^2 T^4) < D.

`RetainedMixedFourScalar` contains both implications. Its reviewed source compiled without edits.

## Three-anchor mixed gap

The exact Lean theorem assumes A >= 1, B,S >= 3, S <= T, W > 0, 0 < Q <= 8, 0 < lam <= 1/10,

    2ABS < T,
    B^2 T^3 < (10001/10000)C,
    (3999/4000)TC < W^2 <= TC+1,
    1 <= L < 51(QBS^2)/(100W) + lam(QBS^2)W/(ABST^3).

It derives

    (9999/10000)/lam^2 * (1/Q - (51051/400000)/(A^2 B^2))^2
      * A^2 T^5/S^2 < C.

The previously proved first-term bound reduces the linear-form estimate to a lower bound W > alpha A T^3/S, where alpha = (1/Q - (51051/400000)/(A^2 B^2))/lam > 1. Since T > 18, the square of this lower bound exceeds 10000. The additive 1 in the upper root estimate is therefore absorbed by the factor 9999/10000. This proves the exact displayed retained gap, including the mixed regime where A may equal 1.

## Actual proof repair

The original three-anchor Lean source failed at three arithmetic goals. `field_simp` had cancelled a positive A from an intermediate inequality, whereas the following displayed intermediate still carried that A. The repaired intermediate matches the actual normalized expression. The final comparison involving Y is now derived by inequality transitivity and explicit reassociation, following the already verified scalar dependency, rather than requesting nonlinear arithmetic across divisions.

Only proof bodies changed. The original theorem header, all assumptions, conclusion, constants and resource limits were preserved. The failed source/log and the exact patch remain separate from the corrected source.

## Scope and next dependency

These two modules do not themselves prove that the required linear-form and frontier bounds hold for every candidate tuple. Their actual full-ring instantiations are downstream dependencies. `CoherentRetainedMixedGap` was read and offered to the existing guarded driver, but the driver reported it ineligible and did not start a compiler for it. The precise readiness reason is recorded separately when available. No missing dependency, unknown assumption, finite certificate, descent step, root integration or MainStatement proof is inferred from this scalar unit.
