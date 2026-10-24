"""Own one private uploader child and continue graph-first into all-proofs.

No API imports or calls. Never edits the uploader ledger, deletes a lock, retries
an ambiguous request, or starts a second child before the first has exited.
"""
import argparse
from collections import Counter
from contextlib import contextmanager
import fcntl
import hashlib
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time
import uuid

from batch_uploader import Halt, Uploader, MAX_ACTIVE_JOBS, digest, validate

TERMINAL_EVENTS = {"COMPLETE", "TIME_LIMIT_CHECKPOINT", "STOPPED", "BLOCKED_DEPENDENCIES"}
EVENTS = TERMINAL_EVENTS | {"PUBLISH_QUEUED", "PROOFS_QUEUED", "PUBLISH_STATUS", "PROOF_STATUS"}
FAIL_PROOF = {"CE", "WA", "SORRY", "FAILED", "ERROR"}
FAIL_PUBLISH = {"FAILED", "ERROR"}
SUCCESS = {"ACCEPTED", "SKETCH_ACCEPTED"}


def sha_file(path):
    h = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


@contextmanager
def locked(path):
    # Opening the conventional lock file does not change the ledger. Never unlink it.
    with Path(path).open("a+") as stream:
        try:
            fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise Halt("Another process owns the required lock")
        yield


def counts(state):
    entries = state["entries"]
    failed = [name for name, e in entries.items()
              if e.get("publish_status") in FAIL_PUBLISH or e.get("proof_status") in FAIL_PROOF]
    return {"entries": len(entries), "registered": sum(bool(e.get("theorem_id")) for e in entries.values()),
            "active": sum(Uploader.is_active(e) for e in entries.values()),
            "proof_statuses": dict(Counter(e.get("proof_status", "UNSUBMITTED") for e in entries.values()
                                           if e.get("kind") == "theorem")),
            "failures": len(failed), "failed_names": failed[:20]}


def verify_receipts(state, state_path):
    base = state_path.parent
    directory = (base / (state_path.name + ".receipts")).resolve()
    pending, checked = [state], set()
    while pending:
        value = pending.pop()
        if isinstance(value, list):
            pending.extend(value)
        elif isinstance(value, dict):
            if set(value) == {"path", "sha256", "bytes"}:
                path = (base / value["path"]).resolve()
                if path.parent != directory or path.name != value["sha256"] + ".json":
                    raise Halt("Receipt reference escapes its content-addressed store")
                key = (str(path), value["sha256"], value["bytes"])
                if key in checked:
                    continue
                raw = path.read_bytes()
                if len(raw) != value["bytes"] or hashlib.sha256(raw).hexdigest() != value["sha256"]:
                    raise Halt("Receipt checksum mismatch")
                checked.add(key)
                pending.append(json.loads(raw))
            else:
                if value.get("schema") == "p2m-manifest-migration-v1":
                    # These four fields describe historical files; they are not
                    # receipt links. The report itself was hash-verified above.
                    provenance = {"old_manifest", "new_manifest", "state_before", "changes_document"}
                    for key in provenance:
                        record = value.get(key)
                        if (not isinstance(record, dict) or set(record) != {"path", "sha256", "bytes"}
                                or not isinstance(record["path"], str)
                                or not isinstance(record["sha256"], str) or len(record["sha256"]) != 64
                                or any(c not in "0123456789abcdef" for c in record["sha256"])
                                or type(record["bytes"]) is not int or record["bytes"] < 0):
                            raise Halt("Malformed historical migration provenance")
                    historical = value.get("old_state_receipt", {})
                    if any(value["state_before"][key] != historical.get(key) for key in ("sha256", "bytes")):
                        raise Halt("Historical state provenance disagrees with its archived receipt")
                    pending.extend(item for key, item in value.items() if key not in provenance)
                else:
                    pending.extend(value.values())
    return len(checked)


