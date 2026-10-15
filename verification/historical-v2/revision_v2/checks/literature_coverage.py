#!/usr/bin/env python3
"""Source-bound editorial/citation coverage checks. Does not modify the article."""
from pathlib import Path
import re,json,hashlib,collections
ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'output/D1_bound5-v2.tex';BASE=ROOT/'upload/D1_bound5-v1(1).tex'
out=ROOT/'revision_v2/checks/literature_coverage.json'
s=SRC.read_text();base=BASE.read_text();norm=' '.join(s.split())
sha=hashlib.sha256(SRC.read_bytes()).hexdigest()
register=json.loads((ROOT/'revision_v2/change_register.json').read_text())
assert hashlib.sha256(BASE.read_bytes()).hexdigest()==register['baseline_sha256']
replay=base
for i,e in enumerate(register['edits']):
    assert replay.count(e['old'])==1,('ambiguous registered edit',i,e['id'])
    replay=replay.replace(e['old'],e['new'])
assert replay==s,'Change register does not reproduce delivered source'
assert sha==register['output_sha256']
labels=re.findall(r'\\label\{([^}]+)\}',s)
refs=re.findall(r'\\(?:eqref|ref|pageref)\{([^}]+)\}',s)
unused_displays=[]
for m in re.finditer(r'\\begin\{(equation|align|gather)\}(.*?)\\end\{\1\}',s,re.S):
    ls=re.findall(r'\\label\{([^}]+)\}',m[2])
    if not ls or not any(x in refs for x in ls):
        unused_displays.append({'line':s[:m.start()].count('\n')+1,'environment':m[1],'labels':ls})
cites=[{'line':s[:m.start()].count('\n')+1,'locator':m[1],'key':m[2]} for m in re.finditer(r'\\cite(?:\[([^]]*)\])?\{([^}]+)\}',s)]
bibs={m[1]:m[2] for m in re.finditer(r'\\bibitem\{([^}]+)\}(.*?)(?=\\bibitem|\\end\{thebibliography\})',s,re.S)}
semicolon=[{'line':i,'source':l} for i,l in enumerate(s.splitlines(),1) if ';' in l]
sec6=s.split(r'\section{Entries of modulus at least three}',1)[1].split(r'\section{Tuples with',1)[0]
finite=s.split(r'\subsection{The finite complement}',1)[1].split(r'\begin{longtable}',1)[0]
checks=[]
def chk(key,condition,note):
    checks.append({'proposal':key,'passed':bool(condition),'checked':note})
chk('P01','difference of the two boundary values of the numerator has modulus' in norm,'Correct numerator jump statement present.')
chk('P02',r'K=400' in sec6 and r'\Phi' not in sec6 and r'\beta=3456' not in sec6 and r'T>3ABS' in s,'New fourth-entry bound and uniform Section6 gap; obsolete Section6 phase calculation absent.')
chk('P03',r'400<10^3' in s and r'\log_{10}D>8s-3' in s,'Weakening of logarithmic comparison explicitly stated.')
chk('P04','Let $a,b,s,t,p,q$ be six distinct tuple entries' in s,'Six named entries precede common interval calculation.')
chk('P05',r'If $\Delta$ is odd' in s and r'If $\Delta$ is even' in s,'Both full-ring parity cases explicit.')
chk('P06',all(x in norm for x in [r'We call the fixed entries $a_1,\ldots,a_m$ the anchors.',r'Proposition~\ref{lem:ordinary-all-orders} applies because',r'\paragraph{Overlap of consecutive intervals.}',r'\paragraph{Exclusion of all remaining values of $D$.}']) and 'P_0' not in sec6,'Terminology changes present; P/P0 branch wording superseded by CA1.')
chk('P07',r'^{old}' not in s and r'R_k^{\mathrm{old}}' not in s and 'Here $R_*$ is the residual constant for the corresponding family' in s,'Historical residual notation removed and family constant identified.')
chk('P08',r'N_3^{bs}' not in s,'Relabelled family uses subscript notation.')
chk('P09',not unused_displays and r'\newcommand{\NN}' not in s,'No unused numbered display remains; obsolete macro absent. Statement numbering retained.')
chk('P10',len(semicolon)==1 and 'P_{v,2}' in semicolon[0]['source'],'Only the mathematical R/T separator semicolon remains.')
chk('P11',all(x not in norm for x in ['This root range is exhaustive:',r'$k\ne0$: otherwise',r'coexist with $-x$:']) and 'following squarefree values of $q$ with $\\Delta\\le64$.' in norm,'Explanatory colon replacements present and valid cutoff64 preserved.')
chk('P12',r'\section{Entries of modulus at least three}' in s,'Shortened heading present.')
expected_locators={'W':'Lemma~3.1','Cipu25':'pp.~27--30','F10':'Theorem~1','FK11':'Corollary~1.2'}
chk('P13',all(any(c['key']==k and c['locator']==v for c in cites) for k,v in expected_locators.items()),'Four introductory source locators present; F10 narrowed to the theorem actually invoked.')
chk('P14',r'positive squarefree $d\ne2$' in s and r"Franu\v{s}i\'c and Kreso~\cite[Corollary~1.2]{FK11}" in s and 'the full ring of integers of $\\mathbb Q(\\sqrt{-d})$' in norm,'Historical statement has correct scope, published author order, and explicit corresponding field.')
fk=bibs['FK11']
chk('FK publication',r"Z.~Franu\v{s}i\'c and D.~Kreso" in fk and r'\sqrt{-2}' in fk and r'\textbf{3} (2011), no.~3.' in fk and '151--165' not in fk and '1--15' not in fk and 'Preprint doi:' in fk,'Published metadata used; disputed pages omitted; arXiv DOI explicitly identified as preprint DOI.')
chk('CA1',r'Suppose that $F_s=0$.' in s and r'6C\le7|2s-a-b|\le28S' in s and all(x not in s for x in ['eq:ff-P0','eq:ff-p0rows','eq:ff-p0det','eq:ff-allSrank']) and r'\mathcal R(1)=\frac{35}{16}+\tau\,5268<3.' in s,'Integral nonvanishing argument replaces universal matrix and extra rank assumptions; residual3 present.')
chk('CA2','the combinations defining $H$ and $V$ already performed' in norm and 'before multiplication by the binomial coefficients' in norm,'Order of combining rows and taking absolute coefficient sums clarified.')
def table_rows(text,limit=None):
    tail=text.split(r'\label{tab:fixed56}',1)[1].split(r'\end{longtable}',1)[0]
    return [tuple(int(x.strip()) for x in l.split('\\')[0].split('&')[:limit]) for l in tail.splitlines() if re.match(r'^\d+\s*&',l)]
