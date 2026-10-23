#!/usr/bin/env python3
"""Independent read-only production-source audit; does not invoke Lean.

Only --out is written, and it must be outside the candidate checkout.
Comments and strings are skipped by a regex-jump lexer independently written
from scan_final_sources.py. This is source-policy evidence, not proof acceptance.
"""
import argparse
import datetime
import hashlib
import json
from pathlib import Path
import re
import subprocess
import time

START = re.compile(r'/-|--|r(#+)"|"')
NESTED = re.compile(r'/-|-/')
STRING_END = re.compile(r'\\.|"', re.S)
TOKENS = re.compile(
    r'\b(?:sorry|admit|sorryAx|native_decide|native_decide_term|implemented_by|unsafe|extern|'
    r'axiom|constant|constants|skipKernelTC|skipKernelTypeChecking|trustLevel|trust_level|'
    r'trustKernel|enableKernel|disableKernel|setEnv|modifyEnv|modifyEnvImpl|addDecl|'
    r'addAndCompile|addAndCompileDecl|addDeclCore|addConstInfo|setEnvUnsafe|importModules|'
    r'run_cmd|run_elab|elab|elab_rules|macro|macro_rules|initialize|builtin_initialize|'
    r'Meta|Elab|opaque|Lean\.Environment)\b|\b(?:s|m|f)!|#eval\b|'
    r'\b(?:Environment|env)\.(?:add|set|insert|modify)\b')
