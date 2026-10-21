"""Opt-in two-slot continuation verifier; never imports mathematical code.

Intakes MUST hold continuation-intake.lock and reject changes to the complete
`protected_closure` union in continuation-active.json. See the companion review.
No existing driver, compiler, queue or remote file is changed by importing this.
"""
from __future__ import annotations
from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path
import argparse
import datetime as dt
import fcntl
import hashlib
import json
import os
import re
import signal
import subprocess
import time

IMPORT_LINE = re.compile(rb'^\s*import\s+([^\n]+)', re.M)
IMPORT_NAME = re.compile(rb'\bD1Bound5\.([A-Za-z0-9_.]+)')
VALID_NAME = re.compile(r'^[A-Za-z0-9_]+$')


def utc():
    return dt.datetime.now(dt.timezone.utc).isoformat()


def sha(data):
    return hashlib.sha256(data).hexdigest()


def fingerprint(closure):
    return sha(json.dumps(closure, sort_keys=True).encode())


def atomic_json(path, value):
    temp = path.with_name(path.name + '.tmp.' + str(os.getpid()))
    with temp.open('w') as stream:
        json.dump(value, stream, indent=2, sort_keys=True)
        stream.flush()
        os.fsync(stream.fileno())
    os.replace(temp, path)


@dataclass
class Job:
    name: str
    closure: dict
    key: str
    protected_artifacts: dict
    process: subprocess.Popen
    stream: object
    log: Path
    started: float
    started_utc: str
    timeout: float
    term_at: float | None = None
    timed_out: bool = False
    interrupted: bool = False


