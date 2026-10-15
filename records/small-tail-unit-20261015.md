# Small-tail formalization continuation, 2026-10-15

## Scope and mathematical reduction

The accepted algebraic statements are independent of a proposed finite
certificate's truth value. `FiniteTail.lean` proves: positive discriminant
gives a domain; regular completions of b,c are b+c±2r including r=0;
the norm-disk and square-test lemmas are complete; and any eligible regular
ordered tail with N(c)<=15 has discriminant <=60.

The normalized full-ring bridge supplies tau=0 or tau=1. Therefore
0<4nu-tau^2<=60 implies 1<=nu<=15, uniformly. Checking 30 rectangular
models (tau,nu) in {0,1} x {1,...,15} suffices, even without pruning
non-squarefree parameters. The stronger rectangle deliberately includes
several proper suborders. `SmallTailRange.lean` proves this arithmetic
reduction and the conditional implication from all rectangular certificates.
**Its certificate hypothesis is not yet discharged.**

The older 26-parameter (d modulo 4) reduction in
`SmallFieldParameters.lean` also compiled, but the 30-model rectangle is
simpler for eventual exhaustive checking.

## Computation and trust status

- `lake build` with the new square-root, disk and finite-tail source
  files passed at exit 0 (2970 jobs).
- `lake build D1Bound5.FiniteTailComputable` passed initially at exit 0.
  It proves an executable Boolean search implies the abstract
  `SmallTailCheck` statement. The later reducibility annotation was
  introduced to probe kernel certificate performance and requires rebuild.
- `lake build D1Bound5.SmallFieldParameters` passed at exit 0.
- `lake build D1Bound5.SmallTailRange` passed at exit 0.
- `#eval` reported disk size 31 for (tau,nu)=(0,2) and Boolean checks
  `true` for (0,2) and (1,1). This is exploratory execution, not proof.
- First kernel experiment
  `lake env lean exploration/SmallTailTrial.lean` exited 1:
  `decide +kernel` did not reduce `smallTailCheckBool 0 2 = true`
  to a proof. This is a checker-computation problem, not a mathematical
  counterexample. The later `SmallTailTrial35` test isolates whether
  the sorting instance is responsible.
- `python3.12 scripts/reference_small_tail.py` exited 0 with
  counts (90 unordered pairs, 118 regular tail candidates, 16 preliminary
  quadruples, 0 fully compatible). The generator uses exact coordinate
  integer arithmetic and no floating point. It verifies the manuscript's
  numeric small-tail counts independently, but does not give Lean proof
  terms and is not trusted as a certificate.

## Remaining next step

Prove Boolean certificates in Lean without native-evaluation axioms,
possibly by splitting into per-anchor checks and using an explicit finite
candidate list with separately proved disk coverage. Then combine all 30
models and transport the finite exclusion through the full-ring equivalence.
The large-C analytic tail lemma is handled in a distinct proof branch.

## Kernel-checked per-model certificate prototype

The first end-to-end positive certificate is `small_tail_015` in
`D1Bound5/SmallTailModel15.lean`, for the auxiliary model
`QuadInt 0 15 = Z[sqrt(-15)]`. This model is a nonmaximal suborder,
but it is included in the deliberately enlarged 30-model rectangle.
The two bounded statements `small_tail_015_pair_cases` and
`small_tail_015_no_small_third` are proved using `decide +kernel`.
The former identifies the only two compatible ordered large pairs;
the latter rules out a common small third entry. Their combination
proves the complete abstract `SmallTailCheck 0 15`, with all quantifiers.

Actual command in the main project: `LEAN_NUM_THREADS=1 lake build
D1Bound5.SmallTailModel15`. Final run exited 0 and printed
`Build completed successfully (1547 jobs).` Earlier monolithic
kernel decisions were too expensive: both original and alternative
single large Boolean trials hit explicit 90/200-second limits.
Splitting the mathematical certificate into large-pair enumeration and
a separate small-anchor incompatibility test succeeded. A partial
compilation attempt that produced an `.olean` before a subprocess
wall-clock timeout was NOT counted; the subsequent full `lake build`
with exit 0 is the accepted evidence.

The other 29 rectangular cases remain to be checked. The positive
instance is not a substitute for the complete analytic large-C branch
or the main bound-five theorem.
