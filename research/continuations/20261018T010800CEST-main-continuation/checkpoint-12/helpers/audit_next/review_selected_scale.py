"""Independent data replay and in-memory source review of selected-row staging.

The author's rendering function is used only after independent pair/tag replay,
to inspect prospective source bytes. No Lean files are emitted or compiled.
"""
from pathlib import Path
import ast
from collections import Counter
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
sha = lambda b: hashlib.sha256(b).hexdigest()
digest = lambda x: sha(json.dumps(x, separators=(",", ":")).encode())
read = lambda p: json.loads((ROOT / p).read_text())
script = ROOT / "pair_selected_scale_next/prepare_selected_rows.py"
assert sha(script.read_bytes()) == "ec862156543e3f4304b253e54591adfbcdc32acfd4f459f6fd8c16547bf32174"
manifest_path = ROOT / "pair_selected_scale_next/dry_inventory/manifest.json"
assert sha(manifest_path.read_bytes()) == "be04bfc2b0be0fffe72fb0155e0920f803e291cfbefafb919a524ad35e6f95bd"
manifest = json.loads(manifest_path.read_text())
reports = {r["row"]: r for r in manifest["results"]}
assert manifest["rows"] == list(range(1, 49)) and manifest["staged_rows"] == [47]
assert len(reports) == 48 and manifest["file_count"] == 9
for pinset in (manifest["source_pins"], manifest["backend_pins"]):
    for path, pin in pinset.items():
        assert sha((ROOT / path).read_bytes()) == pin, path
inputs = {r["row"]: r for r in read("pair_witness_next/all48_input_fingerprints.json")}
diagnostics = {r["row"]: r for r in read("pair_witness_next/all48_diagnostic_manifest.json")["rows"]}
costs = {r["row"]: r for r in read("crossblock_performance_next/selected_mask_costs.json")["rows"]}
sieve_pins = read("pair_witness_next/cached_sieve_fingerprints.json")
floor_manifest = read("sparse_floor_next/generated/manifest.json")
old_manifest = {r["row"]: r for r in read("pair_backend_next/all47_dry/manifest.json")["results"]}

def source_inputs(k):
    path = f"finite_next/two_small/D1Bound5/SmallPairGraphData{k}.lean"
    raw = (ROOT / path).read_bytes()
    assert sha(raw) == inputs[k]["files"][path] == reports[k]["original_source_sha256"]
    s = raw.decode()
    tau, nu = map(int, re.search(rf"def smallPairA_{k} : QuadInt (\d+) (\d+)", s).groups())
    lit = re.search(rf"def smallPairLarge_{k} .*? := \[(.*?)\n\]", s, re.S).group(1)
    ptn = r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩"
    vertices = [tuple(map(int, x)) for x in re.findall(ptn, lit)]
    assert re.sub(ptn, "", lit).replace(",", "").strip() == ""
    assert len(vertices) == len(set(vertices))
    color_word = int(diagnostics[k]["color_mask"])
    assert color_word >> len(vertices) == 0
    classes = [[i for i in range(len(vertices)) if (color_word >> i) & 1 == c] for c in (0, 1)]
    assert digest(classes) == reports[k]["class_indices_digest"]
    spath = f"finite_fast_next/sieves/SmallPairSieve_{tau}_{nu}.lean"
    sraw = (ROOT / spath).read_bytes()
    assert sha(sraw) == sieve_pins[spath] == reports[k]["sieve_sha256"]
    st = sraw.decode()
    masks = {n: int(v) for n, v in re.findall(r"def (smallPairMask_\d+_\d+_\d+) : ℕ := (\d+)", st)}
    slit = re.search(rf"def smallPairSieve_{tau}_{nu} .*? := \[(.*?)\n\]", st, re.S).group(1)
    mpat = r"\((\d+),\s*(smallPairMask_\d+_\d+_\d+)\)"
    sieve = [(int(n) + 1, masks[name]) for n, name in re.findall(mpat, slit)]
    assert re.sub(mpat, "", slit).replace(",", "").strip() == "" and len(sieve) == 25
    fname = f"row{k:02}.json"
    fraw = (ROOT / "sparse_floor_next/generated" / fname).read_bytes()
    assert sha(fraw) == floor_manifest["files"][fname]["sha256"] == reports[k]["floor_json_sha256"]
    frozen = json.loads(fraw)
    assert [c["original_vertex_indices"] for c in frozen["colors"]] == classes
    for c, indices in enumerate(classes):
        assert reports[k]["classes"][c]["vertices"] == len(indices)
        assert reports[k]["classes"][c]["pairs"] == len(indices) * (len(indices)-1) // 2
        for key in ("old_mask_calls", "selected_mask_calls", "selected_index_sum", "guard_tags", "floor_tags"):
            assert reports[k]["classes"][c].get(key, 0) == costs[k]["classes"][c].get(key, 0)
    assert reports[k]["packed_codes_digest"] == costs[k]["packed_codes_digest"]
    return s, tau, nu, vertices, classes, sieve, frozen

