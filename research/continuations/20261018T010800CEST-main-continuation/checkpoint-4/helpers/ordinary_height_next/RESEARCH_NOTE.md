# Ordinary height envelope and unit first-extension cutoff

Stable local drafts, not yet compiler-verified, in dependency order:
1. OrdinaryHeightScalar
2. OrdinaryLog10
3. OrdinaryHeightEnvelope
4. UnitPairHeightCutoff
5. FullRingOrdinaryHeight (requires BennettRootTransfer)
6. UnitPairFirstExtensionBound (also requires UnitPairCubicIteration)

The all-order scalar argument chooses the actual natural order
k=floor(log Z/log R)+1. It proves directly

log Z (log R-log H) < log(2 X H) log R,

where X=3C/B and H=42B^3C, so 2XH=252B^2C^2.
The remainder of the argument uses logarithms only; no real-power
interpolation theorem or unproved continuous estimate is introduced.

IsD1Tuple.ordinary_height_envelope is the actual ordered-quadruple
version of the manuscript corollary. Its input rational parameter
inequalities are exactly those in the source. The all-order inequalities
are derived internally by full_ring_bennett_two_integer_k from the five
actual tuple roots, and the terminal root comparison is proved from
z^2=cd+1. The denominator and positivity conditions are explicit.

For the unit pair, all parameter inequalities are discharged by exact
integer-power comparisons 42^100<10^163, (5/2)^5<10^2 and
253^100<10^241. The reciprocal error term is bounded monotonically
for log10(S)>=4, yielding the exact contradiction with 27log10(S)-4.

IsD1Tuple.unit_pair_first_extension_lt proves S<10000 for an actual
ordered Fin6 tuple whose first entries are -1,1. It has no analytic
certificate, Pell description, real-axis, or S>=9 premise. The S<9
branch is immediate, covering the legitimate S=8 case. The large branch
uses actual cubic iteration D>S^27/8192, actual Bennett root transfer,
and the proved scalar cutoff. Compilation remains the parent agent's gate.
