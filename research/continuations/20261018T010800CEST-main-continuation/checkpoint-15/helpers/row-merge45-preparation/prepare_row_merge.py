#!/usr/bin/env python3
"""Prepare a body-preserving single-module graph-row candidate. Never installs/builds it."""
from pathlib import Path
import argparse, base64, hashlib, json, os, re

IMPORT = re.compile(rb'^import ([A-Za-z0-9_.]+)\r?\n$')
ALL_IMPORTS = re.compile(rb'^\s*import\s+([^\n]+)', re.M)
D1_IMPORT = re.compile(rb'\bD1Bound5\.([A-Za-z0-9_]+)')
ROLE_NAMES = (
    'SmallPairGraphInputs', 'SmallPairRawSelectedData', 'SmallPairGraphArithmetic',
    'SmallPairGraphWitnessData', 'SmallPairGraphClosure', 'SmallPairLightAssembly',
    'SmallPairGraphTriangle', 'SmallPairGraphData')
FORBIDDEN = re.compile(r'^\s*(?:private|protected|noncomputable|local|scoped|attribute|'
                       r'instance|macro|syntax|notation|export|variable|universe|section|'
                       r'axiom|opaque|initialize|builtin_initialize|mutual|#)\b', re.M)

def sha(b):
    return hashlib.sha256(b).hexdigest()

def json_bytes(x):
    return (json.dumps(x, indent=2, sort_keys=True) + '\n').encode()

def split_header(b):
    lines = b.splitlines(keepends=True)
    count = 0
    imports = []
    while count < len(lines):
        m = IMPORT.fullmatch(lines[count])
        if not m:
            break
        imports.append(m.group(1).decode())
        count += 1
    if not imports:
        raise ValueError('Expected consecutive plain imports at the beginning')
    header = b''.join(lines[:count])
    body = b''.join(lines[count:])
    if re.search(rb'^\s*import\b', body, re.M):
        raise ValueError('Late/nonstandard import')
    return header, body, imports

