# Tail degree cancellation

2026-10-20T09:13:38.634814+02:00

The first P tail build left only cancellation of norm(c)^ell against inverse powers, with ell in Fin3. Split exactly those three degree cases at the final equality and provide the explicit nonzero norm. No source coefficients, hypotheses, theorem types or budgets changed.

```diff
--- before
+++ after
@@ -49,10 +49,9 @@
         C^(l : ℕ)*((21/1024 : ℝ)*(1/(U*C))^(6+(l : ℕ))*(1000/999)) := by
       gcongr
     _ = _ := by
-      simp only [pow_add,mul_pow,div_pow,one_pow]
-      dsimp [C]
-      field_simp [hA.ne',hU.ne',hC.ne']
-      <;> ring
+      have hcn : ‖c‖ ≠ 0 := hC.ne'
+      fin_cases l <;> norm_num [C] <;>
+        field_simp [hA.ne', hU.ne', hcn] <;> ring
 
 /-- Actual Taylor tails for the two pair-row types, with the exact finite
 absolute-coefficient totals876 and2676. -/
```
