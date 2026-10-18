# Ordinary height envelope — mathematical scope

This unit verifies the prepared base-ten logarithm module and the passage from all positive integer approximation orders to an explicit height envelope. Define ell(x)=log(x)/log(10). For B>=1, C>1, D>0, Z>=1, R>0, assume CD<2Z^2 and, for every integer k>=1,

1 < 3 C (42 B^3 C)^k / (B Z) + Z/(2 R^k).

The real parameters h,r,u satisfy ell(42 B^3 C)<ell(C)+h, 2ell(C)+r<ell(R), ell(253 B^2)<u, h-r<ell(C), and 0<2ell(C)+r. Then the prepared height theorem claims

ell(D) < 7 ell(C) + (4u+8h-4r)
  + [2ur+(4u+8h-4r)(h-r)]/[ell(C)-(h-r)] + 2/5.

The proof selects a positive integer k using the previously verified floor/log lemma, rescales by log(10)^2, bounds the numerator via 2*(3C/B)*(42B^3C)=252B^2C^2<253B^2C^2, and applies the already verified scalar rational inequality. All inequalities and sign restrictions in the original statement are retained. The existence of the actual full-ring Bennett approximants supplying the universal k premise is a separate downstream obligation.

The logarithm module proves exact rational upper bounds ell(2)<2/5, ell(42)<163/100, ell(253)<241/100, and ell(2/5)>-2/5 through positive integer-power comparisons and the exact reciprocal product identity. These use Lean proof-producing arithmetic, not floating-point estimates or a native oracle.

Prepared-source review is not compilation. Actual build/axiom/replay results are recorded separately. No theorem in this unit by itself proves the final bound-five statement. No independent reviewer or full clean-checkout build is claimed.
