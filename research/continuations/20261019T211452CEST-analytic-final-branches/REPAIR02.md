# Repair 02

2026-10-19T21:38:57.978090+02:00

Actual Lean error at CoherentRetainedBasicGap line72: invalid by tactic, expected type not provided. Normalize the already typed inequality h before applying transitivity, instead of using an untyped tactic term as the method receiver. All original mathematical assumptions and conclusions are unchanged. The module was not in the active OrdinaryClosedIntervals protected closure.

```diff
--- CoherentRetainedBasicGap.attempt01
+++ CoherentRetainedBasicGap.attempt02
@@ -69,7 +69,8 @@
     hA hAB hBS hfrontier hproduct
   have hbase : 0 < A^2*P^5/S^2 := by positivity
   have h := mul_lt_mul_of_pos_right hc hbase
-  exact (by simpa only [one_mul] using h).trans hret
+  simp only [one_mul] at h
+  exact h.trans hret
 
 /-- The first retained power gap needs only an actual ordered quintuple
 whose smallest modulus is at least three. -/
```
