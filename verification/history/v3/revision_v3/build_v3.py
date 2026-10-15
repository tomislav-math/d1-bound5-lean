"""Apply the accepted local v2 review with unique, reversible edit records."""
from pathlib import Path
import hashlib, json, difflib, re

ROOT=Path(__file__).resolve().parent
BASE=ROOT/'input/D1_bound5-v2.tex'
OUT=ROOT.parent/'output/D1_bound5-v3.tex'
EXPECTED='5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70'
original=BASE.read_text()
assert hashlib.sha256(BASE.read_bytes()).hexdigest()==EXPECTED
text=original
edits=[]

def replace(eid,old,new,reason,category='exposition'):
    global text
    assert text.count(old)==1,(eid,text.count(old))
    assert old != new
    edits.append({'id':eid,'category':category,'reason':reason,
                  'old':old,'new':new,'before_offset':text.index(old)})
    text=text.replace(old,new,1)

review=json.loads((ROOT/'prior_review/proposals/reviewed_register.json').read_text())
assert review['authority_sha256']==EXPECTED
for p in review['recommended']:
    replacement=p['replacement']
    reason=p['title']
    if p['id']=='EARLY01':
        replacement=replacement.replace(
            'Bounds for these combinations give gaps between the last two entries when they are nonzero.',
            'When these combinations are nonzero, bounds for them give gaps between the last two entries.')
        reason += ' The integrated exposition review clarified that the combinations, not the tuple entries, must be nonzero.'
    replace(p['id'],p['old'],replacement,reason)

replace('NAV-01',
        '\\begin{lemma}\nUnder Proposition~\\ref{prop:pr-H2}, either the first pair is',
        '\\begin{lemma}\\label{lem:pr-field}\nUnder Proposition~\\ref{prop:pr-H2}, either the first pair is',
        'Give the field-reduction lemma a stable label.','navigation')
replace('NAV-02',
        '\\begin{proposition}\nNo ordered sextuple whose first pair is $(1,3)$ or one of the pairs in',
        '\\begin{proposition}\\label{prop:pr-S15}\nNo ordered sextuple whose first pair is $(1,3)$ or one of the pairs in',
        'Give the common S<15 proposition a stable label.','navigation')
replace('NAV-03',
        'We enumerate the remaining pairs directly. For squarefree',
        'We enumerate the remaining pairs in the fields allowed by\nLemma~\\ref{lem:pr-field}. For squarefree',
        'Cite the field restriction at the finite field list.','navigation')
replace('NAV-04',
        'The norm cutoff is exact because \\(S<15\\) and the norm is integral.',
        'The norm cutoff is exact because Proposition~\\ref{prop:pr-S15}\ngives \\(S<15\\) and the norm is integral.',
        'Cite the exact S<15 reduction at the norm cutoff.','navigation')
replace('NAV-05',
        'The preceding reduction gives $S<15$. For the forty pairs in',
        'Proposition~\\ref{prop:pr-S15} gives $S<15$. For the forty pairs in',
        'Cite the reduction at the start of the fixed-triple completion.','navigation')

replace('AUTHOR-01',r'\author{}',
        r"\author{Zrinka Franu\v{s}i\'{c} \and Tomislav Pejkovi\'{c}}",
        'Copy author names and order from matrices10 .tex.','author metadata')
replace('LIT-01',
        'Ad\\v zaga obtained the uniform bound',
        'For a general account of Diophantine tuples and their connections with\n'
        'elliptic curves, see Dujella~\\cite{Dujella24}.\n\n'
        'Ad\\v zaga obtained the uniform bound',
        'Cite the requested monograph for general background only.','literature')
replace('LIT-02',
        'the same approximation estimates as for the other pairs. We do not\n'
        'determine whether the bound of five is attained.',
        'the same approximation estimates as for the other pairs.\n\n'
        'Dujella~\\cite[Problem~1.11]{DujellaOpen} asks whether a $D(1)$-quintuple\n'
        'exists in the ring of integers of an imaginary quadratic field.\n'
        'Our bound does not settle this question.',
        'State the precise connection with the open existence question; do not claim to solve it.','literature')
