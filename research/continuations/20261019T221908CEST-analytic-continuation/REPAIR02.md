# Repair 02

2026-10-19T22:24:49.297504+02:00

The first repaired build reached all nine entry identities but left Fin3 inequality tests unreduced inside exponents. Add six explicit finite inequality proofs to the simplifier before denominator clearing. No theorem statement, matrix coefficient or normalization changed.

```diff
--- attempt01
+++ attempt02
@@ -23,6 +23,12 @@
     (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
     bennettTwoClearedEntry x y c 2 i j =
       2 * finiteN2RowFactor x y i * finiteN2Matrix x y c i j := by
+  have hfin01 : (0 : Fin 3) ≠ 1 := by decide
+  have hfin02 : (0 : Fin 3) ≠ 2 := by decide
+  have hfin10 : (1 : Fin 3) ≠ 0 := by decide
+  have hfin12 : (1 : Fin 3) ≠ 2 := by decide
+  have hfin20 : (2 : Fin 3) ≠ 0 := by decide
+  have hfin21 : (2 : Fin 3) ≠ 1 := by decide
   have hanti0 : Finset.antidiagonal 0 = {(0,0)} := by decide
   have hanti1 : Finset.antidiagonal 1 = {(0,1),(1,0)} := by decide
   have hanti2 : Finset.antidiagonal 2 = {(0,2),(1,1),(2,0)} := by decide
@@ -40,7 +46,7 @@
         bennettClearedTaylor_two_poles_scaled_eval]
     | rw [bennettTwoOtherPoles_two, bennettTwoNodes_two,
         bennettClearedTaylor_two_poles_scaled_eval]
-    norm_num [hanti1, hanti2, hanti0,
+    norm_num [hfin01, hfin02, hfin10, hfin12, hfin20, hfin21, hanti1, hanti2, hanti0,
       Ring.choose_zero_right, Ring.choose_one_right, finite_choose_two,
       finiteN2RowFactor, finiteN2Matrix, finiteN2DividedMatrix,
       Matrix.mul_diagonal, finiteN2Constant, finiteN2Left, finiteN2Right]
```
