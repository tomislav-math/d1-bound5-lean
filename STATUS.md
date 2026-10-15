# Status

2026-10-15. IN PROGRESS. MAIN THEOREM UNPROVED.

## Concurrent later hourly continuation

The independent hourly invocation recorded at records/runs/20261015T221745+0200-hourly2-START.md has continued with
DeterminantNormalization.lean and a new root import. Its sources and
checks are outside the 209-theorem/420-declaration audit reported below.
Preserve that active work; read its newest PROGRESS/FINISH before acting.
The current fingerprint manifest describes the accepted 62292f0 snapshot,
not that extra in-progress root import. All checked individual modules
were verified byte-unchanged after detecting the added import.

## Current accepted local milestone

37 Lean modules; 209 explicit theorem declarations; 420 project declarations
covered by the transitive axiom audit. The whole integrated build, source
policy/import-coverage scan and axiom audit all PASS with exit 0. The only
allowed axiom dependencies are propext, Classical.choice and Quot.sound.
A targeted replay of TEN modules also completed with exit 0. Its precise
module list and command are in records/recovery-kernel-20261015.json.
This is the installed Lean kernel, not an independent implementation.
No whole-project fresh replay or new clean checkout is claimed.

## Newly closed mathematical obligations

1. Exact full-ring square testing and exhaustive closed norm disks.
2. ALL THIRTY normalized finite small-tail models, with kernel-checked
   explicit-list completeness and full Boolean exclusions.
3. COMPLETE lem:tail-irregular in every imaginary quadratic full integer
   ring: ordered D(1) quadruple with B>=3 => irregular last triple and
   D>2BC. The auxiliary C>=4 restriction has been removed.
4. Even-dimensional root-matrix determinant nonsingularity in every
   quadratic number field, plus |det(M)|>=1 in the imaginary case.
   The reduction modulo two works with zero divisors. This is NOT
   Bennett's arbitrary-order determinant identity.

The previous full-ring bridge, norm bridge and analytic C>=4 branch are
reused. The four analytic sources are byte-identical to private source
commit 3a8f9ff. The current tested proof source is commit 62292f0. Merge
commit a91af24 preserves independent remote paper/verification additions
without changing any Lean source or build configuration. Later record-only
commits do not change this tested source. See the hash manifests.

## Next mathematical action

Proceed to the analytic determinant size bounds in lem:product-four,
then the remaining structural gap/interpolation/approximation arguments.
Do NOT redo the full-ring bridge, small-tail enumeration, full tail lemma,
or even-dimensional arithmetic nonsingularity. The main theorem remains
only a proposition specification, not a proved theorem.

Bennett's all-orders determinant identity, large graph/Pell exclusions with
complete descent/coverage proofs, and all three main sextuple exclusions
remain open. An inherited negative-rational-square wrapper needs stronger
statement packaging before use as a uniform fixed-field classification;
neither new main lemma depends on it. See records/statement-review.md.

## Validation and recovery

Read records/build-record.md, records/paper-to-lean.md,
records/open-obligations.md, and the latest records/runs entry. The direct
recovery invocation has finished its proof unit and saved the results.
No owned compiler/checker is intentionally left running. Inspect live state
before starting another heavy process. Use one compiler/checker at a time.
The 40-theorem historical checkpoint passed a clean checkout; a new clean
checkout of this larger milestone and an independent statement review have
NOT been performed. Those remain final release gates.

Lean 4.33.1; mathlib 0df444a360eaa60ab8c11dca51a86af692955474;
user-local Python 3.12.15. PRIVATE repository tomislav-math/d1-bound5-lean.
No manuscript edit, Freiman change, paid agent, public release or Prove2Me
mission was made. The original frozen manuscript hash is unchanged.
The hourly task was updated and retained enabled; its earlier platform
failure cause is unknown. See records/automation-repair-20261015.md.
