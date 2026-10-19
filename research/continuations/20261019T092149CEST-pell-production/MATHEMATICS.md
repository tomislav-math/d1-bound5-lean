# Bounded Pell production batch

## Mathematical scope

This unit follows the frozen-v4 proof for the pair {-1,1}. It verifies existing finite certificates, without replacing the manuscript recurrence, its norm-two Pell equation, its cutoff, or either sign case. It introduces no new mathematical assumption.

For the four matching parameters 119,127,151,167, the supplied lists have respectively 116,39,29,109 positive magnitudes. For all distinct magnitudes x,y on each list, the certificate excludes x*y+1 as an ordinary integer square and x*y-1 as d times an integer square, by sound modular obstructions. The triangular witness rows cover respectively 6670,741,406,5886 pairs, in total 13703. Same-magnitude opposite-sign vertices are not discarded. The valid-mask theorems prove that all ordinary and d-scaled squares have their modular bits set, so a false bit is a genuine obstruction.

The next 16 prefix blocks, PellLightPrefixData16 through PellLightPrefixData31, contain 256 original finite-check statements for the specified parameters from 2343 through 4871 (not every integer in that interval). Each statement checks the exact continued-fraction recurrence, a stopping numerator exceeding X=10^275, and equality of the explicit magnitude list with the filtered trace of positive solutions to u^2-d*v^2=2 with u<=X. Both empty and nonempty lists are retained. The existing PellLightCFBridge and finite-certificate completeness machinery provide the intended link to the radius X^2=10^550. Those bridges are not replaced by external computation.

## Formal scope and limitations

All 268 original theorems have the same source bytes and statements as the prepared modules. Each uses proof-producing decide +kernel. The accompanying 268 definitions are explicit lists, masks and witnesses, not auxiliary mathematical premises. Source-template and Python structural checks are corroboration, not proofs. Acceptance of this unit requires actual pinned compilation, exact elaborated types, transitive axiom checks and targeted installed same-kernel replay. This is not independent review.

This batch alone does not construct the aggregate certificate for all 1016 parameters, complete the full-ring no-three endpoint, finish the global sextuple exclusions, integrate the accepted root, or prove MainStatement. No clean-checkout or whole-root fresh kernel gate is claimed.
