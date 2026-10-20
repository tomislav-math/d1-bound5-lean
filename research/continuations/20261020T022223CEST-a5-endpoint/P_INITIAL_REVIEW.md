# P-family source review and narrow proof repairs

2026-10-20T02:25:52.220026+02:00

Read all twelve actual P-family sources and the final all-large application. Preserve the manuscript four rows, determinant factor, coefficient2400, residual3, and closed endpoints. Applied only the already diagnosed map_ofNat, Complex.norm_ofNat and additive-congruence normalizations. These files are outside the entire active A5 protected closure. No compiler, new axiom, budget or parameter change. P is uncompiled and unverified at this stage.

```diff
--- FinitePIntegralRows.before
+++ FinitePIntegralRows.after
@@ -22,7 +22,7 @@
 @[simp] theorem map_finitePLeadingFactor {R S : Type*} [CommRing R] [CommRing S]
     (f : R →+* S) (a b s : R) :
     f (finitePLeadingFactor a b s) = finitePLeadingFactor (f a) (f b) (f s) := by
-  simp [finitePLeadingFactor]
+  simp [finitePLeadingFactor, map_ofNat]
 
 @[simp] theorem map_finitePDividedMatrix {R S : Type*} [CommRing R] [CommRing S]
     (f : R →+* S) (a b s c : R) (i j : Fin 4) :
@@ -31,14 +31,14 @@
   fin_cases i <;> fin_cases j <;>
     simp [finitePDividedMatrix,finitePRConstant,finitePTConstant,
       finitePRLeft,finitePRRight,finitePTLeft,finitePTRight,finitePairQuadratic,
-      finitePRLeftCoeff,finitePRRightCoeff,finitePTLeftCoeff,finitePTRightCoeff]
+      finitePRLeftCoeff,finitePRRightCoeff,finitePTLeftCoeff,finitePTRightCoeff, map_ofNat]
 
 private theorem finitePLinearFactor_norm_le (a b s : ℂ)
     (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖) :
     ‖finitePLinearFactor a b s‖ ≤ 4*‖s‖ := by
   calc
     _ ≤ ‖2*s-a‖+‖b‖ := norm_sub_le _ _
-    _ ≤ (‖2*s‖+‖a‖)+‖b‖ := add_le_add_right (norm_sub_le _ _) _
+    _ ≤ (‖2*s‖+‖a‖)+‖b‖ := add_le_add (norm_sub_le _ _) le_rfl
     _ = 2*‖s‖+‖a‖+‖b‖ := by norm_num [norm_mul]
     _ ≤ _ := by linarith only [hAB,hBS]
 
@@ -92,7 +92,7 @@
         -(7*finitePLinearFactor (f a) (f b) (f s)) := by
       linear_combination hfactor
     have hnorm := congrArg norm heq
-    norm_num only [norm_mul,norm_neg,norm_ofNat] at hnorm
+    norm_num only [norm_mul,norm_neg,Complex.norm_ofNat] at hnorm
     have ht := finitePLinearFactor_norm_le (f a) (f b) (f s) hAB hBS
     have hmul := mul_le_mul_of_nonneg_left hW1 (show 0 ≤ 6*‖f c‖ by positivity)
     nlinarith only [hnorm,ht,hmul,hC,hS]
--- FinitePLeadingBound.before
+++ FinitePLeadingBound.after
@@ -73,7 +73,7 @@
         mul_le_mul_of_nonneg_left hm (abs_nonneg (u.1 : ℝ))
   rw [finitePLeading_eq_terms a b s (norm_pos_iff.mp hapos)
     (norm_pos_iff.mp hbpos) (norm_pos_iff.mp hspos) i, norm_div]
-  norm_num only [norm_ofNat]
+  norm_num only [Complex.norm_ofNat]
   calc
     _ ≤ (∑ t, |((finitePLeadingTerms i t).1 : ℝ)|*(‖s‖^2/‖a‖^3))/256 := by
       gcongr
```