IMPORT = re.compile(r'(?m)^[ \t]*(?:(?:public|private|meta)[ \t]+)*import[ \t]+([^\n]+)')


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def scrub(s):
    output = []
    i = 0
    while True:
        match = START.search(s, i)
        if match is None:
            output.append(s[i:])
            return ''.join(output)
        output.append(s[i:match.start()])
        first = match.start()
        token = match.group()
        if token == '--':
            j = s.find('\n', match.end())
            j = len(s) if j < 0 else j
        elif token == '/-':
            depth, j = 1, match.end()
            while depth:
                nested = NESTED.search(s, j)
                if nested is None:
                    raise ValueError('Unterminated nested comment')
                depth += 1 if nested.group() == '/-' else -1
                j = nested.end()
        elif match.group(1):
            ending = '"' + match.group(1)
            j = s.find(ending, match.end())
            if j < 0:
                raise ValueError('Unterminated raw string')
            j += len(ending)
        else:
            j = match.end()
            while True:
                ending = STRING_END.search(s, j)
                if ending is None:
                    raise ValueError('Unterminated string')
                j = ending.end()
                if ending.group() == '"':
                    break
        output.append(re.sub(r'[^\n]', ' ', s[first:j]))
        i = j


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--project', type=Path, required=True)
    parser.add_argument('--reviewed-manifest', type=Path, required=True)
    parser.add_argument('--expected-commit', required=True)
    parser.add_argument('--out', type=Path, required=True)
    args = parser.parse_args()
    project, output = args.project.resolve(), args.out.resolve()
    if output == project or project in output.parents:
        raise ValueError('Audit output must be outside the candidate checkout')
    begin = time.monotonic()
    git = ['git', '--no-optional-locks', '-C', str(project)]
    commit = subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip()
    if commit != args.expected_commit:
        raise ValueError('Candidate commit differs from explicit requested commit')
    git_status = subprocess.check_output(git + ['status', '--porcelain'], text=True)
    manifest = json.loads(args.reviewed_manifest.read_text())
    production_manifest = project / 'verification/PRODUCTION_AND_TOOLS_SHA256.json'
    package_files = json.loads(production_manifest.read_text())
    source_files = {str(p.relative_to(project)): p for p in (project / 'D1Bound5').rglob('*.lean')}
    source_files['D1Bound5.lean'] = project / 'D1Bound5.lean'
    expected = {row['relative_path']: name for name, row in manifest.items()}
    changed, findings, sensitive, options, dependencies, external = [], [], [], [], {}, set()
    unexpected_axioms, ordinary_axioms, source_bytes = [], 0, 0
    for name, row in sorted(manifest.items()):
        raw = (project / row['relative_path']).read_bytes()
        source_bytes += len(raw)
        if hashlib.sha256(raw).hexdigest() != row['sha256']:
            changed.append(name)
        text = raw.decode()
        code = scrub(text)
        dependencies[name] = []
        for match in IMPORT.finditer(code):
            for imported in match[1].split():
                if imported == 'D1Bound5' or imported.startswith('D1Bound5.'):
                    dependencies[name].append(imported)
                else:
                    external.add(imported)
        lines = text.splitlines()
        for match in TOKENS.finditer(code):
            line = code.count('\n', 0, match.start()) + 1
            source_line = lines[line - 1].strip()
            benign = match[0] == 'Elab' and source_line == 'import Lean.Elab.Tactic.Omega'
            findings.append({'module': name, 'line': line, 'token': match[0],
                             'source_line': source_line, 'benign_standard_omega_import': benign})
        for match in re.finditer(r'(?m)^[ \t]*set_option[ \t]+(\S+)[ \t]+([^\n]+)', code):
            row_option = {'module': name, 'name': match[1], 'value': match[2].strip()}
            options.append(row_option)
            if re.search(r'kernel|trust|unsafe|debug|native|proof|admit|sorry', match[1], re.I):
                sensitive.append(row_option)
        for line_number, line in enumerate(code.splitlines(), 1):
            occurrences = list(re.finditer(r'\baxioms\b', line))
            if not occurrences:
                continue
            if len(occurrences) == 1 and re.match(r'^[ \t]*#print[ \t]+axioms[ \t]+\S', line):
                ordinary_axioms += 1
            else:
                unexpected_axioms.append({'module': name, 'line': line_number, 'source': line.strip()})
    active, done, missing, cycles = set(), set(), [], []

    def visit(name):
        if name in active:
            cycles.append(name)
            return
        if name in done:
            return
        if name not in dependencies:
            missing.append(name)
            return
        active.add(name)
        for dependency in dependencies[name]:
            visit(dependency)
        active.remove(name)
        done.add(name)

    visit('D1Bound5')
    package_changed = [relative for relative, digest in package_files.items()
                       if sha(project / relative) != digest]
    changed_after = [name for name, row in manifest.items()
                     if sha(project / row['relative_path']) != row['sha256']]
    git_status_after = subprocess.check_output(git + ['status', '--porcelain'], text=True)
    commit_after = subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip()
    problems = {
        'extra_sources': sorted(set(source_files) - set(expected)),
        'missing_sources': sorted(set(expected) - set(source_files)),
        'changed_sources': changed, 'changed_sources_after_scan': changed_after,
        'changed_package_manifest_entries': package_changed,
        'missing_imports': missing, 'cycles': cycles,
        'outside_canonical_root_closure': sorted(set(manifest) - done),
        'unresolved_policy_findings': [row for row in findings if not row['benign_standard_omega_import']],
        'sensitive_options': sensitive, 'unexpected_plural_axioms': unexpected_axioms,
        'compiled_artifacts': [str(p.relative_to(project)) for p in project.rglob('*')
                               if p.is_file() and ('.olean' in p.name or p.name.endswith(('.ir', '.ir.sig')))],
        'symlinks': [str(p.relative_to(project)) for p in project.rglob('*') if p.is_symlink()],
        'git_dirty_before': git_status, 'git_dirty_after': git_status_after,
        'git_commit_changed': commit_after != commit,
    }
    report = {
        'status': 'PASS_INDEPENDENT_SOURCE_POLICY_ONLY' if not any(problems.values()) else 'REVIEW_REQUIRED',
        'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'candidate_commit': commit, 'candidate_project': str(project),
        'root_module': 'D1Bound5', 'candidate_modules': len(source_files),
        'reviewed_modules': len(manifest), 'closure_modules': len(done), 'source_bytes': source_bytes,
        'candidate_root_sha256': sha(project / 'D1Bound5.lean'),
        'candidate_package_manifest_sha256': sha(production_manifest),
        'candidate_origin_sha256': sha(project / 'verification/CANDIDATE_ORIGIN.json'),
        'reviewed_manifest_sha256': sha(args.reviewed_manifest),
        'review_script_sha256': sha(__file__),
        'ordinary_print_axioms': ordinary_axioms,
        'benign_findings': [row for row in findings if row['benign_standard_omega_import']],
        'options': options, 'external_imports_not_scanned': sorted(external),
        'problems': problems, 'seconds': round(time.monotonic() - begin, 2),
        'scope': 'Independent exact-hash lexical and project-import audit of committed canonical production sources. No Lean compilation, declaration-axiom acceptance, or installed-kernel claim. External Lean/mathlib source policy not scanned.',
        'known_scanner_exit_semantics': 'Packaged scan_final_sources.py may return exit 0 for REVIEW_REQUIRED; acceptance must inspect JSON and explicit finding dispositions.',
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, indent=2, sort_keys=True) + '\n')
    print(json.dumps({k: report[k] for k in ('status', 'candidate_commit', 'closure_modules', 'source_bytes', 'ordinary_print_axioms', 'seconds')}))
    return 0 if report['status'] == 'PASS_INDEPENDENT_SOURCE_POLICY_ONLY' else 1


if __name__ == '__main__':
    raise SystemExit(main())
