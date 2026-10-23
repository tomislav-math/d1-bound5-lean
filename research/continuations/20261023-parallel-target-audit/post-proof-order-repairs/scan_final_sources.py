#!/usr/bin/env python3
"""Read-only, exact-hash production MainTheorem source/import audit. No Lean acceptance claim."""
import argparse, hashlib, json, pathlib, re, time
R=pathlib.Path(__file__).resolve().parent
def sha(b):return hashlib.sha256(b).hexdigest()
def scrub(text):
    # Preserve positions/newlines while removing nested comments and string literals.
    out=list(text);i=0;n=len(text)
    def blank(a,b):
        for k in range(a,b):
            if out[k]!='\n':out[k]=' '
    while i<n:
        if text.startswith('--',i):
            j=text.find('\n',i);j=n if j<0 else j;blank(i,j);i=j
        elif text.startswith('/-',i):
            a=i;i+=2;depth=1
            while i<n and depth:
                if text.startswith('/-',i):depth+=1;i+=2
                elif text.startswith('-/',i):depth-=1;i+=2
                else:i+=1
            if depth:raise ValueError('unterminated block comment')
            blank(a,i)
        elif text[i]=='"':
            a=i;i+=1
            while i<n:
                if text[i]=='\\':i+=2
                elif text[i]=='"':i+=1;break
                else:i+=1
            else:raise ValueError('unterminated string')
            blank(a,min(i,n))
        elif text[i]=='r' and (m:=re.match(r'r(#+)"',text[i:])):
            a=i;end='"'+m.group(1);j=text.find(end,i+len(m.group(0)))
            if j<0:raise ValueError('unterminated raw string')
            i=j+len(end);blank(a,i)
        else:i+=1
    return ''.join(out)
