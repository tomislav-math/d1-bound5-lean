# Repair 08

2026-10-19T23:11:26.047195+02:00

The N3 residual passed. Its approximation proof reported one norm-product rewrite targeting the wrong occurrence and two redundant conversion/simplification failures. Normalize all product norms simultaneously with the two explicitly oriented error differences. Replace the two conversion steps with explicit scalar calc equalities. No coefficient, hypothesis, public statement or integrality construction changed.

```diff
--- before
+++ after
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
         4143*‖y‖^7*‖c‖^4/‖z‖ := by
     apply herrors.trans_lt
-    have hm := mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
-    convert hm using 1 <;> dsimp [L,R] <;> ring
+    calc
+      (‖c‖/‖z‖)*((101/100 : ℝ)*(‖L‖+‖R‖)) <
+          (‖c‖/‖z‖)*(4143*‖y‖^7*‖c‖^3) :=
+        mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
+      _ = 4143*‖y‖^7*‖c‖^4/‖z‖ := by ring
   have hres := mul_lt_mul_of_pos_left
     (finiteN3_residual_norm_lt x y c hx hy hc hxy hXY hXC i) hZ
   have hres' : ‖z‖*‖finiteN3Residual x y c i‖ <
       (35/32 : ℝ)*‖y‖^3*‖z‖/(‖x‖^4*‖c‖^6) := by
-    convert hres using 1 <;> ring
+    calc
+      ‖z‖*‖finiteN3Residual x y c i‖ <
+          ‖z‖*((35/32 : ℝ)*‖y‖^3/(‖x‖^4*‖c‖^6)) := hres
+      _ = (35/32 : ℝ)*‖y‖^3*‖z‖/(‖x‖^4*‖c‖^6) := by ring
   exact hnorm.trans_lt (by linarith only [herr,hres'])
 
 /-- The actual N3 inequality for arbitrary full imaginary quadratic
```
