# Norm-decreasing small-pair descent

Status: drafts awaiting root-owned compilation. This is a proof of manuscript Lemma 7.5 (label sm:bs7-descent), not an assumption of its numerical conclusion. No manuscript modification is made.

## Arithmetic denominator

The separate draft DescentDenominator.lean proves |2r0^2-1|^2>=7 from integrality of r0, r0+1 and r0-1. All three elements are nonzero when a,b are nonzero, ab+1!=0 and r0^2=ab+1.

There is no need to classify units or integer traces. Set n=|r0|^2 and t=2 Re(r0). Discreteness gives n>=1 and |r0±1|^2=n+1±t>=1. Thus |t|<=n. The identity

|2r0^2-1|^2=4n^2+4n+1-2t^2

then gives a lower bound 2n^2+4n+1>=7.

## Contracting multiplier

Choose eta^2=ab. The two multipliers 2ab+1±2r0 eta have product one. If both norms were at least1/5, both would be at most5, and (5-x)(5-y)>=0 with xy=1 would imply x+y<=26/5. The triangle inequality would yield 2|2ab+1|<=26/5, contrary to |2ab+1|^2>=7, since 28>(26/5)^2. Changing the sign of eta therefore makes

|2ab+1-2r0 eta|<1/5.

## Root perturbation and mutation

Let Z=|z|>=33. For tau0=rs,

tau0^2-(eta z)^2=(a+b)z+1.

Because |a|,|b|<3 and |ab|>=1, this difference has norm at most7Z, while 7Z<|eta z|^2. The previously proved root-perturbation lemma with c=0 chooses tau=±rs with

|eta| |tau-eta z|<7.

The elementary bound |r0|^2<=|ab|+1<=2|ab|=2|eta|^2 gives

|r0|^2 |tau-eta z|^2<98<100,

and therefore |2r0(tau-eta z)|<20. The matching mutation w satisfies

w=a+b+(2ab+1-2r0 eta)z-2r0(tau-eta z),

so |w|<6+Z/5+20=Z/5+26<Z.

The sign tau=rs produces mutate(a,b,z,r0,r,-s); tau=-rs produces mutate(a,b,z,r0,r,s). The input roots are arbitrary fixed roots. The already formalized mutate_roots supplies integral output roots, and mutate_reverse supplies reversibility. Zero output roots and zero output extensions remain permitted.

## Files and intended endpoint

- DescentNorm.lean: contracting multiplier and complex mutation norm estimate.
- FullRingDescent.lean: full-ring endpoint with actual two-neighbor membership, integral output roots, explicit norm bound, strict norm decrease and strict squared-norm decrease.
- Dependency: main_next/DescentDenominator.lean, written and audited independently.

The endpoint assumes only the full imaginary quadratic integer ring, a!=0, b!=0, ab+1!=0, the three exact root equations, |a|,|b|<3 and |z|>=33. It has no contraction, numerical decrease, root-sign, nonzero-output or finite-enumeration premise.
