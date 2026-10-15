# Analytic tail branch, direct continuation 2026-10-15

Branch: tail-analytic-20261015, based on accepted 18af1df.
The main bound-five theorem remains UNPROVED.
This branch is separate from the simultaneous finite-tail checker work.

## Mathematical argument

For a complex number q with Re(q)>=0, if 0<rho<1-c^2 and
|q^2-1|<=rho, with c>=0, then Re(q)>c. Indeed
1-Re(q)^2+Im(q)^2<=rho. Consequently |q+1|>1+c and
(1+c)|q-1|<rho. The zero-error case is treated explicitly.
Normalize by a NONZERO target t, and choose the sign of a given root u.
The resulting statement is

    (1+c)|t| |(+/-u)-t| < E,

provided |u^2-t^2|<=E<(1-c^2)|t|^2 and E>0.
The root u itself is never divided out. In a ring embedded in C, sign
selection keeps the root in the ring and preserves its square.

For a putative regular tail d=b+c+2r, r^2=bc+1, choose beta^2=b,
gamma^2=c with r close to beta*gamma. Let alpha^2=a and
x=|alpha|, y=|beta|, z=|gamma|, p=|beta+gamma|.
The hypotheses A>=1, B>=3, C>=4, A<=B and C<=D give
x>=1, y>=12/7, z>=2, x<=y. With er=|r-beta*gamma|,

    (39/20)y z er < 1,
    z^2 <= p^2+2er,
    p > (24/25)z,
    1+2x^2 er < (9/25)(xp)^2.

The perturbation constants are 19/20, 4/5, 6/7 and 4/5 for r,u,v,w.
Here u^2=ab+1, v^2=ac+1 and w^2=ad+1, with signs chosen in the
original ring. Their errors eu,ev,ew satisfy

    (9/5)xy eu < 1,
    (13/7)xz ev < 1,
    (216/125)xz ew < 1+2x^2 er.

A rational two-case bound replaces the manuscript's convexity calculation.
For x<=8/7 the bounds are

    eu < 35/108, ev < 7/26, ew < 19625/50544,
    eu+ev+ew < 49613/50544 < 1.

For x>=8/7 the bounds are

    eu < 245/864, ev < 49/208, ew < 54125/134784,
    eu+ev+ew < 124097/134784 < 1.

Thus |u+v-w|<1. The norm lower bound for every nonzero algebraic integer
implies u+v=w. Squaring and using d=b+c+2r yields 2(ar-uv)=1.
The nonzero algebraic integer ar-uv would have modulus 1/2, a contradiction.

The sign of the regular completion is covered by factoring
(d-b-c-2r)(d-b-c+2r)=regularDefect(b,c,d) and replacing r by -r when needed.
No distinct-modulus assumption, excluded zero root, numerical floating-point
comparison, analytic-branch axiom or unproved all-fields coordinate bridge
is introduced. The full-ring wrapper invokes the existing proved
one_le_norm_integer theorem for every imaginary quadratic field.

## Source map and validation status

RootPerturbation.lean: two general perturbation lemmas, compiled.
TailErrorBounds.lean: rational error sum and p/error-gap estimates, compiled.
TailAnalytic.lean: preservation of integral roots and aligned auxiliary
roots, compiled with minimized imports.
TailAnalyticMain.lean: complete core proof, full-ring C>=4 wrapper and
ordered-D(1)-quadruple irregularity/growth corollary, all compiled.
There are nine new explicit theorems, bringing this branch to 79 theorems
in 23 modules, including the root import module.

Actual terminal build: lake build D1Bound5.TailAnalyticMain, exit 0.
The original successful attempt built the final module in 403s and finished
in 415.36s. A repeated up-to-date build also returned exit 0 in 37.16s.
At the sampled instants the slow attempt was loading imports during
concurrent compilation; this is not a diagnosis of every later phase. An attempted interruption found the
process already finished and did not stop it; an inaccurate automated log
annotation was corrected explicitly. No mathematical error was suppressed.
The preceding failed build had one triangle-inequality API mismatch, now
replaced by explicit norm inequalities and linarith.

Source-policy and root-import-coverage check: PASS, 79 explicit theorems,
23 modules. The integrated build and 133-declaration transitive axiom audit passed.
All four new modules returned successfully from the pinned kernel replay
function. A later repeat of unchanged base modules was stopped; no complete
23-module exit-0 replay is claimed. See tail-analytic-checks.md. No independent
external referee was used. The main theorem remains unproved.
