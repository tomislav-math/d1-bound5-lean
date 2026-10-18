"""Prepare optional all-48 graph replacements without installing or compiling.

One shared Inputs module contains the exact original declarations, roots,
indices, and an untrusted color mask. Arithmetic holds the cheap seed/filter/
count checks. Choose one of the two small closure proof backends. Optional
plain or cached color assembly exports the original graph theorem names and types.

Default emits only row41. Use --rows all --dry-run to validate all source
generation without emitting the full data, then --rows all when authorized
for intake. Cached colors are the preferred staged backend; each actual
certificate still requires standalone kernel compilation.
"""
from pathlib import Path
import argparse
import json
import re
from pair_staging import ROOT, HERE, configure, load_row, lean_pair, lean_option, theorem_block, sha

parser = argparse.ArgumentParser()
parser.add_argument("--rows", default="41", help="all or comma-separated row numbers")
parser.add_argument("--exclude-rows", default="", help="comma-separated rows retained under another architecture")
parser.add_argument("--dry-run", action="store_true")
parser.add_argument("--input-dir", type=Path, default=ROOT / "finite_next/two_small/D1Bound5")
parser.add_argument("--sieve-dir", type=Path, default=ROOT / "finite_fast_next/sieves")
parser.add_argument("--helper-dir", type=Path, default=HERE, help="directory containing the three generic Lean helpers")
parser.add_argument("--manifest-dir", type=Path, default=HERE, help="directory containing frozen input/diagnostic/sieve manifests")
parser.add_argument("--root-routine", type=Path, default=ROOT / "finite_next/two_small/generate_pair_closures.py")
parser.add_argument("--output-dir", type=Path, default=HERE / "staged_all48")
parser.add_argument("--source-only", action="store_true", help="derive all data from hash-pinned Lean originals; do not require historical large JSON copies")
parser.add_argument("--expected-manifest", type=Path, help="verify every emitted source hash against a prior local dry-run before writing it")
color_options = parser.add_mutually_exclusive_group()
color_options.add_argument("--emit-plain-assembly", action="store_true")
color_options.add_argument("--emit-cached-assembly", action="store_true")
args = parser.parse_args()
rows = list(range(1, 49)) if args.rows == "all" else [int(k) for k in args.rows.split(",")]
excluded = set(int(k) for k in args.exclude_rows.split(",") if k)
assert all(1 <= k <= 48 for k in excluded)
rows = [k for k in rows if k not in excluded]
assert rows and len(set(rows)) == len(rows) and all(1 <= k <= 48 for k in rows)
OUT = args.output_dir
configure(args.input_dir, args.manifest_dir, args.root_routine, args.source_only)
SIEVE_PINS = json.loads((args.manifest_dir / "cached_sieve_fingerprints.json").read_text())
EXPECTED = ({r["row"]: r for r in json.loads(args.expected_manifest.read_text())["results"]}
            if args.expected_manifest else None)
GENERIC_PINS = {
    "PairClosureWitness.lean": "c3e5b89a544885205672d45a9a3cb231a99a79dcff6c62a96059e9f00b860a62",
    "PairClosureIndexedWitness.lean": "396e39b992bc9611aabcfcda13356692e98676409381a756555e84104fe22420",
    "PairCachedResidues.lean": "8d30539028d401e948637a33f705cb33707d8ad4e1fe939eafd5ed7c690a9100",
}
for generic, digest in GENERIC_PINS.items():
    assert sha((args.helper_dir / generic).read_bytes()) == digest, generic


def cached_signatures(row):
    t, n = row["tau"], row["nu"]
    relative = f"finite_fast_next/sieves/SmallPairSieve_{t}_{n}.lean"
    source = (args.sieve_dir / f"SmallPairSieve_{t}_{n}.lean").read_bytes()
    assert sha(source) == SIEVE_PINS[relative], relative
    source = source.decode()
    mask_name = rf"smallPairMask_{t}_{n}_\d+"
    masks = {name: int(value) for name, value in
             re.findall(rf"def ({mask_name}) : ℕ := (\d+)", source)}
    literal = re.search(rf"def smallPairSieve_{t}_{n} .*? := \[(.*?)\n\]", source, re.S).group(1)
    pattern = rf"\((\d+),\s*({mask_name})\)"
    entries = re.findall(pattern, literal)
    assert entries and all(name in masks for _, name in entries)
    assert re.sub(pattern, "", literal).replace(",", "").strip() == ""
    moduli = [int(k) + 1 for k, _ in entries]
    signatures = [[(x % m, y % m) for m in moduli] for x, y in row["large"]]
    digest = sha(json.dumps(signatures, separators=(",", ":")).encode())
    if row["row"] == 41:
        assert digest == "adc49d0f5083ae46273677b28edfa091c5c74e8727538b3baabc1a9fbf94ee2b"
    row["cached_report"] = {"sieve_source": relative, "sieve_sha256": SIEVE_PINS[relative],
                            "moduli": moduli, "signature_list_sha256": digest,
                            "coordinate_residues": 2 * len(signatures) * len(moduli)}
    return signatures


