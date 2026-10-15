# Final literature, exposition and accepted-change coverage review

**Status: passed for the scope below.** Three small issues found during this pass were corrected and rechecked: the field in the historical subring sentence, the description of the final table after removal of the fourth-entry search, and an equation number whose only reference disappeared with the old rank proof. No further change is recommended from this review.

Final source: `output/D1_bound5-v2.tex`, 3904 lines, SHA-256 `5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70`.

Change register: `revision_v2/change_register.json`, 122 edits, SHA-256 `51fbaee020732f434f5a67f1ea7af8a7d2f465a68e162fd7824c840810c17ffd`.

## Read scope and conclusions

I scanned the source's prose throughout all sections, checked all captions, and reread the substantive changed passages with their surrounding formulas. The full introduction and bibliography were read directly in the final source. Source-wide inventories cover all citation commands, labels and references, semicolons, accepted notation changes, and remnants of the deleted constructions. The final four QA edits were inspected separately. This is a fresh editorial/dependency review of the resulting source, **not** a claim to have independently re-proved every unchanged estimate or repeated every finite computation.

The title and abstract still describe the proved upper bound without claiming that five is attained. Removing the fourth-entry search does not invalidate the abstract's reference to finite computations: first-pair and third-entry enumerations, extension graphs, finite endpoint checks and their tables remain. The final proof uses the analytic cutoff and the new elementary finite-complement argument consistently.

The new historical sentence is precise. For positive squarefree d≠2 it attributes the subring nonextension theorem to Franušić, and for d=2 to Franušić–Kreso. For d≡3 mod4 it now explicitly names the corresponding field Q(sqrt(-d)); it no longer refers prematurely to an unrelated arbitrary K. The present full-ring proof remains internal to the manuscript. The distinction between algebraic integer tuple roots and auxiliary complex roots, the allowance for zero square values, equal moduli and half-integral coordinates, and the lack of a unique-factorization assumption are preserved.

The notation intentionally retained after the deletions is relevant:

- The structural scalar P₀ and J₀ in the fourth-entry determinant bound remain. They are unrelated to the deleted six-row approximation family.
- H₀ and R₀ in the Section 8 infinite-tail argument remain ordinary-family bases, not remnants of the deleted universal-row estimate.
- Section 8's phase estimate remains necessary for its five-region and fixed-pair calculations. Section 6's superseded phase maximization is gone.
- The fourth-entry cutoff N₀ remains essential. Its binary search computes thresholds for rational inequalities; it is not the deleted enumeration of fourth entries.
- The final 56-row table retains its first six columns exactly, including every N₀. Only the obsolete fourth-entry norm column is removed.

No additional invented terminology or new sweeping prose claim was introduced by these changes. The local word “anchors” now has an explicit definition. Existing mathematical family labels still identify the formulas needed in the tables. There is no reason for further global renaming.

## All citation occurrences and bibliography entries

The final source has **10 citation occurrences and 8 bibliography entries**. Every entry is cited, every citation resolves, and the precise locators refer to the inspected passages below.

