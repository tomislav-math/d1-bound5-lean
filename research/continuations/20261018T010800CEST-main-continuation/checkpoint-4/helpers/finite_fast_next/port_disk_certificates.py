"""Prepare list certificates, preserving and independently checking every point.

The resulting proof remains `decide +kernel`. This script is reproduction
tooling only; its arithmetic checks are not accepted as a Lean proof.
"""
from pathlib import Path
import math
import re

ROOT = Path(__file__).resolve().parent.parent
sources = [ROOT/'finite_next/two_small/D1Bound5/TwoSmallSeedDisks.lean',
           ROOT/'finite_next/one_small/D1Bound5/OneSmallDisks.lean']
for source in sources:
    text = source.read_text()
    theorems = re.findall(r'theorem (\w+)_eq : disk (\d+) (\d+) (\d+) = \1.toFinset := by\n  decide \+kernel', text)
    bounds = {n: (int(t), int(v), int(m)) for n, t, v, m in theorems}
    count = [0]
    def replace(match):
        name, tau, nu, entries = match.groups()
        tau, nu = int(tau), int(nu)
        if name not in bounds:
            return match.group(0)
        assert bounds[name][:2] == (tau, nu)
        bound = bounds[name][2]
        pairs = [tuple(map(int, p)) for p in re.findall(r'⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩', entries)]
        assert len(pairs) == len(set(pairs)), name
        radius = math.isqrt(4*bound)
        expected = [((e-tau*f)//2, f)
                    for e in range(-radius, radius+1)
                    for f in range(-radius, radius+1)
                    if (e-tau*f)%2 == 0 and e*e+(4*nu-tau*tau)*f*f <= 4*bound]
        assert set(pairs) == set(expected), name
        ordered = sorted(pairs, key=lambda p: (2*p[0]+tau*p[1], p[1]))
        assert ordered == expected
        count[0] += 1
        return f'def {name} : List (QuadInt {tau} {nu}) := [\n  '+',\n  '.join(f'⟨{x},{y}⟩' for x,y in ordered)+'\n]'
    text = re.sub(r'def (\w+) : List \(QuadInt (\d+) (\d+)\) := \[(.*?)\]', replace, text, flags=re.S)
    for name, (tau, nu, bound) in bounds.items():
        old = f'theorem {name}_eq : disk {tau} {nu} {bound} = {name}.toFinset := by\n  decide +kernel'
        new = f'theorem {name}_eq : disk {tau} {nu} {bound} = {name}.toFinset := by\n  have h : fastDiskList {tau} {nu} {bound} = {name} := by decide +kernel\n  rw [← fastDiskList_toFinset, h]'
        assert old in text
        text = text.replace(old, new)
    assert count[0] == len(bounds) > 0
    if 'import D1Bound5.FastDiskList' not in text:
        text = 'import D1Bound5.FastDiskList\n'+text
    target = ROOT/'finite_fast_next'/source.name
    target.write_text(text)
    print(f'{source.name}: {count[0]} complete ordered disk lists checked and prepared')
