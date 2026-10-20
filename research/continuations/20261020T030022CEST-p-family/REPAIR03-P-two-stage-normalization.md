# Normalize finite coordinates before polynomial expansion

2026-10-20T03:08:21.579783+02:00

The second actual trial produced an unsolved polynomial goal containing unreduced Fin.induction terms, so ring treated remaining coordinates as unrelated atoms. Keep all row polynomials opaque while normalizing the finite submatrix selectors, then unfold scalar polynomial definitions using explicit vector-coordinate equations. The sparse-column lemma already closed after its rfl repair. All original public statements and polynomial definitions are unchanged; no resource limit is changed.

```diff
--- before
+++ after
@@ -76,11 +76,13 @@
       -78750*a*b*s*(a-b)^5*(a-s)*(b-s)*finitePDetFactor a b s c := by
   rw [finiteP_sparse_column_det _ (by rfl) (by rfl)]
   simp only [Matrix.det_fin_three, Matrix.submatrix_apply]
-  dsimp only [finitePDividedMatrix, finitePRConstant, finitePTConstant,
-    finitePRLeft, finitePRRight, finitePTLeft, finitePTRight, finitePairQuadratic,
-    finitePRLeftCoeff, finitePRRightCoeff, finitePTLeftCoeff, finitePTRightCoeff,
-    finitePDetFactor, Matrix.of_apply, Fin.succAbove, Fin.lt_def,
-    Matrix.vecCons, Fin.cons, Fin.cases]
+  norm_num [finitePDividedMatrix, Matrix.of_apply, Fin.succAbove, Fin.lt_def,
+    Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons]
+  simp only [finitePRConstant, finitePTConstant, finitePRLeft, finitePRRight,
+    finitePTLeft, finitePTRight, finitePairQuadratic, finitePRLeftCoeff,
+    finitePRRightCoeff, finitePTLeftCoeff, finitePTRightCoeff, finitePDetFactor,
+    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
+    Matrix.head_cons, Matrix.tail_cons]
   <;> ring
 
 theorem finitePMatrix_det (a b s c : R) :
```
