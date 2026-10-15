#!/usr/bin/env python3
"""Bind the rerun Section 7 computations to the actual v2 source.

The guarded reconstruction below permits only the seven inspected local
edits. It does not strip arbitrary labels, formulas, or whitespace.
"""
from pathlib import Path
from fractions import Fraction as F
import hashlib, json, re, time

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'revision_v2/checks'
V1 = ROOT / 'upload/D1_bound5-v1(1).tex'
V2 = ROOT / 'output/D1_bound5-v2.tex'
H1 = '74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
H_RUN = '66f5a580e2b08bdd369c1b38a557de20a586cf3cf9a06bb7d0b82d4304587c63'
H2 = '5edcf8777371c4ad8979f122022d3119a8ae2de75d9674b336df994bba860b70'
sha = lambda b: hashlib.sha256(b).hexdigest()
started = time.perf_counter()
assert sha(V1.read_bytes()) == H1
assert sha(V2.read_bytes()) == H2
t1, t2 = V1.read_text(), V2.read_text()
start = r'\section{Tuples with at least two small entries}'
end = r'\section{Reduction of the first three entries}'
s1 = t1[t1.index(start):t1.index(end)]
s2 = t2[t2.index(start):t2.index(end)]
# Recover the exact full source used by the expensive runs from the four
# later registered QA edits. Each reverse replacement is guarded, and its
# resulting whole-source hash must match the recorded original run hash.
register = json.loads((ROOT / 'revision_v2/change_register.json').read_text())
qa = [e for e in register['edits'] if e['id'] in ('QA01','QA02','QA03','QA04')]
assert [e['id'] for e in qa] == ['QA01','QA02','QA03','QA04']
run_text = t2
for e in reversed(qa):
    assert run_text.count(e['new']) == 1, e['id']
    run_text = run_text.replace(e['new'], e['old'], 1)
assert sha(run_text.encode()) == H_RUN
run_section = run_text[run_text.index(start):run_text.index(end)]
assert run_section == s2
working = s1
edits = []
def change(old, new, reason):
    global working
    assert working.count(old) == 1, (reason, working.count(old))
    working = working.replace(old, new, 1)
    edits.append(reason)

change(r'\section{Tuples with at least two small entries}\label{sec:small-entries}',
       start, 'Remove an unused section label; no mathematical content.')
change(r'''with \(m=4\). For \(j\ge1\), write''',
       r'''with \(m=4\), and put
\[
 H=\prod_{i=1}^4a_i,\qquad
 \Delta=\prod_{1\le i<j\le4}(a_i-a_j).
\]
For \(j\ge1\), write''',
       'Locally define the four-anchor H and Delta used by the existing formulas.')
change(r'''For six ordered entries with anchor moduli $A\le B\le S\le T$, interpolation modulus $P$ and final modulus $Q$, assume
\begin{equation}\label{sm:six-V-hypotheses}
 P\ge\max\{4T,1000\},\qquad Q\ge4P,
 \qquad P^2\ge\frac{32BST}{A^3}.
\end{equation}''',
       r'''Let $a,b,s,t,p,q$ be six distinct tuple entries, with moduli
$A\le B\le S\le T\le P\le Q$. Assume
\begin{equation*}
 P\ge\max\{4T,1000\},\qquad Q\ge4P,
 \qquad P^2\ge\frac{32BST}{A^3}.
\end{equation*}''',
       'P04: explicitly name all six distinct ordered entries; size guards unchanged.')
change(r'''\begin{equation}\label{sm:six-V-constants}
 \frac{100}{1-\varepsilon}<101,
 \qquad \frac4{9(1+\varepsilon)}>\frac25.
\end{equation}''',
       r'''\begin{equation*}
 \frac{100}{1-\varepsilon}<101,
 \qquad \frac4{9(1+\varepsilon)}>\frac25.
\end{equation*}''',
       'Remove an unused equation number; both exact comparisons unchanged.')
change(r'''\begin{equation}\label{sm:five-two-small-lower}
 D>\frac25\frac{A^2C^5}{T^2}
  >\frac{243}{81920}A^7S^5T^3
  >\frac{S^5T^3}{400}\ge\frac{S^8}{400}.
\end{equation}
If $s=\log_{10}S\ge49$, this contradicts
\eqref{sm:five-uniform-continuous}. The difference
$s-227/5-(4047/25)/(s-4)$ is increasing and equals $1/375$ at $49$.''',
       r'''\begin{equation*}
 D>\frac25\frac{A^2C^5}{T^2}
  >\frac{243}{81920}A^7S^5T^3
  >\frac{S^5T^3}{400}\ge\frac{S^8}{400}.
\end{equation*}
If $s=\log_{10}S\ge49$, then $400<10^3$ gives
$\log_{10}D>8s-3$. This contradicts
\eqref{sm:five-uniform-continuous}, since
$(8s-3)-g(s)=s-227/5-(4047/25)/(s-4)$ is increasing
and equals $1/375$ at $49$.''',
       'P03: explicitly take the weaker logarithmic lower bound; original power bound unchanged.')
