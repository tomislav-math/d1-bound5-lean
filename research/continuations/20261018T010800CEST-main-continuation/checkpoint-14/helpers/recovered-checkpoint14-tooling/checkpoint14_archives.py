"""Deterministic research archives with exact member verification; no project writes."""
from pathlib import Path, PurePosixPath
import gzip, hashlib, io, json, os, stat, tarfile

MAX_BLOB = 100_000_000
RAW_SHARD = 48_000_000
SECRET = __import__("re").compile(rb"gh[pousr]_[A-Za-z0-9_]{30,}|github_pat_[A-Za-z0-9_]{30,}|-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----")
sha = lambda b: hashlib.sha256(b).hexdigest()

def require(ok, message):
    if not ok:
        raise RuntimeError(message)

def relative(name):
    require(isinstance(name, str) and name, "Empty/non-string relative path")
    p = PurePosixPath(name)
    require(not p.is_absolute() and ".." not in p.parts and str(p) == name and
            not any(ord(c) < 32 for c in name), "Unsafe path: " + repr(name))
    return Path(name)

def stable(path):
    path = Path(os.path.abspath(path))
    require(all(not p.is_symlink() for p in [path, *path.parents]), "Symlink path: " + str(path))
    fd = os.open(path, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK)
    try:
        a = os.fstat(fd)
        require(stat.S_ISREG(a.st_mode), "Nonregular source: " + str(path))
        with os.fdopen(fd, "rb", closefd=False) as f:
            data = f.read()
        b = os.fstat(fd)
        c = path.stat(follow_symlinks=False)
        sig = lambda s: (s.st_dev, s.st_ino, s.st_size, s.st_mtime_ns, s.st_ctime_ns)
        require(sig(a) == sig(b) == sig(c) and len(data) == b.st_size,
                "Changed/incomplete read: " + str(path))
        return data
    finally:
        os.close(fd)

def json_bytes(obj):
    return (json.dumps(obj, indent=2, sort_keys=True) + "\n").encode()

def write_new(path, data):
    path = Path(path)
    require(not os.path.lexists(path), "Existing output: " + str(path))
    require(all(not p.is_symlink() for p in [path, *path.parents]), "Symlink output")
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("xb") as f:
        f.write(data)
        f.flush()
        os.fsync(f.fileno())
    require(stable(path) == data, "Output reread mismatch")

def archive_bytes(members):
    """Canonical sorted USTAR headers inside one mtime-zero gzip member."""
    raw = io.BytesIO()
    with tarfile.open(fileobj=raw, mode="w", format=tarfile.USTAR_FORMAT) as tf:
        for name, data in sorted(members.items()):
            relative(name)
            info = tarfile.TarInfo(name)
            info.size = len(data)
            info.mode = 0o644
            info.uid = info.gid = info.mtime = 0
            info.uname = info.gname = ""
            info.type = tarfile.REGTYPE
            tf.addfile(info, io.BytesIO(data))
    compressed = io.BytesIO()
    with gzip.GzipFile(filename="", fileobj=compressed, mode="wb", compresslevel=9, mtime=0) as gz:
        gz.write(raw.getvalue())
    data = compressed.getvalue()
    require(len(data) < MAX_BLOB, "Compressed shard reaches 100MB")
    return data

def check_shard(data, expected):
    """Extract member streams in memory; never use extractall or follow links."""
    require(len(data) < MAX_BLOB, "Oversized archive")
    raw = gzip.decompress(data)  # also checks gzip CRC and complete member lengths
    seen = {}
    with tarfile.open(fileobj=io.BytesIO(raw), mode="r:") as tf:
        for info in tf:
            relative(info.name)
            require(info.isfile() and not info.issym() and not info.islnk(), "Non-file archive entry")
            require(info.name not in seen and info.name in expected, "Extra/duplicate member")
            pin = expected[info.name]
            require(info.size == pin["bytes"] and info.mode == 0o644 and
                    info.uid == info.gid == info.mtime == 0 and
                    info.uname == info.gname == "" and not info.pax_headers,
                    "Noncanonical archive metadata")
            extracted = tf.extractfile(info)
            require(extracted is not None, "Missing member stream")
            content = extracted.read()
            require(len(content) == pin["bytes"] and sha(content) == pin["sha256"],
                    "Extracted member mismatch: " + info.name)
            require(not SECRET.search(content), "Credential-like archived content: " + info.name)
            seen[info.name] = pin
    require(set(seen) == set(expected), "Incomplete archive extraction")
    return seen

