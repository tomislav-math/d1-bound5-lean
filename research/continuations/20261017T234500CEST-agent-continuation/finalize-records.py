#!/usr/bin/env python3
"""Record a completed, unchanged proof snapshot; no Git mutations."""
import hashlib, json, subprocess
from datetime import datetime, timezone
from pathlib import Path
ROOT = Path("/Users/tp/Lean/D1Bound5")
RUN = ROOT/"research/continuations/20261017T234500CEST-agent-continuation"
checks = json.loads((RUN/"accepted-build-results.json").read_text())
replay = json.loads((RUN/"kernel-replay-result.json").read_text())
if len(checks)!=11 or any(x["exit_code"] for x in checks):
    raise SystemExit("Incomplete or failing build/audit evidence")
if replay["exit_code"] != 0 or not replay["source_unchanged"]:
    raise SystemExit("Replay did not pass on unchanged sources")
for name,digest in replay["source_sha256"].items():
    if hashlib.sha256((ROOT/name).read_bytes()).hexdigest()!=digest:
        raise SystemExit("Source changed after replay: "+name)
frozen = Path("/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex")
assert hashlib.sha256(frozen.read_bytes()).hexdigest()=="776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3"
pin = subprocess.check_output(["git","-C",str(ROOT/".lake/packages/mathlib"),"rev-parse","HEAD"],text=True).strip()
assert pin=="0df444a360eaa60ab8c11dca51a86af692955474"
assert not subprocess.check_output(["git","-C",str(ROOT/".lake/packages/mathlib"),"status","--porcelain","--untracked-files=no"],text=True).strip()
counts={}
for name,extra in [
    ("records/proof-source-sha256.txt",["D1Bound5/"+n+".lean" for n in ["CrossBlockDeterminant","CoherentAnalyticInterpolation","BennettResidualDeterminant","BennettResidueCoefficient","BennettFirstOrder","BennettFirstOrderResidues","BennettPoleSeries"]]),
    ("records/verification-tools-sha256.txt",["scripts/AgentContinuationAudit.lean"])]:
    path=ROOT/name
    names={line.split(None,1)[1].lstrip("*") for line in path.read_text().splitlines() if line.strip()}
    names.update(extra)
    path.write_text("".join(hashlib.sha256((ROOT/n).read_bytes()).hexdigest()+"  "+n+"\n" for n in sorted(names)))
    counts[name]=len(names)
when=datetime.now(timezone.utc).isoformat()
summary="""Seven new root-imported modules prove 45 exported theorems (plus 3 private cross-block helpers) and add 8 public definitions. The new results are the full-ring cross-block determinant lower bound; exact convergent coherent interpolation, manuscript tail estimate and coherent-root compatibility; the arbitrary-size k=1 Bennett determinant with explicit entries and nonvanishing; the conditional all-order determinant/degree and simple-residue coefficient principles; and the local inverse-power binomial expansion.

All seven standalone pinned module builds, the integrated root build, the exact 53-declaration type/transitive-axiom audit, the whole-project transitive-axiom audit and the source/import scan passed. Fresh whole-root leanchecker replay also passed in the SAME installed Lean kernel, with source SHA256 equality before and after replay. Only propext, Classical.choice and Quot.sound are permitted by the enforced audits. Independent source/statement review of all seven exact final module bodies passed. No fresh clean-checkout or independent kernel implementation was used.

The new work does NOT close the arbitrary-order Bennett determinant: concrete residue cancellation/decomposition, the node-removal recurrence and the nonzero determinant constant remain open. The integral coherent linear form and nonvanishing, quantitative approximation and cross-block upper bounds, complete finite certificates/descent, the three final sextuple branches and MainStatement remain UNPROVED. The full-ring product-four and product-five tuple growth endpoints were already proved and remain unchanged.

The public manuscript body matches frozen v4; only PDF metadata and date differ. The two requested hourly automations remain paused. Previous unsynchronized work was privately pushed in d7ba2c337d76df8e081ac8e299f48a019e0d2791 and fd0c8b471614a4b8c5a110a830524c973758e4aa. Publication of this new accepted snapshot requires the separate verified push receipt."""
heading="## 17 October 2026 — cross-block, coherent interpolation and first-order Bennett verified"
for name in ["STATUS.md","records/paper-to-lean.md","records/open-obligations.md","records/build-record.md"]:
    path=ROOT/name
    old=path.read_text()
    if heading in old:
        raise SystemExit("Refusing duplicate record insertion: "+name)
    first,sep,rest=old.partition("\n")
    path.write_text(first+"\n\n"+heading+"\n\n"+summary+"\n\n"+rest.lstrip("\n"))
