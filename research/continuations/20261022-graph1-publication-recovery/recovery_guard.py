"""Hold both project locks for an exact, separately reviewed archive recovery.

This program never stages, unstages, commits, pushes, compiles, imports a driver,
refreshes a manifest, or changes the checkout. It writes only new recovery
records in the fixed, separate recovery directory. Those records are excluded
from this exact 394-file archive commit. The old
publication selection, handoff and timed-out OWNER are immutable inputs.

The operator performs every Git mutation as a separate ordinary tool call:
READY -> explicit 25-path unstage -> INDEX_REVIEW.json + PREFLIGHT.json ->
COMMIT_READY -> normal commit/push -> POST_PUSH_RECEIPT.json + RELEASE.json.
The lock window, including verification, is bounded by 240 seconds.
"""
from datetime import datetime, timezone
from pathlib import Path, PurePosixPath
import fcntl
import hashlib
import json
import os
import re
import signal
import subprocess
import sys
import time


R = Path('/Users/tp/Lean/D1Bound5')
C = R / 'research/continuations'
W = C / '20261018T010800CEST-main-continuation'
U = C / '20261020T100000CEST-work-resume'
O = C / '20261022-graph1-closure'
P = C / '20261022-graph1-endpoint-publication'
Q = C / '20261022-graph1-publication-recovery'
HEAD = '7c5c5bb6239da37ce2fe5bdd4e733bd2bbc54311'
OBSERVATION_SHA256 = '7a504cfd7e57d3bab283094cca4a3ba77afdf53d00f3ee88df09b67780064862'
REPOSITORY = 'tomislav-math/d1-bound5-lean'
TOTALS = {'definitions': 32, 'theorems': 64, 'declarations': 96,
          'guarded_builds': 58, 'targeted_same_kernel_replays': 58,
          'analytic_type_axiom_audits': 7}
REMAINING = [3, 4, 5, 6, 7, 8, 10, 14, 15, 19, 21, 23, 24, 28, 30, 36, 39, 43, 46]
COUNTS = {'foundation': (7, 19, 4), 'sides-pilot': (2, 0, 2),
          'left-rest': (12, 0, 15), 'right-rest': (12, 0, 15),
          'closure-pilot': (4, 9, 2), 'closure-rest': (12, 0, 13), 'assembly': (9, 4, 13)}
STOP = False
DEADLINE = None


def check(condition, message):
    if not condition:
        raise RuntimeError(message)


def utc():
    return datetime.now(timezone.utc).isoformat()


def digest(data):
    return hashlib.sha256(data).hexdigest()


def read(path):
    path = Path(path)
    check(path.is_file() and not path.is_symlink(), 'Not a regular file: ' + str(path))
    return path.read_bytes()


def load(path):
    return json.loads(read(path))


def sha(path):
    return digest(read(path))


def fingerprint(value):
    return digest(json.dumps(value, sort_keys=True, separators=(',', ':')).encode())


def relative(value):
    value = str(value)
    path = PurePosixPath(value)
    check(value and not path.is_absolute() and str(path) == value
          and not any(x in ('.', '..', '.git', '__pycache__') for x in path.parts)
          and not any(ord(x) < 32 for x in value), 'Unsafe project path')
    return value


def repo_file(value):
    path = Path(value)
    if not path.is_absolute():
        path = R / relative(value)
    check(path.is_file() and not path.is_symlink()
          and path.resolve().is_relative_to(R.resolve()), 'Not a project file: ' + str(path))
    return path


def unchanged(pins):
    for path, expected in pins.items():
        check(re.fullmatch(r'[0-9a-f]{64}', expected) is not None, 'Malformed SHA-256')
        check(sha(repo_file(path)) == expected, 'Pinned bytes changed: ' + path)


