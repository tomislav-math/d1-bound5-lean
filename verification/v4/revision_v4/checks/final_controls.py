"""Release integrity, authorized-change replay, metadata and TeX controls."""
from pathlib import Path
from collections import Counter
import hashlib,json,re

root=Path(__file__).resolve().parents[2]
work=root/'revision_v4'
paper=work/'D1_bound5-v4.tex'
base=root/'output/D1_bound5-v3.tex'
new=paper.read_text(); old=base.read_text()
sha=lambda s:hashlib.sha256(s.encode()).hexdigest()
baseline_hash='a1119af75cf623411c678ea0e9b6e7dc9a3f59a931ee67384fc98be8d8373bd5'
assert sha(old)==baseline_hash
release=(work/'release_source.sha256').read_text().split()[0]
assert sha(new)==release
ledger=json.loads((work/'change_register.json').read_text())
replay=old
for item in ledger:
    assert sha(replay)==item['before_sha256'],item['id']
    assert replay.count(item['old'])==1,item['id']
    replay=replay.replace(item['old'],item['new'],1)
    assert sha(replay)==item['after_sha256'],item['id']
assert replay==new
assert len({x['id'] for x in ledger})==len(ledger)

assert old.split(r'\begin{document}',1)[0]==new.split(r'\begin{document}',1)[0]
assert old[old.index(r'\noindent\textbf{Funding.}'):]==new[new.index(r'\noindent\textbf{Funding.}'):]
assert r'\date{}' in new
assert not re.search(r'\\(?:input|include|includegraphics)\b',new)
assert not re.search(r'\\usepackage(?:\[[^\]]*\])?\{[^}]*\.sty',new)
assert not any(ord(c)<32 and c not in '\n\t\r' for c in new)

def theorem(s,label):
    hit=s.index(r'\label{'+label+'}')
    begin=s.rfind(r'\begin{',0,hit)
    env=re.match(r'\\begin\{([^}]+)\}',s[begin:]).group(1)
    end=s.index(r'\end{'+env+'}',hit)+len(r'\end{'+env+'}')
    return s[begin:end]
assert theorem(old,'thm:main')==theorem(new,'thm:main')
for env in ['theorem','proposition','lemma','corollary','proof']:
    assert old.count('\\begin{'+env+'}')==new.count('\\begin{'+env+'}'),env

old_labels=re.findall(r'\\label\{([^}]+)\}',old)
new_labels=re.findall(r'\\label\{([^}]+)\}',new)
assert len(new_labels)==len(set(new_labels))
removed=set(old_labels)-set(new_labels)
assert removed=={'tab:fixed56-windows'}
refs=re.findall(r'\\(?:eqref|ref)\{([^}]+)\}',new)
assert set(refs)<=set(new_labels),set(refs)-set(new_labels)
bib=set(re.findall(r'\\bibitem(?:\[[^\]]*\])?\{([^}]+)\}',new))
citations=[]
for s in re.findall(r'\\cite(?:\[[^\]]*\])?\{([^}]+)\}',new):citations.extend(s.split(','))
assert set(citations)<=bib
assert set(re.findall(r'\\bibitem\{([^}]+)\}',old))==bib

book='For a general account of Diophantine tuples and their connections with\nelliptic curves, see Dujella~\\cite{Dujella24}.'
assert new.count(book)==1
assert 'Our bound does not settle this question.\n'+book in new
assert 'complete output tables' not in new
assert r'\frac38ABC' not in new
assert '26859063' not in new and '166000' not in new
assert r'\frac{27M^5}{Z}+\frac{4M^3Z}{5C^4}' not in new

checkpoint=(work/'checkpoints/math_packet.tex').read_text()
def lemma_with_proof(s,label):
    a=s.index(r'\begin{lemma}\label{'+label+'}')
    b=s.index(r'\end{proof}',a)+len(r'\end{proof}')
    return s[a:b]
math_labels=['lem:product-four','lem:interpolation-parameters','lem:direct-four','lem:retained-gap']
for label in math_labels:assert lemma_with_proof(new,label)==lemma_with_proof(checkpoint,label),label
marker='It remains to treat $S,T<10^8$.'
endmarker=r'Lemma~\ref{lem:ordinary-three-normalized} at order two'
for s in [new,checkpoint]:assert marker in s and endmarker in s
assert new.split(marker)[1].split(endmarker)[0]==checkpoint.split(marker)[1].split(endmarker)[0]

build=work/'final_build'
log=(build/'D1_bound5-v4.log').read_text()
bad=[l for l in log.splitlines() if any(t in l for t in ['Overfull','Underfull','LaTeX Warning:','Package hyperref Warning:'])]
assert not bad,bad
aux=(build/'D1_bound5-v4.aux').read_text()
assert r'\newlabel{thm:main}' in aux
pdf=build/'D1_bound5-v4.pdf'
assert pdf.read_bytes().rstrip().endswith(b'%%EOF')
pages=int(re.search(r'Output written on .*\((\d+) pages,',log,re.S).group(1))
result={'status':'PASS','source_sha256':release,'baseline_sha256':baseline_hash,
 'recorded_changes':len(ledger),'exact_replay':True,'preamble_unchanged':True,
 'funding_declarations_bibliography_affiliation_unchanged':True,
 'main_theorem_unchanged':True,'single_tex_no_external_inputs':True,
 'Dujella_requested_placement':True,'removed_labels':sorted(removed),
 'new_labels':sorted(set(new_labels)-set(old_labels)),
 'math_review_carried_to_release':math_labels+['later direct-four application'],
 'tex_warnings':bad,'pages':pages,'pdf_sha256':hashlib.sha256(pdf.read_bytes()).hexdigest(),
 'scope':'Source replay, preservation and compilation checks; mathematical and page reviews are separate.'}
(work/'checks/final_controls.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