def replay(k, args):
    _, tau, nu, vertices, classes, sieve, frozen = args
    signatures = [[(a % p, b % p) for p, _ in sieve] for a, b in vertices]
    selected, codes = [], {}
    for color, indices in enumerate(classes):
        output = []
        for head_pos, i in enumerate(indices):
            h = frozen["colors"][color]["heads"][head_pos]
            assert h["head_index"] == i
            tags, survivors, guards, ks = [], [], [], []
            floors = iter(h["floor_witnesses"])
            for j in indices[head_pos+1:]:
                tag = 31
                for t, (p, mask) in enumerate(sieve):
                    a, b = signatures[i][t]
                    c, d = signatures[j][t]
                    idx = ((a*c - nu*b*d + 1) % p)*p + ((a*d+b*c+tau*b*d) % p)
                    if not ((mask >> idx) & 1):
                        tag = t
                        break
                if tag == 31:
                    survivors.append(j)
                    a, b = vertices[i]
                    c, d = vertices[j]
                    rr, ii = a*c-nu*b*d+1, a*d+b*c+tau*b*d
                    q = nu if tau == 0 else 4*nu-1
                    if ii == 0 and rr < 0 and rr % q != 0:
                        guards.append(j)
                    else:
                        w = next(floors)
                        assert w["target_index"] == j
                        z = w["k"]
                        if ii != 0:
                            nn = rr*rr + tau*rr*ii + nu*ii*ii
                            assert z*z < nn < (z+1)*(z+1)
                        elif rr > 0:
                            assert z*z < rr < (z+1)*(z+1)
                        else:
                            assert q*z*z < -rr < q*(z+1)*(z+1)
                        ks.append(z)
                tags.append(tag)
            assert next(floors, None) is None
            assert survivors == h["modular_targets"] and guards == h["cheap_guard_targets"]
            word = sum(t * 32**n for n, t in enumerate(tags))
            output.append((word, ks))
            codes[i] = word
        selected.append(output)
    assert digest(selected) == reports[k]["selected_rows_digest"]
    words_hash = sha("".join(f"{i}:{codes[i]}\n" for i in range(len(vertices))).encode())
    assert words_hash == reports[k]["packed_codes_digest"]
    return selected

all_inputs = {k: source_inputs(k) for k in range(1,49)}
assert sum(c["pairs"] for r in reports.values() for c in r["classes"]) == 8063266
independent = {k: replay(k, all_inputs[k]) for k in (34, 47)}
reference34 = (ROOT / "pair_selected_next/generated/SmallPairSelectedData34.lean").read_text()
for side, rows in zip(("left", "right"), independent[34]):
    literal = re.search(rf"def {side}Rows .*? := (\[.*?\n\])", reference34, re.S).group(1)
    assert ast.literal_eval(literal) == rows

