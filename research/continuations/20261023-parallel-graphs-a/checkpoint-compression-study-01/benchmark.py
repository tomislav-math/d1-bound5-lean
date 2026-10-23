#!/usr/bin/env python3
"""Single-worker lossless compression benchmark; original archive never modified."""
import datetime,gzip,hashlib,json,lzma,os,platform,resource,signal,time
from pathlib import Path
MIB=1024*1024
SOURCE=Path('/Users/tp/Lean/D1Bound5ProofObjects/recovery-2c06f4e3f2014ea78ba92a0b48e5ad92/batch-000002/batch.tar.gz')
EXPECTED='8cb1e274875167131b34f533b7cf1d510591cdb877cba4b09d7ee25386adc353'
OUT=Path('/Users/tp/Lean/D1Bound5ProofObjects/compression-benchmark-20261023-batch2')
REPORT=Path(__file__).with_name('BENCHMARK_RESULT.json')
def check(x,m):
 if not x:raise RuntimeError(m)
def sha(p):
 h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(MIB),b''):h.update(b)
 return h.hexdigest()
def fingerprint(p):
 s=p.stat();return [s.st_dev,s.st_ino,s.st_size,s.st_mtime_ns,s.st_ctime_ns]
def peak_rss():
 x=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
 return x if platform.system()=='Darwin' else x*1024
def memory_guard():check(peak_rss()<=512*MIB,'RSS exceeded512MiB')
def transfer(src,dst):
 h=hashlib.sha256();total=0
 for b in iter(lambda:src.read(MIB),b''):
  dst.write(b);h.update(b);total+=len(b);memory_guard()
 return h.hexdigest(),total
def decoded_identity(path,kind):
 h=hashlib.sha256();size=0
 opener=gzip.open if kind=='gzip' else lzma.open
 with opener(path,'rb') as f:
  for b in iter(lambda:f.read(MIB),b''):h.update(b);size+=len(b);memory_guard()
 return h.hexdigest(),size
resource.setrlimit(resource.RLIMIT_DATA,(512*MIB,512*MIB))
resource.setrlimit(resource.RLIMIT_CPU,(600,600))
signal.alarm(900)
check(not OUT.exists() and not REPORT.exists(),'No overwrite permitted')
before=fingerprint(SOURCE);check(sha(SOURCE)==EXPECTED,'Original archive SHA mismatch');check(fingerprint(SOURCE)==before,'Original changed while hashing')
OUT.mkdir();raw=OUT/'batch.raw.tar'
started=time.monotonic()
with gzip.open(SOURCE,'rb') as f,raw.open('xb') as g:raw_sha,raw_bytes=transfer(f,g)
rows=[]
result={'schema':1,'status':'RUNNING_BENCHMARK_NOT_PROOF','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'platform':platform.platform(),'python':platform.python_version(),'source':str(SOURCE),'original_sha256':EXPECTED,'original_bytes':before[2],'original_compression_level':3,'raw_tar_sha256':raw_sha,'raw_tar_bytes':raw_bytes,'decompression_seconds':time.monotonic()-started,'single_worker':True,'memory_limit_bytes':512*MIB,'memory_enforcement':'RLIMIT_DATA512MiB, LZMA presets3/6 single-threaded, per-stream-chunk peakRSS guard512MiB; CPU600s/wall900s.','rows':rows,'output_directory':str(OUT),'old_archive_modified':False,'git_or_lean_operation':False}
def save():
 temp=REPORT.with_suffix('.tmp');temp.write_text(json.dumps(result,indent=2,sort_keys=True)+'\n');os.replace(str(temp),str(REPORT))
save()
for kind,level in [('gzip',9),('xz',3),('xz',6)]:
 name='batch.gzip9.tar.gz' if kind=='gzip' else 'batch.xz'+str(level)+'.tar.xz';target=OUT/name
 start=time.monotonic();cpu=time.process_time()
 with raw.open('rb') as f,target.open('xb') as dest:
  encoder=gzip.GzipFile(filename='',mode='wb',compresslevel=level,fileobj=dest,mtime=0) if kind=='gzip' else lzma.LZMAFile(dest,'wb',format=lzma.FORMAT_XZ,preset=level)
  with encoder as out:copied_sha,copied_bytes=transfer(f,out)
 compression_seconds=time.monotonic()-start;cpu_seconds=time.process_time()-cpu
 check((copied_sha,copied_bytes)==(raw_sha,raw_bytes),'Raw tar changed during compression')
 verify_start=time.monotonic();decoded_sha,decoded_bytes=decoded_identity(target,kind)
 check((decoded_sha,decoded_bytes)==(raw_sha,raw_bytes),'Compression round-trip mismatch')
 row={'kind':kind,'level':level,'path':str(target),'compressed_bytes':target.stat().st_size,'sha256':sha(target),'compression_seconds':compression_seconds,'compression_cpu_seconds':cpu_seconds,'roundtrip_seconds':time.monotonic()-verify_start,'decoded_sha256':decoded_sha,'decoded_bytes':decoded_bytes,'peak_process_rss_bytes':peak_rss(),'ratio_to_original_bytes':target.stat().st_size/before[2]}
 rows.append(row);save();print(json.dumps(row),flush=True)
check(fingerprint(SOURCE)==before and sha(SOURCE)==EXPECTED and fingerprint(SOURCE)==before,'Original archive changed after benchmark')
check(sha(raw)==raw_sha,'Raw tar changed after benchmark');memory_guard()
result.update(status='LOSSLESS_COMPRESSION_BENCHMARK_PASS_NOT_PROOF',original_fingerprint_before=before,original_fingerprint_after=fingerprint(SOURCE),original_hash_after=EXPECTED,final_peak_rss_bytes=peak_rss(),utc_end=datetime.datetime.now(datetime.timezone.utc).isoformat());save();print(json.dumps({'status':result['status'],'report_sha256':sha(REPORT),'report':str(REPORT)}),flush=True)
