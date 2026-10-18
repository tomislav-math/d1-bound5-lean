# Independent review: QuadSquareFloorObstruction

Reviewed source: `floor_next/QuadSquareFloorObstruction.lean`, SHA256 `681d029399e948749766bc59da39f9c99fd35022e8c1582a1085c068b6abec83`.

Result: mathematical and source-API review PASS. This is not a compiler or kernel-acceptance receipt. No source was changed.

- The integer interval lemma correctly replaces a putative square root by its absolute value, applies strict monotonicity of squaring only to nonnegative endpoints, and derives the impossible integer gap k < |n| < k+1. The lower endpoint k is explicitly nonnegative.
- The scaled lemma cancels a strictly positive scale on both inequalities. It never uses truncated division or assumes an unverified divisibility statement.
- The positive-real branch obtains strict positivity from k² < m and applies the accepted positive rational-square classification under positive discriminant.
- The negative-real branches derive m<0 from their checked lower inequalities, then use the accepted exact identities m=−nu*n² or m=−(4nu−1)*n². The signs and scale factors agree with RationalSquares. The zero radicand cannot satisfy a checked lower bound; no zero-root exclusion is assumed.
- Norm rejection uses only multiplicativity: a genuine square z=r*r implies z.norm=r.norm². This algebraic implication needs no discriminant or nonzero hypothesis. The proof has the same `map_mul` and `pow_two` use as accepted `QuadInt.square_coordinates` in SquareTest.
- The computable checker determines its branch from the actual radicand and ring trace. The witness is only a natural number; every asserted interval is explicitly decided. Unsupported traces can reject a nonreal or positive-real input via valid generic criteria, but the nonpositive-real branch returns false.
- Soundness obtains the required positive scale from the actual positive discriminant after substituting tau=0 or tau=1. The z-to-integer-cast equality is established from both actual coordinates.

Pinned API verification used mathlib `0df444a360eaa60ab8c11dca51a86af692955474`: `sq_abs` in Algebra/Order/Ring/Abs.lean:81 and `sq_lt_sq₀ (ha : 0≤a) (hb : 0≤b) : a²<b² ↔ a<b` in Algebra/Order/GroupWithZero/Basic.lean:712. Accepted project Coordinates defines `QuadInt tau nu = QuadraticAlgebra ℤ (-nu) tau` and discriminant `4*nu-tau²`. Accepted RationalSquares and SquareTest were read directly; their signatures and formulas match all uses here.

No mathematical gap, theorem weakening, unchecked witness assumption, or evident pinned-API mismatch was found. The serial compiler remains the next required gate.