def old_statement(source, name):
    block = theorem_block(source, name)
    assert " := by\n  decide +kernel" in block
    return block.split(" := by\n  decide +kernel", 1)[0] + " :="


def emit_row(row):
    k, t, n = row["row"], row["tau"], row["nu"]
    ns = f"PairGraphPrepared{k}"
    root_rows = ",\n".join(f"  ({lean_pair(r)}, {lean_pair(s)})" for r, s in row["root_pairs"])
    dest_rows = ",\n".join(f"  ({lean_option(p)}, {lean_option(m)})" for p, m in row["destinations"])
    inputs = f'''import D1Bound5.PairClosureWitness

namespace D1Bound5
open QuadInt
set_option maxRecDepth 100000

{row["declarations"]}namespace {ns}

/-- Supplied anchor root; all equations are checked by the selected closure certificate. -/
def anchorRoot : QuadInt {t} {n} := {lean_pair(row["anchor_root"])}

def rootPairs : List (QuadInt {t} {n} × QuadInt {t} {n}) := [
{root_rows}
]

def witnesses : List (PairRootWitness {t} {n}) :=
  List.zipWith (fun (z : QuadInt {t} {n}) (rs : QuadInt {t} {n} × QuadInt {t} {n}) =>
    ⟨z, rs.1, rs.2⟩) smallPairClosure_{k} rootPairs

def destinations : List (Option ℕ × Option ℕ) := [
{dest_rows}
]

/-- Untrusted two-color preparation; independent-class certificates check it. -/
def colors : ℕ := {row["diagnostic"]["color_mask"]}

end {ns}
end D1Bound5
'''
    # Moving the declaration block does not rewrite it or duplicate it in a
    # second generated module. The original values and public names survive.
    assert row["declarations"] in inputs
    arithmetic_names = [f"smallPairSeeds_{k}_checked", f"smallPairFilter_{k}_checked",
                        f"smallPairLarge_{k}_count"]
    arithmetic = f'''import D1Bound5.SmallPairGraphInputs{k}
import D1Bound5.TwoSmallSeedDisks
import D1Bound5.SmallPairGraphCheck

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

''' + "\n\n".join(theorem_block(row["source"], name) for name in arithmetic_names) + "\n\nend D1Bound5\n"
    closure_statement = old_statement(row["source"], f"smallPairClosure_{k}_checked")
    membership = f'''import D1Bound5.SmallPairGraphInputs{k}

namespace D1Bound5
open {ns}
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem {ns}.membership_checked :
    pairClosureWitnessBool smallPairA_{k} smallPairB_{k} anchorRoot
      (10^1100) smallPairClosure_{k} witnesses = true := by
  decide +kernel

{closure_statement}
  pairClosureBool_of_witness_checked (by decide) smallPairA_{k} smallPairB_{k} anchorRoot
    (10^1100) smallPairClosure_{k} witnesses {ns}.membership_checked

end D1Bound5
'''
    indexed = f'''import D1Bound5.SmallPairGraphInputs{k}
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
open {ns}
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem {ns}.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_{k} smallPairB_{k} anchorRoot
      (10^1100) smallPairClosure_{k} witnesses destinations = true := by
  decide +kernel

{closure_statement}
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_{k} smallPairB_{k} anchorRoot
    (10^1100) smallPairClosure_{k} witnesses destinations {ns}.indexed_checked

end D1Bound5
'''
    files = {
        f"common/D1Bound5/SmallPairGraphInputs{k}.lean": inputs,
        f"common/D1Bound5/SmallPairGraphArithmetic{k}.lean": arithmetic,
        f"membership/D1Bound5/SmallPairGraphClosure{k}.lean": membership,
        f"indexed/D1Bound5/SmallPairGraphClosure{k}.lean": indexed,
    }
    if args.emit_plain_assembly or args.emit_cached_assembly:
        triangle_statement = old_statement(row["source"], f"smallPairNoTriangle_{k}_checked")
        assembly = f'''import D1Bound5.SmallPairGraphArithmetic{k}
import D1Bound5.SmallPairGraphClosure{k}
import D1Bound5.PairBipartiteCheck
import D1Bound5.SmallPairSieve_{t}_{n}

namespace D1Bound5
open {ns}
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem {ns}.left_checked :
    pairIndependentBool smallPairSieve_{t}_{n}
      (pairSplitByMask smallPairLarge_{k} colors).1 = true := by
  decide +kernel

theorem {ns}.right_checked :
    pairIndependentBool smallPairSieve_{t}_{n}
      (pairSplitByMask smallPairLarge_{k} colors).2 = true := by
  decide +kernel

{triangle_statement}
  pairGraphTriangleFreeBool_of_split smallPairSieve_{t}_{n} smallPairLarge_{k} colors
    {ns}.left_checked {ns}.right_checked

end D1Bound5
'''
        files[f"plain/D1Bound5/SmallPairGraphData{k}.lean"] = assembly
    if args.emit_cached_assembly:
        signature_rows = ",\n".join("  [" + ", ".join(f"({u}, {v})" for u, v in sig) + "]"
                                     for sig in cached_signatures(row))
        cached = f'''import D1Bound5.SmallPairGraphArithmetic{k}
import D1Bound5.SmallPairGraphClosure{k}
import D1Bound5.PairCachedResidues
import D1Bound5.SmallPairSieve_{t}_{n}

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

namespace {ns}

/-- Supplied residues in the exact original vertex and sieve orders. -/
def cachedSignatures : List (List (ℕ × ℕ)) := [
{signature_rows}
]

def cachedVertices : List (PairResidueVertex {t} {n}) :=
  List.zipWith (fun (z : QuadInt {t} {n}) (sig : List (ℕ × ℕ)) => ⟨z, sig⟩)
    smallPairLarge_{k} cachedSignatures

'''
        for side, projection in [("left", 1), ("right", 2)]:
            cached += f'''theorem {side}_certificate_checked :
    pairCachedIndependentCertificateBool smallPairSieve_{t}_{n}
      (pairSplitByMask smallPairLarge_{k} colors).{projection}
      (pairSplitByMask cachedVertices colors).{projection} = true := by
  decide +kernel

theorem {side}_checked :
    pairIndependentBool smallPairSieve_{t}_{n}
      (pairSplitByMask smallPairLarge_{k} colors).{projection} = true :=
  pairIndependentBool_of_cached_certificate smallPairSieve_{t}_{n}
    (pairSplitByMask smallPairLarge_{k} colors).{projection}
    (pairSplitByMask cachedVertices colors).{projection} {side}_certificate_checked

'''
        cached += f'''end {ns}
open {ns}

{triangle_statement}
  pairGraphTriangleFreeBool_of_split smallPairSieve_{t}_{n} smallPairLarge_{k} colors
    {ns}.left_checked {ns}.right_checked

end D1Bound5
'''
        del files[f"plain/D1Bound5/SmallPairGraphData{k}.lean"]
        files[f"cached/D1Bound5/SmallPairGraphData{k}.lean"] = cached
    # Exact public statements are preserved in their new owning modules.
    for name in arithmetic_names:
        assert theorem_block(row["source"], name) in arithmetic
    assert closure_statement in membership and closure_statement in indexed
    if args.emit_plain_assembly or args.emit_cached_assembly:
        assert triangle_statement in assembly
    if args.emit_cached_assembly:
        assert triangle_statement in cached
    return files


