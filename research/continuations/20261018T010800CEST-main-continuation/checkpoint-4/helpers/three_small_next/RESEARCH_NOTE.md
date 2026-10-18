# Three-small actual exclusion draft

Endpoint: `IsD1Tuple.not_three_small` in `ThreeSmallExclusion.lean`.

Inputs are an actual ordered full-ring D(1) sextuple and third modulus below3. Conclusion is False. The theorem joins the already drafted finite closed-disk classification `three_small_fifth_large` with actual analytic bounds. No bounded-extension or approximation certificate is an input.

Dependency order:

1. ThreeAnchorDetailedAlternative
2. ThreeSmallPairAlternative
3. ThreeSmallLargeExtensions
4. ThreeSmallFixedScalar
5. ThreeSmallFixedExtension
6. ThreeSmallExclusion

The pair alternative uses the sufficient quintic constant1/400, weaker than the paper's1/100. Three extensions above10^40 are excluded by the three actual pair alternatives and the ordinary upper bound. In the remaining fourth-entry<85 case, the actual V window starts a lower bound beyond10^38 C^3. The actual Q window and M window then overlap up to C^11/10^22, above the ordinary upper bound10^60 C^7.

Q uses the already drafted actual coefficient55 bound, which is stronger than the manuscript's coarse fixed-anchor constants. All windows include their endpoints.

These are local drafts. Parent is sole remote writer/compiler/Git operator. No theorem is claimed kernel-verified before successful build reports.
