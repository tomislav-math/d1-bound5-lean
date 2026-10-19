# Repair 04

2026-10-19T22:31:19.400424+02:00

All overlap algebra and inequalities elaborated except four redundant dsimp calls on already expanded goals. Removed exactly those four no-progress calls, retaining their bullet scopes. The preparation call51218 failed an over-restrictive line-prefix assertion before any source write; this corrected preparation recognizes the bullet prefix. Every original ratio, endpoint, hypothesis and the complete fifteen-part conclusion remain unchanged.

```diff
--- before
+++ after
@@ -301,7 +301,7 @@
     · exact hr1
   have ho2 : 4*2400^2*(B*S^3)^2*C^5/(1-1/4000 : ℝ) < (allLargeWindowN2 A B C).2 := by
     apply window_overlap_of_ratio (4*2400^2*(B*S^3)^2*C^5/(1-1/4000 : ℝ)) ((allLargeWindowN2 A B C).2) (A^6*C^2/((16*(5/4 : ℝ)^2*2400^2*(4001/3999 : ℝ))*B^6*S^6))
-    · dsimp [allLargeWindowQ,allLargeWindowN2,allLargeWindowP,allLargeWindowA3,allLargeWindowM,allLargeWindowN3,allLargeWindowA4,allLargeWindowA5,ordinaryWindowLower,ordinaryWindowUpper]
+    ·
       positivity
     · dsimp [allLargeWindowQ,allLargeWindowN2,allLargeWindowP,allLargeWindowA3,allLargeWindowM,allLargeWindowN3,allLargeWindowA4,allLargeWindowA5,ordinaryWindowLower,ordinaryWindowUpper]
       field_simp [hA0.ne',hB0.ne',hS0.ne',hT0.ne',hC0.ne']
@@ -309,7 +309,7 @@
     · exact hr2
   have ho3 : 4*2400^2*(B^3*S^2)^2*C^5/(1-1/4000 : ℝ) < (allLargeWindowN2 A B C).2 := by
     apply window_overlap_of_ratio (4*2400^2*(B^3*S^2)^2*C^5/(1-1/4000 : ℝ)) ((allLargeWindowN2 A B C).2) (A^6*C^2/((16*(5/4 : ℝ)^2*2400^2*(4001/3999 : ℝ))*B^10*S^4))
-    · dsimp [allLargeWindowQ,allLargeWindowN2,allLargeWindowP,allLargeWindowA3,allLargeWindowM,allLargeWindowN3,allLargeWindowA4,allLargeWindowA5,ordinaryWindowLower,ordinaryWindowUpper]
+    ·
       positivity
     · dsimp [allLargeWindowQ,allLargeWindowN2,allLargeWindowP,allLargeWindowA3,allLargeWindowM,allLargeWindowN3,allLargeWindowA4,allLargeWindowA5,ordinaryWindowLower,ordinaryWindowUpper]
       field_simp [hA0.ne',hB0.ne',hS0.ne',hT0.ne',hC0.ne']
@@ -405,9 +405,9 @@
     · exact hr14
   have ho15 : 42*B^3*C < 2*A*C^2/(5*B) := by
     apply window_overlap_of_ratio (42*B^3*C) (2*A*C^2/(5*B)) (A*C^1/((105)*B^4))
-    · dsimp [allLargeWindowQ,allLargeWindowN2,allLargeWindowP,allLargeWindowA3,allLargeWindowM,allLargeWindowN3,allLargeWindowA4,allLargeWindowA5,ordinaryWindowLower,ordinaryWindowUpper]
-      positivity
-    · dsimp [allLargeWindowQ,allLargeWindowN2,allLargeWindowP,allLargeWindowA3,allLargeWindowM,allLargeWindowN3,allLargeWindowA4,allLargeWindowA5,ordinaryWindowLower,ordinaryWindowUpper]
+    ·
+      positivity
+    ·
       field_simp [hA0.ne',hB0.ne',hS0.ne',hT0.ne',hC0.ne']
       <;> ring
     · exact hr15
```
