"""Reproduce the reviewed Light47 backend in new research directories only."""
from pathlib import Path
import ast, datetime, hashlib, json, subprocess, types

R = Path('/Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation')
PROJECT = R.parents[2]
H = R / 'checkpoint-12/helpers'
sha = lambda b: hashlib.sha256(b).hexdigest()
def checked(path, digest):
    data = path.read_bytes()
    assert sha(data) == digest, str(path)
    return data
materializer = checked(H / 'pair_selected_scale_next/materialize_inputs.py',
    '303299e125503841fa9fe651186d9b10e44faaefaefefacd2f049ade6130f1b0')
m = types.ModuleType('verified_materializer')
exec(compile(materializer, str(H / 'pair_selected_scale_next/materialize_inputs.py'), 'exec'), m.__dict__)
converter_path = R / 'prepare_light_rows_recovered.py'
converter = m.read_regular(converter_path)
assert sha(converter) == '67e22402774fe51120cd22ac20826b4bd3f1c44a8bb5c401465f023c3f220dde'
base_path = H / 'pair_selected_scale_next/input_requirements.json'
base = m.read_regular(base_path)
assert sha(base) == '5a15034bf8bad9a11647231e683f1006f5b4512c3f715a21269555273b6a85fb'
tree = ast.parse(converter)
pins = next(ast.literal_eval(n.value) for n in tree.body if isinstance(n, ast.Assign)
    and any(isinstance(t, ast.Name) and t.id == 'LIGHT_PINS' for t in n.targets))
extras = {}
for name, digest in pins.items():
    data = m.read_regular(H / name)
    assert sha(data) == digest, name
    extras[name] = data
converter_name = 'pair_light_scale_next/prepare_light_rows.py'
extras[converter_name] = converter
obj = json.loads(base)
files = {x['path']: x for x in obj['files']}
assert len(files) == len(obj['files']) == 134
for name, data in extras.items():
    assert name not in files
    files[name] = dict(path=name, sha256=sha(data), bytes=len(data),
        reasons=['light converter LIGHT_PINS' if name in pins else 'light entry converter'])
obj['generator_sha256'] = sha(converter)
obj['raw_requirements_sha256'] = sha(base)
obj['files'] = [files[k] for k in sorted(files)]
obj['note'] = 'Separate light input superset; frozen raw requirements unchanged. Uses the same existing materializer with explicit requirements path and SHA.'
requirements_data = (json.dumps(obj, indent=2) + '\n').encode()
requirements_sha = 'a96177b74b4fda368613a8247a62aa2258b3111e651bdedbf856a631adc13634'
assert sha(requirements_data) == requirements_sha
seed = R / 'light-scale-bootstrap'
bundle = R / 'light-scale-inputs138'
dry = R / 'light47-manifest-preflight'
out = R / 'prepared-light47'
receipt_path = R / 'light47-preparation-receipt.json'
for path in [seed, bundle, dry, out, receipt_path]:
    assert not path.exists() and not path.is_symlink(), str(path)
# The frozen134-source bundle is checked directly, without filename guessing.
old_requirements = m.requirements(base_path, sha(base))
old_bundle = R / 'selected-scale-inputs'
for item in old_requirements:
    assert sha(m.read_regular(old_bundle / item['path'], item['bytes'])) == item['sha256']
seed.mkdir(mode=0o700)
for name, data in extras.items():
    path = seed / name
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('xb') as f:
        f.write(data)
req_path = seed / 'input_requirements.json'
with req_path.open('xb') as f:
    f.write(requirements_data)
required = m.requirements(req_path, requirements_sha)
assert len(required) == 138
selected, missing, rejected = m.inventory(required, [old_bundle, seed])
assert not missing and not rejected, (missing, rejected)
m.materialize(selected, bundle, requirements_sha)
cmd = ['/Users/tp/.local/bin/python3.12', str(bundle / converter_name),
       '--workspace', str(bundle), '--rows', 'all', '--stage-rows', '47']
with (R / 'light47-preflight.log').open('xb') as log:
    subprocess.run(cmd + ['--output-dir', str(dry)], stdout=log, stderr=subprocess.STDOUT, check=True, timeout=600)
manifest_bytes = m.read_regular(dry / 'manifest.json')
manifest_sha = '74522436b3bbaef7267bc6f62eafef9fb390bc56fbce7f326e16efdaaa65f45a'
assert sha(manifest_bytes) == manifest_sha
manifest = json.loads(manifest_bytes)
assert manifest['file_count'] == 11 and manifest['staged_rows'] == [47]
expected = next(x['files'] for x in manifest['results'] if x['row'] == 47)
assert len(expected) == 11
def preimages():
    result = {}
    for name in expected:
        p = PROJECT / name
        assert not p.is_symlink()
        result[name] = sha(m.read_regular(p)) if p.exists() else None
    return result
before = preimages()
with (R / 'light47-emission.log').open('xb') as log:
    subprocess.run(cmd + ['--output-dir', str(out), '--emit', '--expected-manifest', str(dry / 'manifest.json')],
        stdout=log, stderr=subprocess.STDOUT, check=True, timeout=600)
assert m.read_regular(out / 'manifest.json') == manifest_bytes
for name, info in expected.items():
    assert sha(m.read_regular(out / name, info['bytes'])) == info['sha256']
assert preimages() == before
assert m.read_regular(base_path) == base
for item in old_requirements:
    assert sha(m.read_regular(old_bundle / item['path'], item['bytes'])) == item['sha256']
receipt = dict(utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
    status='Exact source reproduction only; Lean compilation pending; no project source installed',
    script_sha256=sha(Path(__file__).read_bytes()), converter_sha256=sha(converter),
    requirements_sha256=requirements_sha, manifest_sha256=manifest_sha,
    source_count=11, source_bytes=manifest['total_source_bytes'],
    project_preimages=before, outputs=expected,
    original134_sources_unchanged=True, project_unchanged=True)
with receipt_path.open('x') as f:
    f.write(json.dumps(receipt, indent=2) + '\n')
print(json.dumps(receipt, indent=2), flush=True)
