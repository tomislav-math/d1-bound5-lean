from pathlib import Path
import datetime, hashlib, json, re, shutil, subprocess

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT/'research/continuations/20261018T010800CEST-main-continuation'
DEST = RUN/'checkpoint-3'
assert not DEST.exists(), 'Checkpoint already exists; review rather than overwrite'
DEST.mkdir()
stamp = datetime.datetime.now(datetime.timezone.utc).isoformat()
git = lambda *args: subprocess.run(['git', *args], cwd=ROOT, check=True,
    text=True, capture_output=True).stdout.strip()
assert not git('diff', '--cached', '--name-only')
assert git('rev-parse', 'HEAD') == '441ff8a4865a5e6f5497381a2a3dcce76a480fff'
sha = lambda data: hashlib.sha256(data).hexdigest()
paths = [x for x in git('ls-files', '--others', '--exclude-standard', 'D1Bound5').splitlines()
         if x.endswith('.lean')]
source_map = []
for name in sorted(paths):
    source = ROOT/name
    data = source.read_bytes()
    old = RUN/'checkpoint-2/draft-sources'/source.name
    if old.is_file() and old.read_bytes() == data:
        target = old
    else:
        target = DEST/'draft-delta'/source.name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(data)
    source_map.append({'source': name, 'stored_at': str(target.relative_to(ROOT)),
                       'bytes': len(data), 'sha256': sha(data)})
for name, content in json.loads((RUN/'checkpoint-3-intake.json').read_text()).items():
    p = DEST/name
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(content)
for name in ['continuation_driver.py', 'continuation-queue.json', 'continuation-builds.json',
             'continuation-active.json', 'checkpoint-2-push-receipt.json']:
    p = DEST/'verification'/name
    p.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(RUN/name, p)
shutil.copytree(RUN/'continuation-builds', DEST/'verification/continuation-builds')
rows = json.loads((DEST/'verification/continuation-builds.json').read_text())
latest = {(x['name'], x['fingerprint']): x for x in rows}
def closure(name, seen=None):
    seen = {} if seen is None else seen
    if name in seen: return seen
    data = (ROOT/'D1Bound5'/(name+'.lean')).read_bytes()
    seen[name] = sha(data)
    for dep in re.findall(rb'^import D1Bound5\.([A-Za-z0-9_]+)\s*$', data, re.M):
        closure(dep.decode(), seen)
    return seen
passed = []
for name in json.loads((DEST/'verification/continuation-queue.json').read_text())['names']:
    fingerprint = sha(json.dumps(closure(name), sort_keys=True).encode())
    if latest.get((name, fingerprint), {}).get('accepted_build', False): passed.append(name)
(DEST/'SOURCE_MAP.json').write_text(json.dumps({'utc': stamp, 'sources': source_map}, indent=2)+'\n')
record = ROOT/'records/runs/20261018T010800CEST-main-continuation-CHECKPOINT-3.md'
record.write_text(f'''# Main-theorem continuation: third research checkpoint

Captured {stamp}. MainStatement remains UNPROVED. This is an ongoing research backup, not accepted-root integration. The accepted root, its 110-entry proof/configuration manifest, its 58-entry tooling manifest, and the frozen manuscript remain unchanged.

SOURCE_MAP.json records all {len(source_map)} current untracked Lean sources, with exact hashes and storage either in checkpoint-2 or the new delta. This avoids duplicating unchanged large graph tables. The dynamic worker is active; its source snapshots, logs, fingerprints and receipts are preserved.

Successful current dynamic-worker standalone builds: {', '.join(passed)}. Earlier trial02/trial03 standalone results remain in previous records. None of these new sources has yet received final root integration, global axiom audit and fresh kernel replay. An isolated successful compile is not a main-theorem proof.

The new drafts extend actual Bennett coefficient/root transfer to integer-order inequalities, derive an ordinary height envelope and unit first-extension cutoff, reduce a genuine unit-pair sextuple to real norm-two Pell solutions in one fixed squarefree field parameter, and supply a continued-fraction completeness bridge. Concrete Q and N2 approximation families, one-small finite classifiers, and mixed retained bounds are under development. These statements describe source-level work; their complete dependency chains remain unverified.

Finite data reproduction and independent mathematical reviews are saved separately from kernel certificates. The 48 two-small graphs and the 1016-field Pell certificates are not yet accepted. Expensive explicit finite-set normalization is being replaced by a proved list-enumeration bridge before larger pilots. The exact target still includes all full integer rings, half-integral bases, zero pair roots and norm ties. No custom axioms, sorry/admit or native_decide are used in proposed mathematical sources.

Remaining main obligations include successful compilation of all concrete chains, the remaining finite approximation families and their overlap assemblies, actual analytic cutoffs and finite-case contradictions, root integration and full verification. The two user-requested automations remain paused. This record is not a push receipt.
''')
files = sorted([p for p in DEST.rglob('*') if p.is_file()]+[record])
manifest = {'utc': stamp, 'scope': 'UNACCEPTED RESEARCH DELTA',
            'previous_checkpoint_head': git('rev-parse', 'HEAD'),
            'files': [{'path': str(p.relative_to(ROOT)), 'bytes': p.stat().st_size,
                       'sha256': sha(p.read_bytes())} for p in files]}
(DEST/'MANIFEST.json').write_text(json.dumps(manifest, indent=2)+'\n')
files.append(DEST/'MANIFEST.json')
review = [{'path': str(p.relative_to(ROOT)), 'sha256': sha(p.read_bytes())} for p in files]
(RUN/'checkpoint-3-reviewed-paths.json').write_text(json.dumps(review, indent=2)+'\n')
print(json.dumps({'files': len(files), 'bytes': sum(p.stat().st_size for p in files),
                  'all_current_drafts': len(source_map), 'current_standalone_passes': passed,
                  'scope': 'UNACCEPTED RESEARCH DELTA'}))
