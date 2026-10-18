# Arbitrary small-pair graph exclusion

UNCOMPILED research drafts. No compiler success is claimed for these files or
their 48 graph-certificate dependencies.

Compile after all graph data and `SmallPairGraphs`, the three classifier files,
and the existing `SmallExtensionSymmetry`, in this order:

1. `SmallPairGraphSymmetry`
2. `SmallPairRepresentativeProperties`
3. `SmallPairOrbitProperties`
4. `SmallPairBoundedExtensions`
5. `TwoSmallSextuple`

`SmallPairGraphProperty` excludes a D(1)-triple of proper common extensions in
the closed annulus with radii 3 and 10^550. The symmetry theorem transports both
anchor compatibility edges and all three extension-to-extension edges. Each
representative property applies one of the 48 complete graph endpoints, and
the orbit layer covers every classified pair without ordering assumptions.

`IsD1Tuple.small_pair_excludes_three_in_disk` is the final actual full-ring
statement. Its assumptions are an arbitrary small D(1)-pair with ab+1 nonzero,
three distinct nonzero mutually compatible proper common extensions, and
3 <= |z| <= 10^550 for each extension. No model, coordinate, certificate,
descent, symmetry, or root-choice premise is left to the caller.

`IsD1Tuple.two_small_fifth_large` packages this for an ordered sextuple: if the
second modulus is less than 3, the third at least 3, and the first anchor
product is not -1, then the fifth modulus is greater than 10^550. This is only
the finite half of the two-small contradiction; it does not claim the needed
analytic upper bound or settle the product -1 exceptions.

The exact closure retains zero, anchor coincidences, and small intermediate
vertices. Properness and the lower modulus bound are imposed only on the
final three extensions. The classifier covers the full ring using maximality;
all finite root and graph decisions still need the coordinator's Lean kernel
checks. The Python generator merely expands repetitive proof applications.
