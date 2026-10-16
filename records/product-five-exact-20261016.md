# Exact rank-two determinant identity for the normalized five-entry matrix

Date: 2026-10-16. Source `D1Bound5/ProductFiveExactIdentity.lean` (SHA256 `6ac5997ec73913f4e6c11bdd843ec02784b0283e37205bd8579ba3bcc84fb6a8`). Frozen manuscript: v4, Lemma `lem:product-five`, equation `integrated-3`.

Let `t,u : Fin 5 -> C` with `u_i^2=t_i` and let `M` be a symmetric complex 5x5 matrix with diagonal `t`. Set `E_ij=u_i M_ij u_j-t_i t_j`, `F=E_{0..3,0..3}`, `f_i=E_{i4}`, `w_i=t_i` for i<4, and `d=t_4`. If `d != 0` and `det F != 0`, the new theorem proves exactly

`(prod_i t_i) det M = d^2 det F * (1-2h/d+(h^2-pq-p)/d^2)`,

where `h=f^T F^(-1)w`, `p=f^T F^(-1)f`, `q=w^T F^(-1)w`. These are algebraic bilinear forms, with no complex conjugation. Two additional lemmas prove transpose symmetry of a leading four-by-four principal block and of the normalized error. Thus the symmetry premise of the earlier rank-two determinant formula is now discharged for an actual five-entry symmetric root matrix. No zero-square, modulus-tie or nonzero-prefix-coordinate restrictions are introduced. This is an exact structural identity, not the numerical product-five growth inequality.

Proof inputs previously established: `five_normalized_root_det` (Fin5 block determinant via the scalar Schur complement) and `productFiveSchur_det` (symmetric four-by-four rank-two determinant factor). Both are now intended for root integration together with the new module; check actual compiler/audit receipts before claiming acceptance.

The remaining mathematical tasks for `lem:product-five` are the quantitative prefix inverse and last-column bounds; upper determinant bound `|det G|<1/3`; prove `G` nonsingular so that the integral determinant has absolute value >=1 (five is odd and the earlier even-dimensional lower theorem does not apply); then conclude `D>3ABSC` for an actual ordered five-tuple. The full Bennett determinant, certified finite coverage/descent and sextuple exclusion remain separate open obligations. `MainStatement` remains a proposition.
