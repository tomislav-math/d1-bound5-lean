import ast
from contextlib import ExitStack
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import types
import unittest
from unittest import mock

HERE=Path(__file__).parent
SOURCE=HERE/'recorded_supervisor.py'
s=types.ModuleType('supervisor_fixture');s.__file__=str(SOURCE)
exec(compile(SOURCE.read_bytes(),str(SOURCE),'exec'),s.__dict__)


def procstat(pid=900,ppid=800,ticks=1234,comm='normal'):
    fields=['S',str(ppid)]+['0']*17+[str(ticks)]+['0']*8
    return str(pid)+' ('+comm+') '+' '.join(fields)+'\n'


def status(pid=900,ppid=800,pids=None):
    if pids is None:pids=[pid,7]
    return 'Name:\tfixture\nPid:\t%d\nPPid:\t%d\nNSpid:\t%s\n'%(pid,ppid,'\t'.join(map(str,pids)))


class Proc:
    def __init__(self):
        self.text={'/proc/self/stat':procstat(),'/proc/self/status':status()}
        self.links={'/proc/self/ns/pid':'pid:[123]'};self.entries=[];self.reads=[];self.calls={};self.listdir_error=None
    def add(self,pid=901,ppid=900,local=42,namespace='pid:[123]',pids=None):
        self.entries.append(Path('/proc')/str(pid));p='/proc/'+str(pid)
        self.text[p+'/stat']=procstat(pid,ppid);self.text[p+'/status']=status(pid,ppid,pids or [pid,local]);self.links[p+'/ns/pid']=namespace
    def read(self,path,*a,**kw):
        name=str(path);self.reads.append(name);self.calls[name]=self.calls.get(name,0)+1
        value=self.text.get(name,FileNotFoundError(name))
        if isinstance(value,Exception):raise value
        if callable(value):return value(self.calls[name])
        return value
    def readlink(self,path,*a,**kw):
        value=self.links.get(str(path),FileNotFoundError(str(path)))
        if isinstance(value,Exception):raise value
        return value
    def iterdir(self,path):
        if self.listdir_error:raise self.listdir_error
        return iter(self.entries)
    def patch(self):
        stack=ExitStack();f=self
        stack.enter_context(mock.patch.object(Path,'read_text',new=lambda path,*a,**kw:f.read(path,*a,**kw)))
        stack.enter_context(mock.patch.object(Path,'iterdir',new=lambda path:f.iterdir(path)))
        stack.enter_context(mock.patch.object(s.os,'readlink',side_effect=self.readlink))
        stack.enter_context(mock.patch.object(s.os,'getpid',return_value=7))
        return stack


