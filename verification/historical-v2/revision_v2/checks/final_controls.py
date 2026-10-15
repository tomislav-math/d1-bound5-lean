#!/usr/bin/env python3
"""Portable aggregate integrity controls; does not execute mathematical checkers.
Run from any working directory: python /path/to/package/revision_v2/checks/final_controls.py
Only Python's standard library is required. All artifact paths resolve under ROOT.
"""
from pathlib import Path
from collections import Counter
import hashlib
import json
import re

ROOT=Path(__file__).resolve().parents[2]
CHECKS=ROOT/'revision_v2/checks'
FINAL='5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70'
BASELINE='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
RUN='66f5a580e2b08bdd369c1b38a557de20a586cf3cf9a06bb7d0b82d4304587c63'
CONTROLS=[]
def check(name,condition):
    if not condition:raise AssertionError(name)
    CONTROLS.append(name)
def digest(data):return hashlib.sha256(data).hexdigest()
def relative(path):return str(path.relative_to(ROOT))
def load(path):return json.loads((ROOT/path).read_text())
def file_record(path):return {'path':relative(path),'bytes':path.stat().st_size,'sha256':digest(path.read_bytes())}

source_path=ROOT/'output/D1_bound5-v2.tex'; baseline_path=ROOT/'upload/D1_bound5-v1(1).tex'
source=source_path.read_text(); baseline=baseline_path.read_text()
check('final source hash',digest(source_path.read_bytes())==FINAL)
check('unchanged baseline hash',digest(baseline_path.read_bytes())==BASELINE)
register_path=ROOT/'revision_v2/change_register.json';register=json.loads(register_path.read_text())
check('register source bindings',register['baseline_sha256']==BASELINE and register['output_sha256']==FINAL)
check('register relative source paths',register['baseline']==relative(baseline_path) and register['output']==relative(source_path))
check('register edit count agrees with actual entries',register['number_of_edits']==len(register['edits'])==122)
working=baseline;replay=[]
for number,e in enumerate(register['edits'],1):
    check('unique old text for edit '+str(number),working.count(e['old'])==1)
    line=working[:working.index(e['old'])].count('\n')+1
    check('recorded application line for edit '+str(number),line==e['line_at_application'])
    working=working.replace(e['old'],e['new'],1)
    replay.append({'number':number,'id':e['id'],'line_at_application':line})
check('exact replay equals delivered source',working.encode()==source_path.read_bytes())
check('registered line counts',register['baseline_lines']==len(baseline.splitlines()) and register['output_lines']==len(source.splitlines()))

# Source-level reference inventory. Comments are not declarations or citations.
clean=re.sub(r'(?<!\\)%[^\n]*','',source)
labels=re.findall(r'\\label\{([^}]+)\}',clean)
refs=re.findall(r'\\(?:eqref|ref|pageref|autoref)\*?\{([^}]+)\}',clean)
bibs=re.findall(r'\\bibitem(?:\[[^\]]*\])?\{([^}]+)\}',clean)
cites=[]
for group in re.findall(r'\\(?:cite|citep|citet)\*?(?:\[[^\]]*\]){0,2}\{([^}]+)\}',clean):
    cites.extend(x.strip() for x in group.split(','))
missing_refs=sorted(set(refs)-set(labels));missing_cites=sorted(set(cites)-set(bibs))
check('unique labels',len(labels)==len(set(labels)))
check('unique bibliography keys',len(bibs)==len(set(bibs)))
check('no undefined source references',not missing_refs)
check('no undefined source citations',not missing_cites)
formal_types=('theorem','proposition','lemma','corollary','remark')
formal_counts={kind:len(re.findall(r'\\begin\{'+kind+r'\}',clean)) for kind in formal_types}
for kind,count in formal_counts.items():check('balanced formal environment '+kind,count==len(re.findall(r'\\end\{'+kind+r'\}',clean)))
formal_count=sum(formal_counts.values())

# Recover the actual source used by the expensive Section 7 computations.
qa=[e for e in register['edits'] if e['id'] in ('QA01','QA02','QA03','QA04')]
check('exact four final editorial edit IDs',[e['id'] for e in qa]==['QA01','QA02','QA03','QA04'])
run_source=source
for e in reversed(qa):
    check('unique reverse text '+e['id'],run_source.count(e['new'])==1)
    run_source=run_source.replace(e['new'],e['old'],1)
check('recovered expensive-run full-source hash',digest(run_source.encode())==RUN)
start=r'\section{Tuples with at least two small entries}'
end=r'\section{Reduction of the first three entries}'
final_section=source[source.index(start):source.index(end)]
run_section=run_source[run_source.index(start):run_source.index(end)]
check('Section 7 byte-identical since expensive computations',final_section.encode()==run_section.encode())
section_sha=digest(final_section.encode())

# Read every current result JSON. Old bindings are permitted only in the named
# Section 7 run outputs or explicitly historical pre-QA metadata listed here.
section7_run_files={
 'small_v2_pairs.json','small_v2_pell.json','small_v2_triples.json',
 'small_v2_runtime_pairs.json','small_v2_runtime_pell.json','small_v2_runtime_triples.json'}
