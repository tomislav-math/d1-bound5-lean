# Actual-tuple product-five Schur proximity continuation

This is a non-root continuation, not an accepted dependency.

`ProductFiveSchurTupleElaborated.lean` contains one mathematically substantive theorem, `IsD1Tuple.five_compatible_schur_near`. Its content was successfully elaborated as `exploration/ProductFiveSchurTupleTrial.lean` (trial01) on 2026-10-17 with pinned Lean 4.33.1 and project mathlib, exit 0. It obtains the last-four growth inequality directly from the tuple, transfers the four prefix-to-last ratios and fifth-column sign bounds to a common Schur matrix, and proves its norm distance from `halfOffDiagonal` is less than 1/2.

`ProductFiveSchurWitnessPending.lean` appends an existential packaging theorem for the *same* signed matrix. Compilation of this extended file was PRE_EXECUTION_DENIED by tool safety. It is UNCOMPILED, regardless of the shortness of the second proof. Do not import it as accepted mathematics.

Neither file passed an integrated root build, transitive-axiom audit or same-kernel replay. Before acceptance, compile the exact preferred source, audit elaborated theorem types and transitive axioms, import it into `D1Bound5.lean`, rebuild and perform the required replay/source/hash gates. Then connect the still open Schur determinant estimate <1/3 (including prefix size and bilinear h/q/p bounds) and apply the existing arithmetic endpoint to prove `lem:product-five`.

See `records/runs/20261017T082045CEST-productfive-tuple-PROGRESS.md` for exact execution and safety diagnostics. MainStatement remains UNPROVED.
