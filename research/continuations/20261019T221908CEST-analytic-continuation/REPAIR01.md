# Repair 01

2026-10-19T22:20:05.870489+02:00

The exact prior compiler error was an unknown antidiagonal-zero lemma. Replace only that lookup by an explicit proof-producing zero-antidiagonal certificate. All public theorem headers and polynomial data are unchanged.

```diff
--- before
+++ current
@@ -23,6 +23,7 @@
     (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
     bennettTwoClearedEntry x y c 2 i j =
       2 * finiteN2RowFactor x y i * finiteN2Matrix x y c i j := by
+  have hanti0 : Finset.antidiagonal 0 = {(0,0)} := by decide
   have hanti1 : Finset.antidiagonal 1 = {(0,1),(1,0)} := by decide
   have hanti2 : Finset.antidiagonal 2 = {(0,2),(1,1),(2,0)} := by decide
   have hd : x-y ≠ 0 := sub_ne_zero.mpr hxy
@@ -39,7 +40,7 @@
         bennettClearedTaylor_two_poles_scaled_eval]
     | rw [bennettTwoOtherPoles_two, bennettTwoNodes_two,
         bennettClearedTaylor_two_poles_scaled_eval]
-    norm_num [hanti1, hanti2, Finset.antidiagonal_zero,
+    norm_num [hanti1, hanti2, hanti0,
       Ring.choose_zero_right, Ring.choose_one_right, finite_choose_two,
       finiteN2RowFactor, finiteN2Matrix, finiteN2DividedMatrix,
       Matrix.mul_diagonal, finiteN2Constant, finiteN2Left, finiteN2Right]
```