historical_files={'small_v2_constants_pre_qa.json','small_v2_rebinding_pre_qa.json'}
results={}; inventory=[]
for path in sorted(CHECKS.glob('*.json')):
    if path.name=='final_controls.json':continue
    data=json.loads(path.read_text());results[path.name]=data
    check('JSON object '+path.name,isinstance(data,dict))
    bindings=[data[k] for k in ('source_sha256','sha256','hash') if k in data]
    permitted={RUN,FINAL} if path.name in section7_run_files else ({RUN} if path.name in historical_files else {FINAL})
    check('declared source binding '+path.name,bool(bindings) and len(set(bindings))==1 and bindings[0] in permitted)
    actual_binding=bindings[0]
    disposition=('historical pre-QA metadata, not a current rerun' if path.name in historical_files else
                 'pre-QA computation bound by exact Section 7 reconciliation' if actual_binding==RUN else
                 'computation recorded against final source' if path.name in section7_run_files else 'final-source result or metadata')
    declared=data.get('checks',data.get('check_count',data.get('assertions')))
    entry=file_record(path);entry.update({'source_sha256':actual_binding,'binding_disposition':disposition})
    if isinstance(declared,int):entry['reported_check_count']=declared
    elif isinstance(declared,list):
        entry['reported_check_entries']=len(declared)
        if any(isinstance(x,dict) and 'passed' in x for x in declared):
            check('all explicit recorded pass flags '+path.name,all(x.get('passed',True) is True for x in declared if isinstance(x,dict)))
    inventory.append(entry)

# Inspect source-range and current artifact hash claims without rerunning proofs.
lines=source.splitlines(keepends=True)
for name in ('approximation_scope.json','completion_scope.json'):
    data=results[name]
    for r in data['read_ranges']:
        check('read-range byte hash '+name+':'+str(r['start']),digest(''.join(lines[r['start']-1:r['end']]).encode())==r['sha256'])
    for path,h in data.get('artifact_sha256',{}).items():check('reported artifact hash '+path,digest((ROOT/path).read_bytes())==h)
app=results['approximation_scope.json']
check('approximation script hash',digest((CHECKS/'approximation_exact.py').read_bytes())==app['script_sha256'])
check('approximation result hash',digest((CHECKS/'approximation_exact_results.json').read_bytes())==app['results_sha256'])
check('literature register binding',results['literature_coverage.json']['register_sha256']==digest(register_path.read_bytes()))
for item in results['small_v2_rebinding.json']['provenance'].values():
    check('current small-checker hash '+item['output_script'],digest((ROOT/item['output_script']).read_bytes())==item['output_sha256'])

# Cross-file consistency of already computed counts. These are not new searches.
struct=results['structural_v2.json']
check('structural recorded assertion count',struct['assertions']==len(struct['checks']))
check('structural recorded tail counts',struct['tail_enumeration']['counts']==[90,118,16,0])
app_result=results['approximation_exact_results.json']
check('approximation recorded assertion count',app_result['check_count']==len(app_result['checks']))
one=results['one_small_v2_results.json'];comp=results['completion_exact.json'];cross=results['completion_cross.json'];overlaps=results['completion_overlaps.json']
check('cutoff and region row counts',len(one['regions'])==5 and len(one['fixed41'])==41 and len(one['fixed56'])==56 and len(comp['cutoffs'])==57)
check('finite-complement partition counts',one['completion_counts']=={'tail':38,'quadratic':16,'quadratic+annulus':2} and len(comp['finite_tail_rows'])==38 and len(comp['quadratic_rows'])==18)
check('cross-check cutoff count',cross['cutoffs_cross_compared']==len(comp['cutoffs']))
check('all-large and fixed interval count metadata',len(overlaps['large_15_junctions'])==15 and len(overlaps['fixed_13_junctions'])==13)
lookup={(row['pair'],tuple(row['s'])):row for row in comp['cutoffs']}
for row in one['fixed56']:
    other=lookup[(row['pair'],tuple(row['s']))]
    for key in ('N0','Mbs','thresholds','q1','K','eta'):
        check('matching saved cutoff '+str((row['pair'],row['s'],key)),row[key]==other[key])
    check('matching saved infinite threshold '+str((row['pair'],row['s'])),row['ntail']==other['n_infinity'])