declarations=(ROOT/'input/declarations_verbatim.tex').read_text().rstrip('\n')
replace('DECL-01',r'\begin{thebibliography}{9}',
        declarations+'\n\n'+r'\begin{thebibliography}{99}',
        'Copy Funding and Use of artificial intelligence verbatim from matrices10 .tex; reserve two-digit bibliography labels.','declarations')
replace('LIT-03',r'\bibitem{F10}',r'''\bibitem{Dujella24} A.~Dujella, \emph{Diophantine $m$-tuples and Elliptic
Curves}, Developments in Mathematics \textbf{79}, Springer, Cham, 2024.
\href{https://doi.org/10.1007/978-3-031-56724-7}{doi:10.1007/978-3-031-56724-7}.

\bibitem{DujellaOpen} A.~Dujella, \emph{Open problems on Diophantine
$m$-tuples and elliptic curves}, version of 15 October 2026.
\url{https://web.math.pmf.unizg.hr/~duje/pdf/open2.pdf}
(accessed 15 October 2026).

\bibitem{F10}''',
        'Add exactly the verified monograph and open-problems source, without additional research papers.','literature')
replace('AUTHOR-02',r'\end{document}',r'''\bigskip
\noindent Zrinka Franu\v{s}i\'{c} and Tomislav Pejkovi\'{c}\\
Department of Mathematics, Faculty of Science\\
University of Zagreb\\
Bijenička cesta 30, 10000 Zagreb, Croatia. \texttt{fran@math.hr}, \texttt{pejkovic@math.hr}
\end{document}''',
        'Copy the identical affiliation and both emails from matrices10 .tex in a shared block; keep emails after Croatia on the same line and avoid an isolated final author block.','author metadata')

# Local layout changes, if needed after inspecting the first build, belong here.
start=text.index(r'\begin{lemma}\label{sm:bs7-unit-axes}')
end=text.index(r'\end{lemma}',start)+len(r'\end{lemma}')
statement=text[start:end]
replace('LAYOUT-01',statement,
        '\\begin{samepage}\n'+statement+'\n\\end{samepage}',
        'Keep the complete two-alternative statement of Lemma 7.7 on one page.','local layout')
start=text.rfind(r'\begin{table}',0,text.index(r'\label{sm:six-small-triples-table}'))
end=text.index(r'\end{table}',start)+len(r'\end{table}')
table=text[start:end]
fixed=table.replace(r'\begin{table}[htbp]',r'''\par\medskip
\noindent\begin{minipage}{\textwidth}
\makeatletter\def\@captype{table}\makeatother''').replace(
        r'\end{table}',r'\end{minipage}\par\medskip')
replace('LAYOUT-02',table,fixed,
        'Keep Table 3 with its classification, before the following lemma; use a local nonfloating block with the standard caption.','local layout')

OUT.parent.mkdir(exist_ok=True)
OUT.write_text(text)
newhash=hashlib.sha256(OUT.read_bytes()).hexdigest()
for e in edits:
    assert text.count(e['new'])==1,e['id']
    e['final_line_start']=text[:text.index(e['new'])].count('\n')+1
    e['final_line_end']=e['final_line_start']+e['new'].count('\n')
register={'baseline_sha256':EXPECTED,'output_sha256':newhash,
          'baseline':str(BASE.relative_to(ROOT)), 'output':'D1_bound5-v3.tex',
          'changes':edits,
          'not_applied':['Optional additional prose proposals','Global section reorder',
                         'Relocation of the long four-root lemma','Deletion of local transfer/square-test explanations'],
          'style':'Existing preamble, 12pt Latin Modern, margins, macros and empty date preserved.'}
(ROOT/'change_register.json').write_text(json.dumps(register,ensure_ascii=False,indent=2)+'\n')
(ROOT/'D1_bound5-v2_to_v3.diff').write_text(''.join(difflib.unified_diff(
    original.splitlines(keepends=True),text.splitlines(keepends=True),
    fromfile='D1_bound5-v2.tex',tofile='D1_bound5-v3.tex')))
print(json.dumps({'changes':len(edits),'source_sha256':newhash,'output':str(OUT)}))