# Invoke the reviewed rendering function only, with independently computed rows.
# It returns strings in memory and does not write Lean sources.
def module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod
author = module(script, "selected_scale_render_review")
floors = module(ROOT / "sparse_floor_next/generate_floor_witnesses.py", "frozen_floor_render_review")
original, tau, nu, vertices, classes, sieve, frozen = all_inputs[47]
files = author.stage_row(ROOT, 47, independent[47], classes, sieve, floors, floor_manifest, old_manifest)
actual_files = {p: {"sha256": sha(s.encode()), "bytes":len(s.encode())} for p, s in files.items()}
assert actual_files == reports[47]["files"]
assert sum(x["bytes"] for x in actual_files.values()) == manifest["total_source_bytes"]
for part in ("Inputs", "WitnessData", "Arithmetic", "Closure", "Data"):
    name = f"D1Bound5/SmallPairGraph{part}47.lean"
    assert actual_files[name] == old_manifest[47]["files"][name]
data = files["D1Bound5/SmallPairRawSelectedData47.lean"]
for side, indices, expected in zip(("left", "right"), classes, independent[47]):
    body = re.search(rf"def {side}Cached .*? := \[(.*?)\n\]", data, re.S).group(1)
    pat = r"⟨⟨(-?\d+),\s*(-?\d+)⟩,\s*(\[[^\]]*\])⟩"
    records = [((int(a),int(b)),ast.literal_eval(sig)) for a,b,sig in re.findall(pat,body)]
    assert re.sub(pat,"",body).replace(",","").strip()==""
    assert records == [(vertices[i],[(vertices[i][0]%p,vertices[i][1]%p) for p,_ in sieve]) for i in indices]
    rows=ast.literal_eval(re.search(rf"def {side}Rows .*? := (\[.*?\n\])",data,re.S).group(1))
    assert rows == expected
joined="\n".join(files.values())
public=[f"smallPair{x}_47_{suffix}" for x,suffix in [("Seeds","checked"),("Closure","checked"),("Filter","checked"),("NoTriangle","checked"),("Large","count")]]
for name in public:
    pattern=rf"theorem {name}\b(.*?) :="
    assert re.findall(pattern,joined,re.S)==re.findall(pattern,original,re.S)
    assert len(re.findall(pattern,joined,re.S))==1
deps={Path(p).stem:[m for m in re.findall(r'^import D1Bound5\.(\w+)',s,re.M) if f'D1Bound5/{m}.lean' in files] for p,s in files.items()}
def visit(n, ancestors):
    assert n not in ancestors, (n,ancestors)
    for d in deps[n]: visit(d,ancestors+[n])
for n in deps: visit(n,[])
report={
 "status":"Independent full source/mathematical review PASS; no compiler or speed claim",
 "generator_sha256":sha(script.read_bytes()),"manifest_sha256":sha(manifest_path.read_bytes()),
 "all48_original_sieve_floor_and_helper_pins_verified":True,
 "all48_manifest_costs_and_class_sizes_match_frozen_reports":True,
 "all48_total_same_color_pairs":8063266,
 "independently_replayed_rows":[34,47],"independently_replayed_pairs":51984+37636,
 "row34_words_and_floor_rows_identical":True,
 "row47_full_tail_first_reject_tags_and_floor_exhaustion_verified":True,
 "row47_prospective_source_hashes_verified":actual_files,
 "row47_five_scaffold_modules_identical_to_frozen_backend":True,
 "row47_literal_class_coordinates_signatures_and_rows_independently_parsed":True,
 "all_five_original_public_theorem_types_preserved":True,
 "generated_imports_acyclic":True,
 "rendering_note":"Author stage_row renderer invoked with independently computed data only to inspect prospective strings in memory; no Lean files emitted.",
 "scope":"All48 computational traversal reviewed by source and manifest agreement;89,620actualpairs independently re-enumerated across34/47, not a second independent enumeration of all8,063,266pairs."
}
out=ROOT/'audit_next/selected_scale_source_review.json'
out.write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({'result':'PASS','review':str(out),'sha256':sha(out.read_bytes()),'independent_pairs':89620,'staged_sources_inspected':len(files)}))
