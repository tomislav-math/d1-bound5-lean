"""Create only the authorized checkpoint13 helper packet and provenance manifest.
No checkpoint preparation/staging script, Git operation, generator, or Lean build is run.
"""
from pathlib import Path, PurePosixPath
import ast, base64, gzip, hashlib, json, os, re, stat, sys, zlib
R = Path('/Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation')
PINS = {
 'prepare_light_rows_recovered.py':'67e22402774fe51120cd22ac20826b4bd3f1c44a8bb5c401465f023c3f220dde',
 'prepare_light47_bootstrap.py':'1a9dac189eba5c82697dbb53befbcb53ce2b056900e173f5a540178aa8d3136a',
 'light-scale-bootstrap/input_requirements.json':'a96177b74b4fda368613a8247a62aa2258b3111e651bdedbf856a631adc13634',
 'prepare_structural_remaining.py':'494a481766a0c197fae7a5f776525da0fd6681a7cd7d801b6b26e821dbc629ad',
 'prepare_structural_remaining.sourceaudit.json':'2d9163d5357140fcd5d8c82d8bd669638e56ca4798d00f2aafc4fc0245f42c3e',
 'checkpoint13-scripts-review.json':'2b3e9d5da8ff7b88851ab8b2773661f158d2765af82cd5ef2f7f5a0c55fa697c',
 'recovered-bennett/prepare_light_chunks34.py':'0de582aebdde69c3d14cb8bf0cffe39f8144464e618f68c6380413e905ba2674',
 'recovered-bennett/PairLightArithmeticChunks.lean':'f6567fcbc7792894e8607b67148594c393fe089550470cc632f4beffbdcfaca7',
 'recovered-bennett/PairLightArithmeticChunkProofs.lean':'658b9d78aa5789e1a26cdcfc58f5960c552bb3ae7fdeda34961f362a081828a4',
 'recovered-bennett/matching_splitter.py':'ff27192ac821679d0bf7adcd5dedb0f08fff36f22847fd8b4a7a5b1ea36acb3f',
 'recovered-bennett/manifest.json':'5abd013451268a4dbd79c46dc3b21a0a8c055f3d35e63ca97af6a5a99758b225',
 'recovered-cf-production/recovery_manifest.json':'456817505f495ff99904d652cfb08fb68e755575aad35ae1c47e6da332e6244e',
 'recovered-cf-production/generate_cf_production.py':'e9cb691bd361c89a5d44262f6e98eb1ba385c38a31ad5692cce20c89a982be9b',
 'recovered-cf-production/source_review.json':'a750ea43cdee5b7bda36a93612e28dd5201d109bc6c03be924d85f404fc21f3b',
 'prepared-matching-field7/manifest.json':'d833b254e72553e00b7da1be9404db15b2429ba5a187e8597920da2da381a1e2',
 'prepared-matching-field7/D1Bound5/PellMatchingData1.lean':'c949913565bd9de7bdef4a0754304ec516ea073cb9478e586f92cf3f8bcba29f',
 'prepared-cf-production-pilot/manifest.json':'f88aa6d417920ff41f13e90f2dcbe6f8a5850e0aee4c564723a6ad605ebea089',
 'prepared-cf-production-all/manifest.json':'69c9503af94d6e8cf8de6b92f302e75d0bbab8674fabe4ba37af25f4666dc8cb',
 'cf-production-all-expected.json':'69c9503af94d6e8cf8de6b92f302e75d0bbab8674fabe4ba37af25f4666dc8cb',
 'light47-manifest-preflight/manifest.json':'74522436b3bbaef7267bc6f62eafef9fb390bc56fbce7f326e16efdaaa65f45a',
 'narrow22-preparation/narrow_expanded_inputs.py':'4c120fa958983bdc2f39d1fd38db30738f541f1372d28ac5de5b035ebb113e78',
 'structural-remaining-preparation-receipt.json':'52fd3a914d2f85098b65a484ae03ce1e65c83b4baf2a64e919219abec84a036f',
 'structural-remaining-preparation-logs/expanded.log':'affac303492d0156285d4d43034736ab84a30551da7b7dfa2e526c87b38f514c',
 'structural-remaining-preparation-logs/narrow27.log':'8c501a959177cb115c9e2559a2ecc087f01de43a17fd3a5e5d2f22a94c80ca57',
 'structural-remaining-preparation-logs/narrow31.log':'976fc330d4dece902ceb416377da29344240e30d93d2911da82be0f8091be880',
 'structural-remaining-preparation-logs/narrow32.log':'1e601f531441c0fd5bea48d3e49d6aea33c5f6a19c1513bf304087420b8beca9',
 'structural-remaining-preparation-logs/narrow37.log':'8a84355ffc56a81ebff808c355ababa6893728ca63c5c7495e070f323de0cdd0',
}
sha = lambda b: hashlib.sha256(b).hexdigest()
def require(ok, msg):
    if not ok:
        raise RuntimeError(msg)
