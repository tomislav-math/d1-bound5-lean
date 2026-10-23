#!/usr/bin/env python3
"""Read-only source/index inventory; writes receipts only to the explicit research output."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,stat,subprocess


def sha_bytes(b):return hashlib.sha256(b).hexdigest()
def sha_file(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
    return h.hexdigest()
def json_write(p,d):p.write_text(json.dumps(d,sort_keys=True,indent=2)+'\n')
def source_path(n):return n=='D1Bound5.lean' or (n.startswith('D1Bound5/') and n.endswith('.lean'))
def stamp(p):
    s=p.lstat();return {'size':s.st_size,'mtime_ns':s.st_mtime_ns,'inode':s.st_ino,'mode':s.st_mode}
def main():
    a=argparse.ArgumentParser();a.add_argument('--project',required=True);a.add_argument('--expected-manifest',required=True);a.add_argument('--expected-sha256',required=True);a.add_argument('--out',required=True);args=a.parse_args()
    root=Path(args.project).resolve();out=Path(args.out).resolve()
    assert root/'research' in out.parents and not out.exists(),'Output must be a new owned research directory'
    def git(*xs):return subprocess.check_output(['git','-C',str(root),*xs],env={**os.environ,'GIT_OPTIONAL_LOCKS':'0'})
    assert git('rev-parse','--show-toplevel').decode().strip()==str(root)
    expected_path=Path(args.expected_manifest).resolve();assert sha_file(expected_path)==args.expected_sha256
    expected={}
    for line in expected_path.read_text().splitlines():
        h,n=line.split(None,1);assert source_path(n) and n not in expected and len(h)==64;expected[n]=h
    assert len(expected)==4406
    index_lock=Path(git('rev-parse','--git-path','index.lock').decode().strip());index_lock=index_lock if index_lock.is_absolute() else root/index_lock
    assert not index_lock.exists(),'Live index writer'
    head=git('rev-parse','HEAD').decode().strip();branch=git('branch','--show-current').decode().strip()
    raw_index=git('ls-files','--stage','-z');index={}
    for entry in raw_index.split(b'\0'):
        if not entry:continue
        meta,n=entry.split(b'\t',1);mode,oid,stage=meta.decode().split();assert stage=='0';index[n.decode()]={'mode':mode,'oid':oid}
    raw_head=git('ls-tree','-r','-z','HEAD');headfiles={}
    for entry in raw_head.split(b'\0'):
        if not entry:continue
        meta,n=entry.split(b'\t',1);mode,kind,oid=meta.decode().split();headfiles[n.decode()]={'mode':mode,'kind':kind,'oid':oid}
    paths=[root/'D1Bound5.lean']+sorted((root/'D1Bound5').rglob('*'))
    files={};anomalies=[]
    for p in paths:
        n=p.relative_to(root).as_posix()
        if p.is_symlink():anomalies.append({'path':n,'issue':'symlink'});continue
        if p.is_dir():continue
        if not p.exists():anomalies.append({'path':n,'issue':'missing'});continue
        before=stamp(p)
        if not stat.S_ISREG(before['mode']):anomalies.append({'path':n,'issue':'nonregular'});continue
        h=sha_file(p);after=stamp(p);assert before==after,('File changed during inventory',n)
        files[n]={'sha256':h,'bytes':before['size'],'stat':before,'in_index':n in index,'in_HEAD':n in headfiles}
    sources={n:r for n,r in files.items() if source_path(n)}
    missing=sorted(set(expected)-set(sources));mismatch={n:{'expected':expected[n],'actual':sources[n]['sha256']} for n in set(expected)&set(sources) if expected[n]!=sources[n]['sha256']}
    extra={n:r for n,r in sources.items() if n not in expected}
    untracked={n:r for n,r in extra.items() if not r['in_index'] and not r['in_HEAD']}
    protected={n:r for n,r in extra.items() if r['in_index'] or r['in_HEAD']}
    expected_not_index=sorted(set(expected)-set(index));tracked_source_missing=sorted(n for n in set(index)|set(headfiles) if source_path(n) and n not in sources)
    pins={n:sha_file(root/n) for n in ['lake-manifest.json','lakefile.lean','lean-toolchain']}
    expected_pins={'lake-manifest.json':'7ba6f92faaef8900c85a20ac695495111285a1b0c355cb1441a69b34ba9500f4','lakefile.lean':'fa17c8e0e386fe8ffadcab88a9a328337c3db37cc7d64681e7ca26836c73bfb3','lean-toolchain':'3aac669c7a910ec2389f4e4f921b605adf6ebf2d1e0c9b9cd0be4d33f3f5db71'}
    assert raw_index==git('ls-files','--stage','-z') and head==git('rev-parse','HEAD').decode().strip() and not index_lock.exists(),'Git snapshot changed'
    final_paths={p.relative_to(root).as_posix() for p in [root/'D1Bound5.lean']+list((root/'D1Bound5').rglob('*')) if p.is_file()}
    assert final_paths==set(files),'File inventory changed'
    assert all(stamp(root/n)==r['stat'] for n,r in files.items()),'Source metadata changed after hashing'
    policy=root/'GIT_SYNC_POLICY.md'
    metadata={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'project':str(root),'head':head,'branch':branch,'index_sha256':sha_bytes(raw_index),'HEAD_tree_sha256':sha_bytes(raw_head),'expected_manifest':str(expected_path),'expected_manifest_sha256':args.expected_sha256,'policy_sha256':sha_file(policy),'pins':pins,'pins_match_frozen_candidate':pins==expected_pins,'source_inventory_stable':True,'git_snapshot_stable':True}
    summary={'status':'READ_ONLY_PUBLICATION_INVENTORY','metadata':metadata,'canonical_source_count':len(sources),'canonical_nonlean_file_count':len(files)-len(sources),'expected_source_count':len(expected),'matching_expected_sources':len(expected)-len(missing)-len(mismatch),'missing_expected_sources':missing,'mismatching_expected_sources':mismatch,'extra_sources':len(extra),'extra_untracked_sources':len(untracked),'extra_protected_tracked_sources':len(protected),'HEAD_production_sources':sum(source_path(n) for n in headfiles),'index_production_sources':sum(source_path(n) for n in index),'expected_sources_not_indexed':len(expected_not_index),'tracked_source_missing':tracked_source_missing,'anomalies':anomalies,'canonical_mutations':False,'git_mutations':False,'compiler_started':False}
    out.mkdir(parents=True)
    for name,data in [('SUMMARY.json',summary),('CANONICAL_FILES.json',files),('EXTRA_UNTRACKED_SOURCES.json',untracked),('EXTRA_PROTECTED_TRACKED_SOURCES.json',protected),('EXPECTED_NOT_INDEXED.json',expected_not_index),('GIT_INDEX_PRODUCTION.json',{n:r for n,r in index.items() if source_path(n)}),('GIT_HEAD_PRODUCTION.json',{n:r for n,r in headfiles.items() if source_path(n)})]:json_write(out/name,data)
    for name,rows in [('canonical-production.sha256.txt',sources),('obsolete-untracked.sha256.txt',untracked),('protected-extra.sha256.txt',protected)]:
        (out/name).write_text(''.join(r['sha256']+'  '+n+'\n' for n,r in sorted(rows.items())))
    json_write(out/'OUTPUT_MANIFEST.json',{p.name:sha_file(p) for p in sorted(out.iterdir()) if p.is_file()})
    print(json.dumps(summary,sort_keys=True))
if __name__=='__main__':main()
