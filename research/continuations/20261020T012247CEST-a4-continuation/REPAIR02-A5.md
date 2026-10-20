# A5 proof preparation

2026-10-20T01:28:13.835755+02:00

Read all eight A5 sources and preserve original public headers, coefficient data and k=5,m=4,g=4. Apply the same proven normalization and scaling repairs. The sixth coordinate uses the pinned generic Matrix.cons_val_succ' lemma. Hold the existing intake lock and preserve the live A4 dependency closure. No second compiler was started.

```diff
--- FiniteA5Coefficients.before
+++ FiniteA5Coefficients.after
@@ -31,7 +31,7 @@
   fin_cases i <;> fin_cases j
   all_goals
     norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
-      finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,finiteHomogeneousTwo,Fin.sum_univ_succ]
+      finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,finiteHomogeneousTwo,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]
     <;> ring
 
 def finiteA5CoefficientSums : Fin 3 → Fin 6 → ℤ :=
@@ -40,31 +40,31 @@
 theorem finiteA5_coefficient_sums_0 (i : Fin 3) :
     (∑ r, |(finiteA5Coeff0 i 0 r : ℝ)|)+
       (∑ r, |(finiteA5Coeff0 i 1 r : ℝ)|) = finiteA5CoefficientSums i 0 := by
-  fin_cases i <;> norm_num [finiteA5Coeff0,finiteA5CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA5Coeff0,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]
 
 theorem finiteA5_coefficient_sums_1 (i : Fin 3) :
     (∑ r, |(finiteA5Coeff1 i 0 r : ℝ)|)+
       (∑ r, |(finiteA5Coeff1 i 1 r : ℝ)|) = finiteA5CoefficientSums i 1 := by
-  fin_cases i <;> norm_num [finiteA5Coeff1,finiteA5CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA5Coeff1,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]
 
 theorem finiteA5_coefficient_sums_2 (i : Fin 3) :
     (∑ r, |(finiteA5Coeff2 i 0 r : ℝ)|)+
       (∑ r, |(finiteA5Coeff2 i 1 r : ℝ)|) = finiteA5CoefficientSums i 2 := by
-  fin_cases i <;> norm_num [finiteA5Coeff2,finiteA5CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA5Coeff2,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]
 
 theorem finiteA5_coefficient_sums_3 (i : Fin 3) :
     (∑ r, |(finiteA5Coeff3 i 0 r : ℝ)|)+
       (∑ r, |(finiteA5Coeff3 i 1 r : ℝ)|) = finiteA5CoefficientSums i 3 := by
-  fin_cases i <;> norm_num [finiteA5Coeff3,finiteA5CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA5Coeff3,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]
 
 theorem finiteA5_coefficient_sums_4 (i : Fin 3) :
     (∑ r, |(finiteA5Coeff4 i 0 r : ℝ)|)+
       (∑ r, |(finiteA5Coeff4 i 1 r : ℝ)|) = finiteA5CoefficientSums i 4 := by
-  fin_cases i <;> norm_num [finiteA5Coeff4,finiteA5CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA5Coeff4,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]
 
 theorem finiteA5_coefficient_sums_5 (i : Fin 3) :
     (∑ r, |(finiteA5Coeff5 i 0 r : ℝ)|)+
       (∑ r, |(finiteA5Coeff5 i 1 r : ℝ)|) = finiteA5CoefficientSums i 5 := by
-  fin_cases i <;> norm_num [finiteA5Coeff5,finiteA5CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA5Coeff5,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]
 
 end D1Bound5
--- FiniteA5IntegralRows.before
+++ FiniteA5IntegralRows.after
@@ -10,15 +10,15 @@
 
 @[simp] theorem map_finiteA5Constant (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteA5Constant x y c i) = finiteA5Constant (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteA5Constant]
+  fin_cases i <;> simp [finiteA5Constant, map_ofNat]
 
 @[simp] theorem map_finiteA5Left (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteA5Left x y c i) = finiteA5Left (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteA5Left]
+  fin_cases i <;> simp [finiteA5Left, map_ofNat]
 
 @[simp] theorem map_finiteA5Right (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteA5Right x y c i) = finiteA5Right (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteA5Right]
+  fin_cases i <;> simp [finiteA5Right, map_ofNat]
 
 @[simp] theorem map_finiteA5DividedMatrix (f : R →+* S)
     (x y c : R) (i j : Fin 3) :
--- FiniteA5Height.before
+++ FiniteA5Height.after
@@ -13,36 +13,36 @@
       (finiteHomogeneousTwo_norm_le 7 (finiteA5Coeff0 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 7 (finiteA5Coeff0 i 1) x y hxy)
     rw [← add_mul,finiteA5_coefficient_sums_0] at hh
-    simpa [finiteA5RootCoeff] using hh
+    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 8 (finiteA5Coeff1 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 8 (finiteA5Coeff1 i 1) x y hxy)
     rw [← add_mul,finiteA5_coefficient_sums_1] at hh
-    simpa [finiteA5RootCoeff] using hh
+    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 9 (finiteA5Coeff2 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 9 (finiteA5Coeff2 i 1) x y hxy)
     rw [← add_mul,finiteA5_coefficient_sums_2] at hh
-    simpa [finiteA5RootCoeff] using hh
+    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 10 (finiteA5Coeff3 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 10 (finiteA5Coeff3 i 1) x y hxy)
     rw [← add_mul,finiteA5_coefficient_sums_3] at hh
-    simpa [finiteA5RootCoeff] using hh
+    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 11 (finiteA5Coeff4 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 11 (finiteA5Coeff4 i 1) x y hxy)
     rw [← add_mul,finiteA5_coefficient_sums_4] at hh
-    simpa [finiteA5RootCoeff] using hh
+    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 12 (finiteA5Coeff5 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 12 (finiteA5Coeff5 i 1) x y hxy)
     rw [← add_mul,finiteA5_coefficient_sums_5] at hh
-    simpa [finiteA5RootCoeff] using hh
+    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
 
 theorem finiteA5_coefficient_sums_nonneg (i : Fin 3) (ell : Fin 6) :
     0 ≤ (finiteA5CoefficientSums i ell : ℝ) := by
-  fin_cases i <;> fin_cases ell <;> norm_num [finiteA5CoefficientSums]
+  fin_cases i <;> fin_cases ell <;> norm_num [finiteA5CoefficientSums, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]
 
 /-- Exact rational row checks preserve the manuscript's sharp M=3113013. -/
 theorem finiteA5_height_slack (i : Fin 3) :
@@ -77,7 +77,13 @@
   have heq : (101/100 : ℝ)*(‖y‖^7*∑ ell : Fin 6,
       (finiteA5CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) <
       3113013*‖y‖^12*‖c‖^5 := by
-    convert hm using 1 <;> ring
+    calc
+      (101/100 : ℝ)*(‖y‖^7*∑ ell : Fin 6,
+          (finiteA5CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) =
+          ‖y‖^7*((101/100 : ℝ)*(∑ ell : Fin 6,
+            (finiteA5CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ))) := by ring
+      _ < ‖y‖^7*(3113013*(‖y‖*‖c‖)^5) := hm
+      _ = 3113013*‖y‖^12*‖c‖^5 := by ring
   exact hnorm.trans_lt heq
 
 end D1Bound5
--- FiniteA5ResidueIdentity.before
+++ FiniteA5ResidueIdentity.after
@@ -12,6 +12,13 @@
     (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
     finiteUnequalClearedEntry x y c 5 4 i j =
       4*finiteA5RowFactor x y i*finiteA5Matrix x y c i j := by
+  have hfin01 : (0 : Fin 3) ≠ 1 := by decide
+  have hfin02 : (0 : Fin 3) ≠ 2 := by decide
+  have hfin10 : (1 : Fin 3) ≠ 0 := by decide
+  have hfin12 : (1 : Fin 3) ≠ 2 := by decide
+  have hfin20 : (2 : Fin 3) ≠ 0 := by decide
+  have hfin21 : (2 : Fin 3) ≠ 1 := by decide
+  have hanti0 : Finset.antidiagonal 0 = {(0,0)} := by decide
   have hanti1 : Finset.antidiagonal 1 = {(0,1),(1,0)} := by decide
   have hanti2 : Finset.antidiagonal 2 = {(0,2),(1,1),(2,0)} := by decide
   have hanti3 : Finset.antidiagonal 3 = {(0,3),(1,2),(2,1),(3,0)} := by decide
@@ -19,18 +26,23 @@
   have hanti5 : Finset.antidiagonal 5 = {(0,5),(1,4),(2,3),(3,2),(4,1),(5,0)} := by decide
   have hd : x-y ≠ 0 := sub_ne_zero.mpr hxy
   have hd' : y-x ≠ 0 := sub_ne_zero.mpr hxy.symm
-  fin_cases i <;> fin_cases j
+  have hi : i = 0 ∨ i = 1 ∨ i = 2 := by omega
+  have hj : j = 0 ∨ j = 1 ∨ j = 2 := by omega
+  rcases hi with rfl | rfl | rfl <;> rcases hj with rfl | rfl | rfl
   all_goals
     unfold finiteUnequalClearedEntry
-    simp only [finiteUnequalOtherPoles_zero x y 5 4 (by decide) (by decide),
-      finiteUnequalOtherPoles_one x y 5 4 (by decide) (by decide),
-      finiteUnequalOtherPoles_two x y 5 4 (by decide) (by decide),
-      bennettTwoNodes_zero,bennettTwoNodes_one,bennettTwoNodes_two]
-    rw [bennettClearedTaylor_two_poles_scaled_eval]
-    norm_num [hanti1,hanti2,hanti3,hanti4,hanti5,Finset.antidiagonal_zero,
+    first
+    | rw [finiteUnequalOtherPoles_zero x y 5 4 (by decide) (by decide),
+        bennettTwoNodes_zero, bennettClearedTaylor_two_poles_scaled_eval]
+    | rw [finiteUnequalOtherPoles_one x y 5 4 (by decide) (by decide),
+        bennettTwoNodes_one, bennettClearedTaylor_two_poles_scaled_eval]
+    | rw [finiteUnequalOtherPoles_two x y 5 4 (by decide) (by decide),
+        bennettTwoNodes_two, bennettClearedTaylor_two_poles_scaled_eval]
+    norm_num [hfin01,hfin02,hfin10,hfin12,hfin20,hfin21,hanti0,hanti1,hanti2,hanti3,hanti4,hanti5,
       finiteUnequalOrders,Ring.choose_zero_right,Ring.choose_one_right,
       finiteA_choose_two,finiteA_choose_three,finiteA_choose_four,finiteA_choose_five,
       finiteA5RowFactor,finiteA5Matrix,finiteA5DividedMatrix,Matrix.mul_diagonal,
+      Matrix.cons_val_two,Matrix.head_cons,Matrix.tail_cons,
       finiteA5Constant,finiteA5Left,finiteA5Right]
     field_simp [hx,hy,hd,hd']
     <;> ring
--- FiniteA5Residual.before
+++ FiniteA5Residual.after
@@ -58,7 +58,7 @@
     have hm := mul_lt_mul_of_pos_left heta (mul_pos hbase (by norm_num : (0 : ℝ) < 495/33554432))
     convert hm using 1 <;> ring
   rw [← finiteA5_residual_sum_identity x y c hx hy hxy i,norm_mul,norm_mul] at hbound
-  norm_num only [norm_ofNat] at hbound
+  norm_num only [Complex.norm_ofNat] at hbound
   exact (lt_div_iff₀ (by positivity)).mpr (by nlinarith only [hbound])
 
 private theorem finiteA5_rowfactor_scalar (X Y delta r : ℝ)
--- FiniteA5Approximation.before
+++ FiniteA5Approximation.after
@@ -63,8 +63,9 @@
           ‖z‖*(‖(x*L)*(sX/(x*z)-θX)‖+‖(y*R)*(sY/(y*z)-θY)‖) := by
         gcongr
         exact norm_add_le _ _
-      _ = _ := by rw [norm_mul,norm_mul,norm_sub_rev (sX/(x*z)),
-          norm_sub_rev (sY/(y*z))]
+      _ = _ := by
+        simp only [norm_mul, norm_sub_rev (sX/(x*z)) θX,
+          norm_sub_rev (sY/(y*z)) θY]
   have herrors :
       ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*R‖*‖θY-sY/(y*z)‖) ≤
         (‖c‖/‖z‖)*((101/100 : ℝ)*(‖L‖+‖R‖)) := by
@@ -83,13 +84,19 @@
       ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*R‖*‖θY-sY/(y*z)‖) <
         3113013*‖y‖^12*‖c‖^6/‖z‖ := by
     apply herrors.trans_lt
-    have hm := mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
-    convert hm using 1 <;> dsimp [L,R] <;> ring
+    calc
+      (‖c‖/‖z‖)*((101/100 : ℝ)*(‖L‖+‖R‖)) <
+          (‖c‖/‖z‖)*(3113013*‖y‖^12*‖c‖^5) :=
+        mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
+      _ = 3113013*‖y‖^12*‖c‖^6/‖z‖ := by ring
   have hres := mul_lt_mul_of_pos_left
     (finiteA5_residual_norm_lt x y c hx hy hc hxy hXY hXC i) hZ
   have hres' : ‖z‖*‖finiteA5Residual x y c i‖ <
       (495/64 : ℝ)*‖y‖^5*‖z‖/(‖x‖^6*‖c‖^9) := by
-    convert hres using 1 <;> ring
+    calc
+      ‖z‖*‖finiteA5Residual x y c i‖ <
+          ‖z‖*((495/64 : ℝ)*‖y‖^5/(‖x‖^6*‖c‖^9)) := hres
+      _ = (495/64 : ℝ)*‖y‖^5*‖z‖/(‖x‖^6*‖c‖^9) := by ring
   exact hnorm.trans_lt (by linarith only [herr,hres'])
 
 /-- The actual A5 inequality for arbitrary full imaginary quadratic
```
