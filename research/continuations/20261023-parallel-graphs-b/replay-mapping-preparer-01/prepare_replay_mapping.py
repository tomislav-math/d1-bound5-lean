#!/usr/bin/env python3
"""Prepare only: preserve historical bytes and write an UNACCEPTED bridge map.

No Lean, compiler, freeze, checker, Git mutation, or automatic selection. The
parent must review the produced manifest SHA and run the separately reviewed
bridge validator afterwards. Real use requires all current gates first.
"""
import argparse
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import stat
import sys
import types

WORKSPACE = Path('/workspace/scratch/fed64f41ca78')
MIRROR = Path('/tmp/d1bound5-second-loss-recovery-20261023/authoritative-workspace')
COMPILE = WORKSPACE/'recovery-20261023/source'
REPLAY = MIRROR/'recovery-20261023/source'
BUILD = Path('/tmp/d1bound5-verification-20261023/clean-build')
RUNTIME = Path('/tmp/d1bound5-verification-20261023/runtime')
EVIDENCE = BUILD.parent/'evidence'
POLICY_HISTORY = Path('/Users/tp/Lean/D1Bound5/research/continuations/20261023-parallel-target-audit/post-proof-order-repairs/source-policy-final')
BRIDGE_SHA = '829d6a30fd1b35ffda307b88342e100fec24038de23052aa92b39d298967d446'
SOURCE_LOCK_SHA = 'b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c'
RUNTIME_LOCK_SHA = '5c83f7bd62e806af5aca7f63dde0f124ca04cea9dee5028744f8e606826b16fc'
ORIGIN_SHA = 'c2f3ad9fe463b99529db5586397a291f268c18fed12f5b27eaf30cc6876f3795'
BUILD_ID = '2c06f4e3f2014ea78ba92a0b48e5ad92'
IDENTITY = '8f423712a4950a66821d8a82716de9c6e9cbc83ad175d3d54ff8ddf1d47eda39'
COMMIT = 'b4c81242dd9c9cee6966a1e08bce0f94c66f1491'
TREE = 'ee490da49ba30447d92745140f48c1ae3c34f263'
COUNT = 4406
EXACT_HELPER_SHA = '553767859804a0ae0fb29fe7bb6f2844d3d331b06898971a6994b2d533166830'
BROAD_HELPER_SHA = 'e27e4ba3bd62f7a3463690ba0383754a3d99293685b07c6deb40ef7a5d6a43e4'
BUILDER_SHA = '349a4e81d9ae80f66e505f3fa927cbde3a0a287cdb1e9971f1d6295d2b797da0'
FIXED = {
 'source_lock': ('recovery-20261023/restored-tools/original-identities/CLEAN_SOURCE_LOCK.json', SOURCE_LOCK_SHA),
 'runtime_lock': ('recovery-20261023/runtime/RECOVERY_RUNTIME_LOCK_V2.json', RUNTIME_LOCK_SHA),
 'inventory': ('recovery-20261023/final-kernel-preparation/CANONICAL_SOURCE_INVENTORY.json', 'fb9926544ba00591531c865e474c0ddeed92fcf67a7efc4f25e98814b7946931'),
 'lean_env': ('recovery-20261023/final-kernel-preparation/RECOVERY_ENV.json', 'e334f6db7cd955cb75fe6d065e2e72ea75d80d19a689fc9291ee9e0d92758ed8'),
 'exact_invocation': ('recovery-20261023/evidence-path-revision-02/CLEAN118_INVOCATION.json', '572678ee337686a968645696aeeadcded5576cea02c2398a39388a1acf1aa8a2'),
 'broad_invocation': ('recovery-20261023/evidence-path-revision-02/BROAD_INVOCATION.json', '39d69b27f274401d8daf8a5b80484605d554425715ce4c0af5398c2be592c31e'),
 'configuration': ('recovery-20261023/evidence-path-revision-02/RECOVERY_CONFIGURATION.json', '656570ee199f6c2e8155619948ed3739fd131835c20535074bd527c499480c6b'),
}


def require(ok, message):
    if not ok: raise ValueError(message)


def digest(value):
    return hashlib.sha256(value).hexdigest()


def canonical(value, exists=True):
    p = Path(value)
    require(p.is_absolute() and str(p) == str(value) and '..' not in p.parts, 'Noncanonical absolute path')
    for q in (p, *p.parents): require(not q.is_symlink(), 'Symlink path component: '+str(q))
    if exists: require(p.resolve(strict=True) == p, 'Alias path: '+str(p))
    return p


