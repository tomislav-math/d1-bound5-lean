"""Check the graph46 proposal locally without Lean, Git, network, or project writes.

The review reads the pinned observation and independently enumerates every
within-side unordered pair represented by the actual emitted helper headers.
Only the review JSON in this proposal directory may be created.
"""
from pathlib import Path
import hashlib
import json
import re


BASE = Path(__file__).resolve().parent
PAYLOAD = BASE / "payload"
OBSERVED_PATH = BASE.parent / "graph46_inspection/SOURCE_INSPECTION.json"
OBSERVED_SHA256 = "f2d3955f2af8d40917f33e1697a825c786fb8a8f2a2f09720628f5a0cc0b2b54"


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


def json_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def header(raw, name):
    pattern = rb"^theorem " + name.encode() + rb"\s*:"
    matches = list(re.finditer(pattern, raw, re.M))
    assert len(matches) == 1
    start = matches[0].start()
    return raw[start:raw.index(b":=", start)]


def create_exact(path, raw):
    assert path.parent == BASE and not path.is_symlink()
    if path.exists():
        assert path.is_file() and path.read_bytes() == raw
    else:
        with path.open("xb") as stream:
            stream.write(raw)


def main():
    if not __debug__:
        raise RuntimeError("Do not disable review assertions")
    observed_raw = OBSERVED_PATH.read_bytes()
    assert digest(observed_raw) == OBSERVED_SHA256
    observed = json.loads(observed_raw)
    plan = json.loads((PAYLOAD / "PLAN.json").read_bytes())
    coverage = json.loads((PAYLOAD / "PARTITION_COVERAGE.json").read_bytes())
    evidence_raw = (PAYLOAD / "SOURCE_EVIDENCE.json").read_bytes()
    assert digest(evidence_raw) == plan["source_evidence_sha256"]
    assert plan["source_inspection_sha256"] == OBSERVED_SHA256
    assert plan["generator_sha256"] == digest((BASE / "generate.py").read_bytes())
    assert plan["source_manifest_sha256"] == digest((BASE / "ORIGINAL_SOURCE_PATHS.json").read_bytes())
    assert plan["model"] == {"tau": 1, "nu": 6}
    assert plan["status"] == "PREPARED_NOT_BUILT"
    assert plan["remainder_status"] == "DEFERRED_UNTIL_ACTUAL_PILOT_BUILD_AND_REPLAY_MEASUREMENTS"
    manifest_raw = (PAYLOAD / "PAYLOAD_SHA256.json").read_bytes()
    manifest = json.loads(manifest_raw)
    found = {str(path.relative_to(PAYLOAD)) for path in PAYLOAD.rglob("*") if path.is_file()}
    assert found == set(manifest) | {"PAYLOAD_SHA256.json"}
    for relative, expected_hash in manifest.items():
        path = PAYLOAD / relative
        assert path.resolve().is_relative_to(PAYLOAD.resolve()) and not path.is_symlink()
        assert digest(path.read_bytes()) == expected_hash

    originals = {}
    for name, record in plan["original_sources"].items():
        local = (BASE / "inputs" / (name + ".lean")).read_bytes()
        snapshot = (PAYLOAD / "originals" / (name + ".lean")).read_bytes()
        actual = observed["sources"][name]["full_text"].encode()
        assert local == snapshot == actual
        assert digest(local) == record["sha256"] == observed["sources"][name]["sha256"]
        assert len(local) == record["bytes"] == observed["sources"][name]["bytes"]
        originals[name] = local
    assert len(originals) == 6

    candidate_paths = sorted((PAYLOAD / "candidates").glob("*.lean"))
    assert {path.stem for path in candidate_paths} == set(plan["candidate_module_sha256"])
    assert len(candidate_paths) == 24
    helper_pattern = re.compile(
        r"theorem (?P<theorem>\w+)\s*:\s*"
        r"pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46\.sieve (?P<count>\d+)\s*"
        r"\((?P<side>left|right)Cached(?P<block>\d{3})\.drop (?P<drop>\d+)\) "
        r"\((?P=side)Rows(?P=block)\.drop (?P=drop)\) = true := by\s*decide \+kernel")
    helpers, parent_header_hashes = {}, {}
    for path in candidate_paths:
        raw = path.read_bytes()
        text = raw.decode()
        assert digest(raw) == plan["candidate_module_sha256"][path.stem]
        assert len(re.findall(r"^theorem ", text, re.M)) == 1
        assert not re.search(r"^(?:def|abbrev|lemma|axiom|opaque) ", text, re.M)
        assert not re.search(r"\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b", text)
        assert ".take" not in text
        if "Part" in path.stem:
            matches = list(helper_pattern.finditer(text))
            assert len(matches) == 1
            match = matches[0]
            side, block = match["side"], match["block"]
            part_number = re.fullmatch(r"SmallPairLightAdaptive" + side.title() + r"46_" + block + r"Part(\d{2})", path.stem)
            assert part_number is not None
            assert match["theorem"] == f"{side}_prefix_{block}_part{part_number[1]}_checked"
            assert re.findall(r"^import (\S+)$", text, re.M) == ["D1Bound5.SmallPairLightAdaptiveData46"]
            assert text.count("decide +kernel") == 1
            helpers[path.stem] = {"side": side, "block": block, "drop": int(match["drop"]),
                                  "count": int(match["count"]), "theorem": match["theorem"]}
        else:
            block = next(item for item in observed["adaptive_blocks"]["blocks"] if item["module"] == path.stem)
            theorem = block["side"] + "_prefix_" + block["block"] + "_checked"
            original_header = header(originals[path.stem], theorem)
            assert header(raw, theorem) == original_header == block["original_public_header"].encode()
            assert original_header.decode() == plan["original_parent_headers"][path.stem]
            parent_header_hashes[path.stem] = digest(original_header)
            assert "decide +kernel" not in text
            assert "import D1Bound5.PairLightArithmeticPrefixConcat\n" in text
            assert text.endswith(b"\nend D1Bound5.PairLightAdaptivePrepared46\n".decode())
    assert len(helpers) == 20 and len(parent_header_hashes) == 4

    counts = {}
    for side in ("left", "right"):
        vertex_count = observed["sources"]["SmallPairLightData46"]["literals"][side + "Vertices"]["rows"]
        side_helpers = {name: item for name, item in helpers.items() if item["side"] == side}
        seen, heads, head_parts = set(), [], {}
        pair_counts = {}
        for block in (item for item in observed["adaptive_blocks"]["blocks"] if item["side"] == side):
            parts = sorted(((name, item) for name, item in side_helpers.items() if item["block"] == block["block"]),
                           key=lambda pair: pair[1]["drop"])
            next_drop = 0
            parent = (PAYLOAD / "candidates" / (block["module"] + ".lean")).read_text()
            helper_imports = re.findall(r"^import D1Bound5\.(\w+Part\d{2})$", parent, re.M)
            assert helper_imports == [name for name, item in parts]
            assert parent.count("apply pairLightSelectedFloorPrefixBool_of_add 1 6 ") == len(parts) - 1
            for name, item in parts:
                assert item["drop"] == next_drop and item["count"] > 0
                next_drop += item["count"]
                assert parent.count(item["theorem"]) == 1
                first = block["global_start"] + item["drop"]
                local_heads = list(range(first, first + item["count"]))
                assert local_heads[-1] < vertex_count
                heads.extend(local_heads)
                pairs = {(i, j) for i in local_heads for j in range(i + 1, vertex_count)}
                assert not seen.intersection(pairs)
                seen.update(pairs)
                head_parts.update({i: name for i in local_heads})
                pair_counts[name] = len(pairs)
                record = next(row for row in coverage["sides"][side]["parts"] if row["module"] == name)
                assert record["original_first_head"] == first
                assert record["original_last_head"] == local_heads[-1]
                assert record["complete_tail_vertex_count"] == vertex_count - first
                assert record["covered_unordered_pairs"] == len(pairs)
            assert next_drop == block["head_count"]
        assert heads == list(range(vertex_count))
        expected_pairs = {(i, j) for i in range(vertex_count) for j in range(i + 1, vertex_count)}
        assert seen == expected_pairs
        assert len(seen) == coverage["sides"][side]["covered_unordered_pairs"]
        boundary = next(item["global_start"] for item in observed["adaptive_blocks"]["blocks"]
                        if item["side"] == side and item["block"] == "001")
        counts[side] = {"heads": vertex_count, "parts": len(side_helpers), "unordered_pairs": len(seen),
                        "cross_original_block_pairs": sum(i < boundary <= j for i, j in seen),
                        "cross_helper_pairs": sum(head_parts[i] != head_parts[j] for i, j in seen),
                        "pair_counts_by_helper": pair_counts}
        wrapper = "SmallPairLight" + side.title() + "46"
        assert wrapper in plan["unchanged_wrappers"]
        assert not (PAYLOAD / "candidates" / (wrapper + ".lean")).exists()
        assert plan["unchanged_wrappers"][wrapper]["source_sha256"] == digest(originals[wrapper])
        assert len(re.findall(rb"^theorem ", originals[wrapper], re.M)) == 4
        pilot = "SmallPairLightAdaptive" + side.title() + "46_000Part00"
        assert pilot in plan["pilot_targets"] and helpers[pilot]["count"] == 16 and helpers[pilot]["drop"] == 0
        assert len(plan["nominal_remainder_targets"][side]) == 12
    assert len(plan["nominal_full_build_order"]) == len(set(plan["nominal_full_build_order"])) == 26
    assert set(plan["nominal_full_build_order"]) == set(plan["candidate_module_sha256"]) | set(plan["unchanged_wrappers"])
    assert sum(item["unordered_pairs"] for item in counts.values()) == 128523
    review = {
        "schema": 1, "status": "LOCAL_SOURCE_AND_EXACT_COVERAGE_REVIEW_PASS_NOT_LEAN_VERIFIED",
        "graph": 46, "model": {"tau": 1, "nu": 6}, "source_inspection_sha256": OBSERVED_SHA256,
        "generator_sha256": digest((BASE / "generate.py").read_bytes()),
        "reviewer_sha256": digest(Path(__file__).read_bytes()), "payload_sha256": digest(manifest_raw),
        "candidate_modules": 24, "helper_modules": 20, "original_parent_modules": 4,
        "unchanged_wrapper_modules": 2, "all_target_modules": 26, "theorems": 32, "definitions": 0,
        "original_sources_byte_exact": True, "original_public_parent_headers_byte_exact": True,
        "original_public_parent_header_sha256": parent_header_hashes, "wrappers_byte_exact": True,
        "unordered_pairs_enumerated_exactly_once": True, "cross_part_and_cross_parent_pairs_retained": True,
        "counts": counts, "total_unordered_pairs": 128523,
        "raw_literals_not_available_locally": True, "raw_literal_dimensions_taken_from_pinned_observation": True,
        "actual_completed_foundation_binding_required": True, "actual_graph46_pilot_review_required": True,
        "lean_compiled": False, "kernel_replayed": False, "acceptance_claimed": False,
        "root_integration": False, "main_theorem_complete": False,
    }
    create_exact(BASE / "LOCAL_SOURCE_REVIEW.json", json_bytes(review))
    print(json.dumps({key: review[key] for key in ("status", "payload_sha256", "all_target_modules", "theorems", "total_unordered_pairs")}, sort_keys=True))


if __name__ == "__main__":
    main()
