# Prepared proof repairs

2026-10-20T01:24:17.159712+02:00

Apply the already verified A3 normalization pattern to the current A4 proofs: explicit vector coordinates, numeral transport, literal finite-index cases, complex numeral norm, and explicit polynomial scaling. These are reviewed proof-only changes. The A4 parameters k=4,m=3,g=2, all coefficients, public headers and constants are unchanged. No trial has compiled yet.

```diff
--- FiniteA4Coefficients.before
+++ FiniteA4Coefficients.after
@@ -28,7 +28,7 @@
   fin_cases i <;> fin_cases j
   all_goals
     norm_num [finiteA4Left,finiteA4Right,finiteA4RootCoeff,
-      finiteA4Coeff0,finiteA4Coeff1,finiteA4Coeff2,finiteA4Coeff3,finiteA4Coeff4,finiteHomogeneousTwo,Fin.sum_univ_succ]
+      finiteA4Coeff0,finiteA4Coeff1,finiteA4Coeff2,finiteA4Coeff3,finiteA4Coeff4,finiteHomogeneousTwo,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons]
     <;> ring
 
 def finiteA4CoefficientSums : Fin 3 → Fin 5 → ℤ :=
@@ -37,26 +37,26 @@
 theorem finiteA4_coefficient_sums_0 (i : Fin 3) :
     (∑ r, |(finiteA4Coeff0 i 0 r : ℝ)|)+
       (∑ r, |(finiteA4Coeff0 i 1 r : ℝ)|) = finiteA4CoefficientSums i 0 := by
-  fin_cases i <;> norm_num [finiteA4Coeff0,finiteA4CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA4Coeff0,finiteA4CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons]
 
 theorem finiteA4_coefficient_sums_1 (i : Fin 3) :
     (∑ r, |(finiteA4Coeff1 i 0 r : ℝ)|)+
       (∑ r, |(finiteA4Coeff1 i 1 r : ℝ)|) = finiteA4CoefficientSums i 1 := by
-  fin_cases i <;> norm_num [finiteA4Coeff1,finiteA4CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA4Coeff1,finiteA4CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons]
 
 theorem finiteA4_coefficient_sums_2 (i : Fin 3) :
     (∑ r, |(finiteA4Coeff2 i 0 r : ℝ)|)+
       (∑ r, |(finiteA4Coeff2 i 1 r : ℝ)|) = finiteA4CoefficientSums i 2 := by
-  fin_cases i <;> norm_num [finiteA4Coeff2,finiteA4CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA4Coeff2,finiteA4CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons]
 
 theorem finiteA4_coefficient_sums_3 (i : Fin 3) :
     (∑ r, |(finiteA4Coeff3 i 0 r : ℝ)|)+
       (∑ r, |(finiteA4Coeff3 i 1 r : ℝ)|) = finiteA4CoefficientSums i 3 := by
-  fin_cases i <;> norm_num [finiteA4Coeff3,finiteA4CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA4Coeff3,finiteA4CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons]
 
 theorem finiteA4_coefficient_sums_4 (i : Fin 3) :
     (∑ r, |(finiteA4Coeff4 i 0 r : ℝ)|)+
       (∑ r, |(finiteA4Coeff4 i 1 r : ℝ)|) = finiteA4CoefficientSums i 4 := by
-  fin_cases i <;> norm_num [finiteA4Coeff4,finiteA4CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA4Coeff4,finiteA4CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons]
 
 end D1Bound5
--- FiniteA4IntegralRows.before
+++ FiniteA4IntegralRows.after
@@ -10,15 +10,15 @@
 
 @[simp] theorem map_finiteA4Constant (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteA4Constant x y c i) = finiteA4Constant (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteA4Constant]
+  fin_cases i <;> simp [finiteA4Constant, map_ofNat]
 
 @[simp] theorem map_finiteA4Left (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteA4Left x y c i) = finiteA4Left (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteA4Left]
+  fin_cases i <;> simp [finiteA4Left, map_ofNat]
 
 @[simp] theorem map_finiteA4Right (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteA4Right x y c i) = finiteA4Right (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteA4Right]
+  fin_cases i <;> simp [finiteA4Right, map_ofNat]
 
 @[simp] theorem map_finiteA4DividedMatrix (f : R →+* S)
     (x y c : R) (i j : Fin 3) :
--- FiniteA4Height.before
+++ FiniteA4Height.after
@@ -13,31 +13,31 @@
       (finiteHomogeneousTwo_norm_le 5 (finiteA4Coeff0 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 5 (finiteA4Coeff0 i 1) x y hxy)
     rw [← add_mul,finiteA4_coefficient_sums_0] at hh
-    simpa [finiteA4RootCoeff] using hh
+    simpa [finiteA4RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 6 (finiteA4Coeff1 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 6 (finiteA4Coeff1 i 1) x y hxy)
     rw [← add_mul,finiteA4_coefficient_sums_1] at hh
-    simpa [finiteA4RootCoeff] using hh
+    simpa [finiteA4RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 7 (finiteA4Coeff2 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 7 (finiteA4Coeff2 i 1) x y hxy)
     rw [← add_mul,finiteA4_coefficient_sums_2] at hh
-    simpa [finiteA4RootCoeff] using hh
+    simpa [finiteA4RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 8 (finiteA4Coeff3 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 8 (finiteA4Coeff3 i 1) x y hxy)
     rw [← add_mul,finiteA4_coefficient_sums_3] at hh
-    simpa [finiteA4RootCoeff] using hh
+    simpa [finiteA4RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 9 (finiteA4Coeff4 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 9 (finiteA4Coeff4 i 1) x y hxy)
     rw [← add_mul,finiteA4_coefficient_sums_4] at hh
-    simpa [finiteA4RootCoeff] using hh
+    simpa [finiteA4RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons] using hh
 
 theorem finiteA4_coefficient_sums_nonneg (i : Fin 3) (ell : Fin 5) :
     0 ≤ (finiteA4CoefficientSums i ell : ℝ) := by
-  fin_cases i <;> fin_cases ell <;> norm_num [finiteA4CoefficientSums]
+  fin_cases i <;> fin_cases ell <;> norm_num [finiteA4CoefficientSums, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons]
 
 /-- Exact rational row checks preserve the manuscript's sharp M=165763. -/
 theorem finiteA4_height_slack (i : Fin 3) :
@@ -72,7 +72,13 @@
   have heq : (101/100 : ℝ)*(‖y‖^5*∑ ell : Fin 5,
       (finiteA4CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) <
       165763*‖y‖^9*‖c‖^4 := by
-    convert hm using 1 <;> ring
+    calc
+      (101/100 : ℝ)*(‖y‖^5*∑ ell : Fin 5,
+          (finiteA4CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) =
+          ‖y‖^5*((101/100 : ℝ)*(∑ ell : Fin 5,
+            (finiteA4CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ))) := by ring
+      _ < ‖y‖^5*(165763*(‖y‖*‖c‖)^4) := hm
+      _ = 165763*‖y‖^9*‖c‖^4 := by ring
   exact hnorm.trans_lt heq
 
 end D1Bound5
--- FiniteA4ResidueIdentity.before
+++ FiniteA4ResidueIdentity.after
@@ -12,24 +12,36 @@
     (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
     finiteUnequalClearedEntry x y c 4 3 i j =
       2*finiteA4RowFactor x y i*finiteA4Matrix x y c i j := by
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
   have hanti4 : Finset.antidiagonal 4 = {(0,4),(1,3),(2,2),(3,1),(4,0)} := by decide
   have hd : x-y ≠ 0 := sub_ne_zero.mpr hxy
   have hd' : y-x ≠ 0 := sub_ne_zero.mpr hxy.symm
-  fin_cases i <;> fin_cases j
+  have hi : i = 0 ∨ i = 1 ∨ i = 2 := by omega
+  have hj : j = 0 ∨ j = 1 ∨ j = 2 := by omega
+  rcases hi with rfl | rfl | rfl <;> rcases hj with rfl | rfl | rfl
   all_goals
     unfold finiteUnequalClearedEntry
-    simp only [finiteUnequalOtherPoles_zero x y 4 3 (by decide) (by decide),
-      finiteUnequalOtherPoles_one x y 4 3 (by decide) (by decide),
-      finiteUnequalOtherPoles_two x y 4 3 (by decide) (by decide),
-      bennettTwoNodes_zero,bennettTwoNodes_one,bennettTwoNodes_two]
-    rw [bennettClearedTaylor_two_poles_scaled_eval]
-    norm_num [hanti1,hanti2,hanti3,hanti4,Finset.antidiagonal_zero,
+    first
+    | rw [finiteUnequalOtherPoles_zero x y 4 3 (by decide) (by decide),
+        bennettTwoNodes_zero, bennettClearedTaylor_two_poles_scaled_eval]
+    | rw [finiteUnequalOtherPoles_one x y 4 3 (by decide) (by decide),
+        bennettTwoNodes_one, bennettClearedTaylor_two_poles_scaled_eval]
+    | rw [finiteUnequalOtherPoles_two x y 4 3 (by decide) (by decide),
+        bennettTwoNodes_two, bennettClearedTaylor_two_poles_scaled_eval]
+    norm_num [hfin01,hfin02,hfin10,hfin12,hfin20,hfin21,hanti0,hanti1,hanti2,hanti3,hanti4,
       finiteUnequalOrders,Ring.choose_zero_right,Ring.choose_one_right,
       finiteA_choose_two,finiteA_choose_three,finiteA_choose_four,finiteA_choose_five,
       finiteA4RowFactor,finiteA4Matrix,finiteA4DividedMatrix,Matrix.mul_diagonal,
+      Matrix.cons_val_two,Matrix.head_cons,Matrix.tail_cons,
       finiteA4Constant,finiteA4Left,finiteA4Right]
     field_simp [hx,hy,hd,hd']
     <;> ring
--- FiniteA4Residual.before
+++ FiniteA4Residual.after
@@ -58,7 +58,7 @@
     have hm := mul_lt_mul_of_pos_left heta (mul_pos hbase (by norm_num : (0 : ℝ) < 63/524288))
     convert hm using 1 <;> ring
   rw [← finiteA4_residual_sum_identity x y c hx hy hxy i,norm_mul,norm_mul] at hbound
-  norm_num only [norm_ofNat] at hbound
+  norm_num only [Complex.norm_ofNat] at hbound
   exact (lt_div_iff₀ (by positivity)).mpr (by nlinarith only [hbound])
 
 private theorem finiteA4_rowfactor_scalar (X Y delta r : ℝ)
--- FiniteA4Approximation.before
+++ FiniteA4Approximation.after
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
         165763*‖y‖^9*‖c‖^5/‖z‖ := by
     apply herrors.trans_lt
-    have hm := mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
-    convert hm using 1 <;> dsimp [L,R] <;> ring
+    calc
+      (‖c‖/‖z‖)*((101/100 : ℝ)*(‖L‖+‖R‖)) <
+          (‖c‖/‖z‖)*(165763*‖y‖^9*‖c‖^4) :=
+        mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
+      _ = 165763*‖y‖^9*‖c‖^5/‖z‖ := by ring
   have hres := mul_lt_mul_of_pos_left
     (finiteA4_residual_norm_lt x y c hx hy hc hxy hXY hXC i) hZ
   have hres' : ‖z‖*‖finiteA4Residual x y c i‖ <
       (63/8 : ℝ)*‖y‖^4*‖z‖/(‖x‖^5*‖c‖^7) := by
-    convert hres using 1 <;> ring
+    calc
+      ‖z‖*‖finiteA4Residual x y c i‖ <
+          ‖z‖*((63/8 : ℝ)*‖y‖^4/(‖x‖^5*‖c‖^7)) := hres
+      _ = (63/8 : ℝ)*‖y‖^4*‖z‖/(‖x‖^5*‖c‖^7) := by ring
   exact hnorm.trans_lt (by linarith only [herr,hres'])
 
 /-- The actual A4 inequality for arbitrary full imaginary quadratic
```
