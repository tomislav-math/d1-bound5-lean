#!/usr/bin/env python3
"""Pinned 409-field Pell matching production preparation; research outputs only.
Default writes a dry manifest. Explicit --emit writes 72 pure modules and one
heavy assembly; --emit-consumer additionally writes the separately pinned
import-only CF consumer replacement. No wrappers or project files are changed.
"""
import argparse, hashlib, json, os, re, stat
from pathlib import Path

PILOT_GENERATOR_PIN = '0cf59ebda722f7a749b4619f267ff535bb81761cdc284584adc3655ccecfe393'
GRAPH_MANIFEST_PIN = 'fff4d1cfeb13b54020ab01546eeeaa2f0c43a5696780d4ccb252411ea0eb5efd'
CHECK_PIN = 'c1c0284d3cb9fe91ae3599a7d1d28cf05b2201c8cbaef193b20c1b2b5f4ccfa0'
HELPERS = {
    'PellLightMatching.lean': '3ac624524aca77968a148009c6a760dcc5c6aecfa02aa6a1652c7bf7443543c6',
    'PellLightMatchingBridge.lean': '3af9720af80ec1c3ef20365df808d156ab2bd101049dc40f988188fc0fca462e',
}
CF_SOURCE_PIN = '299fed9e0dc2dcc2f7a1289fbd3304b86c66cfc45a84a66214a361414a6557be'
PILOT_OUTPUT_PIN = 'cb2b47876127a30e241273d61a4c1a7056c0b462398797ee7f4519b7c4f90d82'
sha = lambda b: hashlib.sha256(b).hexdigest()

def need(ok, message):
    if not ok:
        raise ValueError(message)

def regular(path):
    path = Path(os.path.abspath(path))
    need(all(not p.is_symlink() for p in [path,*path.parents]), 'symlink input')
    before = path.stat()
    need(stat.S_ISREG(before.st_mode), 'nonregular input')
    b = path.read_bytes()
    after = path.stat()
    stamp = lambda s: (s.st_dev,s.st_ino,s.st_size,s.st_mtime_ns,s.st_ctime_ns)
    need(stamp(before) == stamp(after) and len(b) == after.st_size, 'input changed')
    return b

