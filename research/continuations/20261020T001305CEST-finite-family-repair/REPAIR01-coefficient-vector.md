# Exact coefficient-vector repair

2026-10-20T00:15:27.045654+02:00

The prior compiler left only the evaluation of the third and fourth coordinates of Fin4 coefficient-sum vectors. Explicitly supply the pinned vector evaluation lemmas. Preserve every polynomial, coefficient, public theorem header and bound. The prior bounded batch59905 was collected with exit1; no competitor is running.

```diff
--- before
+++ after
@@ -44,11 +44,11 @@
 theorem finiteA3_coefficient_sums_2 (i : Fin 3) :
     (∑ r, |(finiteA3Coeff2 i 0 r : ℝ)|)+
       (∑ r, |(finiteA3Coeff2 i 1 r : ℝ)|) = finiteA3CoefficientSums i 2 := by
-  fin_cases i <;> norm_num [finiteA3Coeff2,finiteA3CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA3Coeff2,finiteA3CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons]
 
 theorem finiteA3_coefficient_sums_3 (i : Fin 3) :
     (∑ r, |(finiteA3Coeff3 i 0 r : ℝ)|)+
       (∑ r, |(finiteA3Coeff3 i 1 r : ℝ)|) = finiteA3CoefficientSums i 3 := by
-  fin_cases i <;> norm_num [finiteA3Coeff3,finiteA3CoefficientSums,Fin.sum_univ_succ]
+  fin_cases i <;> norm_num [finiteA3Coeff3,finiteA3CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons]
 
 end D1Bound5
```
