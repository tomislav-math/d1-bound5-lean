"""Research-only source preparation for the 39 remaining nonstructural rows.
Uses the frozen converter and input bundle; never runs Lean or writes project sources.
"""
from pathlib import Path
import ast, datetime, hashlib, json, os, statistics, subprocess, sys, types

R = Path("/Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation")
PROJECT = Path("/Users/tp/Lean/D1Bound5")
BUNDLE = R / "light-scale-inputs138"
OUT = R / "prepared-light-remaining39"
EVIDENCE = R / "light-remaining39-preparation"
SCRIPT = R / "prepare_light_remaining39.py"
PYTHON = Path("/Users/tp/.local/bin/python3.12")
REQ = R / "light-scale-bootstrap/input_requirements.json"
MAT = R / "checkpoint-12/helpers/pair_selected_scale_next/materialize_inputs.py"
CONVERTER = BUNDLE / "pair_light_scale_next/prepare_light_rows.py"
MAT_SHA = "303299e125503841fa9fe651186d9b10e44faaefaefefacd2f049ade6130f1b0"
REQ_SHA = "a96177b74b4fda368613a8247a62aa2258b3111e651bdedbf856a631adc13634"
CONVERTER_SHA = "67e22402774fe51120cd22ac20826b4bd3f1c44a8bb5c401465f023c3f220dde"
STRUCTURAL = {16, 22, 27, 31, 32, 37, 41}
ROWS = sorted(set(range(1, 49)) - STRUCTURAL - {34, 47})
MODULES = ("SmallPairGraphInputs", "SmallPairGraphWitnessData", "SmallPairGraphArithmetic",
    "SmallPairGraphClosure", "SmallPairGraphData", "SmallPairRawSelectedData",
    "SmallPairGraphTriangle", "SmallPairLightData", "SmallPairLightLeft",
    "SmallPairLightRight", "SmallPairLightAssembly")
sha = lambda b: hashlib.sha256(b).hexdigest()

def need(ok, message):
    if not ok:
        raise RuntimeError(message)

def plain_ancestors(path):
    p = Path(os.path.abspath(path))
    need(all(not q.is_symlink() for q in [p, *p.parents]), "Symlink path: " + str(p))
    return p

def fresh(path):
    plain_ancestors(path)
    need(not os.path.lexists(path), "Existing destination: " + str(path))

def json_bytes(obj):
    return (json.dumps(obj, indent=2) + "\n").encode()

def exclusive(path, data):
    plain_ancestors(path)
    with path.open("xb") as f:
        f.write(data)

