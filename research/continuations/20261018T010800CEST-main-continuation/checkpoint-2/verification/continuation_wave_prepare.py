from pathlib import Path
import subprocess,json,hashlib,re
ROOT=Path('/Users/tp/Lean/D1Bound5')
RUN=ROOT/'research/continuations/20261018T010800CEST-main-continuation'
WORK=RUN/'two-small-reproduction'
for script in ['generate_pair_closures.py','generate_pair_lean.py','generate_coordinate_sieves.py']:
 r=subprocess.run(['/Users/tp/.local/bin/python3.12','finite_next/two_small/'+script],cwd=WORK)
 if r.returncode: raise RuntimeError(script)
base=WORK/'finite_next/two_small'
manifest=json.loads((base/'SOURCE_MANIFEST.json').read_text())
for row in manifest:
 p=base/row['path'];data=p.read_bytes()
 assert len(data)==row['bytes'],row['path']
 assert hashlib.sha256(data).hexdigest()==row['sha256'],row['path']
for row in manifest:
 (ROOT/row['path']).write_bytes((base/row['path']).read_bytes())
print('All54 regenerated source fingerprints match the reviewed local snapshot.',flush=True)
tracked=set(subprocess.run(['git','ls-files','D1Bound5/*.lean'],cwd=ROOT,text=True,capture_output=True,check=True).stdout.splitlines())
new=[p.stem for p in (ROOT/'D1Bound5').glob('*.lean') if str(p.relative_to(ROOT)) not in tracked]
new=[n for n in new if not n.startswith('SmallPairGraphData') or n=='SmallPairGraphData41']
new=[n for n in new if n!='SmallPairGraphs']
# Already completed standalone builds need not be repeated here. Their imports
# are still checked by Lake and included in every new dependency fingerprint.
passed=set()
for f in ['trial02-results.json','trial03-results.json']:
 for row in json.loads((RUN/f).read_text()):
  if row.get('exit')==0 and row.get('source_unchanged',True):
   name=row['name'].rsplit('-trial',1)[0]
   p=ROOT/'D1Bound5'/(name+'.lean')
   if p.exists() and hashlib.sha256(p.read_bytes()).hexdigest()==row.get('source_sha256'):
    passed.add(name)
new=[n for n in new if n not in passed]
priority=['OneThreeNegative','SmallSextupleReduction','BennettPartialFractions','BennettLocalResidues','BennettResiduePolynomials','BennettResidualCancellation','BennettDeterminantConstant','BennettNodeRemoval','BennettDeterminantFormula','BennettDeterminantNonzero','CoherentQuotientForms','CoherentTwoSize','CoherentFormBounds','CoherentTwoUpper','CoherentTwoGap','CoherentTwoMainGap','CoherentThreeGeneral','CoherentThreeSimultaneous','CoherentThreeNonvanishing','CrossBlockUpper','CrossBlockGrowth','CrossBlockTuple','DescentDenominator','DescentNorm','FullRingDescent','PairExtensionCore','PairSeedDisks','PairExtensionComplete','BennettBinomialIntegrality','BennettSubringSums','BennettTwoDenominatorClearing','BennettTwoIntegralSummands','BennettTwoIntegralEntries','BennettTwoIntegralMatrix']
names=[n for n in priority if n in new]+sorted(set(new)-set(priority))
(RUN/'continuation-queue.json').write_text(json.dumps({'names':names,'pause_after_current':False},indent=2))
print(json.dumps({'queue':names,'already_passed_source_matches':sorted(passed)}),flush=True)
