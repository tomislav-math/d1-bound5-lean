"""Record current working endpoint acceptance after graph25's six-scope audit."""
from pathlib import Path
from datetime import datetime, timezone
import fcntl
import hashlib
import importlib.util
import json
import re
import subprocess
import sys

R = Path('/Users/tp/Lean/D1Bound5')
W = R / 'research/continuations/20261018T010800CEST-main-continuation'
O = R / 'research/continuations/20261022-graph25-closure'
DRIVER = W / 'continuation_driver_capacity.py'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PREVIOUS = [2, 9, 12, 13, 16, 17, 18, 20, 22, 26, 27, 29, 31, 32,
            33, 34, 35, 37, 38, 40, 41, 42, 44, 45, 47, 48]


def load(path):
    return json.loads(path.read_text())


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


assert sha(DRIVER) == DRIVER_SHA
spec = importlib.util.spec_from_file_location('graph25_inventory_driver', DRIVER)
module = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = module
spec.loader.exec_module(module)

with (W / 'continuation-driver.lock').open('r+') as owner, \
        (W / 'continuation-intake.lock').open('r+') as intake:
    for lock in (owner, intake):
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    active = load(W / 'continuation-active.json')
    assert not active.get('active') and not active.get('protected_closure')
    endpoint = load(O / 'ENDPOINT_VERIFICATION.json')
    state = load(O / 'ENDPOINT_PROOF_STATE.json')
    assert endpoint['status'] == 'GRAPH25_WORKING_ENDPOINT_SCOPED_VERIFIED'
    assert endpoint['module'] == 'SmallPairGraphData25'
    assert endpoint['main_theorem_complete'] is False and endpoint['root_integration'] is False
    assert hashlib.sha256(json.dumps(state, sort_keys=True,
                                   separators=(',', ':')).encode()).hexdigest() == endpoint['proof_fingerprint']
    driver = module.Driver(R, W)
    queue, names, closures, accepted, unknown, eligible = driver.snapshot()
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
    assert not unknown, unknown
    modules = {}
    for path in (R / 'D1Bound5').glob('SmallPairGraphData*.lean'):
        match = re.fullmatch(r'SmallPairGraphData(\d+)', path.stem)
        if match:
            number = int(match[1])
            assert number not in modules
            modules[number] = path.stem
    assert set(modules) == set(range(1, 49))
    current = sorted(number for number, name in modules.items() if name in accepted)
    assert current == sorted(PREVIOUS + [25]), current
    assert closures['SmallPairGraphData25'] == state['endpoint_source_closure']
    assert driver.manifest_matches(state['verified_artifacts'])
    assert driver.manifest_matches(state['configuration'])
    remaining = sorted(set(range(1, 49)) - set(current))
    assert len(current) == 27 and len(remaining) == 21
    result = {
        'status': 'CURRENT_WORKING_ENDPOINT_INVENTORY_AFTER_GRAPH25_PASS',
        'utc': datetime.now(timezone.utc).isoformat(),
        'observed_head': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=R, text=True).strip(),
        'previous_accepted_endpoints': PREVIOUS,
        'current_accepted_endpoints': current,
        'accepted_endpoint_count': len(current),
        'remaining_endpoints': remaining,
        'remaining_endpoint_count': len(remaining),
        'total_endpoints': 48,
        'added_endpoints': [25],
        'unknown_modules': unknown,
        'max_parallel': queue['max_parallel'],
        'pause_after_current': queue['pause_after_current'],
        'graph25_endpoint_summary_sha256': sha(O / 'ENDPOINT_VERIFICATION.json'),
        'graph25_endpoint_proof_fingerprint': endpoint['proof_fingerprint'],
        'main_theorem_complete': False,
        'root_integration': False,
        'interpretation': 'Working graph endpoints only; not a percentage of mathematical completion.',
    }
    with (O / 'ENDPOINT_INVENTORY.json').open('x') as stream:
        stream.write(json.dumps(result, indent=2, sort_keys=True) + '\n')
    print(json.dumps(result), flush=True)
