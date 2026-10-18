# Two-small actual cutoff draft

Parent agent is sole remote writer, Lean compiler and Git operator. These are local drafts and are not kernel-verified until the parent reports successful builds.

Endpoint: `IsD1Tuple.two_small_fifth_lt` in `TwoSmallFifthBound.lean`.

Inputs are only an actual ordered full-ring D(1) sextuple and the branch conditions second modulus below3 and third modulus at least3. Output is fifth modulus below10^550. No nondegeneracy condition on the initial pair is used, so the result also applies to the {-1,1} branch.

Dependency order:

1. TwoSmallHeightScalar, TwoSmallOrdinaryHeight
2. CoherentThreeSeparated, FullRingThreeSelection, FourAnchorVWindow
3. TwoSmallTupleInputs
4. TwoSmallLargeS, TwoSmallLargeSBound
5. ThreeGeneralWindow, ThreeAnchorAlternative (also CoherentThreeZeroBootstrap)
6. TwoSmallLargeTScalar, TwoSmallLargeTBound
7. FullRingDirectFour, TwoSmallLargeCScalar
8. TwoSmallMWindow (also complete FiniteMInterval chain)
9. TwoSmallFifthBound

The first case intentionally proves the sufficient internal bounds S<10^50 and D<10^396 instead of the paper's slightly stronger S<10^49,D<10^389. The second case retains T<10^72 and D<10^549 when T≥10^8. The remaining bounded S,T case proves C<10^100 by actual V/direct-four/M windows.

The separated-three constant3/4 is obtained from the existing exact parameter theorem at H=1000, lambda=3/32. It is not inferred from the weaker general-three bound.

Ordinary M additional files authored here are in `ordinary_m_next/`: FiniteMIntegralRows, FiniteMRowBound, FiniteMFullRing, FiniteMInterval. Allorder_det independently audited the row/residual/root/interval mapping mathematically and reported PASS. Kernel compilation remains separate.
