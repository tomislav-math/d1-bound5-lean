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
    start = {'status': 'DRIVER_LAUNCH_REQUEST_NOT_ACCEPTANCE', 'utc': utc(),
             'supervisor_pid': os.getpid(),
             'supervisor_proc_start_ticks': Path('/proc/self/stat').read_text().split()[21],
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
        try:
            child_start_ticks = Path('/proc', str(child.pid), 'stat').read_text().split()[21]
        except (OSError, IndexError):
            # A short-lived child can disappear before this optional observation.
            # Popen.wait remains the authority for its actual process return.
            child_start_ticks = None
        write(out / 'CHILD.json', {'utc': utc(), 'pid': child.pid,
              'proc_start_ticks': child_start_ticks,
              'spec_sha256': expected_sha})
        code = child.wait()
        stream.flush()
        os.fsync(stream.fileno())
    body = log.read_bytes()
    write(out / 'ACTUAL_RETURN.json', {'status': 'ACTUAL_DRIVER_PROCESS_RETURN_NOT_PROOF_ACCEPTANCE',
          'utc': utc(), 'child_pid': child.pid, 'exit_code': code,
          'elapsed_seconds': time.monotonic() - started, 'spec_sha256': expected_sha,
          'stdout_stderr_bytes': len(body), 'stdout_stderr_sha256': sha(body)})
    return code


if __name__ == '__main__':
    raise SystemExit(run(sys.argv[1], sys.argv[2]))
