"""Prepare cp14 helper/archive artifacts only after coordinator review.
No checkpoint snapshot, Git mutation, generator, compiler, or project write is performed.
"""
from pathlib import Path
import ast, base64, datetime, gzip, hashlib, importlib.util, json, os, subprocess, sys, zlib

ROOT = Path("/Users/tp/Lean/D1Bound5")
R = ROOT / "research/continuations/20261018T010800CEST-main-continuation"
HERE = Path(__file__).resolve().parent
HEAD = "de54cc736d61d9cbfc317218d1b805bdb085eb2f"
UTIL_SHA = "5f0ce687d3858ca91b90cf049797157bbb2f796f56f935e688d7ad36ade8f17b"
spec = importlib.util.spec_from_file_location("cp14_archive_tools", HERE / "checkpoint14_archives.py")
util_bytes = (HERE / "checkpoint14_archives.py").read_bytes()
if hashlib.sha256(util_bytes).hexdigest() != UTIL_SHA:
    raise RuntimeError("Archive utility pin mismatch")
u = importlib.util.module_from_spec(spec)
spec.loader.exec_module(u)
require, stable, sha, relative = u.require, u.stable, u.sha, u.relative
OUT = R / "checkpoint14-payloads"
WORK = R / ("checkpoint14-payloads-preparing-" + str(os.getpid()))
PACKET = R / "checkpoint14-helpers.json"
HELPER_MANIFEST = R / "helper14-manifest.json"

PINS = {
 "recovered-adaptive-chunks/prepare_adaptive_light_chunks.py":"7ddd49e70f8c85a0fe247ef5d7cf5ebd864ae526add106aca3b9dcc0adc72508",
 "recovered-adaptive-chunks/DESIGN.md":"0bfd15c76a1d90ac7373b76db94e6b7c4e8e885a1f7e588dc8c3cd073c2d1508",
 "prepare_light_remaining39.py":"cd9b6170de37492f9d25baad56cb84ecb141d3a1b9868b2730236ac66f38101b",
 "light-remaining39-preparation/receipt.json":"00bc79df9277e30f21403e41d8781414dc1e42ead465c464078ec736daf34db7",
 "adaptive-light45-preparation-receipt.json":"c0fe04f1cbcc6394b733333942b7c41d6a778a539b0747cb5b1ba62de9ae83a0",
 "adaptive-remaining38-40k-preparation.json":"6ea2adcdb53a92fc5233e1740b4045a18eb7a0625cc448518fa34c5148eb4263",
 "continuation_driver_capacity.py":"df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db",
 "continuation_driver_capacity_dummy_test.py":"78de23f378f799f262ec640fa52080a2a22fbcaed7cc9014e7cf54da413bf4c9",
 "continuation_driver_capacity_dummy_test_v2.py":"9564e55f8e666212d4da36b5bf762b1f26d96936a7c4f56c9517d9372e460e86",
 "continuation-driver-capacity-review.json":"37da14decf717b606738e40d95bb259068a1eab8e18f4d6424550fa72c24c2a7",
 "continuation-driver-capacity-review-v2.json":"bc7898ef1c8cdc8132437f9a3a5605738054e881a52ae0b8675677f447dee182",
 "continuation-driver-capacity-python312-review.json":"82bd73c602c8687a7ee18ef13cf7f882a38008edb693b877952a7aba2be95216",
 "driver-capacity-restart-receipt.json":"38f537797315d22a4cd21c8ac09f00b1961dd5a04751ae03c295dbc039f36182",
 "recovered-pell-matching-light/PellLightMatching.lean":"3ac624524aca77968a148009c6a760dcc5c6aecfa02aa6a1652c7bf7443543c6",
 "recovered-pell-matching-light/PellLightMatchingBridge.lean":"71e9b8c569c150ce9305062ad39992119e2557e51708f11f0f3339fe47def76e",
 "recovered-pell-matching-pilot/prepare_pell_light_matching_pilot.py":"0cf59ebda722f7a749b4619f267ff535bb81761cdc284584adc3655ccecfe393",
}
SCOPES = [
 ("remaining39", "prepared-light-remaining39",
  "0091cf518b0bdac90510d96a318241dc5b170065e4787fba789385492a3f1f62", "results", 429),
 ("adaptive45", "prepared-adaptive-light45",
  "b5205f4adcc36e748acda7c783a7ac274735a7b323cce2713ed035121802f02f", "files", 10),
 ("adaptive38", "prepared-adaptive-remaining38-40k",
  "3cfaff9aeff48634d1b4ea1ca9ceeb5b9f89a55d98c10fa92c80d0b3076d350f", "files", 366),
 ("matching7", "recovered-pell-matching-pilot/pilot", "3af8f4e64ba8b38ae728e6a8a4d6064279f77eb9dfee225578847a7fcfe07138", "emitted", 2),
]