RULES={
 'admitted_or_unsafe_proof':r'\b(?:sorry|admit|sorryAx|native_decide|native_decide_term|implemented_by|unsafe|extern)\b',
 'explicit_axiom':r'\b(?:axiom|constant|constants)\b',
 'kernel_or_trust_override':r'\b(?:skipKernelTC|skipKernelTypeChecking|trustLevel|trust_level|trustKernel|enableKernel|disableKernel)\b',
 'environment_mutation':r'\b(?:setEnv|modifyEnv|modifyEnvImpl|addDecl|addAndCompile|addAndCompileDecl|addDeclCore|addConstInfo|setEnvUnsafe|importModules)\b|\b(?:Environment|env)\.(?:add|set|insert|modify)\b',
 'metaprogramming_review':r'\b(?:run_cmd|run_elab|elab|elab_rules|macro|macro_rules|initialize|builtin_initialize)\b|#eval\b',
 'meta_namespace_review':r'\b(?:Meta|Elab|Lean\.Environment)\b',
 'opaque_or_interpolated_code_review':r'\bopaque\b|\b(?:s|m|f)!',
}
def main():
    a=argparse.ArgumentParser();a.add_argument('--project',type=pathlib.Path,default=R/'project');a.add_argument('--out',type=pathlib.Path,default=R/'target-source-audit');a.add_argument('--root-module',default='D1Bound5.MainTheorem');a.add_argument('--reuse-audit',type=pathlib.Path);a.add_argument('--root-candidate',type=pathlib.Path);args=a.parse_args()
    P=args.project;O=args.out;O.mkdir(parents=True,exist_ok=True)
    modules={};imports={};external=set();missing=[];errors=[];findings=[];options=[];axiom_reports=[];reused=[];cache=None
    if args.reuse_audit:
        Q=args.reuse_audit
        cache={n:json.loads((Q/n).read_text()) for n in ['SOURCE_MANIFEST.json','IMPORT_GRAPH.json','OPTIONS.json','ORDINARY_AXIOM_REPORTS.json','SOURCE_AUDIT.json','SOURCE_AUDIT_REVIEWED.json']}
        assert cache['SOURCE_AUDIT_REVIEWED.json']['status']=='PASS_SOURCE_REVIEWED'
        external.update(cache['SOURCE_AUDIT.json']['external_imports_not_scanned'])
    def visit(mod):
        if mod in modules:return
        p=P/pathlib.Path(*mod.split('.')).with_suffix('.lean')
        if not p.exists():
            if mod not in missing:missing.append(mod)
            return
        b=(args.root_candidate if mod==args.root_module and args.root_candidate else p).read_bytes();modules[mod]={'sha256':sha(b),'bytes':len(b),'relative_path':str(p.relative_to(P))}
        if cache and mod in cache['SOURCE_MANIFEST.json'] and cache['SOURCE_MANIFEST.json'][mod]['sha256']==sha(b):
            reused.append(mod);im=cache['IMPORT_GRAPH.json'][mod];imports[mod]=im
            findings.extend(x for x in cache['SOURCE_AUDIT.json']['findings'] if x['module']==mod)
            options.extend(x for x in cache['OPTIONS.json'] if x['module']==mod)
            axiom_reports.extend(x for x in cache['ORDINARY_AXIOM_REPORTS.json'] if x['module']==mod)
            for child in im:visit(child)
            return
        text=b.decode();code=scrub(text);im=[]
        for m in re.finditer(r'(?m)^[ \t]*(?:public\s+|private\s+)?import\s+([^\n]+)',code):
            for v in m.group(1).split():
                if v.startswith('D1Bound5.'):im.append(v)
                else:external.add(v)
        imports[mod]=im
        for category,pattern in RULES.items():
            for m in re.finditer(pattern,code):
                line=code.count('\n',0,m.start())+1
                findings.append({'module':mod,'line':line,'category':category,'token':m.group(0),'source_line':text.splitlines()[line-1].strip()})
        for m in re.finditer(r'(?m)^[ \t]*set_option\s+(\S+)\s+([^\n]+)',code):
            options.append({'module':mod,'line':code.count('\n',0,m.start())+1,'name':m.group(1),'value':m.group(2).strip()})
        for m in re.finditer(r'(?m)^[ \t]*#print\s+axioms\s+([^\n]+)',code):
            axiom_reports.append({'module':mod,'line':code.count('\n',0,m.start())+1,'declaration':m.group(1).strip()})
        # Any other standalone plural occurrence needs review; ordinary #print is evidence only.
        for m in re.finditer(r'\baxioms\b',code):
            line=code.count('\n',0,m.start())+1
            if not any(x['module']==mod and x['line']==line for x in axiom_reports):
                findings.append({'module':mod,'line':line,'category':'plural_axioms_review','token':'axioms','source_line':text.splitlines()[line-1].strip()})
        for child in im:visit(child)
    try:visit(args.root_module)
    except Exception as e:errors.append(repr(e))
    changed=[]
    for mod,row in modules.items():
        p=args.root_candidate if mod==args.root_module and args.root_candidate else P/row['relative_path']
        if not p.exists() or sha(p.read_bytes())!=row['sha256']:changed.append(mod)
    special_options=[x for x in options if re.search(r'kernel|trust|unsafe|debug|native|proof|admit|sorry',x['name'],re.I)]
    report={'status':'PASS_SOURCE_ONLY' if not(missing or errors or changed or findings or special_options) else 'REVIEW_REQUIRED',
      'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'root_module':args.root_module,'module_count':len(modules),
      'source_bytes':sum(x['bytes'] for x in modules.values()),'missing_sources':sorted(missing),'source_changes_during_scan':changed,
      'scanner_errors':errors,'findings':findings,'sensitive_options':special_options,'ordinary_print_axioms_count':len(axiom_reports),
      'external_imports_not_scanned':sorted(external),'scope':'Project production sources in exact stated root-module import closure; comments/string literals excluded. External mathlib/Lean modules and out-of-closure research audit scripts are not production sources in this scan. Ordinary #print axioms is recorded separately.',
      'limitations':'Static source audit only; does not replace compiler, exact-type, transitive-axiom or kernel verification. Root must revalidate this exact source manifest after any final edits.',
      'scanner_sha256':sha(pathlib.Path(__file__).read_bytes()),'global_main_theorem_complete':False}
    if cache:
        report['reused_unchanged_reviewed_module_count']=len(reused)
        report['reused_audit_evidence']={n:sha((args.reuse_audit/n).read_bytes()) for n in cache}
        report['new_or_changed_source_modules_scanned']=sorted(set(modules)-set(reused))
    if args.root_candidate:
        report['read_only_root_candidate_overlay']=str(args.root_candidate)
    for name,obj in [('SOURCE_MANIFEST.json',modules),('IMPORT_GRAPH.json',imports),('OPTIONS.json',options),('ORDINARY_AXIOM_REPORTS.json',axiom_reports),('SOURCE_AUDIT.json',report)]:
        (O/name).write_text(json.dumps(obj,indent=2,sort_keys=True)+'\n')
    print(json.dumps({k:report[k] for k in ['status','module_count','source_bytes','missing_sources','source_changes_during_scan','scanner_errors','ordinary_print_axioms_count']}))
    print(json.dumps({'findings':findings,'sensitive_options':special_options}))
if __name__=='__main__':main()