class Metadata(unittest.TestCase):
    def setUp(self):self.p=Proc()
    def child(self):
        with self.p.patch():return s.observe_child_host(42,s.observe_self_host())
    def assert_unavailable(self,result):self.assertEqual(result['status'],'UNAVAILABLE')
    def test_comm_spaces_and_embedded_parentheses(self):
        for comm in ['with spaces','a (b) c','odd ) field) (with ) final','']:
            with self.subTest(comm=comm):
                self.p.text['/proc/self/stat']=procstat(comm=comm)
                with self.p.patch():self.assertEqual(s.proc_identity(Path('/proc/self/stat')),{'host_pid':900,'host_parent_pid':800,'host_start_ticks':1234})
    def test_self_host_distinct_from_namespace_pid(self):
        with self.p.patch():r=s.observe_self_host()
        self.assertEqual(r['host_pid'],900);self.assertEqual(r['namespace_pids'],[900,7])
    def test_stat_wrong_pid(self):
        self.p.text['/proc/self/stat']=procstat(pid=999)
        with self.p.patch():self.assert_unavailable(s.observe_self_host())
    def test_stat_wrong_parent(self):
        self.p.text['/proc/self/status']=status(ppid=999)
        with self.p.patch():self.assert_unavailable(s.observe_self_host())
    def test_self_wrong_local_pid(self):
        self.p.text['/proc/self/status']=status(pids=[900,8])
        with self.p.patch():self.assert_unavailable(s.observe_self_host())
    def test_self_start_race(self):
        self.p.text['/proc/self/stat']=lambda call:procstat(ticks=1234+call)
        with self.p.patch():self.assert_unavailable(s.observe_self_host())
    def test_self_missing_status(self):
        del self.p.text['/proc/self/status']
        with self.p.patch():self.assert_unavailable(s.observe_self_host())
    def test_self_missing_nspid(self):
        self.p.text['/proc/self/status']='Pid:900\nPPid:800\n'
        with self.p.patch():self.assert_unavailable(s.observe_self_host())
    def test_self_empty_nspid(self):
        self.p.text['/proc/self/status']=status(pids=[])
        with self.p.patch():self.assert_unavailable(s.observe_self_host())
    def test_malformed_stat(self):
        for body in ['broken','900 (missing close','900 (ok) S 2','bad (ok) S 2','900 no-open) S 2']:
            with self.subTest(body=body):
                self.p.text['/proc/self/stat']=body
                with self.p.patch():self.assert_unavailable(s.observe_self_host())
    def test_self_missing_namespace(self):
        self.p.links.clear()
        with self.p.patch():self.assert_unavailable(s.observe_self_host())
    def test_unique_child_host_found(self):
        self.p.add();r=self.child();self.assertEqual(r['host_pid'],901);self.assertEqual(r['namespace_pids'],[901,42])
    def test_local_pid_is_not_assumed_host(self):
        self.p.add(pid=42,ppid=77,local=6);self.p.add();self.assertEqual(self.child()['host_pid'],901)
    def test_nonnumeric_entries_ignored(self):
        self.p.entries.extend([Path('/proc/self'),Path('/proc/sys'),Path('/proc/thread-self')]);self.p.add();self.assertEqual(self.child()['host_pid'],901)
    def test_child_missing(self):self.assert_unavailable(self.child())
    def test_child_ambiguous(self):
        self.p.add();self.p.add(pid=902);r=self.child();self.assert_unavailable(r);self.assertEqual(r['matching_entries'],2)
    def test_child_wrong_stat_pid(self):
        self.p.add();self.p.text['/proc/901/stat']=procstat(pid=999,ppid=900);self.assert_unavailable(self.child())
    def test_child_wrong_status_pid(self):
        self.p.add();self.p.text['/proc/901/status']=status(pid=999,ppid=900,pids=[901,42]);self.assert_unavailable(self.child())
    def test_child_wrong_parent(self):self.p.add(ppid=999);self.assert_unavailable(self.child())
    def test_child_status_parent_disagrees(self):
        self.p.add();self.p.text['/proc/901/status']=status(pid=901,ppid=999,pids=[901,42]);self.assert_unavailable(self.child())
    def test_child_wrong_local(self):self.p.add(local=43);self.assert_unavailable(self.child())
    def test_child_wrong_namespace(self):self.p.add(namespace='pid:[999]');self.assert_unavailable(self.child())
    def test_child_wrong_namespace_depth(self):self.p.add(pids=[901,99,42]);self.assert_unavailable(self.child())
    def test_child_raced_ticks(self):
        self.p.add();self.p.text['/proc/901/stat']=lambda call:procstat(901,900,1234+call);self.assert_unavailable(self.child())
    def test_child_disappears_on_reread(self):
        self.p.add()
        def read(call):
            if call>1:raise FileNotFoundError('child exited')
            return procstat(901,900)
        self.p.text['/proc/901/stat']=read;self.assert_unavailable(self.child())
    def test_child_status_permission_error(self):
        self.p.add();self.p.text['/proc/901/status']=PermissionError('not visible');self.assert_unavailable(self.child())
    def test_proc_scan_unavailable(self):self.p.listdir_error=PermissionError('proc');self.assert_unavailable(self.child())
    def test_unavailable_parent_never_scans(self):
        self.p.listdir_error=AssertionError('must not scan')
        with self.p.patch():self.assert_unavailable(s.observe_child_host(42,{'status':'UNAVAILABLE'}))


