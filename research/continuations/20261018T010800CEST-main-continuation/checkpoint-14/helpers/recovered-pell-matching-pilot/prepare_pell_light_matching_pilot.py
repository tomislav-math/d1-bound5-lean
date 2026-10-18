#!/usr/bin/env python3
"""Source-pinned Pell light matching field-7 pilot; no Lean or project writes."""
import argparse, ast, hashlib, json, os, re, stat
from pathlib import Path

CHECK_PIN = 'c1c0284d3cb9fe91ae3599a7d1d28cf05b2201c8cbaef193b20c1b2b5f4ccfa0'
SOURCES = {
    'PellMatchingData1.lean': (926825, '4e50cd4ea81386b59a97b6de37846d484690780955d264313684ef33f9699869'),
    'PellMatchingData2.lean': (390879, '603fbbad5cd1f676c7b5d4f05678ed0716cc31e766487aa81dad2e9d405d3d73'),
    'PellMatchingData3.lean': (307132, 'ebbed025e58033ddcdd4e28192a00f65fb88db7128c0b6186abf4ad4ca1d74f8'),
}
HELPERS = {
    'PellLightMatching.lean': '3ac624524aca77968a148009c6a760dcc5c6aecfa02aa6a1652c7bf7443543c6',
    'PellLightMatchingBridge.lean': '71e9b8c569c150ce9305062ad39992119e2557e51708f11f0f3339fe47def76e',
}
HEADER = b'import D1Bound5.PellMatchingCheck\n\nnamespace D1Bound5\nset_option maxRecDepth 32768\nset_option maxHeartbeats 12000000\n\n'
FOOTER = b'end D1Bound5\n'
OPTIONS = b'set_option maxRecDepth 32768\nset_option maxHeartbeats 12000000\n\n'
DECL = re.compile(rb'^(?:def|theorem) ([A-Za-z0-9_]+)\b', re.M)
sha = lambda b: hashlib.sha256(b).hexdigest()

def need(ok, message):
    if not ok:
        raise ValueError(message)

def regular(path):
    path = Path(os.path.abspath(path))
    need(all(not p.is_symlink() for p in [path, *path.parents]), 'symlink input')
    before = path.stat()
    need(stat.S_ISREG(before.st_mode), 'nonregular input')
    data = path.read_bytes()
    after = path.stat()
    stamp = lambda s: (s.st_dev, s.st_ino, s.st_size, s.st_mtime_ns, s.st_ctime_ns)
    need(stamp(before) == stamp(after) and len(data) == after.st_size, 'input changed')
    return data

def pinned(path, digest, size=None):
    b = regular(path)
    need(sha(b) == digest and (size is None or len(b) == size), 'pin mismatch ' + str(path))
    return b

def decl_header(chunk):
    m = re.match(rb'((?:def|theorem) [A-Za-z0-9_]+[\s\S]*? (?:where|:=))', chunk)
    need(m is not None, 'missing declaration header')
    return m.group(1)

def expected_headers(d):
    return [s.encode() for s in [
        f'def pellMagnitudes_{d} : List ℤ :=',
        f'def pellMasks_{d} : List PellSquareMasks :=',
        f'def pellWitnesses_{d} : List (List (ℕ × ℕ)) :=',
        f'theorem pellMasks_{d}_valid : ∀ m ∈ pellMasks_{d}, m.Valid {d} :=',
        f'theorem pellMatching_{d}_checked :\n    pellMatchingCheck pellMasks_{d} pellMagnitudes_{d} pellWitnesses_{d} = true :=',
        f'theorem pellMagnitudes_{d}_large : ∀ x ∈ pellMagnitudes_{d}, 2 ≤ x :=',
        f'def pellGraphCertificate_{d} : PellMatchingCertificate {d} where',
    ]]

