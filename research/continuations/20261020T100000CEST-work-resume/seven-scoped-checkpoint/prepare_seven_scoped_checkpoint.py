"""Prepare an isolated seven-unit evidence checkpoint AFTER both bound audits PASS.

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
DEST = RUN / 'seven-scoped-checkpoint'
HEAD = '6e8af40e2833acc2e62df970257b07bdef925a7b'
ORIGINAL_INDEX_SHA = 'bc8eb2096ff68daebaaf3ae8a9700f82d0ab6f894abb5f7428e6cc9380411453'
FULL_INDEX_SHA = 'b21070553d7106b0fc9c4fa66b5c435e4af091417dc24d0c6a7eb7151f3c3bca'
OLD_COMMITTED_PACKAGE = 'research/continuations/20261020T100000CEST-work-resume/initial-five-checkpoint/'
AUDITS = [
    {'folder': 'bound-frontier-four-audit-v2', 'label': 'frontier-four',
     'targets': ['FrontierCubicErrors', 'FiniteN3RefinedResidual', 'FiniteN2HeightRefinement', 'FiniteN3HeightRefinement'],
     'audit_sha': '3a20e06a8faf9718aec69ad4d73e1c015717f231eaf5f898e886a353b47f0ec3',
     'binding_sha': 'e7e2a388ab904fadd4c14257b94a4ad6858ffb900e107dda2b29d60c128d8979',
     'map_sha': 'b71d16ef1f7d453cfc809dabf7a18910a8e2bcb2745fef1f37ad0fc9d216e56e',
     'declarations': 10, 'examples': 10},
    {'folder': 'bound-data-three-audit-v2', 'label': 'data-three',
     'targets': ['SmallPairClassificationData', 'FirstPairData', 'OneSmallDisks'],
     'audit_sha': '6c3fbe7979c1fb6c534d403a92e65e762cc40c5e426d924e895c15efecc162bd',
     'binding_sha': 'a8538c26a228b85c0e942d615e884586c9b35c3c68445db959a8220cb0d10601',
     'map_sha': '1d6e84b44ee728bda1f47e13308a7e34f8bd61bdea18bc726257b3f3dcb1a658',
     'declarations': 183, 'examples': 107}
]
NAMES = [n for audit in AUDITS for n in audit['targets']]
NEW_SOURCE_SHA = {
    'FrontierCubicErrors': '290e56b9252013e634702a589994a6103f69a633748ac8b55583e58d2275eedb',
    'FiniteN3RefinedResidual': '0295ce772ecf9751263aff0b8d27649f592a52d5790634adaaa8e26b884eb51a',
    'FiniteN2HeightRefinement': 'b1126c09dc8f65e44341e2b5079d83bdc6a616c2b86378feaae223739d8bfcb0',
    'FiniteN3HeightRefinement': 'cc79841722f14bc0430d983e1a5bde6292d1c53ee9e96ec0883f3acc6f9a5dfb'
}
TOOL_SHA = {
    'scoped_audit_helper_proposal_v2.py': '2b83c6facd4c66a5bc3089aedb76aa4a7c66583a607298d729a3dc75a02577e8',
    'bound_scoped_audit_runner_proposal_v1.py': 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
}
FAILED_V1_SHA = {
    'AnalyticAudit.lean': '4d863ae13f3caccdb5150a1d24b873629a4ddcace88189c4904475c3c4da6ad7',
    'BOUND_AUDIT_FINAL.json': 'e31db34c14131e0057b15563a22446fda51ec0e270597aa436c6797d19e5085e',
    'TARGETED_REPLAY_RECEIPTS.json': '04f530a5db5ec60f5943be5f7e5f0c41b164b32ae3e67d9fbf91b385d6a64c88',
    'analytic-type-axioms.log': '1d136903ceb7bd9b85f20893e32489291354a2b12a1f86ead52a6e5eb132611d'
}
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
    filtered = [item for item in index.split(b'\0') if item and OLD_COMMITTED_PACKAGE.encode() not in item]
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
        require(sum(d['kind'] == 'theorem' for row in originals for d in row['declarations']) == spec['examples'], 'Unexpected exact-example count')
        log = read(out / 'analytic-type-axioms.log').decode()
        require(all('ANALYTIC_AXIOMS_PASS ' + name + ':' in log for name in declarations), 'Missing per-declaration transitive axiom results')
        for rec in records: read(out / rec['log'])
        audit_states.append((spec, out, binding, guards, records, originals))

    require(len(frozen_sources) == 125 and all(frozen_sources.get(n) == h for n, h in NEW_SOURCE_SHA.items()),
            'Exact approved 125-source/four-new-source scope changed')
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
        require((n in NEW_SOURCE_SHA) == (committed is None), 'Scope must remain exactly four new and 121 committed sources')
        ref = include(ROOT / 'D1Bound5' / (n + '.lean'), 'sources/' + n + '.lean', n in NEW_SOURCE_SHA)
        source_map[n] = {'source': 'D1Bound5/' + n + '.lean', **ref}
    require(sum(v['storage'] == 'existing_git_commit' for v in source_map.values()) == 121, 'Wrong committed-source count')

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
    # Keep the failed first attempt visible; these four immutable records are
    # historical evidence only and never satisfy either v2 PASS gate above.
    failed = RUN / 'bound-frontier-four-audit-v1'
    for name, expected in FAILED_V1_SHA.items():
        require(sha(read(failed / name)) == expected, 'Preserved failed v1 evidence changed')
        include(failed / name, 'historical-failed-frontier-v1/' + name)
    require(read_json(failed / 'BOUND_AUDIT_FINAL.json')['status'] == 'FAIL_NOT_VERIFIED',
            'Historical failed attempt was reclassified')
    include(Path(__file__).resolve(), 'prepare_seven_scoped_checkpoint.py', True)
    for path in static_guards: include(ROOT / path, 'pins/' + path)

    summary = {'status': 'SEVEN_SEPARATELY_AUDITED_WORKING_UNITS', 'utc': datetime.now(timezone.utc).isoformat(),
        'modules': NAMES, 'new_source_versions': list(NEW_SOURCE_SHA), 'unchanged_previously_committed_source_targets': AUDITS[1]['targets'],
        'reference_commit': HEAD, 'source_closure_count': 125, 'committed_source_references': 121, 'new_source_payloads': 4,
        'named_declarations_transitively_audited': 193, 'exact_original_theorem_examples': 117,
        'bound_audits_passed': 2, 'targeted_installed_same_kernel_replays': 7,
        'accepted_audit_attempts': [s['folder'] for s in AUDITS],
        'historical_failed_attempt': 'bound-frontier-four-audit-v1',
        'historical_data_v1_attempt': 'NOT_RUN_KNOWN_NAMESPACE_CLOSURE_HARNESS_BUG',
        'fresh_whole_closure_replay': False, 'independent_checker_implementation': False,
        'root_integrated': False, 'main_statement_proved': False, 'clean_checkout_validation': False,
        'inherited_staged_paths_excluded': 547, 'inherited_index_sha256': ORIGINAL_INDEX_SHA,
        'git_mutations_performed': False, 'compiler_started_by_preparer': False,
        'scope': 'Only the seven selected source/evidence units. No row26 payload or denied inherited staged content.'}
    package['VERIFICATION_SUMMARY.json'] = jsonbytes(summary)
    package['SOURCE_MAP.json'] = jsonbytes(source_map)
    package['RECONSTRUCTION_MAP.json'] = jsonbytes(reconstruction)
    package['BUILD_RECEIPTS.json'] = jsonbytes(build_receipts)
    package['README.md'] = ('''# Seven separately audited working units

The four new source versions are FrontierCubicErrors, FiniteN3RefinedResidual,
FiniteN2HeightRefinement, and FiniteN3HeightRefinement. The three data targets
SmallPairClassificationData, FirstPairData, and OneSmallDisks have unchanged
already-committed source bytes; their new contribution is validation evidence.

Both bound source/type/axiom audits and all seven targeted installed SAME-kernel
replays have actual passing terminal receipts. The audits cover 193 named
declarations and 117 independently elaborated exact original theorem examples.
This is NOT the main theorem, accepted-root integration, a fresh whole-closure
replay, an independent checker implementation, or clean-checkout validation.

SOURCE_MAP.json reconstructs the complete 125-module source closure: exactly
four new files in sources/ and 121 byte-identical references to commit ''' + HEAD + '''.
RECONSTRUCTION_MAP.json records the repository-relative original location and
exact payload/committed reference for every preserved input and evidence file.
Original pre-edit sources are anchored to existing committed blobs; no implicit
current-source baseline is used. Verify SHA-256 before restoring anything, and
restore only into a fresh checkout after comparing every destination. Never
overwrite ongoing work blindly.

Audit files, bindings, logs, and process receipts retain historical absolute
paths. They are evidence of the performed checks, not a portable auto-execution
script. Replaying elsewhere requires appropriate path placement or a separately
reviewed regenerated audit and new binding. The scoped helper and guarded runner
are included or anchored as exact provenance.

The earlier frontier v1 audit failed because the generated audit harness closed
named namespaces using anonymous `end` commands. Its actual failure receipt,
log and generated Lean are retained under historical-failed-frontier-v1/ (or
their exact reconstruction references). The matching data v1 harness was never
run. Only the corrected v2 audit attempts contribute to this checkpoint's PASS
claim. Preserving the first attempt is not a claim that its ten printed axiom
checks made the failed complete Lean audit pass.

This checkpoint excludes all 547 inherited staged paths and their exact content.
It contains no row26 closure, denied material, compiled proof objects, external
manuscript, or unrelated run tree. Preparation performs no Git mutation and
does not resolve the earlier refusal. Any future staging/commit/non-forced push
requires its separate explicit review and the existing private-repository policy.
''').encode()

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
        print('ISOLATED_SEVEN_UNIT_CHECKPOINT_PREPARED_NO_GIT_MUTATION', DEST)


if __name__ == '__main__':
    main()
