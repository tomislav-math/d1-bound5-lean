#!/usr/bin/env python3
"""Observe an existing pinned audit invocation; never interpret proof results."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import resource
import signal
import subprocess
import sys
import time


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def write_new(path, obj):
    with Path(path).open('x') as stream:
        json.dump(obj, stream, indent=2, sort_keys=True)
        stream.write('\n')


def usage(row):
    return {key: getattr(row, key) for key in dir(row) if key.startswith('ru_')}


def cleanup_owned(child):
    """Only signal a still-waitable child group; never a reused PID after reaping."""
    try:
        pid, status, row = os.wait4(child.pid, os.WNOHANG)
    except ChildProcessError:
        return {'status': 'ALREADY_REAPED_NO_SIGNAL_SENT'}
    if not pid:
        try:
            os.killpg(child.pid, signal.SIGTERM)
        except ProcessLookupError:
            pass
        deadline = time.monotonic() + 5
        while not pid and time.monotonic() < deadline:
            time.sleep(0.05)
            pid, status, row = os.wait4(child.pid, os.WNOHANG)
        if not pid:
            try:
                os.killpg(child.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            pid, status, row = os.wait4(child.pid, 0)
    child.returncode = os.waitstatus_to_exitcode(status)
    return {'status': 'OWNED_CHILD_REAPED', 'child_exit_code': child.returncode,
            'wait_status': status, 'wait4_rusage': usage(row)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--invocation', required=True, type=Path)
    parser.add_argument('--invocation-sha256', required=True)
    parser.add_argument('--out', required=True, type=Path)
    parser.add_argument('--execute', action='store_true')
    args = parser.parse_args()
    if sys.platform != 'linux' or not hasattr(os, 'wait4'):
        raise RuntimeError('This observer requires Linux wait4; no fallback inference')
    invocation_path = args.invocation.resolve(strict=True)
    raw = invocation_path.read_bytes()
    if hashlib.sha256(raw).hexdigest() != args.invocation_sha256:
        raise RuntimeError('Invocation digest mismatch')
    invocation = json.loads(raw)
    argv = invocation['argv']
    if not isinstance(argv, list) or len(argv) < 2 or not all(isinstance(x, str) for x in argv):
        raise RuntimeError('Expected an exact argv list including executable and runner')
    if not all(Path(x).is_absolute() and Path(x).is_file() for x in argv[:2]):
        raise RuntimeError('Executable and runner must be existing absolute files')
    if sha(argv[1]) != invocation['runner_sha256']:
        raise RuntimeError('Pinned runner digest mismatch')
    out = args.out.resolve()
    output_root = Path(__file__).resolve().parent / 'observations'
    if output_root not in out.parents:
        raise RuntimeError('Observer output must be under its own observations directory')
    # Observations must never write into the source/build tree or audit output.
    forbidden = []
    invocation_inputs = {}
    pending = [(invocation_path, invocation)]
    while pending:
        path, current = pending.pop()
        if str(path) in invocation_inputs:
            raise RuntimeError('Cyclic nested invocation')
        invocation_inputs[str(path)] = sha(path)
        forbidden.append(path.parent)
        current_argv = current['argv']
        for flag in ('--source-root', '--artifact-root', '--build-dir', '--out'):
            if flag in current_argv:
                forbidden.append(Path(current_argv[current_argv.index(flag) + 1]).resolve())
        if '--invocation' in current_argv:
            nested = Path(current_argv[current_argv.index('--invocation') + 1]).resolve(strict=True)
            expected = current_argv[current_argv.index('--invocation-sha256') + 1]
            if sha(nested) != expected:
                raise RuntimeError('Nested invocation digest mismatch')
            pending.append((nested, json.loads(nested.read_text())))
    if any(out == root or root in out.parents for root in forbidden):
        raise RuntimeError('Observer output overlaps protected invocation inputs/outputs')
    if out.exists():
        raise RuntimeError('Observer output must be new; existing observations are immutable')
    before = {
        'schema': 1,
        'status': 'PREPARED_NOT_EXECUTED',
        'proof_acceptance': 'NOT_ASSESSED_BY_OBSERVER',
        'invocation': str(invocation_path),
        'invocation_sha256': args.invocation_sha256,
        'invocation_inputs': invocation_inputs,
        'runner_sha256': invocation['runner_sha256'],
        'observer_sha256': sha(__file__),
        'argv': argv,
        'cwd': os.getcwd(),
        'environment': 'inherited unchanged; values not collected',
        'stdio': 'inherited unchanged',
        'process_session': 'new child session, only for owned signal forwarding',
        'output': str(out),
        'limits': 'unchanged; reviewed audit timeouts remain authoritative',
        'ru_maxrss_units': 'KiB on Linux',
        'scope': 'wait4 for the one outer audit process, including accounted waited descendants',
        'caveat': 'Largest process high-water mark, not simultaneous process-tree RSS; not per-Lean attribution',
    }
    if not args.execute:
        print(json.dumps(before, indent=2))
        return 0
    out.mkdir(parents=True, exist_ok=False)
    before['status'] = 'OBSERVATION_STARTED'
    before['started_unix_seconds'] = time.time()
    write_new(out / 'START.json', before)
    started = time.monotonic()
    child = None
    reaped = False
    forwarded = []

    def forward(signum, frame):
        forwarded.append({'signal': signum, 'elapsed_seconds': time.monotonic() - started})
        if child is not None and not reaped and child.returncode is None:
            try:
                # Only the observer-created child session receives this signal.
                os.killpg(child.pid, signum if len(forwarded) == 1 else signal.SIGKILL)
            except ProcessLookupError:
                pass

    old_handlers = {s: signal.signal(s, forward) for s in (signal.SIGINT, signal.SIGTERM)}
    try:
        # No shell, cwd override, environment override, or changed audit arguments.
        child = subprocess.Popen(argv, start_new_session=True)
        # A signal during Popen construction is delivered once the child is owned.
        if forwarded:
            try:
                os.killpg(child.pid, forwarded[0]['signal'])
            except ProcessLookupError:
                pass
        _, wait_status, child_usage = os.wait4(child.pid, 0)
        reaped = True
        code = os.waitstatus_to_exitcode(wait_status)
        child.returncode = code  # wait4 already reaped it; prevent Popen reaping again.
        result = dict(before)
        result.update({
            'status': 'RESOURCE_OBSERVATION_COMPLETE',
            'ended_unix_seconds': time.time(),
            'wall_seconds': time.monotonic() - started,
            'wait_status': wait_status,
            'child_exit_code': code,
            'shell_exit_code': code if code >= 0 else 128 - code,
            'wait4_rusage': usage(child_usage),
            'observer_children_rusage': usage(resource.getrusage(resource.RUSAGE_CHILDREN)),
            'forwarded_signals': forwarded,
            'invocation_unchanged': sha(invocation_path) == before['invocation_sha256'],
            'all_invocation_inputs_unchanged': all(sha(path) == expected for path, expected in invocation_inputs.items()),
            'runner_unchanged': sha(argv[1]) == before['runner_sha256'],
            'observer_unchanged': sha(__file__) == before['observer_sha256'],
        })
        write_new(out / 'RESOURCE_USAGE.json', result)
        print(json.dumps({'observation': str(out / 'RESOURCE_USAGE.json'),
                          'child_exit_code': code,
                          'wall_seconds': result['wall_seconds'],
                          'maxrss_kib': child_usage.ru_maxrss}), flush=True)
        return result['shell_exit_code']
    except BaseException as error:
        failure = {'status': 'RESOURCE_OBSERVATION_INCOMPLETE',
                   'proof_acceptance': 'NOT_ASSESSED_BY_OBSERVER',
                   'error_type': type(error).__name__, 'error': str(error)[:2000],
                   'wall_seconds': time.monotonic() - started,
                   'forwarded_signals': forwarded}
        if child is not None and not reaped:
            try:
                failure['owned_child_cleanup'] = cleanup_owned(child)
            except BaseException as cleanup_error:
                failure['cleanup_error'] = type(cleanup_error).__name__ + ': ' + str(cleanup_error)[:2000]
        write_new(out / 'ERROR.json', failure)
        raise
    finally:
        for signum, handler in old_handlers.items():
            signal.signal(signum, handler)


if __name__ == '__main__':
    sys.exit(main())
