# Repair 07

2026-10-19T23:06:00.070018+02:00

The N3 identity passed. Its residual proof failed only because norm_ofNat was not namespace-qualified, leaving the norm of complex4 unreduced in the final scalar comparison. The pinned Mathlib Analysis/Complex/Norm.lean explicitly supplies Complex.norm_ofNat. Qualify that single lemma. All residual coefficients, beta values, exponents and statements remain unchanged.

```diff
--- before
+++ after
@@ -68,7 +68,7 @@
     convert hm using 1 <;> ring
   rw [← finiteN3_residual_identity x y c hx hy hxy i,
     norm_mul,norm_mul] at hbound
-  norm_num only [norm_ofNat] at hbound
+  norm_num only [Complex.norm_ofNat] at hbound
   exact (lt_div_iff₀ (by positivity)).mpr (by nlinarith only [hbound])
 
 private theorem finiteN3_rowfactor_scalar (X Y delta r : ℝ)
```
