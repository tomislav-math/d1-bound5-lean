"""Independent synthetic fixtures: no real build, Git, Lean, checker or freeze."""
import argparse
import contextlib
import copy
import hashlib
import io
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import types
import unittest
from unittest.mock import patch

HERE = Path(__file__).resolve().parent
SOURCE = HERE/'prepare_replay_mapping.py'

def load_source():
    m = types.ModuleType('preparer_synthetic_source_only')
    m.__file__ = str(SOURCE)
    exec(compile(SOURCE.read_bytes(), str(SOURCE), 'exec', dont_inherit=True), m.__dict__)
    return m

def sha(data): return hashlib.sha256(data).hexdigest()
def put(path, body):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(body)
    return sha(body)
def save(path, obj): return put(path, (json.dumps(obj, sort_keys=True, indent=2)+'\n').encode())

class Fixture:
    def __init__(self, case):
        self.case = case
        self.tmp = tempfile.TemporaryDirectory(prefix='d1bound5-mapping-fixture-', dir='/tmp')
        case.addCleanup(self.tmp.cleanup)
        self.base = Path(self.tmp.name)
        self.m = load_source(); m = self.m
        m.WORKSPACE=self.base/'workspace'; m.MIRROR=self.base/'mirror'
        m.COMPILE=m.WORKSPACE/'source'; m.REPLAY=m.MIRROR/'source'
        m.BUILD=self.base/'build'; m.RUNTIME=self.base/'runtime';m.EVIDENCE=m.BUILD.parent/'evidence'
        m.POLICY_HISTORY=self.base/'historical-policy'
        m.COUNT=1; m.BUILD_ID='synthetic-build';m.COMMIT='a'*40;m.TREE='b'*40
        self.expected={}
        for name in ['D1Bound5.lean','lean-toolchain','lakefile.lean','lake-manifest.json','scripts/verification/FinalIntegrationAudit.lean','scripts/verification/FinalTargetAudit.lean']:
            self.expected[name]=put(m.REPLAY/name,('synthetic '+name+'\n').encode())
        self.harnesses={n:h for n,h in self.expected.items() if n.startswith('scripts/')}
        self.aux={n:self.expected[n] for n in ['lean-toolchain','lakefile.lean','lake-manifest.json']}
        self.compiler=str(m.RUNTIME/'lean-4.33.1-linux/bin/lean')
        put(Path(self.compiler),b'not executable; never run\n')
        self.exact_helper=self.both('tools/exact.py',b'synthetic exact helper\n')
        self.broad_helper=self.both('tools/broad.py',b'synthetic broad helper\n')
        self.builder=self.both('tools/builder.py',b'synthetic builder\n')
        self.broad_source=self.both('tools/Audit.lean',b'synthetic broad source\n')
        m.EXACT_HELPER_SHA=sha(self.exact_helper.read_bytes());m.BROAD_HELPER_SHA=sha(self.broad_helper.read_bytes());m.BUILDER_SHA=sha(self.builder.read_bytes())
        self.bridge_path=self.base/'bridge.py';put(self.bridge_path,b'# synthetic bridge stand-in\n')
        m.BRIDGE_SHA=sha(self.bridge_path.read_bytes())
        self.sl={'module_count':1,'roots':['D1Bound5'],'sources':{'D1Bound5':{'relative_path':'D1Bound5.lean','sha256':self.expected['D1Bound5.lean'],'bytes':(m.REPLAY/'D1Bound5.lean').stat().st_size}},'auxiliary':self.aux}
        self.rt={'lean':self.compiler,'files':{self.compiler:sha(Path(self.compiler).read_bytes())}}
        self.fixed_data={'source_lock':self.sl,'runtime_lock':self.rt,'inventory':{'source_closure':{'D1Bound5':self.expected['D1Bound5.lean']}},'lean_env':{},'configuration':{'fixture':True}}
        for role,obj in self.fixed_data.items(): self.both_json('fixed/'+role+'.json',obj)
        m.SOURCE_LOCK_SHA=sha((m.WORKSPACE/'fixed/source_lock.json').read_bytes());m.RUNTIME_LOCK_SHA=sha((m.WORKSPACE/'fixed/runtime_lock.json').read_bytes())
        self.identity={'source_root':str(m.COMPILE),'build_dir':str(m.BUILD),'runner_sha256':m.BUILDER_SHA,'source_lock_sha256':m.SOURCE_LOCK_SHA,'runtime_lock_sha256':m.RUNTIME_LOCK_SHA,'lean_arguments':['-j1','-DautoImplicit=false','-R',str(m.COMPILE)],'environment':{}}
        m.IDENTITY=sha(json.dumps(self.identity,sort_keys=True,separators=(',',':')).encode())
        self.origin={'build_id':m.BUILD_ID,'identity_hash':m.IDENTITY,'identity':self.identity,'initial_artifact_inventory':[]}
        m.ORIGIN_SHA=save(m.BUILD/'ORIGIN.json',self.origin)
        self.summary={'status':'PROJECT_SOURCE_BUILD_COMPLETE_RESUMED','build_id':m.BUILD_ID,'identity_hash':m.IDENTITY,'fresh_project_origin':True,'roots':['D1Bound5'],'expected_modules':1,'completed_modules':1,'active':[],'failed':[],'waiting':[],'compiled_this_invocation':['D1Bound5'],'validated_passes_from_prior_invocations':[]}
        save(m.BUILD/'SUMMARY.json',self.summary);put(m.BUILD/'build.lock',b'')
        self.exact_out=m.EVIDENCE/'clean118';self.broad_out=m.EVIDENCE/'broad'
        self.exact_argv=['python3',str(self.exact_helper),'--source-root',str(m.COMPILE),'--out',str(self.exact_out),'--artifact-root',str(m.BUILD/'artifacts'),'--build-dir',str(m.BUILD),'--expected-commit',m.COMMIT,'--expected-tree',m.TREE,'--integration-audit',str(m.COMPILE/'scripts/verification/FinalIntegrationAudit.lean'),'--target-audit',str(m.COMPILE/'scripts/verification/FinalTargetAudit.lean'),'--build-runner',str(self.builder)]
        self.broad_argv=['python3',str(self.broad_helper),'--out',str(self.broad_out),'--broad-audit',str(self.broad_source),'--invocation',str(m.WORKSPACE/'fixed/exact_invocation.json')]
        self.fixed_data['exact_invocation']={'argv':self.exact_argv};self.fixed_data['broad_invocation']={'argv':self.broad_argv}
        for role in ['exact_invocation','broad_invocation']: self.both_json('fixed/'+role+'.json',self.fixed_data[role])
        m.FIXED={role:('fixed/'+role+'.json',sha((m.WORKSPACE/('fixed/'+role+'.json')).read_bytes())) for role in self.fixed_data}
        self.git={'commit':m.COMMIT,'tree':m.TREE,'clean_worktree':True};self.dirs={'fixture':'stable'}
        self.policy=self.base/'policy.json';self.policy_map=self.base/'policy-map.json';save(self.policy,{'fixture':'policy'});save(self.policy_map,{'fixture':'manifest'})
        self.bridge=types.SimpleNamespace(BRIDGE_HARNESSES=self.harnesses,BRIDGE_BROAD_SHA=sha(self.broad_source.read_bytes()),BRIDGE_POLICY_SHA=sha(self.policy.read_bytes()),BRIDGE_POLICY_MANIFEST_SHA=sha(self.policy_map.read_bytes()),bridge_digest=lambda x:sha(json.dumps(x,sort_keys=True,separators=(',',':')).encode()),bridge_git=self.bridge_git)
        def fake_load(path, inputs):inputs.capture(path,m.BRIDGE_SHA);return self.bridge
        self.loader=patch.object(m,'load_bridge',side_effect=fake_load);self.loader.start();case.addCleanup(self.loader.stop)
        put(self.exact_out/'FinalIntegrationAudit.log',b'ORIGINAL_TYPE_AXIOMS_PASS fixture\n'*114)
        targets=['D1Bound5.MainStatement','D1Bound5.IsD1','D1Bound5.IsD1Tuple','D1Bound5.main_statement']
        self.target_text=''.join('FINAL_TARGET_AXIOMS_PASS '+x+': []\n' for x in targets)
        put(self.exact_out/'FinalTargetAudit.log',self.target_text.encode())
        files={str(m.COMPILE/n):h for n,h in self.expected.items()}
        for p in [m.BUILD/'ORIGIN.json',m.BUILD/'SUMMARY.json',self.exact_helper,self.broad_helper,self.builder,m.WORKSPACE/'fixed/source_lock.json',m.WORKSPACE/'fixed/runtime_lock.json']:files[str(p)]=sha(p.read_bytes())
        self.freeze={'schema':1,'source_root':str(m.COMPILE),'build_dir':str(m.BUILD),'artifact_root':str(m.BUILD/'artifacts'),'build_id':m.BUILD_ID,'identity_hash':m.IDENTITY,'source_lock_sha256':m.SOURCE_LOCK_SHA,'runtime_lock_sha256':m.RUNTIME_LOCK_SHA,'accepted_modules':1,'lean':self.compiler,'environment':{},'git_identity':self.git.copy(),'runtime_inventory_sha256':self.bridge.bridge_digest(self.rt['files']),'runtime_file_count':len(self.rt['files']),'files':files}
        self.exact={'status':'CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS','post_audit_all_input_hashes_equal':True,'accepted_fresh_project_modules':1,'source_lock_sha256':m.SOURCE_LOCK_SHA,'runtime_lock_sha256':m.RUNTIME_LOCK_SHA,'audits':[]}
        for name,log,count,h in [('FinalIntegrationAudit','FinalIntegrationAudit.log',114,'scripts/verification/FinalIntegrationAudit.lean'),('FinalTargetAudit','FinalTargetAudit.log',4,'scripts/verification/FinalTargetAudit.lean')]:self.exact['audits'].append({'name':name,'exit_code':0,'expected_pass_markers':count,'observed_pass_markers':count,'audit_sha256':self.harnesses[h],'log_sha256':sha((self.exact_out/log).read_bytes()),'command':[self.compiler,'-j1','-DautoImplicit=false','-R',str(m.COMPILE),str(m.COMPILE/h)]})
        put(self.broad_out/'Audit.log',('AUDIT D1Bound5: []\nAXIOM_AUDIT_PASS: 1 project declarations\nBROAD_PROJECT_AXIOM_AUDIT_PASS 2 declarations\n'+self.target_text).encode())
        self.bf={'command_root':str(self.broad_source.parent),'files':{str(self.broad_source):self.bridge.BRIDGE_BROAD_SHA,str(m.WORKSPACE/'fixed/exact_invocation.json'):m.FIXED['exact_invocation'][1]}}
        self.broad={'status':'CLEAN_BROAD_COMPATIBILITY_AUDIT_PASS','exit_code':0,'all_clean_source_artifact_runtime_git_and_evidence_guards_equal':True,'broad_source_sha256':self.bridge.BRIDGE_BROAD_SHA,'log_sha256':sha((self.broad_out/'Audit.log').read_bytes()),'command':[self.compiler,'-j1','-DautoImplicit=false','-R',str(self.broad_source.parent),str(self.broad_source)],'markers':{'exported_project_declarations':1,'including_private_declarations':2,'independent_target_markers':4,'individual_exported_audit_lines':1}}
        self.flush()
        self.args=argparse.Namespace(bridge_helper=self.bridge_path,source_policy_report=self.policy,source_policy_manifest=self.policy_map,output=self.base/'result',prepare=False)
    def both(self,relative,body):
        for root in [self.m.WORKSPACE,self.m.MIRROR]:put(root/relative,body)
        return self.m.WORKSPACE/relative
    def both_json(self,relative,obj):return self.both(relative,(json.dumps(obj,sort_keys=True,indent=2)+'\n').encode())
    def bridge_git(self,path,expected):
        if path!=self.m.REPLAY or expected!=self.expected:raise ValueError('synthetic clone scope mismatch')
        for name,h in expected.items():
            if sha((path/name).read_bytes())!=h:raise ValueError('synthetic clone byte mismatch')
        return copy.deepcopy(self.git),copy.deepcopy(self.dirs)
    def flush(self):
        fh=save(self.exact_out/'INPUT_FREEZE.json',self.freeze);self.exact['input_freeze_sha256']=fh;save(self.exact_out/'SUMMARY.json',self.exact)
        self.bf['exact_audit_input_freeze_sha256']=fh;self.broad['exact_audit_input_freeze_sha256']=fh
        for name in ['SUMMARY.json','INPUT_FREEZE.json','FinalIntegrationAudit.log','FinalTargetAudit.log']:self.bf['files'][str(self.exact_out/name)]=sha((self.exact_out/name).read_bytes())
        save(self.broad_out/'EVIDENCE_FREEZE.json',self.bf);save(self.broad_out/'SUMMARY.json',self.broad)
    def inspect(self):return self.m.inspect(self.args)
    def produce(self):return self.m.produce(self.args,self.inspect())
    def summary_write(self):save(self.m.BUILD/'SUMMARY.json',self.summary)