def relative(name):
    p = PurePosixPath(name)
    require(name and not p.is_absolute() and '..' not in p.parts and str(p)==name
            and not any(ord(c)<32 for c in name), 'Unsafe path: '+name)
    return name
def stable(name):
    path = R / relative(name)
    require(path.resolve(strict=True)==path and path.resolve().is_relative_to(R.resolve()),
            'Symlinked/outside path: '+name)
    fd=os.open(path,os.O_RDONLY|os.O_NOFOLLOW)
    try:
        a=os.fstat(fd)
        require(stat.S_ISREG(a.st_mode),'Not regular: '+name)
        with os.fdopen(fd,'rb',closefd=False) as f:
            raw=f.read()
        b=os.fstat(fd); c=path.stat(follow_symlinks=False)
        sig=lambda x:(x.st_dev,x.st_ino,x.st_size,x.st_mtime_ns,x.st_ctime_ns)
        require(sig(a)==sig(b)==sig(c) and len(raw)==b.st_size,'Changed read: '+name)
        return raw
    finally:
        os.close(fd)
def publish(name, raw):
    with (R/relative(name)).open('xb') as f:
        f.write(raw); f.flush(); os.fsync(f.fileno())
    require(stable(name)==raw,'Output reread differs: '+name)
def main():
    packet_name='checkpoint13-helpers.json'
    manifest_name='helper13-manifest.json'
    review_name='structural-remaining-independent-review.json'
    for name in [packet_name,manifest_name,review_name]:
        require(not (R/name).exists() and not (R/name).is_symlink(),'Output exists: '+name)
    for directory,count in [('recovered-bennett',5),('recovered-cf-production',3)]:
        children=list((R/directory).iterdir())
        actual={str(p.relative_to(R)) for p in children}
        want={n for n in PINS if n.startswith(directory+'/')}
        require(len(children)==count and actual==want,'Recovered directory scope changed: '+directory)
    raw={n:stable(n) for n in sorted(PINS)}
    for n,digest in PINS.items():
        require(sha(raw[n])==digest,'Reviewed pin mismatch: '+n)
    receipt=json.loads(raw['structural-remaining-preparation-receipt.json'])
    require(receipt['script_sha256']==PINS['prepare_structural_remaining.py']
            and receipt['rows']==[27,31,32,37] and receipt['source_count']==24
            and receipt['tracked_project_sources_unchanged'] is True
            and receipt['frozen134_sources_unchanged'] is True
            and receipt['status']=='Research source preparation only; no installation or Lean compilation',
            'Missing final structural preparation evidence')
    for directory,manifest_name_in,entries_key in [
        ('recovered-bennett','manifest.json','files'),
        ('recovered-cf-production','recovery_manifest.json',None)]:
        obj=json.loads(raw[directory+'/'+manifest_name_in])
        entries=obj[entries_key] if entries_key else obj
        for n,pin in entries.items():
            data=raw[directory+'/'+relative(n)]
            require(sha(data)==pin['sha256'] and len(data)==pin['bytes'],'Recovery manifest mismatch')
    matching=json.loads(raw['prepared-matching-field7/manifest.json'])
    held=raw['prepared-matching-field7/D1Bound5/PellMatchingData1.lean']
    heldpin=matching['outputs']['D1Bound5/PellMatchingData1.lean']
    require(heldpin['sha256']==sha(held) and heldpin['bytes']==len(held),'Held aggregate pin mismatch')
    require(matching['generator_sha256']==PINS['recovered-bennett/matching_splitter.py'],
            'Matching generator mismatch')
    require(raw['prepared-cf-production-all/manifest.json']==raw['cf-production-all-expected.json'],
            'CF expected/actual manifest mismatch')
    for n in ['prepared-cf-production-pilot/manifest.json','prepared-cf-production-all/manifest.json']:
        require(json.loads(raw[n])['generator_sha256']==PINS['recovered-cf-production/generate_cf_production.py'],
                'CF generator mismatch')
    for n in ['light-scale-bootstrap/input_requirements.json','light47-manifest-preflight/manifest.json']:
        require(json.loads(raw[n])['generator_sha256']==PINS['prepare_light_rows_recovered.py'],
                'Light converter mismatch')
    review={
        'reviewer':'/root/source_audit','source_review_pass':True,
        'source_sha256':PINS['prepare_structural_remaining.py'],
        'scope':'Records prior independent source-only review; no generator or Lean execution by reviewer',
        'checked_helpers':{'expanded':'4942337e7b44f4c84ef0ef0b75ef6aeb2c90fd5e17d74df28ba8df8af750ec7a',
                           'narrow':PINS['narrow22-preparation/narrow_expanded_inputs.py']},
        'checks':['Actual CLI and exact per-row metadata/hash schemas match',
                  'Twenty-four expanded files total3068676 bytes; import-only variants total3068788',
                  'All proof bodies and original five public statements preserved by exact output gates',
                  'Forty-eight project preimages and134 frozen input hashes checked before/after by wrapper',
                  'Only new preparation directories; no project install, queue, Git or Lean action'],
        'kernel_acceptance_claim':False,'issues':[],
        'later_coordinator_execution_evidence':'structural-remaining-preparation-receipt.json'}
    review_bytes=(json.dumps(review,indent=2)+'\n').encode()
    raw[review_name]=review_bytes
    builder_name=Path(__file__).name
    require(builder_name=='prepare_checkpoint13_helpers.py','Unexpected builder filename')
    raw[builder_name]=stable(builder_name)
    require(len(raw)==29,'Unexpected explicit helper count')
    secret=re.compile(rb'gh[pousr]_[A-Za-z0-9_]{30,}|github_pat_[A-Za-z0-9_]{30,}|-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----')
    helpers={}
    for n,data in sorted(raw.items()):
        relative(n); require(not secret.search(data),'Credential-like content: '+n)
        helpers[n]=data.decode('utf-8')
        if n.endswith('.json'):json.loads(data)
        if n.endswith('.py'):ast.parse(data)
    payload=json.dumps(helpers,sort_keys=True,ensure_ascii=False,separators=(',',':')).encode()
    compressed=gzip.compress(payload,compresslevel=9,mtime=0)
    packet=(json.dumps({'encoding':'gzip-base64','data':base64.b64encode(compressed).decode()},
                       separators=(',',':'))+'\n').encode()
    decoded=json.loads(gzip.decompress(base64.b64decode(json.loads(packet)['data'],validate=True)))
    require(set(decoded)==set(raw),'Round-trip coverage mismatch')
    require(all(decoded[n].encode()==b for n,b in raw.items()),'Round-trip byte mismatch')
    for n in PINS:require(stable(n)==raw[n],'Source changed during packing: '+n)
    require(stable(builder_name)==raw[builder_name],'Builder changed during packing')
    manifest={
        'scope':'Unaccepted research helper backup; no source installation or compilation',
        'packet_file':packet_name,'packet_sha256':sha(packet),'packet_bytes':len(packet),
        'canonical_payload_sha256':sha(payload),'canonical_payload_bytes':len(payload),
        'helper_count':len(raw),'helper_bytes':sum(map(len,raw.values())),
        'python':sys.version.split()[0],'zlib_runtime':zlib.ZLIB_RUNTIME_VERSION,
        'all_reviewed_pins_verified':True,'exact_decode_and_readback_verified':True,
        'terminal_structural_receipt_sha256':PINS['structural-remaining-preparation-receipt.json'],
        'intentional_exclusions':['Current project drafts captured by checkpoint13 SOURCE_MAP',
          'Prepared Light47 and CF Lean outputs already intaken; manifests preserved',
          'Unreviewed future adaptive helper and active compiler logs'],
        'explicit_lean_exceptions':['Two recovered Bennett generic sources explicitly requested',
          'Held research-only PellMatchingData1 aggregate; not an acceptance claim'],
        'files':[{'path':n,'bytes':len(b),'sha256':sha(b)} for n,b in sorted(raw.items())]}
    manifest_bytes=(json.dumps(manifest,indent=2)+'\n').encode()
    for n,b in [(review_name,review_bytes),(packet_name,packet),(manifest_name,manifest_bytes)]:
        publish(n,b)
    print(json.dumps({'packet_sha256':sha(packet),'packet_bytes':len(packet),
        'manifest_sha256':sha(manifest_bytes),'manifest_bytes':len(manifest_bytes),
        'canonical_payload_sha256':sha(payload),'canonical_payload_bytes':len(payload),
        'helper_count':len(raw),'helper_bytes':manifest['helper_bytes'],
        'builder_sha256':sha(raw[builder_name]),'source_review_sha256':sha(review_bytes)},indent=2))
if __name__=='__main__':
    main()
