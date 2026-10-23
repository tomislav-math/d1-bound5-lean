"""Synthetic read-only bridge fixtures. No Lean, real Git, or real build inputs."""
import argparse
import ast
import contextlib
import copy
import hashlib
import io
import json
import os
from pathlib import Path
import shutil
import sys
import tempfile
import types
import unittest
from unittest.mock import patch

HERE = Path(__file__).resolve().parent
SOURCE = HERE/'final_kernel_bridge.py'
ORIGINAL = HERE/'original/final_kernel_e04.py'

def load_source(path, name):
    module = types.ModuleType(name)
    module.__file__ = str(path)
    module.__package__ = ''
    exec(compile(path.read_bytes(), str(path), 'exec', dont_inherit=True), module.__dict__)
    return module

b = load_source(SOURCE, 'bridge_fixture_source_only')
old = load_source(ORIGINAL, 'original_fixture_source_only')
def digest(raw): return hashlib.sha256(raw).hexdigest()
def put(path, raw):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(raw)
    return digest(raw)
def save(path, value): return put(path, (json.dumps(value, sort_keys=True, indent=2)+'\n').encode())

class Fixture:
    def __init__(self, case):
        self.case = case
        self.temp = tempfile.TemporaryDirectory(prefix='d1bound5-bridge-fixture-', dir='/tmp')
        case.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.original = self.base/'absent-original-source'
        self.project = self.base/'retained-source'
        self.project.mkdir(); (self.project/'.git').mkdir()
        put(self.project/'.git/config', b'[core]\n repositoryformatversion = 0\n bare = false\n')
        self.root = self.base/'runtime'
        self.build = self.base/'build'; self.art = self.build/'artifacts'
        self.meta = self.base/'retained-evidence'; self.meta.mkdir()
        self.historical = self.base/'absent-old-metadata'
        self.toolchain = self.root/'lean-4.33.1-linux'
        self.compiler = str(self.toolchain/'bin/lean')
        self.checker = self.toolchain/'bin/leanchecker'
        self.builtin = self.toolchain/'lib/lean'
        self.shim = self.root/'proc_self_exe_compat.so'
        runtime_paths = [Path(self.compiler), self.checker, self.builtin/'libleanshared.so', self.builtin/'Init.olean', self.shim]
        self.runtime_files = {str(p): put(p, ('fixture runtime '+p.name).encode()) for p in runtime_paths}
        self.runner = self.root/'fresh_project_build.py'; put(self.runner, b'fixture reviewed builder\n')
        self.artifact = self.art/'D1Bound5.olean'; put(self.artifact, b'synthetic artifact; never executed\n')
        self.setup = self.root/'RUNTIME_SETUP.json'
        save(self.setup, {'lean_binary_sha256':b.sha(self.compiler),'kernel_library_sha256':b.sha(self.builtin/'libleanshared.so'),'compat_object_sha256':b.sha(self.shim)})
        save(self.root/'mathlib/lake-manifest.json', {})
        self.source = self.project/'D1Bound5.lean'; put(self.source,b'-- synthetic candidate fixture only\n')
        self.harnesses={n:put(self.project/n,('fixture '+n+'\n').encode()) for n in b.BRIDGE_HARNESSES}
        self.aux={n:put(self.project/n,('fixture '+n+'\n').encode()) for n in ['lean-toolchain','lakefile.lean','lake-manifest.json']}
        self.expected={'D1Bound5.lean':b.sha(self.source),**self.aux,**self.harnesses}
        self.git_entries={n:hashlib.sha1(b'blob '+str(len((self.project/n).read_bytes())).encode()+b'\0'+(self.project/n).read_bytes()).hexdigest() for n in self.expected}
        self.git_commit=b.BRIDGE_COMMIT;self.git_tree=b.BRIDGE_TREE;self.git_status=b'';self.git_format='sha1';self.git_calls=[];self.git_hook=None
        case.addCleanup(patch.stopall)
        patch.object(b.subprocess,'check_output',side_effect=self.fake_git).start()
        self.sl=self.meta/'SOURCE_LOCK.json'
        self.lock={'schema':1,'namespace':'D1Bound5','module_count':1,'roots':['D1Bound5'],'topological_order':['D1Bound5'],'sources':{'D1Bound5':{'relative_path':'D1Bound5.lean','bytes':self.source.stat().st_size,'sha256':b.sha(self.source),'imports':[]}},'auxiliary':self.aux}
        save(self.sl,self.lock)
        patch.object(b,'BRIDGE_COUNT',1).start();patch.object(b,'BRIDGE_SOURCE_LOCK',b.sha(self.sl)).start();patch.object(b,'BRIDGE_HARNESSES',self.harnesses).start()
        self.env={'PATH':str(self.toolchain/'bin')+':/usr/bin:/bin:/usr/sbin:/sbin','LEAN_PATH':str(self.art)+':'+str(self.builtin),'LEAN_SYSROOT':str(self.toolchain),'LEAN_NUM_THREADS':'1','OMP_NUM_THREADS':'1','LANG':'C.UTF-8','LC_ALL':'C.UTF-8','LD_PRELOAD':str(self.shim)}
        self.rt=self.meta/'RUNTIME_LOCK.json'; self.runtime_lock={'schema':1,'lean':self.compiler,'toolchain':str(self.toolchain),'environment':{'LD_PRELOAD':str(self.shim)},'external_paths':[str(self.builtin)],'files':self.runtime_files};save(self.rt,self.runtime_lock)
        self.inventory=self.meta/'SOURCE_INVENTORY.json';save(self.inventory,{'source_closure':{'D1Bound5':b.sha(self.source)},'dependencies':{'D1Bound5':[]}})
        self.env_path=self.meta/'ENV.json';save(self.env_path,self.env)
        self.identity={'schema':1,'source_lock_sha256':b.sha(self.sl),'runtime_lock_sha256':b.sha(self.rt),'runner_sha256':b.sha(self.runner),'source_root':str(self.original),'build_dir':str(self.build),'environment':self.env,'lean_arguments':['-j1','-DautoImplicit=false','-R',str(self.original)]}
        self.origin={'identity':self.identity,'identity_hash':b.bridge_digest(self.identity),'build_id':'synthetic-build','initial_artifact_inventory':[]};save(self.build/'ORIGIN.json',self.origin)
        self.summary={'status':'PROJECT_SOURCE_BUILD_COMPLETE_RESUMED','identity_hash':self.origin['identity_hash'],'build_id':self.origin['build_id'],'fresh_project_origin':True,'failed':[],'active':[],'waiting':[],'expected_modules':1,'completed_modules':1,'compiled_this_invocation':['D1Bound5'],'validated_passes_from_prior_invocations':[]};save(self.build/'SUMMARY.json',self.summary)
        self.receipt=self.build/'attempts/D1Bound5/fixture-attempt/receipt.json';self.log=self.receipt.parent/'compiler.log';put(self.log,b'fixture compiler exit0 record; no compiler ran\n')
        self.row={'command':[self.compiler,*self.identity['lean_arguments'],'-o',str(self.receipt.parent/'stage/D1Bound5.olean'),str(self.original/'D1Bound5.lean')],'status':'COMPILE_PASS','exit_code':0,'module':'D1Bound5','build_id':self.origin['build_id'],'identity_hash':self.origin['identity_hash'],'source_sha256':b.sha(self.source),'dependencies':{},'artifact_bundle':{'D1Bound5.olean':b.sha(self.artifact)},'log_sha256':b.sha(self.log)}
        self.pointer=self.build/'accepted/D1Bound5.json';self.write_receipt()
        self.git_identity={'commit':b.BRIDGE_COMMIT,'tree':b.BRIDGE_TREE,'object_format':'sha1','clean_worktree':True,'selected_committed_blobs':self.git_entries}
        self.build_pins={str(p):b.sha(p) for p in [self.build/'ORIGIN.json',self.build/'SUMMARY.json',self.pointer,self.receipt,self.log]}
        self.accepted={'D1Bound5':{'receipt_sha256':b.sha(self.receipt),'artifact_bundle':self.row['artifact_bundle']}}
        self.build_evidence={'accepted_receipt_chain_sha256':b.bridge_digest(self.accepted),'artifact_bundles_sha256':b.bridge_digest(self.row['artifact_bundle'])}
        self.files={str(self.original/n):h for n,h in self.expected.items()};self.files.update(self.build_pins);self.files[str(self.artifact)]=b.sha(self.artifact)
        self.retained={};self.roles={};self.record_files={}
        for label,path in [('source-lock',self.sl),('runtime-lock',self.rt),('builder',self.runner)]:
            old_path=str(self.historical/(label+'.dat'));self.retained[old_path]={'path':str(path),'sha256':b.sha(path)};self.files[old_path]=b.sha(path)
        exact_helper=self.meta/'exact-helper.py';put(exact_helper,b'fixture exact helper bytes\n');oh=str(self.historical/'exact-helper.py');self.retained[oh]={'path':str(exact_helper),'sha256':b.sha(exact_helper)};self.files[oh]=b.sha(exact_helper)
        self.integration_log=self.record('integration_log',('ORIGINAL_TYPE_AXIOMS_PASS fixture\n'*114).encode())
        targets=['D1Bound5.MainStatement','D1Bound5.IsD1','D1Bound5.IsD1Tuple','D1Bound5.main_statement']
        target_text=''.join('FINAL_TARGET_AXIOMS_PASS '+n+': []\n' for n in targets)
        self.target_log=self.record('target_log',target_text.encode())
        self.exact_freeze={'schema':1,'source_root':str(self.original),'artifact_root':str(self.art),'build_dir':str(self.build),'build_id':self.origin['build_id'],'identity_hash':self.origin['identity_hash'],'source_lock_sha256':b.sha(self.sl),'runtime_lock_sha256':b.sha(self.rt),'accepted_modules':1,'lean':self.compiler,'environment':self.env,'git_identity':self.git_identity,'runtime_inventory_sha256':b.bridge_digest(self.runtime_files),'runtime_file_count':len(self.runtime_files),'files':self.files,**self.build_evidence}
        self.exact_freeze_path=self.record_json('exact_input_freeze',self.exact_freeze)
        audits=[]
        for name,log,count,harness in [('FinalIntegrationAudit',self.integration_log,114,'scripts/verification/FinalIntegrationAudit.lean'),('FinalTargetAudit',self.target_log,4,'scripts/verification/FinalTargetAudit.lean')]:
            audits.append({'name':name,'exit_code':0,'expected_pass_markers':count,'observed_pass_markers':count,'audit_sha256':self.harnesses[harness],'log_sha256':b.sha(log),'command':[self.compiler,'-j1','-DautoImplicit=false','-R',str(self.original),str(self.original/harness)]})
        self.exact_summary={'status':'CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS','post_audit_all_input_hashes_equal':True,'accepted_fresh_project_modules':1,'input_freeze_sha256':b.sha(self.exact_freeze_path),'source_lock_sha256':b.sha(self.sl),'runtime_lock_sha256':b.sha(self.rt),'audits':audits}
        self.exact_summary_path=self.record_json('exact_summary',self.exact_summary)
        broad_source=self.meta/'Audit.lean';put(broad_source,b'fixture broad audit bytes\n');patch.object(b,'BRIDGE_BROAD_SHA',b.sha(broad_source)).start();self.broad_old=str(self.historical/'Audit.lean');self.retained[self.broad_old]={'path':str(broad_source),'sha256':b.sha(broad_source)}
        self.broad_log=self.record('broad_log',('AUDIT D1Bound5: []\nAUDIT D1Bound5.fixture: []\nAXIOM_AUDIT_PASS: 2 project declarations\nBROAD_PROJECT_AXIOM_AUDIT_PASS 3 declarations\n'+target_text).encode())
        self.broad_freeze={'exact_audit_input_freeze_sha256':b.sha(self.exact_freeze_path),'command_root':str(self.historical),'files':{self.broad_old:b.sha(broad_source),**{self.roles[r]:b.sha(self.record_files[r]) for r in ['exact_summary','exact_input_freeze','integration_log','target_log']}}}
        self.broad_freeze_path=self.record_json('broad_evidence_freeze',self.broad_freeze)
        self.broad_summary={'status':'CLEAN_BROAD_COMPATIBILITY_AUDIT_PASS','exit_code':0,'all_clean_source_artifact_runtime_git_and_evidence_guards_equal':True,'exact_audit_input_freeze_sha256':b.sha(self.exact_freeze_path),'broad_source_sha256':b.BRIDGE_BROAD_SHA,'log_sha256':b.sha(self.broad_log),'command':[self.compiler,'-j1','-DautoImplicit=false','-R',str(self.historical),self.broad_old],'markers':{'exported_project_declarations':2,'including_private_declarations':3,'independent_target_markers':4,'individual_exported_audit_lines':2}}
        self.broad_summary_path=self.record_json('broad_summary',self.broad_summary)
        policy={'status':'SOURCE_POLICY_PASS_SOURCE_ONLY','production_module_count':1,'reachable_module_count':1,**{k:[] for k in ['errors','unreviewed_findings','unreviewed_options','source_changes_during_scan']}}
        policy_path=self.record_json('source_policy_report',policy);policy_map=self.record_json('source_policy_manifest',{'D1Bound5':{k:self.lock['sources']['D1Bound5'][k] for k in ['bytes','relative_path','sha256']}})
        patch.object(b,'BRIDGE_POLICY_SHA',b.sha(policy_path)).start();patch.object(b,'BRIDGE_POLICY_MANIFEST_SHA',b.sha(policy_map)).start()
        self.mapping={'schema':1,'kind':'D1BOUND5_REPLAY_SOURCE_RELOCATION','original_compile_root':str(self.original),'replay_source_root':str(self.project),'artifact_root':str(self.art),'distribution_root':str(self.root),'candidate_commit':b.BRIDGE_COMMIT,'candidate_tree':b.BRIDGE_TREE,'source_lock_sha256':b.sha(self.sl),'runtime_lock_sha256':b.sha(self.rt),'source_inventory_sha256':b.sha(self.inventory),'build_origin_sha256':b.sha(self.build/'ORIGIN.json'),'build_summary_sha256':b.sha(self.build/'SUMMARY.json'),'build_id':self.origin['build_id'],'build_identity_hash':self.origin['identity_hash'],'records':self.roles,'retained_files':self.retained}
        self.mapping_path=self.meta/'RELOCATION.json';self.write_mapping()
    def fake_git(self,command,**kwargs):
        self.git_calls.append(command)
        words=command[command.index('-C')+2:]
        if self.git_hook:
            value=self.git_hook(words)
            if value is not None:return value
        if words==['rev-parse','--show-toplevel']:return (str(self.project)+'\n').encode()
        if words==['rev-parse','--absolute-git-dir']:return (str(self.project/'.git')+'\n').encode()
        if words==['rev-parse','--git-common-dir']:return b'.git\n'
        if words==['rev-parse','HEAD']:return (self.git_commit+'\n').encode()
        if words==['rev-parse','HEAD^{tree}']:return (self.git_tree+'\n').encode()
        if words==['rev-parse','--show-object-format']:return (self.git_format+'\n').encode()
        if words==['status','--porcelain=v1','--untracked-files=all']:return self.git_status
        if words==['ls-tree','-r','-z','HEAD']:return b''.join(('100644 blob '+oid+'\t'+n).encode()+b'\0' for n,oid in sorted(self.git_entries.items()))
        raise AssertionError('Unexpected Git command '+repr(command))
    def record(self,role,raw):
        path=self.meta/(role+'.record');put(path,raw);historical=str(self.historical/(role+'.record'));self.roles[role]=historical;self.retained[historical]={'path':str(path),'sha256':b.sha(path)};self.record_files[role]=path;return path
    def record_json(self,role,value):return self.record(role,(json.dumps(value,sort_keys=True,indent=2)+'\n').encode())
    def write_mapping(self): self.mapping_sha=save(self.mapping_path,self.mapping)
    def write_receipt(self):
        save(self.receipt,self.row);save(self.pointer,{'receipt_path':str(self.receipt.relative_to(self.build)),'receipt_sha256':b.sha(self.receipt)})
    def replace_record(self,role,value):
        p=self.record_files[role];save(p,value);self.retained[self.roles[role]]['sha256']=b.sha(p);self.write_mapping()
    def load(self):return b.bridge_load(self.mapping_path,self.mapping_sha,self.project,self.art,self.root,self.sl,self.rt,self.inventory)
    def evidence(self):
        artifacts=b.artifact_inventory([str(self.art),str(self.builtin)])
        sources={str(self.source):b.sha(self.source)}
        pins,compiler,args=b.clean_lock_evidence(self.root,self.project,self.art,self.env,['D1Bound5'],sources,self.inventory,self.sl,self.rt,compile_project=self.original)
        bp,be=b.clean_build_evidence(self.project,self.art,self.env,['D1Bound5'],sources,artifacts,self.inventory,compiler,args,compile_project=self.original)
        return artifacts,pins,bp,be,compiler
    def bind(self,context=None):
        context=context or self.load();arts,pins,bp,be,compiler=self.evidence();pins.update(bp);pins.update(arts);pins.update({str(self.project/n):h for n,h in self.expected.items()})
        return b.bridge_bind(context,pins,bp,be,arts,compiler,self.origin)
    def freeze(self):
        args=argparse.Namespace(project_root=self.project,project_build_root=self.art,source_relocation_manifest=self.mapping_path,source_relocation_sha256=self.mapping_sha,target='D1Bound5',source_lock=self.sl,runtime_lock=self.rt,manifest=self.inventory,lean_env=self.env_path)
        return b.build_freeze(args,self.root,self.env,[str(self.art),str(self.builtin)],self.checker)

