import argparse,ast,hashlib,json,os,re,stat
from pathlib import Path
PREFIX_PIN='e35bc9bd4f83a9884903c2d92c06296fa7806446550f1c2694714cbf8498ad64'
GRAPH_PIN='fff4d1cfeb13b54020ab01546eeeaa2f0c43a5696780d4ccb252411ea0eb5efd'
FIELDS_PIN='d53a205f458a39f63b2d2b0ce79839340264ea820b70ceb4cbf43cac88971728'
sha=lambda b:hashlib.sha256(b).hexdigest()
def need(ok,msg):
    if not ok: raise ValueError(msg)
def regular(p):
    p=Path(os.path.abspath(p));need(all(not q.is_symlink() for q in [p,*p.parents]),'symlink input')
    before=p.stat();need(stat.S_ISREG(before.st_mode),'nonregular input');b=p.read_bytes();after=p.stat()
    stamp=lambda s:(s.st_dev,s.st_ino,s.st_size,s.st_mtime_ns,s.st_ctime_ns)
    need(stamp(before)==stamp(after) and len(b)==after.st_size,'input changed');return b
def pinned(p,h,size=None):
    b=regular(p);need(sha(b)==h and (size is None or len(b)==size),'pin '+str(p));return b
def safe_relative(s):
    p=Path(s);need(not p.is_absolute() and all(x not in ('','..','.') for x in s.split('/')) and str(p)==s,'manifest traversal');return p