def git(*args):
    return subprocess.run(["git", *args], cwd=ROOT, check=True, capture_output=True).stdout

def checked(name, digest=None):
    b = stable(R / relative(name))
    require(digest is None or sha(b) == digest, "Pinned helper changed: " + name)
    return b

def selected_files(obj, kind):
    if kind == "results":
        out = {}
        for row in obj["results"]:
            for name, pin in row.get("files", {}).items():
                require(name not in out, "Duplicate prepared path")
                out[name] = pin
        return out
    if kind == "files":
        return obj["files"]
    return {name: obj["outputs"][name] for name in obj["emitted_source_names"]}

def main():
    require(sys.flags.optimize == 0 and sys.flags.dont_write_bytecode, "Use Python -B without optimization")
    require(git("rev-parse", "HEAD").decode().strip() == HEAD, "HEAD changed")
    require(not git("diff", "--name-only") and not git("diff", "--cached", "--name-only"), "Tracked/index changes")
    for p in [OUT, WORK, PACKET, HELPER_MANIFEST]:
        require(not os.path.lexists(p), "Existing output: " + str(p))
        require(all(not x.is_symlink() for x in [p, *p.parents]), "Symlink output path")
    pins_bytes = {name: checked(name, digest) for name, digest in PINS.items()}
    # Preserve failures, not merely the eventual passing report.
    require(json.loads(pins_bytes["continuation-driver-capacity-review.json"])["passed"] is False,
            "Historical capacity failure missing")
    require(json.loads(pins_bytes["continuation-driver-capacity-review-v2.json"])["passed"] is True,
            "Capacity v2 evidence missing")
    source_files, scopes = {}, []
    archive_manifest_hashes = {}
    for label, directory, digest, kind, count in SCOPES:
        raw = checked(directory + "/manifest.json", digest)
        obj = json.loads(raw)
        files = selected_files(obj, kind)
        require(len(files) == count, "Prepared source count: " + label)
        actual = {str(p.relative_to(R / directory)) for p in (R / directory).rglob("*.lean")}
        require(actual == set(files), "Unexpected/missing prepared Lean: " + label)
        for name, pin in files.items():
            relative(name)
            require(Path(name).parent == Path("D1Bound5") and name.endswith(".lean"), "Unexpected source path")
            path = R / directory / name
            b = stable(path)
            require(len(b) == pin["bytes"] and sha(b) == pin["sha256"], "Prepared source mismatch")
            source_files[label + "/" + name] = dict(source=path, bytes=len(b), sha256=sha(b))
        member = label + "/manifest.json"
        source_files[member] = dict(source=R / directory / "manifest.json", bytes=len(raw), sha256=digest)
        archive_manifest_hashes[digest] = member
        scopes.append(dict(name=label, original_directory=directory, manifest_member=member,
            manifest_sha256=digest, source_count=count,
            source_bytes=sum(x["bytes"] for x in files.values()), status="Unaccepted research source backup"))

    candidates = {
        "prepare_light_remaining39.py",
        "continuation_driver_capacity.py", "continuation_driver_capacity_dummy_test.py",
        "continuation_driver_capacity_dummy_test_v2.py",
    }
    for dirname in ["recovered-adaptive-chunks", "recovered-pell-matching-light",
                    "recovered-pell-matching-pilot", "recovered-pell-matching-light/repair01",
                    "light-remaining39-preparation",
                    "recovered-checkpoint14-tooling"]:
        for p in (R / dirname).iterdir():
            if p.is_file():
                if dirname == "recovered-checkpoint14-tooling" and p.name in {
                        "prepare_checkpoint14.py", "stage_checkpoint14.py"}:
                    continue  # These exact scripts are required runtime snapshot files.
                require(p.suffix in {".py", ".lean", ".json", ".md", ".tsv", ".log", ".diff"},
                        "Unexpected helper extension")
                candidates.add(str(p.relative_to(R)))
    # Runtime top-level JSON is captured by prepare_checkpoint14, not duplicated in this packet.
    helper_bytes = {name: checked(name) for name in sorted(candidates)}
    require(all(len(b) < 2_000_000 for b in helper_bytes.values()), "Oversized individual text helper")
    require(sum(map(len, helper_bytes.values())) < 10_000_000, "Text helper packet unexpectedly large")
    for name, b in helper_bytes.items():
        require(not u.SECRET.search(b), "Credential-like helper")
        b.decode("utf-8")
        if name.endswith(".py"): ast.parse(b)
        if name.endswith(".json"): json.loads(b)

    tracked = {x.decode() for x in git("ls-files", "-z").split(b"\0") if x}
    known = {}
    for path in sorted(R.glob("checkpoint-*/MANIFEST.json")):
        rel = str(path.relative_to(ROOT))
        if rel not in tracked: continue
        old = json.loads(stable(path))
        for row in old.get("files", []):
            if row["path"] in tracked:
                known.setdefault((row["sha256"], row["bytes"]), []).append(row["path"])
    # Exact unchanged helper bytes reuse a previously tracked path; archive manifest aliases
    # reuse their extracted member. Everything else is small UTF-8 packet content.
    packet_helpers, records = {}, []
    for name, b in sorted(helper_bytes.items()):
        record = dict(path=name, bytes=len(b), sha256=sha(b))
        reused = None
        for prior in sorted(known.get((sha(b), len(b)), [])):
            if stable(ROOT / relative(prior)) == b:
                reused = prior
                break
        if reused:
            record["stored_at"] = reused
        elif sha(b) in archive_manifest_hashes:
            record["archive_member"] = archive_manifest_hashes[sha(b)]
        else:
            packet_helpers[name] = b.decode("utf-8")
            record["packet_member"] = name
        records.append(record)
    payload = json.dumps(packet_helpers, sort_keys=True, ensure_ascii=False, separators=(",", ":")).encode()
    packet = (json.dumps(dict(encoding="gzip-base64", data=base64.b64encode(
        gzip.compress(payload, compresslevel=9, mtime=0)).decode()), separators=(",", ":")) + "\n").encode()
    require(len(packet) < 10_000_000, "Oversized helper packet")
    decoded = json.loads(gzip.decompress(base64.b64decode(json.loads(packet)["data"], validate=True)))
    require(decoded == packet_helpers, "Helper packet round trip mismatch")

    # No source mutation: only a fresh research archive directory is created below.
    index = u.build_set(WORK, source_files, scopes)
    for name, b in helper_bytes.items():
        require(checked(name) == b, "Helper changed during archive preparation")
    for name, b in pins_bytes.items():
        require(checked(name) == b, "Pinned evidence changed during archive preparation")
    require(git("rev-parse", "HEAD").decode().strip() == HEAD, "HEAD changed during preparation")
    require(not git("diff", "--name-only") and not git("diff", "--cached", "--name-only"), "Tracked/index changed")
    require(not os.path.lexists(OUT), "Archive destination appeared")
    WORK.rename(OUT)
    verified = u.verify_set(OUT)
    require(index == verified, "Published archive verification mismatch")
    u.write_new(PACKET, packet)
    manifest = dict(format="checkpoint14-helper-manifest-v1",
        scope="Private unaccepted research backup; no Lean/compiler/installation action",
        utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
        expected_head=HEAD, utility_sha256=UTIL_SHA,
        builder_sha256=sha(stable(Path(__file__))), python=sys.version.split()[0],
        zlib_runtime=zlib.ZLIB_RUNTIME_VERSION,
        packet_file=PACKET.name, packet_sha256=sha(packet), packet_bytes=len(packet),
        packet_members=len(packet_helpers), all_helper_count=len(records),
        archive_directory=OUT.name, archive_index_sha256=sha(stable(OUT / "ARCHIVE_INDEX.json")),
        archive_count=len(index["shards"]), archive_member_count=len(index["members"]),
        every_blob_below_100MB=True, every_extracted_member_hash_verified=True,
        helper_files=records, required_evidence_pins=PINS,
        main_statement_proved=False)
    u.write_new(HELPER_MANIFEST, u.json_bytes(manifest))
    print(json.dumps(dict(helper_manifest_sha256=sha(stable(HELPER_MANIFEST)),
        archive_count=len(index["shards"]), archive_members=len(index["members"]),
        archive_bytes=sum(x["bytes"] for x in index["shards"]),
        packet_bytes=len(packet), packet_members=len(packet_helpers),
        reused_helpers=sum("stored_at" in x for x in records)), indent=2))

if __name__ == "__main__":
    main()