def write_new(path, value):
    data = (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()
    with Path(path).open('xb') as stream:
        stream.write(data)
        stream.flush()
        os.fsync(stream.fileno())


def replace_own_owner(output, value):
    path = output / ('OWNER.tmp.' + str(os.getpid()))
    write_new(path, value)
    os.replace(path, output / 'OWNER.json')


def run_readonly(arguments, data=None):
    timeout = 30 if DEADLINE is None else min(30, DEADLINE - time.monotonic())
    check(timeout > 0, 'Recovery lock window expired')
    result = subprocess.run(arguments, cwd=R, input=data, capture_output=True,
                            timeout=timeout, env={**os.environ, 'GIT_OPTIONAL_LOCKS': '0'})
    check(result.returncode == 0, 'Fixed read-only command failed: ' + arguments[0])
    return result.stdout


def git(*arguments):
    # Every call site below is fixed and read-only; no shell is invoked.
    return run_readonly(['git', *arguments])


def index_entries(raw):
    entries = {}
    for line in raw.split(b'\0'):
        if not line:
            continue
        metadata, name = line.split(b'\t', 1)
        mode, oid, stage = metadata.decode().split()
        path = relative(name.decode())
        check(stage == '0' and path not in entries, 'Nontrivial Git index')
        check(mode in ('100644', '100755') and re.fullmatch(r'[0-9a-f]{40}', oid),
              'Non-regular index entry: ' + path)
        entries[path] = (mode, oid)
    return entries


def index_bytes(entries):
    return b''.join((mode + ' ' + oid + ' 0\t' + path + '\0').encode()
                    for path, (mode, oid) in sorted(entries.items()))


def staged_paths():
    return [relative(path.decode()) for path in git(
        'diff', '--no-ext-diff', '--cached', '--no-renames', '--name-only', '-z', '--'
    ).split(b'\0') if path]


def blob_hashes(entries, paths):
    oids = sorted({entries[path][1] for path in paths})
    data = run_readonly(['git', 'cat-file', '--batch'], ('\n'.join(oids) + '\n').encode())
    offset, hashes = 0, {}
    for oid in oids:
        end = data.index(b'\n', offset)
        header = data[offset:end].decode().split()
        check(len(header) == 3 and header[:2] == [oid, 'blob'], 'Unexpected Git object')
        size = int(header[2])
        check(0 <= size <= 5 * 1024 * 1024, 'Object exceeds reviewed size bound')
        offset = end + 1
        check(offset + size < len(data) and data[offset + size] == 10, 'Truncated Git blob')
        hashes[oid] = digest(data[offset:offset + size])
        offset += size + 1
    check(offset == len(data), 'Unexpected trailing Git data')
    return {path: hashes[entries[path][1]] for path in paths}


def index_unlocked():
    path = Path(git('rev-parse', '--git-path', 'index.lock').decode().strip())
    check(not (path if path.is_absolute() else R / path).exists(), 'Git index writer is active')


def no_writer(old_owner):
    active = load(W / 'continuation-active.json')
    queue = load(W / 'continuation-queue.json')
    check(not active.get('active') and not active.get('protected_closure'), 'Active proof driver')
    check(queue['max_parallel'] == 1 and queue['pause_after_current'] is True, 'Driver is not paused serially')
    processes = run_readonly(['ps', '-axo', 'pid=,comm=']).decode()
    for line in processes.splitlines():
        fields = line.strip().split(None, 1)
        if len(fields) != 2:
            continue
        pid, command = int(fields[0]), Path(fields[1]).name
        check(pid != old_owner['pid'], 'Previous publication owner still exists')
        check(command not in ('lean', 'lake', 'leanchecker'), 'A compiler or replay is active')
    check(old_owner['active'] is False and old_owner['reason'] == 'bounded_timeout',
          'Unexpected old publication ownership')


def verify_endpoint():
    summary = load(O / 'ENDPOINT_VERIFICATION.json')
    state = load(O / 'ENDPOINT_PROOF_STATE.json')
    inventory = load(O / 'ENDPOINT_INVENTORY.json')
    check(summary['status'] == 'GRAPH1_WORKING_ENDPOINT_SCOPED_VERIFIED', 'Endpoint did not pass')
    check(summary['proof_state_sha256'] == sha(O / 'ENDPOINT_PROOF_STATE.json')
          and summary['proof_fingerprint'] == fingerprint(state), 'Endpoint fingerprint changed')
    for item in (summary, state):
        check(item['module'] == 'SmallPairGraphData1' and item['whole_graph1_complete'] is True,
              'Wrong working endpoint')
        check(item['root_integration'] is False and item['main_theorem_complete'] is False,
              'Unexpected integration claim')
        check(item['closure_rows'] == 720 and item['filtered_vertices'] == 718
              and item['module_and_check_totals'] == TOTALS, 'Endpoint totals changed')
    check(state['model'] == {'tau': 0, 'nu': 1}, 'Endpoint model changed')
    check(summary['unique_target_count'] == len(state['targets']) == len(set(state['targets'])) == 58,
          'Endpoint target list changed')
    check(len(state['declaration_names']) == len(set(state['declaration_names'])) == 96,
          'Endpoint declarations changed')
    check(summary['scope_count'] == len(state['scope_evidence']) == 7
          and summary['scope_evidence'] == state['scope_evidence'], 'Endpoint scopes changed')
    unchanged(state['verified_files'])
    unchanged({'D1Bound5/' + name + '.lean': value for name, value in state['verified_sources'].items()})
    unchanged(state['verified_artifacts'])
    unchanged(state['configuration'])
    check(sha(repo_file('D1Bound5.lean')) == state['canonical_root_sha256'], 'Canonical root changed')
    check(digest(json.dumps(state['endpoint_source_closure'], sort_keys=True).encode())
          == state['endpoint_build_fingerprint'], 'Endpoint build fingerprint changed')
    check(summary['source_closure_modules'] == len(state['endpoint_source_closure']), 'Closure count changed')
    check(all(state['verified_sources'].get(name) == value
              for name, value in state['endpoint_source_closure'].items()), 'Endpoint source mismatch')
    check(all(state['verified_artifacts'].get(path) == value
              for path, value in state['endpoint_artifacts'].items()), 'Endpoint artifact mismatch')
    builds = load(W / 'continuation-builds.json')
    baseline = load(W / 'continuation-trusted-baseline.json')
    latest = {(row['name'], row['fingerprint']): row for row in builds}
    found_scopes, all_targets = set(), []
    for path, evidence in state['scope_evidence'].items():
        summary_path = repo_file(path)
        scope = summary_path.name.removesuffix('-VERIFICATION_SUMMARY.json')
        check(scope in COUNTS and scope not in found_scopes, 'Unexpected endpoint scope')
        found_scopes.add(scope)
        folder = summary_path.parent
        audit = U / ('pro-graph1-' + scope + '-audit')
        check(sha(summary_path) == evidence['sha256'], 'Scope summary changed')
        unit = load(summary_path)
        unit_state = load(folder / (scope + '-PROOF_STATE.json'))
        check(unit['status'] == 'SCOPED_VERIFICATION_PASS' and unit['public_headers_exact'] is True,
              'Scope verification did not pass')
        check(unit['proof_fingerprint'] == evidence['proof_fingerprint'] == fingerprint(unit_state),
              'Scope fingerprint changed')
        check(sha(folder / (scope + '-PROOF_STATE.json')) == evidence['proof_state_sha256'],
              'Scope proof-state bytes changed')
        targets = unit['targets']
        count, definitions, theorems = COUNTS[scope]
        check(targets == evidence['targets'] == load(folder / (scope + '-TARGETS.json'))
              and len(targets) == count, 'Scope targets changed')
        check(unit['definitions'] == definitions and unit['theorems'] == theorems
              and unit['declarations'] == definitions + theorems
              and unit['guarded_builds'] == unit['targeted_same_kernel_replays'] == count,
              'Scope totals changed')
        all_targets.extend(targets)
        for name in targets:
            key = unit_state['build_fingerprints'][name]
            expected = unit_state['artifact_fingerprints'][name]
            row = latest.get((name, key))
            if row is not None:
                check(row.get('accepted_build') is True, 'A current build fingerprint is not accepted: ' + name)
            manifest = row.get('artifacts') if row is not None else None
            if not manifest:
                trusted = baseline.get('accepted', {}).get(name, {})
                check(trusted.get('fingerprint') == key, 'No accepted baseline fingerprint: ' + name)
                manifest = trusted.get('artifacts')
            check(manifest and manifest == expected, 'Current accepted artifact evidence changed: ' + name)
            check(all(state['verified_artifacts'].get(path) == value for path, value in manifest.items()),
                  'Accepted target artifacts are outside the verified endpoint state: ' + name)
        final = load(audit / 'BOUND_AUDIT_FINAL.json')
        receipts = load(audit / 'TARGETED_REPLAY_RECEIPTS.json')
        check(sha(audit / 'BOUND_AUDIT_FINAL.json') == evidence['bound_audit_sha256'], 'Audit changed')
        check(final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
              and final['main_theorem_claim'] is False, 'Bound audit did not pass')
        check([row['label'] for row in receipts] == ['analytic-type-axioms']
              + [name + '-targeted-replay' for name in targets], 'Replay list changed')
        check(all(row['exit'] == 0 and row['timed_out'] is False and row['guards_unchanged'] is True
                  and not row['binding_drift_paths'] for row in receipts), 'Audit or replay failed')
        check(load(audit / 'active-targeted-replay.json')['active'] is False, 'Replay is active')
        check(sha(audit / 'PREPARATION_BINDINGS.json') == evidence['binding_sha256']
              == final['binding_sha256'], 'Audit binding changed')
    check(found_scopes == set(COUNTS) and len(all_targets) == len(set(all_targets)) == 58
          and set(all_targets) == set(state['targets']), 'Scope union changed')
    check(inventory['status'] == 'CURRENT_WORKING_ENDPOINT_INVENTORY_AFTER_GRAPH1_PASS'
          and inventory['expected_transition_matches'] is True, 'Inventory transition did not pass')
    check(inventory['accepted_endpoint_count'] == 29 and inventory['total_endpoints'] == 48
          and inventory['remaining_endpoints'] == REMAINING
          and inventory['added_endpoints'] == [1] and inventory['removed_endpoints'] == [],
          'Working endpoint inventory changed')
    check(inventory['graph1_endpoint_summary_sha256'] == sha(O / 'ENDPOINT_VERIFICATION.json')
          and inventory['graph1_endpoint_proof_state_sha256'] == sha(O / 'ENDPOINT_PROOF_STATE.json')
          and inventory['graph1_endpoint_proof_fingerprint'] == summary['proof_fingerprint'],
          'Inventory does not bind this endpoint')
    return summary['proof_fingerprint']


def exact_archive_index(expected_entries, archive_pins):
    index_unlocked()
    before = git('ls-files', '--stage', '-z')
    check(index_entries(before) == expected_entries, 'Index differs from the exact repaired snapshot')
    check(set(staged_paths()) == set(archive_pins), 'Staged paths differ from the original 394-file archive')
    check(blob_hashes(expected_entries, archive_pins) == archive_pins, 'Staged archive bytes changed')
    unchanged(archive_pins)
    check(git('ls-files', '--stage', '-z') == before, 'Index changed during review')
    index_unlocked()
    return digest(before)


def check_review_records(expected_entries, archive_pins):
    review = load(Q / 'INDEX_REVIEW.json')
    preflight = load(Q / 'PREFLIGHT.json')
    check(review['status'] == 'INDEX_REVIEW_PASS' and review['read_only'] is True,
          'Exact-index helper has not passed')
    check(review['repository'] == REPOSITORY and review['visibility'] == 'PRIVATE'
          and review['head'] == HEAD, 'Wrong exact-index review destination')
    check(set(review['staged_paths']) == set(archive_pins) and len(review['staged_paths']) == 394,
          'Exact-index helper reviewed another path set')
    check(review['index_fingerprint'] == digest(index_bytes(expected_entries)), 'Helper reviewed another index')
    check(preflight['status'] == 'PREFLIGHT_PASS_REVIEW_STILL_REQUIRED'
          and preflight['repository'] == REPOSITORY and preflight['visibility'] == 'PRIVATE'
          and preflight['local_head'] == preflight['remote_head'] == HEAD
          and preflight['staged_count'] == 394, 'Private preflight has not passed for this archive')
    check(git('rev-parse', 'HEAD').decode().strip() == HEAD, 'HEAD changed before commit review')
    exact_archive_index(expected_entries, archive_pins)


def check_publication(expected_entries, archive_pins):
    release = load(Q / 'RELEASE.json')
    check(release['status'] == 'RELEASE_RECOVERY_AFTER_PRIVATE_PUSH', 'Unexpected recovery release')
    check(release['post_push_receipt_sha256'] == sha(Q / 'POST_PUSH_RECEIPT.json'),
          'Release does not bind the actual post-push receipt')
    receipt = load(Q / 'POST_PUSH_RECEIPT.json')
    check(receipt['status'] == 'PRIVATE_PUSH_VERIFIED' and receipt['repository'] == REPOSITORY
          and receipt['visibility'] == 'PRIVATE' and receipt['commit_exit'] == receipt['push_exit'] == 0,
          'Ordinary private publication has not been verified')
    head = git('rev-parse', 'HEAD').decode().strip()
    check(re.fullmatch(r'[0-9a-f]{40}', head) and head != HEAD
          and receipt['local_head'] == receipt['remote_head'] == head, 'Post-push HEAD mismatch')
    check(git('rev-list', '--parents', '-n', '1', head).decode().split() == [head, HEAD],
          'Recovery did not produce one ordinary child commit')
    check(receipt['selected_committed_blobs_match'] is True and receipt['selected_files'] == 394
          and receipt['staged_count'] == 0 and receipt['main_theorem_complete'] is False
          and receipt['root_integration'] is False, 'Post-push scope changed')
    changed = {path.decode() for path in git('diff', '--no-ext-diff', '--no-renames', '--name-only',
                                           '-z', HEAD, head, '--').split(b'\0') if path}
    check(changed == set(archive_pins), 'Commit includes paths outside the original archive')
    index_unlocked()
    check(index_entries(git('ls-files', '--stage', '-z')) == expected_entries and not staged_paths(),
          'Post-commit index is not the exact reviewed archive tree')
    check(blob_hashes(expected_entries, archive_pins) == archive_pins, 'Committed archive bytes changed')
    check(git('rev-parse', 'refs/remotes/origin/main').decode().strip() == head,
          'Local remote-tracking main does not match the actual push receipt')
    return head


def main():
    global DEADLINE
    check(len(sys.argv) == 1 and Path(__file__).resolve() == Q / 'recovery_guard.py', 'Wrong invocation')
    check(Q.is_dir() and not Q.is_symlink() and Q.resolve().is_relative_to(R.resolve()),
          'Unexpected recovery directory')
    check({path.name for path in Q.iterdir()} == {'ACTUAL_INDEX_OBSERVATION.json', 'recovery_guard.py'},
          'Unexpected pre-existing recovery outputs; review them separately')
    observation_path = Q / 'ACTUAL_INDEX_OBSERVATION.json'
    check(sha(observation_path) == OBSERVATION_SHA256, 'Actual observation bytes changed')
    observed = load(observation_path)
    check(observed['schema'] == 1 and observed['status'] == 'ACTUAL_READ_ONLY_INDEX_OBSERVATION'
          and observed['head'] == HEAD and observed['index_count'] == 419
          and observed['archive_count'] == 394, 'Unexpected original observation')
    extras = observed['extra_canonical_paths']
    original_pins = observed['staged_path_sha256']
    check(len(extras) == len(set(extras)) == 25 and len(original_pins) == 419, 'Unexpected recovery scope')
    check(all(path.startswith('D1Bound5/') and path.endswith('.lean') for path in extras),
          'Recovery extras are not canonical graph sources')
    locks = [W / 'continuation-driver.lock', W / 'continuation-intake.lock']
    for lock in locks:
        repo_file(lock)
    owner = None
    with locks[0].open('r+') as driver_lock, locks[1].open('r+') as intake_lock:
        for lock in (driver_lock, intake_lock):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        DEADLINE = time.monotonic() + 240
        signal.signal(signal.SIGALRM, expired)
        signal.alarm(240)
        try:
            unchanged(observed['pins'])
            old_owner = load(P / 'OWNER.json')
            no_writer(old_owner)
            check(git('rev-parse', '--show-toplevel').decode().strip() == str(R)
                  and git('branch', '--show-current').decode().strip() == 'main'
                  and git('rev-parse', 'HEAD').decode().strip() == HEAD, 'Project HEAD or branch changed')
            index_unlocked()
            raw_index = git('ls-files', '--stage', '-z')
            check(digest(raw_index) == observed['index_entries_sha256'], 'Original index snapshot changed')
            entries = index_entries(raw_index)
            check(index_bytes(entries) == raw_index, 'Index serialization changed')
            check(set(staged_paths()) == set(original_pins), 'Original staged paths changed')
            check(blob_hashes(entries, original_pins) == original_pins, 'Original staged bytes changed')
            unchanged(original_pins)
            selection = load(P / 'SELECTED_FILES_SHA256.json')
            archive_paths = read(P / 'STAGING_PATHS.txt').decode().splitlines()
            manifest_paths = {str((P / name).relative_to(R)) for name in
                              ('SELECTED_FILES_SHA256.json', 'STAGING_PATHS.txt')}
            check(len(selection) == 392 and len(archive_paths) == len(set(archive_paths)) == 394
                  and set(archive_paths) == set(selection) | manifest_paths, 'Original selection changed')
            check(all(path.startswith(('research/', 'records/')) for path in archive_paths)
                  and not any(path.startswith(str(Q.relative_to(R)) + '/') for path in archive_paths),
                  'The reviewed archive includes canonical or recovery files')
            check(set(original_pins) == set(archive_paths) | set(extras)
                  and not set(archive_paths) & set(extras), 'Index mismatch is not exactly the 25 extras')
            archive_pins = {path: original_pins[path] for path in archive_paths}
            check(all(archive_pins[path] == value for path, value in selection.items()),
                  'Selection fingerprints differ from indexed archive bytes')
            tree_paths = {line.split(b'\t', 1)[1].decode() for line in
                          git('ls-tree', '-r', '-z', HEAD).split(b'\0') if line}
            check(not set(extras) & tree_paths, 'A canonical extra already exists in HEAD')
            snapshot_pins = {}
            for path in extras:
                name = Path(path).name
                snapshot = str((O / name).relative_to(R))
                candidate = str((O / 'candidates' / name).relative_to(R))
                check(snapshot in archive_pins and candidate in archive_pins
                      and archive_pins[snapshot] == archive_pins[candidate] == original_pins[path],
                      'A canonical source lacks both exact archived copies: ' + path)
                snapshot_pins.update({snapshot: original_pins[path], candidate: original_pins[path]})
            unchanged(snapshot_pins)
            proof_fingerprint = verify_endpoint()
            control = {str(path.relative_to(R)): sha(path) for path in
                       (W / 'continuation-builds.json', W / 'continuation-trusted-baseline.json')}
            fixed = {**observed['pins'], **original_pins, **control,
                     str(observation_path.relative_to(R)): OBSERVATION_SHA256,
                     str(Path(__file__).resolve().relative_to(R)): sha(Path(__file__))}
            unchanged(fixed)
            check(git('ls-files', '--stage', '-z') == raw_index, 'Original index drifted during review')
            expected_entries = {path: value for path, value in entries.items() if path not in extras}
            expected_sha = digest(index_bytes(expected_entries))
            with (Q / 'UNSTAGE_PATHS.txt').open('x') as stream:
                stream.write('\n'.join(extras) + '\n')
            owner = {'active': True, 'pid': os.getpid(), 'parent_pid': os.getppid(), 'utc': utc(),
                     'timeout_seconds': 240, 'observation_sha256': OBSERVATION_SHA256,
                     'original_index_sha256': digest(raw_index), 'repaired_index_sha256': expected_sha,
                     'archive_paths': 394, 'extra_index_paths': 25, 'git_mutations': [],
                     'purpose': 'Retain the exact reviewed research archive; preserve canonical working bytes.',
                     'main_theorem_complete': False, 'root_integration': False}
            write_new(Q / 'OWNER.json', owner)
            ready = {**owner, 'status': 'READY_FOR_SEPARATE_EXACT_UNSTAGE',
                     'script_sha256': sha(Path(__file__)), 'proof_fingerprint': proof_fingerprint,
                     'old_owner_sha256': sha(P / 'OWNER.json'), 'unstage_paths': extras,
                     'required_next_records': ['INDEX_REVIEW.json', 'PREFLIGHT.json']}
            write_new(Q / 'READY.json', ready)
            print(json.dumps(ready), flush=True)
            commit_ready = False
            while not STOP and time.monotonic() < DEADLINE:
                if not commit_ready and (Q / 'INDEX_REVIEW.json').exists() and (Q / 'PREFLIGHT.json').exists():
                    check_review_records(expected_entries, archive_pins)
                    unchanged(fixed)
                    no_writer(old_owner)
                    record = {'status': 'COMMIT_READY_EXACT_RESEARCH_ARCHIVE', 'utc': utc(),
                              'head': HEAD, 'staged_files': 394, 'index_fingerprint': expected_sha,
                              'index_review_sha256': sha(Q / 'INDEX_REVIEW.json'),
                              'preflight_sha256': sha(Q / 'PREFLIGHT.json'), 'git_mutations': [],
                              'main_theorem_complete': False, 'root_integration': False}
                    write_new(Q / 'COMMIT_READY.json', record)
                    commit_ready = True
                    print(json.dumps(record), flush=True)
                if (Q / 'RELEASE.json').exists():
                    check(commit_ready, 'Release requested before repaired-index review')
                    head = check_publication(expected_entries, archive_pins)
                    unchanged(fixed)
                    check(verify_endpoint() == proof_fingerprint, 'Endpoint evidence changed during publication')
                    no_writer(old_owner)
                    check(git('rev-parse', 'HEAD').decode().strip() == head
                          and index_entries(git('ls-files', '--stage', '-z')) == expected_entries
                          and not staged_paths(), 'Publication changed during final preservation review')
                    result = {'status': 'RECOVERY_COMPLETED_MATCHING_PRIVATE_PUSH_RECORD', 'utc': utc(),
                              'head': head, 'archived_files': 394, 'canonical_files_preserved': 25,
                              'old_publication_owner_unchanged': True, 'proof_manifests_unchanged': True,
                              'proof_fingerprint': proof_fingerprint, 'git_mutations': [],
                              'remote_verification_basis': 'Separate actual root-produced POST_PUSH_RECEIPT.json',
                              'main_theorem_complete': False, 'root_integration': False}
                    write_new(Q / 'FINISH.json', result)
                    owner.update(reason='released_after_verified_archive_publication', head=head)
                    print(json.dumps(result), flush=True)
                    return
                time.sleep(min(0.25, max(0, DEADLINE - time.monotonic())))
            raise RuntimeError('Recovery stopped or reached its 240-second bound; no completion is claimed')
        except Exception as error:
            if owner is not None:
                owner.update(reason='failed_or_interrupted', detail=str(error))
            print(json.dumps({'status': 'RECOVERY_STOPPED_NO_GIT_MUTATION', 'detail': str(error)}), flush=True)
            raise
        finally:
            signal.alarm(0)
            if owner is not None:
                owner.update(active=False, finished_utc=utc())
                replace_own_owner(Q, owner)


def halt(*_):
    global STOP
    STOP = True


def expired(*_):
    raise RuntimeError('The 240-second recovery lock window expired')


if __name__ == '__main__':
    for number in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP):
        signal.signal(number, halt)
    main()
