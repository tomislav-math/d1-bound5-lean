# Expand the now-explicit Taylor truncations

2026-10-20T03:34:57.385781+02:00

The root-cancellation repair removed every half-power atom. The actual remaining goals contained only the finite sums of lengths6,7,8, which had not been expanded before their indices became numerals. Expand those exact sums after cancellation using the already proved coefficients0 through7, then clear rational denominators and ring-normalize. No new assumption, coefficient or budget is introduced.

```diff
--- before
+++ after
@@ -101,6 +101,7 @@
       finitePairQuadratic, finitePLeadingR, finitePLeadingT]
     apply sub_eq_zero.mp
     ring_nf
+    norm_num [Finset.sum_range_succ, Finset.sum_range_zero, h0,h1,h2,h3,h4,h5,h6,h7]
     all_goals field_simp [hu,hv,hc] <;> ring
 
 noncomputable def finitePResidual (a b s c : ℂ) (i : Fin 4) : ℂ :=
```
