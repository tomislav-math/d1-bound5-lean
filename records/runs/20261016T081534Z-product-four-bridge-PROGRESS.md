# PROGRESS — Product-four bridge

The trial source `exploration/ProductFourSizeBridgeTrial.lean` now contains two new proven lemmas. Targeted Lean 4.33.1 compilation passed with exit code 0 (`local-logs/product-four-size-trial01.log`).

The precise missing argument is the link between the root-matrix determinant lower bound and the same signed witness as the rank-one upper bound. The proved elementary inequality uses the tail growth hypothesis `2*B*C<D`, ordered `0<=A<=B<=C`, and `B>=3` to show `A^2+B^2+C^2+D^2 <= (13/12)*D^2` and `D>18`. It does not claim `D>2ABC` in isolation.

Next: assemble an arbitrary imaginary-quadratic-full-ring A>=3 branch using actual selected signs, the rank-one lemma and full-ring determinant lower bound. Keep old staged work intact.

Strong trial result: `full_ring_productFour_large_growth` elaborated and compiled (exit code 0, 221.81-second targeted Lean run, one unused simp warning). It combines SAME signed integral root witness, analytic det/adjugate bounds, normalized invertibility, arithmetic det lower bound, and square sum to prove `D>2ABC` for every imaginary quadratic full ring, assuming the separately proven tail inequality and ordered moduli with A>=3. Existing source `exploration/ProductFourSizeBridgeTrial.lean` was copied byte-for-byte to `D1Bound5/ProductFourLargeBranch.lean` after removing the unused simp argument, imported into the project root, and provided with a dedicated transitive axiom audit. The final changed bytes now require root build and kernel replay.
