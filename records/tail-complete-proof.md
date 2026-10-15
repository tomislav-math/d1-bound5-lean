# Complete tail-irregularity: proof structure

This record describes the finite certificate and the full-ring assembly.
Consult the build and audit receipts for acceptance; the main bound-five
statement remains unproved.

## Mathematical coverage

For an ordered D(1) quadruple (a,b,c,d) in a full imaginary quadratic
integer ring, write A<=B<=C<=D for the complex moduli and suppose B>=3.
The existing analytic branch covers C>=4. For C<4 the coordinate norms
satisfy 9<=N(b)<=N(c)<=15 and N(a)<=N(b). The proved normalized full-ring
basis has tau in {0,1}. The finite-tail discriminant bound gives
0<4*nu-tau^2<=60, so 1<=nu<=15.

All thirty coordinate models in that rectangle are checked, including
unneeded nonmaximal suborders. Hence neither squarefree parameter pruning
nor symmetry-orbit completeness is needed in this part of the proof.

For each model, an explicit integer-coordinate list is proved equal to the
complete closed norm-15 disk. The equality is verified by kernel reduction.
The finite checker considers every ordered pair b,c in the list, with equal
norms permitted, and tests bc+1 by the previously proved necessary-and-
sufficient square-root procedure. Both regular completions are considered.
For each eligible completion it checks every eligible a in the entire list.
Zero and repeated entries are filtered only where tuple distinctness or
nonzeroness requires it. The square-root procedure allows zero roots.

The checker-soundness proof explicitly connects list coverage, both
completion signs, every pair condition and the final failed square test.
The positive-discriminant domain proof establishes that all regular
completions have those two forms. Every finite checker result is a
`decide +kernel` proof. Python only emits untrusted candidate lists; both
coverage and their asserted mathematical consequences are proved in Lean.

The coordinate exclusion is transported through the previously proved
ring equivalence for EVERY imaginary quadratic field. The equality between
coordinate norm and squared complex modulus transfers the bounds. The
finite and analytic cases then imply that (b,c,d) is irregular. Applying
the existing irregular-growth theorem gives D>2BC.

## Exact scope

The endpoint C=4 belongs to the analytic branch. The finite range includes
N(c)=15. Modulus ties and both full integral bases are preserved. There is
no unproved certificate, field-classification or norm-bridge hypothesis in
the assembled theorem. This proves lem:tail-irregular, not the main theorem.

## Validation discipline

This is a self-review, not an independent referee report. Exact compilation,
source/import coverage, transitive axiom auditing and targeted kernel-replay
receipts must identify the actual successful commands. The previously
accepted full-ring bridge and analytic modules are reused unchanged.
