from pathlib import Path
from fractions import Fraction
import hashlib
import json
import re
import argparse

parser = argparse.ArgumentParser(description='Reproduce the preservation checks for the independently reviewed v3 snapshot. A changed source requires a fresh review.')
parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[2], help='Workspace root containing output/ and revision_v3/.')
ROOT = parser.parse_args().root.resolve()
baseline_path = ROOT / 'revision_v3/input/D1_bound5-v2.tex'
source_path = ROOT / 'output/D1_bound5-v3.tex'
register_path = ROOT / 'revision_v3/change_register.json'
b = baseline_path.read_text()
t = source_path.read_text()
register = json.loads(register_path.read_text())
changes = {c['id']: c for c in register['changes']}
baseline_hash = hashlib.sha256(baseline_path.read_bytes()).hexdigest()
source_hash = hashlib.sha256(source_path.read_bytes()).hexdigest()
assert baseline_hash == '5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70'
assert source_hash == 'a1119af75cf623411c678ea0e9b6e7dc9a3f59a931ee67384fc98be8d8373bd5', 'Source differs from the independently reviewed snapshot; obtain a fresh review.'
assert register['output_sha256'] == source_hash

reconstructed = b
for c in register['changes']:
    assert reconstructed.count(c['old']) == 1, c['id']
    reconstructed = reconstructed.replace(c['old'], c['new'])

statement_pattern = r'\\begin\{(theorem|lemma|proposition|corollary|remark)\}(.*?)\\end\{\1\}'
def statements(x):
    return [(m.group(1), re.sub(r'\\label\{[^}]+\}', '', m.group(2)))
            for m in re.finditer(statement_pattern, x, re.S)]

display_pattern = r'\\\[.*?\\\]|\\begin\{(?:equation\*?|align\*?|multline\*?)\}.*?\\end\{(?:equation\*?|align\*?|multline\*?)\}'
table_pattern = r'\\begin\{(?:tabular|longtable)\}.*?\\end\{(?:tabular|longtable)\}'
labels_old = set(re.findall(r'\\label\{([^}]+)\}', b))
labels_new = set(re.findall(r'\\label\{([^}]+)\}', t))
def bibentries(x):
    body = x.split(r'\begin{thebibliography}', 1)[1].split(r'\end{thebibliography}', 1)[0]
    return {m.group(1): m.group(2).strip() for m in re.finditer(r'\\bibitem\{([^}]+)\}(.*?)(?=\\bibitem|\Z)', body, re.S)}
bib_old, bib_new = bibentries(b), bibentries(t)
old_cites = re.findall(r'\\cite(?:\[[^]]*\])?\{[^}]+\}', b)
new_cites = re.findall(r'\\cite(?:\[[^]]*\])?\{[^}]+\}', t)
added_cites = [x for x in new_cites if 'Dujella' in x]
expected_preamble = b.split(r'\begin{document}')[0].replace(changes['AUTHOR-01']['old'], changes['AUTHOR-01']['new'])
metadata_source = json.loads((ROOT / 'revision_v3/input/author_metadata_source.json').read_text())
declarations = (ROOT / 'revision_v3/input/declarations_verbatim.tex').read_text().strip()

def brace_argument(x, start):
    depth = 0
    for i in range(start, len(x)):
        if x[i] == '{':
            depth += 1
        elif x[i] == '}':
            depth -= 1
            if depth == 0:
                return x[start + 1:i]
    raise ValueError('unclosed argument')

author_excerpt = metadata_source['author_excerpt']
old_author_start = author_excerpt.index('{', author_excerpt.index(']{', author_excerpt.index(r'\author[')))
author_original = brace_argument(author_excerpt, old_author_start)
author_new = brace_argument(t, t.index('{', t.index(r'\author')))
addresses = re.findall(r'\\address\[([^]]+)\]\{([^}]+)\}', author_excerpt)
emails = dict(re.findall(r'\\email\[([^]]+)\]\{([^}]+)\}', author_excerpt))
names_tex = author_original.split(' and ')
address_results = []
previous_author_blocks = []
for tex_name, (display_name, address) in zip(names_tex, addresses):
    expected_block = r'\noindent ' + tex_name + '\\\\\n' + address.replace('\\\\', '\\\\\n') + r'. \texttt{' + emails[display_name] + '}'
    previous_author_blocks.append(expected_block)
    address_results.append({'name': display_name, 'email': emails[display_name], 'donor_address_matches_shared_affiliation': address == addresses[0][1]})
