#!/usr/bin/env python3
"""Apply the author's accepted proposals with exact replacement records."""
from pathlib import Path
from hashlib import sha256
import json,re,difflib
ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'upload/D1_bound5-v1(1).tex';OUT=ROOT/'output/D1_bound5-v2.tex'
EXPECTED='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
assert sha256(SRC.read_bytes()).hexdigest()==EXPECTED
original=SRC.read_text();text=original;edits=[];dispositions=[]
def change(old,new,id,reason=''):
 global text
 assert text.count(old)==1,(id,text.count(old),old)
 line=text.count('\n',0,text.index(old))+1
 edits.append({'id':id,'line_at_application':line,'old':old,'new':new,'reason':reason})
 text=text.replace(old,new)
def load(path):return json.loads((ROOT/path).read_text())
def batch(items,id):
 for e in items:change(e['old'],e.get('replacement',e.get('new')),id,e.get('reason',''))
def prose(old,new,id):
 # Whitespace-only variations in an already accepted sentence are harmless.
 variants=[old,re.sub(r'\$([^$]+)\$',lambda m:r'\('+m.group(1)+r'\)',old)]
 hits=[]
 for variant in variants:
  pattern=r'\s+'.join(re.escape(v) for v in variant.split())
  hits=list(re.finditer(pattern,text))
  if hits:break
 assert len(hits)==1,(id,len(hits),old)
 change(hits[0].group(),new,id)

batch(load('review_v1/agents/P02_combined.json')['edits'],'P02')
batch(load('comments_v1/approximation/with_P02_proposal.json')['edits'],'CA1-CA2')
batch(load('comments_v1/independent/integrated_guarded_replacements.json')['replacements'],'IR')
for p in load('comments_v1/notation.json')['proposals']:
 if p['id'] in ('N01','N02','N03','N05'):batch(p['edits'],p['id'])
dispositions.append({'id':'N04','status':'not applied','reason':'Optional basis-parameter harmonization was not recommended as necessary. Existing local definitions are consistent.'})

prose('The large-circle contribution vanishes, since $P>k+1/2$, and the two boundary values differ in modulus by $2t^{k+1/2}$.',
 'The large-circle contribution vanishes, since $P>k+1/2$, and the\ndifference of the two boundary values of the numerator has modulus\n$2t^{k+1/2}$.','P01')
prose('If $s=\\log_{10}S\\ge49$, this contradicts \\eqref{sm:five-uniform-continuous}. The difference $s-227/5-(4047/25)/(s-4)$ is increasing and equals $1/375$ at $49$.',
 'If $s=\\log_{10}S\\ge49$, then $400<10^3$ gives\n$\\log_{10}D>8s-3$. This contradicts\n\\eqref{sm:five-uniform-continuous}, since\n$(8s-3)-g(s)=s-227/5-(4047/25)/(s-4)$ is increasing\nand equals $1/375$ at $49$.','P03')
prose('For six ordered entries with anchor moduli $A\\le B\\le S\\le T$, interpolation modulus $P$ and final modulus $Q$, assume',
 'Let $a,b,s,t,p,q$ be six distinct tuple entries, with moduli\n$A\\le B\\le S\\le T\\le P\\le Q$. Assume','P04')
change('Full-ring parity makes \\(k\\) an integer.',
 'If $\\Delta$ is odd, then $e\\equiv f$ and $g\\equiv h\\pmod2$.\nIf $\\Delta$ is even, then $e$ and $g$ are even.\nIn either case $k$ is an integer.','P05')
prose('The coherent integral root matrix of order four is nonsingular by the even-dimensional congruence above. We estimate its determinant more closely.',
 'The $4\\times4$ integral matrix constructed above is nonsingular by\nthe same congruence argument. We now sharpen the determinant estimate.','P06i')
prose('These choices, made coherently for all anchors, define',
 'We call the fixed entries $a_1,\\ldots,a_m$ the anchors.\nWith the common branch choices above, define','P06ii')
prose('In particular the ordinary all-order construction has its strict $C>4B,\\ AC>1000$ hypotheses.',
 'In particular, the two-entry construction in\nProposition~\\ref{lem:ordinary-all-orders} applies because\n$C>4B$ and $AC>1000$.','P06iii')
change('\\paragraph{All junctions.}','\\paragraph{Overlap of consecutive intervals.}','P06v')
change('\\paragraph{Coverage and the infinite tail.}','\\paragraph{Exclusion of all remaining values of $D$.}','P06v')
prose('The ordinary consecutive-overlap quotient increases by $(R_2/H_2)^2$ on incrementing its order.',
 'The ratio of the upper endpoint of $O_j$ to the lower endpoint of\n$O_{j+1}$ is multiplied by $(R_2/H_2)^2$ when $j$ increases by one.','P06vi')
dispositions.append({'id':'P06iv and conditional phrases','status':'superseded','reason':'The accepted P02 and unconditional-P changes remove those passages.'})