def parse_block(d, block):
    starts = list(DECL.finditer(block))
    chunks = [block[m.start():starts[i+1].start() if i+1 < len(starts) else len(block)]
              for i, m in enumerate(starts)]
    heads = [decl_header(c) for c in chunks]
    need(heads == expected_headers(d), 'seven original declaration types ' + str(d))
    literals = []
    for h, c in zip(heads[:3], chunks[:3]):
        m = re.fullmatch(rb'\n  (\[[^\n]*\])\n\s*', c[len(h):])
        need(m is not None, 'nonliteral data ' + str(d))
        literals.append(m.group(1))
    xs = ast.literal_eval(literals[0].decode())
    masks = ast.literal_eval(literals[1].decode().replace('⟨', '(').replace('⟩', ')'))
    ws = ast.literal_eval(literals[2].decode())
    need(isinstance(xs, list) and xs and all(type(x) is int for x in xs), 'magnitudes')
    need(isinstance(masks, list) and all(isinstance(m, tuple) and len(m) == 3 and
        all(type(v) is int and v >= 0 for v in m) for m in masks), 'masks')
    n = len(xs)
    need(isinstance(ws, list) and len(ws) == n, 'outer witness coverage')
    for i, row in enumerate(ws):
        need(isinstance(row, list) and len(row) == n-1-i and
            all(isinstance(w, tuple) and len(w) == 2 and
                all(type(v) is int and v >= 0 for v in w) for w in row),
            'full-tail witness coverage')
    for h, c in zip(heads[3:6], chunks[3:6]):
        need(re.fullmatch(rb' by\n  decide \+kernel\n\s*', c[len(h):]) is not None,
             'original proof form changed')
    cert_body = (f'\n  magnitudes := pellMagnitudes_{d}\n  masks := pellMasks_{d}\n'
        f'  witnesses := pellWitnesses_{d}\n  masks_valid := pellMasks_{d}_valid\n'
        f'  checked := pellMatching_{d}_checked\n  large := pellMagnitudes_{d}_large\n').encode()
    need(chunks[6][len(heads[6]):].rstrip() == cert_body.rstrip(), 'original certificate fields')
    return dict(field=d, heads=heads, literals=literals, certificate=chunks[6],
                block_sha256=sha(block), vertices=n, pairs=n*(n-1)//2,
                masks=len(masks), witnesses=sum(map(len, ws)))

def pure_source(row):
    d = row['field']
    b = (b'import D1Bound5.PellLightMatching\n\n'
         b'namespace D1Bound5.PellMatchingLightProduction\n') + OPTIONS
    for i, (head, literal) in enumerate(zip(row['heads'][:3], row['literals'])):
        head = head.replace('ℤ'.encode(), b'Int').replace('ℕ'.encode(), b'Nat')
        head = head.replace(b'PellSquareMasks', b'PellLightSquareMasks')
        b += head + b'\n  ' + literal + b'\n\n'
    b += (f'theorem pellMasks_{d}_valid :\n'
        f'    (pellMasks_{d}.all fun m => m.validBool {d}) = true := by\n  decide +kernel\n\n'
        f'theorem pellMatching_{d}_checked :\n'
        f'    pellLightMatchingCheck pellMasks_{d} pellMagnitudes_{d} pellWitnesses_{d} = true := by\n'
        f'  decide +kernel\n\n'
        f'theorem pellMagnitudes_{d}_large :\n'
        f'    (pellMagnitudes_{d}.all fun x => decide (2 ≤ x)) = true := by\n'
        f'  decide +kernel\n\n').encode()
    b += b'end D1Bound5.PellMatchingLightProduction\n'
    for literal in row['literals']:
        need(b.count(literal) == 1, 'literal copy count')
    return b

