# Finite small-triple symmetry bridge

Drafts for root-owned sequential compilation, not yet compiler-verified.

Dependency order:
1. `SmallExtensionSymmetry`
2. `SmallTripleRepresentativeProperties`
3. `SmallTripleOrbitProperties`
4. `SmallTripleBoundedExtensions`
5. `ThreeSmallSextuple`

The endpoint `IsD1Tuple.small_triple_bounded_extensions` concerns any actual
three-element D(1) tuple in the full integer ring of an imaginary quadratic
number field, with every anchor modulus < 3. Every distinct nonzero further
common extension with squared modulus <= 10^80 has modulus < 85. Two such
extensions are equal. All bounds and uniqueness follow from the finite
representative certificates and the 24-entry classification; no conclusion
is included as a premise.

`ProperCommonExtension` requires final nonzero and distinctness only.
The imported mutation closure certificates still include zero and repeated
anchor intermediates. We do not impose properness at mutation steps.

The transport proof uses simultaneous negation and algebraic conjugation.
Negation preserves pair products, while conjugation transports their square
roots. Both preserve the exact integral norm and are involutions. Coordinate
orbit equality is the already finite-checked `smallTripleTable_orbits`.
The reordered descent anchors are compared as unordered sets, not as ordered
triples. Representative 7 uses (-16,8); representative 10 uses (32,-64).
The latter has norm 7168, strictly below 85^2 = 7225.

Final full-ring transport uses `norm_sq_full_ring_equiv`, so it applies to
any complex embedding and introduces no unproved coordinate compatibility.

`IsD1Tuple.three_small_fifth_large` further proves that any ordered actual
sextuple with third modulus < 3 has fifth modulus > 10^40; its fourth
modulus is either < 85 or > 10^40. This uses no upper bound on the sixth
entry.
