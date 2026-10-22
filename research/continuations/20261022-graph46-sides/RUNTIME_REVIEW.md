# Graph 46 side verification workflow

Status: **local preparation only; foundation unbound; no runtime entry point
executed**. This directory contains five new scripts for the existing guarded
Mac workflow. It does not contain `REVIEWED_FOUNDATION_BINDING.json`.

The source payload is frozen at manifest SHA-256
`0a5f79888d094e6111fa6279bc14d72a784981734fe93735dc8c57f62308b3e3`.
It preserves the actual model `(1, 6)`, left/right sizes 360/358, original parent
counts 137+223 and 138+220, four public parent headers and both wrapper files.
The side source proposal contains 20 helpers and 26 nominal build/replay targets
with 32 theorems. Its first two targets are separate 16-head pilots.

## Required actual foundation evidence

The installer accepts the exact payload-manifest SHA-256 and the SHA-256 of an
independently populated, reviewed foundation binding. The supplied template has
status `UNBOUND_DO_NOT_RUN`, null future values, and a different filename from
the required executable binding. No example receipt or template can supply the
actual graph 46 binding.

The real binding must identify the current installation HEAD, the actual
published foundation commit, the foundation proof fingerprint, and hashes of
the **26 files** returned by `installer.py`'s `foundation_binding_files()`.
`REVIEWED_FOUNDATION_BINDING.TEMPLATE.json` lists those exact paths. They include
the completed foundation summary, source/proof/evidence maps, configuration and
target list, actual input/provenance/source-inspection bindings, prepared payload
map, declaration origins, installation receipt, completed audit/replay records,
and publication evidence.

The installer verifies the frozen pure foundation helper at SHA-256
`7bddb13018a45ef5f65aaf5b7f64d845e08cde31f91f64a0da23397f4e5c301f`.
It uses that helper to reproduce the original-data partition and validate all
prepared foundation inputs. It connects the original three foundation source
hashes to the pinned side source observation, then checks 19 definitions and
four theorems, seven accepted bounded builds, seven installed same-kernel
replays, original-type/axiom audit markers, exact replay guard maps, actual
current source and artifact fingerprints, proof-state hash, and provenance.

Publication verification uses the actual `PRIVATE_PUSH_VERIFIED` receipt,
successful commit/push exits, equal local and remote publication heads, private
repository identity, selected committed blob hashes, and an inactive/released
publication owner. The published commit must be an ancestor of the actual
installation HEAD. The foundation evidence must match that published commit.
`POST_PUSH_RECEIPT.json`, `OWNER.json`, and `RELEASE.json` are separately bound
by their actual bytes; a receipt written after a push is not required to occur
in its own publication commit. The graph 1 receipt in this local directory is
an example of the existing schema and is never read by the runtime scripts.

## Installation and serial verification

`installer.py` holds both existing project locks and requires an idle driver,
no live project compiler, a clear index, the `main` branch, paused serial queue,
unchanged root/configuration, original source bytes, and accepted external
dependencies. It refuses existing exact attempts or prior installation outputs.
It snapshots all originals and candidates, replaces only the four reviewed
parent proof sources, adds the twenty helper sources and queue entries, and
retains both wrapper sources unchanged. It runs no compiler and mutates no Git
state or accepted baseline.

The remaining steps are separate commands in this order:

| Step | Script or existing runner | Result required |
| --- | --- | --- |
| Build the pilots | `build_scope.py sides-pilot` | Two guarded builds pass |
| Prepare pilot checks | `prepare_checks.py sides-pilot` | Exact original declarations and bound audit inputs |
| Bind, check and run pilot audit | Existing pinned scoped audit runner | Type/transitive-axiom audit and two same-kernel replays pass |
| Record pilot result | `finish_checks.py sides-pilot` | Actual `SCOPED_VERIFICATION_PASS` and proof state |
| Review pilot measurements | Review actual build/replay receipts | Remaining graph 46 work is justified under the unchanged cap |
| Complete the left remainder | The same build/prepare/runner/finish sequence for `left-rest` | Twelve builds/replays and fifteen theorem checks pass |
| Complete the right remainder | The same sequence for `right-rest` | Twelve builds/replays and fifteen theorem checks pass |

`build_scope.py` serializes scope controllers and invokes only the fixed target
list. It checks protected inputs before and after every worker, keeps durable
batch records, forwards stop signals, and waits for the worker to drain its
compiler children. `bounded_build.py` uses the existing pinned driver with one
thread, both project locks, and the unchanged **240-second inner target cap**.
Every exact prior attempt is rejected. The worker itself requires both
completed verified pilots before launching any remainder target, even if it is
invoked directly.

Both the controller and worker recheck the installed binding, actual HEAD,
queue, root, configuration, and protected foundation/source/artifact evidence.
The audit preparation and finisher perform the same phase checks. Their stored
status remains a side result, with `whole_graph46_complete`, `root_integration`,
and `main_theorem_complete` all false.

## Exact type, axiom and kernel checks

Each audit compares the parsed public declarations with the original snapshots,
constructs examples at those exact types, and collects the transitive axioms of
all target theorems. The retained allowed axiom list is `propext`,
`Classical.choice`, and `Quot.sound`. The existing pinned scoped runner performs
one installed same-kernel replay for every target under both locks and its
240-second per-command cap.

The finisher requires exact target order, successful bound receipts, no timeout
or binding drift, the expected original-type/axiom marker count, current source
and artifact manifests, and equality of replay guard inputs with the actual
binding. It preserves the established proof-state schema. The reusable
`verify_bound_checks()` function does not require the old installation HEAD to
remain current, so a later closure workflow can validate completed scopes after
their publication. The phase-only `verify_installation()` intentionally retains
the installation HEAD condition and must not be used for later post-publication
reuse.

The prior graph 17 provenance-map paths remain historical graph 17 paths. They
are not renamed when adapting graph 1's side workflow to graph 46.

## Local review limits

Local checks cover Python syntax, literal source pins, all cross-script hash
references, exact 2/12/12 target lists, 2/15/15 public declaration counts,
the frozen payload file set including `SOURCE_EVIDENCE.json`, and absence of an
executable foundation binding. An independent reviewer examined the source,
foundation/publication schema, locks, timeout, refusal of repeated fingerprints,
and worker lifetime. An erroneous historical-path substitution was corrected
before any execution, and all dependent script pins were refreshed.

These checks do not replace the future real foundation binding, bounded builds,
type/axiom checks, kernel replays, or publication. No remote command, Lean run,
Git operation, foundation-script change, or graph 1 file change was performed
to prepare this directory.