assert text.count(r'R_k^{\rm old}')==2
change(r'R^{\rm old}',r'R_*','P07')
for _ in range(2):
 # Each surrounding formula is recorded separately, not a blind global rename.
 pos=text.index(r'R_k^{\rm old}');start=text.rfind('\\begin{equation}',0,pos);end=text.index('\\end{equation}',pos)+len('\\end{equation}')
 old=text[start:end];change(old,old.replace(r'R_k^{\rm old}',r'R_*'),'P07')
start=text.index('\\label{eq:pr-family-parameters}');end=text.index('\\end{equation}',start)+len('\\end{equation}')
old=text[start:end];change(old,old+'\nHere $R_*$ is the residual constant for the corresponding family\nin Table~\\ref{tab:ff-parameters}.','P07')
count=text.count('N_3^{bs}');assert count==4,count
for _ in range(count):
 pos=text.index('N_3^{bs}');start=text.rfind('\n',0,pos)+1;end=text.find('\n',pos)
 old=text[start:end];change(old,old.replace('N_3^{bs}','N_{3,bs}'),'P08')

# Use the exact approved punctuation replacements, accounting for the new P chain.
report=(ROOT/'output/D1_bound5-v1_review.txt').read_text()
punct=report.split('P10. Remove the remaining prose semicolons')[1].split('P12. Shorten the Section 6 heading')[0]
for line in punct.splitlines():
 if not line.startswith('| '):continue
 quoted=re.findall('“([^”]+)”',line)
 if len(quoted)!=2:continue
 old,new=quoted
 old=old.replace('N_3^{bs}','N_{3,bs}');new=new.replace('N_3^{bs}','N_{3,bs}')
 # The source mixes dollar and parenthesized inline delimiters.
 choices=[old,re.sub(r'\$([^$]+)\$',lambda m:r'\('+m.group(1)+r'\)',old)]
 found=None
 for c in choices:
  pattern=r'\s+'.join(re.escape(v) for v in c.split());hits=list(re.finditer(pattern,text))
  if hits:
   hit=hits[0];found=hit.group();break
 if found is not None:
  if text.count(found)>1:
   begin=text.rfind('\n',0,hit.start())+1;end=text.find('\n',hit.end())
   context=text[begin:end];change(context,context.replace(found,new),'P10-P11')
  else:change(found,new,'P10-P11')
 elif 'leading absolute coefficient sums' in old:dispositions.append({'id':'P10 removed P0 prose','status':'superseded','reason':'Whole P0 residual argument removed.'})
 else:raise AssertionError(('punctuation sentence missing',old))
change('\\section{Exclusion when every entry has modulus at least three}',
 '\\section{Entries of modulus at least three}','P12')
change('\\cite{W}','\\cite[Lemma~3.1]{W}','P13')
change('\\cite{Cipu25}','\\cite[pp.~27--30]{Cipu25}','P13')
old='''Extensions of $\\{1,3\\}$ in
$\\mathbb Z[\\sqrt{-d}]$ were studied by Franu\\v{s}i\\'c~\\cite{F10} and
Kreso and Franu\\v{s}i\\'c~\\cite{FK11}. Here this pair is covered by the
same approximation estimates as the other pairs. We do not determine
whether the bound of five is attained.'''
new='''Franu\\v{s}i\\'c~\\cite[Theorem~1]{F10} proved that
$\\{1,3\\}$ cannot be extended to a Diophantine quintuple in
$\\mathbb Z[\\sqrt{-d}]$ for positive squarefree $d\\ne2$.
Franu\\v{s}i\\'c and Kreso~\\cite[Corollary~1.2]{FK11} treated $d=2$.
For $d\\equiv3\\pmod4$, this subring is properly contained in
$\\mathcal O_K$. We handle the pair in the full ring of integers using
the same approximation estimates as for the other pairs. We do not
determine whether the bound of five is attained.'''
change(old,new,'P13-P14-FK')
start=text.index('\\bibitem{FK11}');end=text.index('\\bibitem{JZ}',start)
change(text[start:end],'''\\bibitem{FK11} Z.~Franu\\v{s}i\\'c and D.~Kreso, Nonextensibility
of the pair $\\{1,3\\}$ to a Diophantine quintuple in
$\\mathbb Z[\\sqrt{-2}]$, \\emph{J. Comb. Number Theory}
\\textbf{3} (2011), no.~3.
\\href{https://web.math.pmf.unizg.hr/~fran/clanci/dz-web.pdf}{Author's version}.
\\href{https://doi.org/10.48550/arXiv.1312.5241}{Preprint doi:10.48550/arXiv.1312.5241}.

''','FK-bibliography','Published author order/title/year. Disputed journal pages omitted. Existing preprint DOI explicitly remains a preprint identifier.')

