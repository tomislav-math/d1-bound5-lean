# Repair 06

2026-10-19T22:01:23.753406+02:00

FiniteN2IntegralRows failed only at the three polynomial transport lemmas: simp left mapped numerals such as f15 and f40. The already verified Q transport proofs explicitly use map_ofNat. Added the same lemma for Constant, Left and Right. Applied the identical narrowly scoped repair to the already reviewed, not-yet-run N3 transport source. All public statements and coefficients are unchanged. Both existing locks were held after outer process47601 exited1 and its terminal result was collected.

```diff
--- FiniteN2IntegralRows.before
+++ FiniteN2IntegralRows.after
@@ -10,15 +10,15 @@
 
 @[simp] theorem map_finiteN2Constant (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteN2Constant x y c i) = finiteN2Constant (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteN2Constant]
+  fin_cases i <;> simp [finiteN2Constant, map_ofNat]
 
 @[simp] theorem map_finiteN2Left (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteN2Left x y c i) = finiteN2Left (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteN2Left]
+  fin_cases i <;> simp [finiteN2Left, map_ofNat]
 
 @[simp] theorem map_finiteN2Right (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteN2Right x y c i) = finiteN2Right (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteN2Right]
+  fin_cases i <;> simp [finiteN2Right, map_ofNat]
 
 @[simp] theorem map_finiteN2DividedMatrix (f : R →+* S)
     (x y c : R) (i j : Fin 3) :
--- FiniteN3IntegralRows.before
+++ FiniteN3IntegralRows.after
@@ -10,15 +10,15 @@
 
 @[simp] theorem map_finiteN3Constant (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteN3Constant x y c i) = finiteN3Constant (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteN3Constant]
+  fin_cases i <;> simp [finiteN3Constant, map_ofNat]
 
 @[simp] theorem map_finiteN3Left (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteN3Left x y c i) = finiteN3Left (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteN3Left]
+  fin_cases i <;> simp [finiteN3Left, map_ofNat]
 
 @[simp] theorem map_finiteN3Right (f : R →+* S) (x y c : R) (i : Fin 3) :
     f (finiteN3Right x y c i) = finiteN3Right (f x) (f y) (f c) i := by
-  fin_cases i <;> simp [finiteN3Right]
+  fin_cases i <;> simp [finiteN3Right, map_ofNat]
 
 @[simp] theorem map_finiteN3DividedMatrix (f : R →+* S)
     (x y c : R) (i j : Fin 3) :
```
