# Manuscript

**A uniform bound of five for Diophantine tuples in imaginary quadratic integer rings**

Zrinka Franušić and Tomislav Pejković

15 October 2026

- [Read the paper (PDF)](Diophantine_tuples_bound_five_2026-10-15.pdf)
- [LaTeX source](Diophantine_tuples_bound_five_2026-10-15.tex)
- [Article repository and current numerical verification](https://github.com/tomislav-math/diophantine-tuples-bound-five)

This is the manuscript underlying the completed Lean formalization.
The supplied PDF has 58 pages. Earlier working versions and their numerical
checks are retained in the [verification archive](../verification/README.md).

The article is a standalone TeX file using standard packages, with no custom
`.sty` files. A TeX Live installation with Latin Modern and `latexmk` can build
it from the repository root:

```sh
mkdir -p /tmp/d1-bound5-pdf
latexmk -pdf -interaction=nonstopmode -halt-on-error \
  -outdir=/tmp/d1-bound5-pdf paper/Diophantine_tuples_bound_five_2026-10-15.tex
```

The recorded comparison with the archived manuscript input is in
[date_only_checks.json](date_only_checks.json).
