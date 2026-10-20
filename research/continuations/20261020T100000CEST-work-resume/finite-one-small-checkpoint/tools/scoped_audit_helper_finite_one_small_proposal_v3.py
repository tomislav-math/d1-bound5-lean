"""Fail-closed SOURCE audit preparation proposal; NEVER invokes Lean or Git.

Supported source subset: column-zero commands, nested named namespaces/sections,
open/universe/variable/include/omit directives, ordinary def/abbrev/theorem,
unparameterized explicit-field structures, anonymous/named instances.
This is a bounded lexical scanner, not a replacement for Lean's parser.
Original/current headers and lexical contexts must match; proof bodies may differ.
Version 2 closes every named namespace/section with its exact frame name.
Only --prepare writes, exclusively into a previously nonexistent child folder.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re
import sys

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT / 'research/continuations/20261020T100000CEST-work-resume'
IDENT = r"[A-Za-z_\u0080-\uffff][\w'\u0080-\uffff]*(?:\.[A-Za-z_\u0080-\uffff][\w'\u0080-\uffff]*)*"
CMD = re.compile(r'^(?:(?:noncomputable|protected|private)\s+)?'
                 r'(?:namespace|section|end|open|universe|variable|include|omit|set_option|'
                 r'import|def|abbrev|theorem|structure|instance|axiom|opaque|inductive|'
                 r'mutual|macro|syntax|notation|local|scoped|export|attribute|class|example|'
                 r'initialize|builtin_initialize|deriving|elab|infixl|infixr|prefix|postfix|'
                 r'constant|axioms|lemma|#[A-Za-z_][A-Za-z_0-9]*)\b', re.M)
DECL = re.compile(r'(?:(noncomputable|protected|private)\s+)?'
                  r'(def|abbrev|theorem|structure|instance)\b(?:\s+(' + IDENT + '))?')


def require(ok, message):
    if not ok:
        raise ValueError(message)


def masked(text):
    """Mask nested comments and strings, retaining character offsets/newlines."""
    out = list(text)
    i = 0
    depth = 0
    string = False
    while i < len(text):
        if depth:
            if text.startswith('/-', i):
                out[i:i+2] = '  '; depth += 1; i += 2; continue
            if text.startswith('-/', i):
                out[i:i+2] = '  '; depth -= 1; i += 2; continue
            if text[i] != '\n': out[i] = ' '
            i += 1; continue
        if string:
            if text[i] == '\\':
                out[i] = ' '; i += 1
                if i < len(text): out[i] = ' '; i += 1
                continue
            if text[i] == '"': string = False
            if text[i] != '\n': out[i] = ' '
            i += 1; continue
        if text.startswith('/-', i):
            out[i:i+2] = '  '; depth = 1; i += 2; continue
        if text.startswith('--', i):
            while i < len(text) and text[i] != '\n': out[i] = ' '; i += 1
            continue
        if text[i] == '"': out[i] = ' '; string = True
        i += 1
    require(not depth and not string, 'Unclosed comment/string')
    return ''.join(out)


def top_tokens(text):
    """Balanced delimiter check and depth-zero tokens with exact source offsets."""
    s = masked(text)
    pattern = re.compile(r':=|[()\[\]{}]|' + IDENT + r'|\S')
    stack = []
    match = {')': '(', ']': '[', '}': '{'}
    result = []
    for m in pattern.finditer(s):
        t = m.group()
        if t in '([{':
            stack.append(t)
        elif t in ')]}':
            require(stack and stack.pop() == match[t], 'Unbalanced delimiters')
        elif not stack:
            result.append((t, m.start(), m.end()))
    require(not stack, 'Unclosed delimiter')
    return result


def header(body, kind):
    """Find declaration assignment, allowing simple let bindings in result types.

    Ambiguous by-block let values and multiple let binders are rejected. Proof
    bodies need not be scanned as types after the first certified boundary.
    """
    toks = top_tokens(body)
    pending_let = 0
    let_assigned = False
    for i, (t, a, b) in enumerate(toks):
        if t == 'let':
            require(not pending_let, 'Nested depth-zero let: manual audit required')
            pending_let = 1; let_assigned = False
        elif t == ':=':
            if pending_let:
                require(not let_assigned, 'Ambiguous let assignment')
                require(i+1 < len(toks) and toks[i+1][0] != 'by',
                        'by-valued header let: manual audit required')
                let_assigned = True
            else:
                require(kind != 'theorem' or (i+1 < len(toks) and toks[i+1][0] == 'by'),
                        'Term-proof theorem: explicit manual boundary required')
                return body[:a].rstrip()
        elif t in (';', 'in') and pending_let:
            require(let_assigned, 'Unassigned let in header')
            pending_let = 0
    raise ValueError('No certified declaration assignment boundary')


def binders(text):
    """Return simple named binder groups before the outer result-type colon."""
    s = masked(text)
    groups = []
    stack = []
    start = None
    pairs = {')': '(', ']': '[', '}': '{'}
    for i, ch in enumerate(s):
        if ch == ':' and not stack: break
        if ch in '([{':
            if not stack: start = i
            stack.append(ch)
        elif ch in ')]}':
            require(stack and stack.pop() == pairs[ch], 'Malformed binder')
            if not stack:
                content = s[start+1:i]
                if ':' not in content:
                    require(s[start] == '[', 'Unnamed explicit binder unsupported')
                    continue
                names = content.split(':', 1)[0].strip().split()
                require(all(re.fullmatch(IDENT, x) and '.' not in x and x != '_' for x in names),
                        'Non-simple binder names: ' + repr(names))
                groups.extend((x, s[start], content.split(':', 1)[1].strip()) for x in names)
    return groups


def fq(namespace, name):
    if name.startswith('_root_.'): return name[len('_root_.'):]
    return '.'.join(namespace + [name])


def parse(text):
    s = masked(text)
    # Attributes are not reproduced: they affect registration, not theorem type.
    # Same-line attributes are masked to retain the declaration command position.
    s = re.sub(r'^(@\[[^\n]*?\])[ \t]*', lambda m: ' ' * len(m.group()), s, flags=re.M)
    # Leading spaces introduced by same-line attributes only are accepted.
    starts = list(CMD.finditer(s))
    attr_starts = list(re.finditer(r'^[ ]+(?=(?:def|theorem|abbrev|structure)\b)', s, re.M))
    for m in attr_starts:
        require(text[m.start():m.end()].lstrip().startswith('@['),
                'Indented declaration command: manual audit required')
        q = CMD.match(s, m.end())
        # CMD's ^ is not valid in mid-line; detect the declaration directly.
        if q is None: q = DECL.match(s, m.end())
        require(q is not None, 'Attribute declaration parse failure')
        starts.append(q)
    starts.sort(key=lambda m: m.start())
    frames = [{'opener': None, 'name': None, 'namespace': [], 'directives': []}]
    declarations = []
    skipped = []
    imports = []
    for idx, m in enumerate(starts):
        stop = starts[idx+1].start() if idx+1 < len(starts) else len(text)
        raw = text[m.start():stop].rstrip()
        clean = s[m.start():stop].strip()
        first = clean.split(None, 1)[0]
        if first in ('namespace', 'section'):
            line = clean.splitlines()[0]
            parts = line.split()
            require(len(parts) <= 2 and (first == 'section' or len(parts) == 2), 'Bad scope opener')
            require(not clean[len(line):].strip(), 'Unexpected text after scope opener')
            name = parts[1] if len(parts) == 2 else None
            require(name is None or re.fullmatch(IDENT, name), 'Unsupported scope name')
            ns = frames[-1]['namespace'][:]
            if first == 'namespace': ns = fq(ns, name).split('.')
            frames.append({'opener': line, 'name': name, 'namespace': ns, 'directives': []})
        elif first == 'end':
            parts = clean.split()
            require(len(frames) > 1 and len(parts) <= 2, 'Unmatched end')
            require(len(parts) == 1 or parts[1] == frames[-1]['name'], 'Mismatched named end')
            frames.pop()
        elif first == 'import':
            imports.append(clean)
        elif first in ('#check', '#print'):
            skipped.append({'kind': 'diagnostic_command', 'command': clean})
        elif first in ('open', 'universe', 'variable', 'include', 'omit'):
            require(not re.search(r'\bin\s*$', clean), 'Command-scoped directive unsupported')
            if first == 'variable': binders(clean[len('variable'):])
            frames[-1]['directives'].append(clean)
        elif first == 'set_option':
            require(not re.search(r'\bin\s*$', clean), 'Command-scoped option unsupported')
            require(len(clean.split()) == 3, 'Complex option command unsupported')
            option = clean.split()[1]
            # Resource controls do not affect the original statement context.
            if option not in ('maxHeartbeats', 'maxRecDepth', 'autoImplicit'):
                frames[-1]['directives'].append(clean)
        else:
            decl = DECL.match(clean)
            require(decl is not None, 'Unsupported command: ' + first)
            modifier, kind, name = decl.groups()
            require(modifier not in ('private', 'protected'), 'Non-public name requires manual audit')
            if kind == 'instance' and name is None:
                skipped.append({'kind': 'anonymous_instance', 'line': text.count('\n', 0, m.start())+1})
                continue
            require(name is not None, 'Missing declaration name')
            # raw can have comments unlike clean; locate name in its masked view.
            match = DECL.match(s[m.start():stop].lstrip())
            body = raw[match.end():]
            require(not body.lstrip().startswith('.{'), 'Explicit universe suffix: manual audit required')
            context = json.loads(json.dumps(frames))
            item = {'kind': kind, 'name': fq(frames[-1]['namespace'], name),
                    'local_name': name, 'context': context, 'line': text.count('\n', 0, m.start())+1}
            if kind == 'structure':
                require(re.match(r'^\s+where\b', body), 'Parameterized/extended structure unsupported')
                fields = []
                for line in masked(body).splitlines()[1:]:
                    if not line.strip() or line.strip().startswith('deriving '): continue
                    f = re.fullmatch(r'\s+(' + IDENT + r')\s*:\s*(.+?)\s*', line)
                    require(f is not None, 'Grouped/complex structure field: ' + line)
                    fields.append((f.group(1), f.group(2)))
                require(fields, 'No explicit structure fields')
                item['fields'] = fields
                item['header'] = body
            else:
                item['header'] = header(body, kind)
            declarations.append(item)
    require(len(frames) == 1, 'Unclosed source scope')
    require(len({x['name'] for x in declarations}) == len(declarations), 'Duplicate declaration names')
    return {'declarations': declarations, 'skipped': skipped, 'imports': imports}


EXPECTED = {
    'D1Bound5.FirstPairGeometryRow': [('tau', 'ℤ'), ('nu', 'ℤ'), ('a', 'ℤ × ℤ'), ('b', 'ℤ × ℤ')] +
        [(n, 'ℚ') for n in ('A1', 'B0', 'B1', 'd1', 'M2', 'Mn', 'M3', 'M4', 'M5')],
    'D1Bound5.OneSmallCutoffRow': [('triple', 'OneSmallTripleRow')] +
        [(n, 'ℚ') for n in ('q1', 'phi1', 'q', 'M2', 'Mn', 'M3', 'M4', 'M5', 'Mbs')]
}


def intended_structure(text):
    """Only the two reviewed grouped-field repairs may differ from original."""
    for full, fields in EXPECTED.items():
        name = full.rsplit('.', 1)[1]
        p = re.compile(r'(structure ' + name + r' where\n)(.*?)(  deriving DecidableEq)', re.S)
        m = p.search(text)
        if m:
            expanded = []
            for line in m.group(2).splitlines():
                require(':' in line, 'Unexpected original structure line')
                names, typ = line.strip().split(':', 1)
                expanded.extend((n, typ.strip()) for n in names.split())
            require(expanded == fields, 'Original intended field list changed: ' + full)
            replacement = m.group(1) + ''.join('  ' + n + ' : ' + t + '\n' for n, t in fields) + m.group(3)
            text = text[:m.start()] + replacement + text[m.end():]
    return text


def render_context(item, middle):
    lines = ['section']
    for frame in item['context']:
        if frame['opener']: lines.append(frame['opener'])
        lines.extend(frame['directives'])
    # Enforce at the nearest scope, after all original directives.
    lines.append('set_option autoImplicit false')
    lines.append(middle)
    lines.extend('end ' + frame['name'] if frame['name'] else 'end'
                 for frame in reversed(item['context']) if frame['opener'])
    lines.append('end')
    return '\n'.join(lines) + '\n'


def exact_example(item):
    h = item['header']
    explicit = [n for n, bracket, _ in binders(h) if bracket == '(']
    variables = {}
    included = set()
    for frame in item['context']:
        for directive in frame['directives']:
            if directive.startswith('variable '):
                variables.update({n: (bracket, typ) for n, bracket, typ in binders(directive[8:])})
            elif directive.startswith('include '): included.update(directive.split()[1:])
            elif directive.startswith('omit '): included.difference_update(directive.split()[1:])
    # Named argument application avoids accidentally shifting explicit parameters.
    used = set(re.findall(IDENT, masked(h))) | included
    changed = True
    while changed:
        old = used.copy()
        for n, (_, typ) in variables.items():
            if n in used: used.update(re.findall(IDENT, masked(typ)))
        changed = used != old
    section_args = [n for n, (bracket, _) in variables.items() if bracket == '(' and n in used and n not in explicit]
    args = section_args + explicit
    require(len(args) == len(set(args)), 'Duplicate explicit arguments')
    call = '_root_.' + item['name'] + ''.join(' (' + n + ' := ' + n + ')' for n in args)
    return render_context(item, 'example' + h + ' := by\n  exact ' + call)


def structure_checks(item):
    name = item['name']
    fields = [tuple(x) for x in item['fields']]
    expected = EXPECTED.get(name)
    if name == 'D1Bound5.OneSmallTripleRow':
        expected = [('tau', 'ℤ'), ('nu', 'ℤ'), ('a', 'ℤ × ℤ'),
                    ('b', 'ℤ × ℤ'), ('s', 'ℤ × ℤ'), ('cutoff', 'ℤ')]
    require(expected is not None and fields == expected,
            'Unreviewed structure signature: ' + name)
    bind = ' '.join('(' + n + ' : ' + t + ')' for n, t in fields)
    function_type = ' → '.join('(' + t + ')' for _, t in fields) + ' → _root_.' + name
    code = ['example : ' + function_type + ' := @_root_.' + name + '.mk',
            'example ' + bind + ' : _root_.' + name + ' :=\n  _root_.' + name + '.mk' +
            ''.join(' (' + n + ' := ' + n + ')' for n, _ in fields)]
    for n, typ in fields:
        code.append('example (r : _root_.' + name + ') : ' + typ + ' := r.' + n)
        code.append('example ' + bind + ' : (_root_.' + name + '.mk ' +
                    ' '.join(n2 for n2, _ in fields) + ').' + n + ' = ' + n + ' := rfl')
    return render_context(item, '\n'.join(code))


def prepare(names, originals, current_sources=None):
    require(names and len(names) == len(set(names)), 'Duplicate/empty targets')
    records = []
    declarations = []
    examples = []
    snapshots = {}
    for module in names:
        require(re.fullmatch(IDENT, module) and '.' not in module, 'Unsafe module name')
        original_path = Path(originals[module])
        require(original_path.resolve() != (ROOT / 'D1Bound5' / (module + '.lean')).resolve(),
                'Original must be an independent preserved snapshot, not live source')
        original_bytes = original_path.read_bytes()
        current_bytes = (ROOT / 'D1Bound5' / (module + '.lean')).read_bytes() if current_sources is None else current_sources[module]
        normalized_original = intended_structure(original_bytes.decode())
        old = parse(normalized_original)
        new = parse(current_bytes.decode())
        def semantic(d):
            return {k: v for k, v in d.items() if k != 'line'}
        require([semantic(d) for d in old['declarations']] == [semantic(d) for d in new['declarations']],
                'Original declaration signatures/contexts differ: ' + module)
        require(old['imports'] == new['imports'], 'Original imports differ: ' + module)
        names_for_axioms = []
        for item in old['declarations']:
            names_for_axioms.append(item['name'])
            if item['kind'] == 'theorem': examples.append(exact_example(item))
            if item['kind'] == 'structure':
                examples.append(structure_checks(item))
                names_for_axioms += [item['name'] + '.mk'] + [item['name'] + '.' + n for n, _ in item['fields']]
        declarations += names_for_axioms
        snapshots[module + '.lean'] = current_bytes
        records.append({'module': module, 'original_path': str(original_path),
                        'original_sha256': hashlib.sha256(original_bytes).hexdigest(),
                        'current_sha256': hashlib.sha256(current_bytes).hexdigest(),
                        'normalizations': ([] if normalized_original == original_bytes.decode() else
                            ['Explicit reviewed grouped-structure field expansion; this repairs the intended record shape, not an unchanged elaborated constructor.']),
                        'declarations': old['declarations'], 'not_individually_inventoried': new['skipped']})
    require(len(set(declarations)) == len(declarations), 'Repeated audit declaration')
    code = '\n'.join('import D1Bound5.' + n for n in names)
    code += '\nimport Lean.Elab.Command\nimport Lean.Util.CollectAxioms\nset_option autoImplicit false\n'
    code += 'set_option maxRecDepth 32768\nrun_cmd do\n  let names : List Lean.Name := [\n'
    code += ',\n'.join('    `' + n for n in declarations) + ']\n'
    code += '''  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"
'''
    code += '\n'.join('#check @_root_.' + n for n in declarations) + '\n\n' + '\n'.join(examples)
    return {'TARGETS.json': names, 'SCOPED_ORIGINAL_DECLARATIONS.json': records,
            'DECLARATION_NAMES.json': declarations}, snapshots, code


def self_test():
    fixture = '''import Mathlib
open Nat
namespace Outer
universe u
variable {α : Type u}
section S
variable (x : α)
open List
namespace Inner
theorem same (y : α) : let z := x; z = x := by
  rfl
end Inner
end S
theorem root_ok : True := by
  trivial
end Outer
'''
    result = parse(fixture)
    a, b = result['declarations']
    require(a['name'] == 'Outer.Inner.same' and b['name'] == 'Outer.root_ok', 'Namespace test')
    require('(x := x)' in exact_example(a) and '(y := y)' in exact_example(a), 'Section argument test')
    require('variable (x : α)' not in exact_example(b) and 'open List' not in exact_example(b), 'Scope leakage test')
    require('let z := x; z = x' in a['header'], 'Let signature truncation test')
    require(masked('/- outer /- nested -/ -/\n"namespace Bad"\n-- theorem bad\n').strip() == '', 'Lexical mask test')
    attrs = parse('namespace A\n@[simp] theorem a : True := by trivial\n@[simp]\ntheorem b : True := by trivial\nend A\n')
    require([d['name'] for d in attrs['declarations']] == ['A.a', 'A.b'], 'Attribute handling test')
    scoped = parse('namespace A.B\nsection\nvariable (n : Nat)\ninclude n\ntheorem a : True := by trivial\nend\nend A.B\n')
    require('(n := n)' in exact_example(scoped['declarations'][0]), 'Include directive test')
    require(exact_example(a).endswith('end Inner\nend S\nend Outer\nend\n'), 'Named nested scope closure test')
    require(exact_example(scoped['declarations'][0]).endswith('end\nend A.B\nend\n'), 'Anonymous versus named scope closure test')
    rejected = 0
    for bad in ['namespace A\nend B\n', 'namespace A\n', 'axiom bad : False\n',
                'theorem x : True := True.intro\n', 'theorem x : let y := by exact 1; y=y := by rfl\n',
                'structure X where\n  a b : Nat\n', 'theorem x.{u} : True := by trivial\n']:
        try: parse(bad)
        except ValueError: rejected += 1
        else: raise ValueError('Expected closed rejection: ' + bad)
    return {'status': 'PYTHON_PARSER_TESTS_PASS_NOT_LEAN', 'positive_cases': 10, 'negative_cases': rejected}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--self-test', action='store_true')
    parser.add_argument('--prepare', help='New direct child of this run; refuses overwrite')
    parser.add_argument('--original-map', help='JSON module -> explicit original snapshot path')
    parser.add_argument('modules', nargs='*')
    args = parser.parse_args()
    if args.self_test:
        print(json.dumps(self_test(), indent=2)); return
    require(args.original_map and args.modules, 'Explicit original map and targets required')
    original_map = json.loads(Path(args.original_map).read_text())
    records, snapshots, code = prepare(args.modules, original_map)
    if not args.prepare:
        print(json.dumps({'status': 'SOURCE_PREPARATION_CHECK_ONLY_NOT_LEAN',
                          'modules': args.modules, 'declaration_names': len(records['DECLARATION_NAMES.json'])}, indent=2))
        return
    out = RUN / args.prepare
    require(out.parent == RUN and not out.exists() and args.prepare not in ('', '.', '..'), 'Unsafe/existing output folder')
    out.mkdir()
    for name, data in records.items(): (out / name).write_text(json.dumps(data, indent=2) + '\n')
    for name, data in snapshots.items(): (out / name).write_bytes(data)
    source_map = {n: {'source': 'D1Bound5/' + n + '.lean',
                      'snapshot': str((out / (n + '.lean')).relative_to(ROOT)),
                      'sha256': hashlib.sha256(snapshots[n + '.lean']).hexdigest()}
                  for n in args.modules}
    (out / 'SOURCE_MAP.json').write_text(json.dumps(source_map, indent=2) + '\n')
    (out / 'AnalyticAudit.lean').write_text(code)
    (out / 'PREPARED_NOT_COMPILED.txt').write_text('No Lean compilation or axiom verification has been run by this helper.\n')
    print('SCOPED_AUDIT_PREPARED_NOT_RUN', out)


if __name__ == '__main__':
    main()
