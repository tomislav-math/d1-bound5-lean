# Original-source proof changes

The frozen v4 statement and original public theorem headers are unchanged. This records all changes from the originally prepared eight Q sources, including predecessor determinant and lexical repairs. No new public mathematical premises are introduced.

## FiniteQMatrix

```diff
--- FiniteQMatrix original
+++ FiniteQMatrix current
@@ -7,6 +7,59 @@
 namespace D1Bound5
 
 variable {R : Type*} [CommRing R]
+
+set_option maxRecDepth 4096 in
+/-- Sparse determinant expansion before substituting the polynomial row entries. -/
+private theorem finiteQSparseMatrix_det
+    (c0 l0 r0 c1 l1 r1 c2 l2 r2 c3 l3 r3 c4 l4 r4 : R) :
+    (!![c0,l0,r0,0,0; c1,l1,0,r1,0; c2,0,l2,r2,0;
+        c3,l3,0,0,r3; c4,0,l4,0,r4] : Matrix (Fin 5) (Fin 5) R).det =
+      (r4*c3-r3*c4)*(l0*r1*l2+r0*l1*r2) +
+      r3*l4*(c0*l1*r2-l0*c1*r2+l0*r1*c2) -
+      r4*l3*(c0*r1*l2+r0*c1*r2-r0*r1*c2) := by
+  have hs1_0_0 : Fin.succAbove (0 : Fin 2) (0 : Fin 1) = (1 : Fin 2) := by decide
+  have hs1_1_0 : Fin.succAbove (1 : Fin 2) (0 : Fin 1) = (0 : Fin 2) := by decide
+  have hs2_0_0 : Fin.succAbove (0 : Fin 3) (0 : Fin 2) = (1 : Fin 3) := by decide
+  have hs2_0_1 : Fin.succAbove (0 : Fin 3) (1 : Fin 2) = (2 : Fin 3) := by decide
+  have hs2_1_0 : Fin.succAbove (1 : Fin 3) (0 : Fin 2) = (0 : Fin 3) := by decide
+  have hs2_1_1 : Fin.succAbove (1 : Fin 3) (1 : Fin 2) = (2 : Fin 3) := by decide
+  have hs2_2_0 : Fin.succAbove (2 : Fin 3) (0 : Fin 2) = (0 : Fin 3) := by decide
+  have hs2_2_1 : Fin.succAbove (2 : Fin 3) (1 : Fin 2) = (1 : Fin 3) := by decide
+  have hs3_0_0 : Fin.succAbove (0 : Fin 4) (0 : Fin 3) = (1 : Fin 4) := by decide
+  have hs3_0_1 : Fin.succAbove (0 : Fin 4) (1 : Fin 3) = (2 : Fin 4) := by decide
+  have hs3_0_2 : Fin.succAbove (0 : Fin 4) (2 : Fin 3) = (3 : Fin 4) := by decide
+  have hs3_1_0 : Fin.succAbove (1 : Fin 4) (0 : Fin 3) = (0 : Fin 4) := by decide
+  have hs3_1_1 : Fin.succAbove (1 : Fin 4) (1 : Fin 3) = (2 : Fin 4) := by decide
+  have hs3_1_2 : Fin.succAbove (1 : Fin 4) (2 : Fin 3) = (3 : Fin 4) := by decide
+  have hs3_2_0 : Fin.succAbove (2 : Fin 4) (0 : Fin 3) = (0 : Fin 4) := by decide
+  have hs3_2_1 : Fin.succAbove (2 : Fin 4) (1 : Fin 3) = (1 : Fin 4) := by decide
+  have hs3_2_2 : Fin.succAbove (2 : Fin 4) (2 : Fin 3) = (3 : Fin 4) := by decide
+  have hs3_3_0 : Fin.succAbove (3 : Fin 4) (0 : Fin 3) = (0 : Fin 4) := by decide
+  have hs3_3_1 : Fin.succAbove (3 : Fin 4) (1 : Fin 3) = (1 : Fin 4) := by decide
+  have hs3_3_2 : Fin.succAbove (3 : Fin 4) (2 : Fin 3) = (2 : Fin 4) := by decide
+  have hs4_0_0 : Fin.succAbove (0 : Fin 5) (0 : Fin 4) = (1 : Fin 5) := by decide
+  have hs4_0_1 : Fin.succAbove (0 : Fin 5) (1 : Fin 4) = (2 : Fin 5) := by decide
+  have hs4_0_2 : Fin.succAbove (0 : Fin 5) (2 : Fin 4) = (3 : Fin 5) := by decide
+  have hs4_0_3 : Fin.succAbove (0 : Fin 5) (3 : Fin 4) = (4 : Fin 5) := by decide
+  have hs4_1_0 : Fin.succAbove (1 : Fin 5) (0 : Fin 4) = (0 : Fin 5) := by decide
+  have hs4_1_1 : Fin.succAbove (1 : Fin 5) (1 : Fin 4) = (2 : Fin 5) := by decide
+  have hs4_1_2 : Fin.succAbove (1 : Fin 5) (2 : Fin 4) = (3 : Fin 5) := by decide
+  have hs4_1_3 : Fin.succAbove (1 : Fin 5) (3 : Fin 4) = (4 : Fin 5) := by decide
+  have hs4_2_0 : Fin.succAbove (2 : Fin 5) (0 : Fin 4) = (0 : Fin 5) := by decide
+  have hs4_2_1 : Fin.succAbove (2 : Fin 5) (1 : Fin 4) = (1 : Fin 5) := by decide
+  have hs4_2_2 : Fin.succAbove (2 : Fin 5) (2 : Fin 4) = (3 : Fin 5) := by decide
+  have hs4_2_3 : Fin.succAbove (2 : Fin 5) (3 : Fin 4) = (4 : Fin 5) := by decide
+  have hs4_3_0 : Fin.succAbove (3 : Fin 5) (0 : Fin 4) = (0 : Fin 5) := by decide
+  have hs4_3_1 : Fin.succAbove (3 : Fin 5) (1 : Fin 4) = (1 : Fin 5) := by decide
+  have hs4_3_2 : Fin.succAbove (3 : Fin 5) (2 : Fin 4) = (2 : Fin 5) := by decide
+  have hs4_3_3 : Fin.succAbove (3 : Fin 5) (3 : Fin 4) = (4 : Fin 5) := by decide
+  have hs4_4_0 : Fin.succAbove (4 : Fin 5) (0 : Fin 4) = (0 : Fin 5) := by decide
+  have hs4_4_1 : Fin.succAbove (4 : Fin 5) (1 : Fin 4) = (1 : Fin 5) := by decide
+  have hs4_4_2 : Fin.succAbove (4 : Fin 5) (2 : Fin 4) = (2 : Fin 5) := by decide
+  have hs4_4_3 : Fin.succAbove (4 : Fin 5) (3 : Fin 4) = (3 : Fin 5) := by decide
+  simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Matrix.submatrix,
+    hs1_0_0, hs1_1_0, hs2_0_0, hs2_0_1, hs2_1_0, hs2_1_1, hs2_2_0, hs2_2_1, hs3_0_0, hs3_0_1, hs3_0_2, hs3_1_0, hs3_1_1, hs3_1_2, hs3_2_0, hs3_2_1, hs3_2_2, hs3_3_0, hs3_3_1, hs3_3_2, hs4_0_0, hs4_0_1, hs4_0_2, hs4_0_3, hs4_1_0, hs4_1_1, hs4_1_2, hs4_1_3, hs4_2_0, hs4_2_1, hs4_2_2, hs4_2_3, hs4_3_0, hs4_3_1, hs4_3_2, hs4_3_3, hs4_4_0, hs4_4_1, hs4_4_2, hs4_4_3]
+  <;> ring
 
 /-- Left divided coefficient in the manuscript's finite Q pair row. -/
 def finiteQLeft (u v c : R) : R :=
@@ -40,9 +93,9 @@
 theorem finiteQDividedMatrix_det (a b s t c : R) :
     (finiteQDividedMatrix a b s t c).det =
       180*a*b*s*t*(a-b)^2*(a-s)*(a-t)*(b-s)*(b-t)*(s-t) := by
-  simp [finiteQDividedMatrix, Matrix.det_succ_row_zero, Fin.sum_univ_succ,
-    Matrix.submatrix, finiteQConstant, finiteQLeft, finiteQRight]
-  <;> ring
+  rw [finiteQDividedMatrix, finiteQSparseMatrix_det]
+  unfold finiteQConstant finiteQLeft finiteQRight
+  ring
 
 /-- The determinant stated for the full finite Q family follows by the
 explicit column factors; no determinant certificate is an input. -/
```

