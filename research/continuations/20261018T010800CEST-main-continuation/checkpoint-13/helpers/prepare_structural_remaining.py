"""Prepare only four new structural research candidates; never install or compile."""
from pathlib import Path
import datetime, hashlib, json, os, subprocess, types

R = Path('/Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation')
PROJECT = R.parents[2]
B = R / 'selected-scale-inputs'
H = R / 'checkpoint-12/helpers'
ROWS = [27, 31, 32, 37]
KINDS = ['Inputs', 'WitnessData', 'Arithmetic', 'Closure', 'Triangle', 'Data']
PYTHON = '/Users/tp/.local/bin/python3.12'
GENERATOR_SHA = '4942337e7b44f4c84ef0ef0b75ef6aeb2c90fd5e17d74df28ba8df8af750ec7a'
NARROW_SHA = '4c120fa958983bdc2f39d1fd38db30738f541f1372d28ac5de5b035ebb113e78'
EXPECTED_SHA = 'f545ddfd9ae3dfd75f318f815b229afa74119756b6648b919ff0a986d266b198'
REQUIREMENTS_SHA = '5a15034bf8bad9a11647231e683f1006f5b4512c3f715a21269555273b6a85fb'
BACKEND_SHA = '07bcd289cf1e66855f3178c79fd66053518d5657c0e1ae8a55a614e0b7f3d25c'
sha = lambda data: hashlib.sha256(data).hexdigest()

def require(condition, message):
    if not condition:
        raise ValueError(message)

materializer_path = H / 'pair_selected_scale_next/materialize_inputs.py'
materializer = materializer_path.read_bytes()
require(sha(materializer) == '303299e125503841fa9fe651186d9b10e44faaefaefefacd2f049ade6130f1b0', 'Materializer pin')
m = types.ModuleType('verified_readonly_materializer')
exec(compile(materializer, str(materializer_path), 'exec'), m.__dict__)

def checked(path, digest):
    data = m.read_regular(path)
    require(sha(data) == digest, 'Pin mismatch: ' + str(path))
    return data

requirements_path = H / 'pair_selected_scale_next/input_requirements.json'
required = m.requirements(requirements_path, REQUIREMENTS_SHA)
require(len(required) == 134, 'Expected frozen134 inputs')

def check_inputs():
    checked(requirements_path, REQUIREMENTS_SHA)
    for item in required:
        require(sha(m.read_regular(B / item['path'], item['bytes'])) == item['sha256'],
                'Frozen input changed: ' + item['path'])

check_inputs()
generator = B / 'pair_backend_next/stage_pair_backends.py'
narrow = R / 'narrow22-preparation/narrow_expanded_inputs.py'
expected_path = B / 'pair_backend_next/all47_dry/manifest.json'
checked(generator, GENERATOR_SHA)
checked(narrow, NARROW_SHA)
checked(B / 'pair_backend_next/backend_source_pins.json', BACKEND_SHA)
review_path = R / 'checkpoint-11/helpers/audit_next/narrow_expanded22_review.json'
checked(review_path, '93ddcde49582c21c9ff3cd7345fef871f117232bdaa24eb8677f662d0e1e7d9a')
expected_manifest = json.loads(checked(expected_path, EXPECTED_SHA))
row_records = {r['row']: r for r in expected_manifest['results'] if r['row'] in ROWS}
require(set(row_records) == set(ROWS), 'Missing structural row')
expected = {}
for k in ROWS:
    rec = row_records[k]
    require(rec['backend'] == 'structural', 'Wrong backend')
    names = {f'D1Bound5/SmallPairGraph{kind}{k}.lean' for kind in KINDS}
    require(set(rec['files']) == names, 'Unexpected six-module schema')
    expected.update(rec['files'])
require(len(expected) == 24 and sum(v['bytes'] for v in expected.values()) == 3068676,
        'Expanded source count or byte total')

expanded = R / 'prepared-expanded-structural-27-31-32-37'
outputs = {k: R / f'prepared-narrow{k}' for k in ROWS}
logs = R / 'structural-remaining-preparation-logs'
receipt_path = R / 'structural-remaining-preparation-receipt.json'
for path in [expanded, *outputs.values(), logs, receipt_path]:
    require(not path.exists() and not path.is_symlink(), 'Destination already exists: ' + str(path))

tracked = set(expected)
for k in [16, 22, 34, 41]:
    tracked.update(f'D1Bound5/SmallPairGraph{kind}{k}.lean' for kind in KINDS)

def preimages():
    result = {}
    for name in sorted(tracked):
        p = PROJECT / name
        require(not p.is_symlink(), 'Project source symlink: ' + name)
        result[name] = sha(m.read_regular(p)) if p.exists() else None
    return result

before = preimages()
env = dict(os.environ)
env.pop('PYTHONOPTIMIZE', None)
env['PYTHONDONTWRITEBYTECODE'] = '1'
logs.mkdir(mode=0o700)

def run(command, log_name):
    with (logs / log_name).open('xb') as log:
        subprocess.run(command, cwd=R, env=env, stdout=log,
                       stderr=subprocess.STDOUT, check=True, timeout=600)

