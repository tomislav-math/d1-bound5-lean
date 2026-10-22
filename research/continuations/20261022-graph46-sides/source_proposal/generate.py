"""Prepare exact graph46 side partitions locally; never run Lean or change a project.

The source manifest supplies six absolute source paths and their expected SHA256s.
The independently collected graph46 inspection is pinned before reading sources.
The two wrappers are copied only to originals and remain byte-for-byte unchanged.
All output is restricted to a subdirectory of this generator's own directory.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re


BASE = Path(__file__).resolve().parent
STATUS = "PREPARED_NOT_BUILT"
INSPECTION_SHA256 = "f2d3955f2af8d40917f33e1697a825c786fb8a8f2a2f09720628f5a0cc0b2b54"
SIDES = ("left", "right")
PARTITIONS = {
    "left": {"000": (16, 20, 22, 24, 26, 29), "001": (34, 42, 56, 91)},
    "right": {"000": (16, 20, 22, 24, 26, 30), "001": (34, 42, 56, 88)},
}
BLOCK_STARTS = {"left": {"000": 0, "001": 137}, "right": {"000": 0, "001": 138}}
BLOCK_COUNTS = {"left": {"000": 137, "001": 223}, "right": {"000": 138, "001": 220}}
VERTICES_PER_SIDE = {"left": 360, "right": 358}
NAMESPACE = "D1Bound5.PairLightAdaptivePrepared46"
DATA_IMPORT = "import D1Bound5.SmallPairLightAdaptiveData46\n"
JOIN_IMPORT = "import D1Bound5.PairLightArithmeticPrefixConcat\n"


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def json_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def parent_module(side: str, block: str) -> str:
    return f"SmallPairLightAdaptive{side.title()}46_{block}"


def wrapper_module(side: str) -> str:
    return f"SmallPairLight{side.title()}46"


def theorem_header(text: str, name: str) -> str:
    matches = list(re.finditer(r"^theorem " + re.escape(name) + r"\s*:", text, re.M))
    assert len(matches) == 1, name
    start = matches[0].start()
    return text[start:text.index(":=", start)]


def all_headers(text: str) -> list[str]:
    return [text[m.start():text.index(":=", m.start())]
            for m in re.finditer(r"^(?:def|theorem|lemma|abbrev|structure) ", text, re.M)]


def source_evidence(manifest: dict) -> dict:
    path = Path(manifest["source_inspection_path"])
    assert path.is_absolute() and path.is_file() and not path.is_symlink()
    raw = path.read_bytes()
    assert digest(raw) == manifest["source_inspection_sha256"] == INSPECTION_SHA256
    observed = json.loads(raw)
    assert observed["schema"] == 1 and observed["graph"] == 46
    assert observed["status"] == "READ_ONLY_SOURCE_INSPECTION_COMPLETE"
    assert observed["read_only"] and observed["source_snapshot_stable"]
    assert not observed["errors"] and not observed["required_sources_missing"]
    assert observed["original_archive_matches"]["all_matches"]
    assert not observed["acceptance_claimed"] and not observed["lean_compiled"]
    for scalar in ("A", "B"):
        assert {key: observed["model"][scalar][key] for key in ("tau", "nu")} == {"tau": 1, "nu": 6}
    light = observed["sources"]["SmallPairLightData46"]
    assert light["literals"]["sieve"]["rows"] == 25
    original_headers = {}
    for side in SIDES:
        assert all(value is True for key, value in observed["side_consistency"][side].items()
                   if key != "list_counts")
        assert observed["side_consistency"][side]["list_counts"] == [VERTICES_PER_SIDE[side]] * 3
        for kind in ("Vertices", "Cached", "Rows"):
            assert light["literals"][side + kind]["rows"] == VERTICES_PER_SIDE[side]
        assert light["literals"][side + "Cached"]["signature_lengths"] == [25]
        for block in PARTITIONS[side]:
            name = parent_module(side, block)
            actual = [item for item in observed["adaptive_blocks"]["blocks"] if item["module"] == name]
            assert len(actual) == 1
            actual = actual[0]
            assert (actual["tau"], actual["nu"]) == (1, 6)
            assert actual["head_count"] == BLOCK_COUNTS[side][block]
            assert actual["global_start"] == BLOCK_STARTS[side][block]
            assert actual["global_end_exclusive"] == BLOCK_STARTS[side][block] + BLOCK_COUNTS[side][block]
            assert actual["cached_definition"] == side + "Cached" + block
            assert actual["rows_definition"] == side + "Rows" + block
            original_headers[name] = actual["original_public_header"]
    assert len(observed["adaptive_blocks"]["blocks"]) == 4
    for name, item in manifest["sources"].items():
        record = observed["sources"][name]
        assert record["exists"] and record["full_text"] is not None
        assert item["sha256"] == record["sha256"]
        assert item["bytes"] == record["bytes"]
        assert item["observed_remote_path"] == record["path"]
        assert not record["forbidden_tokens"]
        exact = record["full_text"].encode()
        assert len(exact) == record["bytes"] and digest(exact) == record["sha256"]
    return {
        "schema": 1, "status": "OBSERVED_SOURCE_METADATA_NOT_PROOF_ACCEPTANCE", "graph": 46,
        "source_inspection_path": str(path), "source_inspection_sha256": INSPECTION_SHA256,
        "source_snapshot_stable_at_inspection": True,
        "original_light_data": {key: light[key] for key in ("path", "sha256", "bytes", "imports", "literals")},
        "original_foundation_source_sha256": {
            name: observed["sources"][name]["sha256"]
            for name in ("SmallPairLightData46", "SmallPairLightAdaptiveData46", "SmallPairLightAdaptiveValidation46")},
        "original_side_source_sha256": {name: item["sha256"] for name, item in manifest["sources"].items()},
        "model": observed["model"], "adaptive_blocks": observed["adaptive_blocks"],
        "original_public_parent_headers": original_headers,
        "side_consistency": observed["side_consistency"],
        "foundation_completion_verified": False, "lean_compiled": False,
        "kernel_replayed": False, "acceptance_claimed": False,
    }


def part_records(side: str, block: str) -> list[dict]:
    records = []
    offset = 0
    for number, count in enumerate(PARTITIONS[side][block]):
        first = BLOCK_STARTS[side][block] + offset
        tail_length = VERTICES_PER_SIDE[side] - first
        records.append({
            "module": parent_module(side, block) + f"Part{number:02d}",
            "theorem": f"{side}_prefix_{block}_part{number:02d}_checked",
            "part": number,
            "local_drop": offset,
            "head_count": count,
            "original_first_head": first,
            "original_last_head": first + count - 1,
            "complete_tail_vertex_count": tail_length,
            "covered_unordered_pairs": count * (2 * tail_length - count - 1) // 2,
        })
        offset += count
    assert offset == BLOCK_COUNTS[side][block]
    assert [j for item in records for j in range(item["local_drop"],
                                                item["local_drop"] + item["head_count"])] == list(range(offset))
    return records


def helper_source(side: str, block: str, item: dict) -> str:
    first, last = item["original_first_head"], item["original_last_head"]
    offset, count = item["local_drop"], item["head_count"]
    return f"""{DATA_IMPORT}
