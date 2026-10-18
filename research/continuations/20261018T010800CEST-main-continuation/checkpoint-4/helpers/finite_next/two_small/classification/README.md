# Nondegenerate small-pair classification

UNCOMPILED draft. Compile after SmallPairLargeDiscriminant, in this order:
SmallPairClassificationCheck, SmallPairClassificationData, SmallPairClassification.

The finite checker covers every distinct nonzero pair in the16complete
normalized norm-eight disks, provided ab+1 is a nonzero square. The actual
full-ring endpoint uses the large-discriminant exclusion, then maximality to
remove trace-zero parameters3,4,7,8 and trace-one parameter7. Exactly11models
remain, matching the fields in the48-row manuscript table.

Explicit finite equalities identify each model's entire pair table with the
union of its manuscript representative orbits under sign/conjugation; the
existing generic coordinate operator `smallTripleOrbit` applies to arbitrary
finite coordinate sets and is reused here for pairs. The diagnostic generator
independently checked exact equality with all48source orbits. Unordered pairs
handle interchange automatically.

The final theorem proves complete containment in the explicit48orbits for
actual full rings. It does not yet apply the48graph exclusions under symmetry.
The product−1 exceptional cases remain outside this nondegenerate classifier.
