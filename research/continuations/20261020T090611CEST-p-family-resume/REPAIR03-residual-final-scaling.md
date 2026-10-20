# Explicit final residual scaling

2026-10-20T09:16:33.556695+02:00

The only compiler error in FinitePResidualBound was a no-progress ring normalization following convert. Replace it by the exact scalar equality combining35/16 and1/8 into37/16, the already proved strict comparison37/16<3, and the final denominator rearrangement. The original public theorem and all hypotheses are unchanged.

```diff
--- before
+++ after
@@ -30,6 +30,11 @@
     _ < 3*‖s‖^2/(‖a‖^3*‖c‖^5) := by
       have hp : 0 < ‖s‖^2/(‖a‖^3*‖c‖^5) := by positivity
       have hh := mul_lt_mul_of_pos_right (by norm_num : (37/16 : ℝ)<3) hp
-      convert hh using 1 <;> ring
+      calc
+        ((35/16 : ℝ)*‖s‖^2/‖a‖^3)/‖c‖^5+
+            (1/8 : ℝ)*‖s‖^2/(‖a‖^3*‖c‖^5) =
+            (37/16 : ℝ)*(‖s‖^2/(‖a‖^3*‖c‖^5)) := by ring
+        _ < 3*(‖s‖^2/(‖a‖^3*‖c‖^5)) := hh
+        _ = 3*‖s‖^2/(‖a‖^3*‖c‖^5) := by ring
 
 end D1Bound5
```
