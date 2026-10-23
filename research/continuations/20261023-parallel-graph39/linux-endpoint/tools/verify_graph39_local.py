"""Graph39 original public-type, axiom, and scoped installed-kernel audit."""
from pathlib import Path
import hashlib, json, re, subprocess, time
import guarded_general as g
R = Path(__file__).resolve().parent
O = R / 'results-graph39-verified'
O.mkdir(exist_ok=True)
T = R / 'graph39-transfer'

def save(name, value):
    g.save(O / name, value)

def declarations(text):
    matches = list(re.finditer(r'^(def|theorem)\s+(\S+)\s*(.*?)\s*:=', text, re.M | re.S))
    result = []
    for match in matches:
        stack, opens = [], []
        for line in text[:match.start()].splitlines():
            if line.startswith('namespace '):
                stack.append(line[10:].strip())
            elif line.startswith('end '):
                assert stack
                stack.pop()
            elif line.startswith('open '):
                opens.append(line)
        namespace = '.'.join(stack)
        result.append({'kind': match[1], 'local_name': match[2],
            'name': namespace + '.' + match[2], 'namespace': namespace,
            'opens': list(dict.fromkeys(opens)), 'header': match[3].strip()})
    return result

summary = json.loads((R/'results-graph39-adaptive/SUMMARY.json').read_text())
assert not summary.get('failed') and not summary.get('uncompiled')
assert 'SmallPairGraphData39' in summary['compiled']
manifest = json.loads((T/'effective_manifest.json').read_text())
assert all(g.sha(g.P/'D1Bound5'/n) == h for n, h in manifest.items())
sources = g.closure('SmallPairGraphData39')
artifacts = {n: g.sha(g.artifact(n)) for n in sources}
externals = g.external(sources)
original = declarations((T/'original_merged39.lean').read_text())
assert len(original) == 28
helpers = []
for i in range(15):
    helpers.extend(declarations(g.src(f'SmallPairGraphClosure39Chunk{i:02d}').read_text()))
helpers.extend(declarations(g.src('SmallPairGraphClosure39Coverage').read_text()))
helpers.extend(declarations((T/'failures/SmallPairLightData39LeftCached.original.lean').read_text()))
helpers.extend(d for d in declarations((T/'failures/SmallPairLightAdaptiveData39.original.lean').read_text())
    if d['local_name'].startswith('leftCached'))
decls = original + helpers
names = [d['name'] for d in decls]
assert len(names) == len(set(names)) == 49
audit = ('import D1Bound5.SmallPairGraphData39\n'
    'import Lean.Util.CollectAxioms\nimport Lean.Elab.Command\n'
    'noncomputable section\n'
    'set_option autoImplicit false\nset_option maxRecDepth 100000\n'
    'set_option maxHeartbeats 0\n')
for d in decls:
    assert d['header'].startswith(':')
    audit += ('namespace ' + d['namespace'] + '\n' + '\n'.join(d['opens']) + '\n'
        'example ' + d['header'] + ' := ' + d['local_name'] + '\nend ' + d['namespace'] + '\n')
audit += ('run_cmd do\n  for name in ([' + ', '.join('`'+n for n in names)
    + '] : List Lean.Name) do\n    let ax ← Lean.collectAxioms name\n'
    '    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n\n'
    '    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"\n'
    '    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"\n')
(O/'OriginalTypesAxioms.lean').write_text(audit)
save('ORIGINAL_DECLARATIONS.json', original)
save('PLAN.json', {'source_closure': sources, 'artifacts': artifacts,
    'external_import_artifacts': externals, 'original_public_declarations': 28,
    'helper_declarations': 21, 'main_theorem_complete': False,
    'adaptive_modifier_changes': json.loads((T/'ADAPTIVE_MODIFIER_CHANGES.json').read_text()),
    'modifier_changes': json.loads((T/'DECLARATION_MODIFIER_CHANGES.json').read_text()),
    'left_cached_split': json.loads((T/'LEFT_CACHED_SPLIT.json').read_text())})