namespace {NAMESPACE}
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads {first} through {last}, each compared with its entire remaining tail. -/
theorem {item['theorem']} :
    pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve {count}
      ({side}Cached{block}.drop {offset}) ({side}Rows{block}.drop {offset}) = true := by
  decide +kernel

end {NAMESPACE}
"""


def joined_parent(original: str, side: str, block: str, parts: list[dict]) -> str:
    name = f"{side}_prefix_{block}_checked"
    old_header = theorem_header(original, name)
    expected = (f"theorem {name} : pairLightSelectedFloorPrefixBool 1 6 "
                f"PairLightPrepared46.sieve {BLOCK_COUNTS[side][block]} "
                f"{side}Cached{block} {side}Rows{block} = true")
    assert " ".join(old_header.split()) == expected
    assert original.startswith(DATA_IMPORT)
    assert all_headers(original) == [old_header]
    body_start = original.index(":= by\n", original.index(old_header)) + len(":= by\n")
    old_body = "  decide +kernel\n"
    assert original[body_start:body_start + len(old_body)] == old_body
    suffix = original[body_start + len(old_body):]
    assert suffix == f"\nend {NAMESPACE}\n"

    last = parts[-1]
    last_offset, last_count = last["local_drop"], last["head_count"]
    proof = (f"  have h{last_offset:03d} : pairLightSelectedFloorPrefixBool 1 6 "
             f"PairLightPrepared46.sieve {last_count}\n"
             f"      ({side}Cached{block}.drop {last_offset}) "
             f"({side}Rows{block}.drop {last_offset}) = true := {last['theorem']}\n")
    for item in reversed(parts[:-1]):
        offset, count = item["local_drop"], item["head_count"]
        next_offset = offset + count
        remainder = BLOCK_COUNTS[side][block] - next_offset
        total = count + remainder
        proof += (f"  have h{offset:03d} : pairLightSelectedFloorPrefixBool 1 6 "
                  f"PairLightPrepared46.sieve {total}\n"
                  f"      ({side}Cached{block}.drop {offset}) "
                  f"({side}Rows{block}.drop {offset}) = true := by\n"
                  f"    apply pairLightSelectedFloorPrefixBool_of_add 1 6 "
                  f"PairLightPrepared46.sieve {count} {remainder}\n"
                  f"      ({side}Cached{block}.drop {offset}) ({side}Rows{block}.drop {offset})\n"
                  f"    · exact {item['theorem']}\n"
                  f"    · simpa only [List.drop_drop, Nat.reduceAdd] using h{next_offset:03d}\n")
    proof += "  simpa only [List.drop_zero] using h000\n"
    extra_imports = JOIN_IMPORT + "".join("import D1Bound5." + p["module"] + "\n" for p in parts)
    result = original[:body_start] + proof + suffix
    result = result[:len(DATA_IMPORT)] + extra_imports + result[len(DATA_IMPORT):]
    assert theorem_header(result, name) == old_header
    assert all_headers(result) == all_headers(original)
    assert result.endswith(suffix)
    return result


def main() -> None:
    if not __debug__:
        raise RuntimeError("Do not disable checks")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sources", required=True, type=Path,
                        help="JSON containing the six exact original paths and SHA256s")
    parser.add_argument("--output", type=Path, default=Path("payload"))
    args = parser.parse_args()
    output = args.output if args.output.is_absolute() else BASE / args.output
    output = output.resolve()
    assert output != BASE and output.is_relative_to(BASE), "Output must remain in this proposal directory"
    manifest = json.loads(args.sources.read_text())
    assert manifest["schema"] == 1
    expected_names = {parent_module(side, block) for side in SIDES for block in PARTITIONS[side]}
    expected_names.update(wrapper_module(side) for side in SIDES)
    assert set(manifest["sources"]) == expected_names
    evidence = source_evidence(manifest)
    sources, source_records = {}, {}
    for name, item in sorted(manifest["sources"].items()):
        path = Path(item["path"])
        assert path.is_absolute() and path.name == name + ".lean"
        assert path.is_file() and not path.is_symlink()
        assert re.fullmatch(r"[0-9a-f]{64}", item["sha256"])
        data = path.read_bytes()
        assert digest(data) == item["sha256"], name
        assert len(data) == item["bytes"], name
        assert b"\r" not in data and data.endswith(b"\n"), name
        sources[name] = data
        source_records[name] = {"path": str(path), "sha256": digest(data), "bytes": len(data)}

    files = {Path("originals") / (name + ".lean"): data for name, data in sources.items()}
    candidates, parent_headers, wrappers = {}, {}, {}
    coverage, full_order, pilot_targets, remainder = {}, [], [], {}
    for side in SIDES:
        side_parts, side_order = [], []
        for block in PARTITIONS[side]:
            parts = part_records(side, block)
            side_parts.extend(parts)
            for part in parts:
                data = helper_source(side, block, part).encode()
                candidates[part["module"]] = data
                side_order.append(part["module"])
            parent = parent_module(side, block)
            original = sources[parent].decode()
            candidates[parent] = joined_parent(original, side, block, parts).encode()
            side_order.append(parent)
            parent_headers[parent] = theorem_header(original, f"{side}_prefix_{block}_checked")
            assert parent_headers[parent] == evidence["original_public_parent_headers"][parent]
        wrapper = wrapper_module(side)
        wrapper_text = sources[wrapper].decode()
        assert len(all_headers(wrapper_text)) == 4
        assert f"pairLightSelectedFloorIndependentBool 1 6 sieve {side}Cached {side}Rows" in wrapper_text
        assert f"pairLightSelectedFloorIndependentCertificateBool 1 6 sieve\n      {side}Vertices" in wrapper_text
        for count in BLOCK_COUNTS[side].values():
            assert f"pairLightSelectedFloorIndependentBool_of_prefix_drop 1 6 sieve {count}" in wrapper_text
        wrappers[wrapper] = {"source_sha256": digest(sources[wrapper]),
                             "original_snapshot": "originals/" + wrapper + ".lean",
                             "action": "KEEP_EXISTING_SOURCE_BYTE_IDENTICAL"}
        side_order.append(wrapper)
        full_order.extend(side_order)
        pilot = parent_module(side, "000") + "Part00"
        pilot_targets.append(pilot)
        remainder[side] = [name for name in side_order if name != pilot]
        covered_heads = [j for part in side_parts for j in range(
            part["original_first_head"], part["original_last_head"] + 1)]
        assert covered_heads == list(range(VERTICES_PER_SIDE[side]))
        total_pairs = sum(part["covered_unordered_pairs"] for part in side_parts)
        assert total_pairs == VERTICES_PER_SIDE[side] * (VERTICES_PER_SIDE[side] - 1) // 2
        coverage[side] = {"declared_vertex_count": VERTICES_PER_SIDE[side],
                          "parts": side_parts, "covered_head_count": len(covered_heads),
                          "covered_unordered_pairs": total_pairs,
                          "blocks": {block: {"original_start": BLOCK_STARTS[side][block],
                                             "head_count": BLOCK_COUNTS[side][block],
                                             "partition": list(PARTITIONS[side][block])}
                                     for block in PARTITIONS[side]}}
    assert len(candidates) == 24 and len(full_order) == 26 and len(set(full_order)) == 26
    assert len(pilot_targets) == 2 and all(len(v) == 12 for v in remainder.values())
    for name, data in candidates.items():
        text = data.decode()
        assert ".take " not in text
        assert not re.search(r"\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b", text)
        assert set(re.findall(r"(?:PairLight(?:Adaptive)?Prepared|SmallPairLightAdaptiveData)(\d+)\b", text)) == {"46"}
        files[Path("candidates") / (name + ".lean")] = data
    evidence_bytes = json_bytes(evidence)
    plan = {
        "schema": 1, "status": STATUS, "model": {"tau": 1, "nu": 6},
        "source_manifest_path": str(args.sources.resolve()),
        "source_manifest_sha256": digest(args.sources.read_bytes()),
        "generator_sha256": digest(Path(__file__).read_bytes()),
        "source_inspection_sha256": INSPECTION_SHA256,
        "source_evidence_sha256": digest(evidence_bytes),
        "original_sources": source_records, "original_parent_headers": parent_headers,
        "candidate_module_sha256": {name: digest(data) for name, data in sorted(candidates.items())},
        "unchanged_wrappers": wrappers, "pilot_targets": pilot_targets,
        "nominal_remainder_targets": remainder, "nominal_full_build_order": full_order,
        "remainder_status": "DEFERRED_UNTIL_ACTUAL_PILOT_BUILD_AND_REPLAY_MEASUREMENTS",
        "pilot_gate": {
            "head_count_each_side": 16,
            "required_before_any_remainder": [
                "Actual completed graph46 foundation evidence and current source/artifact binding",
                "Actual separate left and right graph46 pilot build and kernel replay PASS",
                "Review graph46 pilot durations and remaining budget under the inherited 240-second cap"],
            "inherited_target_cap_seconds": 240, "cap_enforced_by_this_generator": False,
            "model_and_right_witness_size_require_actual_measurements": True,
            "runtime_prediction_made": False},
        "future_foundation_binding_status": "UNBOUND_REQUIRES_ACTUAL_COMPLETED_FOUNDATION",
        "foundation_commit": None,
        "original_data_modified": False, "full_tails_preserved": True,
        "lean_compiled": False, "kernel_replayed": False,
        "root_integration": False, "main_theorem_complete": False,
    }
    partition_record = {
        "schema": 1, "status": STATUS, "sides": coverage,
        "integer_partition_arithmetic_checked": True,
        "lean_certificate_truth_checked": False,
        "vertex_counts_source": "Observed graph46 literal counts: left 360, right 358; original parent blocks left 137+223, right 138+220",
        "data_lengths_independently_proved_by_generator": False,
        "complete_cached_and_row_tails_preserved": True,
        "cross_part_and_cross_original_block_pairs_retained": True,
        "total_covered_unordered_pairs_both_sides": sum(side["covered_unordered_pairs"] for side in coverage.values()),
    }
    files[Path("PLAN.json")] = json_bytes(plan)
    files[Path("PARTITION_COVERAGE.json")] = json_bytes(partition_record)
    files[Path("SOURCE_EVIDENCE.json")] = evidence_bytes
    files[Path("PAYLOAD_SHA256.json")] = json_bytes({str(path): digest(data)
                                                    for path, data in sorted(files.items())})
    # Validate all conflicts before creating any output; never replace differing bytes.
    for rel, data in files.items():
        target = output / rel
        assert not target.is_symlink()
        if target.exists():
            assert target.is_file() and target.read_bytes() == data, target
    for rel, data in sorted(files.items()):
        target = output / rel
        target.parent.mkdir(parents=True, exist_ok=True)
        if not target.exists():
            with target.open("xb") as stream:
                stream.write(data)
    print(json.dumps({"status": STATUS, "output": str(output),
                      "candidate_modules": len(candidates), "unchanged_wrappers": len(wrappers),
                      "pilot_targets": pilot_targets, "lean_compiled": False}, sort_keys=True))


if __name__ == "__main__":
    main()
