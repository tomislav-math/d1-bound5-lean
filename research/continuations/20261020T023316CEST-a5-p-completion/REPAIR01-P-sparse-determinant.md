# Sparse P determinant expansion

2026-10-20T02:39:54.893843+02:00

The previous real compilation exceeded simplifier recursion depth while recursively expanding every minor. Expand along the last column, whose rows0 and2 are zero, then use the explicit3x3 determinant formula on the remaining two minors. The private sparse-column lemma is proved for every commutative ring and both zero entries are definitional in the actual matrix. No depth, heartbeat or time budget is increased. The original public statements and all polynomial definitions are unchanged. The existing intake lock was held and the active protected closure excluded this file.

```diff
--- before
+++ after
@@ -58,16 +58,28 @@
 def finitePDetFactor (a b s c : R) : R :=
   7*(2*s-a-b)+6*c*(3*s^2-(a+b)*s-a*b)
 
+/-- Expansion on the sparse last column leaves exactly two minors. -/
+private theorem finiteP_sparse_column_det (M : Matrix (Fin 4) (Fin 4) R)
+    (h0 : M 0 3 = 0) (h2 : M 2 3 = 0) :
+    M.det =
+      M 1 3 * (M.submatrix (1 : Fin 4).succAbove (3 : Fin 4).succAbove).det +
+      M 3 3 * (M.submatrix (3 : Fin 4).succAbove (3 : Fin 4).succAbove).det := by
+  rw [Matrix.det_succ_column M 3]
+  norm_num [Fin.sum_univ_succ, h0, h2]
+
 set_option maxHeartbeats 4000000 in
 /-- Exact determinant from the displayed integer polynomials. No rank
 or leading-coefficient certificate is assumed. -/
 theorem finitePDividedMatrix_det (a b s c : R) :
     (finitePDividedMatrix a b s c).det =
       -78750*a*b*s*(a-b)^5*(a-s)*(b-s)*finitePDetFactor a b s c := by
-  simp [finitePDividedMatrix, finitePRConstant, finitePTConstant,
+  rw [finiteP_sparse_column_det _ (by rfl) (by rfl)]
+  simp only [Matrix.det_fin_three, Matrix.submatrix_apply]
+  norm_num [finitePDividedMatrix, finitePRConstant, finitePTConstant,
     finitePRLeft, finitePRRight, finitePTLeft, finitePTRight, finitePairQuadratic,
     finitePRLeftCoeff, finitePRRightCoeff, finitePTLeftCoeff, finitePTRightCoeff,
-    finitePDetFactor, Matrix.det_succ_row_zero, Fin.sum_univ_succ, Matrix.submatrix]
+    finitePDetFactor, Fin.succAbove, Fin.lt_def,
+    Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons]
   <;> ring
 
 theorem finitePMatrix_det (a b s c : R) :
```