def audit(manifest_path, state_path, identity, limit, previous=None, allow_terminal_failures=False):
    """Caller holds the ledger lock; this function is strictly read-only."""
    if not 1 <= limit <= MAX_ACTIVE_JOBS:
        raise Halt("Shared queue limit exceeds the documented maximum")
    for path, expected in identity.items():
        if sha_file(path) != expected:
            raise Halt("Pinned manifest or supervisor/uploader code changed")
    manifest = json.loads(manifest_path.read_text())
    if manifest.get("ready_for_upload") is not True:
        raise Halt("Manifest has not passed final upload validation")
    nodes, existing = validate(manifest, manifest_path.parent)
    raw = state_path.read_bytes()
    state = json.loads(raw)
    if state.get("private") is not True or state.get("env") != manifest["env"]:
        raise Halt("Ledger environment or privacy differs from the immutable manifest")
    entries = state["entries"]
    if any(a.get("stage") != "recorded" for a in state["actions"].values()):
        raise Halt("Unresolved mutation action; review before continuing")
    for name, node in nodes.items():
        entry = entries.get(name, {})
        expected = digest({k: node.get(k) for k in
                           ("kind", "payload", "solution_sha256", "explanation", "publish_dependencies", "proof_dependencies")})
        if entry.get("manifest_sha256") != expected or entry.get("kind") != node["kind"]:
            raise Halt("Ledger node differs from the immutable manifest: " + name)
    for name, binding in existing.items():
        if entries.get(name, {}).get("theorem_id") != binding["id"]:
            raise Halt("Existing binding changed: " + name)
    for name, entry in entries.items():
        if Uploader.is_active(entry) and name not in nodes:
            raise Halt("Active job is absent from the manifest")
        if entry.get("publish_status") not in {None, "PENDING", "COMPILING", "PUBLISHED", "FAILED", "ERROR"}:
            raise Halt("Unknown publication status")
        if entry.get("proof_status") not in {None, "PENDING", "COMPILING"} | SUCCESS | FAIL_PROOF:
            raise Halt("Unknown proof status")
        if entry.get("publish_status") == "PUBLISHED" and not entry.get("theorem_id"):
            raise Halt("Published entry has no theorem/definition ID")
        if entry.get("publish_status") in {"PENDING", "COMPILING"} and not entry.get("job_id"):
            raise Halt("Pending publication has no job ID")
        if entry.get("submission_id") and not entry.get("theorem_id"):
            raise Halt("Proof submission has no registered target ID")
        if entry.get("proof_status") and not entry.get("submission_id"):
            raise Halt("Proof status has no submission ID")
        if (entry.get("job_id") and not entry.get("theorem_id") and entry.get("submission_id")):
            raise Halt("One entry unexpectedly owns publication and proof jobs")
    if previous is not None:
        for name, old in previous["entries"].items():
            new = entries.get(name, {})
            for key in ("job_id", "theorem_id", "submission_id"):
                if old.get(key) and old[key] != new.get(key):
                    raise Halt("A pre-existing job or theorem ID was changed or removed")
            if old.get("proof_status") in SUCCESS and old["proof_status"] != new.get("proof_status"):
                raise Halt("A previously successful proof disposition changed")
        for action_id, old in previous["actions"].items():
            if state["actions"].get(action_id) != old:
                raise Halt("A recorded mutation action changed or disappeared")
    result = counts(state)
    if result["active"] > limit:
        raise Halt("Pending jobs exceed the shared queue limit")
    if result["failures"] and not allow_terminal_failures:
        raise Halt("Terminal publication/proof failure requires review: " + ", ".join(result["failed_names"]))
    result["verified_receipts"] = verify_receipts(state, state_path)
    result["state_sha256"] = hashlib.sha256(raw).hexdigest()
    return state, result


def read_terminal(path, limit):
    """Strictly parse this child's fresh stdout, never an appended older run."""
    terminal = None
    with Path(path).open("rb") as stream:
        while True:
            raw = stream.readline(8 * 1024 * 1024 + 1)
            if not raw:
                break
            if len(raw) > 8 * 1024 * 1024 or not raw.endswith(b"\n"):
                raise Halt("Incomplete or oversized child event")
            if not raw.strip():
                continue
            try:
                event = json.loads(raw)
            except (ValueError, UnicodeError):
                raise Halt("Unexpected non-JSON child output")
            if not isinstance(event, dict) or event.get("event") not in EVENTS:
                raise Halt("Unknown child event")
            if terminal is not None:
                raise Halt("Child emitted output after its terminal event")
            if type(event.get("active")) is not int or not 0 <= event["active"] <= limit or event.get("limit") != limit:
                raise Halt("Child event queue bound mismatch")
            if event["event"] in TERMINAL_EVENTS:
                terminal = event
    if terminal is None:
        raise Halt("Child exited without a terminal event")
    return terminal


