# Adjugate bound: root integration and signed-ring transfer (2026-10-16)

## Mathematical proof unit

For a symmetric zero-diagonal matrix F in M_4(C), with every off-diagonal entry e_ij satisfying |e_ij - 1/2| < 128/8649, prove the unconditional strict estimate

    ||adj(F)||_2 < (8905/5766) * (3139/5766)^2.

This uses all sixteen exact adjugate cofactor formulas. The four diagonal cofactors have deviation < 23/1000 from 1/4; the twelve off-diagonal cofactors have deviation < 197/10000 from -1/8. Their operator error norm is < 23/1000 + 3*(197/10000); the reference adjugate norm is 3/8. Exact rational arithmetic proves the requested upper bound.

The new signed-ring transfer signed_root_matrix_adjugate_upper starts with an arbitrary commutative ring R, a homomorphism f : R -> C, a simultaneous symmetric choice of ring-valued signed roots S_ij and the root-square equations. It proves the above bound for normalizedRootError (f . a) u (f . S). The existence corollary exists_signed_root_matrix_adjugate_upper derives exactly these hypotheses from an original symmetric root matrix whenever all distinct pair products have complex modulus >= 9. The chosen signs remain in R, and zero square values and equal moduli are allowed.

## Sources and validation scope

New accepted-module candidates:
- D1Bound5/AdjugateFourBounds.lean (six proved lemmas).
- D1Bound5/AdjugateOffDiagonal.lean (one cubic inequality).
- D1Bound5/AdjugateCoverage.lean (three covering lemmas).
- D1Bound5/SignedRootAdjugateBound.lean (two ring-valued transfer theorems).
- scripts/AdjugateIntegrationAudit.lean (transitive axiom and elaborated-type audit).

The first three were copied from existing compiled exploratory files, only their imports rewired and trailing inline exploration audit commands removed. Original exploration files remain unchanged. The dedicated script now holds the axiom audit. No admitted mathematical assumptions were added.

The original one-time integrated root build before removing inline audits exited 0 (3015 jobs). A source and root-import scan after their removal passed with 52 modules and 268 explicit theorems. A final build, separate axiom audit and targeted kernel replay are pending at record creation.

## Remaining obligations

The separate direct symmetric determinant bound has been proved only in an isolated exploratory module and is not yet integrated. The full A>=3 product-four lemma also needs the arithmetic determinant lower bound and final assembly. The mixed A>=1,B>=3 branch, arbitrary-order Bennett identity, large finite certificates, and final sextuple exclusions remain open. The bound-five MainStatement has not been proved.

## Final validation receipt

Both final target and full root compilation returned exit 0 (3015 jobs). Source audit passed 52 modules and 268 explicit theorems. The twelve new theorem statements were separately elaborated and passed transitive axiom audit, with only propext, Classical.choice and Quot.sound. Four consecutive installed-Lean-kernel replays of the four new modules exited 0. Both SHA256 manifests were regenerated and checked with true exit-zero conditions. Same-kernel replays do not constitute an independent implementation review. No clean-checkout verification was performed.