class TinyChildren(unittest.TestCase):
    def run_child(self,code):
        with tempfile.TemporaryDirectory(prefix='d1-supervisor02-fixture-',dir='/tmp') as temp:
            root=Path(temp);driver=root/'tiny.py';driver.write_text("import os,sys\nos.write(1,b'fixture stdout\\n')\nos.write(2,b'fixture stderr\\n')\nos.write(1,os.environ['D1_SUPERVISOR_FIXTURE'].encode()+b'\\n')\nsys.exit("+str(code)+")\n")
            out=root/'out';spec={'argv':[sys.executable,str(driver)],'cwd':str(root),'out':str(out),'driver_sha256':hashlib.sha256(driver.read_bytes()).hexdigest()}
            path=root/'spec.json';path.write_text(json.dumps(spec));sha=hashlib.sha256(path.read_bytes()).hexdigest();env=dict(os.environ);env['D1_SUPERVISOR_FIXTURE']='inherited'
            result=subprocess.run([sys.executable,str(SOURCE),str(path),sha],cwd='/tmp',env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
            self.assertEqual(result.returncode,code,result.stderr.decode());self.assertEqual(result.stdout,b'');self.assertEqual(result.stderr,b'')
            raw=(out/'DRIVER_STDOUT_STDERR.log').read_bytes();self.assertEqual(raw,b'fixture stdout\nfixture stderr\ninherited\n')
            actual=json.loads((out/'ACTUAL_RETURN.json').read_bytes());self.assertEqual(actual['exit_code'],code);self.assertEqual(actual['stdout_stderr_bytes'],len(raw));self.assertEqual(actual['stdout_stderr_sha256'],hashlib.sha256(raw).hexdigest())
            self.assertEqual(actual['spec_sha256'],sha);self.assertEqual(actual['status'],'ACTUAL_DRIVER_PROCESS_RETURN_NOT_PROOF_ACCEPTANCE')
            start=json.loads((out/'START.json').read_bytes());child=json.loads((out/'CHILD.json').read_bytes());self.assertEqual(start['argv'],spec['argv']);self.assertEqual(start['cwd'],spec['cwd']);self.assertEqual(child['child_namespace_local_pid'],actual['child_namespace_local_pid'])
            self.assertIn(start['supervisor_host_observation']['status'],['OBSERVED_HOST_PROCESS_IDENTITY','UNAVAILABLE']);self.assertIn(child['child_host_observation']['status'],['OBSERVED_HOST_PROCESS_IDENTITY','UNAVAILABLE'])
    def test_actual_child_exit_zero(self):self.run_child(0)
    def test_actual_child_exit_seven(self):self.run_child(7)


class Scope(unittest.TestCase):
    def test_unchanged_popen_wait_helpers(self):
        old=ast.parse((HERE/'original_supervisor.py').read_bytes());new=ast.parse(SOURCE.read_bytes())
        for name in ['sha','utc','write']:
            before=next(n for n in old.body if isinstance(n,ast.FunctionDef) and n.name==name);after=next(n for n in new.body if isinstance(n,ast.FunctionDef) and n.name==name);self.assertEqual(ast.dump(before),ast.dump(after))
        for target in [('subprocess','Popen'),('child','wait')]:
            def nodes(tree):return [ast.dump(n) for n in ast.walk(tree) if isinstance(n,ast.Call) and isinstance(n.func,ast.Attribute) and isinstance(n.func.value,ast.Name) and (n.func.value.id,n.func.attr)==target]
            self.assertEqual(nodes(old),nodes(new));self.assertEqual(len(nodes(new)),1)
    def test_python38_syntax(self):ast.parse(SOURCE.read_bytes(),feature_version=(3,8))

if __name__=='__main__':unittest.main(verbosity=2)