def pinned(path, digest, size=None):
    b = regular(path)
    need(sha(b) == digest and (size is None or len(b) == size), 'pin mismatch '+str(path))
    return b

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--bundle-dir',type=Path,required=True)
    ap.add_argument('--pilot-generator',type=Path,required=True)
    ap.add_argument('--check-source',type=Path,required=True)
    ap.add_argument('--definitions-source',type=Path,required=True)
    ap.add_argument('--bridge-source',type=Path,required=True)
    ap.add_argument('--cf-source',type=Path,required=True)
    ap.add_argument('--output-dir',type=Path,required=True)
    ap.add_argument('--emit',action='store_true')
    ap.add_argument('--emit-consumer',action='store_true')
    ap.add_argument('--expected-manifest',type=Path)
    a = ap.parse_args()
    need(not a.emit_consumer or a.emit, '--emit-consumer requires --emit')
    helper = pinned(a.pilot_generator,PILOT_GENERATOR_PIN)
    ns = {'__name__':'frozen_pell_matching_pilot','__file__':str(a.pilot_generator)}
    exec(compile(helper,str(a.pilot_generator),'exec'),ns)
    pinned(a.check_source,CHECK_PIN)
    pinned(a.definitions_source,HELPERS['PellLightMatching.lean'])
    pinned(a.bridge_source,HELPERS['PellLightMatchingBridge.lean'])
    mb = pinned(a.bundle_dir/'graph_source_manifest.json',GRAPH_MANIFEST_PIN)
    gm = json.loads(mb)
    expected_files = ['graphs/PellMatchingPilot.lean']+[f'graphs/PellMatchingData{i}.lean' for i in range(1,27)]
    need([r['file'] for r in gm] == expected_files, 'exact27 original groups')
    out = Path(os.path.abspath(a.output_dir))
    need(not os.path.lexists(out), 'output exists')
    need(out.parent.is_dir() and all(not p.is_symlink() for p in [out.parent,*out.parent.parents]), 'invalid output parent')
    rows, groups, source_records = [], [], []
    for src in gm:
        b = pinned(a.bundle_dir/src['file'],src['sha256'],src['bytes'])
        need(b.startswith(ns['HEADER']) and b.endswith(ns['FOOTER']), 'source context')
        body = b[len(ns['HEADER']):-len(ns['FOOTER'])]
        starts = list(re.finditer(rb'^def pellMagnitudes_(\d+) : List ',body,re.M))
        need(starts and starts[0].start()==0 and [int(m.group(1)) for m in starts]==src['fields'], 'exact source fields')
        blocks = [body[m.start():starts[i+1].start() if i+1<len(starts) else len(body)] for i,m in enumerate(starts)]
        need(b''.join(blocks)==body, 'exact source partition')
        gr = []
        for m,block in zip(starts,blocks):
            d=int(m.group(1));r=ns['parse_block'](d,block);r['source']=src['file']
            names={x.group(1).decode() for x in ns['DECL'].finditer(block)}
            refs=set(re.findall(r'\bpell(?:Magnitudes|Masks|Witnesses|Matching|GraphCertificate)_\d+(?:_(?:valid|checked|large))?\b',block.decode()))
            need(refs<=names,'cross-field reference')
            rows.append(r);gr.append(r)
        groups.append((src,gr));source_records.append(src)
    need(len(rows)==409 and len({r['field'] for r in rows})==409,'exact409 fields')
    need(sum(r['vertices'] for r in rows)==9806 and sum(r['pairs'] for r in rows)==258220,'original workload')
    outputs={};pure_modules=[];module_records=[]
    pure_prefix=(b'import D1Bound5.PellLightMatching\n\nnamespace D1Bound5.PellMatchingLightProduction\n'+ns['OPTIONS'])
    pure_suffix=b'end D1Bound5.PellMatchingLightProduction\n'
    split_names={f'graphs/PellMatchingData{i}.lean' for i in (1,2,3)}
    for src,gr in groups:
        batches=[[r] for r in gr] if src['file'] in split_names else [gr]
        for batch in batches:
            if src['file'] in split_names:
                module=f'PellLightMatchingField{batch[0]["field"]}'
            else:
                module=Path(src['file']).stem.replace('PellMatching','PellLightMatching',1)
            pieces=[ns['pure_source'](r) for r in batch]
            need(all(p.startswith(pure_prefix) and p.endswith(pure_suffix) for p in pieces),'pure source envelope')
            generated=pure_prefix+b''.join(p[len(pure_prefix):-len(pure_suffix)] for p in pieces)+pure_suffix
            name=f'D1Bound5/{module}.lean';need(name not in outputs,'duplicate pure module')
            outputs[name]=generated;pure_modules.append(module)
            module_records.append(dict(module=module,original_group=src['file'],fields=[r['field'] for r in batch],
                vertices=sum(r['vertices'] for r in batch),pairs=sum(r['pairs'] for r in batch)))
    need(len(pure_modules)==72 and len(set(pure_modules))==72,'48individual plus24grouped modules')
    need(sum(len(x['fields']) for x in module_records)==409,'module coverage')
    need(sha(outputs['D1Bound5/PellLightMatchingField7.lean'])==PILOT_OUTPUT_PIN,'accepted field7 bytes changed')
    heavy=(b'import D1Bound5.PellLightMatchingBridge\n'+b''.join(
        f'import D1Bound5.{name}\n'.encode() for name in pure_modules)+
        b'\nnamespace D1Bound5\n'+ns['OPTIONS']+b''.join(ns['adapter_block'](r) for r in rows)+ns['FOOTER'])
    old_heads=[h for r in rows for h in r['heads']]
    new_heads=[ns['decl_header'](heavy[m.start():]) for m in ns['DECL'].finditer(heavy)]
    need(new_heads==old_heads and len(new_heads)==2863,'all2863 original public headers')
    assembly_name='D1Bound5/PellLightAllMatchingCertificates.lean';outputs[assembly_name]=heavy
    cf=pinned(a.cf_source,CF_SOURCE_PIN)
    old_imports=[f'import D1Bound5.{Path(r["file"]).stem}\n'.encode() for r in gm]
    need(all(cf.splitlines(keepends=True).count(x)==1 for x in old_imports),'exact27 CF imports')
    old_set=set(old_imports);new_line=b'import D1Bound5.PellLightAllMatchingCertificates\n'
    patched=[];inserted=False
    for line in cf.splitlines(keepends=True):
        if line in old_set:
            if not inserted:patched.append(new_line);inserted=True
        else:patched.append(line)
    new_cf=b''.join(patched)
    marker=b'\nnamespace D1Bound5\n'
    need(cf.count(marker)==1 and new_cf.count(marker)==1,'CF body boundary')
    old_body=cf.split(marker,1)[1];need(new_cf.split(marker,1)[1]==old_body,'CF body changed')
    need(not any(x in new_cf.splitlines(keepends=True) for x in old_imports),'old CF matching import remains')
    need(len(list(ns['DECL'].finditer(new_cf)))==1016,'CF declaration coverage')
    consumer_name='D1Bound5/PellLightAllFiniteCertificates.lean';outputs[consumer_name]=new_cf
    production_names=sorted(set(outputs)-{consumer_name})
    need(len(production_names)==73,'production source count')
    manifest=dict(generator_sha256=sha(regular(__file__)),pilot_generator_sha256=PILOT_GENERATOR_PIN,
        graph_manifest_sha256=GRAPH_MANIFEST_PIN,original_check_sha256=CHECK_PIN,helper_sha256=HELPERS,
        source_groups=source_records,field_count=409,public_declaration_count=2863,
        module_count=72,module_plan=module_records,
        fields=[{k:v for k,v in r.items() if k not in ('heads','literals','certificate')} |
            {'literal_sha256':[sha(x) for x in r['literals']],
             'public_headers':[h.decode() for h in r['heads']]} for r in rows],
        all_original_public_headers_preserved=True,all_original_literal_bytes_preserved=True,
        accepted_field7_sha256=PILOT_OUTPUT_PIN,empty_certificate_unchanged_owner='D1Bound5.PellMatchingCheck',
        no_old_module_wrappers_generated=True,
        consumer_patch=dict(module='D1Bound5.PellLightAllFiniteCertificates',before_sha256=CF_SOURCE_PIN,
            after_sha256=sha(new_cf),old_imports_removed=27,new_imports_added=1,
            body_sha256=sha(old_body),body_byte_identical=True,separate_explicit_emission_required=True),
        production_source_names=production_names,consumer_source_name=consumer_name,
        outputs={name:dict(bytes=len(b),sha256=sha(b),consumer_patch=name==consumer_name) for name,b in sorted(outputs.items())})
    if a.expected_manifest:
        need(manifest==json.loads(regular(a.expected_manifest)),'exact replay mismatch')
    out.mkdir(mode=0o700)
    emitted=[]
    if a.emit:
        (out/'D1Bound5').mkdir(mode=0o700)
        selected=production_names+([consumer_name] if a.emit_consumer else [])
        for name in selected:
            with (out/name).open('xb') as f:f.write(outputs[name])
            emitted.append(name)
    with (out/'manifest.json').open('x') as f:json.dump(manifest,f,indent=2);f.write('\n')
    print(json.dumps(dict(fields=409,pure_modules=72,public_declarations=2863,
        production_sources=73,emitted=len(emitted),manifest_sha256=sha(regular(out/'manifest.json'))),indent=2))

if __name__=='__main__':
    main()
