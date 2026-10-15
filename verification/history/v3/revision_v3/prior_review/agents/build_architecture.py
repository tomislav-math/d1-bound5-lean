import json,hashlib,re,pathlib
root=pathlib.Path('armstrong_v2'); source=root/'input/D1_bound5-v2.tex'
raw=source.read_bytes(); txt=raw.decode(); lines=txt.splitlines(); inv=json.loads((root/'records/statement_inventory.json').read_text())
# This is a read-only architecture ledger, not a mathematical recertification.
data=[
('thm:main','Principal conclusion. Excludes a sextuple by an exhaustive split into zero, one, or at least two small entries.', ['prop:no-all-large-six','prop:one-small','sm:main'],[3851,3859]),
('lem:irregular-growth','Turns nonregularity into C>2AB. Its sharper quadratic, not just its final conclusion, is reused in the final finite complement.',[],[120,143]),
('lem:tail-irregular','Makes the final triple of an ordered quadruple irregular and supplies D>2BC, including the exact small B,C computation. This is the reusable entry-growth source.', ['lem:irregular-growth'],[149,246]),
('lem:product-four','Supplies the four-entry product gaps, with distinct all-large and one-small regimes; its perturbation estimate is also reused inside the five-entry proof.', ['lem:tail-irregular','module:determinant-setup'],[283,324]),
('lem:product-five','Gives the stronger five-entry product lower bound used to launch and close retained-gap interpolation.', ['lem:product-four','module:determinant-setup'],[330,390]),
('lem:five-frontier-gaps','Strengthens the fourth-entry gap for all-large and five one-small regions. Its determinant expansion, not just table conclusions, is reused in the fixed-pair S>=15 proof.', ['lem:product-four','lem:tail-irregular','module:determinant-setup'],[411,520]),
('lem:interpolation-parameters','Packages the two H regimes needed by retained-gap, and supplies the two-anchor estimate and three-anchor zero/nonzero alternatives.', ['module:interpolation-identities'],[614,651]),
('lem:strong-two-anchor','Excludes L2=0 under Q>=5XYP and improves the terminal growth cubically. Two applications force nonvanishing in retained-gap.', ['lem:interpolation-parameters'],[660,685]),
('lem:general-three','Controls L3 when Q need only be >=P. This weaker separation regime is needed before Q>=4P has been established in two-small and three-small proofs.', ['module:interpolation-identities'],[694,705]),
('lem:separated-three','Uses P>=1000 and Q>=4P to improve the L3 residual and give a quadratic interval when L3 vanishes. Distinct from general-three.', ['lem:interpolation-parameters','module:interpolation-identities'],[714,721]),
('lem:four-anchor-nonvanishing','Ensures one of two overlapping three-anchor forms is nonzero. Its simultaneous root choices are essential to the interpolating-polynomial contradiction.', ['module:interpolation-identities'],[728,748]),
('lem:direct-four','Supplies the four-anchor estimate and zero-case bounds needed to obtain seventh-power terminal growth.', ['module:interpolation-identities'],[758,788]),
('lem:retained-gap','Central reusable gap with a distance-sensitive coefficient, five-entry C conclusion, two D conclusions and all numerical guards for approximation families.', ['lem:product-five','lem:strong-two-anchor','lem:interpolation-parameters','lem:direct-four'],[811,874]),
('lem:ordinary-residue-construction','Common matrix construction: polynomial integrality, column divisibility, determinant nonvanishing, beta residual and transfer to integral forms, including parity gain at k=1.', ['external:Bennett96-determinant'],[921,1036]),
('lem:ordinary-all-orders','Gives every ordinary O_j interval and the continuous height estimate. Both outputs are independently consumed.', ['lem:ordinary-residue-construction'],[1059,1148]),
('cor:ordinary-height-envelope','Converts the continuous estimate to rationally certifiable logarithmic upper bounds used with small anchors in three separate arguments.', ['lem:ordinary-all-orders'],[1165,1175]),
('lem:ordinary-three-normalized','Provides the normalized order-two matrix bound M and a coarser directly usable closed interval. Both feed multiple branches.', ['lem:ordinary-residue-construction'],[1198,1329]),
('prop:no-all-large-six','Closes the zero-small branch by a growth lower bound, finite forbidden-interval chain and ordinary infinite tail.', ['lem:five-frontier-gaps','lem:retained-gap','lem:ordinary-all-orders','lem:ordinary-three-normalized','module:finite-forms'],[1860,2009]),
('sm:main','Section-level exit result for at least two small entries, assembled from two-small/four-large and three-small cases and the classification excluding four small entries.', ['sm:six-small-triple-classification','sm:five-two-small-four-large','sm:five-three-small'],[2874,2880]),
('sm:crossblock','Gives a mixed three-by-three growth bound when the first cross-product is at least nine. Used in the two-small search-radius proof.', [],[2033,2079]),
('sm:lem-four-root-k1','Order-one four-anchor approximation interval used only when a small triple has one bounded additional extension. Its exact and safe inequalities establish the window.', ['lem:ordinary-residue-construction'],[2109,2188]),
('sm:bs7-cutoff','Bounds the third large modulus C by 10^550 for a sextuple with exactly two small entries. Makes finite graph searches sufficient.', ['lem:product-four','sm:crossblock','cor:ordinary-height-envelope','lem:general-three','lem:separated-three','lem:four-anchor-nonvanishing','lem:direct-four','lem:ordinary-three-normalized','module:six-V-interval'],[2232,2336]),
('sm:bs7-descent','Reversible strict descent for nondegenerate small pairs, allowing zero and anchor coincidences during generation. Supplies completeness for both pair and triple computations.', [],[2345,2377]),
('sm:bs7-finite-pairs','For all nondegenerate small pairs in fields d<36, excludes a compatible triple of large extensions in the closed search disk via exhaustive graph generation.', ['sm:bs7-descent'],[2384,2403]),
('sm:bs7-unit-axes','Classifies all common extensions of {-1,1} on real or imaginary axes and supplies |z|>=d+1; this identifies the Pell search and field cutoff.', [],[2480,2495]),
('sm:five-unit-cubic','Cubic gap for two nonsymmetric large extensions of {-1,1}; iterated three times to bound the smallest real extension and hence the field parameter.', [],[2501,2521]),
('sm:bs7-unit-pair','Closes the product-minus-one pair {-1,1}: axis/parity exclusions, bounded fields and continued-fraction graph enumeration contradict the two-small C cutoff.', ['sm:bs7-unit-axes','sm:five-unit-cubic','cor:ordinary-height-envelope','sm:bs7-cutoff'],[2526,2619]),
('sm:bs7-eisenstein','Closes the other degenerate small pair by showing every common extension is purely imaginary and at most one lies on each half-axis.', [],[2623,2646]),
('sm:five-two-small-four-large','Assembles the exactly-two-small case, splitting large fields and the 72 finite pair classes, including both degenerate cases.', ['sm:bs7-unit-pair','sm:bs7-eisenstein','sm:bs7-finite-pairs','sm:bs7-cutoff'],[2651,2655]),
('sm:six-small-triple-classification','Proves at most three small entries, classifies the ten small-triple orbits and gives their complete extension lists through 10^40. Each conclusion has a consumer.', ['sm:bs7-descent','module:half-coordinate-square-test'],[2665,2699]),
('sm:five-small-anchor-alternative','Separates vanishing and nonvanishing L3 cases for three small anchors and proves a common quadratic lower bound. Iterated on pairs of three large extensions.', ['module:interpolation-identities','lem:general-three','lem:separated-three'],[2738,2769]),
('sm:five-three-small','Closes three-small case by separating zero or one bounded extra extension, using the L3 alternatives or overlapping three/four-anchor windows.', ['sm:six-small-triple-classification','sm:bs7-descent','cor:ordinary-height-envelope','lem:ordinary-three-normalized','sm:lem-four-root-k1','sm:five-small-anchor-alternative','lem:four-anchor-nonvanishing','lem:general-three'],[2775,2871]),
('prop:pr-H2','Reduces the one-small case to norm one with B<8 or norm two with B<4, by excluding five regions with distance-sensitive gap/residual estimates.', ['lem:five-frontier-gaps','lem:retained-gap','module:common-interval-calculation','module:finite-forms'],[3050,3144]),
('lem:pr-one-three','Handles {1,3} in every full ring: all extensions are rational and any negative extension limits the tuple to four. This removes one enumerated triple and reduces the rational sextuple to positive integers.', [],[3153,3183]),
('unlabelled_35','Bounds the field discriminant by 24 unless the first pair is ±(1,3). This makes the forty-pair enumeration exhaustive.', ['prop:pr-H2'],[3190,3203]),
('unlabelled_36','Shows S<15 for all forty fixed pairs and (1,3), producing the exact norm cutoff N(s)<=224 for the final triple list.', ['lem:tail-irregular','lem:five-frontier-gaps','lem:retained-gap','module:common-interval-calculation','module:finite-forms','module:forty-pair-enumeration'],[3365,3517]),
('prop:one-small','Assembles one-small completion: first-pair and third-entry reductions, exclusion of (1,3,8), analytic N(t)<N0, and exclusion of the finite complement without enumerating fourth entries.', ['prop:pr-H2','unlabelled_35','lem:pr-one-three','unlabelled_36','module:forty-pair-enumeration','module:fifty-six-triples','module:fourth-entry-cutoff','module:finite-complement'],[3841,3847]),
]
mods=[
('module:determinant-setup',[248,274],[],'Even-dimensional nonsingularity and the F perturbation identities.'),
('module:interpolation-identities',[524,589],[],'Coherent integral forms and their exact Taylor/remainder identities.'),
('external:Bennett96-determinant',[979,995],[],'External identity cited at p.1721, transported by clearing denominators. Citation not independently verified in this architecture audit.'),
('module:finite-forms',[1333,1852],[],'Polynomial-row transfer, five two-anchor families, adaptive quadratic rows P and four-anchor linear rows Q. Proofs are explicit here; analytical transfer repeats 1011–1035.'),
('module:six-V-interval',[2195,2223],['lem:four-anchor-nonvanishing','lem:separated-three'],'Two overlapping L3 forms yield the interval used in the two-small cutoff.'),
('module:half-coordinate-square-test',[2385,2392],[],'Necessary/sufficient square test in (u+v sqrt(-d))/2 coordinates, including zero and parity.'),
('module:common-interval-calculation',[2893,3014],['lem:retained-gap','lem:ordinary-all-orders','lem:ordinary-three-normalized','module:finite-forms'],'Parameterized endpoints, overlap quotients and infinite-tail implication.'),
('module:forty-pair-enumeration',[3205,3356],['prop:pr-H2','unlabelled_35','module:finite-forms'],'Complete first-pair list, coefficients for forty pairs and (1,3).'),
('module:fifty-six-triples',[3519,3545],['unlabelled_36','module:forty-pair-enumeration','lem:pr-one-three'],'Enumerates N(s)<=224, keeps 56 after removing (1,-3,3).'),
('module:fourth-entry-cutoff',[3556,3715],['lem:tail-irregular','lem:retained-gap','module:forty-pair-enumeration','module:common-interval-calculation','module:finite-forms'],'For each fixed triple gives N(t)<N0; (1,3,8) has N0=1024 and t>48.'),
('module:finite-complement',[3717,3772],['lem:tail-irregular','lem:irregular-growth','module:fourth-entry-cutoff','module:fifty-six-triples'],'Excludes low N(t): 38 rows by 4BS squared, 16 by exact quadratic endpoint tests, final 2 by congruence.'),
]
by={x['id']:x for x in inv['statements']};rows=[]
for k,role,deps,proof in data:
 s=by[k];refs=[i+1 for i,l in enumerate(lines) if re.search(r'\\(?:eqref|ref)\{'+re.escape(k)+r'\}',l)]
 rows.append(dict(id=k,kind=s['kind'],statement_lines=[s['start'],s['end']],proof_lines=proof,statement_sha256=s['statement_sha256'],frozen_contract=s['statement'],role=role,dependencies=deps,consumers=[],explicit_ref_lines=refs,disposition='MOVE' if k=='sm:lem-four-root-k1' else 'RETAIN',proposed_destination='Immediately before sm:five-three-small, after sm:five-small-anchor-alternative' if k=='sm:lem-four-root-k1' else 'Current mathematical home',proposal_ids=['ARCH-01'] if k=='sm:lem-four-root-k1' else (['ARCH-05'] if k in ['unlabelled_35','unlabelled_36'] else []),claim_preservation='Retain all hypotheses, conclusions, exact constants, labelled intermediate estimates and proof steps. No source edit has been made.',mathematics_status='FROZEN_CURRENT_SOURCE; prior audited status is not independently reassigned by this architecture review',manuscript_status='DIAGNOSTIC_ONLY; no reduction, architecture or exposition proposal integrated'))
