# Prepared one-small joins — NOT YET BUILT OR AUDITED

This directory prepares the next two existing source modules without claiming
compilation, axiom/type acceptance, kernel replay, or canonical root integration.
The original sources are preserved in originals/. Their reviewed statements and
proof bodies have not been edited. The independent source-only review is scoped
explicitly and does not certify imported proofs or table completeness.

After inspecting current access, handoff, Git and process state, the next command
is:

    /Users/tp/.local/bin/python3.12 -B /Users/tp/Lean/D1Bound5/research/continuations/20261021-pro-one-small/bounded_build.py OneSmallReducedImpossible

The wrapper acquires the existing compiler ownership lock, rejects active work,
verifies its exact target source and all required accepted dependency artifacts,
and launches exactly one 240-second guarded build. It is the previously reviewed
bounded wrapper with only its allowed target pins changed. It does not launch
a batch or modify the queue. OneSmallImpossible is allowed only after its own
current prerequisite checks pass. Save and synchronize each coherent checked
unit using the project policy; do not interpret this preparation as acceptance.