def stamp(st):
    return [st.st_dev, st.st_ino, st.st_size, st.st_mtime_ns, st.st_ctime_ns]


class Inputs:
    def __init__(self): self.rows = {}; self.bodies = {}

    def capture(self, path, expected=None):
        p = canonical(str(path))
        require(p.is_file(), 'Not a regular input: '+str(p))
        before = p.stat()
        fd = os.open(p, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK)
        try:
            require(stat.S_ISREG(os.fstat(fd).st_mode) and stamp(os.fstat(fd)) == stamp(before), 'Input replaced/nonregular before open')
            with os.fdopen(fd, 'rb', closefd=False) as stream: body = stream.read()
            after = os.fstat(fd)
        finally: os.close(fd)
        require(stamp(before) == stamp(after) == stamp(p.stat()), 'Input changed during read')
        actual = digest(body)
        require(expected is None or actual == expected, 'Input SHA mismatch: '+str(p))
        row = {'sha256': actual, 'bytes': len(body), 'stat': stamp(after)}
        require(str(p) not in self.rows or self.rows[str(p)] == row, 'Input changed between reads')
        self.rows[str(p)] = row; self.bodies[str(p)] = body
        return body

    def historical(self, old, expected):
        old = canonical(str(old), exists=False)
        actual = old
        if not old.exists() and old.is_relative_to(WORKSPACE):
            actual = MIRROR/old.relative_to(WORKSPACE)
        self.capture(actual, expected)
        return actual

    def recheck(self):
        for p, row in list(self.rows.items()):
            self.capture(p, row['sha256'])


def load_bridge(path, inputs):
    body = inputs.capture(path, BRIDGE_SHA)
    mod = types.ModuleType('reviewed_optional_bridge_preparer_dependency')
    mod.__file__ = str(canonical(str(path)))
    exec(compile(body, mod.__file__, 'exec'), mod.__dict__)
    inputs.capture(path, BRIDGE_SHA)
    return mod


def parsed(inputs, path, expected=None):
    return json.loads(inputs.capture(path, expected))


def option(argv, name):
    require(argv.count(name) == 1 and argv.index(name)+1 < len(argv), 'Missing/duplicate invocation argument '+name)
    return argv[argv.index(name)+1]


