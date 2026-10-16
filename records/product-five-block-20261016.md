# Product-five scalar block determinant bridge (2026-10-16)

Frozen v4 manuscript, equation (integrated-3). This record describes an exact matrix identity, not the full product-five inequality.

For arbitrary finite index n, complex A in Matrix n n, vectors b,c and scalar d != 0, the proof establishes

  det [[A,b],[c^T,d]] = d * det (A - b c^T/d).

The proof constructs an explicit inverse of the 1x1 bottom-right block and applies mathlib Matrix.det_fromBlocks₂₂. No invertibility condition is imposed on A.

For any complex 4x4 matrix F, f,w in C^4, d != 0, define the 5x5 block matrix N by top-left block F + w w^T, top-right column f+d*w, bottom-left row (f+d*w)^T and bottom-right entry d^2. The exact Schur complement is

  G_ij = F_ij - (w_i f_j + f_i w_j)/d - f_i f_j/d^2.

The new Lean theorem `productFiveIntegratedBlock_det` proves det N = d^2 det G, with no symmetry or invertibility assumption on F. This is the block determinant part of (integrated-3). Its index is Fin 4 ⊕ Fin 1, equivalent to Fin 5, and the bridge to the actual five-entry scaled integral root matrix must still be proved.

Source: `exploration/FiveBlockDetRuntime9.lean` (separate from the concurrent ProductFiveRankTwo integration). The local elaboration and .olean compilation both returned exit zero. The corrected exact-type/axiom audit and targeted kernel replay were initiated after an audit-script documentation parsing error; read the final log receipts before claiming acceptance.

Remaining product-five work: prove the specific full-ring five-by-five matrix decomposition, quantitative bounds for its four-entry prefix and last column, determinant comparison with the integral determinant, and the growth D>3ABSC. Bennett, certified finite exclusions and global MainStatement remain open.
