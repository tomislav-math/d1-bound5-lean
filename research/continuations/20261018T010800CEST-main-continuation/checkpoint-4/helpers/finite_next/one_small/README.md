# Exact finite part of the one-small branch

All 17 Lean files are UNCOMPILED research drafts. Exact Python checks passed;
the coordinator must still compile every mathematical bridge and every
`decide +kernel` certificate. No native computation axiom is used.

The frozen manuscript excerpt is in `manuscript_source.txt`. The diagnostic
generator parses the 40 first-pair rows and 56 fixed-triple rows directly from
that excerpt and checks their stated norms. It independently reproduces:

- All 146 first pairs in the ten maximal fields, exactly the 40 prescribed
  simultaneous sign/conjugation orbits. The 16-order rectangle is checked
  before maximality exclusions. No arbitrary unit multiplication is used.
- Exactly 57 third entries of norm at most 224, with all equal-modulus cases:
  the 56 stated rows and the exceptional triple (1,-3,3).
- For every stated row and every common fourth extension of norm below its
  printed N0, the inequality N(t) <= 4 N(b) N(s). Zero and anchor coincidences
  are retained. This direct exact check replaces the manuscript's 16
  convexity estimates and two final congruence calculations.

The root-based bounded check is exhaustive: N(a)<=2 and N(t)<N0<=21270 imply
N(r)^2<=85082 for r^2=a*t+1, hence N(r)<=300. It enumerates a small root disk,
reconstructs the exact quotient (r^2-1)/a, checks multiplication, and tests
the remaining two squares. The checker never assumes divisibility or a
choice of nonzero root.

For first-pair coverage, N(a)N(b)<=63 gives an integral trace bound at most
15, so N(r)^2<=79 and N(r)<=8. If the discriminant exceeds 32, both a and r
are rational, forcing simultaneous +/-(1,3). Otherwise normalized
coordinates lie in the complete 16-order rectangle. Maximality removes the
extra orders; the discriminant-31 table is empty. This supplies arbitrary
full-ring coverage without an unproved fundamental-discriminant list.

Compile order after existing PairExtensionCore, SmallPairClassification,
SmallExtensionSymmetry, OneThreeNegative, and FullRingBridge:

1. OneSmallFiniteCheck
2. FirstPairData, then FirstPairClassification
3. OneSmallDisks, then OneSmallThirdData
4. OneSmallFourthData1 through OneSmallFourthData7
5. OneSmallRows, OneSmallSymmetry, OneSmallOrbitRows
6. OneSmallFullRingFinite
7. OneThreeEight

The principal endpoints are:

- `full_first_pair_classification`: actual full-ring coverage by the rational
  pair or one of the complete tables, with no caller-supplied coordinate model.
- `IsD1Tuple.one_small_first_triple_classification`: after the stated first-pair
  size reduction and S<15, the actual triple is in a proved normalized row,
  or the rational first pair remains. Its one exceptional normalized row
  (1,-3,3) is handled by the existing negative-extension theorem.
- `oneSmallFixedRows_bounded_growth`: exact all-56 bounded complement.
- `oneSmallRowMembership_full_ring_excludes_irregular_bound`: arbitrary
  full-ring and symmetry transport of that complement, contradicting the
  strict tail-growth bound whenever the fourth norm is below the row's N0.
- `IsD1.one_three_small_third_eq_eight`: the separate rational pair has third
  entry 8, using the accepted full-ring positivity/rationality theorem.

The analytic region reduction, S<15, and N(t)<N0 are not proved by these
finite certificates and remain explicit size hypotheses. The finite result
does not claim the main theorem or the analytic cutoff calculation.