class PreparationTests(unittest.TestCase):
    def setUp(self):self.f=Fixture(self);self.m=self.f.m
    def reject_inspect(self):
        with self.assertRaises((ValueError,FileNotFoundError,KeyError)):self.f.inspect()
        self.assertFalse(self.f.args.output.exists())
    def test_valid_inspection_writes_nothing(self):
        info=self.f.inspect();self.assertTrue(info['selected']);self.assertFalse(self.f.args.output.exists())
    def test_valid_production_is_explicitly_unaccepted(self):
        r=self.f.produce();self.assertEqual(r['status'],'UNACCEPTED_MAPPING_PREPARATION_ONLY');self.assertFalse(r['proof_acceptance']);self.assertFalse(r['lean_or_freeze_or_checker_launched'])
        m=json.loads((self.f.args.output/'RELOCATION_MANIFEST.json').read_text());self.assertEqual(m['original_compile_root'],str(self.m.COMPILE));self.assertEqual(m['replay_source_root'],str(self.m.REPLAY));self.assertEqual(m['records']['exact_summary'],str(self.f.exact_out/'SUMMARY.json'))
        for old,row in m['retained_files'].items():self.assertEqual(sha(Path(row['path']).read_bytes()),row['sha256'])
    def test_all_historical_copies_preserve_original_bytes(self):
        info=self.f.inspect();self.m.produce(self.f.args,info);mapping=json.loads((self.f.args.output/'RELOCATION_MANIFEST.json').read_text())
        for old,(actual,h) in info['selected'].items():self.assertEqual(Path(mapping['retained_files'][old]['path']).read_bytes(),info['inputs'].bodies[str(actual)])
    def test_workspace_absent_falls_back_to_pinned_mirror(self):
        shutil.rmtree(self.m.WORKSPACE);r=self.f.produce();self.assertTrue(r['copies']);self.assertTrue(any(str(self.m.MIRROR) in x.get('read_path','') for x in r['copies'].values()))
    def test_wrong_existing_workspace_bytes_do_not_fallback(self):put(self.m.WORKSPACE/'fixed/source_lock.json',b'{}');self.reject_inspect()
    def test_running_build_rejected(self):self.f.summary['status']='RUNNING';self.f.summary_write();self.reject_inspect()
    def test_failed_build_rejected(self):self.f.summary['failed']=['D1Bound5'];self.f.summary_write();self.reject_inspect()
    def test_active_build_rejected(self):self.f.summary['active']=['D1Bound5'];self.f.summary_write();self.reject_inspect()
    def test_waiting_build_rejected(self):self.f.summary['waiting']=['D1Bound5'];self.f.summary_write();self.reject_inspect()
    def test_incomplete_count_rejected(self):self.f.summary['completed_modules']=0;self.f.summary_write();self.reject_inspect()
    def test_duplicate_completed_modules_rejected(self):self.f.summary['validated_passes_from_prior_invocations']=['D1Bound5'];self.f.summary_write();self.reject_inspect()
    def test_wrong_origin_pin_rejected(self):put(self.m.BUILD/'ORIGIN.json',b'{}');self.reject_inspect()
    def test_nonempty_fresh_origin_rejected_even_when_rehashed(self):
        self.f.origin['initial_artifact_inventory']=['old'];self.m.ORIGIN_SHA=save(self.m.BUILD/'ORIGIN.json',self.f.origin);self.reject_inspect()
    def test_wrong_build_identity_rejected(self):self.f.summary['identity_hash']='0'*64;self.f.summary_write();self.reject_inspect()
    def test_wrong_git_commit_rejected(self):self.f.git['commit']='0'*40;self.reject_inspect()
    def test_wrong_git_tree_rejected(self):self.f.git['tree']='0'*40;self.reject_inspect()
    def test_clone_bytes_changed_rejected(self):put(self.m.REPLAY/'D1Bound5.lean',b'changed');self.reject_inspect()
    def test_pending_exact_rejected(self):self.f.exact['status']='RUNNING';self.f.flush();self.reject_inspect()
    def test_pending_broad_rejected(self):self.f.broad['status']='RUNNING';self.f.flush();self.reject_inspect()
    def test_failed_exact_exit_rejected(self):self.f.exact['audits'][0]['exit_code']=1;self.f.flush();self.reject_inspect()
    def test_failed_broad_exit_rejected(self):self.f.broad['exit_code']=1;self.f.flush();self.reject_inspect()
    def test_actual_exact_markers_missing_with_rehashed_log(self):
        p=self.f.exact_out/'FinalIntegrationAudit.log';put(p,b'no markers\n');self.f.exact['audits'][0]['log_sha256']=sha(p.read_bytes());self.f.flush();self.reject_inspect()
    def test_forged_exact_observed_count_rejected(self):self.f.exact['audits'][0]['observed_pass_markers']=113;self.f.flush();self.reject_inspect()
    def test_exact_command_root_rewritten_rejected(self):self.f.exact['audits'][0]['command'][4]=str(self.m.REPLAY);self.f.flush();self.reject_inspect()
    def test_broad_command_rewritten_rejected(self):self.f.broad['command'][4]=str(self.m.REPLAY);self.f.flush();self.reject_inspect()
    def test_actual_broad_markers_missing_with_rehashed_log(self):
        p=self.f.broad_out/'Audit.log';put(p,b'no markers\n');self.f.broad['log_sha256']=sha(p.read_bytes());self.f.flush();self.reject_inspect()
    def test_broad_recorded_marker_forgery_rejected(self):self.f.broad['markers']['including_private_declarations']=123;self.f.flush();self.reject_inspect()
    def test_missing_exact_source_freeze_binding_rejected(self):del self.f.freeze['files'][str(self.m.COMPILE/'D1Bound5.lean')];self.f.flush();self.reject_inspect()
    def test_missing_builder_freeze_binding_rejected(self):del self.f.freeze['files'][str(self.f.builder)];self.f.flush();self.reject_inspect()
    def test_wrong_runtime_freeze_rejected(self):self.f.freeze['runtime_inventory_sha256']='0'*64;self.f.flush();self.reject_inspect()
    def test_missing_broad_exact_record_binding_rejected(self):
        del self.f.bf['files'][str(self.f.exact_out/'SUMMARY.json')];save(self.f.broad_out/'EVIDENCE_FREEZE.json',self.f.bf);self.reject_inspect()
    def test_source_policy_pin_rejected(self):put(self.f.policy,b'{}');self.reject_inspect()
    def test_bridge_helper_pin_rejected(self):put(self.f.bridge_path,b'changed');self.reject_inspect()
    def test_symlink_historical_input_rejected(self):
        p=self.m.WORKSPACE/'fixed/source_lock.json';p.unlink();p.symlink_to(self.m.MIRROR/'fixed/source_lock.json');self.reject_inspect()
    def test_source_changed_after_inspection_rejected(self):
        info=self.f.inspect();put(self.f.policy,b'changed');self.assertRaises(ValueError,self.m.produce,self.f.args,info);self.assertFalse(self.f.args.output.exists())
    def test_clone_changed_after_inspection_rejected(self):
        info=self.f.inspect();put(self.m.REPLAY/'D1Bound5.lean',b'changed');self.assertRaises(ValueError,self.m.produce,self.f.args,info)
    def test_existing_output_not_overwritten(self):
        self.f.args.output.mkdir();put(self.f.args.output/'keep',b'keep');self.assertRaises(ValueError,self.f.produce);self.assertEqual((self.f.args.output/'keep').read_bytes(),b'keep')
    def test_output_symlink_rejected(self):self.f.args.output.symlink_to(self.m.MIRROR,target_is_directory=True);self.assertRaises(ValueError,self.f.produce)
    def test_output_parent_symlink_rejected(self):
        p=self.f.base/'alias';p.symlink_to(self.f.base,target_is_directory=True);self.f.args.output=p/'result';self.assertRaises(ValueError,self.f.produce)
    def test_output_inside_source_root_rejected(self):self.f.args.output=self.m.REPLAY/'new';self.assertRaises(ValueError,self.f.produce)
    def test_output_inside_build_rejected(self):self.f.args.output=self.m.BUILD/'new';self.assertRaises(ValueError,self.f.produce)
    def test_output_inside_runtime_rejected(self):self.f.args.output=self.m.RUNTIME/'new';self.assertRaises(ValueError,self.f.produce)
    def test_output_ancestor_of_inputs_rejected(self):self.f.args.output=self.f.base;self.assertRaises(ValueError,self.f.produce)
    def test_output_not_tmp_rejected(self):self.f.args.output=Path('/var/never-written-preparer-fixture');self.assertRaises(ValueError,self.f.produce)
    def test_mutated_cached_body_is_refreshed_from_original_before_copy(self):
        info=self.f.inspect();old,(actual,h)=next(iter(info['selected'].items()));expected=Path(actual).read_bytes();info['inputs'].bodies[str(actual)]=b'changed';self.m.produce(self.f.args,info);mapping=json.loads((self.f.args.output/'RELOCATION_MANIFEST.json').read_text());self.assertEqual(Path(mapping['retained_files'][old]['path']).read_bytes(),expected)
    def test_partial_io_failure_preserved_not_accepted(self):
        real=self.m.new_file;seen=[False]
        def fail_once(path,body):
            if path.parent.name=='retained' and not seen[0]:seen[0]=True;raise OSError('synthetic disk failure')
            return real(path,body)
        with patch.object(self.m,'new_file',side_effect=fail_once):self.assertRaises(OSError,self.f.produce)
        self.assertTrue((self.f.args.output/'FAILED_PREPARATION.json').exists());self.assertFalse((self.f.args.output/'PREPARATION_RECEIPT.json').exists())
    def test_copy_mutation_during_run_retains_failure(self):
        real=self.m.new_file;seen=[False]
        def mutate(path,body):
            real(path,body)
            if path.parent.name=='retained' and not seen[0]:seen[0]=True;put(self.f.policy,b'changed after first copy')
        with patch.object(self.m,'new_file',side_effect=mutate):self.assertRaises(ValueError,self.f.produce)
        self.assertTrue((self.f.args.output/'FAILED_PREPARATION.json').exists());self.assertFalse((self.f.args.output/'PREPARATION_RECEIPT.json').exists())
    def test_files_and_directories_are_fsynced(self):
        with patch.object(self.m.os,'fsync',wraps=os.fsync) as calls:self.f.produce();self.assertGreater(calls.call_count,10)
    def test_no_process_launch_or_automatic_bridge_freeze(self):
        with patch.object(subprocess,'Popen',side_effect=AssertionError('no subprocess allowed')):self.f.produce()
    def test_main_default_is_readonly_and_shared_lock(self):
        args=['prepare','--bridge-helper',str(self.f.bridge_path),'--source-policy-report',str(self.f.policy),'--source-policy-manifest',str(self.f.policy_map),'--output',str(self.f.args.output)]
        with patch.object(self.m.sys,'argv',args),contextlib.redirect_stdout(io.StringIO()) as out:self.assertEqual(self.m.main(),0)
        self.assertIn('READ_ONLY_PREPARATION_INPUTS_CHECKED_NO_MANIFEST',out.getvalue());self.assertFalse(self.f.args.output.exists())
    def test_main_refuses_active_exclusive_build_lock(self):
        import fcntl
        fd=os.open(self.m.BUILD/'build.lock',os.O_RDONLY)
        try:
            fcntl.flock(fd,fcntl.LOCK_EX|fcntl.LOCK_NB)
            args=['prepare','--bridge-helper',str(self.f.bridge_path),'--source-policy-report',str(self.f.policy),'--source-policy-manifest',str(self.f.policy_map),'--output',str(self.f.args.output)]
            with patch.object(self.m.sys,'argv',args):self.assertRaises(BlockingIOError,self.m.main)
            self.assertFalse(self.f.args.output.exists())
        finally:os.close(fd)
    def test_source_loader_ignores_stale_pyc_and_pin_mismatch(self):
        self.f.loader.stop();p=self.f.bridge_path;put(p,b'FIXTURE_VALUE=17\n');self.m.BRIDGE_SHA=sha(p.read_bytes());(p.parent/'__pycache__').mkdir();put(p.parent/'__pycache__/bridge.fake.pyc',b'garbage stale bytecode')
        m=self.m.load_bridge(p,self.m.Inputs());self.assertEqual(m.FIXTURE_VALUE,17);self.m.BRIDGE_SHA='0'*64;self.assertRaises(ValueError,self.m.load_bridge,p,self.m.Inputs())
    def test_input_inode_replacement_rejected_on_recheck(self):
        info=self.f.inspect();p=self.f.policy;b=p.read_bytes();p.unlink();put(p,b);self.assertRaises(ValueError,info['inputs'].recheck)

    def test_generated_manifest_loads_in_real_reviewed_bridge_with_synthetic_constants(self):
        path=Path('/tmp/d1bound5-optional-replay-source-bridge-20261023/final_kernel_bridge.py')
        body=path.read_bytes();self.assertEqual(sha(body),'829d6a30fd1b35ffda307b88342e100fec24038de23052aa92b39d298967d446')
        b=types.ModuleType('actual_bridge_synthetic_constants');b.__file__=str(path);exec(compile(body,str(path),'exec'),b.__dict__)
        b.BRIDGE_COMMIT=self.m.COMMIT;b.BRIDGE_TREE=self.m.TREE;b.BRIDGE_COUNT=1;b.BRIDGE_SOURCE_LOCK=self.m.SOURCE_LOCK_SHA;b.BRIDGE_HARNESSES=self.f.harnesses;b.bridge_git=self.f.bridge_git
        result=self.f.produce();p=self.f.args.output/'RELOCATION_MANIFEST.json'
        c=b.bridge_load(p,sha(p.read_bytes()),self.m.REPLAY,self.m.BUILD/'artifacts',self.m.RUNTIME,self.m.WORKSPACE/'fixed/source_lock.json',self.m.WORKSPACE/'fixed/runtime_lock.json',self.m.WORKSPACE/'fixed/inventory.json')
        self.assertEqual(c['original'],str(self.m.COMPILE));self.assertEqual(len(c['expected_sources']),6);self.assertFalse(result['proof_acceptance'])
    def test_duplicate_invocation_option_rejected(self):
        self.assertRaises(ValueError,self.m.option,['--out','one','--out','two'],'--out')
    def test_missing_invocation_option_value_rejected(self):
        self.assertRaises(ValueError,self.m.option,['--out'],'--out')

    def test_inventory_file_hash_and_relative_map_hash_roles_differ(self):
        r=self.f.produce();roles=r['inventory_hash_roles'];mapping=json.loads((self.f.args.output/'RELOCATION_MANIFEST.json').read_text())
        self.assertEqual(roles['bridge_source_inventory_file_sha256'],self.m.FIXED['inventory'][1]);self.assertEqual(mapping['source_inventory_sha256'],self.m.FIXED['inventory'][1]);self.assertEqual(roles['selected_clone_relative_file_map_sha256'],self.f.bridge.bridge_digest(self.f.expected));self.assertEqual(roles['selected_clone_relative_file_map_count'],6);self.assertNotEqual(roles['bridge_source_inventory_file_sha256'],roles['selected_clone_relative_file_map_sha256'])
    def test_input_fifo_refused_without_read(self):
        p=self.f.base/'input.fifo';os.mkfifo(p);self.assertRaises(ValueError,self.m.Inputs().capture,p)
    def test_regular_input_swapped_to_fifo_uses_nonblocking_open(self):
        p=self.f.policy;real=os.open;seen=[]
        def swap(path,flags,*a,**kw):
            if Path(path)==p:
                self.assertTrue(flags & os.O_NONBLOCK);p.unlink();os.mkfifo(p);seen.append(True)
            return real(path,flags,*a,**kw)
        with patch.object(self.m.os,'open',side_effect=swap):self.assertRaises(ValueError,self.m.Inputs().capture,p)
        self.assertEqual(seen,[True])
    def test_main_fifo_build_lock_refused_nonblocking(self):
        p=self.m.BUILD/'build.lock';p.unlink();os.mkfifo(p)
        args=['prepare','--bridge-helper',str(self.f.bridge_path),'--source-policy-report',str(self.f.policy),'--source-policy-manifest',str(self.f.policy_map),'--output',str(self.f.args.output)]
        real=os.open
        def checked(path,flags,*a,**kw):
            if Path(path)==p:self.assertTrue(flags & os.O_NONBLOCK)
            return real(path,flags,*a,**kw)
        with patch.object(self.m.sys,'argv',args),patch.object(self.m.os,'open',side_effect=checked):self.assertRaises(ValueError,self.m.main)
        self.assertFalse(self.f.args.output.exists())

if __name__=='__main__':unittest.main(verbosity=2)
