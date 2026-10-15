"""Reproduce final source, declaration, compilation and PDF metadata controls."""
from pathlib import Path
import argparse, hashlib, json, re, unicodedata
import fitz

parser=argparse.ArgumentParser()
parser.add_argument('--root',type=Path,default=Path(__file__).resolve().parents[2])
root=parser.parse_args().root.resolve()
r=root/'revision_v3'
source=root/'output/D1_bound5-v3.tex'
pdf=root/'output/D1_bound5-v3.pdf'
expected='a1119af75cf623411c678ea0e9b6e7dc9a3f59a931ee67384fc98be8d8373bd5'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(source)==expected
t=source.read_text()
register=json.loads((r/'change_register.json').read_text())
assert register['output_sha256']==expected
reverse=t
for c in reversed(register['changes']):
    assert reverse.count(c['new'])==1,c['id']
    reverse=reverse.replace(c['new'],c['old'],1)
assert reverse.encode()==(r/'input/D1_bound5-v2.tex').read_bytes()
assert sha(r/'input/D1_bound5-v2.tex')==register['baseline_sha256']

labels=re.findall(r'\\label\{([^}]+)\}',t)
assert len(labels)==len(set(labels))
references=re.findall(r'\\(?:ref|eqref|pageref)\{([^}]+)\}',t)
assert set(references)<=set(labels)
bibkeys=re.findall(r'\\bibitem\{([^}]+)\}',t)
assert len(bibkeys)==len(set(bibkeys))==10
cites=[k.strip() for group in re.findall(r'\\cite(?:\[[^]]*\])?\{([^}]+)\}',t) for k in group.split(',')]
assert set(cites)<=set(bibkeys)
assert {k for k in bibkeys if k.startswith('Dujella')}=={'Dujella24','DujellaOpen'}
assert r'\date{}' in t
assert not re.search(r'\\(?:input|include)\{',t)
assert r'\documentclass[12pt]{article}' in t

log=(r/'build/D1_bound5-v3.log').read_text()
warnings=[x for x in log.splitlines() if any(s in x for s in ['Warning','Overfull','Underfull','undefined','multiply defined'])]
assert not warnings,warnings
assert 'Output written on ' in log
doc=fitz.open(pdf)
assert len(doc)==59
page_text=[]
for page_number,p in enumerate(doc,1):
    lines=p.get_text().rstrip().splitlines()
    assert lines[-1].strip()==str(page_number)
    page_text.append('\n'.join(lines[:-1]))
pdftext='\n'.join(page_text)
assert '??' not in pdftext
declarations=(r/'input/declarations_verbatim.tex').read_text().strip()
assert declarations in t
donor=json.loads((r/'input/author_metadata_source.json').read_text())
assert declarations in donor['tail_text']
plain=re.sub(r'\\(?:par|medskip|noindent)\b','',declarations)
plain=re.sub(r'\\textbf\{([^}]+)\}',r'\1',plain)
def normalized(s):
    return ''.join(c.lower() for c in unicodedata.normalize('NFKD',s) if c.isalnum())
pdfdecl=pdftext[pdftext.index('Funding.'):pdftext.index('References',pdftext.index('Funding.'))]
assert normalized(plain)==normalized(pdfdecl),'Declaration words or digits differ in rendered PDF'
metadata=json.loads((r/'records/author_metadata.json').read_text())
for token in metadata['funding_project_identifiers']:
    assert token in t and normalized(token) in normalized(pdfdecl),token
for name,email in metadata['emails']:
    assert name in pdftext and email in pdftext
email_lines=[line for p in doc for line in p.get_text().splitlines() if 'fran@math.hr' in line]
assert len(email_lines)==1 and all(s in email_lines[0] for s in ['Croatia.','fran@math.hr','pejkovic@math.hr'])
assert any('Problem 1.11' in p.get_text() for p in doc)
render=json.loads((r/'records/final_render.json').read_text())
assert render['source_sha256']==expected and render['pdf_sha256']==sha(pdf)
result={'status':'PASS','source_sha256':expected,'pdf_sha256':sha(pdf),'pages':len(doc),
        'reversible_registered_edits':len(register['changes']),'labels':len(labels),
        'all_references_and_citations_resolved':True,'bibliography_entries':len(bibkeys),
        'warnings':warnings,'declarations_exact_in_donor_and_tex':True,
        'declaration_words_and_digits_exact_in_pdf':True,
        'funding_identifiers_checked':metadata['funding_project_identifiers'],
        'author_names_and_emails_present':True,'both_emails_on_country_line':True,
        'standalone_standard_latex_source':True}
(r/'checks/final_controls.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