oldrows=table_rows(base,6);newrows=table_rows(s)
chk('IR finite complement',len(newrows)==56 and all(len(r)==6 for r in newrows) and oldrows==newrows and r'f(\sqrt{N_0})<-100' in finite and r'4\mid u,v' in finite and all(x not in finite for x in ['40000','3001','284','binary search']),'All56 rows preserve first6 columns; old fourth-norm column/search replaced by quadratic and annulus argument.')
chk('IR table description','final finite-prefix table' not in s and 'together with their cutoffs $N_0$' in norm,'Current table described by its N0 cutoffs and referenced directly.')
chk('N01',r'q_0=7/13+125/216' in s and r'\frac{7q_0}{24}' in s,'Local analytic coefficient distinguished from later field parameter.')
chk('N02','Complete finite-form construction. Requires' not in s,'Stale assembly comment removed.')
chk('N03',r'H=\prod_{i=1}^4a_i' in s and r'\Delta=\prod_{1\le i<j\le4}(a_i-a_j)' in s,'Imported H and Delta definitions restated in order-one proof.')
chk('N05','this proof also covers zero\nsquare values supplied by the tuple' not in s and 'Zero is allowed as such a square.' in s,'Locally inapplicable zero-root assertion removed; global zero-square convention retained.')
chk('Citation inventory',len(cites)==10 and len(bibs)==8 and set(c['key'] for c in cites)==set(bibs),'Ten citation occurrences match all8 bibliography entries.')
chk('References',len(labels)==len(set(labels)) and set(refs)<=set(labels),'Unique labels and no undefined reference commands.')
chk('Source replay',replay==s,'Every registered old string matched once and exact replay equals delivered source.')
result={'source':str(SRC.relative_to(ROOT)),'source_sha256':sha,'register_sha256':hashlib.sha256((ROOT/'revision_v2/change_register.json').read_bytes()).hexdigest(),'registered_edits':len(register['edits']),'register_ids':dict(collections.Counter(e['id'] for e in register['edits'])),'status':'PASS' if all(c['passed'] for c in checks) else 'PENDING_CORRECTIONS','checks':checks,'citation_occurrences':cites,'bibliography_keys':list(bibs),'label_count':len(labels),'reference_count':len(refs),'unused_labels':sorted(set(labels)-set(refs)),'unreferenced_numbered_displays':unused_displays,'semicolon_lines':semicolon,'scope':'Editorial coverage and exact change replay, not a mathematical re-proof of each change. N04 was deliberately not recommended and is not an accepted-change obligation.'}
out.write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:result[k] for k in ['status','source_sha256','registered_edits','label_count','reference_count']},indent=2))
print('Pending:',[c['proposal'] for c in checks if not c['passed']])
