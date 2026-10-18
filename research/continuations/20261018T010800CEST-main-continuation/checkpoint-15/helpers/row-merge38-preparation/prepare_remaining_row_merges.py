#!/usr/bin/env python3
"""Plan body-preserving row merges; optional reviewed replay emits only new research candidates."""
from pathlib import Path
import argparse, hashlib, json, os, re, sys, types, datetime

BASE_SHA = '0091cf518b0bdac90510d96a318241dc5b170065e4787fba789385492a3f1f62'
ADAPTIVE_SHA = '3cfaff9aeff48634d1b4ea1ca9ceeb5b9f89a55d98c10fa92c80d0b3076d350f'
HELPER_SHA = '93e03376a48b47580239744508aa6bfa2e941dbdfa4de499e8daa3d4272f0335'
DRIVER_SHA = '5e2ba86e07e28d0febbe3a811019fbf46197acc7367799b3598fa9077b6f0081'
ROWS = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21,23,24,25,26,28,29,30,33,35,36,38,39,40,42,43,44,46,48]
PROTECTED_ROWS = [16,22,27,31,32,34,37,41,45,47]
IMPORT_LINE = re.compile(rb'^\s*import\s+([^\n]+)', re.M)
D1_NAME = re.compile(rb'\bD1Bound5\.([A-Za-z0-9_]+)')

def sha(b):
    return hashlib.sha256(b).hexdigest()

def file_sha(p):
    h = hashlib.sha256()
    with p.open('rb') as f:
        for chunk in iter(lambda: f.read(1024*1024), b''):
            h.update(chunk)
    return h.hexdigest()

def packed(x):
    return (json.dumps(x, indent=2, sort_keys=True)+'\n').encode()

def read_pinned(path, digest):
    b = path.read_bytes()
    if sha(b) != digest:
        raise ValueError('Pin mismatch: '+str(path))
    return b

def imports_of(b):
    out = []
    for line in IMPORT_LINE.findall(b):
        out.extend(x.decode() for x in D1_NAME.findall(line.split(b'--',1)[0]))
    return out

def source_record(path, origin, rel, expected=None):
    b = path.read_bytes()
    digest = sha(b)
    if expected is not None and (digest != expected['sha256'] or len(b) != expected['bytes']):
        raise ValueError('Archived source pin mismatch: '+str(path))
    return {'origin':origin,'relative_path':rel,'sha256':digest,'bytes':len(b),
            'imports':imports_of(b)}

def closure(graph, names):
    out, todo = set(), list(names)
    while todo:
        n = todo.pop()
        if n not in out:
            if n not in graph:
                raise ValueError('Missing virtual source: '+n)
            out.add(n)
            todo.extend(graph[n])
    return out

