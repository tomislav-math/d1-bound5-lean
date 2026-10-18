# Source-only pinned API review: Bennett Gamma, majorant, residues at infinity

Review date: 2026-10-18. Remote project and mathlib were read only. No compiler or remote mutation was performed.

Pinned mathlib: `0df444a360eaa60ab8c11dca51a86af692955474`.

Reviewed unchanged sources:

- `bennett_integrality/BennettChooseGamma.lean`: `d9bcba0050f96c2e5358883423228bb6c2cb33d7ddbc636ef04e0b742d0152a4`
- `bennett_next/BennettResidualMajorant.lean`: `621bf3350b583bf323a08abac3edc3459f36cec3092a6486cd8040d14d1acbc9`
- `allorder_next/BennettResiduesAtInfinity.lean`: `ffee844ddcc512f46ac459e558a24bcd0f711cd6e3a6d9884e8c9565460a90d6`

No grounded import or API repair was identified. All source files remain frozen and unchanged. This finding is not a compiler-pass claim.

The Gamma module imports the actual GaussianIntegral module, which publicly imports Gamma.Basic and supplies `Real.Gamma_one_half_eq`. Pinned signatures of `Real.Gamma_add_one`, `Gamma_nat_eq_factorial`, `Gamma_pos_of_pos`, the ascending/descending Pochhammer conversion and succession lemmas, `Ring.choose_smul_choose`, and `Nat.choose_mul_factorial_mul_factorial` match their use. The factorial cancellation and two-anchor substitution retain the correct signs and shifted indices.

The majorant module's CoherentMajorant dependency imports HsymmSummability, supplying the actual homogeneous coefficient bound. The analytic binomial module supplies `Real.one_div_one_sub_rpow_hasFPowerSeriesOnBall_zero`; its `hasSum_sub` and scalar-series evaluation match the proof. Checked the negative-choose unit sign API, `ascPochhammer_pos`, `Summable.of_norm_bounded`, `Summable.of_nonneg_of_le`, `norm_tsum_le_tsum_norm`, and the extended-ball conversion. The counting factor uses card=n+1 correctly.

The infinity-residue module imports polynomial Reverse and the accepted local residue dependency. Checked `natDegree_divByMonic`, `degree_modByMonic_lt`, `reflect_mul`, `reflect_monomial`, `coeff_reflect`, `revAt_le`, `natDegree_reflect_le`, `coeff_zero_reverse`, `reverse_add_C`, `reverse_mul_of_domain`, and the polynomial-to-power-series constant/ordinary coefficient APIs. The reflected monomial has exponent one, so extraction at t+1 selects the remainder coefficient at d−1. `PowerSeries.coeff_X_pow_mul` has coefficient index d+n, exactly matching t+1 in the final step. Denominator-divisible numerators vanish using the actual shifted factor and `X_pow_dvd_iff`.
