# Explicit height scaling

2026-10-20T00:31:16.780963+02:00

The A3 height module proved all coefficient bounds and its exact rational slack, then failed only at the final convert/ring normalization. Replace that step by an explicit equality/inequality/equality calculation using the same already obtained strict scalar bound. The coefficient2265 and original public types are unchanged. The failed source is preserved in wave02; the repaired file is outside the active protected closure.

```diff
--- before
+++ after
@@ -67,7 +67,13 @@
   have heq : (101/100 : ℝ)*(‖y‖^3*∑ ell : Fin 4,
       (finiteA3CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) <
       2265*‖y‖^6*‖c‖^3 := by
-    convert hm using 1 <;> ring
+    calc
+      (101/100 : ℝ)*(‖y‖^3*∑ ell : Fin 4,
+          (finiteA3CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) =
+          ‖y‖^3*((101/100 : ℝ)*(∑ ell : Fin 4,
+            (finiteA3CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ))) := by ring
+      _ < ‖y‖^3*(2265*(‖y‖*‖c‖)^3) := hm
+      _ = 2265*‖y‖^6*‖c‖^3 := by ring
   exact hnorm.trans_lt heq
 
 end D1Bound5
```
