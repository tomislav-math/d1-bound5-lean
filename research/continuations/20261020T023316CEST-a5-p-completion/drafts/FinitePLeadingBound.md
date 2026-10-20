# Prepared proof-only normalization

Use direct finite-case proofs for the three lower and upper anchor bounds; avoid a simplifier closing some branches before the subsequent explicit proofs.

Not applied or compiled. Original theorem headers and definitions are unchanged.

```diff
--- FinitePLeadingBound.before
+++ FinitePLeadingBound.draft
@@ -51,12 +51,12 @@
   have hbpos : 0 < ‖b‖ := hapos.trans_le hAB
   have hspos : 0 < ‖s‖ := hbpos.trans_le hBS
   have hlow (j : Fin 3) : ‖a‖ ≤ ‖![a,b,s] j‖ := by
-    fin_cases j <;> simp only [Matrix.cons_val_zero,Matrix.cons_val_succ,Matrix.head_cons]
+    fin_cases j
     · exact le_rfl
     · exact hAB
     · exact hAB.trans hBS
   have hupp (j : Fin 3) : ‖![a,b,s] j‖ ≤ ‖s‖ := by
-    fin_cases j <;> simp only [Matrix.cons_val_zero,Matrix.cons_val_succ,Matrix.head_cons]
+    fin_cases j
     · exact hAB.trans hBS
     · exact hBS
     · exact le_rfl
```