module_rows=[dict(id=k,lines=l,dependencies=d,role=r,consumers=[]) for k,l,d,r in mods]
nodes={x['id']:x for x in rows+module_rows}
for n in nodes.values():
 for d in n['dependencies']:
  assert d in nodes,(n['id'],d)
  nodes[d]['consumers'].append(n['id'])
# Principal reader-facing conclusion is allowed to have no consumer.
assert [r['id'] for r in rows if not r['consumers']]==['thm:main']
seen=set();active=set()
def visit(k):
 if k in active: raise ValueError('cycle '+k)
 if k in seen:return
 active.add(k)
 for d in nodes[k]['dependencies']:visit(d)
 active.remove(k);seen.add(k)
for k in nodes:visit(k)
for r in rows:
 assert hashlib.sha256(('\n'.join(lines[r['statement_lines'][0]-1:r['statement_lines'][1]])).encode()).hexdigest()==r['statement_sha256']
out=dict(source=str(source),source_sha256=hashlib.sha256(raw).hexdigest(),source_line_count=len(lines),review_role='Independent architecture, Phase 1/3 diagnostic',read_scope={'manuscript':'Every source line 1–3904 freshly read before diagnosis; includes all proofs, tables and bibliography.','skills':'Both SKILL.md files and writing-rules, artisan-writing, house-style, route-polish, shared-controls, control-artifacts read.','prior_audits':'Not read.','rendered_pages':'Not inspected by this reviewer.'},scope_limits=['No article edits','No new numeric computation or external citation verification','No compilation','Statement dependencies record actual mathematical use, including important proof equations and unnumbered modules; explicit reference counts alone are not treated as dependency evidence.'],checks={'statement_count':len(rows),'statement_hashes_match':True,'source_hash_matches_brief':hashlib.sha256(raw).hexdigest()==inv['source_sha256'],'all_dependencies_resolve':True,'dependency_graph_acyclic':True,'all_nonprincipal_statements_have_consumers':True},statements=rows,nonstatement_dependencies=module_rows)
(root/'agents/architecture.json').write_text(json.dumps(out,indent=2,ensure_ascii=False)+'\n')
print(json.dumps(out['checks']))