def inspect_scopes(body):
    text = body.decode('utf-8')
    if FORBIDDEN.search(text) or re.search(r'^\s*@\[|^\s*(?:unsafe|partial|deriving)\b', text, re.M):
        raise ValueError('Unsupported declaration/command with module or scope risks')
    if re.search(r'\b(?:sorry|admit|native_decide|run_tac)\b', text):
        raise ValueError('Unsupported proof/trust command')
    stack = []
    exports = []
    commands = []
    for line in text.splitlines():
        s = line.strip()
        m = re.fullmatch(r'namespace ([A-Za-z0-9_.]+)', s)
        if m:
            stack.append(m.group(1))
            commands.append(s)
            continue
        m = re.fullmatch(r'end(?: ([A-Za-z0-9_.]+))?', s)
        if m:
            if not stack or (m.group(1) and m.group(1) != stack[-1]):
                raise ValueError('Unbalanced or unsupported namespace end: ' + s)
            stack.pop()
            commands.append(s)
            continue
        if s.startswith('set_option '):
            if not stack or not re.fullmatch(r'set_option (?:maxRecDepth|maxHeartbeats) [0-9]+', s):
                raise ValueError('Unsupported/global option: ' + s)
            commands.append(s)
        elif s.startswith('open '):
            if not stack or not re.fullmatch(r'open [A-Za-z0-9_. ]+', s):
                raise ValueError('Unsupported/global open: ' + s)
            commands.append(s)
        m = re.match(r'^(def|theorem|lemma|abbrev) ([A-Za-z0-9_.]+)\b', s)
        if m:
            if not stack:
                raise ValueError('Unscoped declaration')
            exports.append('.'.join(stack + [m.group(2)]))
    if stack:
        raise ValueError('Unclosed namespace')
    return exports, commands

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project', type=Path, required=True)
    ap.add_argument('--row', type=int, required=True)
    ap.add_argument('--pins', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    if args.row <= 0:
        raise ValueError('Positive row required')
    if os.path.lexists(args.output):
        raise FileExistsError('Output must be new, including no dangling symlink')
    args.output.parent.resolve(strict=True)
    selected = {role + str(args.row) for role in ROLE_NAMES}
    target = 'SmallPairGraphData' + str(args.row)
    pins = json.loads(args.pins.read_text())
    if set(pins) != selected:
        raise ValueError('Pins must specify exactly the eight selected module names')
    originals = {}
    parts = {}
    all_exports = []
    for name in sorted(selected):
        path = args.project / 'D1Bound5' / (name + '.lean')
        if path.is_symlink():
            raise ValueError('Source symlink is unsupported')
        b = path.read_bytes()
        if sha(b) != pins[name]:
            raise ValueError('Source preimage mismatch: ' + name)
        header, body, imports = split_header(b)
        exports, commands = inspect_scopes(body)
        all_exports.extend(exports)
        originals[name] = b
        parts[name] = {'header': header, 'body': body, 'imports': imports,
                       'exports': exports, 'commands': commands}
    if len(all_exports) != len(set(all_exports)):
        raise ValueError('Duplicate public declaration names')

    # Traverse the original target's imports in their original order.
    # Emit absorbed bodies in postorder; collect external imports at first encounter.
    body_order, external, seen, visiting = [], [], set(), set()
    def visit(name):
        if name in visiting:
            raise ValueError('Internal cycle')
        if name in seen:
            return
        visiting.add(name)
        for dep in parts[name]['imports']:
            short = dep[len('D1Bound5.'):] if dep.startswith('D1Bound5.') else dep
            if dep.startswith('D1Bound5.') and short in selected:
                visit(short)
            elif dep not in external:
                external.append(dep)
        visiting.remove(name)
        seen.add(name)
        body_order.append(name)
    visit(target)
    if seen != selected:
        raise ValueError('The target does not reach exactly all eight selected bodies')

    graph = {}
    graph_hashes = {}
    for path in sorted((args.project / 'D1Bound5').glob('*.lean')):
        b = path.read_bytes()
        deps = []
        for line in ALL_IMPORTS.findall(b):
            deps.extend(x.decode() for x in D1_IMPORT.findall(line.split(b'--', 1)[0]))
        graph[path.stem] = deps
        graph_hashes[path.stem] = sha(b)
    root_imports = {}
    for path in sorted(args.project.glob('*.lean')):
        if path.name == 'lakefile.lean':
            continue
        deps = []
        for line in ALL_IMPORTS.findall(path.read_bytes()):
            deps.extend(x.decode() for x in D1_IMPORT.findall(line.split(b'--', 1)[0]))
        root_imports[path.name] = deps
    outside_consumers = {
        n: sorted([k for k, deps in graph.items() if k not in selected and n in deps] +
                  [k for k, deps in root_imports.items() if n in deps])
        for n in sorted(selected)}
    if any(outside_consumers[n] for n in selected - {target}):
        raise ValueError('Outside consumers of an absorbed module require a separate plan')
    def closure(start):
        out, todo = set(), list(start)
        while todo:
            n = todo.pop()
            if n not in out:
                if n not in graph:
                    raise ValueError('Missing source dependency: ' + n)
                out.add(n)
                todo.extend(graph[n])
        return out
    original_closure = closure([target])
    ext_d1 = [x[len('D1Bound5.'):] for x in external if x.startswith('D1Bound5.')]
    external_closure = closure(ext_d1)
    if selected & external_closure:
        raise ValueError('External import reaches an absorbed module')
    if original_closure - selected != external_closure:
        raise ValueError('Changed transitive external dependency closure')

    candidate = ''.join('import ' + name + '\n' for name in external).encode() + b'\n'
    records = {}
    for name in body_order:
        body = parts[name]['body']
        marker = ('/- Preserved body from D1Bound5.' + name +
                  '; original SHA256 ' + pins[name] + '. -/\n').encode()
        candidate += marker
        offset = len(candidate)
        candidate += body
        records[name] = {
            'source_sha256': pins[name], 'source_bytes': len(originals[name]),
            'source_base64': base64.b64encode(originals[name]).decode(),
            'header_base64': base64.b64encode(parts[name]['header']).decode(),
            'body_sha256': sha(body), 'body_bytes': len(body),
            'candidate_body_byte_start': offset, 'candidate_body_byte_end': len(candidate),
            'imports': parts[name]['imports'], 'exported_names': parts[name]['exports'],
            'scope_commands': parts[name]['commands']}
        candidate += b'\n'
    for name, rec in records.items():
        a, b = rec['candidate_body_byte_start'], rec['candidate_body_byte_end']
        if candidate[a:b] != parts[name]['body']:
            raise AssertionError('Body preservation failed')
    for name, b in originals.items():
        if (args.project / 'D1Bound5' / (name + '.lean')).read_bytes() != b:
            raise RuntimeError('Source changed while preparing')
    manifest = {
        'schema': 1, 'row': args.row, 'candidate_module': target,
        'candidate_sha256': sha(candidate), 'candidate_bytes': len(candidate),
        'body_order': body_order, 'external_imports_original_first_encounter_order': external,
        'external_D1_source_closure': {n: graph_hashes[n] for n in sorted(external_closure)},
        'outside_import_consumers': outside_consumers,
        'exported_names': all_exports, 'exported_name_count': len(all_exports),
        'originals': records,
        'verification': {
            'all_full_original_preimages_embedded': True,
            'all_import_stripped_bodies_byte_identical': True,
            'namespaces_balanced': True,
            'options_and_opens_remain_in_original_namespace_scopes': True,
            'private_or_module_sensitive_declarations_detected': False,
            'external_transitive_closure_unchanged': True,
            'outside_consumers_of_absorbed_modules': False,
            'project_or_queue_modified': False, 'kernel_compilation_performed': False},
        'limitations': [
            'Byte preservation is source-level evidence, not kernel acceptance.',
            'All external imports are available before the first body; kernel checking must confirm elaboration.',
            'Original public declarations keep their textual names/types/proofs; their owning Lean module changes.',
            'Original seven absorbed source files remain untouched. Root must separately plan scheduling/import use.',
            'No runtime or memory claim; the 600-second merged pilot must be measured.']}
    args.output.mkdir(exist_ok=False)
    with (args.output / (target + '.lean')).open('xb') as f:
        f.write(candidate)
    mb = json_bytes(manifest)
    with (args.output / 'manifest.json').open('xb') as f:
        f.write(mb)
    print(json.dumps({
        'output': str(args.output), 'candidate_sha256': sha(candidate),
        'manifest_sha256': sha(mb), 'candidate_bytes': len(candidate),
        'body_order': body_order, 'external_imports': external,
        'exported_names': all_exports, 'outside_import_consumers': outside_consumers,
        'external_D1_count': len(external_closure)}))

if __name__ == '__main__':
    main()
