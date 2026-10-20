"""Review exactly three continuation scopes and prepare explicit paths. No Git mutation."""
from pathlib import Path
from datetime import datetime
import ast, fcntl, hashlib, json, re, subprocess
root = Path('/Users/tp/Lean/D1Bound5')
out = Path(__file__).resolve().parent
work = root/'research/continuations/20261018T010800CEST-main-continuation'
scopes = [root/'research/continuations/20261020T012247CEST-a4-continuation',
          root/'research/continuations/20261020T022223CEST-a5-endpoint', out]
def sha(b): return hashlib.sha256(b).hexdigest()
def git(*args): return subprocess.check_output(['git', '-C', str(root), *args])
summary = json.loads((out/'VERIFICATION_SUMMARY.json').read_text())
assert summary['outcome'] == 'COMPLETED_UNIT'
initial = json.loads((out/'INITIAL_STATE.json').read_text())
inherited = initial['inherited_index']
patterns = None
for n in ast.parse((root/'scripts/git_sync_preflight.py').read_text()).body:
    if isinstance(n, ast.Assign) and any(isinstance(t, ast.Name) and t.id == 'TOKEN_PATTERNS' for t in n.targets):
        patterns = ast.literal_eval(n.value)
assert patterns
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner, fcntl.LOCK_EX | fcntl.LOCK_NB)
    fcntl.flock(intake, fcntl.LOCK_EX | fcntl.LOCK_NB)
    active = json.loads((work/'continuation-active.json').read_text())
    assert not active.get('active') and not active.get('protected_closure')
    assert git('branch', '--show-current').decode().strip() == 'main'
    head = git('rev-parse', 'HEAD').decode().strip(); assert head == initial['head']
    assert git('remote', 'get-url', 'origin').decode().strip() in {
        'https://github.com/tomislav-math/d1-bound5-lean.git',
        'https://github.com/tomislav-math/d1-bound5-lean', 'git@github.com:tomislav-math/d1-bound5-lean.git'}
    info = json.loads(subprocess.check_output(['/Users/tp/.local/bin/gh', 'repo', 'view',
        'tomislav-math/d1-bound5-lean', '--json', 'nameWithOwner,visibility,viewerPermission']))
    assert info['visibility'] == 'PRIVATE' and info['viewerPermission'] in ['ADMIN', 'MAINTAIN', 'WRITE']
    current = {p: sha(git('show', ':'+p)) for p in git('diff', '--cached', '--name-only', '-z').decode().split('\0') if p}
    assert current == inherited
    for n, h in json.loads((out/'FINAL_SOURCE_GUARDS.json').read_text()).items():
        assert sha((root/'D1Bound5'/(n+'.lean')).read_bytes()) == h
    for n, h in json.loads((out/'FINAL_ARTIFACT_GUARDS.json').read_text()).items(): assert sha((root/n).read_bytes()) == h
    for v in json.loads((out/'SOURCE_MAP.json').read_text()).values():
        assert sha((root/v['source']).read_bytes()) == v['sha256'] == sha((root/v['snapshot']).read_bytes())
    paths = []
    for scope in scopes:
        paths += [p for p in scope.rglob('*') if p.is_file() and '__pycache__' not in p.parts]
        paths += [p for p in (root/'records/runs').glob(scope.name+'-*') if p.is_file()]
    files = sorted(str(p.relative_to(root)) for p in paths)
    assert len(files) == len(set(files)) and not set(files) & set(inherited)
    reviewed = {}; raw = []; whitespace = {}
    for name in files:
        p = root/name
        assert not p.is_symlink() and p.suffix in ['.lean', '.json', '.md', '.py', '.txt', '.log']
        assert p.stat().st_size <= 5*1024*1024
        b = p.read_bytes(); text = b.decode('utf-8')
        assert not any(re.search(pattern, text) for pattern in patterns), 'Credential-shaped content; value withheld: '+name
        reviewed[name] = {'sha256': sha(b), 'bytes': len(b)}
        if p.suffix in ['.lean', '.log'] or p.name == 'A5CoordinateExamples.txt' or (p.suffix == '.md' and '```diff' in text):
            raw.append(name)
            whitespace[name] = [i for i, line in enumerate(text.splitlines(), 1) if line != line.rstrip()]
    manifest = str((out/'STAGING_PATHS.txt').relative_to(root))
    review = str((out/'STAGING_REVIEW.json').relative_to(root))
    assert manifest not in files and review not in files
    files += [manifest, review]
    (out/'STAGING_PATHS.txt').write_text('\n'.join(files)+'\n')
    reviewed[manifest] = {'sha256': sha((root/manifest).read_bytes()), 'bytes': (root/manifest).stat().st_size}
    (out/'STAGING_REVIEW.json').write_text(json.dumps({'time': datetime.now().astimezone().isoformat(),
        'head': head, 'repository': info, 'files': files, 'reviewed': reviewed, 'inherited_index': inherited,
        'raw_source_log_whitespace_exceptions': raw, 'preserved_whitespace_lines': whitespace,
        'note': 'Three explicit continuation scopes only. Failed trials and prepared sources remain research evidence, not accepted imports. Preserve all inherited staging.'}, indent=2)+'\n')
    print('SCOPED_PRIVATE_REVIEW_PASS', len(files), 'paths;', len(inherited), 'inherited blobs preserved')