## FiniteQResidualIdentity

```diff
--- FiniteQResidualIdentity original
+++ FiniteQResidualIdentity current
@@ -53,7 +53,7 @@
       norm_num at h ⊢
       exact h
     calc
-      _ = |halfBinomialCoeff (j+n)|*‖z‖^(j+n) := by
+      _ = |halfBinomialCoeff (j+n)| *‖z‖^(j+n) := by
         rw [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs]
       _ ≤ (5/128 : ℝ)*‖z‖^(j+n) :=
         mul_le_mul_of_nonneg_right hb (pow_nonneg (norm_nonneg z) _)
```

## FiniteQHeight

Unchanged original source.

## FiniteQIntegralRows

```diff
--- FiniteQIntegralRows original
+++ FiniteQIntegralRows current
@@ -11,15 +11,15 @@
 
 @[simp] theorem map_finiteQLeft (f : R →+* S) (u v c : R) :
     f (finiteQLeft u v c) = finiteQLeft (f u) (f v) (f c) := by
-  simp [finiteQLeft]
+  simp [finiteQLeft, map_ofNat]
 
 @[simp] theorem map_finiteQRight (f : R →+* S) (u v c : R) :
     f (finiteQRight u v c) = finiteQRight (f u) (f v) (f c) := by
-  simp [finiteQRight]
+  simp [finiteQRight, map_ofNat]
 
 @[simp] theorem map_finiteQConstant (f : R →+* S) (u v c : R) :
     f (finiteQConstant u v c) = finiteQConstant (f u) (f v) (f c) := by
-  simp [finiteQConstant]
+  simp [finiteQConstant, map_ofNat]
 
 @[simp] theorem map_finiteQDividedMatrix (f : R →+* S)
     (a b s t c : R) (i j : Fin 5) :
```

