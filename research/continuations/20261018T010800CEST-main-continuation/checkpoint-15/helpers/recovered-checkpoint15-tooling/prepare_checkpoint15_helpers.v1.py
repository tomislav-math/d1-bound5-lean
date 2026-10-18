"""Create only cp15's small research helper packet; reuse committed archives.
No archive creation/copy, generator, compiler, checkpoint snapshot or Git mutation.
"""
from pathlib import Path
import ast, base64, datetime, gzip, hashlib, importlib.util, json, os, subprocess, sys

ROOT = Path("/Users/tp/Lean/D1Bound5")
R = ROOT / "research/continuations/20261018T010800CEST-main-continuation"
HEAD = "323ce078b4626ba5165aef17364ac1755e29daf8"
UTILITY = R / "checkpoint-14/helpers/recovered-checkpoint14-tooling/checkpoint14_archives.py"
UTILITY_SHA = "5f0ce687d3858ca91b90cf049797157bbb2f796f56f935e688d7ad36ade8f17b"
INDEX = R / "checkpoint-14/archives/ARCHIVE_INDEX.json"
INDEX_SHA = "a357b1195d445246087b16882710b5c771536e39a07f0c84069eca47c4df8d4c"
if hashlib.sha256(UTILITY.read_bytes()).hexdigest() != UTILITY_SHA:
    raise RuntimeError("Committed read utility pin mismatch")
spec = importlib.util.spec_from_file_location("cp15_committed_read_tools", UTILITY)
u = importlib.util.module_from_spec(spec)
spec.loader.exec_module(u)
require, stable, sha, relative = u.require, u.stable, u.sha, u.relative
OPTIONAL_MERGE_PINS = {
 "row-merge38-preparation/prepare_remaining_row_merges.py":"1fbfd387d02d3399137e8e7af3d539dab0bcd5d026b1509c70a82b2c2b6fb1bf",
 "row-merge38-preparation/dry/dry-manifest.json":"97822768254678a3080495490f1409ed81a0b7b9c925612eefe2b35b2de0d330",
}  # Article_audit independently reviewed source and all38 dry outputs; no execution here.
PINS = {
 "recovered-pell-matching-production/prepare_pell_light_matching_production.py":"d045b82f28d953175e0ec4dacd0646da2db17da38d494e5be775a82e9ff46198",
 "recovered-pell-matching-production/source_review.json":"d25bb6a60b36a65f5eb68c2848a2299ffc4e120bb46369e6b624fcad18fd500a",
 "recovered-pell-matching-production/proposed_import_closure.json":"390469556a94c219ec91a4b71c214f40d2703d25b37a6c62a6fb585b75990164",
 "recovered-pell-matching-production/dry/manifest.json":"1ec6fa9846bb82e00685b9dffaf39999457282e621d57b66fbc5e5688e4419f3",
 "recovered-pell-matching-production/production/manifest.json":"1ec6fa9846bb82e00685b9dffaf39999457282e621d57b66fbc5e5688e4419f3",
 "recovered-pell-matching-production/production/emission_receipt.json":"6609283b7712af36f4c2065a88e3ac10afc40388a57aa55571e333ea8cc0c260",
 "row-merge45-preparation/prepare_row_merge.py":"93e03376a48b47580239744508aa6bfa2e941dbdfa4de499e8daa3d4272f0335",
 "row-merge45-preparation/row45-pins.json":"ec9703caec9ba78f8ba9fa6d88909d039ec5e44e3c50957e1f3dc736e2349548",
 "row-merge45-preparation/readiness-report.json":"c58a386125e067cb5e65c9242d690a8d0074b27acb29e73b9b3b4eb8757e2c56",
 "row-merge45-preparation/candidate/manifest.json":"8305d01079e79c122f26ac2869caf4608e59194b03519f12426dba5d37a90408",
}

def git(*args):
    return subprocess.run(["git", *args], cwd=ROOT, check=True, capture_output=True).stdout

