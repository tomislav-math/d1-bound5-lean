# Auxiliary audit repair

The first type/axiom audit exited 1 (Lean PID 91533, tool process 91527, collected). All 574 axiom markers were printed, but exact-type examples were not accepted. The auxiliary audit omitted required names after namespace end commands and used a lower recursion-depth option than the source modules. The original failed audit, logs, receipts and artifact guards are preserved in failed-audit-1.

Repair: close each namespace with its exact full name, and use the source modules' existing maxRecDepth 32768 in the audit. No mathematical source, statement, certificate data, proof, compiler pin or trust baseline changed. No targeted replay had started in the failed attempt. A new serial audit/replay run must succeed before acceptance.
