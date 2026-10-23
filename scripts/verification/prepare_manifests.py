#!/usr/bin/env python3
"""Prepare reviewable manifests outside the repository; this does not verify proofs."""
import argparse
import hashlib
import json
from pathlib import Path


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


def safe_file(root, name):
    relative = Path(name)
    require(not relative.is_absolute() and '..' not in relative.parts, 'Unsafe relative path: ' + name)
    path = root / relative
    require(path.is_file() and not path.is_symlink() and root in path.resolve().parents,
            'Missing or escaping file: ' + name)
    return path


def read_manifest(path):
    rows = {}
    for line in path.read_text().splitlines():
        if not line.strip():
            continue
        value, name = line.split(None, 1)
        name = name.lstrip('*')
        require(name not in rows and len(value) == 64 and all(c in '0123456789abcdef' for c in value),
                'Invalid or duplicate prior manifest row')
        rows[name] = value
    require(rows, 'Prior tools manifest must not be empty')
    return rows


def write_manifest(path, rows):
    path.write_text(''.join(value + '  ' + name + '\n' for name, value in sorted(rows.items())))


def prepare(project, source_lock_path, source_lock_sha256, prior_path, updated, out):
    project, out = project.resolve(), out.resolve()
    require(project != out and project not in out.parents, 'Manifest proposals must be outside the source checkout')
    require(not out.exists() or not any(out.iterdir()), 'Output directory must be empty')
    require(digest(source_lock_path) == source_lock_sha256, 'Unreviewed source lock')
    lock = json.loads(source_lock_path.read_text())
    pins_path = safe_file(project, 'scripts/verification/release_pins.json')
    pins = json.loads(pins_path.read_text())
    require(lock['namespace'] == 'D1Bound5' and lock['roots'] == ['D1Bound5'], 'Wrong root scope')
    require(lock['module_count'] == len(lock['sources']) == pins['expected_project_modules'], 'Wrong release scope')
    require(lock['auxiliary'] == pins['configuration_sha256'], 'Configuration pin mismatch')
    proof = {}
    for row in lock['sources'].values():
        name = row['relative_path']
        require(name not in proof, 'Duplicate production path')
        require(digest(safe_file(project, name)) == row['sha256'], 'Changed production source: ' + name)
        proof[name] = row['sha256']
    discovered = {p.relative_to(project).as_posix() for p in (project/'D1Bound5').rglob('*.lean')}
    discovered.add('D1Bound5.lean')
    require(discovered == set(proof), 'Production directory contains missing or disconnected source files')
    prior = read_manifest(prior_path)
    require(set(updated) <= set(prior), 'Explicitly updated paths must already occur in prior tools manifest')
    required = set(pins['required_tools']) | set(pins['configuration_sha256']) | {'scripts/verification/release_pins.json'}
    tools = {}
    changes = []
    for name in sorted(set(prior) | required):
        actual = digest(safe_file(project, name))
        if name in prior and name not in updated:
            require(actual == prior[name], 'Unexpected historical tool change: ' + name)
        tools[name] = actual
        if prior.get(name) != actual:
            changes.append({'relative_path': name, 'before_sha256': prior.get(name), 'after_sha256': actual})
    for name, expected in pins['configuration_sha256'].items():
        require(tools[name] == expected, 'Changed pinned configuration: ' + name)
    out.mkdir(parents=True, exist_ok=True)
    write_manifest(out/'proof-source-sha256.txt', proof)
    write_manifest(out/'verification-tools-sha256.txt', tools)
    report = {'status': 'MANIFEST_PROPOSAL_ONLY_NOT_PROOF_ACCEPTANCE', 'production_modules': len(proof),
        'verification_tool_entries': len(tools), 'source_lock_sha256': source_lock_sha256,
        'prior_tools_manifest_sha256': digest(prior_path), 'release_pins_sha256': digest(pins_path),
        'explicitly_updated_historical_tools': sorted(updated), 'changed_or_added_tools': changes,
        'output_sha256': {p.name: digest(p) for p in out.iterdir() if p.is_file()}}
    (out/'MANIFEST_PROPOSAL.json').write_text(json.dumps(report, indent=2, sort_keys=True)+'\n')
    return report


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    for key in ['project', 'source-lock', 'source-lock-sha256', 'prior-tools-manifest', 'out']:
        ap.add_argument('--'+key, required=True)
    ap.add_argument('--updated-tool', action='append', default=[])
    args = ap.parse_args()
    result = prepare(Path(args.project), Path(args.source_lock), args.source_lock_sha256,
                     Path(args.prior_tools_manifest), args.updated_tool, Path(args.out))
    print(json.dumps(result, sort_keys=True))


if __name__ == '__main__':
    main()