def main():
    need(sys.version_info[:2] == (3, 12), "Expected Python 3.12")
    need(sys.flags.optimize == 0 and sys.flags.dont_write_bytecode, "Unsafe Python flags")
    need("PYTHONOPTIMIZE" not in os.environ, "Inherited PYTHONOPTIMIZE")
    need(len(ROWS) == 39, "Wrong row count")
    for p in [OUT, EVIDENCE]:
        fresh(p)
    plain_ancestors(MAT)
    mat_bytes = MAT.read_bytes()
    need(sha(mat_bytes) == MAT_SHA, "Materializer pin mismatch")
    ast.parse(mat_bytes)
    m = types.ModuleType("verified_materializer")
    exec(compile(mat_bytes, str(MAT), "exec"), m.__dict__)
    need(m.read_regular(MAT) == mat_bytes, "Materializer changed")
    need(sha(m.read_regular(CONVERTER)) == CONVERTER_SHA, "Converter pin mismatch")
    need(m.read_regular(CONVERTER) == m.read_regular(R / "prepare_light_rows_recovered.py"),
         "Recovered converter differs")
    required = m.requirements(REQ, REQ_SHA)
    need(len(required) == 138, "Input count mismatch")
    names = sorted(f"D1Bound5/{prefix}{k}.lean" for k in ROWS for prefix in MODULES)
    need(len(names) == len(set(names)) == 429, "Prospective name mismatch")
    input_before = {}
    for item in required:
        b = m.read_regular(BUNDLE / item["path"], item["bytes"])
        need(sha(b) == item["sha256"], "Input pin: " + item["path"])
        input_before[item["path"]] = dict(sha256=sha(b), bytes=len(b))
    materialization_before = m.read_regular(BUNDLE / "materialization_manifest.json")
    materialization = json.loads(materialization_before)
    need(materialization["requirements_sha256"] == REQ_SHA, "Bundle provenance mismatch")
    need({x["path"]: dict(sha256=x["sha256"], bytes=x["bytes"])
         for x in materialization["files"]} == input_before, "Bundle manifest mismatch")
    requirements_before = m.read_regular(REQ)
    project_before, preimage_bytes = {}, {}
    for name in names:
        p = plain_ancestors(PROJECT / name)
        if os.path.lexists(p):
            b = m.read_regular(p)
            project_before[name] = dict(sha256=sha(b), bytes=len(b),
                saved_path="project-preimages/" + name)
            preimage_bytes[name] = b
        else:
            project_before[name] = None
    # All input pins and all target preimages have been checked before data/log writes.
    for p in [OUT, EVIDENCE]:
        fresh(p)
    EVIDENCE.mkdir(mode=0o700)
    exclusive(EVIDENCE / "inputs-before.json", json_bytes(input_before))
    exclusive(EVIDENCE / "project-preimages-before.json", json_bytes(project_before))
    exclusive(EVIDENCE / "requirements.json", requirements_before)
    for name, b in preimage_bytes.items():
        p = EVIDENCE / "project-preimages" / name
        p.parent.mkdir(parents=True, exist_ok=True)
        exclusive(p, b)
    env = os.environ.copy()
    for key in ("PYTHONOPTIMIZE", "PYTHONPATH", "PYTHONHOME", "PYTHONSTARTUP", "PYTHONUSERBASE"):
        env.pop(key, None)
    env["PYTHONNOUSERSITE"] = "1"
    env["PYTHONDONTWRITEBYTECODE"] = "1"
    cmd = [str(PYTHON), "-B", str(CONVERTER), "--workspace", str(BUNDLE),
        "--rows", "all", "--stage-rows", ",".join(map(str, ROWS)),
        "--output-dir", str(OUT), "--emit"]
    exclusive(EVIDENCE / "command.json", json_bytes(dict(argv=cmd,
        PYTHONOPTIMIZE_present=False, PYTHONDONTWRITEBYTECODE="1")))
    start = datetime.datetime.now(datetime.timezone.utc).isoformat()
    print(json.dumps(dict(status="preflight passed; source-only converter starting",
        rows=ROWS, input_files=138, prospective_targets=len(names),
        saved_preimages=len(preimage_bytes), output_dir=str(OUT))), flush=True)
    with (EVIDENCE / "converter.stdout.log").open("xb") as log:
        completed = subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT,
            env=env, timeout=1800, check=False)
    need(completed.returncode == 0, "Converter failed; inspect isolated log")
    manifest_bytes = m.read_regular(OUT / "manifest.json")
    manifest = json.loads(manifest_bytes)
    need(manifest["generator_sha256"] == CONVERTER_SHA, "Output generator pin")
    need(manifest["rows"] == list(range(1, 49)) and manifest["staged_rows"] == ROWS,
         "Wrong diagnostic/staged rows")
    expected = {}
    per_row, classes = [], []
    for report in manifest["results"]:
        k = report["row"]
        if k not in ROWS:
            need("files" not in report, "Unexpected staged row")
            continue
        need(not report["structural"], "Unexpected structural row")
        files = report["files"]
        need(len(files) == 11, "Wrong per-row module count")
        need(not (expected.keys() & files.keys()), "Duplicate output name")
        expected.update(files)
        per_row.append(dict(row=k, tau=report["tau"], nu=report["nu"],
            files=len(files), source_bytes=sum(x["bytes"] for x in files.values()),
            classes=report["classes"]))
        for side, cls in zip(("left", "right"), report["classes"]):
            classes.append(dict(row=k, side=side, **cls))
    need(sorted(expected) == names and manifest["file_count"] == 429, "Output name mismatch")
    actual_names = sorted(str(p.relative_to(OUT)) for p in OUT.rglob("*.lean"))
    need(actual_names == names, "Unexpected/missing Lean output")
    for name, info in expected.items():
        b = m.read_regular(OUT / name, info["bytes"])
        need(sha(b) == info["sha256"], "Emitted source mismatch: " + name)
    need(manifest["total_source_bytes"] == sum(x["bytes"] for x in expected.values()),
         "Output byte total mismatch")
    input_after = {}
    for item in required:
        b = m.read_regular(BUNDLE / item["path"], item["bytes"])
        input_after[item["path"]] = dict(sha256=sha(b), bytes=len(b))
    need(input_after == input_before, "Input bundle changed")
    need(m.read_regular(REQ) == requirements_before, "Requirements changed")
    need(m.read_regular(MAT) == mat_bytes, "Materializer changed")
    need(m.read_regular(BUNDLE / "materialization_manifest.json") == materialization_before,
         "Materialization manifest changed")
    project_after = {}
    for name in names:
        p = plain_ancestors(PROJECT / name)
        if os.path.lexists(p):
            b = m.read_regular(p)
            project_after[name] = dict(sha256=sha(b), bytes=len(b),
                saved_path="project-preimages/" + name)
        else:
            project_after[name] = None
    need(project_after == project_before, "Prospective project target changed during run")
    for name, b in preimage_bytes.items():
        need(m.read_regular(EVIDENCE / "project-preimages" / name) == b,
             "Saved preimage mismatch")
    exclusive(EVIDENCE / "inputs-after.json", json_bytes(input_after))
    exclusive(EVIDENCE / "project-preimages-after.json", json_bytes(project_after))
    counts = sorted(x["pairs"] for x in classes)
    ranges = [(0, 8000), (8001, 20000), (20001, 26106), (26107, 50000),
        (50001, 100000), (100001, 250000), (250001, 10**20)]
    distribution = dict(class_count=len(classes), total_pairs=sum(counts),
        minimum=counts[0], maximum=counts[-1], median=statistics.median(counts),
        ranges=[dict(minimum=lo, maximum=hi, count=sum(lo<=n<=hi for n in counts))
            for lo, hi in ranges],
        classes_over_8000=[dict(row=x["row"], side=x["side"], pairs=x["pairs"])
            for x in classes if x["pairs"]>8000],
        classes_over_26106=[dict(row=x["row"], side=x["side"], pairs=x["pairs"])
            for x in classes if x["pairs"]>26106])
    receipt = dict(status="Research-only exact source preparation; not installed or compiled",
        utc_started=start, utc_finished=datetime.datetime.now(datetime.timezone.utc).isoformat(),
        wrapper_sha256=sha(m.read_regular(SCRIPT)), converter_sha256=CONVERTER_SHA,
        materializer_sha256=MAT_SHA, requirements_sha256=REQ_SHA,
        input_file_count=138, input_bytes=sum(x["bytes"] for x in input_before.values()),
        all_138_input_sources_unchanged=True, input_materialization_manifest_unchanged=True,
        prospective_project_sources_unchanged=True,
        no_project_queue_compiler_git_actions=True, source_count=len(expected),
        source_bytes=manifest["total_source_bytes"], manifest_sha256=sha(manifest_bytes),
        output_dir=str(OUT), staged_rows=ROWS, diagnostic_rows=list(range(1,49)),
        per_row=per_row, class_pair_distribution=distribution, outputs=expected,
        saved_project_preimages=len(preimage_bytes), project_preimages=project_before)
    exclusive(EVIDENCE / "receipt.json", json_bytes(receipt))
    print(json.dumps(dict(status=receipt["status"], source_count=len(expected),
        source_bytes=receipt["source_bytes"], manifest_sha256=receipt["manifest_sha256"],
        receipt_sha256=sha(m.read_regular(EVIDENCE / "receipt.json")),
        distribution=distribution, per_row_summary=[dict(row=x["row"],
            source_bytes=x["source_bytes"], vertices=[c["vertices"] for c in x["classes"]],
            pairs=[c["pairs"] for c in x["classes"]],
            floor_tags=[c.get("floor_tags", 0) for c in x["classes"]]) for x in per_row]), indent=2), flush=True)

if __name__ == "__main__":
    main()
