# P height proof repairs

2026-10-20T03:20:41.949398+02:00

Actual compiler errors showed unreduced third vector coordinates, rewriting the exponent split inside its own right side, and the invalid adjacent ASCII tokens |*. Add file-local coordinate simp lemmas, factor powers with reverse rewrites, and separate the absolute-value closing bar from multiplication by one space. The lexical repair restores the intended product by the common height, already required by the following theorem and the manuscript. Raw original source is preserved; exact-statement audit examples normalize only this lexical separator in FinitePHeight. No coefficient, exponent, mathematical hypothesis or resource setting changes.

```diff
--- before
+++ after
@@ -8,6 +8,8 @@
 open Finset
 
 namespace D1Bound5
+
+attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three
 
 /-- Integer coefficient and the three anchor exponents. -/
 abbrev FinitePTerm := ℤ × ℕ × ℕ × ℕ
@@ -68,7 +70,7 @@
     · have hsplit : i+j = 3+(i+j-3) := by omega
       have hsmall : i+j-3+l ≤ 2 := by omega
       calc
-        B^(i+j)*S^l = B^3*(B^(i+j-3)*S^l) := by rw [hsplit, pow_add]; ring
+        B^(i+j)*S^l = B^3*(B^(i+j-3)*S^l) := by rw [← mul_assoc, ← pow_add, ← hsplit]
         _ ≤ B^3*(S^(i+j-3)*S^l) := by gcongr
         _ = B^3*S^(i+j-3+l) := by rw [pow_add]
         _ ≤ B^3*S^2 := by gcongr
@@ -81,7 +83,7 @@
     (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
     (i : Fin 4) (l j t : Fin 3) :
     ‖finitePTermValue (finitePRootTerms i l j t) a b s‖ ≤
-      |((finitePRootTerms i l j t).1 : ℝ)|*
+      |((finitePRootTerms i l j t).1 : ℝ)| *
         max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2) := by
   let u := finitePRootTerms i l j t
   have hm := finiteP_monomial_le ‖a‖ ‖b‖ ‖s‖ hA hAB hBS
```
