# Definitional normalization of P coordinates

2026-10-20T03:03:47.677645+02:00

The sparse-column helper reduced to the reflexive Fin.succ2=3 equality, now closed by rfl. The remaining failure was in recursive simplification of the expanded concrete matrix, not in the ring identity. Replace arithmetic norm_num/simp traversal of the large polynomials by definitional reduction of the selected coordinate functions before ring normalization. The first bounded trial exited1 and its terminal result was collected. Both locks are held. Original public theorem headers, definitions and resource limits are unchanged.

```diff
--- before
+++ after
@@ -66,6 +66,7 @@
       M 3 3 * (M.submatrix (3 : Fin 4).succAbove (3 : Fin 4).succAbove).det := by
   rw [Matrix.det_succ_column M 3]
   norm_num [Fin.sum_univ_succ, h0, h2]
+  rfl
 
 set_option maxHeartbeats 4000000 in
 /-- Exact determinant from the displayed integer polynomials. No rank
@@ -75,11 +76,11 @@
       -78750*a*b*s*(a-b)^5*(a-s)*(b-s)*finitePDetFactor a b s c := by
   rw [finiteP_sparse_column_det _ (by rfl) (by rfl)]
   simp only [Matrix.det_fin_three, Matrix.submatrix_apply]
-  norm_num [finitePDividedMatrix, finitePRConstant, finitePTConstant,
+  dsimp only [finitePDividedMatrix, finitePRConstant, finitePTConstant,
     finitePRLeft, finitePRRight, finitePTLeft, finitePTRight, finitePairQuadratic,
     finitePRLeftCoeff, finitePRRightCoeff, finitePTLeftCoeff, finitePTRightCoeff,
-    finitePDetFactor, Fin.succAbove, Fin.lt_def,
-    Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons]
+    finitePDetFactor, Matrix.of_apply, Fin.succAbove, Fin.lt_def,
+    Matrix.vecCons, Fin.cons, Fin.cases]
   <;> ring
 
 theorem finitePMatrix_det (a b s c : R) :
```
