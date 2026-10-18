# Ordinary height scalar unit — exact statements and review

This unit verifies the existing wave119 source without editing or weakening its three theorem statements. It is progress from reviewed source to actual Lean verification, not a claim of three newly discovered mathematical results. The original final bound-five theorem remains unproved.

## Integer orders imply a logarithmic bound

For real H>=1, R>1, Z>=1 and X>0, assume that for every integer k>=1,

    1 < X*H^k/Z + Z/(2*R^k).

Then

    log(Z)*(log(R)-log(H)) < log(2*X*H)*log(R).

The proof chooses k=floor(log(Z)/log(R))+1, so log(Z)<k*log(R)<=log(Z)+log(R), and Z<R^k. The residual term is then less than 1/2, giving Z<2*X*H^k. Taking logarithms and using log(H)>=0 proves the division-free bound. In particular, R>H is NOT an extra hidden hypothesis. Connecting the all-order inequality to the actual approximation data remains a separate dependency.

## Exact scalar height transformation

For real x,z,d,p,q,h,r,u with z,q>=0, p>2*x+r>0, q<x+h, and x>h-r, assume

    z*(p-q) < (2*x+u)*p,
    d < 2/5-x+2*z.

Then

    d < 7*x+(4*u+8*h-4*r)
        +(2*u*r+(4*u+8*h-4*r)*(h-r))/(x-(h-r))+2/5.

The positive denominator x-(h-r) and comparison p*(x-(h-r))<(p-q)*(2*x+r) are derived from the stated inequalities. No absolute-value or logarithmic-base convention is hidden in this purely real statement.

## Unit-pair scalar contradiction

There are no real s,d with

    s>=4,
    27*s-4<d,
    d<7*s+617/25+(118401/2500)/(s-203/100).

For s>=4 the denominator is positive and the reciprocal term is at most 118401/4925. Direct rational arithmetic then contradicts the lower bound. This is the scalar closing step, not the complete full-ring unit-pair exclusion.

## Scope

The source imports only three pinned Mathlib modules, no other D1Bound5 research module. All three theorem types are exposed in the audit. Rechecking uses the same installed Lean kernel, not an independent implementation or independent referee. No full root integration, clean-checkout test or global theorem completion is asserted. The current runtime driver records the newly successful OrdinaryHeightScalar source fingerprint, so the hourly worker can reuse it and proceed to other unfinished wave119 modules.
