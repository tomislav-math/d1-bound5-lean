"""One 240-second guarded graph1 target; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl
import importlib.util
import json
import os
import signal
import subprocess
import sys
import time

from foundation_inputs import DRIVER_SHA, TARGETS, load_binding, source_hash


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
assert OUT == ROOT / 'research/continuations/20261022-graph1-foundation'
PINS = __REVIEWED_SOURCE_PINS__
os.environ['LEAN_NUM_THREADS'] = '1'
assert len(sys.argv) == 2
name = sys.argv[1]
assert name in PINS and set(PINS) == set(TARGETS), 'Unreviewed target'
binding = load_binding(OUT)
plan = json.loads((OUT / 'PLAN.json').read_text())
installation = json.loads((OUT / 'INSTALL_RECEIPT.json').read_text())
installation_sha = source_hash(OUT / 'INSTALL_RECEIPT.json')
assert installation['status'] == 'EXACT_GRAPH1_LITERAL_PARTITION_INSTALLED_NOT_BUILT'
assert source_hash(OUT / 'PLAN.json') == installation['plan_sha256']
assert source_hash(OUT / 'PREPARED_PAYLOAD_SHA256.json') == installation['prepared_payload_sha256']
assert PINS == plan['source_manifest'] == installation['source_manifest']
assert source_hash(OUT / 'GRAPH1_BINDING.json') == plan['input_binding_sha256'] == installation['input_binding_sha256']
assert plan['configuration'] == binding['configuration']
payload = json.loads((OUT / 'PREPARED_PAYLOAD_SHA256.json').read_text())
assert source_hash(Path(__file__)) == payload['bounded_build.py']
for relative, expected in payload.items():
    path = OUT / relative
    assert path.resolve().is_relative_to(OUT) and source_hash(path) == expected
driver_path = WORK / 'continuation_driver_capacity.py'
assert source_hash(driver_path) == DRIVER_SHA
spec = importlib.util.spec_from_file_location('graph1_guarded_driver', driver_path)
module = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = module
spec.loader.exec_module(module)
driver = module.Driver(ROOT, WORK)


@contextmanager
def intake():
    with driver.lock_path.open('r+') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        try:
            yield
        finally:
            fcntl.flock(lock, fcntl.LOCK_UN)


def on_stop(_signal, _frame):
    driver.stop = True


for stop_signal in (signal.SIGTERM, signal.SIGINT, signal.SIGHUP):
    signal.signal(stop_signal, on_stop)


def no_live_project_compiler():
    output = subprocess.run(['ps', '-axo', 'pid=,ppid=,comm=,args='], text=True,
                            capture_output=True, check=True, timeout=10).stdout
    for line in output.splitlines():
        fields = line.strip().split(None, 3)
        if len(fields) < 4 or int(fields[0]) == os.getpid():
            continue
        pid, _, executable, _ = fields
        if Path(executable).name not in ('lean', 'lake', 'leanchecker'):
            continue
        process = subprocess.run(['/usr/sbin/lsof', '-a', '-p', pid, '-d', 'cwd', '-Fn'],
                                 text=True, capture_output=True, timeout=10)
        if process.returncode and subprocess.run(['ps', '-p', pid, '-o', 'pid='],
                capture_output=True, timeout=10).returncode == 0:
            raise RuntimeError('Cannot identify live compiler cwd: ' + pid)
        assert not any(item == 'n' + str(ROOT) or item.startswith('n' + str(ROOT) + '/')
                       for item in process.stdout.splitlines()), 'Another project compiler: ' + pid


def put(path, data):
    if not isinstance(data, bytes):
        data = (json.dumps(data, indent=2, sort_keys=True) + '\n').encode()
    with path.open('xb') as stream:
        stream.write(data)


def guards():
    assert source_hash(driver_path) == DRIVER_SHA
    assert driver.static == binding['configuration'] == plan['configuration']
    assert driver.manifest_matches(binding['configuration'], cached=False)
    assert source_hash(ROOT / 'D1Bound5.lean') == binding['canonical_root_sha256']
    assert source_hash(OUT / 'GRAPH1_BINDING.json') == plan['input_binding_sha256']
    assert source_hash(OUT / 'PLAN.json') == installation['plan_sha256']
    assert source_hash(OUT / 'PREPARED_PAYLOAD_SHA256.json') == installation['prepared_payload_sha256']
    assert source_hash(OUT / 'bounded_build.py') == payload['bounded_build.py']
    assert source_hash(OUT / 'foundation_inputs.py') == payload['foundation_inputs.py']
    assert source_hash(OUT / 'INSTALL_RECEIPT.json') == installation_sha
    assert source_hash(driver.queue_path) == installation['queue_after_sha256']


with (WORK / 'continuation-driver.lock').open('r+') as owner:
    fcntl.flock(owner, fcntl.LOCK_EX | fcntl.LOCK_NB)
    try:
        with intake():
            no_live_project_compiler()
            guards()
            active = json.loads(driver.active_path.read_text())
            assert not active.get('active') and not active.get('protected_closure'), \
                'Reconcile active ownership before building'
            queue = json.loads(driver.queue_path.read_text())
            assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
            assert source_hash(driver.queue_path) == installation['queue_after_sha256']
            assert name in queue['names']
            closure = driver.closure(name)
            assert not set(closure) & set(queue.get('blocked_modules', []))
            assert closure[name] == PINS[name]
            latest = driver.latest()
            prior = latest.get((name, module.fingerprint(closure)))
            assert prior is None, 'Existing attempt at these exact bytes; review before retry'
            for dependency in closure:
                if dependency == name:
                    continue
                dependency_closure = driver.closure(dependency)
                manifest = driver.expected_manifest(dependency, module.fingerprint(dependency_closure), latest)
                assert manifest and driver.artifacts(dependency) == manifest, \
                    'Unaccepted dependency: ' + dependency
            source = ROOT / 'D1Bound5' / (name + '.lean')
            for suffix in ('-BUILD_RECEIPT.json', '.lean', '-SOURCE_CLOSURE.json', '-build.log', '-ORIGINAL_SOURCES.json'):
                path = OUT / (name + suffix)
                assert not path.exists() and not path.is_symlink(), str(path)
            configuration = OUT / 'CONFIGURATION.json'
            if configuration.exists() or configuration.is_symlink():
                assert configuration.is_file() and not configuration.is_symlink()
                assert json.loads(configuration.read_text()) == binding['configuration']
            else:
                put(configuration, binding['configuration'])
            put(OUT / (name + '.lean'), source.read_bytes())
            put(OUT / (name + '-SOURCE_CLOSURE.json'), closure)
            guards()
            assert not driver.stop, 'Stop requested before launch'
            assert driver.launch(name, closure, 240)
        while driver.jobs:
            time.sleep(2)
            with intake():
                driver.reap()
    finally:
        if driver.jobs:
            driver.stop = True
            while driver.jobs:
                with intake():
                    driver.reap()
                if driver.jobs:
                    time.sleep(2)
    if not driver.rows or driver.rows[-1]['name'] != name:
        raise RuntimeError('No terminal target receipt')
    row = driver.rows[-1]
    put(OUT / (name + '-BUILD_RECEIPT.json'), row)
    put(OUT / (name + '-build.log'), Path(row['log']).read_bytes())
    original_closure = Path(row['log']).with_suffix('.sources.json')
    assert json.loads(original_closure.read_text()) == closure
    put(OUT / (name + '-ORIGINAL_SOURCES.json'), original_closure.read_bytes())
    guards()
    no_live_project_compiler()
    print('TARGET_DRAINED', json.dumps({key: row.get(key) for key in
          ('name', 'exit', 'accepted_build', 'seconds', 'timed_out', 'interrupted',
           'source_sha256', 'fingerprint', 'closure_unchanged', 'shared_artifacts_unchanged')}), flush=True)
    sys.exit(0 if row['accepted_build'] else 1)
