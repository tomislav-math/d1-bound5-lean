# P residual coordinate normalization

2026-10-20T03:23:27.507749+02:00

The actual residual-identity compilation reported the same invalid ASCII |* separator and unreduced third literal-vector coordinates. Add the standard file-local coordinate simp equations to that module and the remaining P coefficient/row calculations which use the same literal indices. Separate closing absolute bars from multiplication in proof bodies. No polynomial coefficient, public mathematical statement, hypothesis or resource limit changes. The previous bounded batch exited1, its terminal result was collected, and both existing locks are held.

```diff
--- FinitePResidualIdentity.before
+++ FinitePResidualIdentity.after
@@ -5,6 +5,8 @@
 open Finset
 
 namespace D1Bound5
+
+attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three
 
 theorem finiteP_half_coefficients :
     halfBinomialCoeff 5 = 7/256 ∧ halfBinomialCoeff 6 = -21/1024 ∧
@@ -45,7 +47,7 @@
       norm_num at h ⊢
       exact h
     calc
-      _ = |halfBinomialCoeff (j+n)|*‖z‖^(j+n) := by
+      _ = |halfBinomialCoeff (j+n)| *‖z‖^(j+n) := by
         rw [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs]
       _ ≤ (21/1024 : ℝ)*‖z‖^(j+n) :=
         mul_le_mul_of_nonneg_right hb (pow_nonneg (norm_nonneg z) _)
--- FinitePLeadingBound.before
+++ FinitePLeadingBound.after
@@ -4,6 +4,8 @@
 open Finset
 
 namespace D1Bound5
+
+attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three
 
 /-- Coefficient, denominator anchor, numerator anchor, numerator exponent,
 and denominator exponent; a common denominator256 is outside the sum. -/
@@ -62,7 +64,7 @@
     · exact le_rfl
   have hterm (t : Fin 12) :
       ‖finitePLeadingTermValue ![a,b,s] (finitePLeadingTerms i t)‖ ≤
-        |((finitePLeadingTerms i t).1 : ℝ)|*(‖s‖^2/‖a‖^3) := by
+        |((finitePLeadingTerms i t).1 : ℝ)| *(‖s‖^2/‖a‖^3) := by
     let u := finitePLeadingTerms i t
     obtain ⟨he,hn⟩ := finitePLeadingTerms_exponents i t
     have hm := finiteP_monomial_bound ‖a‖ ‖s‖ ‖![a,b,s] u.2.1‖ ‖![a,b,s] u.2.2.1‖
@@ -75,7 +77,7 @@
     (norm_pos_iff.mp hbpos) (norm_pos_iff.mp hspos) i, norm_div]
   norm_num only [Complex.norm_ofNat]
   calc
-    _ ≤ (∑ t, |((finitePLeadingTerms i t).1 : ℝ)|*(‖s‖^2/‖a‖^3))/256 := by
+    _ ≤ (∑ t, |((finitePLeadingTerms i t).1 : ℝ)| *(‖s‖^2/‖a‖^3))/256 := by
       gcongr
       exact (norm_sum_le _ _).trans (Finset.sum_le_sum fun t _ => hterm t)
     _ = (∑ t, |((finitePLeadingTerms i t).1 : ℝ)|)*(‖s‖^2/‖a‖^3)/256 := by
--- FinitePTailCoefficients.before
+++ FinitePTailCoefficients.after
@@ -2,6 +2,8 @@
 import D1Bound5.FinitePMonomial
 
 namespace D1Bound5
+
+attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three
 
 /-- Signed coefficient, power of the root anchor, power of the other
 anchor. Zero padding keeps each coefficient a sum over Fin3. -/
--- FinitePRowBound.before
+++ FinitePRowBound.after
@@ -4,6 +4,8 @@
 import D1Bound5.FiniteRowRootTransfer
 
 namespace D1Bound5
+
+attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three
 
 theorem finitePRowForm_eq_root_sum (a b s c z rA rB rS : ℂ) (i : Fin 4) :
     finitePRowForm a b s c z rA rB rS i =
```
