# Repair 01

2026-10-19T21:31:30.509025+02:00

Actual CoherentRetainedTuple error: productFive_growth retained four concrete Fin.castAdd indices. Added kernel-decided index equalities before product normalization, also at the identical application in CoherentRetainedBasicGap. Actual OrdinaryClosedIntervals error: an add_le_add_left application placed the residual on the wrong side of addition. Replaced it by add_le_add le_rfl hres. Public statements and constants are unchanged. Both project locks held; no active compiler.

An earlier preparation call (tool PID46639) stopped before editing on BlockingIOError: [Errno 35] Resource temporarily unavailable at the intake lock. This was ordinary concurrency protection, not a tool safety refusal. The owner batch PID46281 has now drained with exit1 and its result was collected.

```diff
--- CoherentRetainedTuple.before
+++ CoherentRetainedTuple.after
@@ -41,7 +41,11 @@
   have hproduct :
       3*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ <
         ‖phi (a 4 : K)‖ := by
-    simpa only [Fin.prod_univ_four, mul_assoc] using
+    have hc0 : Fin.castAdd 1 (0 : Fin 4) = (0 : Fin 5) := by decide
+    have hc1 : Fin.castAdd 1 (1 : Fin 4) = (1 : Fin 5) := by decide
+    have hc2 : Fin.castAdd 1 (2 : Fin 4) = (2 : Fin 5) := by decide
+    have hc3 : Fin.castAdd 1 (3 : Fin 4) = (3 : Fin 5) := by decide
+    simpa only [Fin.prod_univ_four, hc0, hc1, hc2, hc3, mul_assoc] using
       (IsD1Tuple.productFive_growth hK phi a ha hmon hB)
   let Tup : Finset (𝓞 K) := Finset.univ.image a
   have hmem (i : Fin 5) : a i ∈ Tup :=
--- CoherentRetainedBasicGap.before
+++ CoherentRetainedBasicGap.after
@@ -102,7 +102,11 @@
   have hproduct :
       3*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ <
         ‖phi (a 4 : K)‖ := by
-    simpa only [Fin.prod_univ_four, mul_assoc] using
+    have hc0 : Fin.castAdd 1 (0 : Fin 4) = (0 : Fin 5) := by decide
+    have hc1 : Fin.castAdd 1 (1 : Fin 4) = (1 : Fin 5) := by decide
+    have hc2 : Fin.castAdd 1 (2 : Fin 4) = (2 : Fin 5) := by decide
+    have hc3 : Fin.castAdd 1 (3 : Fin 4) = (3 : Fin 5) := by decide
+    simpa only [Fin.prod_univ_four, hc0, hc1, hc2, hc3, mul_assoc] using
       (IsD1Tuple.productFive_growth hK phi a ha hmon hB)
   let Tup : Finset (𝓞 K) := Finset.univ.image a
   have hmem (i : Fin 5) : a i ∈ Tup :=
--- OrdinaryClosedIntervals.before
+++ OrdinaryClosedIntervals.after
@@ -90,7 +90,7 @@
   let U := 3*C*H^k/B
   let V := 1/(2*R^k)
   have hform' : 1 < U/Z+V*Z := by
-    have hh := hform.trans_le (add_le_add_left hres _)
+    have hh := hform.trans_le (add_le_add le_rfl hres)
     convert hh using 1 <;> dsimp [U,V] <;> ring
   have hzC : (f z)^2=f (t 2)*f (t 3)+1 := by
     simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz'
```
