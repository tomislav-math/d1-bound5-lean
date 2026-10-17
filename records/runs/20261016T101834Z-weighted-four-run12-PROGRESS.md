# PROGRESS — weighted branch sign selection

2026-10-16 around 10:25Z. Examined latest status and frozen v4 product-four proof. The second branch uses first-row magnitude >=3 and later-pair magnitude >=12; the existing complete tail-growth theorem does NOT alone supply the latter when 3<=B<=C<4. The missing arithmetic threshold must stay explicit, or be proved separately. Do not silently strengthen hB to C>=4.

Started source `exploration/WeightedRootSignsTrial.lean`, defining two explicit scalar bounds and proving integral sign alternatives from the accepted `exists_root_error_three` and `exists_root_error_twelve`. Next add symmetric simultaneous finite-index construction, then targeted compilation/axiom audit and accepted integration if successful. No claimed compiled outcome at this point.

Correction during proof development: although the manuscript's twelve-threshold cannot be inferred directly for B*C when C<4, this DOES NOT obstruct the required numerical bound. The already proved nine-threshold estimate gives |E_ij|<128/8649<1/64 and |F_ij|<16/31<7/13. Both comparisons are exact rational inequalities. Thus every later pair needs only |a_i a_j|>=9, which follows from B>=3 and monotonicity without assuming C>=4. New source uses that stronger route; the earlier concern should not be mistaken for a proven gap in the theorem.

Scalar proof unit compiled with exit code 0 before appending the simultaneous matrix construction. Full enlarged source compilation now running. No acceptance or final audit claimed yet.
