# Analytic import-chain readiness

This is a source and pinned-API review, not a kernel acceptance report. A single read-only snapshot of the coordinator records and current imports found 688 modules in the current `MainTheorem` closure. The active protected target at that snapshot was `SmallPairGraphLeft34`; no remote or active source was changed.

## Nearest analytic compilation stages

1. Retry the current corrected `CoherentTwoGap` and `CoherentThreeSimultaneous`. Their last recorded failures concern older hashes. Then compile `CoherentTwoMainGap`, `CoherentThreeGeneral` and `CoherentThreeNonvanishing`.
2. Compile `CoherentThreeParameters` before `CoherentParameterForms`; compile `CoherentVandermondeFourNorm` independently, followed by `CoherentFourParameters` and `CoherentDirectFour`. These feed every retained interpolation branch.
3. Compile `CoherentRetainedIntegral` and `CoherentRetainedAnalyticData`, then the retained scalar/gap/tuple/start modules. The mixed branch uses `CoherentRetainedMixedSizes`, `CoherentRetainedMixedForms`, `RetainedMixedScalar`, `CoherentRetainedMixedGap`, its tuple and four-anchor start wrappers. `CoherentThreeZeroBootstrap` additionally needs `CoherentThreeGeneral` and `CoherentParameterForms`.
4. Join the actual finite approximation intervals and ordinary tail. The no-small-entry branch ends at `AllLargeImpossible`; the one-small-entry branch joins the five unbounded regions, the 41-pair reduction and bounded triple certificates at `OneSmallImpossible`. The remaining branches use `ThreeSmallExclusion`, `TwoSmallNondegenerateImpossible` and `DegeneratePairImpossible`.
5. Compile `MainTheorem` only after those actual branch dependencies, then run the coordinator's complete closure and axiom acceptance checks. The theorem source imposes no new analytic premises.

The coordinator's continuation ledger does not contain every earlier accepted standalone trial. In particular, the earlier kernel passes of `CoherentNearOne`, `CoherentPolynomialWeights` and `CoherentTwoVanishing` must not be reclassified as unbuilt merely because they are absent from that ledger.

## Grounded repairs

Exact before/after hashes and filenames are in `repair_manifest.json`.

- `CoherentParameterForms`: make the factor `P*Q` explicit in `199*P*Q` before the square-norm rewrite.
- `CoherentThreeZeroBootstrap`: apply its remainder inequality to the first summand with `add_le_add ht le_rfl`.
- `CoherentRetainedMixedSizes`: give `mul_lt_mul` its required non-strict second premise, `hC864.le`.
- `CoherentThreeParameters`: correct two additions to `add_le_add le_rfl hy` and `add_le_add le_rfl hy2`.
- `CoherentFourParameters`: correct one addition to `add_le_add le_rfl hy`.

The last two copies retain the already prepared `noncomputable section`. All repairs preserve the theorem statements and mathematical arguments.

## Reviewed without speculative edits

The current contents of `CoherentDirectFour`, `CoherentVandermondeFourNorm` and `CoherentTwoMainGap` were compared with their local drafts; only removal of audit-print commands differed. Their relevant APIs and source joins showed no additional concrete mismatch. `CoherentRetainedIntegral` and `CoherentRetainedAnalyticData` were also inspected. The article-audit agent independently reviewed all four mixed size/form/gap/tuple modules and found the single `mul_lt_mul` premise issue above.

Potential simplifier, instance transparency and elaborator-performance issues without an exact failing signature were left for actual compiler diagnostics rather than changing stable proofs speculatively.
