# Small-triple classification draft

UNCOMPILED. Root is sole compiler and remote writer. These modules extend the
previous SmallQuadruple modules; they have no `sorry`, axioms or native evaluation.

Compile order: SmallTripleCheck, SmallTripleData, SmallTripleClassification.

The completed mathematical target is the classification part of manuscript
Lemma 7.12: any three distinct nonzero D(1) entries of modulus <3 in a full
imaginary quadratic integer ring belong to the 24 explicit coordinate triples
in four models (tau,nu)=(0,1),(0,2),(1,1),(1,2), i.e. d=1,2,3,7.
The tables are also checked equal to the unions of the ten manuscript orbits
under simultaneous negation and conjugation. In half-integral coordinates,
x+yω=(2x+y+y*sqrt(-d))/2.

Coverage proof: complete norm≤8 disks from SmallQuadrupleData; nested Boolean
classifier tests every ordered distinct nonzero triple and all three square
conditions, including zero roots. Every positive normalized model with
Δ≤32 is among 16 checked models. If Δ>32, all small coordinates are rational;
three distinct nonzero values in [-2,2] necessarily give product 2, while 3
is not a square. Only five models have a nonempty triple table; maximality
excludes the extra (0,4) Gaussian suborder using squarefree_trace_zero_parameter.
The endpoint transports the actual tuple through the full integer-ring
isomorphism and proves integer norm≤8 from strict embedded modulus<3.

The draft establishes complete containment in the explicit table and orbit
agreement. It does not yet assert a theorem realizing every row as an IsD1
finset, though the independent generation confirms this. It does not claim
any extension-column completeness or Proposition 7.14.

The next missing finite unit is reversible-descent closure soundness for the
chosen ten anchor pairs. The article gives exact closure sizes
61,89,64,105,71,112,112,57,83,55 through radius10^40. A kernel certificate need
only verify the radius33 seed list, the two neighbors of each listed vertex
within radius10^40, and the third-anchor filter. The analytic descent lemma
supplies termination/completeness. Existing DescentAlgebra supplies root and
vertex reversibility. No enumeration of the huge geometric disk is needed.

`generate_tables.py` is diagnostic source for the finite tables, not a trusted
input to Lean. It regenerates all16 graphs by exact integer arithmetic and
compares their triangles with the ten manuscript orbits. The `.lean` proof
checks each concrete table independently with `decide +kernel`.
