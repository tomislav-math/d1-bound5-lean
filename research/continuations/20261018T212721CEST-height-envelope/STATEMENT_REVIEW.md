# Statement review of the height/cutoff unit

Reviewer scope: this assistant's direct source and mathematical inspection, NOT an independent reviewer. All original theorem statement strings are unchanged; the logarithm source is byte-identical, while the height scaling and unit rational-constant steps only change proof bodies. The exact elaborated type and axiom log is the authoritative complementary evidence.

The general height envelope assumes every positive integer approximation order, not merely finitely many checked orders. It derives positivity of the residual-rate logarithm and R>1 from the supplied rate bounds. The natural-floor order selection is the previously verified OrdinaryHeightScalar theorem. The denominator log10(C)-(h-r) is explicitly positive. The bound CD<2Z^2 is an exposed input, not silently inferred for arbitrary real variables.

The unit specialization takes S>=10000, proves R=27(S-1)^2/64>(2/5)S^2, and uses exact logarithmic parameters h=163/100, r=-2/5, u=241/100. It proves the upper envelope with constants 617/25, 118401/2500 and 203/100. The cutoff theorem first assumes S>=10000 by contradiction, invokes precisely the conditional all-order hypothesis available in that regime, and combines the upper envelope with D>S^27/8192. This yields the strict conclusion S<10000.

These are conditional real-variable theorems. FullRingOrdinaryHeight, BennettRootTransfer and UnitPairFirstExtensionBound must still supply and combine the actual full-integer-ring tuple inputs; their source text alone is not accepted as a proof. Exhaustive finite graph/Pell checks and the final bound-five theorem remain separate unresolved gates. No new assumptions were added to any original theorem, and no main-theorem completion is claimed.