def inspect(args):
    """Only read/hash metadata and read-only Git; no writes or replay validation."""
    inputs = Inputs()
    inputs.capture(canonical(str(Path(__file__).absolute())))
    # Fail early for a running/pending build, before reading large snapshots.
    origin = parsed(inputs, BUILD/'ORIGIN.json', ORIGIN_SHA)
    summary = parsed(inputs, BUILD/'SUMMARY.json')
    require(origin['build_id'] == BUILD_ID and origin['identity_hash'] == IDENTITY and
            digest(json.dumps(origin['identity'], sort_keys=True, separators=(',', ':')).encode()) == IDENTITY and
            origin['initial_artifact_inventory'] == [] and origin['identity']['source_root'] == str(COMPILE) and
            origin['identity']['build_dir'] == str(BUILD) and origin['identity']['runner_sha256'] == BUILDER_SHA and
            origin['identity']['source_lock_sha256'] == SOURCE_LOCK_SHA and origin['identity']['runtime_lock_sha256'] == RUNTIME_LOCK_SHA and
            origin['identity']['lean_arguments'] == ['-j1', '-DautoImplicit=false', '-R', str(COMPILE)], 'Fixed original build identity mismatch')
    require(summary['status'] in ('FRESH_PROJECT_SOURCE_BUILD_PASS', 'PROJECT_SOURCE_BUILD_COMPLETE_RESUMED') and
            summary['build_id'] == BUILD_ID and summary['identity_hash'] == IDENTITY and
            summary['fresh_project_origin'] is True and summary['roots'] == ['D1Bound5'] and
            summary['expected_modules'] == summary['completed_modules'] == COUNT and
            not summary['active'] and not summary['failed'] and not summary['waiting'], 'Current full build is not terminal complete')
    fixed = {}; fixed_paths = {}
    for role, (relative, expected) in FIXED.items():
        actual = inputs.historical(WORKSPACE/relative, expected)
        fixed_paths[role] = actual; fixed[role] = json.loads(inputs.bodies[str(actual)])
    sl = fixed['source_lock']; rt = fixed['runtime_lock']
    names = summary['compiled_this_invocation']+summary['validated_passes_from_prior_invocations']
    require(len(names) == len(set(names)) == COUNT and set(names) == set(sl['sources']) and
            sl['module_count'] == COUNT and sl['roots'] == ['D1Bound5'], 'Completed build source scope differs')
    bridge = load_bridge(args.bridge_helper, inputs)
    expected_sources = {row['relative_path']: row['sha256'] for row in sl['sources'].values()}
    expected_sources.update(sl['auxiliary']); expected_sources.update(bridge.BRIDGE_HARNESSES)
    require(set(sl['auxiliary']) == {'lean-toolchain','lakefile.lean','lake-manifest.json'} and len(expected_sources) == COUNT+5, 'Wrong complete clone scope')
    git_before, dirs_before = bridge.bridge_git(REPLAY, expected_sources)
    require(git_before['commit'] == COMMIT and git_before['tree'] == TREE, 'Retained clone identity differs')
    compiler = str(RUNTIME/'lean-4.33.1-linux/bin/lean')
    require(rt['lean'] == compiler, 'Compiler identity differs')
    exact_out = EVIDENCE/'clean118'; broad_out = EVIDENCE/'broad'
    roles = {
      'exact_summary': exact_out/'SUMMARY.json', 'exact_input_freeze': exact_out/'INPUT_FREEZE.json',
      'integration_log': exact_out/'FinalIntegrationAudit.log', 'target_log': exact_out/'FinalTargetAudit.log',
      'broad_summary': broad_out/'SUMMARY.json', 'broad_evidence_freeze': broad_out/'EVIDENCE_FREEZE.json',
      'broad_log': broad_out/'Audit.log', 'source_policy_report': POLICY_HISTORY/'SOURCE_POLICY_REPORT.json',
      'source_policy_manifest': POLICY_HISTORY/'SOURCE_MANIFEST.json'}
    actual_roles = dict(roles)
    actual_roles.update(source_policy_report=canonical(str(args.source_policy_report)), source_policy_manifest=canonical(str(args.source_policy_manifest)))
    records = {}
    for role, path in actual_roles.items():
        expected = bridge.BRIDGE_POLICY_SHA if role == 'source_policy_report' else bridge.BRIDGE_POLICY_MANIFEST_SHA if role == 'source_policy_manifest' else None
        records[role] = inputs.capture(path, expected)
    exact = json.loads(records['exact_summary']); audited = json.loads(records['exact_input_freeze'])
    broad = json.loads(records['broad_summary']); bf = json.loads(records['broad_evidence_freeze'])
    require(exact['status'] == 'CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS' and exact['post_audit_all_input_hashes_equal'] is True and
            exact['accepted_fresh_project_modules'] == COUNT and exact['input_freeze_sha256'] == digest(records['exact_input_freeze']) and
            exact['source_lock_sha256'] == SOURCE_LOCK_SHA and exact['runtime_lock_sha256'] == RUNTIME_LOCK_SHA, 'Exact118 gate is not accepted')
    require(audited['schema'] == 1 and audited['source_root'] == str(COMPILE) and audited['build_dir'] == str(BUILD) and
            audited['artifact_root'] == str(BUILD/'artifacts') and audited['build_id'] == BUILD_ID and audited['identity_hash'] == IDENTITY and
            audited['source_lock_sha256'] == SOURCE_LOCK_SHA and audited['runtime_lock_sha256'] == RUNTIME_LOCK_SHA and
            audited['accepted_modules'] == COUNT and audited['lean'] == compiler and audited['environment'] == origin['identity']['environment'] and
            audited['git_identity'] == git_before and audited['runtime_inventory_sha256'] == bridge.bridge_digest(rt['files']) and
            audited['runtime_file_count'] == len(rt['files']), 'Exact audit snapshot identity differs')
    exact_argv = fixed['exact_invocation']['argv']; broad_argv = fixed['broad_invocation']['argv']
    require(option(exact_argv,'--source-root') == str(COMPILE) and option(exact_argv,'--out') == str(exact_out) and
            option(exact_argv,'--artifact-root') == str(BUILD/'artifacts') and option(exact_argv,'--build-dir') == str(BUILD) and
            option(exact_argv,'--expected-commit') == COMMIT and option(exact_argv,'--expected-tree') == TREE and
            option(broad_argv,'--out') == str(broad_out), 'Fixed invocation paths differ')
    require(len(exact['audits']) == 2, 'Exact audit result count differs')
    for row, name, role, count, marker, arg in zip(exact['audits'], ['FinalIntegrationAudit','FinalTargetAudit'],
            ['integration_log','target_log'], [114,4], ['ORIGINAL_TYPE_AXIOMS_PASS','FINAL_TARGET_AXIOMS_PASS'],
            ['--integration-audit','--target-audit']):
        harness = option(exact_argv,arg); relative = str(Path(harness).relative_to(COMPILE))
        require(row['name'] == name and row['exit_code'] == 0 and row['expected_pass_markers'] == row['observed_pass_markers'] == count and
                row['audit_sha256'] == bridge.BRIDGE_HARNESSES[relative] and row['log_sha256'] == digest(records[role]) and
                records[role].decode().count(marker) == count and row['command'] == [compiler,'-j1','-DautoImplicit=false','-R',str(COMPILE),harness], 'Exact audit log/command mismatch')
    require(broad['status'] == 'CLEAN_BROAD_COMPATIBILITY_AUDIT_PASS' and broad['exit_code'] == 0 and
            broad['all_clean_source_artifact_runtime_git_and_evidence_guards_equal'] is True and
            broad['exact_audit_input_freeze_sha256'] == bf['exact_audit_input_freeze_sha256'] == digest(records['exact_input_freeze']) and
            broad['broad_source_sha256'] == bridge.BRIDGE_BROAD_SHA and broad['log_sha256'] == digest(records['broad_log']), 'Broad gate is not accepted')
    broad_source = option(broad_argv,'--broad-audit')
    require(broad['command'] == [compiler,'-j1','-DautoImplicit=false','-R',str(Path(broad_source).parent),broad_source] and
            bf['command_root'] == str(Path(broad_source).parent) and bf['files'].get(broad_source) == bridge.BRIDGE_BROAD_SHA, 'Broad historical command differs')
    lines = records['broad_log'].decode().splitlines()
    public = [int(m.group(1)) for line in lines if (m := re.fullmatch(r'AXIOM_AUDIT_PASS: (\d+) project declarations',line.strip()))]
    private = [int(m.group(1)) for line in lines if (m := re.fullmatch(r'BROAD_PROJECT_AXIOM_AUDIT_PASS (\d+) declarations',line.strip()))]
    target = [m.group(1) for line in lines if (m := re.match(r'^FINAL_TARGET_AXIOMS_PASS (D1Bound5\.[^: ]+):',line.strip()))]
    individual = sum(line.strip().startswith('AUDIT D1Bound5.') or line.strip().startswith('AUDIT D1Bound5:') for line in lines)
    require(len(public) == len(private) == 1 and public[0] > 0 and private[0] >= public[0] and individual == public[0] and len(target) == 4 and
            set(target) == {'D1Bound5.MainStatement','D1Bound5.IsD1','D1Bound5.IsD1Tuple','D1Bound5.main_statement'} and
            broad['markers'] == {'exported_project_declarations':public[0],'including_private_declarations':private[0],
             'independent_target_markers':4,'individual_exported_audit_lines':individual}, 'Broad actual/recorded markers differ')
    for role in ('exact_summary','exact_input_freeze','integration_log','target_log'):
        require(bf['files'].get(str(roles[role])) == digest(records[role]), 'Broad omits exact gate record')
    # Only metadata is copied. Source files map by relative path; unchanged
    # build/runtime artifacts remain at their original roots for later bridge
    # validation. This preparer deliberately does not claim a new full replay
    # or full accepted-receipt/artifact/runtime integrity revalidation.
    selected = {str(old): (actual_roles[role], digest(records[role])) for role, old in roles.items()}
    all_historical = {}
    for evidence in (audited['files'], bf['files']):
        for old, expected in evidence.items():
            canonical(old, exists=False)
            require(old not in all_historical or all_historical[old] == expected, 'Conflicting historical expected hashes')
            all_historical[old] = expected
            p = Path(old)
            if p.is_relative_to(COMPILE):
                relative = str(p.relative_to(COMPILE))
                require(expected_sources.get(relative) == expected, 'Historical source map differs')
            elif p.is_relative_to(BUILD) or old in rt['files'] or p == RUNTIME/'fresh_project_build.py':
                # Membership, all accepted receipt chains and every artifact
                # hash are checked by the mandatory later bridge freeze.
                pass
            else:
                actual = inputs.historical(p, expected)
                require(old not in selected or selected[old] == (actual,expected), 'Historical role/source collision')
                selected[old] = (actual,expected)
    for relative, expected in expected_sources.items():
        require(audited['files'].get(str(COMPILE/relative)) == expected, 'Exact audit omits selected source/config/harness')
    require(audited['files'].get(str(BUILD/'ORIGIN.json')) == ORIGIN_SHA and
            audited['files'].get(str(BUILD/'SUMMARY.json')) == digest(inputs.bodies[str(BUILD/'SUMMARY.json')]), 'Exact audit build records mismatch')
    for old, expected in [(exact_argv[1],EXACT_HELPER_SHA), (broad_argv[1],BROAD_HELPER_SHA),
                          (option(exact_argv,'--build-runner'),BUILDER_SHA)]:
        require(all_historical.get(old) == expected, 'Reviewed helper/builder omitted or changed in historical freezes')
    for role in ('source_lock','runtime_lock'):
        old = str(WORKSPACE/FIXED[role][0]); require(all_historical.get(old) == FIXED[role][1], 'Historical lock mismatch')
    require(bf['files'].get(option(broad_argv,'--invocation')) == FIXED['exact_invocation'][1], 'Broad invocation binding differs')
    inputs.recheck()
    require(bridge.bridge_git(REPLAY, expected_sources) == (git_before,dirs_before), 'Retained clone changed during preparation scan')
    return {'inputs':inputs,'bridge':bridge,'origin':origin,'summary':summary,'selected':selected,'roles':roles,
            'fixed_paths':fixed_paths,'expected_sources':expected_sources,'git_identity':git_before,'directories':dirs_before,
            'bridge_helper':canonical(str(args.bridge_helper))}


