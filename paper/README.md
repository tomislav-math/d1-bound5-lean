# Manuscript

**A uniform bound of five for Diophantine tuples in imaginary quadratic integer rings**

Zrinka Franušić and Tomislav Pejković

15 October 2026

- [Read the paper (PDF)](D1_bound5-v4-dated.pdf)
- [LaTeX source](D1_bound5-v4-dated.tex)
- [Numerical verification programs and instructions](../verification/README.md)

This is v4 with an explicit date below the authors. The only source change
from the frozen verified v4 is `\date{} -> \date{15 October 2026}`.
The mathematics, funding, AI declaration, affiliations and bibliography are
unchanged. Keeping the `v4-dated` name distinguishes this reading copy while
preserving v4 as the target of the ongoing Lean formalization.

The article is a standalone TeX file using standard packages, with no custom
`.sty` files. A TeX Live installation with Latin Modern and `latexmk` can build
it from the repository root:

```sh
mkdir -p /tmp/d1-bound5-pdf
latexmk -pdf -interaction=nonstopmode -halt-on-error \
  -outdir=/tmp/d1-bound5-pdf paper/D1_bound5-v4-dated.tex
```

The supplied PDF has 58 pages. `date_only_checks.json` records the scoped
release checks. Adding the date moves a small amount of text between pages
1 and 2; all manuscript text is preserved apart from the displayed date.

The repository remains private. No public release or licence has been selected.
