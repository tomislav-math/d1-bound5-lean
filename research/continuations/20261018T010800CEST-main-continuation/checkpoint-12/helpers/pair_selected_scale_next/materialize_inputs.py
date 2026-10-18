"""Materialize a NEW portable input bundle from existing hash-pinned files.

No generator is imported or executed. Default mode inventories only. With
--apply, every requirement must first resolve to an existing regular file
with the exact basename, byte count, and SHA256. All selected bytes are read
and rechecked before the destination directory is created. Existing paths
are never overwritten. Symlinks are never followed, including ancestors.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import sys


def fail(message):
    raise ValueError(message)


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            fail("Duplicate JSON key: " + key)
        result[key] = value
    return result


def absolute(path):
    # Do not resolve(): that would conceal symlink ancestors.
    return Path(os.path.abspath(os.fspath(path)))


def open_directory(path):
    """Open an absolute directory by no-follow traversal from / (Mac/POSIX)."""
    path = absolute(path)
    fd = os.open("/", os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW)
    try:
        for part in path.parts[1:]:
            child = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW,
                            dir_fd=fd)
            os.close(fd)
            fd = child
        return fd
    except BaseException:
        os.close(fd)
        raise


def read_regular(path, expected_size=None):
    """Reject symlinks, nonregular inputs, and files changing during a read."""
    path = absolute(path)
    parent = open_directory(path.parent)
    fd = None
    try:
        fd = os.open(path.name, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK,
                     dir_fd=parent)
        before = os.fstat(fd)
        if not stat.S_ISREG(before.st_mode):
            fail("Not a regular file: " + str(path))
        if expected_size is not None and before.st_size != expected_size:
            fail("Changed byte count: " + str(path))
        chunks = []
        while True:
            data = os.read(fd, 1024 * 1024)
            if not data:
                break
            chunks.append(data)
        after = os.fstat(fd)
        fingerprint = lambda s: (s.st_dev, s.st_ino, s.st_size,
                                 s.st_mtime_ns, s.st_ctime_ns)
        if fingerprint(before) != fingerprint(after):
            fail("Changed during read: " + str(path))
        data = b"".join(chunks)
        if len(data) != after.st_size:
            fail("Incomplete read: " + str(path))
        return data
    finally:
        if fd is not None:
            os.close(fd)
        os.close(parent)


def relative_path(text):
    if not isinstance(text, str) or not text or "\\" in text or "\x00" in text:
        fail("Invalid relative path")
    path = PurePosixPath(text)
    if path.is_absolute() or any(x in ("", ".", "..") for x in text.split("/")):
        fail("Traversal or noncanonical relative path: " + text)
    if str(path) != text:
        fail("Noncanonical relative path: " + text)
    return path


def requirements(path, expected_sha):
    data = read_regular(path)
    if hashlib.sha256(data).hexdigest() != expected_sha:
        fail("Requirements SHA256 mismatch")
    obj = json.loads(data, object_pairs_hook=unique_object)
    if obj.get("format") != "selected-scale-input-requirements-v1":
        fail("Unknown requirements format")
    files, by_path = obj.get("files"), {}
    if not isinstance(files, list) or not files:
        fail("Requirements must be a nonempty list")
    for item in files:
        if not isinstance(item, dict):
            fail("Invalid requirement")
        path = str(relative_path(item.get("path")))
        digest, size = item.get("sha256"), item.get("bytes")
        if not isinstance(digest, str) or re.fullmatch(r"[0-9a-f]{64}", digest) is None:
            fail("Invalid SHA256: " + path)
        if type(size) is not int or size < 0:
            fail("Invalid byte count: " + path)
        if path in by_path:
            fail("Duplicate or conflicting destination: " + path)
        by_path[path] = dict(path=path, sha256=digest, bytes=size)
    for path in by_path:
        for parent in PurePosixPath(path).parents:
            if str(parent) in by_path:
                fail("File/directory destination conflict: " + path)
    if any(p == "materialization_manifest.json" or p.startswith("materialization_manifest.json/")
           for p in by_path):
        fail("Reserved manifest destination")
    return [by_path[p] for p in sorted(by_path)]


def inventory(files, roots):
    wanted = {}
    for item in files:
        wanted.setdefault(PurePosixPath(item["path"]).name, set()).add(
            (item["bytes"], item["sha256"]))
    matches, rejected, seen = {}, [], set()
    for root in roots:
        fd = open_directory(root)
        os.close(fd)
        # fwalk itself is read-only; follow_symlinks=False never enters links.
        # Actual reads additionally walk every ancestor using O_NOFOLLOW.
        for directory, dirs, names, directory_fd in os.fwalk(root, follow_symlinks=False):
            dirs.sort()
            for name in list(dirs):
                info = os.stat(name, dir_fd=directory_fd, follow_symlinks=False)
                if not stat.S_ISDIR(info.st_mode):
                    dirs.remove(name)
            for name in sorted(set(names) & wanted.keys()):
                path = str(Path(directory) / name)
                if path in seen:
                    continue
                seen.add(path)
                try:
                    info = os.stat(name, dir_fd=directory_fd, follow_symlinks=False)
                    if not stat.S_ISREG(info.st_mode):
                        fail("Nonregular or symlink candidate")
                    if info.st_size not in {size for size, _ in wanted[name]}:
                        continue
                    data = read_regular(path, info.st_size)
                    digest = hashlib.sha256(data).hexdigest()
                    if (len(data), digest) in wanted[name]:
                        matches.setdefault((name, len(data), digest), []).append(path)
                except (OSError, ValueError) as exc:
                    rejected.append(dict(path=path, reason=str(exc)))
    selected, missing = [], []
    for item in files:
        key = (PurePosixPath(item["path"]).name, item["bytes"], item["sha256"])
        candidates = sorted(matches.get(key, []), key=lambda p: (len(p), p))
        if not candidates:
            missing.append(item)
        else:
            selected.append(dict(item, source=candidates[0], exact_candidates=len(candidates)))
    return selected, missing, rejected


def destination_parent(destination):
    destination = absolute(destination)
    if destination == Path("/"):
        fail("Destination must be a NEW child directory")
    parent = open_directory(destination.parent)
    try:
        try:
            os.stat(destination.name, dir_fd=parent, follow_symlinks=False)
        except FileNotFoundError:
            return destination, parent
        fail("Destination already exists: " + str(destination))
    except BaseException:
        os.close(parent)
        raise


def write_new(root_fd, relative, data):
    parts = relative_path(relative).parts
    directory = os.dup(root_fd)
    fd = None
    try:
        for part in parts[:-1]:
            try:
                os.mkdir(part, mode=0o700, dir_fd=directory)
            except FileExistsError:
                pass
            child = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW,
                            dir_fd=directory)
            os.close(directory)
            directory = child
        fd = os.open(parts[-1], os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW,
                     0o600, dir_fd=directory)
        view = memoryview(data)
        while view:
            count = os.write(fd, view)
            if count <= 0:
                fail("Incomplete output write: " + relative)
            view = view[count:]
    finally:
        if fd is not None:
            os.close(fd)
        os.close(directory)


def materialize(selected, destination, requirement_sha):
    destination, parent = destination_parent(destination)
    root_fd = None
    try:
        # Final full fresh reads BEFORE ANY directory or file is created.
        payloads = {}
        for item in selected:
            data = read_regular(item["source"], item["bytes"])
            if hashlib.sha256(data).hexdigest() != item["sha256"]:
                fail("Source changed since inventory: " + item["source"])
            payloads[item["path"]] = data
        os.mkdir(destination.name, mode=0o700, dir_fd=parent)
        root_fd = os.open(destination.name, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW,
                          dir_fd=parent)
        for item in selected:
            write_new(root_fd, item["path"], payloads[item["path"]])
        manifest = dict(requirements_sha256=requirement_sha, files=selected,
                        file_count=len(selected), total_bytes=sum(x["bytes"] for x in selected))
        write_new(root_fd, "materialization_manifest.json",
                  (json.dumps(manifest, indent=2) + "\n").encode())
    finally:
        if root_fd is not None:
            os.close(root_fd)
        os.close(parent)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--requirements", type=Path, required=True)
    parser.add_argument("--requirements-sha256", required=True)
    parser.add_argument("--search-root", type=Path, action="append", required=True)
    parser.add_argument("--destination", type=Path, required=True)
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()
    files = requirements(args.requirements, args.requirements_sha256)
    destination, parent = destination_parent(args.destination)
    os.close(parent)
    selected, missing, rejected = inventory(files, [absolute(p) for p in args.search_root])
    report = dict(mode="apply" if args.apply else "read-only inventory", required=len(files),
                  found=len(selected), bytes=sum(x["bytes"] for x in selected),
                  destination=str(destination), missing=missing, rejected_candidates=rejected)
    print(json.dumps(report, indent=2), flush=True)
    if missing:
        return 2
    if args.apply:
        materialize(selected, destination, args.requirements_sha256)
        print(json.dumps(dict(created=str(destination), files=len(selected),
                              inputs_copied_exactly=True)), flush=True)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, TypeError) as exc:
        print(json.dumps(dict(error=str(exc), writes_may_be_partial=
                              "Only --apply can create its new destination; existing paths are never overwritten.")),
              file=sys.stderr)
        sys.exit(1)
