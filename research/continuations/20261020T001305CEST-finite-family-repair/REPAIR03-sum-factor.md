# Correct the direction of the finite-sum identity

2026-10-20T00:20:37.070982+02:00

The exact failed goal already has the common factor inside the finite sum. Use the reverse sum_mul identity to extract it, then associativity. All four public theorem signatures and the scalar height margin are unchanged. The old source and compiler error remain in wave01. This file was outside the live protected closure.

```diff
--- before
+++ after
@@ -67,7 +67,7 @@
     _ ≤ (101/100 : ℝ)*(∑ ell, (v ell/(1000 : ℝ)^(k-(ell : ℕ)))*T^k) :=
       mul_le_mul_of_nonneg_left hsum (by norm_num)
     _ = ((101/100 : ℝ)*(∑ ell, v ell/(1000 : ℝ)^(k-(ell : ℕ))))*T^k := by
-      rw [Finset.sum_mul]
+      rw [← Finset.sum_mul]
       ring
     _ < M*T^k := mul_lt_mul_of_pos_right hslack (pow_pos hT0 _)
 
```