def build_set(work, source_files, scopes):
    """source_files maps safe archive names to already verified source paths/pins."""
    require(not os.path.lexists(work), "Archive work directory exists")
    work.mkdir(mode=0o700)
    groups, current, size = [], [], 0
    for name, item in sorted(source_files.items()):
        relative(name)
        cost = ((item["bytes"] + 511) // 512 + 1) * 512
        require(cost <= RAW_SHARD, "Single member exceeds raw shard budget")
        if current and size + cost > RAW_SHARD:
            groups.append(current)
            current, size = [], 0
        current.append(name)
        size += cost
    if current:
        groups.append(current)
    index = dict(format="checkpoint14-exact-archives-v1", scopes=scopes,
                 blob_limit_exclusive=MAX_BLOB, raw_shard_budget=RAW_SHARD,
                 members={}, shards=[])
    for number, names in enumerate(groups):
        contents, pins = {}, {}
        for name in names:
            item = source_files[name]
            b = stable(item["source"])
            require(len(b) == item["bytes"] and sha(b) == item["sha256"], "Source pin changed")
            require(not SECRET.search(b), "Credential-like source")
            contents[name] = b
            pins[name] = dict(bytes=len(b), sha256=sha(b))
        blob = archive_bytes(contents)
        # Reconstruct every member and compare its exact hash/length before writing.
        check_shard(blob, pins)
        filename = f"sources-{number:03}.tar.gz"
        write_new(work / filename, blob)
        check_shard(stable(work / filename), pins)
        index["shards"].append(dict(path=filename, bytes=len(blob), sha256=sha(blob),
                                   members=names))
        for name in names:
            index["members"][name] = dict(**pins[name], shard=filename)
    for name, item in source_files.items():
        b = stable(item["source"])
        require(len(b) == item["bytes"] and sha(b) == item["sha256"], "Source changed during archive")
    write_new(work / "ARCHIVE_INDEX.json", json_bytes(index))
    verify_set(work)
    return index

def verify_set(folder):
    index = json.loads(stable(folder / "ARCHIVE_INDEX.json"))
    require(index["format"] == "checkpoint14-exact-archives-v1", "Unknown archive format")
    require(index["blob_limit_exclusive"] == MAX_BLOB and
            index["raw_shard_budget"] == RAW_SHARD, "Unexpected archive bounds")
    expected_files = {"ARCHIVE_INDEX.json"}
    seen = set()
    for shard in index["shards"]:
        name = shard["path"]
        require(relative(name).parent == Path("."), "Nested archive blob path")
        require(name not in expected_files and name.endswith(".tar.gz"), "Duplicate/invalid shard")
        expected_files.add(name)
        data = stable(folder / name)
        require(len(data) == shard["bytes"] and sha(data) == shard["sha256"], "Shard hash mismatch")
        require(len(shard["members"]) == len(set(shard["members"])), "Duplicate shard member")
        pins = {n: index["members"][n] for n in shard["members"]}
        require(not seen.intersection(pins), "Member appears in two shards")
        require(all(p["shard"] == name for p in pins.values()), "Member shard mismatch")
        check_shard(data, pins)
        seen.update(pins)
    require(seen == set(index["members"]), "Global member coverage mismatch")
    require({p.name for p in folder.iterdir()} == expected_files, "Unexpected archive file")
    return index
