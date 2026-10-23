"""Read-only prerequisite registry for local builds and guarded historical imports."""
from pathlib import Path
import hashlib, json

LEAN_SHA='e8baaa71855a616dc351028f3ad2200051b0671f423a1696a100e809302d5550'
KERNEL_SHA='23d636cac1cadcba37beac30eff9b9b20d66cee726cf5defb4ae39f1284a3e5a'
COMPAT_SHA='adadebacce0eff75173ba60108b682c546badfa189551527bd7be9062fc0853e'
MATHLIB='0df444a360eaa60ab8c11dca51a86af692955474'

class Registry:
    def __init__(self,g,frozen):
        self.g,self.frozen=g,frozen
        self.cache={}
        self.dependencies={n:[x[9:] for x in g.imports(n) if x.startswith('D1Bound5.')] for n in frozen}
        self.direct_external={n:{x for x in g.imports(n) if not x.startswith('D1Bound5.')} for n in frozen}
        self.closures={}
        self.external_names={}
        self.candidates={}
        self.selected={}
        self.rejected={}
        self.export_manifests={}
        assert self.digest(g.BIN/'lean')==LEAN_SHA,'PINNED_LEAN_BINARY_CHANGED'
        assert self.digest(g.BIN.parent/'lib/lean/libleanshared.so')==KERNEL_SHA,'PINNED_KERNEL_CHANGED'
        assert self.digest(g.R/'proc_self_exe_compat.so')==COMPAT_SHA,'PINNED_COMPAT_SHIM_CHANGED'
        self.runtime_setup=json.loads((g.R/'RUNTIME_SETUP.json').read_text())
        assert self.runtime_setup['lean_binary_sha256']==LEAN_SHA
        assert self.runtime_setup['kernel_library_sha256']==KERNEL_SHA
        assert self.runtime_setup['compat_object_sha256']==COMPAT_SHA
        assert self.runtime_setup['mathlib_commit']==MATHLIB
        for directory in g.R.glob('results-*'):
            for p in directory.glob('*-receipt.json'):
                try:row=json.loads(p.read_text())
                except (ValueError,OSError):continue
                n=row.get('name')
                if n in frozen:self.candidates.setdefault(n,[]).append((p,row))

    def digest(self,p):
        p=Path(p)
        if not p.exists():return None
        st=p.stat();key=(str(p),st.st_size,st.st_mtime_ns,st.st_ctime_ns)
        if key not in self.cache:self.cache[key]=hashlib.sha256(p.read_bytes()).hexdigest()
        return self.cache[key]

    def closure(self,n):
        if n not in self.closures:
            out={n:self.frozen[n]};ext=set(self.direct_external[n])
            for d in self.dependencies[n]:
                out.update(self.closure(d));ext.update(self.external_names[d])
            self.closures[n]=out;self.external_names[n]=ext
        return self.closures[n]

    def parts(self,n):
        base=self.g.artifact(n)
        return {str(p):self.digest(p) for p in [base,Path(str(base)+'.server'),Path(str(base)+'.private')] if p.exists()}

    def external(self,n):
        self.closure(n)
        out={}
        for mod in self.external_names[n]:
            suffix=Path(*mod.split('.')).with_suffix('.olean')
            paths=[p/suffix for p in self.g.SEARCH if (p/suffix).exists()]
            assert paths,'MISSING_EXTERNAL '+mod
            p=paths[0];out[mod]={'path':str(p),'sha256':self.digest(p)}
        return out

    def validate_row(self,n,row):
        status=row.get('proof_status',row.get('status'))
        assert status in ['COMPILED_ONLY','IMPORTED_HISTORICAL_ACCEPTANCE'],'NOT_SUCCESSFUL_RECEIPT'
        sc=self.closure(n)
        assert row.get('source_closure')==sc,'SOURCE_CLOSURE_MISMATCH'
        assert row.get('toolchain')=='4.33.1','TOOLCHAIN_MISMATCH'
        assert row.get('artifact_sha256')==self.digest(self.g.artifact(n)) and self.g.artifact(n).exists(),'ARTIFACT_MISMATCH'
        deps={d:self.digest(self.g.artifact(d)) for d in sc if d!=n}
        assert all(deps.values()),'MISSING_DEPENDENCY_ARTIFACT'
        assert row.get('dependency_artifacts')==deps,'DEPENDENCY_ARTIFACT_GUARD_MISMATCH'
        actual_parts=self.parts(n)
        if status=='COMPILED_ONLY':
            assert row.get('exit_code')==0,'COMPILER_EXIT_NOT_ZERO'
            command=row.get('command',[])
            assert command and Path(command[0])==self.g.BIN/'lean','UNPINNED_COMPILER_COMMAND'
            if 'artifact_parts' in row:assert row['artifact_parts']==actual_parts,'ARTIFACT_PARTS_MISMATCH'
            else:assert len(actual_parts)==1,'UNGUARDED_ADDITIONAL_ARTIFACT_PARTS'
            if 'external_import_artifacts' in row:
                assert row.get('lean_binary_sha256')==LEAN_SHA,'COMPILER_BINARY_GUARD_MISMATCH'
                assert row.get('proc_path_compat_sha256')==COMPAT_SHA,'COMPAT_GUARD_MISMATCH'
                assert row.get('mathlib_commit')==MATHLIB,'MATHLIB_PIN_MISMATCH'
                assert row['external_import_artifacts']==self.external(n),'EXTERNAL_IMPORT_GUARD_MISMATCH'
                mode='LOCAL_GENERAL_COMPILER_RECEIPT'
            else:
                # guarded_compile.py explicitly rejects every external import except Init.
                assert self.external_names[n]<={'Init'},'MISSING_EXTERNAL_IMPORT_GUARDS'
                mode='LOCAL_PURE_INIT_COMPILER_RECEIPT_WITH_PINNED_RUNTIME'
        else:
            assert row.get('exit_code')==0,'IMPORT_EXIT_NOT_ZERO'
            assert row.get('artifact_parts')==actual_parts,'HISTORICAL_ARTIFACT_PARTS_MISMATCH'
            assert row.get('mathlib_commit')==MATHLIB,'MATHLIB_PIN_MISMATCH'
            assert row.get('external_import_artifacts')==self.external(n),'EXTERNAL_IMPORT_GUARD_MISMATCH'
            history=row.get('historical_acceptance')
            assert isinstance(history,dict) and history,'MISSING_ORIGINAL_HISTORICAL_ACCEPTANCE'
            fingerprint=hashlib.sha256(json.dumps(sc,sort_keys=True).encode()).hexdigest()
            assert history.get('name')==n and history.get('source_closure')==sc,'HISTORICAL_SOURCE_MISMATCH'
            assert history.get('fingerprint')==fingerprint,'HISTORICAL_FINGERPRINT_MISMATCH'
            original=history.get('acceptance_row') or history.get('baseline_row')
            assert original and original.get('fingerprint')==fingerprint,'MISSING_ORIGINAL_ACCEPTANCE'
            if history.get('acceptance_row'):assert original.get('accepted_build') is True,'ORIGINAL_BUILD_NOT_ACCEPTED'
            assert original.get('artifacts')==history.get('historical_all_artifacts'),'ORIGINAL_ARTIFACT_RECORD_MISMATCH'
            exported=history.get('exported_artifacts',{})
            assert exported and {str(self.g.P/p):h for p,h in exported.items()}==actual_parts,'ORIGINAL_EXPORTED_ARTIFACT_MISMATCH'
            assert all(history['historical_all_artifacts'].get(p)==h for p,h in exported.items()),'UNACCEPTED_EXPORTED_PART'
            manifest_path=Path(row['export_manifest_path'])
            manifest_hash=self.digest(manifest_path)
            assert manifest_hash==row.get('export_manifest_sha256'),'EXPORT_MANIFEST_CHANGED'
            key=(str(manifest_path),manifest_hash)
            if key not in self.export_manifests:
                manifest=json.loads(manifest_path.read_text())
                manifest['_rows_by_name']={r['name']:r for r in manifest['accepted']}
                self.export_manifests[key]=manifest
            manifest=self.export_manifests[key]
            assert manifest['_rows_by_name'].get(n)==history,'HISTORICAL_ROW_NOT_IN_PINNED_EXPORT'
            assert manifest['toolchain_file'].strip()=='leanprover/lean4:v4.33.1','HISTORICAL_TOOLCHAIN_MISMATCH'
            assert manifest['mathlib_manifest_sha256']==self.runtime_setup['mathlib_manifest_sha256'],'HISTORICAL_MATHLIB_MISMATCH'
            assert row.get('remote_configuration')==manifest['configuration'],'HISTORICAL_CONFIGURATION_MISMATCH'
            histories={d:manifest['dependency_acceptance'][d] for d in sc}
            assert row.get('historical_dependency_acceptance')==histories,'HISTORICAL_DEPENDENCY_RECORD_MISMATCH'
            for d,dep in histories.items():
                dsc=self.closure(d)
                assert dep['source_closure']==dsc,'ORIGINAL_DEPENDENCY_SOURCE_MISMATCH '+d
                assert dep['fingerprint']==hashlib.sha256(json.dumps(dsc,sort_keys=True).encode()).hexdigest(),'ORIGINAL_DEPENDENCY_FINGERPRINT_MISMATCH '+d
                assert dep.get('artifacts'),'MISSING_ORIGINAL_DEPENDENCY_ARTIFACTS '+d
            assert row.get('dependency_artifact_parts')=={d:self.parts(d) for d in sc if d!=n},'DEPENDENCY_PARTS_MISMATCH'
            mode='GUARDED_HISTORICAL_IMPORT'
        return mode

    def validate(self,n):
        if n in self.selected:return True
        if n in self.rejected:return False
        failures=[]
        for p,row in self.candidates.get(n,[]):
            try:mode=self.validate_row(n,row)
            except (AssertionError,KeyError,OSError) as exc:
                failures.append({'receipt':str(p),'reason':str(exc)});continue
            bad=[d for d in self.dependencies[n] if not self.validate(d)]
            if bad:
                failures.append({'receipt':str(p),'reason':'DEPENDENCIES_NOT_INDEPENDENTLY_ACCEPTED','dependencies':bad});continue
            self.selected[n]={'receipt':str(p),'receipt_sha256':self.digest(p),'mode':mode,
                              'artifact_parts':self.parts(n)}
            return True
        self.rejected[n]=failures or [{'reason':'NO_SUCCESSFUL_RECEIPT'}]
        return False

    def report(self,required):
        for n in sorted(required):self.validate(n)
        return {'status':'PASS' if set(required)<=self.selected.keys() else 'PREREQUISITE_PROVENANCE_INCOMPLETE',
                'required_count':len(required),'accepted':self.selected,'rejected':self.rejected,
                'runtime_setup_sha256':self.digest(self.g.R/'RUNTIME_SETUP.json'),
                'historical_export_manifests':{path:sha for path,sha in self.export_manifests},
                'source_closure':self.frozen,'main_theorem_complete':False}
