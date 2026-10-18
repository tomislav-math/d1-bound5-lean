"""Independent actual-literal replay; never imports the converter or Lean."""
from pathlib import Path
import ast,hashlib,json,re
R=Path(__file__).resolve().parents[1];B=R/'pair_light_next/left34'
sha=lambda b:hashlib.sha256(b).hexdigest()
def unique(pattern,text):
 a=re.findall(pattern,text,re.S|re.M);assert len(a)==1;return a[0]
def literal(name,text):
 return ast.literal_eval(unique(rf'^def {name} : [^\n]+ := (\[.*?\n\])',text))
def coords(body):
 p=r'⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩'
 assert not re.sub(p,'',body).replace(',','').strip()
 return [tuple(map(int,x)) for x in re.findall(p,body)]
m=json.loads((B/'manifest.json').read_text());assembly=json.loads((B/'assembly_manifest.json').read_text())
assert sha((B/'manifest.json').read_bytes())==assembly['data_manifest_sha256']
for name,pin in assembly['files'].items():
 b=(B/name).read_bytes();assert sha(b)==pin['sha256'] and len(b)==pin['bytes']
for name,pin in m['source_pins'].items():assert sha((R/name).read_bytes())==pin
s=(B/'SmallPairLightData34.lean').read_text()
# Exact parse of complete emitted literal declarations, not generator data.
assert re.findall(r'^def (\S+) :',s,re.M)==['sieve','leftVertices','leftCached','leftRows']
actual={n:literal(n,s) for n in ['sieve','leftVertices','leftCached','leftRows']}
old=(R/'pair_backend_next/staged_pilots_floor_fix/D1Bound5/SmallPairGraphInputs34.lean').read_text()
vertices=coords(unique(r'def smallPairLarge_34 .*? := \[(.*?)\n\]',old))
mask=int(unique(r'def colors : ℕ := (\d+)',old));assert len(vertices)==457 and mask>>457==0
indices=[i for i in range(457) if not (mask>>i)&1];expected_vertices=[vertices[i] for i in indices]
assert len(indices)==229 and indices==m['original_split_indices']
assert actual['leftVertices']==expected_vertices
oldcache=(R/'pair_literal_next/generated/SmallPairLiteralCachedData34.lean').read_text()
body=unique(r'def leftCached .*? := \[(.*?)\n\]',oldcache)
pattern=r'⟨⟨(-?\d+),\s*(-?\d+)⟩,\s*(\[[^\]]*\])⟩'
assert not re.sub(pattern,'',body).replace(',','').strip()
cache=[((int(x),int(y)),ast.literal_eval(sig)) for x,y,sig in re.findall(pattern,body)]
assert actual['leftCached']==cache and [x for x,_ in cache]==expected_vertices
oldwords=(R/'pair_selected_next/generated/SmallPairSelectedData34.lean').read_text()
assert actual['leftRows']==literal('leftRows',oldwords)
oldsieve=(R/'finite_fast_next/sieves/SmallPairSieve_1_2.lean').read_text()
masks=dict(re.findall(r'^def (smallPairMask_1_2_\d+) : ℕ := (\d+)$',oldsieve,re.M))
body=unique(r'def smallPairSieve_1_2 .*? := \[(.*?)\n\]',oldsieve)
p=r'\((\d+),\s*(smallPairMask_1_2_\d+)\)'
assert not re.sub(p,'',body).replace(',','').strip()
sieve=[(int(k),int(masks[n])) for k,n in re.findall(p,body)]
assert actual['sieve']==sieve and len(sieve)==25
assert len(actual['leftRows'])==len(cache)==229
for (x,y),sig in cache:
 assert sig==[(x%(k+1),y%(k+1)) for k,_ in sieve]
counts={'pairs':0,'mask_rejections':0,'duplicate_tags':0,'integer_guards':0,'norm_floors':0,'positive_floors':0,'negative_floors':0}
for i,(x,xsig) in enumerate(cache):
 code,floors=actual['leftRows'][i];floorpos=0
 for y,ysig in cache[i+1:]:
  counts['pairs']+=1;tag=code%32;code//=32
  if tag<25:
   k,bits=sieve[tag];p=k+1;u,v=xsig[tag],ysig[tag]
   rr=(u[0]*v[0]+((-2)%p)*u[1]*v[1]+1)%p
   ii=(u[0]*v[1]+u[1]*v[0]+(1%p)*u[1]*v[1])%p
   assert not(bits>>(rr*p+ii))&1;counts['mask_rejections']+=1
  elif tag==30:
   assert x==y;counts['duplicate_tags']+=1
  else:
   assert tag==31
   re_z=x[0]*y[0]-2*x[1]*y[1]+1
   im_z=x[0]*y[1]+x[1]*y[0]+x[1]*y[1]
   if im_z==0 and re_z<0 and re_z%7:
    counts['integer_guards']+=1
   else:
    assert floorpos<len(floors);k=floors[floorpos];floorpos+=1
    if im_z:
     n=re_z*re_z+re_z*im_z+2*im_z*im_z
     assert k*k<n<(k+1)*(k+1);counts['norm_floors']+=1
    elif re_z>0:
     assert k*k<re_z<(k+1)*(k+1);counts['positive_floors']+=1
    else:
     assert 7*k*k<-re_z<7*(k+1)*(k+1);counts['negative_floors']+=1
 assert code==0 and floorpos==len(floors)
assert counts==dict(pairs=26106,mask_rejections=26104,duplicate_tags=0,integer_guards=0,norm_floors=2,positive_floors=0,negative_floors=0)
ass=(B/'SmallPairLightAssembly34.lean').read_text()
assert sha(ass.encode())=='6a0195e9356ce602881ba23270aeac451918eed77e30e3bdb8e3b35be0fb5140'
assert re.findall(r'^theorem (\S+)\s*:',ass,re.M)==['sieve_eq','leftVertices_eq','leftCached_eq','leftRows_eq','left_checked']
report=dict(status='Independent actual-data replay and assembly source review PASS; no Lean compilation',
 files=assembly['files'],data_manifest_sha256=sha((B/'manifest.json').read_bytes()),
 reference_sources=m['source_pins'],generic_bridge_sha256=m['bridge_source_sha256'],
 exact_original_sieve=True,exact_original_left_split_order_and_coverage=True,
 exact_original_cached_coordinates_and_signatures=True,exact_original_packed_words_and_floors=True,
 canonical_signature_pairs_checked=229*25,full_tail_replay=counts,
 source_review=['Arithmetic-only data imports PairLightArithmetic; isolated check imports only its data. Heavy old data/bridge appear only in later assembly.',
 'Assembly checks the four concrete equalities against actual original data, then applies the reviewed unconditional bridge with discriminant7>0.',
 'Endpoint is exactly original left pairIndependentBool for the original split. It does not claim right independence, the triangle certificate, a full-ring endpoint or MainStatement.',
 'Three rfl equalities reflect identical literal values; ordered split equality remains explicitly kernel-computed. Their actual elaboration and certificate computation still require root compilation.'],
 actions='Parsed every emitted literal independently, compared against original source lists and replayed all26106 selected tail tags and exact two floor inequalities. No converter import/execution, remote action or compiler.',
 kernel_claim=False,issues=[])
out=R/'audit_next/light34_data_assembly_review.json';out.write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({'review_sha256':sha(out.read_bytes()),'vertices':229,'signature_pairs':5725,'counts':counts},indent=2))
