#!/usr/bin/env python3
"""Fail-closed production-source policy. This is not a Lean/kernel proof gate.

All review exceptions are explicit, repository-relative data beside this file.
No candidate checkout, compiler artifacts, network or private paths are used.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import sys

HERE = Path(__file__).resolve().parent
MODULE = re.compile(r"[A-Za-z_][A-Za-z0-9_']*(?:\.[A-Za-z_][A-Za-z0-9_']*)*\Z")
RULES = {
    'forbidden_proof_or_execution': r'\b(?:sorry|admit|sorryAx|axiom|constant|constants|unsafe|native_decide|native_decide_term|implemented_by|extern|ofReduce\w*|run_tac|run_cmd|run_elab)\b|\+\s*native\b',
    'kernel_or_trust_override': r'\b(?:skipKernelTC|skipKernelTypeChecking|trustLevel|trust_level|trustKernel|enableKernel|disableKernel)\b',
    'environment_mutation': r'\b(?:setEnv|modifyEnv|modifyEnvImpl|addDecl|addAndCompile|addAndCompileDecl|addDeclCore|addConstInfo|setEnvUnsafe|importModules)\b|\b(?:Environment|env)\.(?:add|set|insert|modify)\b',
    'metaprogramming_review': r'\b(?:elab|elab_rules|macro|macro_rules|initialize|builtin_initialize|notation|syntax|infix|infixl|infixr|prefix|postfix)\b|#eval\b',
    'meta_namespace_review': r'\b(?:Meta|Elab|Lean\.Environment)\b',
    'opaque_or_interpolated_code_review': r'\bopaque\b|\b(?:s|m|f)!',
}
PATTERNS = {name: re.compile(pattern) for name, pattern in RULES.items()}
OPTION = re.compile(r'\bset_option\s+(\S+)\s+([^\n]+)')
IMPORT = re.compile(r'(?:(?:public|private|meta)\s+)*import\s+(.+)\Z')


def sha(data):
    return hashlib.sha256(data).hexdigest()


def under(path, root):
    try:
        path.resolve().relative_to(root.resolve())
        return True
    except ValueError:
        return False


def letter_like(c):
    """Lean 4.33.1 Init.Meta.Defs.isLetterLike, not Python Unicode isalpha."""
    n = ord(c)
    return ((0x3B1 <= n <= 0x3C9 and n != 0x3BB)
            or (0x391 <= n <= 0x3A9 and n not in {0x3A0, 0x3A3})
            or 0x3CA <= n <= 0x3FB or 0x1F00 <= n <= 0x1FFE
            or 0x2100 <= n <= 0x214F or 0x1D49C <= n <= 0x1D59F
            or (0xC0 <= n <= 0xFF and n not in {0xD7, 0xF7})
            or 0x100 <= n <= 0x17F)


def id_first(c):
    return 'a' <= c <= 'z' or 'A' <= c <= 'Z' or c == '_' or (c > '\x7f' and letter_like(c))


def id_rest(c):
    n = ord(c)
    return (id_first(c) or '0' <= c <= '9' or c in "'!?"
            or 0x2080 <= n <= 0x2089 or 0x2090 <= n <= 0x209C
            or 0x1D62 <= n <= 0x1D6A or n == 0x2C7C)


def clean_lean(text):
    """Return code and comment-free text, preserving offsets and newlines.

