"""Resume private Prove2Me uploads with a bounded shared publish/verify queue.

Only main() imports the existing authorized p2m_client. Importing this module
does not authenticate, access credentials, or contact the platform.
"""
import argparse
import fcntl
import hashlib
import importlib
import json
import os
from pathlib import Path
import re
import signal
import time
import uuid

# The platform permits 100 pending proof submissions and, separately, 100
# pending/compiling publication jobs. Our combined ceiling never exceeds either.
MAX_ACTIVE_JOBS = 100

PUBLISH_PENDING = {"PENDING", "COMPILING"}
PROOF_PENDING = {"PENDING", "COMPILING"}
PROOF_SUCCESS = {"ACCEPTED", "SKETCH_ACCEPTED"}
PROOF_TERMINAL = PROOF_SUCCESS | {"CE", "WA", "SORRY", "FAILED", "ERROR"}


class Halt(RuntimeError):
    pass


def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, ensure_ascii=False).encode()).hexdigest()


def module_name(name, kind):
    return ("Definitions.Def_" if kind == "definition" else "Theorems.Thm_") + name.replace(".", "_")


def platform_imports(source):
    found = set()
    for line in source.splitlines():
        line = line.split("--", 1)[0].strip()
        if line.startswith("import "):
            found.update(x for x in line[7:].split() if x.startswith(("Definitions.", "Theorems.")))
    return found


def validate(manifest, base):
    if manifest.get("private") is not True or not manifest.get("env"):
        raise Halt("Manifest must explicitly select private visibility and a pinned environment")
    nodes = {}
    existing = {}
    for item in manifest.get("existing", []):
        if item["kind"] not in ("definition", "theorem") or not item.get("id"):
            raise Halt("Invalid existing binding")
        if item["name"] in existing:
            raise Halt("Duplicate existing binding: " + item["name"])
        existing[item["name"]] = item
    for raw in manifest["nodes"]:
        node = dict(raw)
        name, kind, payload = node["name"], node["kind"], node["payload"]
        if name in nodes or kind not in ("definition", "theorem"):
            raise Halt("Duplicate node or unsupported kind: " + name)
        if payload.get("private", True) is not True or payload.get("env", manifest["env"]) != manifest["env"]:
            raise Halt("Visibility/environment mismatch: " + name)
        name_key = "definition_name" if kind == "definition" else "theorem_name"
        if payload.get(name_key) != name:
            raise Halt("Payload name mismatch: " + name)
        node["payload"] = {**payload, "private": True, "env": manifest["env"]}
        for field in ("publish_dependencies", "proof_dependencies"):
            node[field] = list(node.get(field, []))
            if name in node[field] or len(set(node[field])) != len(node[field]):
                raise Halt("Self-dependency or duplicate dependency: " + name)
        if node.get("solution"):
            if kind != "theorem" or not node.get("explanation"):
                raise Halt("A proof needs a theorem target and an explanation: " + name)
            path = Path(node["solution"])
            if not path.is_absolute():
                path = base / path
            node["solution"] = str(path.resolve())
            source = path.read_bytes()
            if hashlib.sha256(source).hexdigest() != node.get("solution_sha256"):
                raise Halt("Proof source hash mismatch: " + name)
            if re.search(r"\b" + re.escape(module_name(name, kind)) + r"\b", source.decode()):
                raise Halt("A proof must not import its own target: " + name)
        nodes[name] = node
    kinds = {n: e["kind"] for n, e in existing.items()}
    for name, node in nodes.items():
        if name in kinds and kinds[name] != node["kind"]:
            raise Halt("Existing binding kind mismatch: " + name)
        kinds[name] = node["kind"]
    modules = {module_name(n, k): n for n, k in kinds.items()}
    if len(modules) != len(kinds):
        raise Halt("Platform module name collision")
    for name, node in nodes.items():
        for field in ("publish_dependencies", "proof_dependencies"):
            if any(d not in kinds for d in node[field]):
                raise Halt("Unknown dependency in " + field + ": " + name)
        body = node["payload"].get("definition", "") if node["kind"] == "definition" else node["payload"].get("preamble", "")
        for source, field in [(body, "publish_dependencies")] + ([(Path(node["solution"]).read_text(), "proof_dependencies")] if node.get("solution") else []):
            for module in platform_imports(source):
                if module not in modules or modules[module] not in node[field]:
                    raise Halt("Imported platform dependency is missing from " + field + ": " + name + " / " + module)
    visiting, visited = set(), set()
    def visit(name):
        if name in visited or name not in nodes:
            return
        if name in visiting:
            raise Halt("Cyclic publication dependencies: " + name)
        visiting.add(name)
        for dep in nodes[name]["publish_dependencies"] + nodes[name]["proof_dependencies"]:
            visit(dep)
        visiting.remove(name)
        visited.add(name)
    for name in nodes:
        visit(name)
    return nodes, existing


