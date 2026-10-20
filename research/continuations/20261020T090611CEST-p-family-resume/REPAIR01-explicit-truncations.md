# Exact finite Taylor truncation repair

2026-10-20T09:07:44.190012+02:00

The latest failed proof left sums over range6, range7 and range8 unexpanded after normalization. Prove their three exact generic expansions using explicitly instantiated sum_range_succ equalities and apply these before the algebraic cancellation. This changes only proof terms, not the remainder, coefficients, public signatures, assumptions, or budgets. No retry of an unchanged failed source.

```diff
--- before
+++ after
@@ -83,6 +83,21 @@
 noncomputable def finitePLeadingT (u v : ℂ) : ℂ :=
   -75/(128*u)+5*v/(16*u^2)-15*v^2/(256*u^3)-35*u/(256*v^2)+15/(32*v)
 
+private theorem finiteP_sum_six (f : ℕ → ℂ) :
+    (∑ m ∈ Finset.range 6, f m) = f 0+f 1+f 2+f 3+f 4+f 5 := by
+  rw [Finset.sum_range_succ f 5, Finset.sum_range_succ f 4,
+    Finset.sum_range_succ f 3, Finset.sum_range_succ f 2,
+    Finset.sum_range_succ f 1, Finset.sum_range_succ f 0]
+  simp only [Finset.sum_range_zero, zero_add]
+
+private theorem finiteP_sum_seven (f : ℕ → ℂ) :
+    (∑ m ∈ Finset.range 7, f m) = f 0+f 1+f 2+f 3+f 4+f 5+f 6 := by
+  rw [Finset.sum_range_succ f 6, finiteP_sum_six]
+
+private theorem finiteP_sum_eight (f : ℕ → ℂ) :
+    (∑ m ∈ Finset.range 8, f m) = f 0+f 1+f 2+f 3+f 4+f 5+f 6+f 7 := by
+  rw [Finset.sum_range_succ f 7, finiteP_sum_seven]
+
 set_option maxHeartbeats 2000000 in
 /-- The actual pair rows cancel every coefficient through c^-4. -/
 theorem finitePPairResidual_eq_leading_tail (u v c : ℂ)
@@ -99,9 +114,12 @@
     norm_num [finitePPairCoeff, finitePRConstant, finitePTConstant,
       finitePRLeftCoeff, finitePRRightCoeff, finitePTLeftCoeff, finitePTRightCoeff,
       finitePairQuadratic, finitePLeadingR, finitePLeadingT]
+    simp only [finiteP_sum_six, finiteP_sum_seven, finiteP_sum_eight,
+      h0,h1,h2,h3,h4,h5,h6,h7]
+    norm_num only [Complex.ofReal_one, Complex.ofReal_div, Complex.ofReal_neg,
+      Complex.ofReal_ofNat, pow_zero, pow_one, one_mul]
     apply sub_eq_zero.mp
     ring_nf
-    norm_num [Finset.sum_range_succ, Finset.sum_range_zero, h0,h1,h2,h3,h4,h5,h6,h7]
     all_goals field_simp [hu,hv,hc] <;> ring
 
 noncomputable def finitePResidual (a b s c : ℂ) (i : Fin 4) : ℂ :=
```