def main():
    require(sys.flags.optimize == 0 and sys.flags.dont_write_bytecode, "Use Python -B without optimization")
    require(git("rev-parse", "HEAD").decode().strip() == HEAD, "HEAD changed")
    require(not git("diff", "--name-only") and not git("diff", "--cached", "--name-only"), "Tracked/index changes")
    packet_path, manifest_path = R / "checkpoint15-helpers.json", R / "helper15-manifest.json"
    for p in [packet_path, manifest_path]:
        require(not os.path.lexists(p) and all(not q.is_symlink() for q in [p, *p.parents]), "Existing/unsafe output")
    tracked = {x.decode() for x in git("ls-files", "-z").split(b"\0") if x}
    require(str(UTILITY.relative_to(ROOT)) in tracked, "Utility is not committed")
    index_bytes = stable(INDEX)
    require(sha(index_bytes) == INDEX_SHA, "Committed archive index changed")
    index = json.loads(index_bytes)
    archive_refs = []
    for path, digest, size in [(INDEX, INDEX_SHA, len(index_bytes))] + [
        (INDEX.parent / relative(x["path"]), x["sha256"], x["bytes"]) for x in index["shards"]]:
        name = str(path.relative_to(ROOT))
        require(path.parent == INDEX.parent and name in tracked, "Archive reference is not committed")
        b = stable(path)
        require(sha(b) == digest and len(b) == size and len(b) < 100_000_000, "Committed archive blob changed")
        archive_refs.append(dict(path=name, sha256=digest, bytes=size))
    require(len(archive_refs) == 5 and len(index["members"]) == 811, "Unexpected cp14 archive set")

    candidates = set(PINS)
    optional_directories = []
    # Only the two exact reviewed merge38 source/dry artifacts enter the optional scope.
    for name, digest in OPTIONAL_MERGE_PINS.items():
        relative(name)
        require(name.startswith("row-merge38-preparation/"), "Unexpected optional merge scope")
        b = stable(R / name)
        require(sha(b) == digest, "Optional reviewed merge source changed")
        candidates.add(name)
        optional_directories.append(str(Path(name).parent))
    here = Path(__file__).resolve().parent
    for p in here.iterdir():
        if p.is_file() and p.name not in {"prepare_checkpoint15.py", "stage_checkpoint15.py"}:
            require(p.suffix in {".py", ".json", ".md", ".diff"}, "Unexpected tooling file")
            candidates.add(str(p.relative_to(R)))
    contents = {}
    for name in sorted(candidates):
        b = stable(R / relative(name))
        require(name not in (PINS | OPTIONAL_MERGE_PINS) or sha(b) == (PINS | OPTIONAL_MERGE_PINS)[name], "Pinned provenance changed: " + name)
        require(len(b) < 2_000_000 and not u.SECRET.search(b), "Oversized/credential-like helper")
        b.decode("utf-8")
        if name.endswith(".py"): ast.parse(b)
        if name.endswith(".json"): json.loads(b)
        contents[name] = b
    require(sum(map(len, contents.values())) < 10_000_000, "Helper scope unexpectedly large")
    production = json.loads(contents["recovered-pell-matching-production/production/manifest.json"])
    require(production["generator_sha256"] == PINS["recovered-pell-matching-production/prepare_pell_light_matching_production.py"],
            "Production generator provenance mismatch")
    require(contents["recovered-pell-matching-production/dry/manifest.json"] ==
            contents["recovered-pell-matching-production/production/manifest.json"], "Dry/emit manifest mismatch")
    require(len(production["outputs"]) == 74, "Production output count")
    production_pins = {}
    for name, pin in production["outputs"].items():
        path = R / "recovered-pell-matching-production/production" / relative(name)
        b = stable(path)
        require(len(b) == pin["bytes"] and sha(b) == pin["sha256"], "Production source changed")
        production_pins[name] = dict(bytes=len(b), sha256=sha(b))
    intake112 = json.loads(stable(R / "wave112-intake.json"))
    receipt112 = json.loads(stable(R / "wave112-receipt.json"))["source_sha256"]
    require(set(intake112) == set(receipt112) == {Path(n).name for n in production_pins},
            "Production intake112 coverage differs")
    for name, pin in production_pins.items():
        basename = Path(name).name
        require(sha(intake112[basename].encode()) == receipt112[basename] == pin["sha256"],
                "Production intake112 bytes differ")
    # Original source bodies/preimages are retained in this exact merge manifest.
    merge = json.loads(contents["row-merge45-preparation/candidate/manifest.json"])
    require(merge["row"] == 45 and len(merge["originals"]) == 8 and merge["exported_name_count"] == 28,
            "Merge45 provenance coverage")
    candidate = stable(R / "row-merge45-preparation/candidate/SmallPairGraphData45.lean")
    require(len(candidate) == merge["candidate_bytes"] and sha(candidate) == merge["candidate_sha256"],
            "Merge45 candidate changed")
    intake111 = json.loads(stable(R / "wave111-intake.json"))
    receipt111 = json.loads(stable(R / "wave111-receipt.json"))["source_sha256"]
    require(sha(intake111["SmallPairGraphData45.lean"].encode()) ==
            receipt111["SmallPairGraphData45.lean"] == sha(candidate), "Merge45 intake111 differs")

    known = {}
    for path in sorted(R.glob("checkpoint-*/MANIFEST.json")):
        if str(path.relative_to(ROOT)) not in tracked: continue
        for row in json.loads(stable(path)).get("files", []):
            if row["path"] in tracked:
                known.setdefault((row["sha256"], row["bytes"]), []).append(row["path"])
    packet_helpers, records, canonical = {}, [], {}
    for name, b in sorted(contents.items()):
        key = (sha(b), len(b))
        record = dict(path=name, sha256=key[0], bytes=key[1])
        old = next((p for p in sorted(known.get(key, [])) if stable(ROOT / relative(p)) == b), None)
        if old:
            record["stored_at"] = old
        elif key in canonical:
            record["packet_member"] = canonical[key]
        else:
            canonical[key] = name
            packet_helpers[name] = b.decode("utf-8")
            record["packet_member"] = name
        records.append(record)
    payload = json.dumps(packet_helpers, sort_keys=True, ensure_ascii=False, separators=(",", ":")).encode()
    packet = (json.dumps(dict(encoding="gzip-base64", data=base64.b64encode(
        gzip.compress(payload, compresslevel=9, mtime=0)).decode()), separators=(",", ":")) + "\n").encode()
    require(len(packet) < 10_000_000, "Oversized packet")
    require(json.loads(gzip.decompress(base64.b64decode(json.loads(packet)["data"], validate=True))) ==
            packet_helpers, "Helper roundtrip mismatch")
    for name, b in contents.items():
        require(stable(R / relative(name)) == b, "Helper changed during packing")
    for row in archive_refs:
        require(sha(stable(ROOT / relative(row["path"]))) == row["sha256"], "Archive reference changed")
    require(git("rev-parse", "HEAD").decode().strip() == HEAD and
            not git("diff", "--name-only") and not git("diff", "--cached", "--name-only"), "HEAD/index changed")
    u.write_new(packet_path, packet)
    meta = dict(format="checkpoint15-helper-manifest-v1", expected_head=HEAD,
        scope="Small private research provenance packet; MainStatement unproved",
        utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
        packet_file=packet_path.name, packet_sha256=sha(packet), packet_bytes=len(packet),
        helper_files=records, packet_members=len(packet_helpers), helper_count=len(records),
        archived_sources_reused_without_copy=True, archive_references=archive_refs,
        archive_index_sha256=INDEX_SHA, archive_member_count=811,
        production_sources_recorded_but_not_duplicated=production_pins,
        production_sources_storage="Exact paired intake112 and current checkpoint SOURCE_MAP; no source installation here",
        merge45_candidate_sha256=sha(candidate),
        optional_future_merge_directories=optional_directories, evidence_pins=PINS,
        optional_merge_evidence_pins=OPTIONAL_MERGE_PINS,
        main_statement_proved=False, builder_sha256=sha(stable(Path(__file__))))
    u.write_new(manifest_path, u.json_bytes(meta))
    print(json.dumps(dict(packet_sha256=sha(packet), packet_bytes=len(packet),
        manifest_sha256=sha(stable(manifest_path)), helpers=len(records),
        packet_members=len(packet_helpers), archive_bytes_copied=0), indent=2))

if __name__ == "__main__":
    main()