class Uploader:
    def __init__(self, api, manifest, state_path, limit=15, base=None, emit=None, publish_only=False):
        if not 1 <= limit <= MAX_ACTIVE_JOBS:
            raise Halt("Queue limit must be between 1 and %d" % MAX_ACTIVE_JOBS)
        self.api, self.path, self.limit = api, Path(state_path), limit
        self.publish_only = publish_only
        self.nodes, self.existing = validate(manifest, Path(base or "."))
        self.emit = emit or (lambda event: print(json.dumps(event, ensure_ascii=False), flush=True))
        self.stop = False
        self.deadline = None
        self.state = json.loads(self.path.read_text()) if self.path.exists() else {
            "schema": "p2m-private-batch-v1", "env": manifest["env"], "private": True,
            "entries": {}, "actions": {}, "max_active_observed": 0,
        }
        if self.state["env"] != manifest["env"] or self.state.get("private") is not True:
            raise Halt("Saved state environment/visibility mismatch")
        self.entries = self.state["entries"]
        for name, node in self.nodes.items():
            entry = self.entries.setdefault(name, {"kind": node["kind"]})
            signature = digest({k: node.get(k) for k in ("kind", "payload", "solution_sha256", "explanation", "publish_dependencies", "proof_dependencies")})
            if entry.get("manifest_sha256", signature) != signature:
                raise Halt("Node changed after it entered the upload ledger: " + name)
            entry["manifest_sha256"] = signature
        for name, binding in self.existing.items():
            entry = self.entries.setdefault(name, {"kind": binding["kind"]})
            if entry.get("theorem_id", binding["id"]) != binding["id"]:
                raise Halt("Existing node ID mismatch: " + name)
            entry["theorem_id"] = binding["id"]
            entry["existing"] = True
        for name, entry in self.entries.items():
            if self.is_active(entry) and name not in self.nodes:
                raise Halt("Manifest dropped a pending node: " + name)
        self.recover_actions()
        self.save()

    def save(self):
        self.state["updated_unix"] = time.time()
        self.api.save(self.path, self.state)
        with self.path.open("rb") as stream:
            os.fsync(stream.fileno())

    def check_existing(self):
        """Verify supplied IDs before allowing them to become proof targets/imports."""
        for name, binding in self.existing.items():
            endpoint = "/definitions/" if binding["kind"] == "definition" else "/theorems/"
            item = self.api.request(endpoint + binding["id"])
            returned_name = item.get("definition_name", item.get("theorem_name"))
            returned_env = item.get("mathlib_rev", item.get("env"))
            self.entries[name]["existing_receipt"] = item
            self.save()
            if item.get("visibility") != "private" or returned_name != name or returned_env != self.state["env"]:
                raise Halt("Existing binding visibility/name/environment mismatch: " + name)

    @staticmethod
    def is_active(entry):
        return (bool(entry.get("job_id")) and not entry.get("theorem_id") and entry.get("publish_status", "PENDING") in PUBLISH_PENDING) or (bool(entry.get("submission_id")) and entry.get("proof_status", "PENDING") in PROOF_PENDING)

    def active(self):
        return sum(self.is_active(e) for e in self.entries.values())

    def paused(self):
        return self.stop or (self.deadline is not None and time.monotonic() >= self.deadline)

    def event(self, event, **fields):
        count = self.active()
        if count > self.limit:
            raise Halt("Internal queue bound exceeded")
        self.state["max_active_observed"] = max(count, self.state["max_active_observed"])
        self.save()
        self.emit({"event": event, "active": count, "limit": self.limit, **fields})

    def apply_response(self, action):
        response = action["response"]
        names = action["names"]
        if action["kind"] == "proof":
            entry = self.entries[names[0]]
            entry["submission_id"] = response["submission_id"]
            entry["proof_status"] = response.get("status", "PENDING")
        elif action["kind"] == "definition":
            entry = self.entries[names[0]]
            entry["job_id"] = response["job_id"]
            entry["publish_status"] = "PENDING"
        else:
            jobs = {j["name"]: j["job_id"] for j in response.get("jobs", [])}
            if len(jobs) != len(response.get("jobs", [])) or not set(jobs) <= set(names):
                raise Halt("Batch response contains an unexpected name")
            for name in names:
                entry = self.entries[name]
                if name in jobs:
                    entry["job_id"] = jobs[name]
                    entry["publish_status"] = "PENDING"
                else:
                    entry["publish_status"] = "FAILED"
                    entry["publish_error"] = {"reason": "Not queued in batch response", "response": response}
        action["stage"] = "recorded"

    def recover_actions(self):
        for action in self.state["actions"].values():
            if action["stage"] == "intent":
                raise Halt("Previous request outcome is unknown; reconcile server records before retrying: " + str(action["names"]))
            if action["stage"] == "received":
                self.apply_response(action)

    def mutate(self, kind, names, call, request_body=None):
        action_id = uuid.uuid4().hex
        action = {"kind": kind, "names": names, "stage": "intent", "started_unix": time.time(), "request": request_body}
        self.state["actions"][action_id] = action
        self.save()
        # An exception leaves an explicit ambiguous intent. Never repeat it blindly.
        response = call()
        action.update(stage="received", response=response, received_unix=time.time())
        self.save()
        self.apply_response(action)
        self.event("PROOFS_QUEUED" if kind == "proof" else "PUBLISH_QUEUED", names=names)

    def registered(self, names):
        return all(self.entries.get(n, {}).get("theorem_id") for n in names)

    def fill(self):
        changed = False
        # Filling the queue never waits for a compilation or a proof verdict.
        while not self.paused() and self.active() < self.limit:
            ready_proofs = [] if self.publish_only else [n for n, d in self.nodes.items() if d.get("solution") and self.entries[n].get("theorem_id") and not self.entries[n].get("submission_id") and self.registered(d["proof_dependencies"])]
            if ready_proofs:
                name = ready_proofs[0]
                node, entry = self.nodes[name], self.entries[name]
                if hashlib.sha256(Path(node["solution"]).read_bytes()).hexdigest() != node["solution_sha256"]:
                    raise Halt("Proof file changed before upload: " + name)
                self.mutate("proof", [name], lambda: self.api.verify(entry["theorem_id"], node["solution"], node["explanation"]), {"theorem_id": entry["theorem_id"], "solution": node["solution"], "sha256": node["solution_sha256"], "explanation": node["explanation"]})
                changed = True
                continue
            ready = [n for n, d in self.nodes.items() if not self.entries[n].get("theorem_id") and not self.entries[n].get("job_id") and self.entries[n].get("publish_status") != "FAILED" and self.registered(d["publish_dependencies"])]
            definitions = [n for n in ready if self.nodes[n]["kind"] == "definition"]
            if definitions:
                name = definitions[0]
                payload = self.nodes[name]["payload"]
                self.mutate("definition", [name], lambda: self.api.request("/submit-definition", "POST", body=payload), payload)
                changed = True
                continue
            names = [n for n in ready if self.nodes[n]["kind"] == "theorem"][:self.limit - self.active()]
            if not names:
                break
            body = {"problems": [{k: v for k, v in self.nodes[n]["payload"].items() if k not in ("env", "private")} for n in names], "env": self.state["env"], "private": True}
            self.mutate("theorems", names, lambda: self.api.request("/submit-problem", "POST", body=body), body)
            changed = True
        return changed

    def poll(self):
        for name, entry in self.entries.items():
            if self.paused():
                break
            if entry.get("job_id") and not entry.get("theorem_id") and entry.get("publish_status", "PENDING") in PUBLISH_PENDING:
                job = self.api.request("/publish-jobs/" + entry["job_id"])
                entry["publish_receipt"] = job
                status = job["status"]
                previous = entry.get("publish_status", "PENDING")
                if status not in PUBLISH_PENDING | {"PUBLISHED", "FAILED", "ERROR"}:
                    self.save()
                    raise Halt("Unknown publish status: " + status)
                entry["publish_status"] = status
                if status == "PUBLISHED":
                    node = self.nodes[name]
                    expected = node["payload"]
                    if job.get("visibility") != "private" or job.get("theorem_name") != name:
                        self.save()
                        raise Halt("Published node visibility/name mismatch: " + name)
                    expected_body = expected.get("definition") if node["kind"] == "definition" else expected.get("preamble", "")
                    if job.get("definitions", "") != expected_body or (node["kind"] == "theorem" and job.get("formal_statement") != expected["formal_statement"]):
                        self.save()
                        raise Halt("Published Lean source differs from submitted payload: " + name)
                    entry["theorem_id"] = job["theorem_id"]
                if status != previous:
                    self.event("PUBLISH_STATUS", name=name, status=status)
                else:
                    self.save()
            if entry.get("submission_id") and entry.get("proof_status", "PENDING") in PROOF_PENDING:
                verdict = self.api.request("/verify?submission_id=" + entry["submission_id"])
                entry["proof_receipt"] = verdict
                status = verdict["status"]
                previous = entry.get("proof_status", "PENDING")
                if status not in PROOF_PENDING | PROOF_TERMINAL:
                    self.save()
                    raise Halt("Unknown proof status: " + status)
                entry["proof_status"] = status
                if status != previous:
                    self.event("PROOF_STATUS", name=name, status=status)
                else:
                    self.save()

    def done(self, name):
        node, entry = self.nodes[name], self.entries[name]
        if entry.get("publish_status") in {"FAILED", "ERROR"}:
            return True
        if not entry.get("theorem_id"):
            return False
        if self.publish_only:
            # Previously submitted proofs remain owned by this ledger and must
            # still be polled. This mode only prevents NEW proof submissions.
            return not (entry.get("submission_id") and entry.get("proof_status", "PENDING") in PROOF_PENDING)
        return not node.get("solution") or entry.get("proof_status") in PROOF_TERMINAL

    def run(self, max_seconds=3600, poll_seconds=3):
        if not 0 < poll_seconds <= 5 or max_seconds <= 0:
            raise Halt("Invalid poll interval or runtime limit")
        deadline = time.monotonic() + max_seconds
        self.deadline = deadline
        while not self.stop and time.monotonic() < deadline:
            changed = self.fill()
            if self.paused():
                break
            if all(self.done(n) for n in self.nodes):
                failed = [n for n in self.nodes if self.entries[n].get("publish_status") in {"FAILED", "ERROR"} or self.entries[n].get("proof_status") in PROOF_TERMINAL - PROOF_SUCCESS]
                self.event("COMPLETE", failed=failed)
                return 1 if failed else 0
            if not self.active() and not changed:
                self.event("BLOCKED_DEPENDENCIES", nodes=[n for n in self.nodes if not self.done(n)])
                return 2
            self.poll()
            # Newly available slots/dependencies are filled before sleeping.
            self.fill()
            if all(self.done(n) for n in self.nodes):
                continue
            time.sleep(min(poll_seconds, max(0, deadline - time.monotonic())))
        self.event("STOPPED" if self.stop else "TIME_LIMIT_CHECKPOINT")
        return 3


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--state", type=Path, required=True)
    parser.add_argument("--limit", type=int, default=15)
    parser.add_argument("--max-seconds", type=float, default=3600)
    parser.add_argument("--poll-seconds", type=float, default=3)
    parser.add_argument("--publish-only", action="store_true", help="Register nodes without submitting new proofs; reuse this manifest/state later without the flag")
    args = parser.parse_args()
    args.state.parent.mkdir(parents=True, exist_ok=True)
    lock = open(str(args.state) + ".lock", "a+")
    try:
        fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        raise SystemExit("Another uploader owns this state ledger")
    api = importlib.import_module("p2m_client")
    runner = Uploader(api, json.loads(args.manifest.read_text()), args.state, args.limit, args.manifest.parent, publish_only=args.publish_only)
    def stop(signum, frame):
        runner.stop = True
    signal.signal(signal.SIGINT, stop)
    signal.signal(signal.SIGTERM, stop)
    try:
        runner.check_existing()
        return runner.run(args.max_seconds, args.poll_seconds)
    finally:
        runner.save()
        lock.close()


if __name__ == "__main__":
    raise SystemExit(main())