shared_author_block = r'\noindent ' + author_original + '\\\\\n' + addresses[0][1].replace('\\\\', '\\\\\n') + '. ' + ', '.join(r'\texttt{' + emails[display_name] + '}' for display_name, _ in addresses)
previous_author_text = '\\bigskip\n' + previous_author_blocks[0] + '\n\n\\medskip\n' + previous_author_blocks[1] + '\n\\end{document}'
assert t.count(changes['AUTHOR-02']['new']) == 1
previous_review_source_hash = hashlib.sha256(t.replace(changes['AUTHOR-02']['new'], previous_author_text).encode()).hexdigest()
metadata_checks = {
    'authors_and_order_match_source': author_new.replace(r' \and ', ' and ') == author_original,
    'declarations_exactly_present_in_source_evidence': declarations in metadata_source['tail_text'],
    'declarations_exactly_present_in_v3': declarations in t,
    'declarations_sha256': hashlib.sha256((ROOT / 'revision_v3/input/declarations_verbatim.tex').read_bytes()).hexdigest(),
    'author_address_checks': address_results,
    'both_donor_addresses_identical': len(addresses) == 2 and addresses[0][1] == addresses[1][1],
    'shared_affiliation_and_both_emails_match_source_order_exactly': shared_author_block in t,
    'previous_review_source_reconstructed_by_reverting_only_author_format': previous_review_source_hash,
    'empty_date_preserved': r'\date{}' in t,
}
assert all(v for v in metadata_checks.values() if isinstance(v, bool))
assert len(address_results) == 2 and all(x['donor_address_matches_shared_affiliation'] for x in address_results)
assert previous_review_source_hash == 'ab102478bf254121c07c07a3ea78d4f289ba17deec2fb77e60426d1cd72cabfd'
checks = {
    'registered_edits_reproduce_source_exactly': reconstructed == t,
    'registered_edit_count': len(register['changes']),
    'theorem_like_statement_count': len(statements(b)),
    'theorem_like_statements_identical_modulo_labels': statements(b) == statements(t),
    'display_count': len(re.findall(display_pattern, b, re.S)),
    'all_display_contents_identical': re.findall(display_pattern, b, re.S) == re.findall(display_pattern, t, re.S),
    'table_count': len(re.findall(table_pattern, b, re.S)),
    'all_table_contents_identical': re.findall(table_pattern, b, re.S) == re.findall(table_pattern, t, re.S),
    'preamble_identical_except_authorized_author_names': expected_preamble == t.split(r'\begin{document}')[0],
    'existing_bibliography_entries_identical': all(bib_new.get(key) == value for key, value in bib_old.items()),
    'added_bibliography_keys': sorted(set(bib_new) - set(bib_old)),
    'existing_citation_calls_identical': [x for x in new_cites if 'Dujella' not in x] == old_cites,
    'added_citation_calls': added_cites,
    'labels_removed': sorted(labels_old - labels_new),
    'labels_added': sorted(labels_new - labels_old),
    'sm04_exact_endpoint_difference': str(Fraction(49) - Fraction(227, 5) - Fraction(4047, 25) / 45),
}
assert all(v for k, v in checks.items() if isinstance(v, bool))
assert not checks['labels_removed']
assert checks['labels_added'] == ['lem:pr-field', 'prop:pr-S15']
assert checks['added_bibliography_keys'] == ['Dujella24', 'DujellaOpen']
assert len(added_cites) == 2
layout_checks = [
    {'id': c['id'], 'classification': 'MATHEMATICAL_CONTENT_UNCHANGED',
     'evidence': 'The samepage wrapper is outside the unchanged lemma environment.' if c['id'] == 'LAYOUT-01' else 'The local nonfloating minipage replaces only the table wrapper. The complete tabular body, caption text and label are preserved.',
     'rendered_layout_status': 'Delegated to the rendered-page reviewer.'}
    for c in register['changes'] if c['id'] in ('LAYOUT-01', 'LAYOUT-02')
]

