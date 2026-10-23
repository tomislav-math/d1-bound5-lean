#!/usr/bin/env python3
"""Run one reviewed argv with file-backed output and an actual child-return record.

This is an operational wrapper, not proof acceptance or a platform survival claim.
The child driver owns its existing resource/watchdog logic unchanged.
"""
import datetime
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time


def sha(data):
    return hashlib.sha256(data).hexdigest()


def utc():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def write(path, value):
    data = (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()
    fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600)
    with os.fdopen(fd, 'wb') as stream:
        stream.write(data)
        stream.flush()
        os.fsync(stream.fileno())
    directory = os.open(path.parent, os.O_RDONLY | os.O_DIRECTORY)
    try:
        os.fsync(directory)
    finally:
        os.close(directory)


def proc_identity(path):
    """Read /proc stat without assuming the comm field has no spaces."""
    raw = path.read_text()
    first = raw.find(' ('); last = raw.rfind(') ')
    if first < 1 or last <= first:
        raise ValueError('Malformed proc stat')
    fields = raw[last + 2:].split()
    return {'host_pid': int(raw[:first]), 'host_parent_pid': int(fields[1]),
            'host_start_ticks': int(fields[19])}


def proc_status(path):
    rows = dict(line.split(':', 1) for line in path.read_text().splitlines() if ':' in line)
    return {'host_pid': int(rows['Pid']), 'host_parent_pid': int(rows['PPid']),
            'namespace_pids': [int(x) for x in rows['NSpid'].split()]}


def observe_self_host():
    try:
        before = proc_identity(Path('/proc/self/stat'))
        status = proc_status(Path('/proc/self/status'))
        namespace = os.readlink('/proc/self/ns/pid')
        after = proc_identity(Path('/proc/self/stat'))
        if (before != after or before['host_pid'] != status['host_pid'] or
                before['host_parent_pid'] != status['host_parent_pid'] or
                not status['namespace_pids'] or status['namespace_pids'][-1] != os.getpid()):
            raise ValueError('Inconsistent self process identity')
        return {'status': 'OBSERVED_HOST_PROCESS_IDENTITY', **before,
                'namespace_pids': status['namespace_pids'], 'pid_namespace': namespace}
    except (OSError, ValueError, IndexError, KeyError) as error:
        return {'status': 'UNAVAILABLE', 'reason': type(error).__name__}


def observe_child_host(namespace_pid, parent):
    """Never treat a namespace-local Popen PID as a host /proc directory."""
    if parent.get('status') != 'OBSERVED_HOST_PROCESS_IDENTITY':
        return {'status': 'UNAVAILABLE', 'reason': 'Parent host identity unavailable'}
    matches = []
    try:
        entries = list(Path('/proc').iterdir())
    except OSError:
        return {'status': 'UNAVAILABLE', 'reason': 'Host proc enumeration unavailable'}
    for entry in entries:
        if not entry.name.isdecimal():
            continue
        try:
            before = proc_identity(entry / 'stat')
            status = proc_status(entry / 'status')
            if (before['host_pid'] != int(entry.name) or status['host_pid'] != before['host_pid'] or
                    before['host_parent_pid'] != parent['host_pid'] or status['host_parent_pid'] != parent['host_pid'] or
                    len(status['namespace_pids']) != len(parent['namespace_pids']) or
                    status['namespace_pids'][-1] != namespace_pid or
                    os.readlink(entry / 'ns/pid') != parent['pid_namespace']):
                continue
            if proc_identity(entry / 'stat') != before:
                continue
            matches.append({'status': 'OBSERVED_HOST_PROCESS_IDENTITY', **before,
                            'namespace_pids': status['namespace_pids'],
                            'pid_namespace': parent['pid_namespace']})
        except (OSError, ValueError, IndexError, KeyError):
            continue
    if len(matches) == 1:
        return matches[0]
    return {'status': 'UNAVAILABLE', 'reason': 'No unique visible child identity',
            'matching_entries': len(matches)}


def run(spec_path, expected_sha):
    spec_path = Path(spec_path)
    raw = spec_path.read_bytes()
    if sha(raw) != expected_sha:
        raise ValueError('Reviewed invocation SHA256 differs')
    spec = json.loads(raw)
    if set(spec) != {'argv', 'cwd', 'out', 'driver_sha256'}:
        raise ValueError('Unexpected invocation schema')
    argv = spec['argv']
    if not isinstance(argv, list) or len(argv) < 2 or not all(isinstance(x, str) for x in argv):
        raise ValueError('Explicit argv required')
    driver = Path(argv[1])
    if sha(driver.read_bytes()) != spec['driver_sha256']:
        raise ValueError('Reviewed driver bytes differ')
    out = Path(spec['out'])
    if not out.is_absolute() or out.resolve() != out or out.exists():
        raise ValueError('A new canonical output directory is required')
    out.mkdir(mode=0o700)
    started = time.monotonic()
    supervisor_host = observe_self_host()
    start = {'status': 'DRIVER_LAUNCH_REQUEST_NOT_ACCEPTANCE', 'utc': utc(),
             'supervisor_namespace_local_pid': os.getpid(),
             'supervisor_host_observation': supervisor_host,
             'boot_id': Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
             'spec_sha256': expected_sha, 'argv': argv, 'cwd': spec['cwd'],
             'driver_sha256': spec['driver_sha256'],
             'supervisor_sha256': sha(Path(__file__).read_bytes()),
             'missing_terminal_record_means': 'UNKNOWN; inspect owned processes and locks before retry'}
    write(out / 'START.json', start)
    log = out / 'DRIVER_STDOUT_STDERR.log'
    with log.open('xb') as stream:
        child = subprocess.Popen(argv, cwd=spec['cwd'], stdin=subprocess.DEVNULL,
                                 stdout=stream, stderr=subprocess.STDOUT, close_fds=True)
        # Optional host identity can be unavailable for a short-lived child.
        # Popen.wait remains the authority for its actual process return.
        child_host = observe_child_host(child.pid, supervisor_host)
        write(out / 'CHILD.json', {'utc': utc(),
              'child_namespace_local_pid': child.pid,
              'child_host_observation': child_host,
              'spec_sha256': expected_sha})
        code = child.wait()
        stream.flush()
        os.fsync(stream.fileno())
    body = log.read_bytes()
    write(out / 'ACTUAL_RETURN.json', {'status': 'ACTUAL_DRIVER_PROCESS_RETURN_NOT_PROOF_ACCEPTANCE',
          'utc': utc(), 'child_namespace_local_pid': child.pid, 'exit_code': code,
          'elapsed_seconds': time.monotonic() - started, 'spec_sha256': expected_sha,
          'stdout_stderr_bytes': len(body), 'stdout_stderr_sha256': sha(body)})
    return code


if __name__ == '__main__':
    raise SystemExit(run(sys.argv[1], sys.argv[2]))
