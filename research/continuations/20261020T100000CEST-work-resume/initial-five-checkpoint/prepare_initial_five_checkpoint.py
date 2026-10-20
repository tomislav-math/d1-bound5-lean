"""Prepare a new five-unit checkpoint; never stage, commit, push or change live proofs.
Default is a read-only proposal. --prepare writes only a fresh isolated package.
All dependency sources are pinned to exact paths in the existing HEAD.
"""
from pathlib import Path
from collections import Counter
from datetime import datetime, timezone
import argparse, hashlib, json, os, re, subprocess

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT / 'research/continuations/20261020T100000CEST-work-resume'
AUDIT = RUN / 'initial-audit-v2'
DEST = RUN / 'initial-five-checkpoint'
EXPECTED_HEAD = '16c7d9d29b03dbbe4fb2d572f933ced4cd82c260'
NAMES = ['FinitePRatioMonomial', 'CoherentRetainedMixedFourSizes',
         'SmallPairClassificationCheck', 'OneSmallFiniteCheck', 'OneThreeEight']
TOKEN_PATTERNS = [r'gh[pousr]_[A-Za-z0-9]{20,}', r'github_pat_[A-Za-z0-9_]{30,}',
                  r'-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----',
                  r'sk-(?:proj-)?[A-Za-z0-9_-]{28,}',
                  r'(?i)Bearer\s+[A-Za-z0-9_.-]{30,}', r'(?i)https?://[^\s/:]+:[^\s/@]+@']

def need(ok, message):
    if not ok: raise RuntimeError(message)

def sha(b): return hashlib.sha256(b).hexdigest()
def blob_oid(b): return hashlib.sha1(b'blob ' + str(len(b)).encode() + b'\0' + b).hexdigest()

def git(*args):
    return subprocess.check_output(['git', *args], cwd=ROOT,
        env={**os.environ, 'GIT_OPTIONAL_LOCKS': '0'}, timeout=30)

