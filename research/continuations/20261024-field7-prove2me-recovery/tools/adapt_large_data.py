"""Split exactly four oversized literal-table exports without changing sources.

No API or ledger writes. The original manifest and artifacts remain immutable.
The resulting plan adds four source-derived definition units. A separate
coordinator owns the locked ledger migration and publication restart.
"""
from __future__ import annotations

import argparse
import ast
from collections import defaultdict
import copy
import hashlib
import heapq
import json
from pathlib import Path
import re


LIMIT = 1_048_576
CHUNK_TARGET = 650_000
PREFIX = "D1Bound5_SmallPair"
TARGETS = {family + side: PREFIX + family + "Data6" + side + "Rows_Definitions"
           for family in ("Light", "RawSelected") for side in ("Left", "Right")}


class AdaptationError(RuntimeError):
    pass


def digest(data):
    return hashlib.sha256(data).hexdigest()


def canonical(value):
    return json.dumps(value, sort_keys=True, ensure_ascii=False, separators=(",", ":")).encode()


def atomic_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_bytes(json.dumps(value, ensure_ascii=False, sort_keys=True, indent=2).encode() + b"\n")
    temporary.replace(path)


def table_info(source):
    """Read only the strict, literal Nat-table grammar of the four known files."""
    matches = list(re.finditer(r"noncomputable def (leftRows|rightRows)\s*:\s*List \((?:Nat|ℕ) × List (?:Nat|ℕ)\)\s*:=\s*", source))
    if len(matches) != 1:
        raise AdaptationError("Expected exactly one literal row-table declaration")
    match = matches[0]
    start = match.end()
    if source[start:start+1] != "[":
        raise AdaptationError("Row-table value is not a literal list")
    depth, end = 0, None
    for offset in range(start, len(source)):
        character = source[offset]
        if character == "[":
            depth += 1
        elif character == "]":
            depth -= 1
            if depth == 0:
                end = offset + 1
                break
    if end is None:
        raise AdaptationError("Unterminated literal row table")
    literal = source[start:end]
    if not literal.isascii() or re.search(r"[^0-9\s,\[\]()]", literal):
        raise AdaptationError("Unexpected expression in literal Nat table")
    expression = ast.parse(literal, mode="eval").body
    if not isinstance(expression, ast.List):
        raise AdaptationError("Expected an outer list")
    rows, values = [], []
    offsets = [0]
    for line in literal.splitlines(keepends=True):
        offsets.append(offsets[-1] + len(line))
    for element in expression.elts:
        if not (isinstance(element, ast.Tuple) and len(element.elts) == 2 and
                isinstance(element.elts[0], ast.Constant) and type(element.elts[0].value) is int and element.elts[0].value >= 0 and
                isinstance(element.elts[1], ast.List) and
                all(isinstance(item, ast.Constant) and type(item.value) is int and item.value >= 0 for item in element.elts[1].elts)):
            raise AdaptationError("Expected rows of type Nat × List Nat")
        if element.end_lineno is None or element.end_col_offset is None:
            raise AdaptationError("AST row has no exact source range")
        row = literal[offsets[element.lineno-1] + element.col_offset:
                      offsets[element.end_lineno-1] + element.end_col_offset]
        rows.append(row)
        values.append((element.elts[0].value, [item.value for item in element.elts[1].elts]))
    if not rows:
        raise AdaptationError("Unexpected empty oversized table")
    return {"start": start, "end": end, "literal": literal, "rows": rows,
            "values": values, "name": match.group(1),
            "normalized_sha256": digest(re.sub(r"\s+", "", literal).encode())}


def chunk_rows(rows, target=CHUNK_TARGET):
    chunks, current, size = [], [], 4
    for row in rows:
        required = len(row.encode()) + 4
        if required + 4 > target:
            raise AdaptationError("One atomic row exceeds the helper target size")
        if current and size + required > target:
            chunks.append(current)
            current, size = [], 4
        current.append(row)
        size += required
    if current:
        chunks.append(current)
    return chunks


def literal_rows(rows):
    return "[\n  " + ",\n  ".join(rows) + "\n]"


