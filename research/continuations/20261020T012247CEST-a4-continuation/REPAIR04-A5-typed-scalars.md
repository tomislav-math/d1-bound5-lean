# A5 definition elaboration repair

2026-10-20T01:58:58.141761+02:00

The actual A5 matrix build failed during elaboration of the two giant three-entry root-column definitions, with the default 200000-heartbeat limit at synthesis of pending metavariables. Subsequent missing-identifier and recovery-placeholder diagnostics belong to this rejected build; no source placeholder was inserted and no A5 build was accepted.

Extract each original coordinate expression verbatim into a private scalar definition with explicit result type R. The public vectors now assemble those six scalars. Each exact literal polynomial, operation order and coefficient is preserved. Six separately typed rfl examples against the original coordinate expressions are prepared for the actual Lean audit. Public theorem and definition signatures remain unchanged, while the definition body syntax is deliberately refactored. No heartbeat or wall-time limit was increased. The existing owner and intake locks were held and no compiler was active.

The earlier INTERFACE_REVIEW.json is an observation before this refactor, not a claim that these current bodies are still text-identical.
