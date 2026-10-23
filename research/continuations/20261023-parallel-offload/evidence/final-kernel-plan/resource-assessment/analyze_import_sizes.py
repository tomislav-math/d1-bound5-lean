#!/usr/bin/env python3
"""Source-header/stat-size proxy only: never loads Lean artifacts or starts Lean."""
import collections
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[2]
SOURCE_ROOTS = [ROOT.parent / 'clean-checkout', ROOT / 'mathlib',
                *[p for p in (ROOT / 'mathlib/.lake/packages').iterdir() if p.is_dir()],
                ROOT / 'lean-4.33.1-linux/src/lean', ROOT / 'lean-4.33.1-linux/src/lean/lake']


def imports(path):
    depth = 0
    prelude = False
    result = []
    with path.open() as f:
        for raw in f:
            line, i = '', 0
            while i < len(raw):
                pair = raw[i:i+2]
                if pair == '/-':
                    depth += 1; i += 2; continue
                if depth:
                    if pair == '-/': depth -= 1; i += 2
                    else: i += 1
                    continue
                if pair == '--': break
                line += raw[i]; i += 1
            line = line.strip()
            if not line or line == 'module': continue
            if line == 'prelude': prelude = True; continue
            match = re.fullmatch(r'(?:(?:public|private|meta)\s+)*import\s+(?:all\s+)?(.+)', line)
            if not match: break
            for name in match.group(1).split():
                if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_']*(?:\.[A-Za-z_][A-Za-z0-9_']*)*", name):
                    raise ValueError((str(path), line))
                if name not in result: result.append(name)
    return result if prelude else ['Init', *result]


def main():
    seen, missing = set(), []
    def visit(name):
        if name in seen: return
        seen.add(name)
        relative = name.replace('.', '/') + '.lean'
        source = next((p / relative for p in SOURCE_ROOTS if (p / relative).is_file()), None)
        if source is None: missing.append(name); return
        for dependency in imports(source): visit(dependency)
    visit('D1Bound5')
    env = json.loads((ROOT / 'lean-env.json').read_text())
    artifact_roots = [Path(p) for p in env['LEAN_PATH'].split(':') if p]
    rows = {}
    unavailable = []
    totals = collections.defaultdict(collections.Counter)
    counts = collections.Counter()
    for name in sorted(seen):
        relative = name.replace('.', '/')
        base = next((r / (relative + '.olean') for r in artifact_roots if (r / (relative + '.olean')).is_file()), None)
        if base is None: unavailable.append(name); continue
        parts = {}
        for suffix in ['.olean', '.olean.server', '.olean.private', '.ir.sig', '.ir']:
            path = base.with_name(base.name.removesuffix('.olean') + suffix)
            if path.is_file(): parts[suffix] = path.stat().st_size
        kind = 'project' if name == 'D1Bound5' or name.startswith('D1Bound5.') else 'external'
        totals[kind].update(parts); counts[kind] += 1
        rows[name] = parts
    scope = ('Source-header transitive import approximation, including implicit Init and ignoring import-level attributes; '
             'candidate artifact file sizes only, not actual imported private regions or resident memory. No Lean process.')
    summary = {'scope': scope, 'modules': counts, 'source_missing': missing, 'artifact_missing': unavailable,
               'bytes_by_part': dict(totals), 'total_bytes': sum(sum(x.values()) for x in totals.values()),
               'not_a_ram_lower_bound': 'Some mapped pages/extension/IR data may remain unresident; kernel environments and checking scratch add memory.'}
    output = Path(__file__).parent
    (output / 'IMPORT_SIZE_PROXY.json').write_text(json.dumps({'scope': scope, 'module_parts': rows}, indent=2, sort_keys=True) + '\n')
    (output / 'IMPORT_SIZE_SUMMARY.json').write_text(json.dumps(summary, indent=2, sort_keys=True) + '\n')
    print(json.dumps(summary, indent=2))


if __name__ == '__main__': main()