def jsonbytes(x): return (json.dumps(x, indent=2, sort_keys=True) + '\n').encode()

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--prepare', action='store_true')
    args = ap.parse_args()
    need(not DEST.exists(), 'Destination already exists; do not overwrite')
    head = git('rev-parse', 'HEAD').decode().strip()
    need(head == EXPECTED_HEAD, 'HEAD changed; review dependency anchors before proceeding')
    index_before = git('ls-files', '--stage', '-z')
    staged = {p.decode() for p in git('diff', '--cached', '--name-only', '-z').split(b'\0') if p}
    need(len(staged) == 547, 'Inherited staged scope changed; review before proceeding')
    need(git('remote', 'get-url', 'origin').decode().strip() ==
         'https://github.com/tomislav-math/d1-bound5-lean.git', 'Unexpected destination')
    guards = json.loads((AUDIT/'TARGETED_REPLAY_GUARDS.json').read_text())
    receipts = json.loads((AUDIT/'TARGETED_REPLAY_RECEIPTS.json').read_text())
    targets = json.loads((AUDIT/'TARGETS.json').read_text())
    need(targets == NAMES, 'Unexpected audit unit set')
    expected_labels = {'analytic-type-axioms'} | {n+'-targeted-replay' for n in NAMES}
    need(len(receipts) == 6 and {v['label'] for v in receipts} == expected_labels,
         'Incomplete final audit receipts')
    need(all(v['exit'] == 0 and not v['timed_out'] and v['guards_unchanged'] for v in receipts),
         'Final audit did not pass')
    need(json.loads((AUDIT/'active-targeted-replay.json').read_text())['active'] is False,
         'Audit still active')
    evidence_inputs = {}
    def read(p):
        b = p.read_bytes()
        evidence_inputs[str(p)] = sha(b)
        return b
    source_bytes = {}
    for n, h in guards['project_sources'].items():
        p = ROOT/'D1Bound5'/(n+'.lean')
        source_bytes[n] = read(p)
        need(sha(source_bytes[n]) == h, 'Source guard mismatch: '+n)
    def check_guards():
        for n, h in guards['project_sources'].items():
            need(sha((ROOT/'D1Bound5'/(n+'.lean')).read_bytes()) == h, 'Source changed: '+n)
        for p, h in {**guards['compiled_artifacts'], **guards['immutable_inputs']}.items():
            need(sha((ROOT/p).read_bytes()) == h, 'Artifact/pin guard mismatch: '+p)
    check_guards()
    tree = {}
    for item in git('ls-tree', '-r', '-z', head).split(b'\0'):
        if not item: continue
        meta, name = item.split(b'\t', 1)
        mode, kind, oid = meta.split()
        path = name.decode()
        if kind == b'blob' and mode in (b'100644', b'100755') and path.endswith('.lean'):
            tree.setdefault(oid.decode(), []).append(path)
    package = {}
    source_map = {}
    for n, b in source_bytes.items():
        record = {'source': 'D1Bound5/'+n+'.lean', 'sha256': sha(b), 'git_blob': blob_oid(b)}
        if n in NAMES:
            snap = read(AUDIT/(n+'.lean'))
            need(snap == b, 'Audited source snapshot mismatch: '+n)
            key = 'sources/'+n+'.lean'
            package[key] = b
            record.update(storage='checkpoint', path=key)
            package['before/'+n+'.lean'] = read(RUN/'before'/(n+'.lean'))
        else:
            found = tree.get(blob_oid(b), [])
            need(found, 'Dependency absent from current committed HEAD: '+n)
            path = min(found, key=lambda p:(not p.startswith('D1Bound5/'), len(p), p))
            need(git('cat-file', 'blob', head+':'+path) == b, 'Committed dependency mismatch: '+n)
            record.update(storage='existing_git_commit', commit=head, path=path)
        source_map[n] = record
    imports = re.compile(rb'^\s*import\s+([^\n]+)', re.M)
    names = re.compile(rb'\bD1Bound5\.([A-Za-z0-9_]+)')
    def closure(n, found=None):
        found = {} if found is None else found
        if n in found: return found
        found[n] = sha(source_bytes[n])
        for line in imports.findall(source_bytes[n]):
            for dep in names.findall(line.split(b'--', 1)[0]): closure(dep.decode(), found)
        return found
    rows = json.loads((ROOT/'research/continuations/20261018T010800CEST-main-continuation/continuation-builds.json').read_text())
    build_receipts = []
    for n in NAMES:
        fp = sha(json.dumps(closure(n), sort_keys=True).encode())
        matching = [v for v in rows if v['name'] == n and v['fingerprint'] == fp]
        need(matching, 'No current fingerprint build receipt: '+n)
        rec = matching[-1]
        need(rec['accepted_build'] and rec['exit'] == 0 and rec['closure_unchanged'],
             'Current build not accepted: '+n)
        need(rec['source_sha256'] == sha(source_bytes[n]), 'Build source mismatch: '+n)
        build_receipts.append(rec)
        log = Path(rec['log'])
        need(log.is_relative_to(ROOT), 'Unexpected build log path')
        package['build-logs/'+n+'.log'] = read(log)
    audit_files = ['AnalyticAudit.lean', 'DECLARATIONS.json', 'EXACT_ORIGINAL_STATEMENT_EXAMPLES.json',
        'HEADER_REVIEW.json', 'REPLAY_TARGETS.json', 'SOURCE_MAP.json', 'TARGETED_REPLAY_GUARDS.json',
        'TARGETED_REPLAY_RECEIPTS.json', 'TARGETS.json', 'active-targeted-replay.json', 'locked_checks.py']
    audit_files += [v['log'] for v in receipts]
    for n in audit_files: package['audit/'+n] = read(AUDIT/n)
    for n in ['AnalyticAudit.lean', 'TARGETED_REPLAY_RECEIPTS.json', 'analytic-type-axioms.log']:
        package['failed-first-audit/'+n] = read(RUN/'initial-audit'/n)
    package['SOURCE_STATEMENT_REVIEW.md'] = read(RUN/'SOURCE_STATEMENT_REVIEW.md')
    for n in guards['immutable_inputs']:
        package['pins/'+n] = read(ROOT/n)
    declarations = json.loads((AUDIT/'DECLARATIONS.json').read_text())
    summary = {'status':'FIVE_SEPARATELY_VERIFIED_WORKING_UNITS', 'utc':datetime.now(timezone.utc).isoformat(),
        'modules':NAMES, 'declarations_by_kind':dict(Counter(v['kind'] for v in declarations)),
        'targeted_installed_same_kernel_replays':5, 'exact_type_transitive_axiom_audit':'PASS',
        'current_source_guard_count':len(source_map), 'existing_commit_dependency_count':len(source_map)-5,
        'reference_commit':head, 'root_integrated':False, 'main_statement_proved':False,
        'fresh_whole_closure_replay':False, 'clean_checkout':False,
        'inherited_staged_paths_excluded':547, 'git_mutations_performed':False,
        'scope':'Sources and recorded checks only. No generated proof objects or accepted-root edits.'}
    package['VERIFICATION_SUMMARY.json'] = jsonbytes(summary)
    package['SOURCE_MAP.json'] = jsonbytes(source_map)
    package['BUILD_RECEIPTS.json'] = jsonbytes(build_receipts)
    package['README.md'] = ("# Five verified working units\n\n"
        "This isolated checkpoint contains the five modules listed in VERIFICATION_SUMMARY.json. "
        "Each has current guarded compilation, original statement checks, a transitive-axiom audit "
        "and a targeted installed SAME-kernel replay. The failed initial audit is retained separately.\n\n"
        "MainStatement remains unproved. No accepted-root integration, fresh whole-closure replay or "
        "clean-checkout validation is claimed. SOURCE_STATEMENT_REVIEW.md is an independent source-level "
        "semantic review, not a claim of completed verification.\n\n"
        "SOURCE_MAP.json locates all 62 dependency-closure source files. Five are included in sources/. "
        "The other 57 are byte-identical blobs in reference commit " + head + ". Restore each to its "
        "source path only in a fresh checkout, verify SHA256, and use the pinned toolchain/manifest. "
        "Existing project files must first be compared, never overwritten blindly.\n\n"
        "Historical audit scripts and receipts preserve their original absolute paths. They document "
        "the performed checks; replay in a new checkout requires appropriately located audit commands.\n\n"
        "This package excludes every inherited staged path and does not retry the earlier denied graph "
        "commit. Creating it does not stage, commit or push anything.\n").encode()
    package['prepare_initial_five_checkpoint.py'] = read(Path(__file__).resolve())
    for name, b in package.items():
        need(not Path(name).is_absolute() and '..' not in Path(name).parts, 'Unsafe package path')
        need(not any(re.search(p, b.decode()) for p in TOKEN_PATTERNS), 'Credential-shaped text: '+name)
        need(str((DEST/name).relative_to(ROOT)) not in staged, 'Inherited index path overlap')
    manifest = {name:{'sha256':sha(b), 'bytes':len(b)} for name,b in sorted(package.items())}
    package['MANIFEST.json'] = jsonbytes({'files':manifest, 'scope':'All payload files except this manifest and PATHS.txt'})
    proposed = sorted(str((DEST/n).relative_to(ROOT)) for n in [*package, 'PATHS.txt'])
    package['PATHS.txt'] = ('\n'.join(proposed)+'\n').encode()
    check_guards()
    for p,h in evidence_inputs.items(): need(sha(Path(p).read_bytes()) == h, 'Evidence changed: '+p)
    need(git('ls-files', '--stage', '-z') == index_before and git('rev-parse','HEAD').decode().strip() == head,
         'Git state changed during preparation')
    print(json.dumps({'status':'REVIEWED_PACKAGE_PROPOSAL','files':len(package),
        'bytes':sum(map(len,package.values())),'destination':str(DEST),'summary':summary},indent=2))
    if args.prepare:
        DEST.mkdir(mode=0o700)
        for n,b in package.items():
            p=DEST/n;p.parent.mkdir(parents=True,exist_ok=True)
            with p.open('xb') as f:f.write(b)
            need(p.read_bytes() == b, 'Package readback mismatch: '+n)
        need(git('ls-files','--stage','-z') == index_before, 'Index changed externally during output')
        print('ISOLATED_CHECKPOINT_PREPARED_NO_GIT_MUTATION',str(DEST))

if __name__ == '__main__':
    main()