def adapter_block(row):
    d = row['field']
    p = 'PellMatchingLightProduction.'
    h = row['heads']
    bodies = [
        f'\n  {p}pellMagnitudes_{d}\n\n',
        f'\n  {p}pellMasks_{d}.map pellLightMasksToOriginal\n\n',
        f'\n  {p}pellWitnesses_{d}\n\n',
        f' by\n  exact pellLightMasks_valid {d} {p}pellMasks_{d} {p}pellMasks_{d}_valid\n\n',
        f' by\n  exact (pellLightMatchingCheck_eq {p}pellMasks_{d}\n'
        f'    {p}pellMagnitudes_{d} {p}pellWitnesses_{d}).symm.trans\n'
        f'      {p}pellMatching_{d}_checked\n\n',
        f' by\n  exact pellLightMagnitudes_large {p}pellMagnitudes_{d} {p}pellMagnitudes_{d}_large\n\n',
    ]
    b = b''.join(head + body.encode() for head, body in zip(h[:6], bodies)) + row['certificate']
    actual = [decl_header(b[m.start():]) for m in DECL.finditer(b)]
    need(actual == h, 'adapter public declaration headers changed')
    return b

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--original-dir', type=Path, required=True)
    ap.add_argument('--check-source', type=Path, required=True)
    ap.add_argument('--helper-dir', type=Path, required=True)
    ap.add_argument('--output-dir', type=Path, required=True)
    ap.add_argument('--emit', action='store_true', help='Emit only field7 and its uniquely namespaced adapter')
    ap.add_argument('--expected-manifest', type=Path)
    a = ap.parse_args()
    pinned(a.check_source, CHECK_PIN)
    for name, digest in HELPERS.items():
        pinned(a.helper_dir/name, digest)
    out = Path(os.path.abspath(a.output_dir))
    need(not os.path.lexists(out), 'output exists')
    need(out.parent.is_dir() and all(not p.is_symlink() for p in [out.parent,*out.parent.parents]),
         'invalid output parent')
    rows, source_records = [], []
    for name, (size, digest) in SOURCES.items():
        b = pinned(a.original_dir/name, digest, size)
        need(b.startswith(HEADER) and b.endswith(FOOTER), 'source context')
        body = b[len(HEADER):-len(FOOTER)]
        starts = list(re.finditer(rb'^def pellMagnitudes_(\d+) : List ', body, re.M))
        need(len(starts) == 16 and starts[0].start() == 0, 'field partition')
        blocks = [body[m.start():starts[i+1].start() if i+1 < len(starts) else len(body)]
                  for i,m in enumerate(starts)]
        need(b''.join(blocks) == body, 'exact source partition')
        fields = []
        for m, block in zip(starts, blocks):
            d = int(m.group(1)); row = parse_block(d, block); row['source'] = name
            names = {x.group(1).decode() for x in DECL.finditer(block)}
            refs = set(re.findall(r'\bpell(?:Magnitudes|Masks|Witnesses|Matching|GraphCertificate)_\d+(?:_(?:valid|checked|large))?\b', block.decode()))
            need(refs <= names, 'cross-field or unknown declaration reference')
            rows.append(row); fields.append(d)
        source_records.append(dict(file=name,bytes=size,sha256=digest,fields=fields))
    need(len(rows) == 48 and len({r['field'] for r in rows}) == 48, '48-field coverage')
    all_outputs = {}
    for r in rows:
        all_outputs[f'D1Bound5/PellLightMatchingField{r["field"]}.lean'] = pure_source(r)
    imports = b'import D1Bound5.PellLightMatchingBridge\n' + b''.join(
        f'import D1Bound5.PellLightMatchingField{r["field"]}\n'.encode() for r in rows)
    heavy = imports + b'\nnamespace D1Bound5\n' + OPTIONS + b''.join(adapter_block(r) for r in rows) + FOOTER
    original_heads = [h for r in rows for h in r['heads']]
    actual_heads = [decl_header(heavy[m.start():]) for m in DECL.finditer(heavy)]
    need(actual_heads == original_heads and len(actual_heads) == 336, 'all336 public declaration types')
    all_outputs['D1Bound5/PellLightMatchingFirst48Certificates.lean'] = heavy
    pilot = next(r for r in rows if r['field'] == 7)
    need(pilot['vertices'] == 229 and pilot['pairs'] == 26106, 'pilot workload')
    adapter = (b'import D1Bound5.PellLightMatchingBridge\nimport D1Bound5.PellLightMatchingField7\n\n'
        b'namespace D1Bound5.PellMatchingLightPilot7\n' + OPTIONS + adapter_block(pilot) +
        b'end D1Bound5.PellMatchingLightPilot7\n')
    all_outputs['D1Bound5/PellLightMatchingField7Adapter.lean'] = adapter
    emitted = ['D1Bound5/PellLightMatchingField7.lean', 'D1Bound5/PellLightMatchingField7Adapter.lean']
    mappings = [dict(field=r['field'], original_name='D1Bound5.'+m.group(1).decode(),
        preserved_original_header=h.decode(),
        pure_namespace='D1Bound5.PellMatchingLightProduction',
        planned_public_namespace='D1Bound5',
        pilot_namespace='D1Bound5.PellMatchingLightPilot7' if r['field']==7 else None)
        for r in rows for m,h in zip(DECL.finditer(adapter_block(r)),r['heads'])]
    manifest = dict(generator_sha256=sha(regular(__file__)), original_check_sha256=CHECK_PIN,
        helper_sha256=HELPERS, sources=source_records, original_field_count=48,
        original_declaration_count=336, declaration_mapping=mappings,
        fields=[{k:v for k,v in r.items() if k not in ('heads','literals','certificate')} |
            {'literal_sha256':[sha(x) for x in r['literals']]} for r in rows],
        pilot_field=7, pilot_vertices=229, pilot_pairs=26106,
        pilot_only_emission=True, original_project_sources_untouched=True,
        old_public_headers_preserved_in_unemitted_shared_assembly=True,
        exact_all_literal_bytes_preserved=True, emitted_source_names=emitted,
        outputs={name:dict(bytes=len(b),sha256=sha(b),emittable=name in emitted)
            for name,b in sorted(all_outputs.items())})
    if a.expected_manifest:
        need(manifest == json.loads(regular(a.expected_manifest)), 'exact replay mismatch')
    out.mkdir(mode=0o700)
    if a.emit:
        (out/'D1Bound5').mkdir(mode=0o700)
        for name in emitted:
            with (out/name).open('xb') as f:
                f.write(all_outputs[name])
    with (out/'manifest.json').open('x') as f:
        json.dump(manifest,f,indent=2);f.write('\n')
    print(json.dumps(dict(emitted=a.emit,fields=48,declarations=336,pilot_pairs=26106,
        source_files=emitted if a.emit else [],manifest_sha256=sha(regular(out/'manifest.json'))),indent=2))

if __name__ == '__main__':
    main()
