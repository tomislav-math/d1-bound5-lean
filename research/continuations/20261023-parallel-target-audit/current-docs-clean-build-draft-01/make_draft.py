#!/usr/bin/env python3
"""Research-only documentation proposal from completed, hash-checked receipts."""
from datetime import datetime, timezone
import difflib
import hashlib
import json
from pathlib import Path
import shutil

ROOT = Path('/workspace/scratch/fed64f41ca78')
OUT = ROOT / 'lean-offload/current-docs-clean-build-draft-01'
REMOTE = 'research/continuations/20261023-parallel-target-audit/current-docs-clean-build-draft-01'
PINS = {
    'clean-build/SUMMARY.json': 'a1f72a5787940ae47eec852c68c4bea88f00e845371dfd67a425728a694523af',
    'clean-build/ORIGIN.json': '082a76e73032059147d45ec53b6a878cee97d7104a7653d8f9d8a0ae105feaae',
    'lean-offload/results-clean-final-audits/SUMMARY.json': '5b5a21c944be0923563a6948ce37a39506b8ae9c69a31353fc750f8b2e79db14',
    'lean-offload/results-clean-final-audits/INPUT_FREEZE.json': '698a3a0fecaa49f8451b7fc3e55df85802cab02e14bded5b7a10504dd9b00c95',
    'lean-offload/results-clean-broad-audit/SUMMARY.json': '3f59624818a3e49c1e2705de1182e33a86650aa45ae3dcf1f088ced8dd2a17f2',
    'lean-offload/results-clean-broad-audit-v2/SUMMARY.json': 'ca6cf12fca5019030ad4eaf5ef4c69467f99f539f224f54aec97ac32b1288908',
    'lean-offload/fresh-durable-locks/CLEAN_SOURCE_LOCK.json': 'b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c',
    'lean-offload/repository-verification-proposal/records/proof-source-sha256.txt': 'af5813a4364be84328e0e67bc940f8388c6539b435eb180b7a1fa66857bbe80b',
    'lean-offload/final-installation-plan-02/FINAL_INSTALL_MAP.json': 'cd83528b50a0f2a89b3225498c530efd4aa4defa9da0ebd34522ad69a0d5abfb',
    'lean-offload/final-installation-plan-02/records/verification-tools-sha256.txt': '8bbb2035cb90b849e96a0d1b5b9b0f3e37eb29c44fa4c92b4c502fa42f4875b9',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def save(name, obj):
    (OUT / name).write_text(json.dumps(obj, indent=2, sort_keys=True) + '\n')


raw = {}
for name, expected in PINS.items():
    raw[name] = (ROOT / name).read_bytes()
    assert sha(raw[name]) == expected, name
build = json.loads(raw['clean-build/SUMMARY.json'])
origin = json.loads(raw['clean-build/ORIGIN.json'])
exact = json.loads(raw['lean-offload/results-clean-final-audits/SUMMARY.json'])
freeze = json.loads(raw['lean-offload/results-clean-final-audits/INPUT_FREEZE.json'])
old_broad = json.loads(raw['lean-offload/results-clean-broad-audit/SUMMARY.json'])
broad = json.loads(raw['lean-offload/results-clean-broad-audit-v2/SUMMARY.json'])
lock = json.loads(raw['lean-offload/fresh-durable-locks/CLEAN_SOURCE_LOCK.json'])
install = json.loads(raw['lean-offload/final-installation-plan-02/FINAL_INSTALL_MAP.json'])
assert build['status'] == 'PROJECT_SOURCE_BUILD_COMPLETE_RESUMED'
assert build['completed_modules'] == build['expected_modules'] == 4406
assert not build['active'] and not build['failed'] and not build['waiting']
assert origin['initial_artifact_inventory'] == []
assert exact['status'] == 'CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS'
assert exact['accepted_fresh_project_modules'] == 4406 and exact['post_audit_all_input_hashes_equal'] is True
assert [x['observed_pass_markers'] for x in exact['audits']] == [114, 4]
assert all(x['exit_code'] == 0 for x in exact['audits'])
assert broad['status'] == 'CLEAN_BROAD_COMPATIBILITY_AUDIT_PASS' and broad['exit_code'] == 0
assert broad['all_clean_source_artifact_runtime_git_and_evidence_guards_equal'] is True
assert broad['markers']['including_private_declarations'] == 29602
assert broad['markers']['exported_project_declarations'] == broad['markers']['individual_exported_audit_lines'] == 29145
assert broad['markers']['independent_target_markers'] == 4
assert old_broad['status'] == 'FAILED_NO_BROAD_ACCEPTANCE' and old_broad['exit_code'] == 1
assert broad['broad_source_sha256'] == '0e4779bb1f294d3588dd409e9afe616855346da52172596efabd9adca594537f'
assert exact['main_theorem_complete'] is False and broad['main_theorem_complete'] is False
assert broad['exact_audit_input_freeze_sha256'] == exact['input_freeze_sha256']
logs = {}
for a in exact['audits']:
    p = ROOT / 'lean-offload/results-clean-final-audits' / (a['name'] + '.log')
    assert sha(p.read_bytes()) == a['log_sha256']
    logs[str(p.relative_to(ROOT))] = a['log_sha256']
for folder, result in [('results-clean-broad-audit', old_broad), ('results-clean-broad-audit-v2', broad)]:
    p = ROOT / 'lean-offload' / folder / 'Audit.log'
    assert sha(p.read_bytes()) == result['log_sha256']
    logs[str(p.relative_to(ROOT))] = result['log_sha256']
source_map = {v['relative_path']: v['sha256'] for v in lock['sources'].values()}
manifest_map = {}
for line in raw['lean-offload/repository-verification-proposal/records/proof-source-sha256.txt'].decode().splitlines():
    digest, name = line.split(None, 1)
    assert name not in manifest_map
    manifest_map[name] = digest
assert len(source_map) == len(manifest_map) == 4406 and source_map == manifest_map
for name, expected in source_map.items():
    assert sha((ROOT / 'clean-checkout' / name).read_bytes()) == expected
for name, expected in lock['auxiliary'].items():
    assert sha((ROOT / 'clean-checkout' / name).read_bytes()) == expected
assert len(lock['auxiliary']) == 3
assert freeze['git_identity']['commit'] == '102905a54f1b4db67ed81dd9d2c01d4eb6fd97c2'
assert freeze['git_identity']['tree'] == 'b6dd4139f839698609352d7f9866b4b429d32475'
assert len(freeze['git_identity']['selected_committed_blobs']) == 4412
assert install['count'] == 25
assert next(x for x in install['rows'] if x['target'] == 'D1Bound5.lean')['after_sha256'] == source_map['D1Bound5.lean']
assert next(x for x in install['rows'] if x['target'] == 'scripts/Audit.lean')['after_sha256'] == broad['broad_source_sha256']

copy_map = {
    'clean-build/SUMMARY.json': 'evidence/CLEAN_BUILD_SUMMARY.json',
    'clean-build/ORIGIN.json': 'evidence/CLEAN_BUILD_ORIGIN.json',
    'lean-offload/results-clean-final-audits/SUMMARY.json': 'evidence/CLEAN_118_SUMMARY.json',
    'lean-offload/results-clean-broad-audit/SUMMARY.json': 'evidence/BROAD_V1_FAILED_SUMMARY.json',
    'lean-offload/results-clean-broad-audit-v2/SUMMARY.json': 'evidence/BROAD_V2_SUMMARY.json',
}
for source, target in copy_map.items():
    (OUT / target).write_bytes(raw[source])
when = datetime.now(timezone.utc).isoformat()
evidence = {
    'status': 'RESEARCH_DOCUMENTATION_DRAFT_NOT_INSTALLED_FINAL_KERNEL_PENDING', 'utc': when,
    'source_receipts': {n: {'sha256': h, 'bytes': len(raw[n]), 'local_path': str(ROOT / n),
                            'snapshot_copy': copy_map.get(n)} for n, h in PINS.items()},
    'log_hashes_revalidated': logs,
    'clean_build': {'status': build['status'], 'completed': 4406, 'expected': 4406,
                    'active': 0, 'failed': 0, 'waiting': 0, 'empty_project_origin': True,
                    'completed_through_guarded_resumes': True, 'actual_outer_exit_0': 'Reported by root; summary and guarded per-module provenance are retained'},
    'exact118': {'status': exact['status'], 'markers': [114, 4], 'exit_codes': [0, 0], 'postflight_equal': True},
    'broad_v1': {'status': old_broad['status'], 'exit_code': 1, 'reason': 'Doc-comment /-- before run_cmd at line123; markers do not override failure'},
    'broad_v2': {'status': broad['status'], 'exit_code': 0, 'markers': broad['markers'], 'all_guards_equal': True},
    'fresh_full_root_kernel_replay': 'IN_PROGRESS_REPORTED_BY_ROOT; freeze/dry-run PASS, rootexec92175; no successful final replay receipt claimed',
    'global_final_acceptance': False, 'canonical_installation': 'NOT_PERFORMED_BY_THIS_DRAFT',
    'candidate': {'commit': freeze['git_identity']['commit'], 'tree': freeze['git_identity']['tree'],
                  'source_root': freeze['source_root'], 'artifact_root': freeze['artifact_root'],
                  'build_id': freeze['build_id'], 'identity_hash': freeze['identity_hash'],
                  'source_lock_sha256': freeze['source_lock_sha256'], 'runtime_lock_sha256': freeze['runtime_lock_sha256'],
                  'configuration_sha256': lock['auxiliary'], 'selected_committed_blob_count': 4412},
    'unchanged_original_documents': {
        'README.md': sha((OUT / 'before/README.md').read_bytes()),
        'STATUS.md': sha((OUT / 'before/STATUS.md').read_bytes()),
        'LOCAL_START_HERE.txt': sha((OUT / 'before/LOCAL_START_HERE.txt').read_bytes())},
    'proof_source_to_manifest_map_equality': True, 'live_tested_candidate_4406_source_and_3_config_hashes_equal': True,
    'portable_check_sh_executed_end_to_end': False,
}
save('evidence/CHECKPOINT_EVIDENCE.json', evidence)

readme = (ROOT / 'lean-offload/graph39-review/release-docs-proposal/proposed/README.md').read_text()
old = '''**Final verification is pending:** the clean source build, the 118 exact
statement/axiom checks, the separate broad compatibility audit, and the
full-root fresh kernel replay must all be tied to the same reviewed snapshot.
See `STATUS.md` for individual gate results and evidence references. No public
license or release has been selected.'''
new = '''**Checkpoint, 23 October 2026:** the source build started with an empty
project artifact tree and completed all 4406 modules through guarded resumes.
The 114 original-declaration checks and four independent target axiom checks passed,
as did the separate broad compatibility audit after its recorded comment-only
repair. **The fresh full-root kernel replay is in progress; final publication
remains pending.** The successful receipts refer to the tested candidate snapshot;
they do not yet certify a final release commit. See `STATUS.md` for the exact
evidence and the preserved failed first broad-audit attempt. No public license
or release has been selected.'''
assert readme.count(old) == 1
readme = readme.replace(old, new)
readme = readme.replace('`x*y+1` and its square root may be zero. Equal absolute values are permitted.',
                       '`x*y+1` and its square root may be zero. Equal absolute values (and hence\nequal norms in these fields) are permitted. This is a uniform upper bound;\nthe formal theorem does not assert that a five-element example exists.')
readme = readme.replace('Follow [the verification instructions]',
'''The current run used the reviewed guarded component runners. End-to-end
execution of the packaged `scripts/check.sh` is not claimed by those receipts.
The reviewed installation plan supplies the reproduction tools after the
remaining gates; its canonical installation is still pending at this checkpoint.

Follow [the verification instructions]''')
readme = readme.replace('`records/open-obligations.md`: mathematical dependencies not yet formalized.',
                       '`records/open-obligations.md`: historical mathematical obligation records; current gates are in `STATUS.md`.')
readme = readme.replace('Historical\nlarge extension graphs have not been regenerated in this session.',
                       'Historical\nnumerical archives retain their original provenance.')
readme += f'\nThe previous README is preserved verbatim in [{REMOTE}/before/README.md]({REMOTE}/before/README.md).\n'
(OUT / 'proposed/README.md').write_text(readme)

checkpoint = f'''## 23 October 2026 — full candidate build and audits passed; fresh replay in progress

This checkpoint supersedes earlier progress counts while preserving every
historical entry below. It describes the tested candidate, not an accepted
final release or an executed installation.

The assembled declaration is `D1Bound5.main_statement : D1Bound5.MainStatement`.
For every imaginary quadratic field `K`, each finite nonzero `D(1)` set in the
full integer ring `𝓞 K` has cardinality at most five. The full ring includes
half-integral bases; equal moduli and zero pair square roots are allowed.
The assertion is an upper bound, not a sharpness construction. The independent
target harness expands the proposition and applies it using only its stated
hypotheses; its four axiom checks allow only the fixed standard baseline.

| Gate | Recorded result |
|---|---|
| Source build from an empty project artifact tree | PASS: all 4406 modules; guarded resumes; no active, failed or waiting modules |
| Exact original declarations and independent target | PASS: 114 type/axiom + 4 target axiom markers, both audits exit 0, input hashes equal afterwards |
| Broad compatibility, original attempt | FAILED: exit 1 from a doc-comment before `run_cmd`; retained as failure history |
| Broad compatibility, corrected v2 | PASS: exit 0; 29,145 exported declarations, 29,602 including private declarations, four target markers; all guards equal |
| Fresh official full-root kernel replay | IN PROGRESS, root-owned; freeze/dry-run passed; no successful replay receipt claimed |
| Canonical preservation, installation and publication | PENDING; reviewed plans are not execution receipts |

The build summary is `a1f72a5787940ae47eec852c68c4bea88f00e845371dfd67a425728a694523af`.
The exact118 summary is `5b5a21c944be0923563a6948ce37a39506b8ae9c69a31353fc750f8b2e79db14`;
its input freeze is `698a3a0fecaa49f8451b7fc3e55df85802cab02e14bded5b7a10504dd9b00c95`.
The broad-v2 summary is `ca6cf12fca5019030ad4eaf5ef4c69467f99f539f224f54aec97ac32b1288908`.
The failed original broad summary remains `3f59624818a3e49c1e2705de1182e33a86650aa45ae3dcf1f088ced8dd2a17f2`.
Exact summary copies, original locations and log hashes are recorded in
[{REMOTE}/evidence/CHECKPOINT_EVIDENCE.json]({REMOTE}/evidence/CHECKPOINT_EVIDENCE.json).

The tested commit is `102905a54f1b4db67ed81dd9d2c01d4eb6fd97c2`, tree
`b6dd4139f839698609352d7f9866b4b429d32475`. Its path-independent source lock is
`b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c`, and its
runtime lock is `c50d017cd71b3ee22d299302c15a64d5e82a9b71f95ef6040ca077dc56dbd404`.
The audits allow only `propext`, `Classical.choice`, and `Quot.sound`.
The corrected broad harness removes one hyphen from a doc-comment; it changes
no production proof source or audit body. Both original and corrected evidence
remain separately identified.

The reviewed revision-02 installation map has 25 explicit targets. After the
remaining proof gates, preserve the 353 reviewed extra sources, install the
exact umbrella and tools, and verify the complete 4406-path production set,
all source hashes, all three configuration pins, both manifests and the source
lock. A matching import-closure lock alone does not exclude unused extra files.
Preserve the tested runtime, paths, commit/tree, origin and receipt identities;
a later source-equivalence record must not rename them as a run of the released
commit or as an end-to-end run of the portable wrapper.
The detailed pending bridge is [{REMOTE}/SOURCE_EQUIVALENCE_BRIDGE_OUTLINE.md]({REMOTE}/SOURCE_EQUIVALENCE_BRIDGE_OUTLINE.md).

The historical entries below retain their original dates, statements and evidence.

'''
prior_status = (OUT / 'before/STATUS.md').read_text()
assert prior_status.startswith('# Status\n\n')
new_status = '# Status\n\n' + checkpoint + prior_status[len('# Status\n\n'):]
assert new_status.endswith(prior_status[len('# Status\n\n'):])
(OUT / 'proposed/STATUS.md').write_text(new_status)

handoff = f'''D1Bound5 continuation checkpoint — 23 October 2026
Research-only draft; not installed in D1Bound5Handoff or the canonical repository.

Read this checkpoint together with the original D1_bound5_formalization_prompt.txt
and its preservation/verification constraints. Keep that prompt and the original
handoff files unchanged. The old statement that formalization has not started
is historical; do not create a replacement project or restart completed work.

MATHEMATICAL TARGET
Za svako imaginarno kvadratno polje K, svaki konačan skup A u punom prstenu
cijelih O_K, sastavljen od nenultih elemenata, za koji je ab+1 kvadrat u O_K
za sve različite a,b iz A, ima najviše pet elemenata. Jednake norme i nulti
kvadratni korijeni parova dopušteni su. Ovo je gornja granica ≤5, a ne tvrdnja
o postojanju peteročlanog primjera.

Formal names: D1Bound5.main_statement, D1Bound5.MainStatement, D1Bound5.IsD1.
The independent target harness expands the statement with no additional
estimate, classification, coordinate-model or certificate premise.

COMPLETED RECEIPTS
- Fresh-origin project build completed through guarded resumes: 4406/4406,
  no active/failed/waiting modules. Root observed the builder's actual exit0.
  Summary SHA a1f72a5787940ae47eec852c68c4bea88f00e845371dfd67a425728a694523af.
- Clean exact audit: 114 original named declarations + 4 target axiom checks, exit0
  for both harnesses, all input hashes equal afterwards. Summary SHA
  5b5a21c944be0923563a6948ce37a39506b8ae9c69a31353fc750f8b2e79db14.
- Broad v2 audit: exit0, 29145 exported/29602 including private declarations,
  four target markers, all source/artifact/runtime/Git/evidence guards equal.
  Summary SHA ca6cf12fca5019030ad4eaf5ef4c69467f99f539f224f54aec97ac32b1288908.
- Original broad attempt failed with exit1 at the doc-comment before run_cmd.
  Keep its summary/log and original source. The reviewed v2 removes exactly one
  hyphen from that comment; the runner changes only its expected source hash.

STILL REQUIRED
1. The official fresh full-root kernel replay is running under root session 92175.
   Do not start a second replay. Inspect its actual exit/result and pre/post guards. These receipts do not claim that replay.
2. Capture the final execution evidence quiescently using the reviewed export
   plan; preserve failure/resource history. Do not infer success from markers
   when a process exits nonzero.
3. Root coordinates the reviewed preservation of353 extra sources and the
   revision-02 installation map, then verifies the final source/config/tool
   identities and updates current documentation from actual receipts.
4. Root alone handles exact staging, private Git preflight, commit and push.
   Refresh reviewed HEAD/index after any research-only checkpoint commit;
   never alter the frozen historical preservation plan to conceal that change.

IDENTITIES AND LOCATIONS
Mac repository: /Users/tp/Lean/D1Bound5.
Original preserved handoff: /Users/tp/Lean/D1Bound5Handoff.
Tested source: /workspace/scratch/fed64f41ca78/clean-checkout.
Tested project artifacts: /workspace/scratch/fed64f41ca78/clean-build/artifacts.
Tested commit102905a54f1b4db67ed81dd9d2c01d4eb6fd97c2,
tree b6dd4139f839698609352d7f9866b4b429d32475.
Source lock b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c.
Runtime lock c50d017cd71b3ee22d299302c15a64d5e82a9b71f95ef6040ca077dc56dbd404.
Exact audit freeze698a3a0fecaa49f8451b7fc3e55df85802cab02e14bded5b7a10504dd9b00c95.
Build origin, runtime paths, artifacts and Git identities belong to the actual
tested run. A future byte-equivalent release needs an explicit bridge; it does
not retroactively become that run. The portable check.sh was not executed
end-to-end by these component-runner receipts.

Reviewed current install plan:
research/continuations/20261023-parallel-graphs-b/final-installation-plan-02/.
Its map SHA is cd83528b50a0f2a89b3225498c530efd4aa4defa9da0ebd34522ad69a0d5abfb.
The original final-installation-plan-01 and failed broad-v1 records remain historical.

This checkpoint's exact evidence and proposed documents are under
{REMOTE}/.
It is a pending-status draft. No canonical document, handoff, source, runtime,
Git index or Git history was changed by preparing it.
'''
handoff = handoff.replace('of353', 'of 353').replace('commit102905', 'commit 102905').replace('freeze698a', 'freeze 698a')
(OUT / 'proposed/LOCAL_START_HERE.txt').write_text(handoff)

bridge = f'''# Source-equivalence evidence bridge — outline, not an installed-release claim

This outline records the successful tested snapshot and the exact checks needed
to connect a later canonical publication to it. The fresh full-root replay is
in progress; canonical preservation/installation and the final source-equivalence
receipt remain pending. The original run identities and failed broad-v1 evidence remain intact.

| Object | Tested or prepared identity | Status |
|---|---|---|
| Tested source commit/tree | `102905a54f1b4db67ed81dd9d2c01d4eb6fd97c2` / `b6dd4139f839698609352d7f9866b4b429d32475` | Fixed historical run identity |
| Project source lock | `b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c` | 4406 reachable source paths/imports/hashes and 3 configuration pins |
| Production-only SHA manifest | `af5813a4364be84328e0e67bc940f8388c6539b435eb180b7a1fa66857bbe80b` | Exactly equals the source lock's 4406 relative-path/hash map |
| Full source-policy path map | `fa84386224dedc9b6a9a4fa76679b7bdaf1250cf1927e0ae59c170bc4eee9550` | Must be regenerated and matched after installation to exclude unused extras |
| Runtime lock | `c50d017cd71b3ee22d299302c15a64d5e82a9b71f95ef6040ca077dc56dbd404` | Historical tested runtime/cache identity; never relabel |
| Empty-origin build | origin `082a76e73032059147d45ec53b6a878cee97d7104a7653d8f9d8a0ae105feaae`, summary `a1f72a5787940ae47eec852c68c4bea88f00e845371dfd67a425728a694523af` | Completed 4406 through guarded resumes |
| Exact118 freeze/summary | `698a3a0fecaa49f8451b7fc3e55df85802cab02e14bded5b7a10504dd9b00c95` / `5b5a21c944be0923563a6948ce37a39506b8ae9c69a31353fc750f8b2e79db14` | PASS, actual tested commit/tree and 4412 selected Git blobs bound |
| Corrected broad audit | source `0e4779bb1f294d3588dd409e9afe616855346da52172596efabd9adca594537f`, summary `ca6cf12fca5019030ad4eaf5ef4c69467f99f539f224f54aec97ac32b1288908` | v2 PASS; original exit1 remains separate |
| Installation revision02 | map `cd83528b50a0f2a89b3225498c530efd4aa4defa9da0ebd34522ad69a0d5abfb` | Reviewed preparation only, 25 explicit targets |
| Tool manifest revision02 | `8bbb2035cb90b849e96a0d1b5b9b0f3e37eb29c44fa4c92b4c502fa42f4875b9` | 75 tool/config/history paths, corrected broad harness; not production-source identity |
| Final installed commit/tree and fresh replay result | Unfilled | Must come from actual later operations and successful receipts |

## Required production/configuration correspondence

The reviewed Mac inventory contains 4759 Lean sources: 4406 selected and 353
untracked extras. Preserve the 353 through the reviewed executor and retain its
actual execution receipt. The 4405 selected namespace files are specified to
remain unchanged. The sole production edit is the umbrella:

`33c5f8a0eb94b1ab1196054d8189a968dbe6da8f19ae818d962e435ea72a43c2`
→ `a45a579195a0e787c3e1986e2e0ee671ca64fa82aa030d0c68908c1f61f5982d`.

It appends exactly `\\nimport D1Bound5.MainTheorem\\n` while retaining all legacy
imports. The resulting bytes equal the tested candidate root. This proposal
mapping is checked; live canonical installation is not asserted here.

The configuration pins are unchanged:

'''
for name, digest in sorted(lock['auxiliary'].items()):
    bridge += f'- `{name}`: `{digest}`.\n'
bridge += '''
After installation, compare every production relative path and SHA, verify
there are exactly those4406 production files, run the reviewed source-policy
gate, and regenerate the source lock. Both source-set equality and lock equality
are necessary: the lock alone describes reachable imports and cannot rule out
unimported extra files. Verify all25 installation targets and all75 tool-manifest
rows separately. Documentation edits belong to their own reviewed scope.

## Bridge receipt fields to fill only after real operations

Record the canonical root, actual reviewed HEAD/index, preservation receipt,
installation map/version and per-target results, complete production path/hash
map, three configuration pins, source-policy result/map, regenerated source-lock
hash and proof/tool manifest checks. Bind staged Git blobs and then the actual
commit/tree and private push result in separate records, since a commit cannot
contain its own future hash. Attach the actual fresh-root replay result and
freeze hashes without changing any tested-run identity.

The resulting claim is exact released-production/configuration byte-equivalence
to the tested snapshot, with an explicit tooling mapping. It does not claim the
final commit ran in the old environment, that a changed broad audit was covered
by the failed first run, or that the portable check.sh was executed end-to-end.
A later clean clone derives its own commit/tree and runtime paths, generates its
own reviewed locks and starts with empty project artifacts. Resume is restricted
to the same frozen run identity.
'''
bridge = bridge.replace('those4406', 'those 4406').replace('all25', 'all 25').replace('all75', 'all 75')
(OUT / 'SOURCE_EQUIVALENCE_BRIDGE_OUTLINE.md').write_text(bridge)
for name in ['README.md', 'STATUS.md', 'LOCAL_START_HERE.txt']:
    a=(OUT/'before'/name).read_text().splitlines(True)
    b=(OUT/'proposed'/name).read_text().splitlines(True)
    (OUT/(name.replace('.', '_')+'.pending.diff')).write_text(''.join(difflib.unified_diff(a,b,fromfile='before/'+name,tofile='proposed/'+name)))
for name, expected in PINS.items():
    assert sha((ROOT/name).read_bytes()) == expected, 'Input changed: '+name
files={p.relative_to(OUT).as_posix(): {'sha256':sha(p.read_bytes()),'bytes':p.stat().st_size}
       for p in sorted(OUT.rglob('*')) if p.is_file() and p.name not in ['PACKAGE_MANIFEST.json']}
save('PACKAGE_MANIFEST.json', {'status':'RESEARCH_ONLY_DRAFT_BUILD118_AND_BROAD_V2_PASS_FRESH_KERNEL_IN_PROGRESS',
    'utc':when,'files':files,'file_count':len(files),'canonical_or_handoff_writes':False,'Git_mutations':False,
    'Lean_or_checker_execution_by_author':False,'original_status_history_preserved_verbatim':True,
    'original_readme_and_handoff_preserved':True,'final_success_claim':False})
print(json.dumps({'status':'DRAFT_PREPARED','files':len(files)+1,'bytes':sum(x['bytes'] for x in files.values()),
                  'manifest_sha256':sha((OUT/'PACKAGE_MANIFEST.json').read_bytes())},indent=2))
