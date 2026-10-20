"""Prepare an isolated finite13 evidence checkpoint AFTER the full bound audit PASS.

Default mode only reviews the exact proposal; --prepare writes a new package.
Never stages, commits, pushes, imports the compiler driver, or runs Lean.
The 547 inherited staged entries and their content boundary remain untouched.
"""
from pathlib import Path
from datetime import datetime, timezone
from collections import defaultdict
import argparse
import hashlib
import json
import os
import re
import subprocess

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT / 'research/continuations/20261020T100000CEST-work-resume'
DEST = RUN / 'finite-one-small-checkpoint'
HEAD = 'ea18e9a9bf036d65835e646da3a9f9a517d0bb0d'
ORIGINAL_INDEX_SHA = 'bc8eb2096ff68daebaaf3ae8a9700f82d0ab6f894abb5f7428e6cc9380411453'
FULL_INDEX_SHA = '3ca3d3e793b4b1474f1780554a6748f866c8f45806fef51260d53925b8e2268f'
OLD_COMMITTED_PACKAGES = ('research/continuations/20261020T100000CEST-work-resume/initial-five-checkpoint/',
                          'research/continuations/20261020T100000CEST-work-resume/seven-scoped-checkpoint/')
AUDITS = [{'folder': 'finite-one-small-audit-v1', 'label': 'finite13', 'targets': ['OneSmallThirdData', 'OneSmallFourthData1', 'OneSmallFourthData2', 'OneSmallFourthData3', 'OneSmallFourthData4', 'OneSmallFourthData5', 'OneSmallFourthData6', 'OneSmallFourthData7', 'OneSmallRows', 'OneSmallRowMetadata', 'OneSmallSymmetry', 'OneSmallOrbitRows', 'OneSmallFullRingFinite'], 'audit_sha': 'ddedf730228eee1c0b10957bedb7228a8a73cfcd9a00a53fd0f243c5a999c3b8', 'binding_sha': 'fee8c46feeb73fe16256a694b50a4a64d37ca5841db1ff98f7531a27c8466c0c', 'map_sha': '15a58bc888e80b5e35513994cfcd218579ff23f97d94459a682bec305b473ca4', 'declarations': 501, 'examples': 252, 'structure_examples': 14}]
NAMES = [n for audit in AUDITS for n in audit['targets']]
NEW_SOURCE_SHA = {'FirstPairClassification': '7439f45210b59f019ad649fd7de039e4dd3225058c8cf127213409e314835de7', 'OneSmallRows': '5d9e96e3d46ca1e91403fd677ac916a5fa55d59330a9fc532fee6467ec77e849'}
TOOL_SHA = {'scoped_audit_helper_finite_one_small_proposal_v3.py': '130497619e9ad1619a65a5bedb89a89fbd4bcf688e32039a8cf69a33ffb6c3c1', 'bound_scoped_audit_runner_proposal_v1.py': 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'}
FINAL_SHA = {'BOUND_AUDIT_FINAL.json': 'a81389abf225e9a9206b4acb03322046286986db6f8953151015f982997dd2de', 'TARGETED_REPLAY_RECEIPTS.json': '4ef1b45a3c88d9051ee54cb87f1277d83db293c707cf9ec3c43ebd241cca86f1', 'TARGETED_REPLAY_GUARDS.json': 'b40922dfaa425db88cdd2eb09808d08e34460988f61dc81692004b78c7445dea'}
SECRET_PATTERNS = [r'gh[pousr]_[A-Za-z0-9]{20,}', r'github_pat_[A-Za-z0-9_]{30,}',
    r'-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----', r'sk-(?:proj-)?[A-Za-z0-9_-]{28,}',
    r'(?i)Bearer\s+[A-Za-z0-9_.-]{30,}', r'(?i)https?://[^\s/:]+:[^\s/@]+@']


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def blob(data):
    return hashlib.sha1(b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest()


def jsonbytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()


def git(*args, data=None):
    return subprocess.check_output(['git', *args], cwd=ROOT, input=data,
        env={**os.environ, 'GIT_OPTIONAL_LOCKS': '0'}, timeout=30)


def original_index_hash(index):
    filtered = [item for item in index.split(b'\0') if item and not any(item.split(b'\t', 1)[1].decode().startswith(prefix) for prefix in OLD_COMMITTED_PACKAGES)]
    return sha(b'\0'.join(filtered) + b'\0')


def merge_exact(dest, source, label):
    for key, value in source.items():
        require(key not in dest or dest[key] == value, 'Conflicting exact guard: ' + label + ':' + key)
        dest[key] = value


def validate_receipts(spec, final, records, active, out):
    expected_labels = ['analytic-type-axioms'] + [n + '-targeted-replay' for n in spec['targets']]
    require(final.get('status') == 'BOUND_SCOPED_AUDIT_PASS' and final.get('main_theorem_claim') is False,
            'Actual final bound-audit PASS required: ' + spec['folder'])
    require(final.get('binding_sha256') == spec['binding_sha'] and final.get('source_map_sha256') == spec['map_sha'],
            'Final receipt does not bind the reviewed preparation')
    require(final.get('records') == records and [r['label'] for r in records] == expected_labels,
            'Missing, duplicate, reordered or inconsistent final replay receipts')
    require(active.get('active') is False and active.get('last') == records[-1], 'Audit is active/incomplete')
    for i, rec in enumerate(records):
        require(rec.get('exit') == 0 and rec.get('timed_out') is False and rec.get('guards_unchanged') is True
                and rec.get('binding_drift_paths') == [], 'An audit/replay did not pass guarded checks')
        expected = ['/Users/tp/.elan/bin/lake', 'env', 'lean', str(out / 'AnalyticAudit.lean')] if i == 0 else [
            '/Users/tp/.elan/bin/lake', 'env', 'leanchecker', '--verbose', 'D1Bound5.' + spec['targets'][i-1]]
        require(rec.get('command') == expected and rec.get('log') == rec['label'] + '.log', 'Unexpected recorded audit command/log')


def self_test():
    """Synthetic receipt validator tests only: no I/O, Git or compiler."""
    from copy import deepcopy
    spec = AUDITS[0]
    out = RUN / spec['folder']
    records = []
    for i, label in enumerate(['analytic-type-axioms'] + [n + '-targeted-replay' for n in spec['targets']]):
        command = ['/Users/tp/.elan/bin/lake', 'env', 'lean', str(out / 'AnalyticAudit.lean')] if i == 0 else [
            '/Users/tp/.elan/bin/lake', 'env', 'leanchecker', '--verbose', 'D1Bound5.' + spec['targets'][i-1]]
        records.append({'label': label, 'command': command, 'log': label + '.log', 'exit': 0,
                        'timed_out': False, 'guards_unchanged': True, 'binding_drift_paths': []})
    final = {'status': 'BOUND_SCOPED_AUDIT_PASS', 'main_theorem_claim': False,
             'binding_sha256': spec['binding_sha'], 'source_map_sha256': spec['map_sha'], 'records': records}
    validate_receipts(spec, final, records, {'active': False, 'last': records[-1]}, out)
    rejected = 0
    for kind in ['failed_status', 'wrong_binding', 'wrong_map', 'main_claim', 'missing_replay',
                 'duplicate_replay', 'failed_exit', 'timeout', 'guard_drift', 'binding_drift',
                 'wrong_command', 'wrong_log', 'active', 'wrong_final_records']:
        f, recs = deepcopy(final), deepcopy(records)
        f['records'] = recs
        active_flag = False
        if kind == 'failed_status': f['status'] = 'FAIL_NOT_VERIFIED'
        elif kind == 'wrong_binding': f['binding_sha256'] = '0' * 64
        elif kind == 'wrong_map': f['source_map_sha256'] = '0' * 64
        elif kind == 'main_claim': f['main_theorem_claim'] = True
        elif kind == 'missing_replay': recs.pop()
        elif kind == 'duplicate_replay': recs.append(deepcopy(recs[-1]))
        elif kind == 'failed_exit': recs[0]['exit'] = 1
        elif kind == 'timeout': recs[1]['timed_out'] = True
        elif kind == 'guard_drift': recs[1]['guards_unchanged'] = False
        elif kind == 'binding_drift': recs[1]['binding_drift_paths'] = ['fixture-only']
        elif kind == 'wrong_command': recs[1]['command'][-1] = 'D1Bound5.WrongTarget'
        elif kind == 'wrong_log': recs[1]['log'] = 'wrong.log'
        elif kind == 'active': active_flag = True
        elif kind == 'wrong_final_records': f['records'] = recs[:-1]
        try:
            validate_receipts(spec, f, recs, {'active': active_flag, 'last': recs[-1]}, out)
        except RuntimeError:
            rejected += 1
        else:
            raise RuntimeError('Invalid synthetic receipt accepted: ' + kind)
    return {'status': 'SYNTHETIC_RECEIPT_VALIDATOR_TESTS_PASS_NOT_AUDIT',
            'positive_cases': 1, 'negative_cases': rejected, 'external_receipts_read_or_written': False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument('--prepare', action='store_true', help='Write only a new isolated package, after all gates pass')
    modes.add_argument('--self-test', action='store_true', help='Pure synthetic receipt tests; no I/O or subprocesses')
    args = parser.parse_args()
    if args.self_test:
        print(json.dumps(self_test(), indent=2))
        return
    require(not DEST.exists(), 'Destination exists; do not overwrite a previous package')
    require(git('rev-parse', 'HEAD').decode().strip() == HEAD, 'HEAD changed: new explicit source-map review required')
    index_before = git('ls-files', '--stage', '-z')
    require(sha(index_before) == FULL_INDEX_SHA and original_index_hash(index_before) == ORIGINAL_INDEX_SHA,
            'Inherited index changed; stop rather than refreshing its boundary')
    staged = {p.decode() for p in git('diff', '--cached', '--name-only', '-z').split(b'\0') if p}
    require(len(staged) == 547, 'Inherited staged scope changed')
    require(git('remote', 'get-url', 'origin').decode().strip() == 'https://github.com/tomislav-math/d1-bound5-lean.git',
            'Unexpected remote; no alternative destination is authorized')
    denied_blobs = set()
    denied_module_names = set()
    for item in index_before.split(b'\0'):
        if not item: continue
        meta, path = item.split(b'\t', 1)
        mode, oid, stage = meta.split()
        if path.decode() in staged:
            require(stage == b'0', 'Unmerged inherited index')
            denied_blobs.add(oid.decode())
            if path.decode().endswith('.lean'): denied_module_names.add(Path(path.decode()).stem)

    # Inputs are hash-guarded on first read and checked again before/after output.
    inputs = {}
    def read(path):
        path = Path(path)
        require(path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(ROOT.resolve()),
                'Unexpected evidence path: ' + str(path))
        value = path.read_bytes()
        name = str(path.resolve())
        require(name not in inputs or inputs[name] == sha(value), 'Input changed while reading: ' + name)
        inputs[name] = sha(value)
        return value
    def read_json(path): return json.loads(read(path))

    frozen_sources = {}
    artifact_guards = {}
    static_guards = {}
    audit_states = []
    for spec in AUDITS:
        out = RUN / spec['folder']
        require(sha(read(out / 'AnalyticAudit.lean')) == spec['audit_sha'], 'Reviewed generated audit changed')
        require(sha(read(out / 'PREPARATION_BINDINGS.json')) == spec['binding_sha'], 'Reviewed binding changed')
        require(sha(read(out / 'SOURCE_MAP.json')) == spec['map_sha'], 'Reviewed source map changed')
        require(read_json(out / 'TARGETS.json') == read_json(out / 'REPLAY_TARGETS.json') == spec['targets'], 'Wrong target set')
        for name, digest in FINAL_SHA.items():
            require(sha(read(out / name)) == digest, 'Reviewed terminal evidence changed: ' + name)
        final = read_json(out / 'BOUND_AUDIT_FINAL.json')
        records = read_json(out / 'TARGETED_REPLAY_RECEIPTS.json')
        validate_receipts(spec, final, records, read_json(out / 'active-targeted-replay.json'), out)
        start = read_json(out / 'BOUND_AUDIT_START.json')
        require(start['binding_sha256'] == spec['binding_sha'] and start['source_map_sha256'] == spec['map_sha']
                and start['targets'] == spec['targets'] and start['main_theorem_claim'] is False, 'Start identity mismatch')
        binding = read_json(out / 'PREPARATION_BINDINGS.json')
        guards = read_json(out / 'TARGETED_REPLAY_GUARDS.json')
        require(binding['audit_folder'] == str(out) and binding['targets'] == binding['replays'] == spec['targets'], 'Binding identity mismatch')
        require(binding['project_sources'] == guards['project_sources'], 'Prepared/final closure mismatch')
        expected_preparation = dict(binding['files'])
        expected_preparation[str(out / 'PREPARATION_BINDINGS.json')] = spec['binding_sha']
        require(guards['preparation_files'] == expected_preparation, 'Final preparation-file guard differs from reviewed binding')
        for path, expected in expected_preparation.items():
            require(sha(read(path)) == expected, 'Prepared input drift: ' + path)
        merge_exact(frozen_sources, guards['project_sources'], 'source')
        merge_exact(artifact_guards, guards['compiled_artifacts'], 'artifact')
        merge_exact(static_guards, guards['immutable_inputs'], 'static')
        declarations = read_json(out / 'DECLARATION_NAMES.json')
        originals = read_json(out / 'SCOPED_ORIGINAL_DECLARATIONS.json')
        require(len(declarations) == len(set(declarations)) == spec['declarations'], 'Unexpected declaration count')
        require(sum(d['kind'] == 'theorem' for row in originals for d in row['declarations']) == spec['examples'], 'Unexpected exact-theorem count')
        require(sum(d['kind'] == 'def' for row in originals for d in row['declarations']) == 241, 'Unexpected original definition count')
        structures = [d for row in originals for d in row['declarations'] if d['kind'] == 'structure']
        require(len(structures) == 1 and sum(2 + 2 * len(d['fields']) for d in structures) == spec['structure_examples'], 'Unexpected original structure examples')
        log = read(out / 'analytic-type-axioms.log').decode()
        require(all('ANALYTIC_AXIOMS_PASS ' + name + ':' in log for name in declarations), 'Missing per-declaration transitive axiom results')
        for rec in records: read(out / rec['log'])
        audit_states.append((spec, out, binding, guards, records, originals))

    require(len(frozen_sources) == 61 and all(frozen_sources.get(n) == h for n, h in NEW_SOURCE_SHA.items()),
            'Exact approved 61-source/two-new-source scope changed')
    require(not (set(frozen_sources) & denied_module_names), 'Denied module-name overlap in closure')
    source_bytes = {n: read(ROOT / 'D1Bound5' / (n + '.lean')) for n in frozen_sources}
    def stable():
        for n, expected in frozen_sources.items():
            require(sha((ROOT / 'D1Bound5' / (n + '.lean')).read_bytes()) == expected, 'Canonical source drift: ' + n)
        for path, expected in {**artifact_guards, **static_guards}.items():
            require(sha((ROOT / path).read_bytes()) == expected, 'Compiled artifact/static pin drift: ' + path)
        for path, expected in inputs.items(): require(sha(Path(path).read_bytes()) == expected, 'Evidence input drift: ' + path)
        require(git('ls-files', '--stage', '-z') == index_before and git('rev-parse', 'HEAD').decode().strip() == HEAD,
                'Index or HEAD changed during checkpoint preparation')
    stable()

    tree = defaultdict(list)
    for item in git('ls-tree', '-r', '-z', HEAD).split(b'\0'):
        if not item: continue
        meta, name = item.split(b'\t', 1)
        mode, kind, oid = meta.split()
        if kind == b'blob' and mode in (b'100644', b'100755'): tree[oid.decode()].append(name.decode())
    committed_cache = {}
    def committed_reference(data):
        oid = blob(data)
        paths = tree.get(oid, [])
        if not paths: return None
        path = min(paths, key=lambda p: (not p.startswith('D1Bound5/'), len(p), p))
        if oid not in committed_cache: committed_cache[oid] = git('cat-file', 'blob', HEAD + ':' + path)
        require(committed_cache[oid] == data, 'Committed byte mismatch')
        return {'storage': 'existing_git_commit', 'commit': HEAD, 'path': path, 'sha256': sha(data), 'git_blob': oid}

    package = {}
    reconstruction = {}
    package_by_oid = {}
    def include(path, preferred, force_payload=False):
        path = Path(path).resolve()
        require(str(path.relative_to(ROOT)) not in staged, 'Denied inherited source/evidence path; do not repackage')
        data = read(path)
        oid = blob(data)
        require(oid not in denied_blobs, 'Denied staged-content overlap; do not repackage: ' + str(path))
        reference = None if force_payload else committed_reference(data)
        if reference is None:
            key = package_by_oid.get(oid, preferred)
            require(not Path(key).is_absolute() and '..' not in Path(key).parts, 'Unsafe package key')
            require(key not in package or package[key] == data, 'Package path collision')
            package[key] = data
            package_by_oid[oid] = key
            reference = {'storage': 'checkpoint', 'path': key, 'sha256': sha(data), 'git_blob': oid}
        original = str(path.relative_to(ROOT))
        require(original not in reconstruction or reconstruction[original] == reference, 'Conflicting reconstruction mapping')
        reconstruction[original] = reference
        return reference

    source_map = {}
    for n, data in source_bytes.items():
        require(sha(data) == frozen_sources[n] and blob(data) not in denied_blobs, 'Source guard/denied-content mismatch')
        committed = committed_reference(data)
        require((n in NEW_SOURCE_SHA) == (committed is None), 'Scope must remain exactly two new and 59 committed sources')
        ref = include(ROOT / 'D1Bound5' / (n + '.lean'), 'sources/' + n + '.lean', n in NEW_SOURCE_SHA)
        source_map[n] = {'source': 'D1Bound5/' + n + '.lean', **ref}
    require(sum(v['storage'] == 'existing_git_commit' for v in source_map.values()) == 59, 'Wrong committed-source count')

    build_receipts = []
    audit_files = ['AnalyticAudit.lean', 'DECLARATION_NAMES.json', 'SCOPED_ORIGINAL_DECLARATIONS.json',
        'REPLAY_TARGETS.json', 'SOURCE_MAP.json', 'TARGETS.json', 'BUILD_RECEIPT_MAP.json',
        'PREPARATION_BINDINGS.json', 'BOUND_AUDIT_START.json', 'BOUND_AUDIT_FINAL.json',
        'TARGETED_REPLAY_GUARDS.json', 'TARGETED_REPLAY_RECEIPTS.json', 'active-targeted-replay.json']
    for spec, out, binding, guards, records, originals in audit_states:
        prefix = 'audit/' + spec['label'] + '/'
        for name in audit_files + [rec['log'] for rec in records]: include(out / name, prefix + name)
        # Preserve the reconstruction identity of every bound input without
        # unnecessarily duplicating committed originals or source snapshots.
        for path in binding['files']:
            p = Path(path)
            include(p, 'provenance/' + str(p.relative_to(ROOT)))
        receipt_map = read_json(out / 'BUILD_RECEIPT_MAP.json')
        for n in spec['targets']:
            ref = receipt_map[n]
            rec = read_json(ref['receipt'])
            closure = read_json(ref['closure'])
            require(rec['name'] == n and rec['source_sha256'] == frozen_sources[n] and rec['accepted_build'] is True
                    and rec['exit'] == 0 and rec['closure_unchanged'] is True and rec['shared_artifacts_unchanged'] is True
                    and rec['timed_out'] is False and rec.get('interrupted', False) is False, 'Build is not an exact guarded PASS')
            require(rec['fingerprint'] == sha(json.dumps(closure, sort_keys=True).encode()), 'Build closure fingerprint mismatch')
            require(all(frozen_sources.get(dep) == h for dep, h in closure.items()), 'Build/source closure mismatch')
            require(all(artifact_guards.get(p) == h for p, h in rec['artifacts'].items()), 'Build/final artifact mismatch')
            include(ref['receipt'], 'build/' + n + '-BUILD_RECEIPT.json')
            include(ref['closure'], 'build/' + n + '-SOURCE_CLOSURE.json')
            include(rec['log'], 'build-logs/' + n + '.log')
            build_receipts.append(rec)
        for row in originals:
            require(row['module'] in spec['targets'], 'Unexpected original module')
            original = read(row['original_path'])
            require(sha(original) == row['original_sha256'] and committed_reference(original) is not None,
                    'Preserved original no longer has the reviewed committed provenance')
            include(row['original_path'], 'before/' + row['module'] + '.lean')
    for name, expected in TOOL_SHA.items():
        require(sha(read(RUN / name)) == expected, 'Reviewed audit tool changed')
        include(RUN / name, 'tools/' + name)
    include(Path(__file__).resolve(), 'prepare_finite13_checkpoint.py', True)
    for path in static_guards: include(ROOT / path, 'pins/' + path)

    summary = {'status': 'FINITE13_SEPARATELY_AUDITED_WORKING_UNITS', 'modules': ['OneSmallThirdData', 'OneSmallFourthData1', 'OneSmallFourthData2', 'OneSmallFourthData3', 'OneSmallFourthData4', 'OneSmallFourthData5', 'OneSmallFourthData6', 'OneSmallFourthData7', 'OneSmallRows', 'OneSmallRowMetadata', 'OneSmallSymmetry', 'OneSmallOrbitRows', 'OneSmallFullRingFinite'], 'new_source_versions': ['FirstPairClassification', 'OneSmallRows'], 'new_source_audited_targets': ['OneSmallRows'], 'new_source_closure_dependencies': ['FirstPairClassification'], 'unchanged_previously_committed_source_targets': ['OneSmallThirdData', 'OneSmallFourthData1', 'OneSmallFourthData2', 'OneSmallFourthData3', 'OneSmallFourthData4', 'OneSmallFourthData5', 'OneSmallFourthData6', 'OneSmallFourthData7', 'OneSmallRowMetadata', 'OneSmallSymmetry', 'OneSmallOrbitRows', 'OneSmallFullRingFinite'], 'reference_commit': 'ea18e9a9bf036d65835e646da3a9f9a517d0bb0d', 'source_closure_count': 61, 'committed_source_references': 59, 'new_source_payloads': 2, 'named_declarations_transitively_audited': 501, 'exact_original_theorem_examples': 252, 'exact_original_structure_examples': 14, 'total_exact_original_examples': 266, 'unchanged_original_definition_bodies': 241, 'bound_audits_passed': 1, 'targeted_installed_same_kernel_replays': 13, 'accepted_audit_attempts': ['finite-one-small-audit-v1'], 'fresh_whole_closure_replay': False, 'independent_checker_implementation': False, 'root_integrated': False, 'main_statement_proved': False, 'clean_checkout_validation': False, 'inherited_staged_paths_excluded': 547, 'inherited_index_sha256': 'bc8eb2096ff68daebaaf3ae8a9700f82d0ab6f894abb5f7428e6cc9380411453', 'git_mutations_performed': False, 'compiler_started_by_preparer': False, 'scope': 'Only the thirteen selected targets and exact finite closure/evidence. FirstPairClassification is a closure dependency, not a separately audited target. No row26 payload or denied inherited staged content.'}
    summary['utc'] = datetime.now(timezone.utc).isoformat()
    package['VERIFICATION_SUMMARY.json'] = jsonbytes(summary)
    package['SOURCE_MAP.json'] = jsonbytes(source_map)
    package['RECONSTRUCTION_MAP.json'] = jsonbytes(reconstruction)
    package['BUILD_RECEIPTS.json'] = jsonbytes(build_receipts)
    package['README.md'] = '# Thirteen separately audited finite working units\n\nThis checkpoint records the exact finite-one-small-audit-v1 milestone: all\n13 named targets (including OneSmallRowMetadata), 501 transitive axiom checks,\n252 exact original theorem examples and 14 original structure examples.\nThe independently preserved original definitions retain all 241 complete bodies.\nThe bound audit and all 13 targeted installed SAME-kernel replays must have\nactual passing terminal receipts before this package can be prepared.\n\nSOURCE_MAP.json reconstructs the complete 61-module source closure: exactly\n59 byte-identical references to commit ea18e9a9bf036d65835e646da3a9f9a517d0bb0d and two\nnew source payloads: OneSmallRows and FirstPairClassification. Only OneSmallRows\nis one of the 13 explicit audit/replay targets; FirstPairClassification is a\nclosure dependency. Its inclusion is not a claim of a separate original-type\nor targeted-replay audit of every declaration in that dependency.\n\nThis is not the main theorem, accepted-root integration, a fresh whole-closure\nreplay, an independent checker implementation, or clean-checkout validation.\nRECONSTRUCTION_MAP.json records exact repository-relative reconstruction inputs.\nOriginal pre-edit sources are anchored to existing committed blobs; the current\nsource is never silently substituted for an independent original. Verify hashes\nand compare destinations before restoration into a fresh checkout.\n\nAudit files, bindings, logs and process receipts retain historical absolute paths.\nThey document performed checks and are not a portable auto-execution script.\nReplaying elsewhere requires appropriate path placement or separately reviewed\nregeneration and new bindings. The scoped helper and guarded runner are included\nor anchored as exact provenance. This proposal narrowly reuses the earlier\nseven-scoped checkpoint mechanism with finite13 pins and structure counts.\n\nAll 547 inherited staged paths and their exact staged content are excluded.\nThere are no row26 payloads, compiled proof objects, external manuscript files\nor unrelated run trees. The original Oct19 refusal reason remains UNKNOWN;\nthis distinct scoped checkpoint neither reclassifies nor resolves that refusal.\nPreparation performs no Git mutation. Any future explicit-path staging, commit\nand non-forced push must follow the existing PRIVATE-repository policy with\nseparate review. The original inherited index must remain byte-for-byte intact.\n'.encode()

    for name, data in package.items():
        require(not Path(name).is_absolute() and '..' not in Path(name).parts, 'Unsafe output path')
        require(str((DEST / name).relative_to(ROOT)) not in staged, 'Inherited staged path overlap')
        require(blob(data) not in denied_blobs, 'Denied staged payload overlap')
        require(not any(re.search(pattern, data.decode()) for pattern in SECRET_PATTERNS), 'Credential-shaped text: ' + name)
    manifest = {name: {'sha256': sha(data), 'bytes': len(data)} for name, data in sorted(package.items())}
    package['MANIFEST.json'] = jsonbytes({'files': manifest, 'scope': 'All payload files except this manifest and PATHS.txt'})
    paths = sorted(str((DEST / name).relative_to(ROOT)) for name in [*package, 'PATHS.txt'])
    package['PATHS.txt'] = ('\n'.join(paths) + '\n').encode()
    stable()
    print(json.dumps({'status': 'POST_PASS_CHECKPOINT_REVIEW', 'destination': str(DEST),
                      'files': len(package), 'bytes': sum(map(len, package.values())), 'summary': summary}, indent=2))
    if args.prepare:
        DEST.mkdir(mode=0o700)
        for name, data in package.items():
            path = DEST / name
            path.parent.mkdir(parents=True, exist_ok=True)
            with path.open('xb') as stream: stream.write(data)
            require(path.read_bytes() == data, 'Package readback mismatch: ' + name)
        stable()
        print('ISOLATED_FINITE13_CHECKPOINT_PREPARED_NO_GIT_MUTATION', DEST)


if __name__ == '__main__':
    main()
