# Finite-Q residual proof repair

2026-10-19T16:06:10.703473+02:00

The failed hw1 polynomial normalization used broad norm_num, which rewrote equality of products into a disjunction before ring. Restrict simplification to norm_mul, norm_pow and Complex.norm_ofNat, then invoke ring on the unchanged polynomial identity. No theorem type, constant or premise changes. The original source and predecessor failure log remain preserved.

## Explicit positive coefficient increment

2026-10-19T16:12:11.602962+02:00

FiniteQFullRing failed only in the final nlinarith step combining the lower bound for the integral row with the coefficient 54 estimate. Replace it by hL.trans_lt hbound, add the already proved positive monomial T^3 C^2/Z, and use ring to identify 54+1=55. Every root choice and all original hypotheses and constants are unchanged. The failed wave01 source and log remain preserved.