class Driver:
    def __init__(self, root, run, command=None):
        self.root, self.run = Path(root), Path(run)
        self.queue_path = self.run / 'continuation-queue.json'
        self.state_path = self.run / 'continuation-builds.json'
        self.active_path = self.run / 'continuation-active.json'
        self.baseline_path = self.run / 'continuation-trusted-baseline.json'
        self.lock_path = self.run / 'continuation-intake.lock'
        self.logs = self.run / 'continuation-builds'
        self.command = command or ['/Users/tp/.elan/bin/lake', 'build', 'D1Bound5.{name}']
        self.rows = json.loads(self.state_path.read_text()) if self.state_path.exists() else []
        self.baseline = json.loads(self.baseline_path.read_text()) if self.baseline_path.exists() else {}
        self.jobs = {}
        self.artifact_hash_cache = {}
        self.stop = False
        self.static = {str(p.relative_to(self.root)): sha(p.read_bytes()) for p in
                       (self.root / 'lean-toolchain', self.root / 'lake-manifest.json',
                        self.root / 'lakefile.lean', self.root / 'lakefile.toml') if p.exists()}

    @contextmanager
    def locked(self):
        self.run.mkdir(parents=True, exist_ok=True)
        with self.lock_path.open('a+') as lock:
            fcntl.flock(lock, fcntl.LOCK_EX)
            try:
                yield
            finally:
                fcntl.flock(lock, fcntl.LOCK_UN)

    def closure(self, name, seen=None, source_cache=None):
        if not VALID_NAME.fullmatch(name):
            raise ValueError('Invalid module name: ' + repr(name))
        seen = {} if seen is None else seen
        if name in seen:
            return seen
        # Shared only within one scheduling snapshot. Launch and completion
        # omit this argument and therefore read/hash a fresh source closure.
        source_cache = {} if source_cache is None else source_cache
        if name not in source_cache:
            data = (self.root / 'D1Bound5' / (name + '.lean')).read_bytes()
            deps = []
            for line in IMPORT_LINE.findall(data):
                names = IMPORT_NAME.findall(line.split(b'--', 1)[0])
                if b'D1Bound5' in line.split(b'--', 1)[0] and not names:
                    raise ValueError('Unsupported D1 import syntax in ' + name)
                deps.extend(dep.decode() for dep in names)
            source_cache[name] = (sha(data), deps)
        digest, deps = source_cache[name]
        seen[name] = digest
        for dep in deps:
            self.closure(dep, seen, source_cache)
        return seen

    def artifacts(self, name):
        found = {}
        for folder in (self.root / '.lake/build/lib/lean/D1Bound5',
                       self.root / '.lake/build/ir/D1Bound5'):
            for path in folder.glob(name + '.*'):
                if path.is_file():
                    found[str(path.relative_to(self.root))] = sha(path.read_bytes())
        return found

    def manifest_matches(self, manifest, cached=False):
        for name, expected in manifest.items():
            path = self.root / name
            try:
                st = path.stat()
                key = (st.st_dev, st.st_ino, st.st_size, st.st_mtime_ns, st.st_ctime_ns)
            except FileNotFoundError:
                return False
            old = self.artifact_hash_cache.get(name)
            if cached and old is not None and old[0] == key:
                digest = old[1]
            else:
                digest = sha(path.read_bytes())
                self.artifact_hash_cache[name] = (key, digest)
            if digest != expected:
                return False
        return True

    def latest(self):
        return {(row['name'], row['fingerprint']): row for row in self.rows}

    def expected_manifest(self, name, key, latest):
        """Return trusted bytes, never a manifest inferred from current files."""
        row = latest.get((name, key))
        # A failure at this fingerprint cannot be overridden by baseline trust.
        if row is not None:
            if not row.get('accepted_build', False):
                return None
            manifest = row.get('artifacts')
            if manifest:
                return manifest
        trusted = self.baseline.get('accepted', {}).get(name, {})
        if trusted.get('fingerprint') == key and trusted.get('artifacts'):
            return trusted['artifacts']
        return None

    def accepted(self, name, closures, latest):
        manifest = self.expected_manifest(name, fingerprint(closures[name]), latest)
        return manifest is not None and self.manifest_matches(manifest, cached=True)

    def write_active(self):
        protected = {}
        active = []
        for job in self.jobs.values():
            for module, digest in job.closure.items():
                if module in protected and protected[module] != digest:
                    raise RuntimeError('Active closure hash disagreement: ' + module)
                protected[module] = digest
            active.append({'name': job.name, 'fingerprint': job.key,
                           'closure': job.closure, 'pid': job.process.pid,
                           'pgid': job.process.pid, 'started_utc': job.started_utc,
                           'log': str(job.log), 'timeout_seconds': job.timeout})
        atomic_json(self.active_path, {'status': 'BUILDING' if active else 'BETWEEN_BUILDS',
                    'active': active, 'protected_closure': protected,
                    # Alias preserves old intake readers that check `closure`.
                    'closure': protected, 'immutable_inputs': self.static, 'utc': utc()})

    def snapshot(self):
        queue = json.loads(self.queue_path.read_text())
        names = list(dict.fromkeys(queue['names']))
        source_cache = {}
        closures = {name: self.closure(name, source_cache=source_cache) for name in names}
        all_names = set().union(*(set(c) for c in closures.values())) if closures else set()
        for name in all_names:
            if name not in closures:
                closures[name] = self.closure(name, source_cache=source_cache)
        latest = self.latest()
        accepted = {name for name in all_names if self.accepted(name, closures, latest)}
        blocked = set(queue.get('blocked_modules', []))
        unknown = sorted(all_names - set(names) - accepted)
        eligible = []
        for name in names:
            key = fingerprint(closures[name])
            if name in self.jobs or name in accepted or (name, key) in latest:
                continue
            closure_names = set(closures[name])
            if closure_names & blocked:
                continue
            # Every D1 dependency must already have current accepted artifacts.
            # Therefore Lake can never implicitly compile an unaccepted/held dep.
            if (closure_names - {name}) - accepted:
                continue
            uncompiled = closure_names - accepted
            if any(uncompiled & (set(j.closure) - accepted) for j in self.jobs.values()):
                continue
            eligible.append(name)
        return queue, names, closures, accepted, unknown, eligible

    def launch(self, name, closure, timeout):
        # Scheduling may use metadata-cached hashes. Launch must compare its
        # fresh dependency-byte snapshot against previously accepted bytes;
        # it must never adopt changed files as a new immutable baseline.
        frozen = {}
        latest = self.latest()
        for dep in set(closure) - {name}:
            dep_closure = self.closure(dep)
            expected = self.expected_manifest(dep, fingerprint(dep_closure), latest)
            actual = self.artifacts(dep)
            if (any(closure.get(module) != digest for module, digest in dep_closure.items())
                    or not expected
                    or actual != expected):
                self.stop = True
                print(json.dumps({'status': 'LAUNCH_DEPENDENCY_REVALIDATION_FAILED',
                                  'name': name, 'dependency': dep, 'utc': utc()}), flush=True)
                return False
            frozen.update(actual)
        self.logs.mkdir(parents=True, exist_ok=True)
        stem = name + '-' + dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
        log = self.logs / (stem + '.log')
        atomic_json(self.logs / (stem + '.sources.json'), closure)
        (self.logs / (stem + '.lean')).write_bytes((self.root / 'D1Bound5' / (name + '.lean')).read_bytes())
        stream = log.open('w')
        try:
            process = subprocess.Popen([arg.format(name=name) for arg in self.command],
                cwd=self.root, stdout=stream, stderr=subprocess.STDOUT, start_new_session=True)
        except BaseException:
            stream.close()
            raise
        self.jobs[name] = Job(name, closure, fingerprint(closure), frozen, process, stream,
                              log, time.monotonic(), utc(), timeout)
        self.write_active()  # still under intake lock: no unprotected launch interval
        print(json.dumps({'status': 'BUILDING', 'name': name, 'pid': process.pid, 'utc': utc()}), flush=True)
        return True

    def terminate(self, job, timed_out=False):
        if job.term_at is None:
            job.timed_out = timed_out
            job.interrupted = not timed_out
            job.term_at = time.monotonic()
            try:
                os.killpg(job.process.pid, signal.SIGTERM)
            except ProcessLookupError:
                pass
        elif time.monotonic() - job.term_at > 10:
            try:
                os.killpg(job.process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass

    def reap(self):
        for name, job in list(self.jobs.items()):
            if job.process.poll() is None:
                if self.stop or job.term_at is not None:
                    self.terminate(job, timed_out=job.timed_out)
                elif time.monotonic() - job.started > job.timeout:
                    self.terminate(job, timed_out=True)
                continue
            job.stream.close()
            try:
                unchanged = self.closure(name) == job.closure
            except (OSError, ValueError):
                unchanged = False
            immutable = self.manifest_matches(job.protected_artifacts) and self.manifest_matches(self.static)
            artifacts = self.artifacts(name)
            has_olean = '.lake/build/lib/lean/D1Bound5/' + name + '.olean' in artifacts
            row = {'name': name, 'fingerprint': job.key, 'source_sha256': job.closure[name],
                   'exit': job.process.returncode, 'closure_unchanged': unchanged,
                   'shared_artifacts_unchanged': immutable, 'timed_out': job.timed_out,
                   'interrupted': job.interrupted, 'timeout_seconds': job.timeout,
                   'accepted_build': job.process.returncode == 0 and unchanged and immutable
                                     and has_olean and not job.timed_out and not job.interrupted,
                   'artifacts': artifacts, 'seconds': time.monotonic() - job.started,
                   'utc': utc(), 'log': str(job.log)}
            self.rows.append(row)
            atomic_json(self.state_path, self.rows)
            del self.jobs[name]
            self.write_active()
            print(json.dumps(row), flush=True)
            if not immutable:
                self.stop = True
                print(json.dumps({'status': 'IMMUTABLE_INPUT_CHANGED_STOPPING', 'name': name}), flush=True)

    def run_loop(self, execute=False, poll_seconds=2.0, *, defer_busy_snapshot=False):
        self.logs.mkdir(parents=True, exist_ok=True)
        while True:
            with self.locked():
                self.reap()
                defer_snapshot = False
                if execute and defer_busy_snapshot and self.jobs:
                    queue = json.loads(self.queue_path.read_text())
                    slots = min(2, max(1, int(queue.get('max_parallel', 2))))
                    defer_snapshot = len(self.jobs) >= slots
                if not defer_snapshot:
                    queue, names, closures, accepted, unknown, eligible = self.snapshot()
                if not self.manifest_matches(self.static):
                    self.stop = True
                pause = queue.get('pause_after_current', False) or self.stop
                if not execute:
                    print(json.dumps({'status': 'DRY_RUN', 'eligible': eligible,
                        'untracked_nonqueued': unknown, 'accepted_count': len(accepted)}), flush=True)
                    return
                slots = min(2, max(1, int(queue.get('max_parallel', 2))))
                if not defer_snapshot and not pause and not unknown:
                    for name in eligible[:max(0, slots - len(self.jobs))]:
                        timeout = queue.get('target_timeout_seconds', {}).get(name, queue.get('default_timeout_seconds', 600))
                        if not isinstance(timeout, (int, float)) or timeout <= 0:
                            raise ValueError('Timeout must be positive')
                        if not self.launch(name, closures[name], timeout):
                            break
                if not self.jobs:
                    self.write_active()
                    print(json.dumps({'status': 'PAUSED' if pause else 'NO_ELIGIBLE_TARGET',
                        'untracked_nonqueued': unknown,
                        'unresolved': [n for n in names if n not in accepted], 'utc': utc()}), flush=True)
                    return
            time.sleep(poll_seconds)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=Path('/Users/tp/Lean/D1Bound5'))
    parser.add_argument('--run', type=Path)
    parser.add_argument('--execute', action='store_true', help='Opt in to actual Lake builds after parent review')
    parser.add_argument('--defer-busy-snapshot', action='store_true',
                        help='Skip full scheduling snapshots only while all slots are occupied')
    args = parser.parse_args()
    run = args.run or args.root / 'research/continuations/20261018T010800CEST-main-continuation'
    driver = Driver(args.root, run)
    def stop(_signum, _frame):
        driver.stop = True
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    driver.run.mkdir(parents=True, exist_ok=True)
    # This prevents two copies of this driver. The old serial driver must
    # still be stopped explicitly, because it does not implement this lock.
    with (driver.run / 'continuation-driver.lock').open('a+') as owner:
        fcntl.flock(owner, fcntl.LOCK_EX | fcntl.LOCK_NB)
        try:
            driver.run_loop(args.execute, defer_busy_snapshot=args.defer_busy_snapshot)
        finally:
            for job in driver.jobs.values():
                driver.terminate(job)
            while driver.jobs:
                with driver.locked():
                    driver.reap()
                time.sleep(0.1)


if __name__ == '__main__':
    main()
