"""Split original row41 certificates without changing any arithmetic/checker.
The original source remains untouched. Names live in a separate namespace;
large vertices are the already frozen bipartite pilot's exact copied list.
"""
from pathlib import Path
import re,json,hashlib
ROOT=Path(__file__).resolve().parents[2];OUT=Path(__file__).resolve().parent
source=(ROOT/'finite_next/two_small/D1Bound5/SmallPairGraphData41.lean').read_text()
start=source.index('def smallPairA_41 ')
stop=source.index('\ndef smallPairLarge_41 ')
defs=source[start:stop].strip()
for old,new in [('smallPairA_41','anchorA'),('smallPairB_41','anchorB'),('smallPairClosure_41','closure')]:
 defs=defs.replace(old,new)
(OUT/'SmallPairPhaseData41.lean').write_text('import D1Bound5.SmallPairBipartitePilotData41\n\nnamespace D1Bound5.PairPhasePilot41\nopen QuadInt\nset_option maxRecDepth 100000\n\n'+defs+'\n\ndef large : List (QuadInt 1 2) := smallPairPilotLarge_41\n\nend D1Bound5.PairPhasePilot41\n')
checks={
'Seeds':('import D1Bound5.TwoSmallSeedDisks\n','pairSeedsCoveredBool anchorA anchorB seedRootDisk_1_2 closure = true'),
'Closure':('','pairClosureBool anchorA anchorB (10^1100) closure = true'),
'Filter':('','largePairVertices anchorA anchorB closure = large'),
}
for phase,(extra,goal) in checks.items():
 (OUT/f'SmallPairPhase{phase}41.lean').write_text(f'''import D1Bound5.SmallPairPhaseData41
{extra}
namespace D1Bound5.PairPhasePilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem {phase.lower()}_checked :
    {goal} := by
  decide +kernel

end D1Bound5.PairPhasePilot41
''')
# Exact literal comparison is diagnostic only; the proofs execute the unchanged checkers.
original=re.search(r'def smallPairClosure_41 .*? := \[(.*?)\n\]',source,re.S).group(1)
new=re.search(r'def closure .*? := \[(.*?)\n\]',(OUT/'SmallPairPhaseData41.lean').read_text(),re.S).group(1)
assert original==new
report={'purpose':'Isolate unchanged seed, closure and filter computation; no triangle check.',
 'original_source_sha256':hashlib.sha256(source.encode()).hexdigest(),
 'closure_literal_sha256':hashlib.sha256(original.encode()).hexdigest(),
 'files':{p.name:{'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size} for p in sorted(OUT.glob('*.lean'))}}
(OUT/'phase41_manifest.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
