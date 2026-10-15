#!/usr/bin/env python3
"""Conservative source-policy scan. This does not replace kernel/axiom audits."""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]


def remove_comments(text):
    """Strip Lean line/nested block comments, preserving line numbers."""
    out = []
    i = depth = 0
    quoted = False
    while i < len(text):
        if depth:
            if text.startswith('/-', i):
                depth += 1
                i += 2
            elif text.startswith('-/', i):
                depth -= 1
                i += 2
            else:
                out.append('\n' if text[i] == '\n' else ' ')
                i += 1
        elif quoted:
            out.append(text[i])
            if text[i] == '\\' and i + 1 < len(text):
                out.append(text[i + 1])
                i += 2
            else:
                if text[i] == '"':
                    quoted = False
                i += 1
        elif text.startswith('/-', i):
            depth = 1
            i += 2
        elif text.startswith('--', i):
            end = text.find('\n', i)
            i = len(text) if end < 0 else end
        else:
            quoted = text[i] == '"'
            out.append(text[i])
            i += 1
    if depth or quoted:
        raise ValueError('Unterminated comment or string')
    return ''.join(out)


forbidden = re.compile(
    r'\b(sorry|admit|sorryAx|axiom|unsafe|native_decide|implemented_by|extern)\b'
    r'|\+native\b|debug\.skipKernelTC|Lean\.ofReduce|\brun_(tac|cmd|elab)\b'
)
files = [ROOT / 'D1Bound5.lean'] + sorted((ROOT / 'D1Bound5').glob('*.lean'))
errors = []
theorem_count = 0
for path in files:
    code = remove_comments(path.read_text(encoding='utf-8'))
    theorem_count += len(re.findall(r'^\s*(?:theorem|lemma)\s+', code, re.MULTILINE))
    for hit in forbidden.finditer(code):
        line = code[:hit.start()].count('\n') + 1
        errors.append('{}:{}: {}'.format(path.relative_to(ROOT), line, hit.group()))
if errors:
    print('\n'.join(errors), file=sys.stderr)
    sys.exit(1)
print('SOURCE_AUDIT_PASS: {} modules, {} explicit theorems'.format(len(files), theorem_count))