# These are independent mathematical judgments from the proof text, not outputs
# of the string comparison. Each item covers one newly introduced sentence.
evidence = {
 'EARLY01': [
  'The definition of L_m is an integral combination of z and the products R_i. The Vandermonde divisibility argument establishes its coefficients in Z[a_1,...,a_m].',
  'The partial-fraction identity makes the anchor-weighted coefficients vanish for 1<=n<m. Equation eq:coherent-exact retains 1-f(xy), and equations eq:coherent-exact/eq:coherent-tail explicitly identify and bound the remainder. The sentence does not assert that 1-f(xy) vanishes.',
  'For a nonzero L_m, integrality gives |L_m|>=1; the estimates in lem:interpolation-parameters, lem:strong-two-anchor and lem:direct-four compare this with expressions in P,Q and yield gap inequalities, used explicitly by lem:retained-gap.',
  'The L_2 zero case in lem:strong-two-anchor gives Q<5XYP; lem:interpolation-parameters/lem:separated-three give the two-sided L_3 zero range; lem:direct-four gives 10ABSTP^3<Q<17ABSTP^3 for L_4=0.'
 ],
 'EARLY02': [
  'The anchors are the first four distinct sextuple entries and the terminal pair is c,d. The preceding proof establishes C>1000 and D>1000C, precisely the two size hypotheses in lem:direct-four; ordering and distinctness are inherited.',
  'Substitution P=C,Q=D into the vanishing conclusion of lem:direct-four gives the stated strict upper bound 17ABSTC^3.',
  'Combining A^2C^5/S^2<D<17ABSTC^3 and cancelling positive A,C^3,S^2 gives C^2<17BS^3T/A. The unchanged displayed lower ratio is >1 because C>3ABST, T>2ABS, A>=1, B>=3.'
 ],
 'APP-02': [
  'In the all-large proof, eq:integrated-6 supplies the initial lower bound and O_j supplies the infinite tail; the common interval calculation in Section 8 and the fixed-triple calculation in Section 9 have the same structure.',
  'The actual chains pass through Q,N_2,P and the finite A_3,M,N_3,N_{3,bs},A_4,A_5 rows before the ordinary infinite tail, with the stated branches. No assertion says that a single finite family covers the full tail.',
  'Section 5 displays the finite polynomial rows and determinants, proves anchor divisibility before substitution, and then converts the integral forms using eq:ff-master/eq:ff-window.'
 ],
 'APP-03': [
  'The constants immediately preceding this sentence are the coefficient and residual constants of the finite two-anchor rows and the order-two three-anchor M estimate in their displayed normalizations.',
  'Equation eq:ff-prows lists exactly four quadratic rows, eq:ff-qdet is exactly the determinant of the five linear rows on a,b,s,t, and eq:ordinary-three-M is the cited M estimate.',
  'The proof following eq:ff-P explicitly evaluates R(1)=35/16+tau*5268<3. H_P is the same maximum as H_* in that proof, and its two terms are unchanged.',
  'The N_{3,bs} endpoints are obtained by replacing A,B by B,S in N_3. Equation eq:ordinary-integer-k at k=j has U=3CH_2^j/B and V=1/(2R_2^j), producing the displayed O_j endpoints.',
  'Equation eq:ff-window gives exactly [l/(1-epsilon),u/(1+epsilon)] with l=4U^2/C and u=1/(4V^2C), including both closed endpoints. This preserves the conversion removed from the local paragraph.'
 ],
 'APP-04': [
  'The first comparison is G>l_Q/(1-epsilon); eq:integrated-6 gives D>G. Indeed G/l_Q=(A^2C^4)/(12100S^2T^10), and the stated substitutions yield the first lower quantity.',
  'Every later junction X->Y requires u_X/(1+epsilon)>l_Y/(1-epsilon), equivalently u_X/l_Y>h, where h=4001/3999. These are the comparisons in the unchanged table.',
  'The second and third table columns are explicitly headed lower quantity and required constant. Requiring the former to exceed the latter is the sufficient strict comparison used in the argument.',
  'The first two lower quantities follow from C>A^2T^5/S^2 and T>2ABS; e.g. Q->N_2 yields A^4C^2/(36*735^2*T^2*B^8)>256A^16S^4/(36*735^2). Later rows use C>KA^7B^5S^3 from eq:large-gap with the separately printed branch conditions.'
 ],
 'SM-02': [
  'Each of s,t,c is distinct from anchors a,b and terminal d, and its modulus P is <=D. For P>=10^8 and 1<=A<=B<3, P>4B and AP>1000. The h,r,u bounds printed next and x>=8>4 satisfy the height-envelope conditions. All later uses choose P=S,T,T,C respectively.'
 ],
 'SM-04': [
  'The preceding unchanged inequality is D>S^8/400. Since 400<10^3, x=log10(S)>=49 gives log10(D)>8x-3. Only the dummy real variable has changed from s to x.',
  'Subtracting the printed g(x) gives x-227/5-(4047/25)/(x-4). Its derivative is 1+(4047/25)/(x-4)^2>0 for x>=49, and exact rational evaluation at 49 is 1/375. The height bound applies at P=S, contradicting the strict lower bound.'
 ],
 'COLD-05': [
  'lem:retained-gap supplies C>1000,C>200S,C>4T,AC>1000,D>1000C, satisfying each row construction and eq:ff-window. Its own B,T,AT hypotheses remain explicit and are checked in the later applications; this sentence is expressly conditional.'
 ],
 'COMP-02': [
  'The common cutoff proof assumes N(t)>=N0, obtains all finite overlaps and the ordinary infinite tail, and concludes a contradiction. It therefore proves N(t)<N0 for all 56 listed triples and for (1,3,8).',
  'For (1,3,8), irregular growth gives T>48 versus T<32. In the 56-row branch, 38 rows use T>2BS, 16 use the irregular-triple quadratic and convexity, and the last two combine that quadratic with t+1=(u+v*sqrt(-2))^2. The statement describes these actual proof cases without claiming fourth-entry enumeration.'
 ],
 'COMP-03': [
  'With d_bs=|b-s|^2, s_0=S^2, b_0=B^2 and d0=|b-s|/S, sqrt(d_bs^6/s_0^6)=d0^6 and sqrt(b_0*d_bs^5/s_0^6)=(B/S)*d0^5. Thus phi1 is an upward enclosure of Phi. Section 8 defines the valid residual as kappa*Phi, and the displayed kappa*phi1 is at least this value.'
 ],
 'NAV-03': [
  'lem:pr-field concludes Delta<=24 for all pairs other than (1,3) up to the allowed negation. The following d list is exactly the positive squarefree imaginary-quadratic parameters with absolute fundamental discriminant <=24; (1,3) is treated separately.'
 ],
 'NAV-04': [
  'prop:pr-S15 excludes S>=15 for every pair in the enumeration. Since N(s)=S^2 is integral, S<15 is exactly N(s)<=224. The label points to the unchanged statement and proof.'
 ],
 'NAV-05': [
  'The section concerns exactly the forty listed first pairs plus (1,3), which are the alternatives in prop:pr-S15. Its conclusion supplies S<15 in this context.'
 ],
 'LIT-01': [
  'Independently opened the Springer publisher page and Dujella author page for DOI 10.1007/978-3-031-56724-7. Both describe the monograph as covering Diophantine m-tuples and their elliptic-curve connections; the bibliography metadata match title, author, volume 79, publisher, year 2024 and DOI. The new sentence makes only a general-background recommendation, not a theorem attribution. Primary URLs: https://link.springer.com/book/10.1007/978-3-031-56724-7 and https://web.math.pmf.unizg.hr/~duje/diophantine-mtuples-book.html (retrieved 15 October 2026; web refs turn66view0 and turn66view1).'
 ],
 'LIT-02': [
  'Independently extracted printed page 4 of revision_v3/sources/Dujella_open-problems_accessed_2026-10-15.pdf, SHA256 571b5a71d67d4a438ebc560e976c512a57849c93b00164969ac36139c17eaacd. Problem 1.11 asks exactly for existence of a D(1)-quintuple in the integer ring of an imaginary quadratic field. The new sentence preserves its question form and full-ring scope.',
  'The unchanged theorem proves cardinality at most five. It excludes sextuples and larger tuples without constructing or excluding a quintuple, so it does not settle the cited existence question. This preserves the content of the former unattained-bound disclaimer.'
 ],
}

