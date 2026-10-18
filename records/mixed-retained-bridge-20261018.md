# Mixed retained interpolation bridge

This unit checks three prepared source modules in dependency order. Individual proof status is established only by their build and audit receipts, not by this mathematical description. The unrestricted bound-five theorem remains UNPROVED.

Let a0,...,a4 be distinct elements of an actual D(1)-set in the full ring of integers of an imaginary quadratic field. Write A,B,S,T,C for their complex absolute values. The bridge assumes 1 <= A <= B <= S, B >= 3, T > 2*A*B*S, C > 3*A*B*S*T and A*T >= H. The allowed rows are (H,lambda,U)=(32,1/10,179/10) and (48,19/200,15). These size/frontier hypotheses remain explicit inputs, not claims about arbitrary five-element sets.

## Why two successive two-anchor estimates are required

The scalar size lemma supplies T >= 5*S, C >= 5*A*B*T, A*T >= 32, C >= 4*T and T*C > 10000. The first actual two-anchor estimate yields A^2*T^3 < (10001/10000)*C. That supplies the stronger input C >= 5*B*S*T for the second actual two-anchor estimate. The latter yields B^2*T^3 < (10001/10000)*C, and hence C > (179/10)*A*B*S*T^2.

## Nonzero integral form

The previously proved zero-window theorem says that vanishing of the actual coherent three-anchor form would imply C < U*A*B*S*T^2. Since U <= 179/10, this contradicts the preceding strict lower bound. The full-ring integrality theorem then yields norm(L) >= 1. Nonvanishing and this lower bound are derived, not extra assumptions of the full-ring bridge. The analytic upper bound is

    norm(L) < 51*norm(Delta)/(100*Z)
              + lambda*norm(Delta)*Z/(A*B*S*T^3).

Here Delta is the actual Vandermonde product of the first three embedded entries and Z is the actual coherent terminal square-root norm.

## Quantitative gap target

Set R=norm(Delta)/(B*S^2). Injectivity and the ordering give 0<R<=8. The previously checked mixed scalar implication yields

    C > (9999/10000)/lambda^2
        * (1/R - (51051/400000)/(A^2*B^2))^2
        * (A^2*T^5/S^2).

The coefficient in front of A^2*T^5/S^2 is strictly greater than one in both allowed rows. Consequently C > A^2*T^5/S^2. The proof explicitly constructs the auxiliary complex square root and supplies its norm estimates. No exclusion of zero pair-square roots, half-integral full-ring coordinates, or equal absolute values is added.

This is a conditional growth theorem for an actual tuple under the displayed frontier/size conditions. Applying it to every final case, exhaustive finite certificates and descent, accepted-root integration and all final verification gates remain separate tasks. Targeted replay is the installed Lean kernel, not an independent review.

## Verification status

# FINISH — 2026-10-18T21:08:36.965040+02:00

Outcome: COMPLETED_UNIT. Five prepared theorems and one parameter-row definition across CoherentRetainedMixedSizes, CoherentRetainedMixedForms and CoherentRetainedMixedGap are now separately verified. The mixed-gap proof needed an explicit expected local scalar type before final transitivity/simplification; no original statement or hypothesis changed.

For actual full-ring D(1)-tuple entries with 1<=A<=B<=S, B>=3, T>2ABS, C>3ABST, and AT>=H for one of the two manuscript rows H=32/48, the result derives the nonzero integral coherent form and the precise coefficient bound, hence C>A^2*T^5/S^2. The form lower bound and choice of auxiliary root are supplied internally, not assumed.

All three pinned builds, all six exact declaration types and transitive axioms (only propext, Classical.choice, Quot.sound), and three targeted installed SAME-kernel replays passed. The source scan covers 42 project modules in the exact imported closure. No fresh whole-root replay, clean-checkout build, independent final review or accepted-root integration is claimed. MainStatement remains UNPROVED.

Sources, failed attempts and evidence are preserved in research/continuations/20261018T205247CEST-mixed-bridge/. Private publication requires the subsequent separate Git calls and post-push comparison; this FINISH does not invent a commit/push receipt. The pre-existing Git index entry must remain unchanged. The initial denied administration calls are recorded in the conversation attachment, not claimed as executed Mac inspections. No automation was changed.

Next priority: inspect OrdinaryHeightEnvelope and its current unmet prerequisites in NEXT_DEPENDENCIES.json. No new proof for that target was launched.