## FiniteQResidualBound

```diff
--- FiniteQResidualBound original
+++ FiniteQResidualBound current
@@ -58,7 +58,10 @@
       _ ≤ (‖u‖*(‖4*u^3‖+‖8*u^2*v‖))*‖c‖ := by
         exact mul_le_mul_of_nonneg_right
           (mul_le_mul_of_nonneg_left (norm_sub_le _ _) (norm_nonneg _)) (norm_nonneg _)
-      _ = _ := by dsimp [U, V, C]; norm_num [norm_mul, norm_pow]; ring
+      _ = _ := by
+        dsimp [U, V, C]
+        simp only [norm_mul, norm_pow, Complex.norm_ofNat]
+        ring
   have ht0 : ‖u*(u^2-5*u*v)*finiteQHalfRemainder 4 (1/(u*c))‖ ≤
       (U^3+5*U^2*V)*(M*(1/(U*C))^4) := by
     rw [norm_mul]
```

## FiniteQRowBound

Unchanged original source.

## FiniteQFullRing

```diff
--- FiniteQFullRing original
+++ FiniteQFullRing current
@@ -93,6 +93,11 @@
   change 1 ≤ ‖finiteQRowForm
     (f (a 0)) (f (a 1)) (f (a 2)) (f (a 3)) (f c) (f z)
     (f (sigma 0)) (f (sigma 1)) (f (sigma 2)) (f (sigma 3)) i‖ at hL
-  nlinarith only [hL, hbound, hcoeff]
+  calc
+    1 < 54*T^3*‖f c‖^2/‖f z‖+3*T*‖f z‖/(2*A^2*‖f c‖^4) :=
+      hL.trans_lt hbound
+    _ < (54*T^3*‖f c‖^2/‖f z‖+3*T*‖f z‖/(2*A^2*‖f c‖^4)) +
+        T^3*‖f c‖^2/‖f z‖ := lt_add_of_pos_right _ hcoeff
+    _ = 55*T^3*‖f c‖^2/‖f z‖+3*T*‖f z‖/(2*A^2*‖f c‖^4) := by ring
 
 end D1Bound5
```

## FiniteQInterval

Unchanged original source.