def sentence_parts(change_id):
    x = changes[change_id]['new']
    if change_id == 'EARLY02':
        return re.split(r'(?<=\.)\s+', x.strip(), maxsplit=2)
    if change_id == 'EARLY01':
        x = x.split('\n\n', 1)[1].strip()
    if change_id == 'COMP-03':
        x = x.split('is at least $K$. ', 1)[1].split('\nThe same lemma', 1)[0]
    if change_id == 'NAV-03':
        x = x.rsplit(' For squarefree', 1)[0]
    if change_id == 'NAV-05':
        x = x.split(' For the forty pairs', 1)[0]
    if change_id == 'LIT-01':
        x = x.split('\n\n', 1)[0]
    if change_id == 'LIT-02':
        x = x.split('\n\n', 1)[1]
    return re.split(r'(?<=\.)\s+', x.strip())

sentence_checks = []
for change_id, proofs in evidence.items():
    sentences = sentence_parts(change_id)
    assert len(sentences) == len(proofs), (change_id, sentences)
    for index, (sentence, proof) in enumerate(zip(sentences, proofs), 1):
        assert sentence in changes[change_id]['new']
        sentence_checks.append({
            'id': f'MP-{change_id}-{index:02}',
            'change_id': change_id,
            'source_lines': [changes[change_id]['final_line_start'], changes[change_id]['final_line_end']],
            'sentence': sentence,
            'classification': 'TRUE',
            'evidence': proof,
            'severity': 'none',
            'smallest_repair': None,
        })
