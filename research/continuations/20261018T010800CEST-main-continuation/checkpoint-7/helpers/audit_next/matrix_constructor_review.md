# Matrix constructor audit — 2026-10-18

Source-only audit requested after the pinned CrossBlockUpper compiler rejected a raw lambda passed to Matrix.det. No Lean compiler was run and no proof source was changed.

Pinned reference: mathlib 0df444a360eaa60ab8c11dca51a86af692955474, Mathlib/LinearAlgebra/Matrix/Defs.lean implementation note explicitly recommends Matrix.of when constructing a matrix from a function, even instead of an explicitly Matrix-ascribed lambda. Matrix.of is definitionally an equivalence from the function type.

All local *.lean files were scanned for direct Matrix.det (fun ...) / lambda receivers and all determinant call sites were inspected. Outside crossblock-owned files (already under repair), no additional direct raw-lambda determinant applications remain. Accepted BennettDeterminant modules were excluded from mutation.

Queued finite matrix definitions inspected:

- `finite_a_next/FiniteA3Matrix.lean` — SHA256 `e2e655ee4e57d8710dc3aa3f891fc956ce3421ebfedb3c1976c3b656531c2d23`; explicit Matrix result, Matrix.of or matrix notation.
- `finite_a_next/FiniteA4Matrix.lean` — SHA256 `8160d482ef4af6a3307162786e4040e2c1a8e04d3e0161f72bbd6a408d7657d7`; explicit Matrix result, Matrix.of or matrix notation.
- `finite_a_next/FiniteA5Matrix.lean` — SHA256 `04c9a60595c610effd0203ae4598f87c7a188f9e9a48e423cf96478db6bfe7a2`; explicit Matrix result, Matrix.of or matrix notation.
- `finite_n2_next/FiniteN2Matrix.lean` — SHA256 `1f3f076e9bd3b39bd1afb85c25ff777354cf04b5db2ff603d1bf7550fbf8c4aa`; explicit Matrix result, Matrix.of or matrix notation.
- `finite_n3_next/FiniteN3Matrix.lean` — SHA256 `9b5cf6f1b34a2d14f582faaafec43fb3607631a0d4aabe09544ccdd317c95e9c`; explicit Matrix result, Matrix.of or matrix notation.
- `finite_p_next/FinitePMatrix.lean` — SHA256 `f63bb9dc0443c81c8f1b568986847dda2ed4570060ea2207007d3b8eff49c96c`; explicit Matrix result, Matrix.of or matrix notation.
- `finite_q_next/FiniteQMatrix.lean` — SHA256 `2f755e678bd622e56202bc0ee045607d7d27be9db56f9573d2b8ebb7ab8ce87d`; explicit Matrix result, Matrix.of or matrix notation.
- `ordinary_m_next/FiniteMMatrix.lean` — SHA256 `8af7f9699b9fc84a48e57a25795d84c9aefe6f4ade8e20a65b9b82216db511c9`; explicit Matrix result, Matrix.of or matrix notation.

The only remaining bare-lambda Matrix-returning definitions found are historical bennett_draft/BennettFirstOrder.lean lines 17–18 and 64–65, and bennett_draft/BennettFirstOrderResidues.lean line 88. Their compiled/queue status is not established by this audit; they were reported to root and left unchanged. Unlike the failed direct determinant application, these have declaration-level Matrix result types.

No theorem statement, assumption, proof, or source hash changed in this audit. This result does not substitute for the serial compiler gate.
