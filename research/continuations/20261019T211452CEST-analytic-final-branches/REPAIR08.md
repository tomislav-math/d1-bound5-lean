# Repair 08

2026-10-19T22:05:55.925580+02:00

The corrected import exposed a lexer error: adjacent absolute-value bar and star were read as token |*. Inserted whitespace at the two affected products. The quadratic norm proof used an addition lemma in the wrong orientation; replaced it with explicit add_le_add of the norm inequality and reflexivity. No polynomial, coefficient, exponent or public theorem header changed. The current IntegralRows compilation does not protect this source. The first preparation call48866 asserted an incorrect expected occurrence count3 and stopped before editing; inspection confirmed exactly2.

```diff
--- FiniteHomogeneousTwo.attempt02
+++ FiniteHomogeneousTwo.attempt03
@@ -21,7 +21,7 @@
   unfold finiteHomogeneousTwo
   calc
     _ ≤ ∑ j, ‖(v j : ℂ)*x^(j : ℕ)*y^(n-(j : ℕ))‖ := norm_sum_le _ _
-    _ ≤ ∑ j, |(v j : ℝ)|*‖y‖^n := by
+    _ ≤ ∑ j, |(v j : ℝ)| *‖y‖^n := by
       apply Finset.sum_le_sum
       intro j _
       have hj : (j : ℕ) ≤ n := by omega
@@ -29,7 +29,7 @@
       have hnorm : ‖(v j : ℂ)‖ = |(v j : ℝ)| := by simp
       rw [norm_mul, norm_mul, norm_pow, norm_pow, hnorm]
       calc
-        _ ≤ |(v j : ℝ)|*‖y‖^(j : ℕ)*‖y‖^(n-(j : ℕ)) := by gcongr
+        _ ≤ |(v j : ℝ)| *‖y‖^(j : ℕ)*‖y‖^(n-(j : ℕ)) := by gcongr
         _ = _ := by rw [mul_assoc, ← pow_add, hsum]
     _ = _ := by rw [Finset.sum_mul]
 
@@ -37,7 +37,7 @@
     ‖u+v*c+w*c^2‖ ≤ ‖u‖+‖v‖*‖c‖+‖w‖*‖c‖^2 := by
   calc
     _ ≤ ‖u+v*c‖+‖w*c^2‖ := norm_add_le _ _
-    _ ≤ (‖u‖+‖v*c‖)+‖w*c^2‖ := add_le_add_right (norm_add_le _ _) _
+    _ ≤ (‖u‖+‖v*c‖)+‖w*c^2‖ := add_le_add (norm_add_le _ _) le_rfl
     _ = _ := by rw [norm_mul, norm_mul, norm_pow]
 
 end D1Bound5
```
