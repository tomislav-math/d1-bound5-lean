# Rank-one determinant and numerical closure

For every complex 4x4 matrix F with det F != 0 and complex vector w, the theorem rankOneDeterminant_adjugate_norm_le proves

  |det(F + w w^T)| <= |det F| + ||adj F||_2 * sum_i |w_i|^2.

The transpose is algebraic. No Hermitian or symmetry condition is needed. ScaledRootRankOneBound transports this inequality to the exact normalized root matrix.

ProductFourNumericalClosure defines e=128/8649, s=3139/5766 and h=8905/5766, proves h*s^2*(1+3/36+s/324)<1/2, and formally derives |det(F+w w^T)|<D^2/2 for D>18 when sum |w_i|^2 <=13*D^2/12, |det F|<h*s^3, and ||adj F||_2<h*s^2. With the additional integral determinant lower bound A*B*C*D<=|det(F+w w^T)| it deduces D>2ABC.

The upper bounds on det F and adj F remain explicit hypotheses in the new theorem types. They have not yet been proved from the operator-norm perturbation. This is not a proof of the complete product-four lemma or bound-five theorem.

Next: establish the sharp perturbative det and adjugate upper bounds in both matrix branches and connect the algebraic-integer lower bound. Bennett's arbitrary-order determinant identity and finite graph coverage remain open.

The frozen manuscript and unrelated projects are unchanged. Validation receipts must be checked before accepting this module.