String contents remain in the second result for the historic conservative
forbidden-token policy. Interpolated-string syntax is itself review-required.
"""
    code = list(text)
    comments_removed = list(text)
    i, n = 0, len(text)

    def blank(target, start, end):
        for k in range(start, end):
            if target[k] != '\n':
                target[k] = ' '

    while i < n:
        if text.startswith('--', i):
            end = text.find('\n', i)
            end = n if end < 0 else end
            blank(code, i, end)
            blank(comments_removed, i, end)
            i = end
        elif text.startswith('/-', i):
            start, depth = i, 1
            i += 2
            while i < n and depth:
                if text.startswith('/-', i):
                    depth += 1
                    i += 2
                elif text.startswith('-/', i):
                    depth -= 1
                    i += 2
                else:
                    i += 1
            if depth:
                raise ValueError('Unterminated nested comment')
            blank(code, start, i)
            blank(comments_removed, start, i)
        elif text[i] == '«':
            # Quotes and comment delimiters inside escaped identifiers are inert.
            # Keep their spelling visible to conservative forbidden-token rules.
            end = text.find('»', i + 1)
            if end < 0:
                raise ValueError('Unterminated escaped identifier')
            i = end + 1
        elif (text[i] in {'∑', '∏'} and text.startswith("'", i + 1)
              and i + 2 < n and text[i + 2].isspace() and not text.startswith("'", i + 3)):
            # Standard spaced Mathlib tsum/tprod tokens include their prime.
            # Do not assume this tokenization where a valid Char could start.
            i += 2
        elif text[i] == 'r' and (match := re.match(r'r(#+|)"', text[i:])):
            start = i
            terminator = '"' + match.group(1)
            end = text.find(terminator, i + len(match.group(0)))
            if end < 0:
                raise ValueError('Unterminated raw string')
            i = end + len(terminator)
            blank(code, start, i)
        elif text[i] == "'" and not text.startswith("''", i):
            # Match Lean.Parser.charLitFnAux/quotedCharCoreFn. Identifier primes
            # are consumed as part of identifiers below and cannot enter here.
            start = i
            i += 1
            if i >= n:
                raise ValueError('Unterminated character literal')
            if text[i] == '\\':
                i += 1
                if i >= n:
                    raise ValueError('Unterminated character escape')
                escape = text[i]
                i += 1
                if escape in {'x', 'u'}:
                    count = 2 if escape == 'x' else 4
                    digits = text[i:i + count]
                    if len(digits) != count or not re.fullmatch(r'[0-9a-fA-F]+', digits):
                        raise ValueError('Invalid hexadecimal character escape')
                    i += count
                elif escape not in '\\"\'rnt':
                    raise ValueError('Invalid character escape')
            else:
                i += 1
            if i >= n or text[i] != "'":
                raise ValueError('Unterminated character literal')
            i += 1
            blank(code, start, i)
        elif text.startswith("''", i):
            # Lean tokenFnAux explicitly does not start a Char literal here.
            i += 2
        elif id_first(text[i]):
            i += 1
            while i < n and id_rest(text[i]):
                i += 1
        elif text[i] == '"':
            start = i
            i += 1
            while i < n:
                if text[i] == '\\':
                    i += 2
                elif text[i] == '"':
                    i += 1
                    break
                else:
                    i += 1
            else:
                raise ValueError('Unterminated string')
            blank(code, start, min(i, n))
        else:
            i += 1
    return ''.join(code), ''.join(comments_removed)


def finding_allowed(row, source_sha, policy):
    # Review data cannot create a blanket exception for a forbidden construct.
    if not (row['category'] == 'meta_namespace_review' and row['token'] == 'Elab'
            and row['source_line'] == 'import Lean.Elab.Tactic.Omega'):
        return False
    expected = dict(row, source_sha256=source_sha,
                    disposition='BENIGN_STANDARD_TACTIC_IMPORT')
    return expected in policy['reviewed_findings']


def option_allowed(row, source_sha, policy):
    name, value = row['name'], row['value']
    if name in {'maxRecDepth', 'maxHeartbeats'} and re.fullmatch(r'[0-9]+(?:\s+in)?', value):
        disposition = 'RESOURCE_LIMIT_ONLY'
    elif name == 'autoImplicit' and value == 'false':
        disposition = 'EXPLICIT_IMPLICIT_PARAMETER_POLICY'
    elif name == 'compiler.extract_closed' and value == 'false':
        return dict(row, source_sha256=source_sha,
                    disposition='BENIGN_CODE_GENERATION_OPTION') in policy['reviewed_codegen_options']
    else:
        return False
    return any(x['name'] == name and x['value'] == value and x['disposition'] == disposition
               for x in policy['reviewed_resource_options'])


def audit(project, root_module, policy):
    project = Path(project).resolve()
    if not MODULE.fullmatch(root_module):
        raise ValueError('Unsupported root module identifier')
    namespace = root_module.split('.')[0]
    if policy['schema'] != 1 or policy['namespace'] != namespace:
        raise ValueError('Unsupported review manifest schema/namespace')
    paths = [project / (namespace + '.lean')]
    paths += sorted((project / namespace).rglob('*.lean'))
    sources, imports, findings, options, ordinary, errors = {}, {}, [], [], [], []
    for path in (project / namespace).rglob('*'):
        if path.is_symlink() and path.is_dir():
            errors.append('Symlinked production directory requires explicit review: ' + str(path.relative_to(project)))
    theorem_count = 0
    for path in paths:
        relative = path.relative_to(project)
        name = '.'.join(relative.with_suffix('').parts)
        if not MODULE.fullmatch(name):
            errors.append('Unsupported production module path: ' + str(relative))
            continue
        if not path.is_file():
            errors.append('Missing production source: ' + str(relative))
            continue
        if not under(path, project):
            errors.append('Production source escapes checkout: ' + str(relative))
            continue
        raw = path.read_bytes()
        sources[name] = {'relative_path': str(relative), 'bytes': len(raw), 'sha256': sha(raw)}
        try:
            text = raw.decode('utf-8')
            code, comment_free = clean_lean(text)
        except (ValueError, UnicodeError) as error:
            errors.append(name + ': ' + str(error))
            imports[name] = []
            continue
        lines = text.splitlines()
        children, header = [], True
        for line in code.splitlines():
            line = line.strip()
            if not line or line in {'module', 'prelude'}:
                continue
            match = IMPORT.fullmatch(line)
            if match:
                if not header:
                    errors.append(name + ': import outside supported module header')
                for child in match.group(1).split():
                    if not MODULE.fullmatch(child):
                        errors.append(name + ': unsupported import syntax: ' + child)
                    elif child not in children:
                        children.append(child)
            else:
                header = False
        imports[name] = children
        theorem_count += len(re.findall(r'(?m)^\s*(?:theorem|lemma)\s+', code))
        for category, pattern in PATTERNS.items():
            target = comment_free if category == 'forbidden_proof_or_execution' else code
            for match in pattern.finditer(target):
                line = target.count('\n', 0, match.start()) + 1
                findings.append({'module': name, 'line': line, 'category': category,
                                 'token': match.group(), 'source_line': lines[line - 1].strip()})
        for match in OPTION.finditer(code):
            options.append({'module': name, 'line': code.count('\n', 0, match.start()) + 1,
                            'name': match.group(1), 'value': match.group(2).strip()})
        print_lines = set()
        for match in re.finditer(r'(?m)^\s*#print\s+axioms\s+([^\n]+)', code):
            # Start at #print, rather than preceding whitespace/newlines.
            offset = code.find('#print', match.start(), match.end())
            line = code.count('\n', 0, offset) + 1
            print_lines.add(line)
            ordinary.append({'module': name, 'line': line, 'declaration': match.group(1).strip()})
        for match in re.finditer(r'\baxioms\b', code):
            line = code.count('\n', 0, match.start()) + 1
            if line not in print_lines:
                findings.append({'module': name, 'line': line, 'category': 'plural_axioms_review',
                                 'token': 'axioms', 'source_line': lines[line - 1].strip()})
    reachable, visiting = set(), set()

    def visit(name):
        if name in visiting:
            errors.append('Project import cycle: ' + name)
            return
        if name in reachable:
            return
        reachable.add(name)
        if name not in sources:
            errors.append('Unresolved project import: ' + name)
            return
        visiting.add(name)
        for child in imports[name]:
            if child == namespace or child.startswith(namespace + '.'):
                visit(child)
        visiting.remove(name)

    visit(root_module)
    for name in sorted(set(sources) - reachable):
        errors.append('Not imported by project root: ' + name)
    final_paths = [project / (namespace + '.lean')] + sorted((project / namespace).rglob('*.lean'))
    if final_paths != paths:
        errors.append('Production source inventory changed during scan')
    changed = [name for name, row in sources.items()
               if not (project / row['relative_path']).is_file()
               or not under(project / row['relative_path'], project)
               or sha((project / row['relative_path']).read_bytes()) != row['sha256']]
    unresolved = [row for row in findings
                  if not finding_allowed(row, sources[row['module']]['sha256'], policy)]
    unreviewed_options = [row for row in options
                          if not option_allowed(row, sources[row['module']]['sha256'], policy)]
    passed = not (errors or changed or unresolved or unreviewed_options)
    return {
        'status': 'SOURCE_POLICY_PASS_SOURCE_ONLY' if passed else 'SOURCE_POLICY_FAILED_NO_ACCEPTANCE',
        'root_module': root_module, 'production_module_count': len(sources),
        'reachable_module_count': len(reachable), 'explicit_theorem_count': theorem_count,
        'source_changes_during_scan': changed, 'errors': errors,
        'findings': findings, 'unreviewed_findings': unresolved,
        'options': options, 'unreviewed_options': unreviewed_options,
        'ordinary_print_axioms': ordinary,
        'source_manifest': sources, 'imports': imports,
        'source_only': True, 'compiler_ran': False, 'kernel_replay_ran': False,
        'scope': 'Every production Lean file under the root namespace, including nested modules; exact equality with root import closure is required.',
        'limitations': 'Lexical source policy only. Successful clean compilation, exact mathematical types, transitive axioms and fresh installed-kernel replay are separate required gates.',
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', type=Path, required=True)
    parser.add_argument('--out', type=Path, required=True)
    parser.add_argument('--root-module', default='D1Bound5')
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)
    policy_path = HERE / 'reviewed_source_policy.json'
    policy_raw = policy_path.read_bytes()
    script_hash = sha(Path(__file__).read_bytes())
    try:
        report = audit(args.project, args.root_module, json.loads(policy_raw))
        if policy_path.read_bytes() != policy_raw or sha(Path(__file__).read_bytes()) != script_hash:
            raise ValueError('Source-policy script or review manifest changed during scan')
    except Exception as error:
        report = {'status': 'SOURCE_POLICY_FAILED_NO_ACCEPTANCE', 'errors': [repr(error)],
                  'source_only': True, 'compiler_ran': False, 'kernel_replay_ran': False}
    report['policy_manifest_sha256'] = sha(policy_raw)
    report['policy_script_sha256'] = script_hash
    for key, filename in [('source_manifest', 'SOURCE_MANIFEST.json'), ('imports', 'IMPORT_GRAPH.json'),
                          ('options', 'OPTIONS.json'), ('ordinary_print_axioms', 'ORDINARY_AXIOM_REPORTS.json')]:
        value = report.pop(key, None)
        if value is not None:
            (args.out / filename).write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')
    (args.out / 'SOURCE_POLICY_REPORT.json').write_text(json.dumps(report, indent=2, sort_keys=True) + '\n')
    print(report['status'])
    if report['status'] != 'SOURCE_POLICY_PASS_SOURCE_ONLY':
        print(json.dumps({key: report.get(key, []) for key in ['errors', 'source_changes_during_scan',
                         'unreviewed_findings', 'unreviewed_options']}, indent=2), file=sys.stderr)
        return 1
    print('{} production modules; source-only gate'.format(report['production_module_count']))
    return 0


if __name__ == '__main__':
    sys.exit(main())