def render_row(row, base, archived, helper):
    """Return candidate bytes plus exact source-only manifest; writes nothing."""
    selected = {role+str(row) for role in helper['ROLE_NAMES']}
    target = 'SmallPairGraphData'+str(row)
    originals, parts, declarations = {}, {}, []
    for n in sorted(selected):
        rel='D1Bound5/'+n+'.lean'
        if rel not in archived:
            raise ValueError('Missing heavy preimage '+rel)
        b=read_pinned(base/rel,archived[rel]['sha256'])
        if len(b)!=archived[rel]['bytes']:
            raise ValueError('Length mismatch '+rel)
        header,body,imports=helper['split_header'](b)
        names,commands=helper['inspect_scopes'](body)
        originals[n]=b
        parts[n]={'header':header,'body':body,'imports':imports,
                  'names':names,'commands':commands}
        declarations.extend(names)
    if len(declarations)!=len(set(declarations)):
        raise ValueError('Duplicate declaration')
    order,external,seen,visiting=[],[],set(),set()
    def visit(n):
        if n in visiting:raise ValueError('Cycle')
        if n in seen:return
        visiting.add(n)
        for dep in parts[n]['imports']:
            short=dep[len('D1Bound5.'):] if dep.startswith('D1Bound5.') else dep
            if dep.startswith('D1Bound5.') and short in selected:
                visit(short)
            elif dep not in external:
                external.append(dep)
        visiting.remove(n);seen.add(n);order.append(n)
    visit(target)
    if seen!=selected:raise ValueError('Not all eight bodies reachable')
    candidate=''.join('import '+n+'\n' for n in external).encode()+b'\n'
    records={}
    for n in order:
        part=parts[n]
        marker=('/- Preserved body from D1Bound5.'+n+
                '; original SHA256 '+sha(originals[n])+'. -/\n').encode()
        candidate+=marker
        start=len(candidate)
        candidate+=part['body']
        end=len(candidate)
        if candidate[start:end]!=part['body']:raise AssertionError('Body mismatch')
        records[n]={
            'archive_component':'base','archive_manifest_sha256':BASE_SHA,
            'relative_path':'D1Bound5/'+n+'.lean','source_sha256':sha(originals[n]),
            'source_bytes':len(originals[n]),'header_bytes':len(part['header']),
            'header_sha256':sha(part['header']),'body_bytes':len(part['body']),
            'body_sha256':sha(part['body']),
            'candidate_body_byte_start':start,'candidate_body_byte_end':end,
            'imports':part['imports'],'exported_names':part['names'],
            'scope_commands':part['commands']}
        candidate+=b'\n'
    result={
        'row':row,'target_module':target,'candidate_sha256':sha(candidate),
        'candidate_bytes':len(candidate),'body_order':order,
        'external_imports_original_first_encounter_order':external,
        'original_body_references':records,'exported_names':declarations,
        'exported_name_count':len(declarations),
        'all_eight_bodies_byte_identical_in_memory':True,
        'candidate_emitted':False}
    return candidate,result

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project',type=Path,required=True)
    ap.add_argument('--run',type=Path,required=True)
    ap.add_argument('--base',type=Path,required=True)
    ap.add_argument('--adaptive',type=Path,required=True)
    ap.add_argument('--helper',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--emit',action='store_true',help='Requires reviewed dry manifest and accepted pilot; research output only')
    ap.add_argument('--dry-manifest',type=Path)
    ap.add_argument('--review-receipt',type=Path)
    args=ap.parse_args()
    reviewed_bytes=None
    reviewed=None
    receipt=None
    if args.emit:
        if args.dry_manifest is None or args.review_receipt is None:
            raise ValueError('--emit requires --dry-manifest and --review-receipt')
        reviewed_bytes=args.dry_manifest.read_bytes()
        reviewed=json.loads(reviewed_bytes)
        receipt=json.loads(args.review_receipt.read_text())
        if (receipt.get('source_sha256')!=file_sha(Path(__file__)) or
            receipt.get('dry_manifest_sha256')!=sha(reviewed_bytes) or
            receipt.get('source_review_pass') is not True or
            receipt.get('root_approved') is not True or not receipt.get('reviewer')):
            raise ValueError('Exact independent review and root-approval receipt required')
    elif args.dry_manifest is not None or args.review_receipt is not None:
        raise ValueError('Review inputs are only valid in --emit mode')
    if os.path.lexists(args.output):
        raise FileExistsError('New report output directory required')
    args.output.parent.resolve(strict=True)
    bb=read_pinned(args.base/'manifest.json',BASE_SHA)
    ab=read_pinned(args.adaptive/'manifest.json',ADAPTIVE_SHA)
    hb=read_pinned(args.helper,HELPER_SHA)
    helper={'__name__':'readonly_row_merge_helpers','__file__':str(args.helper)}
    exec(compile(hb,str(args.helper),'exec'),helper)
    base,adaptive=json.loads(bb),json.loads(ab)
    if base['staged_rows']!=sorted(ROWS+[45]) or adaptive['rows']!=ROWS:
        raise ValueError('Frozen row selection changed')
    if set(ROWS)&set(PROTECTED_ROWS):raise AssertionError('Protected row selected')
    archived={}
    for entry in base['results']:
        if entry['row'] in ROWS:
            files=entry.get('files')
            if not files or len(files)!=11:
                raise ValueError('Expected exactly11 files per selected base row')
            archived.update(files)
    if len(archived)!=38*11:raise ValueError('Unexpected base source count')
    delta=adaptive['files']
    if len(delta)!=366:raise ValueError('Unexpected adaptive source count')
    for rel in delta:
        if not re.fullmatch(r'D1Bound5/SmallPairLight(?:Adaptive(?:Data|Validation|Left|Right)|Left|Right)[0-9]+(?:_[0-9]+)?\.lean',rel):
            raise ValueError('Unexpected adaptive file '+rel)

    # Current actual graph plus selected38 archived base and then adaptive overlay.
    source_map={}
    for p in sorted((args.project/'D1Bound5').glob('*.lean')):
        source_map[p.stem]=source_record(p,'project','D1Bound5/'+p.name)
    project_map=dict(source_map)
    for origin,folder,files in [('base',args.base,archived),('adaptive',args.adaptive,delta)]:
        for rel,expected in sorted(files.items()):
            if Path(rel).parts!=('D1Bound5',Path(rel).name):
                raise ValueError('Unsafe source path')
            n=Path(rel).stem
            source_map[n]=source_record(folder/rel,origin,rel,expected)
    virtual_graph={n:rec['imports'] for n,rec in source_map.items()}
    root_imports={}
    for p in sorted(args.project.glob('*.lean')):
        if p.name!='lakefile.lean':
            root_imports[p.name]=imports_of(p.read_bytes())
    original_main=closure(virtual_graph,['MainTheorem'])
    root_reach=closure(virtual_graph,[n for deps in root_imports.values() for n in deps])

    rows=[];candidate_graph=dict(virtual_graph);candidate_sources=dict(source_map)
    absorbed_all=set()
    for row in ROWS:
        candidate,rec=render_row(row,args.base,archived,helper)
        selected=set(rec['original_body_references']);target=rec['target_module']
        absorbed=selected-{target};absorbed_all.update(absorbed)
        external=[x[len('D1Bound5.'):] for x in rec['external_imports_original_first_encounter_order'] if x.startswith('D1Bound5.')]
        ext_closure=closure(virtual_graph,external)
        if selected&ext_closure:raise ValueError('External import reaches absorbed body')
        if closure(virtual_graph,[target])-selected!=ext_closure:
            raise ValueError('External closure differs')
        outside={n:sorted([k for k,deps in virtual_graph.items() if k not in selected and n in deps]+
                          [k for k,deps in root_imports.items() if n in deps])
                 for n in sorted(selected)}
        rec['outside_import_consumers']=outside
        rec['external_D1_modules']=sorted(ext_closure)
        rec['outside_absorbed_consumers_on_virtual_main_or_root']={
            n:[x for x in outside[n] if x in original_main or x in root_reach or x in root_imports]
            for n in sorted(absorbed) if any(x in original_main or x in root_reach or x in root_imports for x in outside[n])}
        candidate_graph[target]=external
        candidate_sources[target]={'origin':'planned-merged-not-emitted',
            'relative_path':'D1Bound5/'+target+'.lean','sha256':sha(candidate),
            'bytes':len(candidate),'imports':external}
        rows.append(rec)
        del candidate
    candidate_main=closure(candidate_graph,['MainTheorem'])
    if candidate_main!=original_main-absorbed_all:
        raise ValueError('Main closure changed beyond exactly266 absorbed modules')
    for n,rec in project_map.items():
        match=re.search(r'([0-9]+)(?:_[0-9]+)?$',n)
        if match and int(match.group(1)) in PROTECTED_ROWS and n.startswith('SmallPair'):
            if source_map[n]!=rec or candidate_sources[n]!=rec:
                raise AssertionError('Protected row virtual source changed')

    # Reuse the exact driver acceptance/snapshot rules, with virtual source bytes.
    sys.dont_write_bytecode=True
    dp=args.run/'continuation_driver_parallel.py'
    db=read_pinned(dp,DRIVER_SHA)
    mod=types.ModuleType('readonly_remaining_merge_driver');mod.__file__=str(dp)
    sys.modules[mod.__name__]=mod;exec(compile(db,str(dp),'exec'),mod.__dict__)
    controls={n:(args.run/n).read_bytes() for n in [
        'continuation-queue.json','continuation-builds.json','continuation-trusted-baseline.json']}
    actual_queue=json.loads(controls['continuation-queue.json'])
    planned_modules={Path(rel).stem for rel in archived}|{Path(rel).stem for rel in delta}
    proposed_names=list(dict.fromkeys(
        [n for n in actual_queue['names'] if n not in absorbed_all]+
        sorted(planned_modules-absorbed_all)))
    proposed_queue=dict(actual_queue);proposed_queue['names']=proposed_names
    class VirtualQueue:
        def read_text(self):return json.dumps(proposed_queue)
    class VirtualDriver(mod.Driver):
        def closure(self,name,seen=None,source_cache=None):
            cache={} if source_cache is None else source_cache
            if name in candidate_sources:
                rec=candidate_sources[name]
                cache[name]=(rec['sha256'],rec['imports'])
            return super().closure(name,seen,cache)
    vd=VirtualDriver(args.project,args.run);vd.queue_path=VirtualQueue()
    q,names,closures,accepted,unknown,eligible=vd.snapshot()
    latest=vd.latest()
    for rec in rows:
        target=rec['target_module']
        ext=rec['external_D1_modules']
        for n in ext:
            if n not in closures:closures[n]=vd.closure(n)
        rec['accepted_external_dependencies']=[n for n in ext if vd.accepted(n,closures,latest)]
        rec['unaccepted_external_dependencies']=[n for n in ext if n not in rec['accepted_external_dependencies']]
        rec['eligible_under_virtual_queue_and_exact_driver_rules']=target in eligible
        rec['untracked_nonqueued_inside_target_closure']=sorted(set(closures[target])&set(unknown))
        rec['outside_absorbed_consumers_in_proposed_queue']={
            n:[x for x in consumers if x in names]
            for n,consumers in rec['outside_import_consumers'].items()
            if n!=target and any(x in names for x in consumers)}
    manifest={
        'schema':1,'status':'SOURCE_ONLY_DRY_MANIFEST_NOT_EMISSION_AUTHORIZATION',
        'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'rows':ROWS,'protected_rows_unchanged':PROTECTED_ROWS,
        'base_manifest_sha256':BASE_SHA,'adaptive_manifest_sha256':ADAPTIVE_SHA,
        'body_parser_generator_sha256':HELPER_SHA,'exact_driver_sha256':DRIVER_SHA,
        'source_only_generator_sha256':file_sha(Path(__file__)),
        'source_references':source_map,
        'planned_merged_sources':{r['target_module']:candidate_sources[r['target_module']] for r in rows},
        'results':rows,
        'summary':{'rows':38,'original_heavy_modules':304,'planned_merged_modules':38,
            'absorbed_modules':len(absorbed_all),'base_files_referenced':len(archived),
            'adaptive_files_referenced':len(delta),'candidate_total_bytes':sum(r['candidate_bytes'] for r in rows),
            'lean_files_emitted':0,'preimage_source_bytes_copied':0,
            'virtual_main_before':len(original_main),'virtual_main_after':len(candidate_main)},
        'current_root_imports':root_imports,
        'original_virtual_main_reachable':sorted(original_main),
        'merged_virtual_main_reachable':sorted(candidate_main),
        'exact_driver_virtual_queue':{'actual_count':len(actual_queue['names']),
            'proposed_count':len(names),'global_unknown':unknown,'eligible_merged_targets':
            [r['target_module'] for r in rows if r['target_module'] in eligible],
            'removed_only_absorbed_from_existing_queue':sorted(set(actual_queue['names'])&absorbed_all),
            'added_prepared_modules':sorted(set(names)-set(actual_queue['names']))},
        'control_hashes':{n:sha(b) for n,b in controls.items()},
        'control_capture_stability':{n:(args.run/n).read_bytes()==b for n,b in controls.items()},
        'gates_before_any_future_emission_or_intake':[
            'Root confirms row45 merged pilot accepted at its exact source/full dependency fingerprint.',
            'Root and independent reviewer approve this exact planner/dry manifest.',
            'Before project intake: resolve queued outside consumers/global unknowns explicitly; do not weaken driver gates.',
            'Revalidate frozen archives and current source/queue/acceptance before selecting rows.',
            'Each planned pure dependency must pass the kernel at its actual exact source closure before its merged endpoint.'],
        'limits':[
            'Default mode emits JSON only. Reviewed --emit writes new research candidates, never project files, queues or Git.',
            'Complete preimages remain in archived base sources and are referenced by manifest/path/SHA; no149MB copy.',
            'Public names/types/proofs and each eight-body byte sequence are preserved in memory.',
            'Additional earlier imports and owning-module changes still need actual Lean compilation.',
            'Current unaccepted/planned dependencies are recorded honestly; no artifact-presence acceptance.']}
    if any(r['outside_absorbed_consumers_on_virtual_main_or_root'] for r in rows):
        raise ValueError('A merged row has a live outside source consumer')
    emitted_files={}
    if args.emit:
        if (reviewed.get('rows')!=ROWS or
            reviewed.get('base_manifest_sha256')!=BASE_SHA or
            reviewed.get('adaptive_manifest_sha256')!=ADAPTIVE_SHA or
            reviewed.get('body_parser_generator_sha256')!=HELPER_SHA or
            reviewed.get('source_only_generator_sha256')!=file_sha(Path(__file__))):
            raise ValueError('Reviewed manifest pins/selection mismatch')
        expected={r['row']:r for r in reviewed['results']}
        fixed=['row','target_module','candidate_sha256','candidate_bytes','body_order',
               'external_imports_original_first_encounter_order','original_body_references',
               'exported_names','exported_name_count','external_D1_modules']
        for rec in rows:
            if any(rec[k]!=expected[rec['row']][k] for k in fixed):
                raise ValueError('Body/import replay differs from reviewed dry manifest')
            for n in rec['external_D1_modules']:
                if source_map[n]!=reviewed['source_references'][n]:
                    raise ValueError('Reviewed external dependency source changed: '+n)
        real_driver=mod.Driver(args.project,args.run)
        pilot_closure=real_driver.closure('SmallPairGraphData45')
        if pilot_closure['SmallPairGraphData45']!='373463e9b5600703d80d2d098967a3029ee41ff3c22f1bec44e1f0e5a4281fd2':
            raise ValueError('Pilot source differs from reviewed merged45')
        if not real_driver.accepted('SmallPairGraphData45',{'SmallPairGraphData45':pilot_closure},real_driver.latest()):
            raise ValueError('Merged45 lacks current exact accepted kernel/artifact record')
        manifest['emission_gate']={
            'reviewed_dry_manifest_sha256':sha(reviewed_bytes),
            'review_receipt_sha256':file_sha(args.review_receipt),
            'pilot_source_sha256':pilot_closure['SmallPairGraphData45'],
            'pilot_full_closure_fingerprint':mod.fingerprint(pilot_closure),
            'pilot_exact_current_artifacts_accepted':True,
            'research_candidates_only':True,
            'planned_dependency_acceptance_not_implied':True}
    args.output.mkdir(exist_ok=False)
    if args.emit:
        (args.output/'D1Bound5').mkdir(exist_ok=False)
        for rec in rows:
            candidate,replay=render_row(rec['row'],args.base,archived,helper)
            if sha(candidate)!=rec['candidate_sha256']:
                raise ValueError('Archived source changed during candidate replay')
            rel='D1Bound5/'+rec['target_module']+'.lean'
            with (args.output/rel).open('xb') as f:f.write(candidate)
            emitted_files[rel]={'sha256':sha(candidate),'bytes':len(candidate)}
            rec['candidate_emitted']=True
        with (args.output/'reviewed-dry-manifest.json').open('xb') as f:f.write(reviewed_bytes)
        manifest['status']='RESEARCH_CANDIDATES_EMITTED_NOT_INSTALLED_OR_COMPILED'
        manifest['summary']['lean_files_emitted']=len(emitted_files)
        manifest['emitted_files']=emitted_files
    filename='emission-manifest.json' if args.emit else 'dry-manifest.json'
    payload=packed(manifest)
    with (args.output/filename).open('xb') as f:f.write(payload)
    print(json.dumps({'manifest_path':str(args.output/filename),
        'manifest_sha256':sha(payload),'manifest_bytes':len(payload),'summary':manifest['summary'],
        'global_unknown':unknown,'rows_with_queued_outside_consumers':
        {r['row']:r['outside_absorbed_consumers_in_proposed_queue'] for r in rows if r['outside_absorbed_consumers_in_proposed_queue']},
        'eligible_merged_targets':manifest['exact_driver_virtual_queue']['eligible_merged_targets'],
        'unaccepted_external_counts':{r['row']:len(r['unaccepted_external_dependencies']) for r in rows},
        'stability':manifest['control_capture_stability']}))

if __name__=='__main__':
    main()