CERT=re.compile(rb'^(def pellFiniteCertificate_(\d+) : PellFiniteCertificate (\d+) \(10\^275\)) where\n  a0 := (\d+)\n  lastIndex := (\d+)\n  graph := ([^\n]+)\n  prefix_checked := by decide \+kernel\n  stopping := by decide \+kernel\n  magnitudes_eq := by decide \+kernel\n',re.M)
MAG=re.compile(rb'^def pellMagnitudes_(\d+) : List \xe2\x84\xa4 :=\n  (\[.*?\])\n',re.M)
OPTS=b'\nnamespace D1Bound5.PellLightProduction\nset_option maxRecDepth 32768\nset_option maxHeartbeats 12000000\n\n'
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bundle-dir',type=Path,required=True);ap.add_argument('--output-dir',type=Path,required=True)
    ap.add_argument('--stage-light',default='PellLightPrefixData1');ap.add_argument('--emit',action='store_true');ap.add_argument('--emit-heavy',action='store_true');ap.add_argument('--expected-manifest',type=Path);a=ap.parse_args()
    out=Path(os.path.abspath(a.output_dir));need(not os.path.lexists(out),'output exists');need(out.parent.is_dir() and all(not p.is_symlink() for p in [out.parent,*out.parent.parents]),'invalid output parent')
    pm=json.loads(pinned(a.bundle_dir/'prefix_source_manifest.json',PREFIX_PIN));gm=json.loads(pinned(a.bundle_dir/'graph_source_manifest.json',GRAPH_PIN))
    need(len(pm)==65 and len(gm)==27,'manifest lengths')
    need([Path(r['file']).stem for r in pm]==['PellFinitePilot']+[f'PellFiniteData{i}' for i in range(1,65)],'prefix module order')
    graph={};graph_modules=[];inputpins={}
    for r in gm:
        rel=safe_relative(r['file']);b=pinned(a.bundle_dir/rel,r['sha256'],r['bytes']);inputpins[str(rel)]=sha(b);module=rel.stem;graph_modules.append(module)
        ms=list(MAG.finditer(b));need([int(m.group(1)) for m in ms]==r['fields'],'graph fields')
        for m in ms:
            d=int(m.group(1));lit=m.group(2);xs=ast.literal_eval(lit.decode());need(d not in graph and isinstance(xs,list) and xs and all(type(x)is int for x in xs),'graph literals')
            graph[d]=(module,lit,len(xs))
    need(len(graph)==409,'nonempty graph count')
    outputs={};records=[];lightmodules=[];headers=[]
    for r in pm:
        rel=safe_relative(r['file']);b=pinned(a.bundle_dir/rel,r['sha256'],r['bytes']);inputpins[str(rel)]=sha(b)
        ms=list(CERT.finditer(b));need([int(m.group(2)) for m in ms]==r['fields'],'prefix fields')
        need(len(re.findall(rb'^def ',b,re.M))==len(ms),'unparsed prefix definition')
        module='PellLightPrefixPilot' if rel.stem=='PellFinitePilot' else rel.stem.replace('PellFiniteData','PellLightPrefixData')
        lightmodules.append(module);src=b'import D1Bound5.PellLightCF\n'+OPTS
        for m in ms:
            header=m.group(1);d=int(m.group(2));need(d==int(m.group(3)),'type field disagreement');a0=int(m.group(4));n=int(m.group(5));g=m.group(6).decode()
            expected=f'pellGraphCertificate_{d}' if d in graph else f'pellEmptyMatchingCertificate {d}';need(g==expected,'graph expression changed')
            lit=graph[d][1] if d in graph else b'[]';count=graph[d][2] if d in graph else 0
            src+=f'def magnitudes_{d} : List Int :=\n  '.encode()+lit+b'\n\n'
            src+=f'theorem checked_{d} :\n    pellLightFiniteCheck {d} {a0} (10^275) {n} magnitudes_{d} = true := by\n  decide +kernel\n\n'.encode()
            records.append(dict(field=d,a0=a0,lastIndex=n,graph=g,magnitude_literal_sha256=sha(lit),magnitudes=count,light_module=module,original_type=header.decode()))
            headers.append(header)
        src+=b'end D1Bound5.PellLightProduction\n';outputs[f'D1Bound5/{module}.lean']=src
    need(len(records)==1016 and len({r['field'] for r in records})==1016,'complete field coverage')
    need({r['field'] for r in records if r['magnitudes']}==set(graph),'graph/prefix coverage')
    imports=['PellLightFiniteAdapter']+lightmodules+graph_modules;need(len(imports)==len(set(imports)),'duplicate import')
    heavy=''.join(f'import D1Bound5.{n}\n' for n in imports).encode()+b'\nnamespace D1Bound5\nset_option maxRecDepth 32768\nset_option maxHeartbeats 12000000\n\n'
    for r,header in zip(records,headers):
        d=r['field'];a0=r['a0'];n=r['lastIndex'];g=r['graph'];garg=g if d in graph else '('+g+')'
        heavy+=header+b' :=\n'+f'  pellFiniteCertificateOfLight {d} (10^275) {a0} {n} {garg} (by\n    change pellLightFiniteCheck {d} {a0} (10^275) {n} PellLightProduction.magnitudes_{d} = true\n    exact PellLightProduction.checked_{d})\n\n'.encode()
    heavy+=b'end D1Bound5\n'
    actual=re.findall(rb'^(def pellFiniteCertificate_\d+ : PellFiniteCertificate \d+ \(10\^275\)) :=',heavy,re.M);need(actual==headers,'original public types not preserved')
    outputs['D1Bound5/PellLightAllFiniteCertificates.lean']=heavy
    old=pinned(a.bundle_dir/'PellFiniteFields.lean',FIELDS_PIN);prefix_imports=''.join(f"import D1Bound5.{Path(r['file']).stem}\n" for r in pm).encode();need(old.startswith(prefix_imports),'unexpected Fields imports')
    body=old[len(prefix_imports):];newimport=b'import D1Bound5.PellLightAllFiniteCertificates\n';outputs['D1Bound5/PellFiniteFields.lean']=newimport+body;need(outputs['D1Bound5/PellFiniteFields.lean'][len(newimport):]==body,'Fields body changed')
    selected=set(lightmodules) if a.stage_light=='all' else set(filter(None,a.stage_light.split(',')));need(selected<=set(lightmodules),'unknown light stage')
    staged={f'D1Bound5/{n}.lean' for n in selected}
    if a.emit_heavy: staged|={'D1Bound5/PellLightAllFiniteCertificates.lean','D1Bound5/PellFiniteFields.lean'}
    manifest=dict(generator_sha256=sha(regular(__file__)),prefix_manifest_sha256=PREFIX_PIN,graph_manifest_sha256=GRAPH_PIN,original_fields_sha256=FIELDS_PIN,original_fields_body_sha256=sha(body),source_pins=inputpins,fields=records,field_count=1016,original_public_types_preserved=True,original_graphs_preserved=True,exact_magnitude_literal_bytes_preserved=True,fields_body_unchanged=True,new_shared_module_direct_imports_exclude_old_prefix_modules=True,staged=sorted(staged),outputs={n:dict(bytes=len(v),sha256=sha(v),staged=n in staged) for n,v in sorted(outputs.items())})
    if a.expected_manifest:need(manifest==json.loads(regular(a.expected_manifest)),'expected manifest mismatch')
    out.mkdir(mode=0o700)
    if a.emit:
        (out/'D1Bound5').mkdir(mode=0o700)
        for n in sorted(staged):
            with (out/n).open('xb') as f:f.write(outputs[n])
    with (out/'manifest.json').open('x') as f:json.dump(manifest,f,indent=2);f.write('\n')
    print(json.dumps(dict(fields=1016,pure_modules=65,heavy_modules=2,staged=sorted(staged),emitted=a.emit,manifest_sha256=sha(regular(out/'manifest.json'))),indent=2))
if __name__=='__main__':main()
