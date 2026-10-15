"""Assemble the diagnostic review. Never writes an article source."""
from pathlib import Path
import hashlib, json, re

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'input/D1_bound5-v2.tex'
SHA = '5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70'
assert hashlib.sha256(SRC.read_bytes()).hexdigest() == SHA
source = SRC.read_text()
all_p = {}
for name in ['early', 'approximation', 'small', 'completion']:
    obj = json.loads((ROOT / f'proposals/{name}.json').read_text())
    for proposal in obj.get('proposals', obj.get('patches', [])):
        p = dict(proposal)
        p['origin'] = f'proposals/{name}.json'
        all_p[p['id']] = p

# Integrate the independent review corrections in the PROPOSAL REGISTER only.
all_p['SM-01']['replacement'] = all_p['SM-01']['replacement'].replace(
    'construct the graph on all common extensions inside that disk',
    'construct the graph on their common extensions of modulus at least three inside that disk')
all_p['SM-03']['replacement'] = all_p['SM-03']['replacement'].replace(
    'The first case will be excluded by comparing the growth alternatives in Lemma~\\ref{sm:five-small-anchor-alternative} with the height upper bound.',
    'The first case uses the growth alternatives in Lemma~\\ref{sm:five-small-anchor-alternative} and the height upper bound.')
all_p['COMP-01']['replacement'] = all_p['COMP-01']['replacement'].replace(
    'by showing that the forbidden intervals cover every\nvalue',
    'by showing that, in each range to be excluded, the forbidden intervals cover every\nvalue')
all_p['COMP-03']['replacement'] = all_p['COMP-03']['replacement'].replace(
    'displayed $R_{bs}$ bounds the relabeled residual from above.',
    'displayed $R_{bs}$ is a valid residual constant for $N_{3,bs}$.')

all_p['COLD-05'] = {
    'id':'COLD-05', 'origin':'agents/cold_reader.txt',
    'old':'All their size hypotheses follow from\nLemma~\\ref{lem:retained-gap}.',
    'replacement':'Whenever Lemma~\\ref{lem:retained-gap} applies, it supplies all the size hypotheses used in this table.',
    'severity':'Low-cost clarification of the conditional scope',
    'reason':'The common interval calculation is a reusable template. Its later applications first establish the retained-gap hypotheses. Make that dependency conditional at the table entrance.',
    'mathematical_contract':'No hypothesis is removed or newly assumed. Preserve the explicit AT and T guards in the five-region and fixed-pair applications.',
    'dependencies':['lem:retained-gap','prop:pr-H2','eq:pr-fixed-fourth-gap']
}
order = ['SM-04','APP-03','EARLY02','SM-02','EARLY01','APP-02','APP-04','COMP-02','COMP-03','COLD-05']
titles = {
    'SM-04': 'Resolve the local collision between the tuple entry s and log10(S)',
    'APP-03': 'Identify P, Q, M and the relabelled/ordinary rows before the first table',
    'EARLY02': 'Make the L4 nonvanishing inference explicit',
    'SM-02': 'Identify which interpolation entry has modulus P',
    'EARLY01': 'Explain what the interpolation weights accomplish',
    'APP-02': 'Explain the role of the finite approximation families',
    'APP-04': 'Explain what the endpoint comparisons require',
    'COMP-02': 'State the upper-cutoff and lower-growth completion mechanism',
    'COMP-03': 'Identify the upward enclosure of the relabelled residual constant',
    'COLD-05': 'Make the size-condition statement conditional on the retained-gap lemma',
}
cross = {'early':'agents/cross_small_on_early.txt',
         'approximation':'agents/cross_completion_on_approx.txt',
         'small':'agents/cross_early_on_small.txt',
         'completion':'agents/cross_approx_on_completion.txt',
         'cold_reader':'agents/cross_completion_on_cold05.txt'}
for p in all_p.values():
    assert source.count(p['old']) == 1, p['id']
    p['line_start'] = source[:source.index(p['old'])].count('\n') + 1
    p['line_end'] = p['line_start'] + p['old'].count('\n')
    p['status'] = 'RECOMMENDED_UNAPPLIED' if p['id'] in order else 'OPTIONAL_UNAPPLIED'
    p['independent_review'] = cross[Path(p['origin']).stem]
    p['title'] = titles.get(p['id'], p.get('why',p.get('reason','')).split('.')[0])
    p['source_sha256'] = SHA