# The frozen expanded generator can overwrite its output: the explicit
# nonexistence guard above is mandatory; it receives only this NEW directory.
run([PYTHON, '-B', str(generator), '--rows', '27,31,32,37',
     '--exclude-rows', '16,22,34,41',
     '--input-dir', str(B / 'finite_next/two_small/D1Bound5'),
     '--manifest-dir', str(B / 'pair_witness_next'),
     '--sieve-dir', str(B / 'finite_fast_next/sieves'),
     '--root-routine', str(B / 'finite_next/two_small/generate_pair_closures.py'),
     '--staging-helper', str(B / 'pair_witness_next/pair_staging.py'),
     '--floor-generator', str(B / 'sparse_floor_next/generate_floor_witnesses.py'),
     '--floor-manifest', str(B / 'sparse_floor_next/generated/manifest.json'),
     '--source-pins', str(B / 'pair_backend_next/backend_source_pins.json'),
     '--expected-manifest', str(expected_path),
     '--output-dir', str(expanded)], 'expanded.log')
expanded_bytes = m.read_regular(expanded / 'manifest.json')
expanded_manifest = json.loads(expanded_bytes)
require(expanded_manifest['rows'] == ROWS and expanded_manifest['file_count'] == 24,
        'Expanded row/count mismatch')
require(expanded_manifest['expected_manifest_verified'] is True, 'Missing exact source gate')
require(expanded_manifest['results'] == [row_records[k] for k in ROWS], 'Expanded metadata mismatch')
require({str(p.relative_to(expanded)) for p in expanded.rglob('*.lean')} == set(expected),
        'Unexpected expanded Lean files')
for name, pin in expected.items():
    require(sha(m.read_regular(expanded / name, pin['bytes'])) == pin['sha256'],
            'Expanded output mismatch: ' + name)

def split_imports(data):
    lines = data.splitlines(keepends=True)
    n = 0
    while n < len(lines) and lines[n].startswith(b'import '):
        n += 1
    require(n > 0, 'Missing imports')
    return b''.join(lines[:n]), b''.join(lines[n:])

narrow_reports = {}
for k in ROWS:
    checked(narrow, NARROW_SHA)
    run([PYTHON, '-B', str(narrow), '--source-root', str(expanded),
         '--manifest-sha256', sha(expanded_bytes), '--row', str(k),
         '--output', str(outputs[k])], f'narrow{k}.log')
    report_bytes = m.read_regular(outputs[k] / 'manifest.json')
    report = json.loads(report_bytes)
    files = row_records[k]['files']
    require(report['row'] == k and report['backend'] == 'structural', 'Narrow row/backend')
    require(report['input_manifest_sha256'] == sha(expanded_bytes)
            and report['transform_sha256'] == NARROW_SHA, 'Narrow provenance')
    require(set(report['files']) == set(files) and report['unchanged_files'] == 4,
            'Narrow file count')
    require(report['all_bodies_byte_identical'] is True, 'Narrow preservation flag')
    require(m.read_regular(outputs[k] / 'source_manifest.before.json') == expanded_bytes,
            'Original manifest changed')
    require({str(p.relative_to(outputs[k])) for p in outputs[k].rglob('*.lean')} == set(files),
            'Unexpected narrow Lean files')
    for name, pin in files.items():
        old = m.read_regular(expanded / name, pin['bytes'])
        imports, body = split_imports(old)
        want = old
        if name == f'D1Bound5/SmallPairGraphInputs{k}.lean':
            require(imports == b'import D1Bound5.SmallPairGraphCheck\n', 'Inputs imports')
            want = b'import D1Bound5.Coordinates\n' + body
        elif name == f'D1Bound5/SmallPairGraphArithmetic{k}.lean':
            require(imports == (f'import D1Bound5.SmallPairGraphInputs{k}\n'
                    'import D1Bound5.TwoSmallSeedDisks\n').encode(), 'Arithmetic imports')
            want = imports + b'import D1Bound5.SmallPairGraphCheck\n' + body
        actual = m.read_regular(outputs[k] / name)
        require(actual == want and split_imports(actual)[1] == body, 'Body/import change: ' + name)
        evidence = report['files'][name]
        require(evidence['pre_sha256'] == pin['sha256']
                and evidence['post_sha256'] == sha(actual)
                and evidence['post_bytes'] == len(actual), 'Narrow evidence mismatch')
    narrow_reports[str(k)] = dict(directory=str(outputs[k]),
        manifest_sha256=sha(report_bytes), source_bytes=report['total_post_bytes'],
        outputs=report['files'])

require(sum(r['source_bytes'] for r in narrow_reports.values()) == 3068788, 'Narrow byte total')
require(preimages() == before, 'Tracked project source changed')
check_inputs()
checked(generator, GENERATOR_SHA)
checked(narrow, NARROW_SHA)
checked(expected_path, EXPECTED_SHA)
receipt = dict(utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
    status='Research source preparation only; no installation or Lean compilation',
    script_sha256=sha(m.read_regular(Path(__file__))),
    generator_sha256=GENERATOR_SHA, narrow_helper_sha256=NARROW_SHA,
    frozen_expected_manifest_sha256=EXPECTED_SHA, frozen134_requirements_sha256=REQUIREMENTS_SHA,
    rows=ROWS, source_count=24, narrow_source_bytes=3068788,
    expanded_manifest_sha256=sha(expanded_bytes), narrow=narrow_reports,
    project_preimages=before, tracked_project_sources_unchanged=True,
    frozen134_sources_unchanged=True, no_queue_or_git_action=True)
with receipt_path.open('x') as f:
    f.write(json.dumps(receipt, indent=2) + '\n')
print(json.dumps(receipt, indent=2), flush=True)