class BridgeTests(unittest.TestCase):
    def setUp(self):self.f=Fixture(self)
    def reject_load(self):
        with self.assertRaises((ValueError,FileNotFoundError,KeyError)):self.f.load()
    def reject_bind(self):
        with self.assertRaises((ValueError,FileNotFoundError,KeyError)):self.f.bind()
    def test_valid_mapping_absent_old_root_and_historical_argv(self):
        f=self.f;self.assertFalse(f.original.exists());ctx=f.load();extra=f.bind(ctx)
        self.assertEqual(ctx['original'],str(f.original));self.assertTrue(all(Path(p).is_relative_to(f.base) for p in extra))
        self.assertEqual(json.loads(f.receipt.read_text())['command'][-1],str(f.original/'D1Bound5.lean'))
        self.assertEqual(json.loads(f.receipt.read_text())['command'][4],str(f.original))
    def test_valid_full_schema4_freeze_and_validate_without_lean(self):
        x=self.f.freeze();self.assertEqual(x['schema'],4);b.validate(x);self.assertTrue(all(Path(p).is_relative_to(Path('/tmp')) for p in x['pins']))
    def test_wrong_manifest_pin(self):self.f.mapping_sha='0'*64;self.reject_load()
    def test_missing_manifest_pin(self):self.f.mapping_sha=None;self.reject_load()
    def test_unexpected_manifest_key(self):self.f.mapping['extra']=1;self.f.write_mapping();self.reject_load()
    def test_wrong_original_compile_root(self):self.f.mapping['original_compile_root']=str(self.f.base/'wrong');self.f.write_mapping();self.reject_load()
    def test_same_replay_compile_root(self):self.f.mapping['original_compile_root']=str(self.f.project);self.f.write_mapping();self.reject_load()
    def test_relative_old_root(self):self.f.mapping['original_compile_root']='relative/root';self.f.write_mapping();self.reject_load()
    def test_parent_segment_old_root(self):self.f.mapping['original_compile_root']=str(self.f.base)+'/x/../old';self.f.write_mapping();self.reject_load()
    def test_wrong_artifact_root(self):self.f.mapping['artifact_root']=str(self.f.base/'wrong');self.f.write_mapping();self.reject_load()
    def test_wrong_runtime_root(self):self.f.mapping['distribution_root']=str(self.f.base/'wrong');self.f.write_mapping();self.reject_load()
    def test_wrong_build_identity(self):self.f.mapping['build_identity_hash']='0'*64;self.f.write_mapping();self.reject_load()
    def test_wrong_build_id(self):self.f.mapping['build_id']='wrong';self.f.write_mapping();self.reject_load()
    def test_wrong_candidate_commit_manifest(self):self.f.mapping['candidate_commit']='0'*40;self.f.write_mapping();self.reject_load()
    def test_wrong_source_lock_pin(self):self.f.mapping['source_lock_sha256']='0'*64;self.f.write_mapping();self.reject_load()
    def test_changed_source_bytes_despite_clean_git_status(self):put(self.f.source,b'changed');self.reject_load()
    def test_missing_source(self):self.f.source.unlink();self.reject_load()
    def test_changed_config(self):put(self.f.project/'lakefile.lean',b'changed');self.reject_load()
    def test_extra_lean_source(self):put(self.f.project/'Extra.lean',b'extra');self.reject_load()
    def test_extra_ignored_nonsource_file(self):put(self.f.project/'ignored.txt',b'extra');self.reject_load()
    def test_git_wrong_head(self):self.f.git_commit='0'*40;self.reject_load()
    def test_git_wrong_tree(self):self.f.git_tree='0'*40;self.reject_load()
    def test_git_dirty_index(self):self.f.git_status=b' M D1Bound5.lean\n';self.reject_load()
    def test_git_wrong_blob(self):self.f.git_entries['D1Bound5.lean']='0'*40;self.reject_load()
    def test_git_wrong_object_format(self):self.f.git_format='sha256';self.reject_load()
    def test_git_changes_during_scan(self):
        n=[0]
        def hook(words):
            if words==['rev-parse','HEAD']:
                n[0]+=1
                if n[0]>1:return b'0000000000000000000000000000000000000000\n'
        self.f.git_hook=hook;self.reject_load()
    def test_source_symlink(self):
        f=self.f;p=f.base/'other';put(p,f.source.read_bytes());f.source.unlink();f.source.symlink_to(p);self.reject_load()
    def test_source_directory_symlink(self):
        f=self.f;p=f.base/'other';p.mkdir();(f.project/'linked').symlink_to(p,target_is_directory=True);self.reject_load()
    def test_git_directory_symlink(self):
        f=self.f;(f.project/'.git/config').unlink();(f.project/'.git').rmdir();p=f.base/'git-copy';p.mkdir();(f.project/'.git').symlink_to(p,target_is_directory=True);self.reject_load()
    def test_git_external_actual_gitdir(self):
        f=self.f;external=f.base/'external-git';external.mkdir()
        f.git_hook=lambda words: (str(external)+'\n').encode() if words==['rev-parse','--absolute-git-dir'] else None
        self.reject_load()
    def test_git_external_common_gitdir(self):
        f=self.f;external=f.base/'external-git';external.mkdir()
        f.git_hook=lambda words: (str(external)+'\n').encode() if words==['rev-parse','--git-common-dir'] else None
        self.reject_load()
    def test_git_indirect_metadata_files_refused(self):
        for name in ['commondir','gitdir','shallow','config.worktree']:
            with self.subTest(name=name):
                p=self.f.project/'.git'/name;put(p,b'fixture external ref\n')
                self.reject_load();p.unlink()
    def test_git_nonempty_external_alternates_refused(self):
        for name in ['objects/info/alternates','objects/info/http-alternates']:
            with self.subTest(name=name):
                p=self.f.project/'.git'/name;put(p,b'/missing/external/objects\n')
                self.reject_load();p.unlink()
    def test_git_empty_alternates_remain_standalone(self):
        put(self.f.project/'.git/objects/info/alternates',b'  \n')
        self.f.bind()
    def test_git_promisor_object_marker_refused(self):
        put(self.f.project/'.git/objects/pack/synthetic.promisor',b'')
        self.reject_load()
    def test_git_external_config_directives_refused(self):
        for value in [b'[include]\n path = /outside\n',b'[includeIf "gitdir:*"]\n path = /outside\n',b'[extensions]\n partialClone = outside\n',b'[remote "origin"]\n promisor = true\n']:
            with self.subTest(value=value):
                put(self.f.project/'.git/config',value);self.reject_load()
    def test_git_bare_promisor_refused(self):
        put(self.f.project/'.git/config',b'[remote "origin"]\n promisor\n')
        self.reject_load()
    def test_git_bare_promisor_comments_refused(self):
        for suffix in [b' # lazy objects',b' ; partial clone',b'\t# comment',b'   ']:
            with self.subTest(suffix=suffix):
                put(self.f.project/'.git/config',b'[remote "origin"]\n promisor'+suffix+b'\n')
                self.reject_load()
    def test_git_metadata_symlink_refused(self):
        f=self.f;p=f.base/'external-config';put(p,b'[core]\n')
        (f.project/'.git/config').unlink();(f.project/'.git/config').symlink_to(p)
        self.reject_load()
    def test_git_metadata_special_file_refused(self):
        os.mkfifo(self.f.project/'.git/fixture-fifo')
        self.reject_load()
    def test_git_config_changes_during_scan(self):
        f=self.f
        def hook(words):
            if words==['rev-parse','HEAD']:
                put(f.project/'.git/config',b'[include]\n path = /outside\n')
        f.git_hook=hook;self.reject_load()
    def test_missing_record_role(self):del self.f.roles['target_log'];self.f.write_mapping();self.reject_load()
    def test_missing_retained_mapping(self):del self.f.retained[self.f.roles['target_log']];self.f.write_mapping();self.reject_bind()
    def test_unused_retained_mapping(self):
        f=self.f;p=f.meta/'unused';put(p,b'x');f.retained[str(f.historical/'unused')]={'path':str(p),'sha256':b.sha(p)};f.write_mapping();self.reject_bind()
    def test_destination_collision(self):
        f=self.f;f.retained[f.roles['target_log']]=dict(f.retained[f.roles['integration_log']]);f.write_mapping();self.reject_load()
    def test_retained_file_symlink(self):
        f=self.f;p=f.meta/'copy';put(p,f.target_log.read_bytes());f.target_log.unlink();f.target_log.symlink_to(p);self.reject_load()
    def test_retained_mapping_into_old_source_root(self):
        f=self.f;f.original.mkdir();p=f.original/'old.log';put(p,b'x');f.retained[f.roles['target_log']]={'path':str(p),'sha256':b.sha(p)};f.write_mapping();self.reject_load()
    def test_mapping_changes_after_load(self):ctx=self.f.load();put(self.f.mapping_path,b'{}');self.assertRaises(ValueError,self.f.bind,ctx)
    def test_retained_bytes_change_after_load(self):ctx=self.f.load();put(self.f.target_log,b'changed');self.assertRaises(ValueError,self.f.bind,ctx)
    def test_receipt_historical_argv_forgery(self):self.f.row['command'][-1]=str(self.f.source);self.f.write_receipt();self.reject_bind()
    def test_receipt_wrong_R_root(self):self.f.row['command'][4]=str(self.f.project);self.f.write_receipt();self.reject_bind()
    def test_receipt_source_hash_forgery(self):self.f.row['source_sha256']='0'*64;self.f.write_receipt();self.reject_bind()
    def test_receipt_failed(self):self.f.row['status']='COMPILER_FAILED';self.f.write_receipt();self.reject_bind()
    def test_receipt_pointer_escape(self):save(self.f.pointer,{'receipt_path':'../escape.json','receipt_sha256':'0'*64});self.reject_bind()
    def test_build_summary_incomplete(self):
        f=self.f;f.summary['status']='BUILD_FAILED';save(f.build/'SUMMARY.json',f.summary);f.mapping['build_summary_sha256']=b.sha(f.build/'SUMMARY.json');f.write_mapping();self.reject_bind()
    def test_build_summary_active(self):
        f=self.f;f.summary['active']=['D1Bound5'];save(f.build/'SUMMARY.json',f.summary);f.mapping['build_summary_sha256']=b.sha(f.build/'SUMMARY.json');f.write_mapping();self.reject_bind()
    def test_origin_nonempty_initial_artifacts(self):
        f=self.f;f.origin['initial_artifact_inventory']=['old'];save(f.build/'ORIGIN.json',f.origin);f.mapping['build_origin_sha256']=b.sha(f.build/'ORIGIN.json');f.write_mapping();self.reject_bind()
    def test_artifact_changed(self):put(self.f.artifact,b'changed');self.reject_bind()
    def test_artifact_symlink(self):
        f=self.f;p=f.base/'artifact-copy';put(p,f.artifact.read_bytes());f.artifact.unlink();f.artifact.symlink_to(p);self.reject_bind()
    def test_artifact_extra_unknown_suffix_before_freeze(self):put(self.f.art/'D1Bound5.olean.foo',b'extra');self.reject_bind()
    def test_artifact_extra_unknown_suffix_after_freeze(self):
        x=self.f.freeze();put(self.f.art/'D1Bound5.olean.foo',b'extra');self.assertRaises(ValueError,b.validate,x)
    def test_artifact_symlink_directory_after_freeze(self):
        f=self.f;x=f.freeze();p=f.base/'external-artifacts';p.mkdir()
        (f.art/'linked').symlink_to(p,target_is_directory=True)
        self.assertRaises(ValueError,b.validate,x)
    def test_receipt_dependency_map_forged(self):
        self.f.row['dependencies']={'D1Bound5.fake':{'receipt_sha256':'0'*64,'artifact_bundle':{}}}
        self.f.write_receipt();self.reject_bind()
    def test_artifact_extra_junk_after_freeze(self):
        x=self.f.freeze();put(self.f.art/'junk',b'extra');self.assertRaises(ValueError,b.validate,x)
    def test_audit_forged_recorded_marker_count(self):
        f=self.f;f.exact_summary['audits'][0]['observed_pass_markers']=113;f.replace_record('exact_summary',f.exact_summary);self.reject_bind()
    def test_audit_actual_markers_missing_with_matching_log_hash(self):
        f=self.f;put(f.integration_log,b'no actual markers\n');f.retained[f.roles['integration_log']]['sha256']=b.sha(f.integration_log);f.exact_summary['audits'][0]['log_sha256']=b.sha(f.integration_log);f.replace_record('exact_summary',f.exact_summary);self.reject_bind()
    def test_audit_wrong_historical_command(self):
        f=self.f;f.exact_summary['audits'][0]['command'][4]=str(f.project);f.replace_record('exact_summary',f.exact_summary);self.reject_bind()
    def test_audit_wrong_artifact_binding(self):
        f=self.f;f.exact_freeze['artifact_bundles_sha256']='0'*64;f.replace_record('exact_input_freeze',f.exact_freeze);f.exact_summary['input_freeze_sha256']=b.sha(f.exact_freeze_path);f.replace_record('exact_summary',f.exact_summary);self.reject_bind()
    def test_audit_missing_source_from_snapshot(self):
        f=self.f;del f.exact_freeze['files'][str(f.original/'D1Bound5.lean')];f.replace_record('exact_input_freeze',f.exact_freeze);f.exact_summary['input_freeze_sha256']=b.sha(f.exact_freeze_path);f.replace_record('exact_summary',f.exact_summary);self.reject_bind()
    def test_broad_forged_markers_summary(self):
        f=self.f;f.broad_summary['markers']['including_private_declarations']=99;f.replace_record('broad_summary',f.broad_summary);self.reject_bind()
    def test_broad_forged_actual_target_set(self):
        f=self.f;put(f.broad_log,f.broad_log.read_bytes().replace(b'D1Bound5.main_statement:',b'D1Bound5.wrong:'));f.retained[f.roles['broad_log']]['sha256']=b.sha(f.broad_log);f.broad_summary['log_sha256']=b.sha(f.broad_log);f.replace_record('broad_summary',f.broad_summary);self.reject_bind()
    def test_broad_different_exact_freeze(self):
        f=self.f;f.broad_summary['exact_audit_input_freeze_sha256']='0'*64;f.replace_record('broad_summary',f.broad_summary);self.reject_bind()
    def test_broad_omits_exact_record(self):
        f=self.f;del f.broad_freeze['files'][f.roles['target_log']];f.replace_record('broad_evidence_freeze',f.broad_freeze);self.reject_bind()
    def test_policy_report_changed(self):
        f=self.f;value=json.loads(f.record_files['source_policy_report'].read_text());value['status']='REVIEW_REQUIRED';f.replace_record('source_policy_report',value);self.reject_bind()
    def test_source_mutated_after_freeze(self):
        x=self.f.freeze();put(self.f.source,b'changed');self.assertRaises(ValueError,b.validate,x)
    def test_extra_old_live_pin_after_freeze(self):
        x=self.f.freeze();x['pins']['/workspace/old-live-pin']='0'*64;self.assertRaises(ValueError,b.validate,x)
    def test_bridge_path_alias_and_missing_rejection(self):
        for value in ['relative','/tmp/../var','/tmp//x',str(self.f.base/'missing')]:
            with self.subTest(value=value),self.assertRaises((ValueError,FileNotFoundError)):b.bridge_path(value)