def fsync_dir(path):
    fd=os.open(path,os.O_RDONLY|os.O_DIRECTORY|os.O_NOFOLLOW)
    try: os.fsync(fd)
    finally: os.close(fd)


def new_directory(path):
    canonical(str(path.parent)); require(not path.exists() and not path.is_symlink(),'Destination must be new')
    os.mkdir(path,0o700); fsync_dir(path.parent); fsync_dir(path)


def new_file(path, body):
    canonical(str(path.parent))
    fd=os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL|os.O_NOFOLLOW,0o444)
    try:
        with os.fdopen(fd,'wb',closefd=False) as stream: stream.write(body); stream.flush()
        os.fsync(fd)
    finally: os.close(fd)
    fsync_dir(path.parent)
    require(path.read_bytes()==body,'Copied bytes changed')


def produce(args, inspected):
    out=canonical(str(args.output),exists=False)
    require(out.is_relative_to(Path('/tmp')) and out != Path('/tmp'),'Output must be a new retained /tmp directory')
    forbidden=[WORKSPACE,MIRROR,REPLAY,BUILD,RUNTIME,EVIDENCE,*map(Path,inspected['inputs'].rows)]
    require(all(not out.is_relative_to(p) and not p.is_relative_to(out) for p in forbidden),'Output overlaps selected inputs/build/runtime/clone')
    require(not out.exists() and not out.is_symlink(),'Output already exists; no resume or overwrite')
    inp=inspected['inputs']; inp.recheck()
    bridge=inspected['bridge']
    require(bridge.bridge_git(REPLAY,inspected['expected_sources']) == (inspected['git_identity'],inspected['directories']),'Clone changed before copy')
    new_directory(out)
    copies={}; mappings={}; paths={}
    try:
        new_directory(out/'retained'); new_directory(out/'support')
        for old,(actual,expected) in sorted(inspected['selected'].items()):
            name=digest(old.encode())+'-'+Path(old).name
            dest=out/'retained'/name
            body=inp.bodies[str(actual)]
            require(digest(body)==expected,'Staged input body hash differs')
            new_file(dest,body); copies[str(dest)]={'sha256':expected,'bytes':len(body),'historical_path':old,'read_path':str(actual)}
            mappings[old]={'path':str(dest),'sha256':expected};paths[old]=str(dest)
        support={**inspected['fixed_paths'],'bridge_helper':inspected['bridge_helper']}
        support_outputs={}
        for role,actual in sorted(support.items()):
            old = str(WORKSPACE/FIXED[role][0]) if role in FIXED else str(actual)
            if old in paths: dest=Path(paths[old])
            else:
                dest=out/'support'/(role+actual.suffix)
                body=inp.bodies[str(actual)];new_file(dest,body)
                copies[str(dest)]={'sha256':digest(body),'bytes':len(body),'read_path':str(actual)}
            support_outputs[role]=str(dest)
        inp.recheck()
        require(bridge.bridge_git(REPLAY,inspected['expected_sources']) == (inspected['git_identity'],inspected['directories']),'Clone changed while copying')
        for p,row in copies.items():require(digest(canonical(p).read_bytes())==row['sha256'],'Output copy mutated')
        manifest={'schema':1,'kind':'D1BOUND5_REPLAY_SOURCE_RELOCATION','original_compile_root':str(COMPILE),'replay_source_root':str(REPLAY),
                  'artifact_root':str(BUILD/'artifacts'),'distribution_root':str(RUNTIME),'candidate_commit':COMMIT,'candidate_tree':TREE,
                  'source_lock_sha256':SOURCE_LOCK_SHA,'runtime_lock_sha256':RUNTIME_LOCK_SHA,'source_inventory_sha256':FIXED['inventory'][1],
                  'build_origin_sha256':ORIGIN_SHA,'build_summary_sha256':inp.rows[str(BUILD/'SUMMARY.json')]['sha256'],
                  'build_id':BUILD_ID,'build_identity_hash':IDENTITY,'records':{k:str(v) for k,v in inspected['roles'].items()},'retained_files':mappings}
        manifest_bytes=(json.dumps(manifest,indent=2,sort_keys=True)+'\n').encode()
        new_file(out/'RELOCATION_MANIFEST.json',manifest_bytes)
        inp.recheck()
        receipt={'schema':1,'status':'UNACCEPTED_MAPPING_PREPARATION_ONLY','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
                 'manifest_sha256':digest(manifest_bytes),'preparer_sha256':inp.rows[str(Path(__file__).absolute())]['sha256'],'bridge_helper_sha256':BRIDGE_SHA,
                 'inputs':inp.rows,'copies':copies,'support_outputs':support_outputs,'git_identity':inspected['git_identity'],
                 'inventory_hash_roles':{'bridge_source_inventory_file_sha256':FIXED['inventory'][1],
                   'selected_clone_relative_file_map_sha256':bridge.bridge_digest(inspected['expected_sources']),
                   'selected_clone_relative_file_map_count':len(inspected['expected_sources']),
                   'note':'The 4411-file map digest is not the final checker source-inventory JSON file SHA; only the latter goes in manifest.source_inventory_sha256'},
                 'full_artifact_receipt_runtime_revalidation_performed':False,'lean_or_freeze_or_checker_launched':False,
                 'required_next':['Parent reviews exact manifest/helper/input identity and copy receipt','Separately reviewed bridge freeze validates all current accepted receipts/artifacts/runtime and binds exact audit snapshots','Parent separately selects any official fresh replay'],
                 'historical_records_rewritten':False,'proof_acceptance':False}
        new_file(out/'PREPARATION_RECEIPT.json',(json.dumps(receipt,indent=2,sort_keys=True)+'\n').encode())
        fsync_dir(out)
        return receipt
    except BaseException as error:
        try:new_file(out/'FAILED_PREPARATION.json',(json.dumps({'status':'FAILED_NO_ACCEPTANCE','error':repr(error),'copies_completed':copies},indent=2,sort_keys=True)+'\n').encode())
        except BaseException:pass
        raise


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--bridge-helper',type=Path,required=True)
    ap.add_argument('--source-policy-report',type=Path,required=True)
    ap.add_argument('--source-policy-manifest',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--prepare',action='store_true',help='Write new retained directory after read-only gate inspection; never launches a freeze/checker')
    args=ap.parse_args()
    lock=canonical(str(BUILD/'build.lock'))
    fd=os.open(lock,os.O_RDONLY|os.O_NOFOLLOW|os.O_NONBLOCK)
    try:
        require(stat.S_ISREG(os.fstat(fd).st_mode),'Build lock is not a regular file')
        fcntl.flock(fd,fcntl.LOCK_SH|fcntl.LOCK_NB)
        inspected=inspect(args)
        if not args.prepare:
            print(json.dumps({'status':'READ_ONLY_PREPARATION_INPUTS_CHECKED_NO_MANIFEST','mapping_file_count':len(inspected['selected']),'proof_acceptance':False}));return 0
        receipt=produce(args,inspected)
        print(json.dumps({'status':receipt['status'],'manifest_sha256':receipt['manifest_sha256'],'output':str(args.output),'proof_acceptance':False}));return 0
    finally:os.close(fd)


if __name__=='__main__':
    try:sys.exit(main())
    except Exception as error:print('REFUSED_OR_FAILED_PREPARATION: '+str(error),file=sys.stderr);sys.exit(2)