def topological_order(units):
    waiting, children = {}, defaultdict(list)
    for unit_id, unit in units.items():
        dependencies = set(unit.get("publication_dependencies", [])) | set(unit.get("proof_dependencies", []))
        if unit_id in dependencies or dependencies - set(units):
            raise AdaptationError("Invalid self or missing dependency after adaptation")
        waiting[unit_id] = len(dependencies)
        for dependency in dependencies:
            children[dependency].append(unit_id)
    ready = [unit_id for unit_id, count in waiting.items() if count == 0]
    heapq.heapify(ready)
    ordered = []
    while ready:
        unit_id = heapq.heappop(ready)
        ordered.append(unit_id)
        for child in children[unit_id]:
            waiting[child] -= 1
            if waiting[child] == 0:
                heapq.heappush(ready, child)
    if len(ordered) != len(units):
        raise AdaptationError("New data aliases would create a dependency cycle")
    return ordered


def patch_manifest(manifest, plan, base, *, limit=LIMIT, chunk_target=CHUNK_TARGET):
    """Prepare the narrow adaptation in memory; return new artifacts separately."""
    base = Path(base)
    old_nodes = {node["name"]: node for node in manifest["nodes"]}
    if len(old_nodes) != len(manifest["nodes"]):
        raise AdaptationError("Duplicate names in original manifest")
    missing = set(TARGETS.values()) - set(old_nodes)
    if missing:
        raise AdaptationError("Missing exact oversized targets: " + ", ".join(sorted(missing)))
    for name in TARGETS.values():
        node = old_nodes[name]
        if node["kind"] != "definition" or node.get("existing_binding"):
            raise AdaptationError("Cannot adapt an existing published identity: " + name)
        if len(node["payload"]["definition"].encode()) <= limit:
            raise AdaptationError("Expected an oversized original artifact: " + name)
    info = {key: table_info(old_nodes[name]["payload"]["definition"]) for key, name in TARGETS.items()}
    for side in ("Left", "Right"):
        light, raw = info["Light" + side], info["RawSelected" + side]
        if light["values"] != raw["values"] or light["normalized_sha256"] != raw["normalized_sha256"]:
            raise AdaptationError("Light/RawSelected tables differ; four-helper deduplication is forbidden")
    updated = copy.deepcopy(manifest)
    updated_plan = copy.deepcopy(plan)
    nodes = {node["name"]: node for node in updated["nodes"]}
    units = updated_plan["units"]
    artifacts, added, proofs = {}, [], []
    parent_helpers = {}
    for side in ("Left", "Right"):
        key = "Light" + side
        parent_name = TARGETS[key]
        parent = nodes[parent_name]
        table = info[key]
        chunks = chunk_rows(table["rows"], chunk_target)
        if len(chunks) != 2:
            raise AdaptationError("The four-helper adaptation requires exactly two chunks per table")
        reconstructed = [row for chunk in chunks for row in chunk]
        if reconstructed != table["rows"] or ast.literal_eval(literal_rows(reconstructed)) != table["values"]:
            raise AdaptationError("Literal row reconstruction changed the data")
        helpers, lean_names = [], []
        first_row = 0
        for index, chunk in enumerate(chunks, 1):
            suffix = table["normalized_sha256"][:16] + f"_part{index:02d}"
            constant = "rowData_" + suffix
            lean_name = "D1Bound5.Prove2MeTransfer." + constant
            name = "D1Bound5_Prove2MeTransfer_" + constant
            unit_id = "scanner_data_" + suffix
            if name in old_nodes or unit_id in units or lean_name in plan.get("declarations", {}):
                raise AdaptationError("Helper name or unit collision")
            body = ("import Init\n\nnamespace D1Bound5.Prove2MeTransfer\n"
                    "set_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n"
                    "noncomputable def " + constant + " : List (Nat × List Nat) :=\n" + literal_rows(chunk) +
                    "\n\nend D1Bound5.Prove2MeTransfer\n")
            if len(body.encode()) > limit:
                raise AdaptationError("Helper still exceeds token-scanner source limit")
            relative = f"adaptations/scanner-limit-v1/Definitions/Def_{name}.lean"
            artifacts[relative] = body
            payload = {"definition_name": name, "definition_title": f"Finite row table 6, {side.lower()} part {index}",
                       "definition": body, "env": manifest["env"], "private": True,
                       "natural_language_statement": f"Consecutive rows {first_row+1}–{first_row+len(chunk)} of the original {side.lower()} finite certificate table. The two parts concatenate to the exact original list of pairs consisting of a natural number and a list of natural numbers.",
                       "source": parent["payload"]["source"] + f". Exact row slice {first_row+1}-{first_row+len(chunk)}; normalized original literal SHA-256 {table['normalized_sha256']}.",
                       "tags": list(parent["payload"].get("tags", []))}
            helper = {"name": name, "kind": "definition", "unit_id": unit_id, "payload": payload,
                      "publish_dependencies": [], "proof_dependencies": [], "source_blocks": [],
                      "definition_file": relative, "definition_sha256": digest(body.encode()),
                      "metadata_status": "EXACT_LITERAL_DATA_SLICE",
                      "source_derived_from": {"parent": parent_name, "rows": [first_row, first_row+len(chunk)],
                                              "literal_sha256": table["normalized_sha256"]}}
            added.append(helper)
            helpers.append(name)
            lean_names.append(lean_name)
            units[unit_id] = {"kind": "definition", "platform_name": name, "primary_declaration": None,
                              "source_blocks": [], "inline_source_blocks": [], "publication_inline_source_blocks": [],
                              "publication_dependencies": [], "proof_dependencies": [], "source_modules": [],
                              "source_bytes": len(body.encode()), "payload_status": "SOURCE_DERIVED_LITERAL_SPLIT",
                              "source_derived_from": helper["source_derived_from"]}
            first_row += len(chunk)
        parent_helpers[parent_name] = added[-2:]
        expression = "_root_.List.append " + " ".join("_root_." + name for name in lean_names)
        replace_value(parent, units, table, expression, helpers, artifacts, manifest["env"])
        raw_name = TARGETS["RawSelected" + side]
        raw = nodes[raw_name]
        alias = "_root_.D1Bound5.PairLightPrepared6." + table["name"]
        replace_value(raw, units, info["RawSelected" + side], alias, [parent_name], artifacts, manifest["env"])
        proofs.append({"side": side.lower(), "rows": len(table["rows"]),
                       "normalized_literal_sha256": table["normalized_sha256"],
                       "light_raw_literal_equality": True, "exact_row_recomposition": True,
                       "chunk_rows": [len(chunk) for chunk in chunks],
                       "definitional_equality_reason": "List.append unfolds on the first literal list to the identical original List.cons sequence; the RawSelected alias unfolds to that same list."})
    # Keep every old node in exactly its old relative order. Insert helpers
    # immediately before their original parent, with no unrelated file edits.
    node_list = []
    for node in updated["nodes"]:
        node_list.extend(parent_helpers.get(node["name"], []))
        node_list.append(node)
    updated["nodes"] = node_list
    updated_plan["publication_topological_order"] = topological_order(units)
    for node in updated["nodes"]:
        source = node["payload"].get("definition", node["payload"].get("preamble", "") + node["payload"].get("formal_statement", ""))
        if len(source.encode()) > limit:
            raise AdaptationError("Source exceeds the scanner limit after adaptation: " + node["name"])
    changed = set(TARGETS.values())
    untouched = [name for name in old_nodes if name not in changed]
    if any(canonical(old_nodes[name]) != canonical(nodes[name]) for name in untouched):
        raise AdaptationError("An unrelated manifest node changed")
    report = {"reason": "Prove2Me token scanner rejects source files above 1048576 bytes",
              "schema": "p2m-scanner-limit-adaptation-v1", "source_limit": limit,
              "changed_nodes": [{"name": name, "reason": "Exact literal table split or definitionally equal alias",
                                  "old_source_bytes": len(old_nodes[name]["payload"]["definition"].encode()),
                                  "new_source_bytes": len(nodes[name]["payload"]["definition"].encode()),
                                  "old_node_sha256": digest(canonical(old_nodes[name])),
                                  "new_node_sha256": digest(canonical(nodes[name]))} for name in sorted(changed)],
              "added_nodes": [node["name"] for node in added], "unchanged_node_count": len(untouched),
              "unchanged_nodes_identical": True, "original_source_files_modified": 0,
              "proof_data_checks": proofs, "dependency_graph_acyclic": True,
              "artifacts": {path: {"bytes": len(body.encode()), "sha256": digest(body.encode())} for path, body in artifacts.items()}}
    updated["export_adaptations"] = list(updated.get("export_adaptations", [])) + [{k:v for k,v in report.items() if k not in {"artifacts"}}]
    updated["ready_for_upload"] = False
    updated["preparation_validation"] = "SCANNER_LIMIT_ADAPTATION_REQUIRES_MANIFEST_REVALIDATION"
    updated_plan["export_adaptations"] = list(updated_plan.get("export_adaptations", [])) + [report]
    updated_plan["summary"]["platform_units"] = len(units)
    updated_plan["summary"]["unit_kinds"]["definition"] += len(added)
    return updated, updated_plan, artifacts, report