class CompatibilityTests(unittest.TestCase):
    def test_official_execute_and_resource_helpers_ast_unchanged(self):
        a={n.name:n for n in ast.parse(ORIGINAL.read_bytes()).body if isinstance(n,ast.FunctionDef)}
        c={n.name:n for n in ast.parse(SOURCE.read_bytes()).body if isinstance(n,ast.FunctionDef)}
        for name in ['execute','cgroup','approved_environment','process_memory','resolve_module','validate_clean_paths','artifact_inventory','distribution_libraries']:
            with self.subTest(name=name):self.assertEqual(ast.dump(a[name],include_attributes=False),ast.dump(c[name],include_attributes=False))
    def test_default_plan_matches_original(self):
        results=[]
        for mod in [old,b]:
            out=io.StringIO()
            with patch.object(sys,'argv',[mod.__file__,'plan','--offload-root','/tmp/fixture-offload']),contextlib.redirect_stdout(out):self.assertEqual(mod.main(),0)
            results.append(json.loads(out.getvalue()))
        self.assertEqual(results[0],results[1]);self.assertEqual(results[1]['command'],['/tmp/fixture-offload/lean-4.33.1-linux/bin/leanchecker','--verbose','--fresh','D1Bound5'])
    def test_relocation_cli_pair_and_freeze_only_refusals(self):
        cases=[['plan','--source-relocation-manifest','/tmp/x'],['freeze','--source-relocation-manifest','/tmp/x'],['freeze','--source-relocation-sha256','0'*64],['run','--source-relocation-manifest','/tmp/x','--source-relocation-sha256','0'*64],['plan','--source-relocation-manifest','/tmp/x','--source-relocation-sha256','0'*64]]
        for args in cases:
            with self.subTest(args=args),patch.object(sys,'argv',[b.__file__,*args]),contextlib.redirect_stderr(io.StringIO()),self.assertRaises(SystemExit) as error:b.main()
            self.assertEqual(error.exception.code,2)
    def test_default_full_schema3_freeze_matches_original(self):
        f=Fixture(self);shutil.copytree(f.project,f.original)
        args=argparse.Namespace(project_root=f.original,project_build_root=f.art,
            source_relocation_manifest=None,source_relocation_sha256=None,target='D1Bound5',
            source_lock=f.sl,runtime_lock=f.rt,manifest=f.inventory,lean_env=f.env_path)
        results=[]
        for mod in [old,b]:
            with patch.object(mod,'utc',return_value='SYNTHETIC_SAME_UTC'):
                frozen=mod.build_freeze(args,f.root,f.env,[str(f.art),str(f.builtin)],f.checker)
            self.assertEqual(frozen['schema'],3)
            self.assertEqual(frozen['pins'].pop(str(Path(mod.__file__).resolve())),b.sha(mod.__file__))
            mod.validate({**frozen,'pins':dict(frozen['pins'])})
            results.append(frozen)
        self.assertEqual(results[0],results[1])

    def test_default_schema3_clean_evidence_matches_original(self):
        f=Fixture(self);shutil.copytree(f.project,f.original)
        order=['D1Bound5'];sources={str(f.original/'D1Bound5.lean'):b.sha(f.source)};arts=b.artifact_inventory([str(f.art),str(f.builtin)])
        outputs=[]
        for mod in [old,b]:
            lp,compiler,args=mod.clean_lock_evidence(f.root,f.original,f.art,f.env,order,sources,f.inventory,f.sl,f.rt)
            bp,evidence=mod.clean_build_evidence(f.original,f.art,f.env,order,sources,arts,f.inventory,compiler,args)
            outputs.append((lp,compiler,args,bp,evidence))
        self.assertEqual(outputs[0],outputs[1])

if __name__=='__main__':unittest.main(verbosity=2)