| Key and final location | Claim/scope checked | Primary evidence and locator | Status and limits |
|---|---|---|---|
| A, introduction line 39 | Historical uniform bound 42 | [Author preprint](https://arxiv.org/pdf/1807.01896v1), Theorem 5.1; [publication DOI](https://doi.org/10.1142/S1664360719500206) | The theorem excludes m≥43. Publisher-deposited metadata supports volume 11 (2021), article 1950020. The publication PDF was not independently available; the mathematical passage inspected is the author preprint. |
| CF, introduction line 41 | Bound 24 for both signs in full imaginary quadratic integer rings | [Publisher abstract and metadata](https://londmathsoc.onlinelibrary.wiley.com/doi/abs/10.1112/blms.12929) | Reopened in this pass. The abstract explicitly states nonexistence for m>24 and both signs. Volume 56, issue 1, January 2024, pp. 274–287 and DOI agree. The online-first date is September 2023, which does not change the 2024 issue citation. Full proof not reread, and no unsupported theorem number added. |
| Bennett96, introduction line 58 and construction line 987 | Construction attribution; exact all-order determinant identity | [Original paper](https://personal.math.ubc.ca/~bennett/B-Binom.pdf), printed p. 1721, (2.1)–(2.4) and the following determinant; [DOI](https://doi.org/10.1090/S0002-9947-96-01480-8) | Relevant original passage reread. The cited specialization and the manuscript's explicit complex-variable extension paragraph are preserved. Bibliography volume 348 (1996), no. 5, pp. 1717–1738 agrees. A new elementary proof is not silently required or claimed supplied. |
| JZ, introduction line 59 and construction line 948 | Relative contour/residue construction | [Author copy](https://mapmf.pmfst.unist.hr/~borka/files/PellEqIJNTV3_kopija.pdf), §7; [DOI](https://doi.org/10.1142/S1793042106000735) | The citation is to the construction, not an unqualified application of its final approximation theorem. The local clearing factors and estimates remain proved in the manuscript. Author names, title, volume 2 (2006), no. 4, pp. 569–590 agree with the original and publisher-deposited metadata. |
| W, introduction line 63 | 3×3 root-matrix nonvanishing argument | [Pinned author preprint](https://github.com/natanaelwf/Solving-Open-Problems/blob/768dda32edc7166f9dd094b419df250b1e008531/dujella-problems-1.12-1.13/README.md), Lemma 3.1 | The pinned lemma was reread. It is credited as a preprint, with the author/date/commit recorded. The manuscript does not claim to use or validate the later quantitative Subspace Theorem argument. |
| Cipu25, introduction line 66 | Symmetric-pair factorization attribution | [Author's conference slides](https://web.math.pmf.unizg.hr/~congress/Dubrovnik25/Slides-NT-25/Cipu.pdf), PDF pp. 27–30 | These four pages were inspected again. The locator is to PDF slide pages, and the entry continues to identify slides/joint work in progress, not a journal article. The current proof supplies its own argument. |
| F10, introduction line 66 | Nonextension of {1,3} in Z[sqrt(-d)] for positive squarefree d≠2 | [Journal paper](https://cs.uwaterloo.ca/journals/JIS/VOL13/Franusic/franusic4.pdf), Theorem 1, p. 2; [journal record](https://cs.uwaterloo.ca/journals/JIS/VOL13/Franusic/franusic4.html) | Original theorem reread and journal page reopened. The source uses a negative radicand parameter; the manuscript's positive-d notation translates it correctly. Theorem 1 alone is the precise locator for this claim. Proposition 2 concerns rationality of a third entry and is appropriately omitted from this citation. Volume 13 (2010), Article 10.9.6 is correct. |
| FK11, introduction line 69 | Completion of the d=2 subring case | [Author-hosted paper](https://web.math.pmf.unizg.hr/~fran/clanci/dz-web.pdf), Corollary 1.2, PDF p. 2; [author publication list](https://web.math.pmf.unizg.hr/~fran/papers.html), entry 7 | Published author order Franušić–Kreso, sqrt(-2) title, journal volume 3 (2011), no. 3 are supported. The source numbering remains Corollary 1.2. Disputed pages are omitted. The retained arXiv DOI is expressly labelled a preprint DOI. |

For FK11, author records still disagree between pages 1–15 and 151–165. The latter appears in [Kreso's own 2014 thesis](https://diglib.tugraz.at/download.php?id=576a7cf8ee90d&location=aleph), printed pp. xi and 84. No publisher-final pagination or journal DOI was established. The final manuscript does not pretend otherwise. Detailed evidence and access limits remain in `comments_v1/literature/FK_publication_check.md`.

The source working copies and their hashes are indexed in `review_v1/agents/literature_source_index.json`; the FK author copy is separately recorded in the comments report. No full copyrighted paper needs to be included in the deliverable archive. This review adds no exhaustive novelty claim. The earlier targeted literature search supports the historical framing, but is not a priority certificate.

## Accepted-recommendation coverage ledger

| Proposal | Final disposition |
|---|---|
| P01 | Correct numerator branch-jump statement present. |
| P02 | Stronger fourth-entry lemma and K=400 applied; obsolete Section 6 phase calculation removed. |
| P03 | The 400<10³ weakening and logarithmic difference are explicit. |
| P04 | All six entries a,b,s,t,p,q named before the common interval calculation. |
| P05 | Odd/even discriminant parity cases explicit. |
| P06 | Local matrix/construction wording, anchor definition, headings and endpoint-ratio explanation applied. The old P/P₀ assignment is superseded by CA-1. The conditional wording for declining P02 is correctly not reintroduced. |
| P07 | R^{old} notation replaced by the defined family constant R_*. |
| P08 | N_{3,bs} used consistently. |
| P09 | Unused displayed equation numbers removed, including newly unused `eq:ff-pguards` after CA-1. Newly needed section/proposition labels retained. Statement numbering preserved; unused macro removed. |
| P10 | No prose/caption semicolons remain. The sole semicolon is the mathematical R/T display separator. The deleted universal-row paragraph requires no punctuation replacement. |
| P11 | Four local prose-colon changes applied. The valid Δ≤64 cutoff is unchanged. |
| P12 | Short Section 6 heading applied. Layout verification belongs to the root's rendered-PDF review. |
| P13 | Four introductory locators added; F10 narrowed to Theorem 1 because P14 states only that theorem's conclusion. |
| P14 | Historical conclusion, squarefree parameter, published author order and explicit full-ring distinction present. QA01 fixes the corresponding field referent. |
| CA-1 | Integral four-row rank proof replaces extra rank conditions and the universal six-row alternative. Residual 3 and the 15-comparison chain are retained. |
| CA-2 | Coefficients are taken after forming H,V and before multiplication by binomial coefficients. |
| IR / fourth-entry-search removal | New irregular quadratic, 16 endpoint checks and the two-row annulus argument replace the search. Existing pair/triple/graph enumerations remain. All 56 table rows keep their first six columns; final proposition cites the preceding argument. QA02 updates the table description. |
| FK published metadata | Published identity replaces the preprint identity; disputed pages omitted; author-copy link added; preprint DOI clearly distinguished. |
| N01 | Analytic q renamed q₀ within the relevant proof, avoiding its field-parameter collision. |
| N02 | Stale assembly comments removed. |
| N03 | Imported H and Δ definitions restated locally. |
| N05 | Inapplicable local zero-root assurance removed while all global/descent zero allowances remain. |
| N04 | Deliberately not recommended and not an accepted-change obligation. No harmonization rewrite was introduced. |
| QA01–QA04 | Three findings of this review and the trailing empty-spacing cleanup applied and inspected. No formula changed by these final corrections. |

## Executed final controls

`revision_v2/checks/literature_coverage.py` ran successfully against the final hash. Its JSON output is `revision_v2/checks/literature_coverage.json`.

The checker independently replays all **122** registered edits from the authoritative v1: every old string matches once, and the replay is byte-for-byte equal to the delivered v2 source. This checks the relation between the register and the artifact, not the mathematical truth of each edit.

It also checks the accepted-item conditions above, the preserved 56 table rows, citation coverage, obsolete notations, and global references. Final inventory: **116 unique labels, 221 reference commands, no undefined references, no unused labels, and no unreferenced numbered display**. There are **10 citation occurrences**, **8 cited bibliography entries**, and **one mathematical semicolon**. Every check passed.

The independently derived rank/15-overlap cross-review remains at `comments_v1/literature/rank_cross_review.md`; its precise mathematical scope and conditional treatment of P02 are not expanded by this editorial pass. The revision's other numerical/proof checks are reported by their respective reviewers. No full-source mathematical certification is inferred merely from the absence of editorial findings.
