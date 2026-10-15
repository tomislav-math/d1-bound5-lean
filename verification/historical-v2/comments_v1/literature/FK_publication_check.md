# FK11: published reference and conflicting pagination

Review completed 15 October 2026. No manuscript changes were made.

Manuscript checked: `upload/D1_bound5-v1(1).tex`, SHA-256 `74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228`.

## Decision

**Accept the substantive correction:** cite the published 2011 article, with **Z. Franušić followed by D. Kreso** and the title containing **sqrt(-2)**. The earlier report established that the explicit arXiv-v1 reference described that PDF accurately; it did not establish that citing that version was preferable to citing the published work. The newly inspected author publication record and author-hosted paper support the published reference.

**Do not certify the page range yet.** The two authors' own records conflict: Franušić's publication list gives **1–15**, while Kreso's January 2014 thesis gives **151–165** in both its publication list and bibliography. I did not retrieve the publisher's final article or an original issue contents page. Nothing inspected supports 197–211. Neither a majority of secondary citations nor an inferred page offset resolves this conflict.

The independently supported core entry is:

```tex
\bibitem{FK11}
Z.~Franu\v{s}i\'{c} and D.~Kreso,
\emph{Nonextensibility of the pair $\{1,3\}$ to a Diophantine quintuple
in $\mathbb Z[\sqrt{-2}]$},
J. Comb. Number Theory \textbf{3} (2011), no.~3.
\url{https://web.math.pmf.unizg.hr/~fran/clanci/dz-web.pdf}.
```

This intentionally omits the unresolved page range. It is a usable draft reference rather than a claim that the article has no pagination. If the author chooses to follow Franušić's own publication list, insert `1--15` after `no.~3`; record that this follows the author's bibliography, **not** a newly verified publisher PDF. Kreso's thesis supplies primary author evidence for the alternative `151--165`, but the present check cannot decide between them. No journal DOI was found. The arXiv DOI `10.48550/arXiv.1312.5241` identifies the preprint record and must not be presented as a journal DOI.

In the historical sentence, use `Franušić and Kreso~\cite{FK11}` when naming the authors in the published order. The relevant result remains **Corollary 1.2**. In the inspected author copy, Theorem 1.1 and Corollary 1.2 are on PDF page 2; in arXiv v1 they are on PDF page 3. I have not certified the corresponding final journal page. A theorem-number locator avoids an unsupported journal-page locator.

## Inspected primary evidence

| ID | Source and exact locator | What it establishes | What it does not establish |
|---|---|---|---|
| FK-P1 | [Franušić's publication list](https://web.math.pmf.unizg.hr/~fran/papers.html), entry 7 | Published title with sqrt(-2); author order Franušić–Kreso; journal; volume 3; year 2011; issue 3; reported pages 1–15. Its link leads to FK-P2. | It is author-maintained metadata, not an inspected final journal masthead. |
| FK-P2 | [Author-hosted paper](https://web.math.pmf.unizg.hr/~fran/clanci/dz-web.pdf), title page and PDF p. 2 | Title and author order agree with FK-P1. Corollary 1.2 excludes an extension of {1,3} to a Diophantine quintuple in Z[sqrt(-2)]. Its numbering agrees with arXiv v1. | This 14-page file has ordinary manuscript page numbers and no journal masthead, volume, issue, printed journal page range, or DOI. It cannot authenticate either reported 15-page range. Its TeX creation timestamp in March 2012 is a file-generation fact, not a publication-date correction. |
| FK-P3 | [Dijana Kreso, *Rational function decomposition and Diophantine equations*, PhD thesis, January 2014](https://diglib.tugraz.at/download.php?id=576a7cf8ee90d&location=aleph), printed p. xi, publication item [ii], and bibliography item 40, printed p. 84 | A second primary author record gives Franušić–Kreso, the sqrt(-2) title, journal volume 3 (2011), and pages 151–165. The preface identifies the included paper as already published. | It does not supply a journal masthead or settle why FK-P1 gives 1–15. |
| FK-P4 | [Nova, *Frontiers of Combinatorics and Number Theory*, Volume 3](https://novapublishers.com/shop/frontiers-of-combinatorics-and-number-theory-volume-3/), contents between the edge-maximal-graphs paper and the twelve-variable quadratic-forms paper | The publisher itself lists the paper with its sqrt(-2) title in this compilation. | The web TOC gives no chapter/page range, journal issue, or DOI, and lists only Franušić in its author line. It is not reliable evidence for dropping Kreso. It is a compilation record, not the original journal issue. |
| FK-P5 | [Nova's journal page](https://novapublishers.com/shop/journal-of-combinatorics-and-number-theory/), link labelled “browse prior individual issues” | The journal is published by Nova; the historical-issues link is `https://www.novapublishers.org/catalog/product_info.php?products_id=7065`. | Following that link redirected to Nova's home page on this check. It did not expose volume 3, issue 3 or its full text. |
| FK-P6 | [arXiv record](https://arxiv.org/abs/1312.5241) and [v1 PDF](https://arxiv.org/pdf/1312.5241v1), title page and PDF p. 3 | The 2013 v1 PDF has authors Kreso–Franušić and a title with sqrt(-d); the landing record differs in author order. The mathematical result and numbering cited above are present. | Metadata for this later preprint does not override the published article's author order/title or settle journal pagination. |

A Crossref exact-title/author query returned unrelated works rather than this article. The JSON response is retained as a reproducible negative lookup, not proof that no journal DOI exists. Search results from TU Graz Pure, CroRIS, Dujella's reference list and later research bibliographies also disagree on pagination. They were used to identify the conflict and were **not** promoted to publisher-verified facts.

## Reproducible local record and limits

- `comments_v1/literature/FK_author_journal.pdf`: 125652 bytes, SHA-256 `1b98d2473e23c44d2a247a527249a4ac6cc61640bee98870206b881ac896a59e`; title page and the result on p. 2 freshly inspected.
- `comments_v1/literature/Kreso_thesis2014.pdf`: 675081 bytes, SHA-256 `1fef2cca1306c2b841cf8142fb2002b4f954a8f3881288c186bd5b50542a12e3`; title/date, preface, publication list and bibliography entry freshly inspected. This is not a claim to have re-reviewed the entire thesis.
- `comments_v1/literature/crossref_title_query.json`: query parameters `query.title=Nonextensibility of the pair 1 3 to a Diophantine quintuple`, `query.author=Franusic Kreso`, `rows=5` at `https://api.crossref.org/works`.
- Full source PDFs and extracted texts are working copies. Exclude them from the distributable review archive; retain this report, source URLs and hashes.

**Checked:** published identity, exact author order/title, author-reported journal/year/issue, the two competing author-reported page ranges, and the cited corollary in an original author copy. **Not checked:** publisher-final PDF, final journal pagination, exact day/month of publication, or absence of a journal DOI. No claim of an exhaustive bibliographic search is made.

This bibliographic correction does not change the manuscript's mathematical dependency: the cited pair result is historical context, and the manuscript supplies its own treatment of {1,3} in the full ring of integers. Nothing in this check creates a requirement to publish computational code.
