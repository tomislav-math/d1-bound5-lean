# All-degree complete-homogeneous variable-adjunction identity — 17 October 2026

Status: six separately compiled, axiom-audited Lean theorems, not imported into the accepted D1Bound5 root.

## Mathematical unit

For a finite index type I, a commutative semiring R, and any assignment a : Option I → R, define H_n(a) to be the evaluation of Mathlib's complete homogeneous symmetric polynomial MvPolynomial.hsymm (Option I) R n. Write z=a none and b(i)=a(some i). The proofs establish, for all n≥0,

    H_(n+1)(a) = z * H_n(a) + H_(n+1)(b),

and the all-degree convolution formula

    H_n(a) = sum_(j=0)^n z^(n-j) * H_j(b).

These identities require neither distinct nor nonzero variable values and hold in every commutative semiring, including arbitrary characteristic. The underlying finite multiset polynomial is identified with mathlib's hsymm under the algebra evaluation homomorphism, using the certified equivalence Sym (Option I) (n+1) ≃ Sym (Option I) n ⊕ Sym I (n+1). The sum recursion is then iterated by induction.

## Verification and honest scope

Source: HsymmOptionSplitTrial.lean, mirrored at exploration/HsymmOptionSplitTrial.lean for isolated compilation. The six declarations are homogeneousMultisetSum_eq_hsymm, homogeneousMultisetSum_option_succ, homogeneousMultisetSum_zero, homogeneousMultisetSum_option_closed, hsymm_aeval_option_succ, hsymm_aeval_option_closed.

Failed trial01 exposed a missing multiset-product homomorphism reduction; trial03 exposed an incorrect rewrite target in the induction. Corrected trial04 compiled. The pinned .olean build completed with exit code zero. All six elaborated theorem types and all six transitive axiom lists are present in logs/pinned-olean-build.log; allowed axioms only: propext, Classical.choice, Quot.sound. No sorry, admit, sorryAx, native_decide or new mathematical axioms were accepted. The first two direct leanchecker attempts could not locate an .olean stored outside Lake's build lib path; they were technical path errors, not proof failures. After compiling the source to .lake/build/lib/lean/exploration/HsymmOptionSplitTrial.olean, targeted installed same-kernel replay with `lake env leanchecker --fresh --verbose exploration.HsymmOptionSplitTrial` completed with EXIT 0 (192.48 seconds). Evidence: logs/leanchecker-final.log.

This is useful combinatorial infrastructure for identifying the already formalized all-order Lagrange remainder coefficient with H_k. That identification for arbitrary node count is still NOT formally proved. It also does not supply analytic interpolation error estimates, arbitrary-order Bennett determinants, finite certificate coverage or the final sextuple exclusions.

No root import, fresh clean-checkout build, whole-project kernel replay, independent proof review or global D1 bound-five proof is claimed.
