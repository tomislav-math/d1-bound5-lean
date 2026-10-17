# Isolated nodal interpolation recurrence (17 October 2026)

This directory preserves a Lean 4.33.1/mathlib-pinned standalone proof
and exact verification logs. This is research material outside the accepted
D1Bound5 import graph. The five proved declarations are not counted as
accepted root project theorems.

The source uses the installed mathlib Lagrange.nodal polynomial to prove
an all-order recurrence of arbitrary weighted power moments, uniqueness
from the first number-of-nodes many values, and the specific Lagrange
moment recurrence. It allows duplicate nodes, zeros and arbitrary weights.

See records/interpolation-nodal-recurrence-20261017.md for the statements,
the isolated compilation and axiom trust receipts, and the remaining
mathematical obligations. The logs directory stores positive and failed
trial output. The installed same-kernel replay succeeded, but this is not
independent review, a complete root build or a final bound-five proof.

Root integration into D1Bound5/InterpolationNodalRecurrence.lean was
PRE_EXECUTION_DENIED by tool safety before execution; no alternate
tool was used to achieve the rejected root mutation.
