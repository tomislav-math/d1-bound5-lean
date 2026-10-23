#!/usr/bin/env python3
import argparse,hashlib,json
from pathlib import Path
p=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--output');args=ap.parse_args()
r=json.loads((p/'FRESH_RUNTIME_LOCK_PARTS_INDEX.json').read_text());h=hashlib.sha256();total=0
out=Path(args.output).open('wb') if args.output else None
try:
 for item in r['parts']:
  b=(p/item['file']).read_bytes();assert len(b)==item['bytes']<=r['maximum_part_bytes'];assert hashlib.sha256(b).hexdigest()==item['sha256'];h.update(b);total+=len(b)
  if out:out.write(b)
finally:
 if out:out.close()
assert total==r['original_bytes'] and h.hexdigest()==r['original_sha256']
print(json.dumps({'status':'PASS_EXACT_RUNTIME_LOCK_RECONSTRUCTION','sha256':h.hexdigest(),'bytes':total,'parts':len(r['parts'])}))