check('quadratic maximum consistent across saved results',one['maximum_quadratic_upper']==comp['quadratic_worst_regular_upper'])
pairs=results['small_v2_pairs.json'];pell=results['small_v2_pell.json'];triples=results['small_v2_triples.json'];binding=results['small_v2_source_check.json']
graph_totals={'vertices':sum(x[3] for x in pairs['rows']),'edges':sum(x[4] for x in pairs['rows']),'triangles':sum(x[5] for x in pairs['rows'])}
check('small-pair saved class and graph counts',len(pairs['all_classes'])==72 and len(pairs['rows'])==48)
check('small-pair saved graph totals',graph_totals=={'vertices':36931,'edges':36854,'triangles':0})
check('small-triple saved row count',len(triples['rows'])==10)
pell_derived=[len(pell['rows']),sum(x[1]>0 for x in pell['rows']),sum(x[1] for x in pell['rows']),sum(x[2] for x in pell['rows']),sum(x[3] for x in pell['rows'])]
check('Pell saved totals agree with saved rows',pell_derived==pell['totals'])
check('Section 7 reconciliation metadata',binding['section_sha256']==section_sha and binding['expensive_run_source_sha256']==RUN and binding['section_unchanged_since_expensive_runs'] is True and binding['run_source_recovered_by_exact_QA_reversal'] is True)
for mode in ('pairs','triples','pell'):
    runtime=results['small_v2_runtime_'+mode+'.json']
    check('Section 7 runtime/result source consistency '+mode,runtime['source_sha256']==results['small_v2_'+mode+'.json']['hash'])
    check('Section 7 saved runtime '+mode,runtime['mode']==mode and runtime['passed'] is True and runtime==binding['fresh_computation_runtimes'][mode])
check('Section 7 exact-check count consistency',binding['exact_constant_checks']==len(results['small_v2_constants.json']['checks']))

ledger_names=['structural','approximation','small','one_small','completion','literature_style'];ledgers=[]
for name in ledger_names:
    path=ROOT/'revision_v2/agents'/ (name+'.md')
    check('agent ledger present '+name,path.is_file())
    check('agent ledger contains final source hash '+name,FINAL in path.read_text())
    ledgers.append(file_record(path))

pdf_path=ROOT/'output/D1_bound5-v2.pdf'
check('delivered final PDF present',pdf_path.is_file())
pdf=file_record(pdf_path);pdf_qa=results['pdf_qa.json']
check('PDF byte identity matches production QA',pdf['sha256']==pdf_qa['pdf_sha256'] and pdf['bytes']==pdf_qa['pdf_bytes'])
log_path=ROOT/pdf_qa['compile_log'];log=log_path.read_text(errors='replace')
check('final build log hash',digest(log_path.read_bytes())==pdf_qa['compile_log_sha256'])
build_match=re.search(r'Output written on\s+.*?\((\d+) pages,\s*(\d+) by\s*tes\)',log,re.S)
check('build completion page and byte count',build_match is not None and int(build_match[1])==pdf_qa['pages'] and int(build_match[2])==pdf['bytes'])
issues=[line for line in log.splitlines() if re.search(r'^!|undefined references|Citation .* undefined|Reference .* undefined|Overfull \\|Underfull \\',line)]
check('no build errors or unresolved-reference/box warnings',not issues)
pdf.update({'pages_from_build_log':int(build_match[1]),'build_log':file_record(log_path),'visual_review_status':'Recorded in pdf_qa.json; not repeated by this aggregate runner.'})
portable_log=CHECKS/'final_build.log'
if portable_log.exists():check('portable copied build log matches final log',portable_log.read_bytes()==log_path.read_bytes())

report={
 'scope':'Aggregate integrity, source reconciliation, recorded-result consistency and artifact checks only. No mathematical checker, finite search, LaTeX build, or visual review is executed by this runner. Recorded check counts are not new mathematical checks and must not be summed as independent evidence.',
 'source_sha256':FINAL,'baseline_sha256':BASELINE,'register':file_record(register_path),
 'replay':{'edits':len(replay),'exact_source_reproduced':True,'entries':replay},
 'formal_statement_counts_derived_from_source':formal_counts,'formal_statement_count':formal_count,
 'references':{'label_count':len(labels),'reference_occurrences':len(refs),'bibliography_keys':bibs,'citation_occurrences':len(cites),'missing_refs':missing_refs,'missing_cites':missing_cites},
 'section7_reconciliation':{'initial_expensive_run_source_sha256':RUN,'actual_saved_run_source_sha256':{mode:results['small_v2_runtime_'+mode+'.json']['source_sha256'] for mode in ('pairs','triples','pell')},'recovered_by_exact_reverse_QA_edits':True,'unchanged_section_sha256':section_sha,'expensive_checks_rerun_by_this_runner':False,'saved_graph_totals':graph_totals,'saved_pell_totals':pell_derived},
 'results_inventory':inventory,'agent_ledgers':ledgers,'pdf':pdf,
 'aggregate_control_count':len(CONTROLS),'aggregate_controls':CONTROLS,'status':'PASS',
 'command':'python revision_v2/checks/final_controls.py','dependencies':'Python 3 standard library only; no external executable or package required.'}
(CHECKS/'final_controls.json').write_text(json.dumps(report,indent=2)+'\n')
print('PASS aggregate-only:',len(CONTROLS),'integrity/consistency controls;',len(replay),'replayed edits;',formal_count,'formal statements;',len(inventory),'result/metadata JSON files;',len(ledgers),'agent ledgers;',pdf['pages_from_build_log'],'PDF pages.')
