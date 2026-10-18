# Left41 fallback scalar obstruction

Status: exact Python diagnostics only. No Lean source was changed, no compiler was run, and no kernel acceptance is claimed. All frozen inputs matched the preceding norm diagnostic, whose SHA256 is recorded in the JSON.

For all 884 fallback pairs, product-plus-one z=a+bω has b=0, a<0, and a mod 7=1. Its norm is n² with n=−a. Consequently T=2a and T+2n=0: all 884 trace-square tests pass with trace root 0. The next required identity, 7y²=2n−T, fails integrality in every case, since 2n−T≡3 mod 7. No pair reaches the imaginary square test or parity test.

This identifies a simpler certificate than supplied square-root floors. If (x+yω)² is a negative rational integer in QuadInt(1,2), its imaginary part gives y(2x+y)=0. The y=0 case would make its real part x² nonnegative. Otherwise y=−2x, and the real part is x²−2y²=−7x², hence divisible by 7. Thus the conjunction im(z)=0, re(z)<0, and re(z) mod7=1 excludes a square without square-root computation. This is a mathematical derivation awaiting a Lean proof and concrete kernel certificate.

Exact per-pair coordinates, norms, norm roots, scalar values, floor bounds, and extrema are saved in the JSON. Norm roots range from 154 to 3588 bits; the imaginary numerators range from 156 to 3590 bits. The trace target and its floor are identically zero.

Artifacts:
- `audit_next/diagnose_left41_trace_fallbacks.py` — SHA256 `e56260405692029889a0babc9ba375bc08c226adeafaf4262faf654d3e452a0a`
- `audit_next/left41_trace_fallback_diagnostic.json` — SHA256 `268a1d0425ba014bb9e56e690900c972083e30f5f4628ada62010c9d62843af0`
- `audit_next/left41_norm_fallback_diagnostic.json` — SHA256 `e013b6d22626ade79504a23f0a05da7f8db7e86dabded467969ea017f106f0ef`