def replace_value(node, units, table, expression, dependencies, artifacts, env):
    old_source = node["payload"]["definition"]
    body = old_source[:table["start"]] + expression + old_source[table["end"]:]
    body = "".join("import Definitions.Def_" + name.replace(".", "_") + "\n" for name in dependencies) + body
    relative = f"adaptations/scanner-limit-v1/Definitions/Def_{node['name']}.lean"
    artifacts[relative] = body
    node["payload"]["definition"] = body
    node["definition_file"] = relative
    node["definition_sha256"] = digest(body.encode())
    for key in ("publish_dependencies", "proof_dependencies"):
        node[key] = sorted(set(node.get(key, [])) | set(dependencies))
    unit = units[node["unit_id"]]
    by_name = {item["platform_name"]: unit_id for unit_id, item in units.items()}
    for key in ("publication_dependencies", "proof_dependencies"):
        unit[key] = sorted(set(unit.get(key, [])) | {by_name[name] for name in dependencies})
    unit["payload_status"] = "SOURCE_DERIVED_LITERAL_SPLIT"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--plan", type=Path, required=True)
    parser.add_argument("--output-manifest", type=Path, required=True)
    parser.add_argument("--output-plan", type=Path, required=True)
    parser.add_argument("--changes", type=Path, required=True)
    args = parser.parse_args()
    if args.manifest.resolve() == args.output_manifest.resolve() or args.plan.resolve() == args.output_plan.resolve():
        raise AdaptationError("Original manifests and plans are immutable")
    if args.output_manifest.parent.resolve() != args.manifest.parent.resolve():
        raise AdaptationError("New manifest must share the original artifact base directory")
    old_manifest_bytes, old_plan_bytes = args.manifest.read_bytes(), args.plan.read_bytes()
    manifest, plan, artifacts, report = patch_manifest(json.loads(old_manifest_bytes), json.loads(old_plan_bytes), args.manifest.parent)
    for relative, body in artifacts.items():
        path = args.manifest.parent / relative
        if path.exists() and path.read_text() != body:
            raise AdaptationError("Conflicting existing adaptation artifact: " + str(path))
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(body)
    atomic_json(args.output_manifest, manifest)
    atomic_json(args.output_plan, plan)
    report.update(old_manifest_sha256=digest(old_manifest_bytes), new_manifest_sha256=digest(args.output_manifest.read_bytes()),
                  old_plan_sha256=digest(old_plan_bytes), new_plan_sha256=digest(args.output_plan.read_bytes()))
    atomic_json(args.changes, report)
    print(json.dumps({"changed_nodes":len(report["changed_nodes"]),"added_nodes":len(report["added_nodes"]),
                      "unchanged_node_count":report["unchanged_node_count"],"all_sources_under_limit":True,
                      "dependency_graph_acyclic":True,"new_manifest_sha256":report["new_manifest_sha256"]}),flush=True)


if __name__ == "__main__":
    main()
