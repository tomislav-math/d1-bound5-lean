# Repair 03

2026-10-19T21:40:32.525343+02:00

After the correct inequality addition, the old convert tactic created a reflexive subgoal with no U or V, so the mandatory dsimp failed with made no progress. Replaced that tactic sequence by an explicit calc equality. This is the same elementary rational identity and no theorem header changed. Prior owner batch46984 exited1 and was collected before this repair.

```diff
--- OrdinaryClosedIntervals.attempt01
+++ OrdinaryClosedIntervals.attempt02
@@ -91,7 +91,11 @@
   let V := 1/(2*R^k)
   have hform' : 1 < U/Z+V*Z := by
     have hh := hform.trans_le (add_le_add le_rfl hres)
-    convert hh using 1 <;> dsimp [U,V] <;> ring
+    calc
+      1 < 3*C*H^k/(B*Z)+Z/(2*R^k) := hh
+      _ = U/Z+V*Z := by
+        dsimp only [U,V]
+        ring
   have hzC : (f z)^2=f (t 2)*f (t 3)+1 := by
     simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz'
   obtain ⟨hrootlo,hroothi⟩ := finite_tuple_root_relative_norm
```