register = {
    'authority_sha256': SHA,
    'scope':'Diagnostic only. These replacements have NOT been applied to v2.',
    'recommended_order':order,
    'recommended':[all_p[k] for k in order],
    'optional':[p for k,p in all_p.items() if k not in order],
    'cross_review_corrections':[
        'SM-01 restricts graph vertices to modulus at least three.',
        'SM-03 avoids implying every subcase needs the height upper bound.',
        'COMP-01 restricts interval coverage to the ranges being excluded.',
        'COMP-03 identifies R_bs as a residual constant in its normalization.'
    ],
    'architecture_decisions':[
        {'id':'ARCH-01','decision':'OPTIONAL_PLACEMENT','reason':'Architecture reviewer prefers moving the complete four-root lemma near its only consumer; Section 7 reviewer prefers retaining the final case flow. Leave outside the minimal pass, or trial a location before the small-anchor-alternative lemma. No deletion. Verify references and layout if implemented.'},
        {'id':'ARCH-02','decision':'RETAIN_CURRENT_PROOF','reason':'The approximation reviewer identified functional local explanation of signs, the sharper constant and zero-root safety. Keep this self-contained transfer proof rather than force backward reading for a small line saving.'},
        {'id':'ARCH-03','decision':'DEFER','reason':'The repeated half-coordinate square test is short and makes the finite computation locally reproducible. A cross-reference is permissible but not a priority. Keep the later omega-coordinate formulation.'},
        {'id':'ARCH-04','decision':'OPTIONAL_MINOR_REDUCTION','reason':'Lines 2201–2206 repeat the already invoked four-anchor contradiction. They may be removed while retaining the hypotheses and coherent-root convention. Gain is small; no mathematical simplification follows.'},
        {'id':'ARCH-05','decision':'RECOMMEND_SECONDARY','reason':'Add stable labels to the discriminant lemma and S<15 proposition, then cite them at the finite-list introductions. Keep their statements and proofs unchanged.'},
        {'id':'ARCH-REORDER','decision':'DO_NOT_REORDER','reason':'No demonstrated gain justifies moving entire case sections. Current order is coherent.'}
    ],
    'cold_reader_decisions':[
        {'id':'COLD-01','decision':'MERGED_IN_APP-03'},
        {'id':'COLD-02','decision':'OPTIONAL_ALTERNATIVE','reason':'Do not add this introduction mechanism paragraph on top of equivalent selected section openings by default.'},
        {'id':'COLD-03','decision':'MERGED_IN_EARLY02'},
        {'id':'COLD-04','decision':'MERGED_IN_COMP-02'},
        {'id':'COLD-05','decision':'RECOMMENDED_UNAPPLIED'},
        {'id':'COLD-06','decision':'OPTIONAL_LAYOUT_PASS','reason':'After prose edits, try keeping Table 3 with its classification instead of inside the next proof, and keep Lemma 7.7 together. Recheck neighboring pages; no global preamble change.'}
    ]
}
(ROOT/'proposals/reviewed_register.json').write_text(json.dumps(register,ensure_ascii=False,indent=2)+'\n')

# Dry application in memory only, to detect conflicting replacements and changed
# statement surfaces. This is not an edited manuscript or a mathematical proof.
trial = source
for k in order:
    p = all_p[k]
    assert trial.count(p['old']) == 1, k
    trial = trial.replace(p['old'],p['replacement'],1)
pattern = r'\\begin\{(theorem|lemma|proposition|corollary)\}.*?\\end\{\1\}'
before = [m.group(0) for m in re.finditer(pattern,source,re.S)]
after = [m.group(0) for m in re.finditer(pattern,trial,re.S)]
assert len(before)==37 and before==after
labels = set(re.findall(r'\\label\{([^}]+)\}',source))
newrefs = set()
for p in all_p.values():
    newrefs.update(re.findall(r'\\(?:eqref|ref)\{([^}]+)\}',p['replacement']))
assert newrefs <= labels, newrefs-labels
log = (ROOT/'build/D1_bound5-v2.log').read_text()
issues=[line for line in log.splitlines() if any(w in line for w in ['Warning','Overfull','Underfull','undefined','multiply defined'])]
assert not issues,issues
pdf=json.loads((ROOT/'checks/pdf_equivalence.json').read_text())
assert pdf['pages']==[58,58,58]
assert all(pdf['same_text_by_page']) and all(pdf['same_rgb_96dpi_by_page'])
coverage=json.loads((ROOT/'render_cold/coverage.json').read_text())
assert [p['page'] for p in coverage['pages']]==list(range(1,59))
assert all(p['fully_decoded'] and p['visually_inspected'] for p in coverage['pages'])
for p in all_p.values():
    assert (ROOT/p['independent_review']).is_file(), p['independent_review']
ledger=json.loads((ROOT/'agents/architecture.json').read_text())
assert len(ledger['statements'])==37
assert all(ledger['checks'][k] for k in ['statement_hashes_match','source_hash_matches_brief','all_dependencies_resolve','dependency_graph_acyclic','all_nonprincipal_statements_have_consumers'])
result={'status':'PASS','source_sha256':SHA,'source_unmodified':True,
        'formal_statements':37,'proposals_with_unique_old_blocks':len(all_p),
        'recommended_proposals':len(order),'recommended_in_memory_application_has_no_conflicts':True,
        'formal_statements_unchanged_under_recommended_proposals':True,
        'proposed_references_resolve':True,'baseline_pages':58,'baseline_tex_warnings':issues,
        'recorded_visual_review_covers_pages_1_through_58':True,
        'three_baseline_PDFs_equal_in_extracted_text_and_96dpi_RGB_on_all_pages':True,
        'limits':'These controls protect source identity, proposal mechanics, ledger bookkeeping and baseline build. Human reviews and bounded arithmetic checks are separate evidence; this is not a proof of the main theorem or typesetting acceptance of unapplied text.'}
(ROOT/'checks/review_controls.json').write_text(json.dumps(result,indent=2)+'\n')
assert hashlib.sha256(SRC.read_bytes()).hexdigest()==SHA
print(json.dumps(result,indent=2))
