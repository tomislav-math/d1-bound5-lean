# Repair 05

2026-10-19T22:37:58.692804+02:00

The actual N3 height compiler error is an addition-side mismatch in the cubic triangle estimate. Replace the incorrectly oriented add_le_add_right with add_le_add and a reflexive right-hand summand. All coefficient vectors, sums, constants and public theorem headers are unchanged.

```diff
--- before
+++ after
@@ -32,7 +32,7 @@
   calc
     _ ≤ ‖u+v*c+w*c^2‖+‖t*c^3‖ := norm_add_le _ _
     _ ≤ (‖u‖+‖v‖*‖c‖+‖w‖*‖c‖^2)+‖t*c^3‖ :=
-      add_le_add_right (finite_norm_quadratic_le _ _ _ _) _
+      add_le_add (finite_norm_quadratic_le _ _ _ _) le_rfl
     _ = _ := by rw [norm_mul,norm_pow]
 
 /-- Exact coefficient vectors, checked against the actual N3 matrix. -/
```
