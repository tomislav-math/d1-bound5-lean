# Lean 4 formalization of the uniform bound of five for Diophantine tuples in imaginary quadratic integer rings

This repository contains the **Lean 4 formalization** of the main theorem in
[A uniform bound of five for Diophantine tuples in imaginary quadratic integer rings](https://github.com/tomislav-math/diophantine-tuples-bound-five)
by **Zrinka Franušić and Tomislav Pejković**.

Manuscript: 15 October 2026.

Let $K$ be an imaginary quadratic field and let $A$ be a finite subset of
$\mathcal O_K\setminus\{0\}$. If $ab+1$ is a square in $\mathcal O_K$ for every
pair of distinct elements $a,b\in A$, then

$$|A|\leq 5.$$

The result holds uniformly for the **full ring of integers** of every imaginary
quadratic field, including the half-integral basis cases. The square value zero
is allowed.

The Lean theorem is `D1Bound5.main_statement : D1Bound5.MainStatement`.
Its complete dependency build, exact statement and axiom checks, and fresh
replay through the Lean kernel have passed.

The [main theorem on Prove2Me](https://prove2.me/theorems/4bb5d407-713b-46ac-967d-97d7abf88598)
has status **Proved**. The formalization was completed on 24 October 2026.

| Material | Location |
|---|---|
| Paper | [Article repository](https://github.com/tomislav-math/diophantine-tuples-bound-five) · [PDF](paper/Diophantine_tuples_bound_five_2026-10-15.pdf) · [LaTeX source](paper/Diophantine_tuples_bound_five_2026-10-15.tex) |
| Prove2Me | [Project](https://prove2.me/missions/No_Diophantine_sextuples_in_rings_of_integers_of_imaginary_quadratic_fields) · [Verified main theorem](https://prove2.me/theorems/4bb5d407-713b-46ac-967d-97d7abf88598) |
| Main Lean theorem | [MainTheorem.lean](D1Bound5/MainTheorem.lean) |
| Formal statement and definitions | [Specification.lean](D1Bound5/Specification.lean) · [Basic.lean](D1Bound5/Basic.lean) |
| Reproduce the Lean verification | [Verification instructions](scripts/verification/README.md) |
| Numerical programs and recorded results | [Article verification guide](https://github.com/tomislav-math/diophantine-tuples-bound-five/blob/main/verification/README.md) |
| Verification evidence | [Status](STATUS.md) |

The project uses **Lean 4.33.1**. Exact Lean and mathlib versions are pinned in
[lean-toolchain](lean-toolchain), [lakefile.lean](lakefile.lean), and
[lake-manifest.json](lake-manifest.json).

The recorded output of `#print axioms D1Bound5.main_statement` is:

```text
'D1Bound5.main_statement' depends on axioms: [propext, Classical.choice, Quot.sound]
```

The full checkout contains about **1.6 GB in 43,000 tracked files**, including
about 1.4 GB of development records in `research/`. These are uncompressed
file sizes, excluding Git history and downloaded dependencies. To check the
Lean proof, only `D1Bound5/`, `scripts/`, `records/` and the root Lean and Lake
files are needed. The [verification guide](scripts/verification/README.md#download-only-the-verification-files)
gives a smaller checkout command.