# Apply numbering economy only after all useful new references have been added.
unused=['eq:coherent-form','eq:ff-zcomparison','eq:ff-two-det','eq:ff-beta','eq:ff-two-inequality','eq:ff-two-endpoints','eq:ff-pzero','eq:ff-pcancel','eq:ff-pdet','eq:ff-pdegrees','eq:ff-qguards','eq:ff-Q','sm:six-V-hypotheses','sm:six-V-constants','sm:five-two-small-lower','sm:five-bounded-four-lower','eq:pr-family-parameters','eq:pr-ratio-residual','eq:pr-pair-defect','eq:pr-fixed-M','eq:pr-fixed-R','eq:pr-fixed-Rp','eq:fixed56-residual','eq:fixed56-cutoff']
for label in unused:
 marker='\\label{'+label+'}'
 if marker not in text:continue
 if re.search(r'\\(?:ref|eqref|pageref)\{'+re.escape(label)+r'\}',text):
  dispositions.append({'id':'P09 '+label,'status':'retained','reason':'Referenced after accepted changes.'});continue
 pos=text.index(marker);start=text.rfind('\\begin{equation}',0,pos);end=text.index('\\end{equation}',pos)+len('\\end{equation}')
 assert start>=0 and text[start:pos].count('\\begin{')==1,label
 old=text[start:end];new=old.replace('\\begin{equation}','\\begin{equation*}').replace('\\end{equation}','\\end{equation*}').replace(marker,'')
 change(old,new,'P09',label)
change('\\newcommand{\\NN}{\\mathrm N}\n','','P09 unused macro')
for label in ['sec:structural-growth','sec:coherent-interpolation','sec:finiteforms','sec:all-large','sec:small-entries','sec:pair-reduction','sec:fixed56','lem:ordinary-all-orders','lem:pr-field24','prop:pr-S15']:
 marker='\\label{'+label+'}'
 if marker in text and not re.search(r'\\(?:ref|eqref|pageref)\{'+re.escape(label)+r'\}',text):change(marker,'','P09 unused source label',label)

# Dependent corrections identified by the independent review of actual v2.
change('For $d\\equiv3\\pmod4$, this subring is properly contained in\n$\\mathcal O_K$.',
 'For $d\\equiv3\\pmod4$, the ring $\\mathbb Z[\\sqrt{-d}]$ is properly contained\nin the full ring of integers of $\\mathbb Q(\\sqrt{-d})$.',
 'QA01','Make the field in the new historical statement explicit before K is parameterized.')
change('They are listed,\nwith their fourth-entry bounds, in the final finite-prefix table below.',
 'They are listed, together with their cutoffs $N_0$, in\nTable~\\ref{tab:fixed56}.',
 'QA02','Describe the final table after deletion of the fourth-entry search.')
old='\\begin{equation}\\label{eq:ff-pguards}\n C\\ge200S,\\qquad AC\\ge1000,\\qquad C\\ge1000.\n\\end{equation}'
change(old,old.replace('equation}','equation*}').replace('\\label{eq:ff-pguards}',''),
 'QA03','The unconditional rank proof removed the only reference to this numbered display. Keep all hypotheses unchanged.')
change(' \\epsilon=\\frac1{4000},\\quad h=\\frac{4001}{3999},\\quad\n',
 ' \\epsilon=\\frac1{4000},\\quad h=\\frac{4001}{3999}.\n',
 'QA04','Remove a trailing empty spacing command and end the constant-definition display.')

labels=re.findall(r'\\label\{([^}]+)\}',text);refs=re.findall(r'\\(?:ref|eqref|pageref)\{([^}]+)\}',text)
assert len(labels)==len(set(labels));assert not set(refs)-set(labels),set(refs)-set(labels)
assert '\\date{}' in text and '\\documentclass[12pt]{article}' in text
assert original.split('\\begin{document}')[0].replace('\\newcommand{\\NN}{\\mathrm N}\n','')==text.split('\\begin{document}')[0]
assert sha256(SRC.read_bytes()).hexdigest()==EXPECTED
OUT.write_text(text)
record={'baseline':str(SRC.relative_to(ROOT)),'baseline_sha256':EXPECTED,'output':str(OUT.relative_to(ROOT)),'output_sha256':sha256(OUT.read_bytes()).hexdigest(),'edits':edits,'dispositions':dispositions,'number_of_edits':len(edits),'baseline_lines':len(original.splitlines()),'output_lines':len(text.splitlines()),'undefined_references':[],'font_margins_packages_unchanged':True,'original_preserved':True}
(ROOT/'revision_v2/change_register.json').write_text(json.dumps(record,indent=2)+'\n')
(ROOT/'revision_v2/D1_bound5-v1_to_v2.diff').write_text(''.join(difflib.unified_diff(original.splitlines(True),text.splitlines(True),fromfile='D1_bound5-v1.tex',tofile='D1_bound5-v2.tex')))
print(json.dumps({k:v for k,v in record.items() if k not in ('edits','dispositions')},indent=2))
