# All-order proof compilation

Pinned source command: `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean exploration/LagrangeHomogeneous.lean` in /Users/tp/Lean/D1Bound5, with logged stdout/stderr.
Trial01 EXIT 1: missing explicit singleton-subtype binder and singleton simplification.
Trial02 EXIT 1: exact Sym.replicate and Finset.insert_empty API corrections still needed.
Trial03 EXIT 0 (remote PID 91547; output collected, 25.52 seconds, no warnings).
The five complete theorem proofs include the first formal all-k identity with mathlib hsymm. None of the trial failures was a safety refusal; they were actual Lean elaboration errors and have been repaired. Failed sources/logs are retained outside root imports.

Root promotion and the new all-order reciprocal corollary are now pending integrated build, type/axiom audit and fresh same-kernel replay.
