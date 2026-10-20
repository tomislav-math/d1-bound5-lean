# Prepared proof-only normalization

Normalize multiplication association directly in the scaled monomial bound, rather than a conversion followed by a potentially vacuous dsimp.

Not applied or compiled. Original theorem headers and definitions are unchanged.

```diff
--- FinitePTailCoefficients.before
+++ FinitePTailCoefficients.draft
@@ -73,7 +73,7 @@
     change ‖(m.1 : ℂ)*(![u,v] side)^m.2.1*(![v,u] side)^m.2.2‖ ≤ _
     simp only [norm_mul,norm_pow,hn]
     have hh := mul_le_mul_of_nonneg_left hm (show 0 ≤ (m.1.natAbs : ℝ) by positivity)
-    convert hh using 1 <;> dsimp [U,V,m] <;> ring
+    simpa only [U, V, mul_assoc] using hh
   rw [finitePPairCoeff_eq_terms]
   calc
     _ ≤ ∑ t : Fin 3, ‖((finitePTailCoeffTerms kind side l t).1 : ℂ)*
```
