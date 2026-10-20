# Full-ring norm normalization

2026-10-20T09:21:31.424021+02:00

The actual full-ring compilation failed at three scalar inequalities because phi on a field coercion and the explicitly composed integer-ring homomorphism remained distinct arithmetic atoms. Normalize the original size/order hypotheses with change before invoking linarith, including the norm lower bound for the third anchor. Apply the same definitional normalization to the immediately following interval proof. No mathematical hypothesis, public type, embedding or constant is changed.

```diff
--- FinitePFullRing.lean.before
+++ FinitePFullRing.lean.after
@@ -26,6 +26,10 @@
         3*‖phi (a 2 : K)‖^2*‖phi (z : K)‖/
           (‖phi (a 0 : K)‖^3*‖phi (c : K)‖^5) := by
   let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
+  change Monotone (fun j => ‖f (a j)‖) at hmon
+  change 200*‖f (a 2)‖ ≤ ‖f c‖ at hCT
+  change ‖f c‖ ≤ ‖f d‖ at hCD
+  change 1000 ≤ ‖f (a 0)‖*‖f c‖ at hAC
   have hf : Function.Injective f := by
     intro x y hxy
     apply NumberField.RingOfIntegers.ext
@@ -81,6 +85,7 @@
     fin_cases j <;> rfl
   have hC200 : 200 ≤ ‖f c‖ := by
     have hT1 := one_le_norm_integer hK phi (hS.1 _ (haS 2))
+    change 1 ≤ ‖f (a 2)‖ at hT1
     linarith only [hT1,hCT]
   have hbound := finitePRowForm_norm_lt (f (a 0)) (f (a 1)) (f (a 2)) (f c) (f z)
     (f (sigma 0)) (f (sigma 1)) (f (sigma 2)) (ha0 0) (ha0 1) (ha0 2) hz0
--- FinitePInterval.lean.before
+++ FinitePInterval.lean.after
@@ -32,13 +32,16 @@
   let C := ‖f c‖
   let D := ‖f d‖
   let H := max (B*T^3) (B^3*T^2)
+  change 200*T ≤ C at hCT
+  change C ≤ D at hCD
+  change 1000 ≤ A*C at hAC
   have hn (j : Fin 3) : 1 ≤ ‖f (a j)‖ := one_le_norm_integer hK phi (hS.1 _ (haS j))
   have hA : 0 < A := by have hh := hn 0; linarith only [hh]
   have hB : 0 < B := by have hh := hn 1; linarith only [hh]
   have hT : 0 < T := by have hh := hn 2; linarith only [hh]
-  have hC : 0 < C := by change 0 < ‖phi (c : K)‖; linarith only [hCT,hT]
+  have hC : 0 < C := by linarith only [hCT,hT]
   have hAT : A ≤ T := hmon (by decide)
-  have hAD : 4*A ≤ D := by change 4*A ≤ ‖phi (d : K)‖; linarith only [hAT,hCT,hCD,hT]
+  have hAD : 4*A ≤ D := by linarith only [hAT,hCT,hCD,hT]
   have hCD4000 : 4000 ≤ C*D := by
     have hh := mul_le_mul_of_nonneg_left hAD hC.le
     nlinarith only [hh,hAC]
```