reports, total_bytes = [], 0
for k in rows:
    row = load_row(k)
    files = emit_row(row)
    report_files = {}
    for relative, contents in files.items():
        data = contents.encode()
        total_bytes += len(data)
        report_files[relative] = {"sha256": sha(data), "bytes": len(data)}
        if EXPECTED is not None:
            assert k in EXPECTED and report_files[relative] == EXPECTED[k]["files"][relative], relative
        if not args.dry_run:
            destination = OUT / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(data)
    reports.append({"row": k, "original_source_sha256": row["diagnostic"]["source_sha256"],
                    "original_declarations_sha256": sha(row["declarations"].encode()),
                    "vertices": len(row["vertices"]), "files": report_files,
                    **({"cached": row["cached_report"]} if args.emit_cached_assembly else {})})
OUT.mkdir(parents=True, exist_ok=True)
report = {
    "status": "Uncompiled replacement sources; no remote install and no build queue",
    "dry_run": args.dry_run, "rows": rows,
    "source_only": args.source_only,
    "expected_source_manifest_verified": args.expected_manifest is not None,
    "plain_color_assembly_included": args.emit_plain_assembly,
    "cached_color_assembly_included": args.emit_cached_assembly,
    "generic_source_pins": GENERIC_PINS,
    "supported_closure_backend": "indexed; Graph41 pilot passed standalone kernel compilation",
    "backend_rule": "Install common plus exactly one of membership/indexed, then the selected color assembly",
    "namespace_rule": "These replace original GraphData definitions; do not import old and new data owners together",
    "data_duplication": "Original declarations occur once per row; both closure alternatives share all root data",
    "file_count_including_alternatives": sum(len(r["files"]) for r in reports),
    "bytes_including_alternatives": total_bytes,
    "results": reports,
}
tag = "all" if rows == list(range(1, 49)) else "_".join(map(str, rows))
color_tag = "_cached" if args.emit_cached_assembly else ""
report_path = OUT / f"manifest_{tag}{color_tag}_{'dry' if args.dry_run else 'staged'}.json"
report_path.write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps({k: v for k, v in report.items() if k != "results"}, indent=2))
