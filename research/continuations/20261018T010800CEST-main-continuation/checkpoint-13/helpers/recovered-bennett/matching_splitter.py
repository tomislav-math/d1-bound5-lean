import argparse, ast, hashlib, json, os, re, stat
from pathlib import Path
PINS={1:(926825,'4e50cd4ea81386b59a97b6de37846d484690780955d264313684ef33f9699869'),2:(390879,'603fbbad5cd1f676c7b5d4f05678ed0716cc31e766487aa81dad2e9d405d3d73'),3:(307132,'ebbed025e58033ddcdd4e28192a00f65fb88db7128c0b6186abf4ad4ca1d74f8')}
HEAD=b'import D1Bound5.PellMatchingCheck\n\nnamespace D1Bound5\nset_option maxRecDepth 32768\nset_option maxHeartbeats 12000000\n\n'
TAIL=b'end D1Bound5\n'
START=re.compile(rb'^def pellMagnitudes_(\d+) : List \xe2\x84\xa4 :=\n',re.M)
DECL=re.compile(rb'^(def|theorem) ([A-Za-z_][A-Za-z_0-9]*)\b',re.M)
TOK=re.compile(rb'[A-Za-z_][A-Za-z_0-9]*')
REF=re.compile(rb'pell(?:Magnitudes|Masks|Witnesses|Matching|GraphCertificate)_(\d+)(?:_[A-Za-z_0-9]+)?\Z')
sha=lambda b:hashlib.sha256(b).hexdigest()
def need(ok,msg):
    if not ok: raise ValueError(msg)
def regular(p):
    p=Path(os.path.abspath(p)); need(all(not q.is_symlink() for q in [p,*p.parents]),'symlink source')
    before=p.stat(); need(stat.S_ISREG(before.st_mode),'nonregular source'); b=p.read_bytes(); after=p.stat()
    stamp=lambda s:(s.st_dev,s.st_ino,s.st_size,s.st_mtime_ns,s.st_ctime_ns)
    need(stamp(before)==stamp(after) and len(b)==after.st_size,'changed source'); return b
def names(d):
    return [('def',f'pellMagnitudes_{d}'),('def',f'pellMasks_{d}'),('def',f'pellWitnesses_{d}'),('theorem',f'pellMasks_{d}_valid'),('theorem',f'pellMatching_{d}_checked'),('theorem',f'pellMagnitudes_{d}_large'),('def',f'pellGraphCertificate_{d}')]
def numbers(s):
    a=[] if not s else [int(x) for x in s.split(',')]; need(len(a)==len(set(a)),'duplicate selection'); return set(a)
def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--source-dir',type=Path,required=True); ap.add_argument('--output-dir',type=Path,required=True)
    ap.add_argument('--stage-fields',default='7'); ap.add_argument('--stage-aggregates',default='1'); ap.add_argument('--emit',action='store_true'); ap.add_argument('--expected-manifest',type=Path); a=ap.parse_args()
    out=Path(os.path.abspath(a.output_dir)); need(not os.path.lexists(out),'output exists'); need(out.parent.is_dir() and all(not p.is_symlink() for p in [out.parent,*out.parent.parents]),'invalid output parent')
    outputs={}; records=[]; groups=[]; original=[]
    for g in (1,2,3):
        b=regular(a.source_dir/f'PellMatchingData{g}.lean'); need((len(b),sha(b))==PINS[g],f'pin Data{g}'); need(b.startswith(HEAD) and b.endswith(TAIL),'context changed')
        starts=list(START.finditer(b)); need(len(starts)==16 and starts[0].start()==len(HEAD),'field count'); blocks=[]; fields=[]
        for i,m in enumerate(starts):
            d=int(m.group(1)); end=starts[i+1].start() if i+1<len(starts) else len(b)-len(TAIL); block=b[m.start():end]
            ds=[(k.decode(),n.decode()) for k,n in DECL.findall(block)]; need(ds==names(d),f'declarations {d}')
            top=[s for s in block.splitlines() if s and not chr(s[0]).isspace()]; need(len(top)==7 and all(DECL.match(s) for s in top),f'commands {d}')
            local={n.encode() for _,n in ds}
            for t in TOK.findall(block):
                r=REF.fullmatch(t)
                if r: need(int(r.group(1))==d and t in local,f'foreign field reference {t!r}')
            lit=re.search(rb'^def pellMagnitudes_\d+ : List .*? :=\n  (\[.*?\])\n',block,re.M).group(1); mags=ast.literal_eval(lit.decode()); need(isinstance(mags,list) and all(type(x)is int for x in mags),'magnitude literal')
            name=f'D1Bound5/PellMatchingField{d}.lean'; need(name not in outputs,'duplicate module'); outputs[name]=HEAD+block+TAIL
            need(outputs[name][len(HEAD):-len(TAIL)]==block,'block changed')
            records.append(dict(field=d,parent=g,block_start=m.start(),block_end=end,block_sha256=sha(block),block_bytes=len(block),declarations=[n for _,n in ds],cross_field_dependencies=[],magnitudes=len(mags),unordered_pairs=len(mags)*(len(mags)-1)//2))
            fields.append(d); blocks.append(block)
        need(len(set(fields))==16 and HEAD+b''.join(blocks)+TAIL==b,'partition failed')
        outputs[f'D1Bound5/PellMatchingData{g}.lean']=''.join(f'import D1Bound5.PellMatchingField{d}\n' for d in fields).encode()
        groups.append(dict(group=g,sha256=sha(b),bytes=len(b),fields=fields,exact_partition=True)); original += [n.decode() for _,n in DECL.findall(b)]
    need(len(records)==48 and len({r['field'] for r in records})==48,'field overlap'); need(len(original)==336 and original==[n for r in records for n in r['declarations']],'public declaration coverage')
    selected={r['field'] for r in records} if a.stage_fields=='all' else numbers(a.stage_fields); aggs=numbers(a.stage_aggregates)
    need(selected<={r['field'] for r in records} and aggs<={1,2,3},'unknown selection')
    staged={f'D1Bound5/PellMatchingField{d}.lean' for d in selected}|{f'D1Bound5/PellMatchingData{g}.lean' for g in aggs}
    manifest=dict(generator_sha256=sha(regular(__file__)),original_groups=groups,fields=records,exact_336_declarations_preserved=True,no_cross_field_dependencies=True,staged_fields=sorted(selected),staged_aggregate_drafts=sorted(aggs),aggregate_status='HELD until every imported field module passes',outputs={n:dict(sha256=sha(v),bytes=len(v),staged=n in staged) for n,v in sorted(outputs.items())})
    if a.expected_manifest: need(manifest==json.loads(regular(a.expected_manifest)),'replay mismatch')
    out.mkdir(mode=0o700)
    if a.emit:
        (out/'D1Bound5').mkdir(mode=0o700)
        for n in sorted(staged):
            with (out/n).open('xb') as f: f.write(outputs[n])
    with (out/'manifest.json').open('x') as f: json.dump(manifest,f,indent=2); f.write('\n')
    print(json.dumps(dict(groups=3,fields=48,declarations=336,emitted=a.emit,staged_fields=sorted(selected),held_aggregates=sorted(aggs),manifest_sha256=sha(regular(out/'manifest.json'))),indent=2))
if __name__=='__main__': main()
