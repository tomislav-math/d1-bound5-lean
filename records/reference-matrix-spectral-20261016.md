# Exact reference matrix for the four-entry determinant estimate

Formal source: `D1Bound5/ReferenceMatrixSpectral.lean`. The existing reference matrix is H = `(J_4-I_4)/2`, diagonal zero and off-diagonal 1/2. No assumptions on tuple entries appear in the six new declarations.

## Mathematical proof

Define K to have diagonal -4/3 and off-diagonal 2/3. In matrix notation, H = (J-I)/2 and K = -2I+(2/3)J. The identity J²=4J yields HK=KH=I; the Lean proof verifies all sixteen entries in each identity. Hence det H is nonzero.

For the exact determinant write H = (-1/2)(I-J) and express `-J` as the product of a 4-by-1 column of -1 entries and a 1-by-4 row of 1 entries. The proved matrix determinant lemma gives det(I-J)=1-4=-3. Therefore det H=(-1/2)^4(-3)=-3/16. This avoids a brute-force twenty-four-term determinant expansion.

By H adj(H) = det(H) I and KH=I, adj(H)=det(H) K. Consequently the diagonal entries of adj(H) equal 1/4 and all off-diagonal entries equal -1/8. These identities are established in Lean by the general adjugate identity plus the explicit inverse. No singular-value or analytic norm assertion is assumed.

## Verification scope

Direct module elaboration: exit 0. Integrated root build: exit 0, 3006 Lake jobs. Source/import scan: PASS, 43 modules and 234 explicit theorems. Targeted transitive-axiom audit and new-module kernel replay must be recorded separately after their actual results are available; compilation is not proof of a successful replay.

## Remaining dependency

The spectral perturbation estimate for F-H has been proved in `RootMatrixOperatorBound`. Still required for `lem:product-four` are a formal spectral norm bound on K, perturbative determinant/adjugate upper bounds, and the mixed A>=1,B>=3 case. Bennett's all-orders identity and the global bound-five theorem remain open.

## Final validation receipt

The deferred checks described above have now finished. The targeted transitive-axiom audit passed, exit 0, for all seven new declarations and found only `propext`, `Classical.choice`, and `Quot.sound`. The installed Lean kernel replay of `D1Bound5.ReferenceMatrixSpectral` also passed, exit 0. Fully elaborated theorem types were inspected. This targeted replay is neither a whole-root replay nor an independently implemented checker.
