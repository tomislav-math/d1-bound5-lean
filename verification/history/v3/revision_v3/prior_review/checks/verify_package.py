"""Verify bytes of the delivered diagnostic evidence; not a proof checker."""
from pathlib import Path
import hashlib, json

root = Path(__file__).resolve().parents[1]
manifest = json.loads((root/'records/package_manifest.json').read_text())
for name, expected in manifest['sha256'].items():
    path = root/name
    assert path.is_file(), name
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected, name
print(f"PASS: {len(manifest['sha256'])} packaged files match their recorded SHA-256.")