def next_phase(phase, returncode, event, snapshot, elapsed, duration, root, signalled=False):
    if signalled:
        raise Halt("Supervisor stop or failure signal was forwarded; no automatic restart")
    if snapshot["failures"] or snapshot["active"] != event["active"]:
        raise Halt("Terminal event and ledger do not agree")
    if phase == "graph_first":
        if event.get("mode") != "graph_first" or event.get("graph_root") != root:
            raise Halt("Terminal event has a different graph phase/root")
    elif event.get("mode") == "graph_first":
        raise Halt("All-proofs child reported graph-first mode")
    if returncode == 0 and event["event"] == "COMPLETE":
        if event.get("failed") != [] or event["active"] != 0:
            raise Halt("COMPLETE contains a failure or active job")
        if phase == "graph_first" and event.get("completion_scope") != "registrations_and_root_connected_reductions":
            raise Halt("Unknown graph completion scope")
        return "all_proofs" if phase == "graph_first" else None
    if returncode == 3 and event["event"] == "TIME_LIMIT_CHECKPOINT" and elapsed >= duration:
        return phase
    raise Halt("Child did not reach a verified clean completion or time checkpoint")


class Supervisor:
    def __init__(self, args, popen=subprocess.Popen, clock=time.monotonic, emit=None):
        self.args, self.popen, self.clock = args, popen, clock
        self.emit = emit or (lambda event: print(json.dumps(event, sort_keys=True), flush=True))
        self.child = None
        self.stop_requested = False
        self.forwarded = False
        self.run_id = time.strftime("%Y%m%dT%H%M%SZ", time.gmtime()) + "-" + uuid.uuid4().hex[:8]
        self.directory = args.log_dir / self.run_id
        self.directory.mkdir(parents=True, exist_ok=False)
        paths = [args.manifest, args.uploader, args.uploader.parent / "batch_uploader.py", Path(__file__).resolve()]
        client = args.uploader.parent / "p2m_client.py"
        if client.exists():
            paths.append(client)
        self.identity = {str(path): sha_file(path) for path in paths}
        self.journal = self.directory / "progress.jsonl"

    def event(self, name, **fields):
        record = {"event": name, "unix": time.time(), "run_id": self.run_id, **fields}
        with self.journal.open("a") as stream:
            stream.write(json.dumps(record, sort_keys=True) + "\n")
            stream.flush()
            os.fsync(stream.fileno())
        self.emit(record)

    def request_stop(self, signum=signal.SIGTERM, frame=None):
        self.stop_requested = True
        self.forward_once(signum)

    def forward_once(self, signum=signal.SIGTERM):
        if self.child is not None and not self.forwarded:
            self.forwarded = True
            try:
                self.child.send_signal(signum)
            except ProcessLookupError:
                pass

    def command(self, phase):
        a = self.args
        return [a.python, "-u", str(a.uploader), "--manifest", str(a.manifest), "--state", str(a.state),
                "--limit", str(a.limit), "--max-seconds", str(a.max_seconds), "--poll-seconds", str(a.poll_seconds),
                "--graph-first" if phase == "graph_first" else "--all-proofs",
                "--root-theorem", a.root_theorem, "--max-graph-proofs", str(a.max_graph_proofs)]

    def run(self):
        phase, cycle, previous = self.args.start_phase, 0, None
        with locked(str(self.args.state) + ".supervisor.lock"):
            while phase is not None:
                if self.stop_requested:
                    raise Halt("Supervisor was stopped before launching a child")
                allow_existing_failures = previous is None and getattr(self.args, "allow_existing_terminal_failures", False)
                with locked(str(self.args.state) + ".lock"):
                    before, snapshot = audit(self.args.manifest, self.args.state, self.identity,
                                             self.args.limit, previous, allow_terminal_failures=allow_existing_failures)
                cycle += 1
                prefix = "%03d-%s" % (cycle, phase)
                outpath, errpath = self.directory / (prefix + ".stdout.jsonl"), self.directory / (prefix + ".stderr.log")
                self.event("PHASE_START", phase=phase, cycle=cycle, snapshot=snapshot,
                           existing_terminal_failures_allowed=allow_existing_failures, stdout=str(outpath), stderr=str(errpath), identities=self.identity)
                self.forwarded = False
                started = self.clock()
                with outpath.open("xb") as output, errpath.open("xb") as error:
                    # No shell, credentials or environment dumping. Only this single child exists.
                    self.child = self.popen(self.command(phase), stdout=output, stderr=error,
                                            cwd=str(self.args.uploader.parent))
                    self.event("CHILD_STARTED", phase=phase, cycle=cycle, pid=self.child.pid)
                    if self.stop_requested:
                        self.forward_once()
                    reported = started
                    last_failures = None
                    while True:
                        try:
                            returncode = self.child.wait(timeout=5)
                            break
                        except subprocess.TimeoutExpired:
                            # Atomic ledger reads; mutation intents can legitimately be in flight.
                            try:
                                current = counts(json.loads(self.args.state.read_text()))
                                if current["failures"] and current["failures"] != last_failures:
                                    self.event("TERMINAL_FAILURE_OBSERVED", phase=phase, snapshot=current)
                                last_failures = current["failures"]
                                # A failed branch does not stop healthy work; it blocks handoff.
                                if current["active"] > self.args.limit:
                                    self.forward_once()
                                if self.clock() - reported >= 30:
                                    self.event("PHASE_PROGRESS", phase=phase, cycle=cycle, snapshot=current,
                                               elapsed_seconds=round(self.clock() - started, 2))
                                    reported = self.clock()
                            except (OSError, ValueError, KeyError, TypeError):
                                self.forward_once()
                    self.child = None
                    output.flush()
                    error.flush()
                elapsed = self.clock() - started
                # Child is gone. Acquire the same ledger lock before inspecting the checkpoint.
                with locked(str(self.args.state) + ".lock"):
                    after, snapshot = audit(self.args.manifest, self.args.state, self.identity,
                                            self.args.limit, before)
                    event = read_terminal(outpath, self.args.limit)
                    following = next_phase(phase, returncode, event, snapshot, elapsed, self.args.max_seconds,
                                           self.args.root_theorem, self.forwarded or self.stop_requested)
                    scheduling = after.get("scheduling", {})
                    if scheduling.get("mode") != phase:
                        raise Halt("Ledger scheduling mode does not match child phase")
                self.event("PHASE_FINISHED", phase=phase, cycle=cycle, returncode=returncode,
                           terminal_event=event["event"], snapshot=snapshot, next_phase=following)
                previous, phase = after, following
            self.event("ALL_PROOFS_SUBMITTED", snapshot=snapshot,
                       note="Successful dispositions include sketches; verify the platform root status separately.")
        return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--state", type=Path, required=True)
    parser.add_argument("--uploader", type=Path, default=Path(__file__).with_name("global_uploader.py"))
    parser.add_argument("--python", default=sys.executable)
    parser.add_argument("--log-dir", type=Path)
    parser.add_argument("--limit", type=int, default=15)
    parser.add_argument("--max-graph-proofs", type=int, default=8)
    parser.add_argument("--max-seconds", type=float, default=43200)
    parser.add_argument("--poll-seconds", type=float, default=3)
    parser.add_argument("--root-theorem", default="D1Bound5.main_statement")
    parser.add_argument("--allow-existing-terminal-failures", action="store_true",
                        help="Resume healthy branches on initial launch; failures still block every automatic handoff")
    parser.add_argument("--start-phase", choices=("graph_first", "all_proofs"), default="graph_first")
    args = parser.parse_args()
    if not 1 <= args.limit <= MAX_ACTIVE_JOBS or not 1 <= args.max_graph_proofs <= args.limit:
        parser.error("Require 1 <= max-graph-proofs <= limit <= %d" % MAX_ACTIVE_JOBS)
    if args.max_seconds <= 0 or not 0 < args.poll_seconds <= 5:
        parser.error("Require positive runtime and poll interval <=5 seconds")
    args.manifest, args.state, args.uploader = args.manifest.resolve(), args.state.resolve(), args.uploader.resolve()
    args.log_dir = (args.log_dir or args.state.parent / "phase-supervisor-logs").resolve()
    runner = Supervisor(args)
    signal.signal(signal.SIGTERM, runner.request_stop)
    signal.signal(signal.SIGINT, runner.request_stop)
    try:
        return runner.run()
    except Exception as error:
        runner.request_stop()
        # Wait in bounded increments if an unexpected supervisor error occurs while a child lives.
        if runner.child is not None:
            while True:
                try:
                    runner.child.wait(timeout=5)
                    break
                except subprocess.TimeoutExpired:
                    continue
        # Do not print arbitrary exception text: client diagnostics belong only in child logs.
        runner.event("SUPERVISOR_HALTED", error_type=type(error).__name__,
                     reason=str(error) if isinstance(error, Halt) else "Unexpected local supervision error; inspect logs")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
