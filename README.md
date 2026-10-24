# Lean 4 formalization: a uniform bound of five for Diophantine tuples in imaginary quadratic integer rings

This repository contains the **Lean 4 formalization** of the main theorem in
[A uniform bound of five for Diophantine tuples in imaginary quadratic integer rings](https://github.com/tomislav-math/diophantine-tuples-bound-five)
by **Zrinka Franušić and Tomislav Pejković**.

Manuscript: 15 October 2026. Lean formalization completed and verified: 23 October 2026.

Let $K$ be an imaginary quadratic field and let $A$ be a finite subset of
$\mathcal O_K\setminus\{0\}$. If $ab+1$ is a square in $\mathcal O_K$ for every
pair of distinct elements $a,b\in A$, then

$$|A|\leq 5.$$

The result holds uniformly for the **full ring of integers** of every imaginary
quadratic field, including the half-integral basis cases.

The Lean theorem is `D1Bound5.main_statement : D1Bound5.MainStatement`.
Its complete dependency build, exact statement and axiom checks, and fresh
replay through the Lean kernel have passed.

| Material | Location |
|---|---|
| Paper | [Article repository](https://github.com/tomislav-math/diophantine-tuples-bound-five) · [PDF](paper/Diophantine_tuples_bound_five_2026-10-15.pdf) · [LaTeX source](paper/Diophantine_tuples_bound_five_2026-10-15.tex) |
| Main Lean theorem | [MainTheorem.lean](D1Bound5/MainTheorem.lean) |
| Formal statement and definitions | [Specification.lean](D1Bound5/Specification.lean) · [Basic.lean](D1Bound5/Basic.lean) |
| Reproduce the Lean verification | [Verification instructions](scripts/verification/README.md) |
| Numerical programs and recorded results | [Numerical verification](verification/README.md) |
| Verification evidence and dated history | [Status](STATUS.md) |

The project uses **Lean 4.33.1**. Exact Lean and mathlib versions are pinned in
[lean-toolchain](lean-toolchain), [lakefile.lean](lakefile.lean), and
[lake-manifest.json](lake-manifest.json).