change(r'''\begin{equation}\label{sm:five-bounded-four-lower}
 D>\frac{C^7}{100M^6}=10^{-50}C^7.
\end{equation}''',
       r'''\begin{equation*}
 D>\frac{C^7}{100M^6}=10^{-50}C^7.
\end{equation*}''',
       'Remove an unused equation number; power bound unchanged.')
change('vanishes; integrality of a purely imaginary root',
       'vanishes. Integrality of a purely imaginary root',
       'Split the rational-square explanation into two sentences.')
assert working == s2, 'Unaccounted Section 7 difference'

def env_containing(text, token, env):
    pos = text.index(token)
    a = text.rfind('\\begin{' + env + '}', 0, pos)
    b = text.index('\\end{' + env + '}', pos) + len('\\end{' + env + '}')
    assert a >= 0
    return text[a:b]

tables = []
for name, token, env in [
    ('48 small-pair graphs', r'\label{sm:bs7-pair-table}', 'longtable'),
    ('10 small-triple rows', r'\label{sm:six-small-triples-table}', 'table'),
    ('Pell graph totals', 'Fields & Nonempty graphs & Vertices & Edges & Triangles', 'tabular'),
]:
    a, b = env_containing(s1, token, env), env_containing(s2, token, env)
    assert a == b, name
    tables.append({'table': name, 'unchanged_bytewise_utf8': True,
                   'bytes': len(b.encode()), 'sha256': sha(b.encode())})

# The exact v2 scripts compare all 48 pair rows directly with the source.
# Their triple and Pell expected rows are fixed data; the bytewise comparison
# above binds these already inspected data to the actual v2 tables.
results = {}
for mode in ('pairs', 'triples', 'pell'):
    data = json.loads((OUT / f'small_v2_{mode}.json').read_text())
    runtime = json.loads((OUT / f'small_v2_runtime_{mode}.json').read_text())
    assert data['hash'] in (H_RUN, H2)
    assert runtime['source_sha256'] == data['hash'] and runtime['passed']
    results[mode] = runtime
pairdata = json.loads((OUT / 'small_v2_pairs.json').read_text())
degenerate = []
for d, a, b in pairdata['all_classes']:
    u, v = a; x, y = b
    if u*x-d*v*y == -4 and u*y+v*x == 0:
        degenerate.append((d, a, b))
units = [r for r in degenerate if r[1:] == ([-2, 0], [2, 0])]
assert len(units) == 23 and len(degenerate) == 24
assert [r for r in degenerate if r not in units] == [(3, [-1, -1], [1, -1])]
constants = json.loads((OUT / 'small_v2_constants.json').read_text())
assert constants['source_sha256'] == H2 and len(constants['checks']) == 74

# P03 is a symbolic rational identity, not a decimal approximation.
def g(s): return 7*s + F(212, 5) + F(4047, 25)/(s-4)
for s in (F(49), F(50), F(100), F(1000000)):
    assert 8*s-3-g(s) == s-F(227,5)-F(4047,25)/(s-4)
assert 400 < 10**3 and 8*49-3-g(F(49)) == F(1,375)
# Derivative of the difference: 1+(4047/25)/(s-4)^2 > 0 for s>=49.
assert F(4047,25) > 0
# P04: strict nonvanishing margin at X=BST/A^3>=1 is at least3/4.
assert F(32)-F(121,4)-1 == F(3,4) > 0
assert F(100)/(1-F(1,4000)) < 101
assert F(4)/(9*(1+F(1,4000))) > F(2,5)

assert sha(V2.read_bytes()) == H2
report = {'source_sha256': H2, 'baseline_sha256': H1,
          'expensive_run_source_sha256': H_RUN,
          'run_source_recovered_by_exact_QA_reversal': True,
          'section_sha256': sha(s2.encode()),
          'section_unchanged_since_expensive_runs': True,
          'section_lines': [2011, 2881],
          'guarded_edit_blocks': len(edits), 'edits': edits,
          'only_registered_local_changes': True,
          'tables': tables, 'fresh_computation_runtimes': results,
          'exact_constant_checks': 74,
          'P03_identity_and_endpoint': 'passed; derivative manifestly positive',
          'P04_nonvanishing_and_interval_constants': 'passed',
          'degenerate_pair_classes': {'unit_pairs': 23, 'other': [r for r in degenerate if r not in units]},
          'seconds': time.perf_counter()-started}
(OUT / 'small_v2_source_check.json').write_text(json.dumps(report, indent=2)+'\n')
print(json.dumps(report, indent=2))
