# Analytic-tail validation record

Source commit: 3a8f9ff711bdaf3dec07b3fe3dbbc9be6af336f9.
Private branch: tail-analytic-20261015.
Pinned Lean 4.33.1, mathlib 0df444a360eaa60ab8c11dca51a86af692955474.
The main bound-five theorem remains unproved.

## Actual completed checks

1. `lake build D1Bound5.TailAnalyticMain`: exit 0, all four new modules
   compiled. The successful original attempt took 415.36 seconds; an
   up-to-date repeat also returned exit 0 in 37.16 seconds. See
   tail-analytic-targeted-build.log.
2. `python3.12 scripts/source_audit.py`: exit 0, 79 explicit theorems,
   23 modules including root, complete root-import coverage.
3. Integrated `lake build`: exit 0, 2971 jobs. This is a dependency-job
   count, not a theorem count.
4. `lake env lean scripts/Audit.lean`: exit 0, 133 project declarations
   passed the transitive whitelist. The only axioms were propext,
   Classical.choice and Quot.sound. The nine new public theorem axiom
   lists and both terminal theorem types are printed in
   tail-analytic-build-and-axioms.log.
5. The unchanged bundled `replayFromImports` function returned successfully
   for every new module: RootPerturbation, TailErrorBounds, TailAnalytic,
   TailAnalyticMain. Each REPLAY_PASS line is written AFTER successful
   return from the kernel, not merely at the start of a check. Five
   unchanged base modules also passed. See tail-analytic-kernel-replay.log.

## Scope of the interrupted whole-project repeats

The combined `bash scripts/check.sh --replay` completed source checks,
build and axiom audit, then its all-at-once kernel checker was stopped by
this owner. The combined command therefore exited 143, NOT 0.

To obtain observable, sequential module-level outcomes, the exact body of
replayFromImports was copied from the installed LeanChecker.lean into
scripts/SequentialReplay.lean, with its copyright notice preserved.
The replay function's SHA256 is
168f5a2aed2522c422d0dcc2eab6c33dd62448556d797051a0cba00989a2bfa6.
Its byte identity to the installed function was actually checked. Only the
caller changed: modules are processed sequentially and a flushed PASS is
printed after each completed function call. This is Lean's own kernel,
not an independent verifier or a new mathematical axiom.

The full exact command and requested module list are saved in
replay-receipt JSON. The four new modules and five unchanged modules passed.
The optional repetition was stopped during FullRingBasis. Overall exit 143
is recorded, and a complete 23-module exit-0 replay is NOT claimed.
Stopping the later work does not turn a preceding successful kernel return
into a mere proposed proof. The unchanged 70-theorem base already had its
separate accepted build/axiom/replay record at 18af1df.

## Integrity and remaining release checks

The proof-source SHA256 manifest was checked. Mathematical sources and
verification Audit.lean are unchanged from source commit 3a8f9ff. The
original 19 base modules have no mathematical source changes relative to
18af1df, apart from the root's additional imports. The exact main target and
all pinned configuration files are unchanged. The frozen manuscript digest
was rechecked and matches its release identity.

No fresh checkout of this 79-theorem branch or independent external
statement review was run. No --fresh replay of all of mathlib is claimed.
Previous clean-checkout receipts retain their original scope.

The Mac has 8 GiB RAM and another invocation was doing finite-tail work.
Sampling observed import loading, and later actual elaboration. Concurrent
memory pressure is consistent with the slow runtime, not a proved exclusive
cause. Only this invocation's verified own processes were signalled.
The old checker and sequential checker each have an accurately recorded
controlled interruption. Earlier attempted stops of completed builds sent
no signal; their actual successful exits were retained. No permanent
machine setting or other invocation's mathematical source was changed.
