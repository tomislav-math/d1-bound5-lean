# Repair01 — explicit third vector coordinate

2026-10-20T02:26:54.391365+02:00

The prepared six-case proof compiled the first four cases but left literal coordinate2 unresolved in cases20 and21. Add the actual matrix third-coordinate/head/tail simplifiers to each of the six private calculations. No mathematical expression, public header, coefficient, resource budget or import is changed. Predecessor batch exited1 and was collected; both locks held.

```diff
--- before
+++ after
@@ -34,7 +34,7 @@
       ∑ ell : Fin 6, finiteA5RootCoeff x y 0 0 ell*c^(ell : ℕ) := by
   norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
     finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
-    finiteHomogeneousTwo,Fin.sum_univ_succ]
+    finiteHomogeneousTwo,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
   <;> ring
 
 private theorem finiteA5_root_coeff_01 {R : Type*} [CommRing R]
@@ -43,7 +43,7 @@
       ∑ ell : Fin 6, finiteA5RootCoeff x y 0 1 ell*c^(ell : ℕ) := by
   norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
     finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
-    finiteHomogeneousTwo,Fin.sum_univ_succ]
+    finiteHomogeneousTwo,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
   <;> ring
 
 private theorem finiteA5_root_coeff_10 {R : Type*} [CommRing R]
@@ -52,7 +52,7 @@
       ∑ ell : Fin 6, finiteA5RootCoeff x y 1 0 ell*c^(ell : ℕ) := by
   norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
     finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
-    finiteHomogeneousTwo,Fin.sum_univ_succ]
+    finiteHomogeneousTwo,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
   <;> ring
 
 private theorem finiteA5_root_coeff_11 {R : Type*} [CommRing R]
@@ -61,7 +61,7 @@
       ∑ ell : Fin 6, finiteA5RootCoeff x y 1 1 ell*c^(ell : ℕ) := by
   norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
     finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
-    finiteHomogeneousTwo,Fin.sum_univ_succ]
+    finiteHomogeneousTwo,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
   <;> ring
 
 private theorem finiteA5_root_coeff_20 {R : Type*} [CommRing R]
@@ -70,7 +70,7 @@
       ∑ ell : Fin 6, finiteA5RootCoeff x y 2 0 ell*c^(ell : ℕ) := by
   norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
     finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
-    finiteHomogeneousTwo,Fin.sum_univ_succ]
+    finiteHomogeneousTwo,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
   <;> ring
 
 private theorem finiteA5_root_coeff_21 {R : Type*} [CommRing R]
@@ -79,7 +79,7 @@
       ∑ ell : Fin 6, finiteA5RootCoeff x y 2 1 ell*c^(ell : ℕ) := by
   norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
     finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
-    finiteHomogeneousTwo,Fin.sum_univ_succ]
+    finiteHomogeneousTwo,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
   <;> ring
 
 theorem finiteA5_root_coeff_decomposition {R : Type*} [CommRing R]
```
