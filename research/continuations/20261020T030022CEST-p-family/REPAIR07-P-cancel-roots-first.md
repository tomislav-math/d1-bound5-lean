# Cancel the common half powers before clearing denominators

2026-10-20T03:30:18.295713+02:00

The actual residual identity still had equivalent half-power bases represented differently after field_simp. Subtract the two sides and ring-normalize first, cancelling the identical half-power terms while their bases are unchanged. Then clear only the remaining rational denominators and finish by ring. This proves the same actual residual identity without any extra root or convergence assumption. All public headers, coefficients and budgets are unchanged.

```diff
--- before
+++ after
@@ -99,8 +99,9 @@
     norm_num [finitePPairCoeff, finitePRConstant, finitePTConstant,
       finitePRLeftCoeff, finitePRRightCoeff, finitePTLeftCoeff, finitePTRightCoeff,
       finitePairQuadratic, finitePLeadingR, finitePLeadingT]
-    field_simp [hu,hv,hc]
-    <;> ring
+    apply sub_eq_zero.mp
+    ring_nf
+    all_goals field_simp [hu,hv,hc] <;> ring
 
 noncomputable def finitePResidual (a b s c : ℂ) (i : Fin 4) : ℂ :=
   finitePDividedMatrix a b s c i 0+
```