table="\n".join("| "+x["label"]+" | "+str(x["exit_code"])+" | "+str(x["seconds"])+" |" for x in checks)
body="# Author-requested multi-agent continuation — FINISH\n\nUTC: "+when+"\n\n"+summary+"""

## Exact verification

| Step | Exit code | Seconds |
|---|---:|---:|
"""+table+"\n\nFresh whole-root same-kernel replay: EXIT 0, "+str(replay["seconds"])+" seconds. Command: "+" ".join(replay["command"])+".\n\n"+(RUN/"final-source-audit.log").read_text()+"""

The replay receipt records every project source hash and confirms unchanged bytes. The pinned mathlib checkout has no tracked modifications. The external frozen manuscript hash remains unchanged. Source/tool fingerprint manifest entry counts: """+json.dumps(counts)+""".

See accepted-build-results.json, continuation-axioms.log, whole-project-axioms.log, whole-root-kernel-replay.log and kernel-replay-result.json. The independent source audit includes the exact seven-module hash mapping and confirms no weakened assumptions. Earlier failed trial sources/logs are intentionally retained under research; they are not imported proof modules. The unexecuted CombinedBennettTrial03 retry was superseded by the actual standalone builds.

## Next mathematical work

1. Define the genuine all-order Bennett residue polynomials, identify the local coefficients, prove their exact cleared partial-fraction decomposition and residual cancellation.
2. Use the proved determinant degree/divisibility step, then complete node removal with the parameter shift nu to nu-k. Retain the zero node while more than one node remains, unless a stronger invertible-column version is separately proved.
3. Transport the coherent analytic roots and normalization to the actual integral linear form; establish its nonzero lower bound and quantitative upper/approximation bounds with the manuscript constants.
4. Prove completeness of the finite enumerations through reversible descent and exact graph/table certificates, then assemble the three sextuple exclusions and MainStatement.

No percentages of total formalization are asserted. Saved numerical examples and literature citations are not treated as kernel proofs.
"""
coverage = """
## New proof modules

| Module | Exported theorems | Proven scope and manuscript connection |
|---|---:|---|
| CrossBlockDeterminant | 2 | Algebraic nonvanishing and full-ring norm lower bound in Lemma 7.2; the analytic upper bound is still open. |
| CoherentAnalyticInterpolation | 13 | Section 3 exact convergent interpolation and tail estimate, normalization and coherent-root identities; integral-form nonvanishing still needs proof. |
| BennettResidualDeterminant | 5 | The all-order degree/divisibility step for Lemma 4.1, conditional on actual residual cancellation and a distinguished coefficient equal to one. |
| BennettResidueCoefficient | 5 | Coefficient comparison and sum-of-simple-residues cancellation, conditional on the exact cleared decomposition. |
| BennettFirstOrder | 9 | Arbitrary-size first-order interpolation operator and residue determinant. |
| BennettFirstOrderResidues | 8 | Explicit diagonal/off-diagonal k=1 residue entries and nonvanishing at t=3/2. |
| BennettPoleSeries | 3 | Verified local inverse-power binomial expansion for arbitrary k; global residue identification remains open. |

The counts exclude three private cross-block helper theorems and eight public definitions.

"""
body = body.replace("## Exact verification", coverage + "## Exact verification")
(ROOT/"records/runs/20261017T234500CEST-agent-continuation-FINISH.md").write_text(body)
(ROOT/"records/agent-continuation-20261017.md").write_text(body)
print(json.dumps({"status":"FINAL_RECORDS_AND_MANIFESTS_WRITTEN","utc":when,"manifests":counts},indent=2))
