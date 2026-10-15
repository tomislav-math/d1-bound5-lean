# Finite small-tail certificates completed

All thirty normalized models (tau,nu) in {0,1} x {1,...,15} now have unconditional SmallTailCheck proofs. New explicit lists are checked equal to the exhaustive disk enumeration. Each full finite checker result is proved using decide +kernel. The generic list-coverage implication was proved in SmallTailExplicit.lean.

Commands: LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.SmallTailData0_1 and ... SmallTailAllData. Both exited 0. Logs: local-logs/recovery-20261015T1949/gaussian-02.log and all-data-03.log. No Python result or native-evaluation axiom is a proof dependency.

The full-field C<4 transfer and join with the analytic C>=4 case are being compiled in TailIrregular.lean. Do not count the transfer as accepted until the build and axiom audit pass. Main theorem remains unproved.
