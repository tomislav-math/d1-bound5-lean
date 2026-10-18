# Exact small-triple extension certificates

UNCOMPILED DRAFT. No accepted result claimed until root compiles and audits.
Root is the sole compiler/remote writer. Files are ready for staged integration.
Source-audit independently reviewed PairExtensionCore and PairExtensionComplete
and found the mathematics sound, including the integer root bound and zero-root cases.

Compile order:
1. PairExtensionCore (only accepted SquareTest/DiskEnumeration/DescentAlgebra)
2. PairSeedDisks
3. SmallTripleExtensionData1 through SmallTripleExtensionData10
4. PairExtensionComplete (needs the new FullRingDescent module)
5. SmallTripleExtensions

This is an actual complete finite-proof branch, not huge-radius enumeration.
PairExtensionCore proves a uniform seed-root norm bound of132 from N(a)≤8,
N(z)≤1089, reconstructs z=(q²−1)/a, and proves soundness of the seed, closure,
and third-anchor filters. It also proves root uniqueness up to sign from the
positive-definite coordinate norm, then proves arbitrary mutation edges can
be reversed through one of the two deterministic canonical-root neighbors.
Zero roots, zero vertices and anchor coincidences are retained throughout.

The four explicit root disks have norm bound132. The ten closure lists are
finite exact coordinate data through N(z)≤10^80. Their respective lengths
are61,89,64,105,71,112,112,57,83,55, matching the manuscript. Every seed is
checked present, both canonical neighbors of every vertex are checked present
whenever within the bound, and the third-anchor filter yields precisely the
advertised singleton, or an empty list in row8. `decide +kernel` checks all
certificates; Python output is not trusted.

PairExtensionComplete uses strong induction on the nonnegative integer norm,
the actual full-ring analytic descent, and the proved canonical reversibility
to establish completeness of any seed-covered closed list. This theorem is
then instantiated in SmallTripleExtensions to provide unconditional complete
extension-list theorems for each of the ten manuscript representatives in
any actual full integer ring equivalent to the corresponding coordinate model.
No unproved descent assumption appears in those final theorem statements.

Still needed to close the whole three-small finite lemma: transport the ten
extension assertions under simultaneous negation/conjugation, connect arbitrary
triple-coordinate sets to those representatives, and extract “at most one,
with norm<85”. The previous triple classification already proves every actual
small triple belongs to one of these ten coordinate orbits. This does not yet
prove the analytic Proposition7.14.

Diagnostic source: ../triple/generate_extensions.py regenerates all seed and
closure lists and compares every advertised extension and count; this folder's
generate_lean_data.py converts the generated integers into reviewable Lean.
