#!/usr/bin/env python3
"""Bind the independent v1 Section 7 checker to the actual v2 source.
The numerical algorithm is preserved. Only paths, SHA guards, run metadata,
and output names change. Does not edit the article.
"""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'revision_v2/checks';SRC=ROOT/'output/D1_bound5-v2.tex'
sha=hashlib.sha256(SRC.read_bytes()).hexdigest()
provenance={}
for stem in ['exact','constants']:
 source=ROOT/f'review_v1/checks/small_v1_{stem}.py';s=source.read_text()
 provenance[stem]={'input_script':str(source.relative_to(ROOT)),'input_sha256':hashlib.sha256(source.read_bytes()).hexdigest()}
 s=s.replace("SRC=ROOT/'upload/D1_bound5-v1(1).tex'", "SRC=ROOT/'output/D1_bound5-v2.tex'\nEXPECTED_SOURCE_SHA='"+sha+"'\nassert hashlib.sha256(SRC.read_bytes()).hexdigest()==EXPECTED_SOURCE_SHA")
 s=s.replace("ROOT/'review_v1/checks'", "ROOT/'revision_v2/checks'").replace("ROOT/'review_v1/checks/", "ROOT/'revision_v2/checks/").replace('small_v1_', 'small_v2_')
 if stem=='exact':
  s=s.replace('Fresh independent Section 7 reconstruction; no prior audit code imported.', 'Rebound v2 rerun of the independent v1 Section 7 checker. Computational core unchanged.')
  old=" for arg in sys.argv[1:] or ['triples','pairs','pell']:globals()[arg]()"
  new=""" for arg in sys.argv[1:] or ['triples','pairs','pell']:
  started=time.perf_counter();passed=False
  try:
   globals()[arg]();passed=True
  finally:
   elapsed=time.perf_counter()-started
   current=hashlib.sha256(SRC.read_bytes()).hexdigest()
   assert current==EXPECTED_SOURCE_SHA,'Source changed during run'
   metadata={'mode':arg,'passed':passed,'seconds':elapsed,'source_sha256':current,'algorithm_origin':'Rebound independent v1 checker, same computational core'}
   (OUT/('small_v2_runtime_'+arg+'.json')).write_text(json.dumps(metadata,indent=2)+'\\n')
   print('RUNTIME',json.dumps(metadata),flush=True)"""
  assert old in s;s=s.replace(old,new)
 else:
  s=s.replace('Exact rational inequalities and polynomial identities freshly reconstructed for Section 7.', 'V2 rerun of previously independently reconstructed Section 7 inequalities and identities.')
  s=s.replace("report={'source_sha256':hashlib.sha256(SRC.read_bytes()).hexdigest(),'checks':checks}", "assert hashlib.sha256(SRC.read_bytes()).hexdigest()==EXPECTED_SOURCE_SHA\nreport={'source_sha256':EXPECTED_SOURCE_SHA,'checks':checks,'algorithm_origin':'Rebound independent v1 constants, actual v2 rerun'}")
 output=OUT/f'small_v2_{stem}.py';output.write_text(s);provenance[stem]['output_script']=str(output.relative_to(ROOT));provenance[stem]['output_sha256']=hashlib.sha256(output.read_bytes()).hexdigest()
(OUT/'small_v2_rebinding.json').write_text(json.dumps({'source_sha256':sha,'provenance':provenance,'algorithm_changes':False},indent=2)+'\n')
print(sha)
