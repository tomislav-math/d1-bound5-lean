> UNFILLED TEMPLATE — not current status and not approved for application.
> Use only after every gate in APPLICATION_CHECKLIST.md has actual successful evidence.

# A uniform bound of five for Diophantine tuples in imaginary quadratic integer rings

**Zrinka Franušić and Tomislav Pejković**

Manuscript: 15 October 2026. Verified checkpoint: {{VERIFIED_AT_UTC}}.

For every degree-two totally complex number field K and finite
A ⊂ 𝓞_K ∖ {0}, if ab + 1 is a square in 𝓞_K for every distinct a, b ∈ A,
then |A| ≤ 5. This uses the full ring of integers, permits zero pair-square
roots and equal absolute values, and makes no sharpness assertion.

The Lean declaration is `D1Bound5.main_statement : D1Bound5.MainStatement`.
{{MAIN_THEOREM_LINK_ONLY_AFTER_EXACT_GIT_BLOB_IS_TRACKED}}

The current recovery source build, exact declaration audit, broad audit and
official fresh full-root kernel replay completed successfully. Canonical
installation and source/configuration equivalence were checked against the
tested recovery candidate. The exact records are:

| Gate | Actual result and durable evidence |
|---|---|
| 4,406 project modules from fresh project outputs, with guarded resumes | {{BUILD_RECEIPT_LINK_AND_SHA256}} |
| Exact 114+4 declaration occurrences | {{EXACT118_RECEIPT_LINK_AND_SHA256}} |
| Separate broad declaration audit | {{BROAD_RECEIPT_LINK_AND_SHA256}} |
| Official full-root fresh replay | {{FRESH_RECEIPT_LINK_AND_SHA256}} |
| Canonical installation and source identity | {{INSTALL_AND_SOURCE_BRIDGE_LINKS_AND_SHA256}} |

The historical failures, environment losses and unknown process exits remain
in [STATUS.md](STATUS.md) and their original records. They have not been
relabeled as successful attempts. The bundled checker uses the installed Lean
kernel, not an independent verifier implementation. The allowed axiom baseline
is `propext`, `Classical.choice`, `Quot.sound`.

{{CHECK_SH_EXECUTION_BOUNDARY: retain explicit “Full verification used direct reviewed steps; packaged check.sh was not run end to end” unless a separate actual end-to-end result exists.}}

Use {{INSTALLED_VERIFICATION_GUIDE_LINK_AFTER_BYTE_CHECK}} for the pinned
reproduction procedure. Lean is `leanprover/lean4:v4.33.1`; mathlib is
`0df444a360eaa60ab8c11dca51a86af692955474`. A new checkout must establish its
own source/runtime identities and fresh project output directory. Source
equivalence does not mean a later release commit was executed in an older run.

| Material | Link |
|---|---|
| Paper | [PDF](paper/Diophantine_tuples_bound_five_2026-10-15.pdf) |
| Manuscript source | [LaTeX](paper/Diophantine_tuples_bound_five_2026-10-15.tex) |
| Numerical supplement | [Verification guide](verification/README.md) |
| Preserved formalization history | [Status](STATUS.md) |

The repository remains private; no public release or licence has been selected.
External numerical checks are evidence, not Lean proof terms. The frozen v4
manuscript SHA256 remains
`776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3`.
