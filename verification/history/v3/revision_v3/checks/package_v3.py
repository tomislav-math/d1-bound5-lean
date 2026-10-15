"""Build the self-contained v3 review bundle after the checks have passed."""
from pathlib import Path
import hashlib,json,zipfile

root=Path(__file__).resolve().parents[2]
r=root/'revision_v3'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
final=json.loads((r/'checks/final_controls.json').read_text())
assert final['status']=='PASS'
assert final['source_sha256']==sha(root/'output/D1_bound5-v3.tex')
assert final['pdf_sha256']==sha(root/'output/D1_bound5-v3.pdf')
math=json.loads((r/'agents/math_preservation.json').read_text())
assert math['source_sha256']==final['source_sha256'] and not math['findings']
v1=json.loads((r/'agents/visual_first.json').read_text())
v2=json.loads((r/'agents/visual_second.json').read_text())
assert v1['pdf_sha256']==final['pdf_sha256']
assert final['pdf_sha256'] in (r/'agents/visual_second.json').read_text()
assert set(v1['pages_reviewed'])==set(range(1,31))
assert final['source_sha256'] in (r/'agents/exposition.txt').read_text()

report=f'''D1_bound5-v3 — revision and verification record
15 October 2026

Delivered article: 59 pages. Standard article class, 12pt Latin Modern,
A4 with 24 mm margins, existing macros/packages and empty date preserved.
No custom .sty file is needed.

Source SHA256: {final['source_sha256']}
PDF SHA256: {final['pdf_sha256']}
Baseline v2 SHA256: {math['baseline_sha256']}

Changes
The 23 reversible registered edits implement the ten accepted local Armstrong
review recommendations, five navigation edits, six author/declaration/literature
edits, and two local layout repairs. The exposition review additionally clarified
one pronoun in the new interpolation introduction before acceptance. There is no
global rearrangement and no change of mathematical theorem, bound or table data.

Zrinka Franusic and Tomislav Pejkovic are named, with their diacritics, in the
article. Their shared University of Zagreb affiliation and both email addresses
were copied from matrices10 .tex (6 October 2026). Funding and Use of artificial
intelligence were copied verbatim. Every declaration word and digit was also
checked in the rendered PDF. In particular, the identifiers IP-2022-10-5008,
TEBAG, PK.1.1.10.0004 and IK IA 1.1.3. Impact4Math match the donor source.

Exactly two Dujella references were added: the 2024 monograph and the open-problems
list dated 15 October 2026. The publisher and author pages verify the monograph's
metadata and DOI. The list's Problem 1.11 asks whether an imaginary-quadratic
integer ring contains a D(1)-quintuple. The introduction explicitly says that
the present bound does not settle that existence question. No extra research
paper was added. See agents/dujella.txt for primary source URLs and snapshot hash.

Verification actually performed for v3
- Independent mathematical-preservation and exposition reviews of the integrated
  edits, tied to the final source SHA256. All 32 new explanatory sentences were
  checked against their actual proof or source context; no findings remain.
- Exact replay and reversal of the 23 edits. All 37 theorem-like statements,
  358 displayed-mathematics blocks and 15 tabular/longtable bodies are unchanged
  from v2 (statement comparison ignores only the two added navigation labels).
- Exact bounded rechecks: 15 all-large overlap comparisons, gap and tail bounds;
  enumeration of 40 pairs and 57 third entries; agreement with all 56 listed
  triples; the 38/16/2 complement split; the two exceptional congruence checks;
  and all five regional phase/gap/residual/overlap/tail comparisons.
- Clean latexmk/pdflatex compilation: no warnings, overfull or underfull boxes,
  undefined references/citations or duplicate labels. All 118 labels resolve.
- Every final PDF page inspected visually by independent reviewers (1–30 and
  31–59). Root also inspected title, dense/changed pages and final declarations,
  references and affiliation. The split Lemma 7.7 statement, Table 3 interrupting
  the next proof, and isolated final author address were repaired and rechecked.

Limits
This revision is a controlled improvement of v2. The expensive graphs through
10^550 and the full polynomial-family calculations were NOT rerun in this v3
pass. Their source formulas, bounds and tables are unchanged. The previous
D1_bound5-v2_verification.zip is included as inherited evidence, not relabelled
as a fresh v3 computation. The small numerical checks use certain printed M and
N0 values as inputs; each script/report states its scope. No mechanical check
alone is a proof of the complete article.

Package layout and reproduction
The archive preserves output/ and revision_v3/ so paths work after extraction.
Python 3 is needed; final_controls.py also needs PyMuPDF (import fitz).
From the extracted root run:
  python revision_v3/agents/math_preservation_check.py
  python revision_v3/checks/approximation_check.py
  python revision_v3/checks/completion_check.py
  python revision_v3/checks/final_controls.py
The checks are deliberately locked to this reviewed source hash.

The article compiles with ordinary LaTeX packages:
  latexmk -pdf -interaction=nonstopmode -halt-on-error output/D1_bound5-v3.tex
Compilation can update PDF metadata and its byte hash; the delivered PDF and
archived build log are the ones covered by the recorded visual review.

revision_v3/build_v3.py reproduces the source from the frozen baseline and the
accepted review register. change_register.json and D1_bound5-v2_to_v3.diff show
every edit. agents/ contains independent reports; checks/ contains scripts and
actual outputs; records/ contains provenance; render/final/ contains the 59
reviewed page images. package_manifest.json records SHA256 for every other file.
'''
(r/'D1_bound5-v3_revision_report.txt').write_text(report)
prior=root/'output/D1_bound5-v2_verification.zip'
if not prior.exists():
    prior=root/'prior_verification/D1_bound5-v2_verification.zip'
inherited={'file':'prior_verification/D1_bound5-v2_verification.zip','sha256':sha(prior),
           'status':'Inherited original verification package; not rerun during v3 exposition revision.'}
(r/'records/inherited_verification.json').write_text(json.dumps(inherited,indent=2)+'\n')
files={}
def add(p,name=None):
    assert p.is_file(),p
    files[name or p.relative_to(root).as_posix()]=p
for name in ['D1_bound5-v3.tex','D1_bound5-v3.pdf']:
    add(root/'output'/name)
for name in ['build_v3.py','change_register.json','D1_bound5-v2_to_v3.diff','D1_bound5-v3_revision_report.txt']:
    add(r/name)
for name in ['D1_bound5-v2.tex','author_metadata_source.json','declarations_verbatim.tex']:
    add(r/'input'/name)
for folder in ['agents','checks','records','prior_review','render/final']:
    for p in sorted((r/folder).rglob('*')):
        if p.is_file() and '__pycache__' not in p.parts:
            add(p)
for name in ['D1_bound5-v3.log','compile.log']:
    add(r/'build'/name)
add(prior,'prior_verification/D1_bound5-v2_verification.zip')
manifest={'source_sha256':final['source_sha256'],'pdf_sha256':final['pdf_sha256'],
          'files':[{'path':k,'sha256':sha(p),'bytes':p.stat().st_size} for k,p in sorted(files.items())]}
target=root/'output/D1_bound5-v3_verification.zip'
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as z:
    for k,p in sorted(files.items()): z.write(p,k)
    z.writestr('package_manifest.json',json.dumps(manifest,indent=2)+'\n')
print(json.dumps({'path':str(target),'bytes':target.stat().st_size,'sha256':sha(target),'files':len(files)+1},indent=2))
