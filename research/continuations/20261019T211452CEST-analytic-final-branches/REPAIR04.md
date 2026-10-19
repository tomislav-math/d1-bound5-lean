# Repair 04

2026-10-19T21:50:06.463727+02:00

Actual CoherentRetainedStart errors were the syntactically distinct presentations of the same full-ring embedding in hA and of v at concrete indices in the zero-window bound. Explicitly change hA to the local abbreviation and assign the existing upper inequality its exact local scalar type, then use asymmetry of strict order. No hypothesis, constant or mathematical conclusion changed. The currently active independent compiler does not protect this source.

```diff
--- CoherentRetainedStart.attempt01
+++ CoherentRetainedStart.attempt02
@@ -39,6 +39,7 @@
   let T := ‖f (a 3)‖
   let C := ‖f (a 4)‖
   let D := ‖f (a 5)‖
+  change 3 ≤ A at hA
   let i4 : Fin 4 → Fin 6 := ![0,1,2,3]
   let i5 : Fin 5 → Fin 6 := ![0,1,2,3,4]
   let j5 : Fin 5 → Fin 6 := ![0,1,2,4,5]
@@ -96,8 +97,8 @@
     (by change 1 ≤ A; linarith only [hA]) hAB hBS hST hTC hC1000.le hterminal.1.le heta
   have hnonzero : L ≠ 0 := by
     intro hz
-    have hh := (hforms.2 hz).2
-    linarith only [hh,hterminal.2]
+    have hh : D < 17*A*B*S*T*C^3 := (hforms.2 hz).2
+    exact lt_asymm hh hterminal.2
   let Tup : Finset (𝓞 K) := Finset.univ.image a
   have hmem (i : Fin 6) : a i ∈ Tup :=
     Finset.mem_image.mpr ⟨i, Finset.mem_univ i, rfl⟩
```