assert len(sentence_checks) == 32

report = {
    'reviewer': 'Independent read-only mathematical-preservation reviewer /root/v3_preservation',
    'status': 'PASS_SCOPED_MATHEMATICAL_PRESERVATION',
    'source_path': str(source_path.relative_to(ROOT)),
    'source_sha256': source_hash,
    'baseline_path': str(baseline_path.relative_to(ROOT)),
    'baseline_sha256': baseline_hash,
    'scope': 'The 10 accepted exposition recommendations, 5 navigation edits, 6 subsequently authorized author/declaration/literature edits, and registered local layout wrappers; checks of new explanatory sentences against actual proof or primary-source contexts and exact baseline preservation. This does not reopen a global mathematical audit, recompute finite graphs, or certify rendered layout.',
    'mechanical_checks': checks,
    'metadata_checks': metadata_checks,
    'layout_checks': layout_checks,
    'sentence_checks': sentence_checks,
    'findings': [],
    'unresolved_mathematical_findings': 0,
    'new_table_entries': 0,
    'limitations': ['No expensive finite graph or global numerical rerun was undertaken; those mathematical authorities are unchanged from the frozen baseline.', 'PDF layout is outside this reviewer role. Any later source change requires revalidation/rebinding.'],
}
out = ROOT / 'revision_v3/agents'
(out / 'math_preservation.json').write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n')
lines = [
    'Independent mathematical-preservation review — D1_bound5-v3',
    'Status: PASS (scoped review; no findings)',
    f'Source: {source_path.relative_to(ROOT)}',
    f'Source SHA256: {source_hash}',
    f'Baseline SHA256: {baseline_hash}',
    '',
    report['scope'],
    '',
    'Authority: the frozen v2 source, the accepted ten-item register, and the actual integrated v3 diff; the later user-authorized metadata source and Dujella primary sources. Read-only manuscript review under the latex-math-writing and math-paper-campaign preservation controls; the existing 12pt Latin Modern style, margins and empty date remain, with the authorized author names added.',
    '',
    'Preservation checks:',
    f"- Exact replay of the {len(register['changes'])} registered changes reproduces v3 byte-for-byte.",
    '- All 37 theorem-like statements are identical modulo the two new stable labels.',
    '- All 358 displayed-mathematics blocks and all 15 tabular/longtable bodies are identical.',
    '- The preamble is unchanged except for the authorized author names. Existing bibliography entries, existing citation calls and all old labels are preserved; exactly the two authorized Dujella entries and citation calls are added.',
    '- The only new labels are lem:pr-field and prop:pr-S15; their three new citations identify the actual preserved results.',
    '- The logarithmic variable replacement changes only the local dummy name; exact endpoint difference is 1/375.',
    '',
    '- Both donor address entries are identical. The shared affiliation is copied exactly, with both names and both emails in their source order. Both declarations match the matrices10 evidence and the verbatim input byte-for-byte. The empty date is preserved.',
    '- Reverting only the final shared-author formatting reproduces the previous reviewed source SHA256 ab102478bf254121c07c07a3ea78d4f289ba17deec2fb77e60426d1cd72cabfd exactly; this independently verifies the sole final delta.',
    '- Local samepage/table-wrapper edits preserve the complete lemma, table body, caption and label; rendered page quality is reviewed separately.',
    '',
    'Sentence-by-sentence review (all 32 newly introduced explanatory sentences are true):',
]
for item in sentence_checks:
    lines += ['', f"{item['id']} — TRUE — v3 lines {item['source_lines'][0]}–{item['source_lines'][1]}", item['sentence'], 'Evidence: ' + item['evidence']]
lines += ['', 'No changed hypothesis, conclusion, constant, exponent, sign, endpoint, exceptional case, tuple symmetry, or claimed uniformity was found. The finite computations and underlying proofs were preserved. No repair is requested.', '', 'Limits: this is the requested preservation review of actual v3 edits, not a fresh proof audit of the full paper or an independent rendering assessment.']
(out / 'math_preservation.txt').write_text('\n'.join(lines) + '\n')
print(json.dumps({'status': report['status'], 'source_sha256': source_hash, 'sentence_count': len(sentence_checks), 'findings': 0, 'mechanical_checks': checks}, indent=2))
