# Mixed 4x4 determinant bound — 16 October 2026

`D1Bound5/MixedFourDetBound.lean` contains five proved declarations. If a symmetric zero-diagonal 4x4 complex matrix has first-row deviations from 1/2 below 1/18 and lower-block deviations below 1/64, then its determinant has modulus below 3/10. The proof uses the mixed pair-product bound 7/192 and the exact symmetric determinant polynomial. `mixed_signed_root_det_upper` transports the estimate to a fixed integral signed-root matrix satisfying `MixedSignedEntryGood`; it is not yet the tuple-level growth theorem.

Integrated pinned build exit 0 (3024 jobs). Five exact statement/axiom checks exit 0, only propext, Classical.choice and Quot.sound. Same-kernel replay of the new module exit 0. Source/import scan exit 0 (61 modules, 308 explicit theorems); both SHA-256 manifests exit 0 (64 and 26 paths). Logs: `local-logs/mixed-det-hourly14-*`. No independent external review or clean-checkout verification.

Next: prove the mixed adjugate operator bound for the SAME signed matrix; combine with the existing arithmetic determinant lower estimate, rank-one bound and weighted numerical closure. Product-five, Bennett determinant identity, finite descent and global bound five remain open.