def unchanged():
    assert g.closure('SmallPairGraphData39') == sources
    assert {n:g.sha(g.artifact(n)) for n in sources} == artifacts
    assert g.external(sources) == externals

commands = [('original-types-axioms', [str(g.BIN/'lean'), '-j1', str(O/'OriginalTypesAxioms.lean')])]
kernel_targets = [f'SmallPairGraphClosure39Chunk{i:02d}' for i in range(1,15)]
kernel_targets += ['SmallPairGraphClosure39', 'SmallPairGraphArithmetic39',
    'SmallPairRawSelectedData39LeftCached', 'SmallPairRawSelectedData39LeftRows',
    'SmallPairRawSelectedData39RightCached', 'SmallPairRawSelectedData39RightRows',
    'SmallPairLightAssembly39', 'SmallPairGraphTriangle39']
kernel_targets += ['SmallPairLightData39LeftCached']
kernel_targets += [f'SmallPairLightData39LeftCachedChunk{i:02d}' for i in range(4)]
assert len(kernel_targets) == 27
# The unchanged computational helpers are kernel checked by their fresh guarded
# compilation. Replay the full side parent on the current artifact and leave the
# transitive fresh replay to final root integration.
kernel_targets += ['SmallPairLightLeft39', 'SmallPairLightAdaptiveData39']
assert len(kernel_targets) == len(set(kernel_targets)) == 29
commands += [(n+'-kernel', [str(g.BIN/'leanchecker'), '--verbose', 'D1Bound5.'+n]) for n in kernel_targets]
rows = []
for label, cmd in commands:
    unchanged()
    start = time.monotonic()
    save('ACTIVE.json', {'label': label, 'command': cmd, 'status':'RUNNING'})
    with (O/(label+'.log')).open('w') as f:
        try:
            q = subprocess.run(cmd, cwd=g.P, env=g.ENV, stdout=f, stderr=subprocess.STDOUT, timeout=240)
            row = {'label':label,'command':cmd,'exit':q.returncode,'timed_out':False}
        except subprocess.TimeoutExpired:
            row = {'label':label,'command':cmd,'exit':None,'timed_out':True}
    row['seconds'] = round(time.monotonic()-start,3)
    rows.append(row)
    save('AUDIT_RESULTS.json', rows)
    print(json.dumps(row), flush=True)
    assert row['exit'] == 0 and not row['timed_out']
    unchanged()
save('ACTIVE.json', {'status':'FINISHED'})
save('VERIFICATION_SUMMARY.json', {'status':'GRAPH39_ENDPOINT_SCOPED_VERIFICATION_PASS',
    'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),
    'graph':39,'closure_rows':915,'filtered_vertices':914,'left_heads':458,'right_heads':456,
    'original_public_types_checked':28,'additional_helper_types_checked':21,
    'transitive_axioms_allowed':['propext','Classical.choice','Quot.sound'],
    'installed_kernel_scopes':kernel_targets,'source_closure':sources,'artifacts':artifacts,
    'external_import_artifacts':externals,'lean_binary_sha256':g.sha(g.BIN/'lean'),
    'leanchecker_binary_sha256':g.sha(g.BIN/'leanchecker'),
    'toolchain':'4.33.1','mathlib_commit':'0df444a360eaa60ab8c11dca51a86af692955474',
    'source_transfer_manifest':manifest,'compiled_on_new_linux_platform':True,
    'main_theorem_complete':False,'accepted_root_integration':False,
    'modifier_changes':json.loads((T/'DECLARATION_MODIFIER_CHANGES.json').read_text()),
    'adaptive_modifier_changes':json.loads((T/'ADAPTIVE_MODIFIER_CHANGES.json').read_text()),
    'left_cached_split':json.loads((T/'LEFT_CACHED_SPLIT.json').read_text())})
print('GRAPH39_ENDPOINT_SCOPED_VERIFICATION_PASS', flush=True)
