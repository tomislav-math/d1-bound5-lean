"""Local dummy safety tests; no Lean, remote operations, or production writes."""
import hashlib
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location("materializer", Path(__file__).with_name("materialize_inputs.py"))
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)


class Safety(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name).resolve()
        self.sources = self.root / "sources"
        self.sources.mkdir()
        self.destination = self.root / "new"

    def tearDown(self):
        self.tmp.cleanup()

    def item(self, path="nested/item.txt", content=b"exact"):
        return dict(path=path, sha256=hashlib.sha256(content).hexdigest(), bytes=len(content))

    def req(self, files):
        path = self.root / "requirements.json"
        data = json.dumps(dict(format="selected-scale-input-requirements-v1", files=files)).encode()
        path.write_bytes(data)
        return m.requirements(path, hashlib.sha256(data).hexdigest())

    def test_exact_copy_and_duplicate_identical_sources(self):
        for name in ("one", "two"):
            folder = self.sources / name
            folder.mkdir()
            (folder / "item.txt").write_bytes(b"exact")
        files = self.req([self.item()])
        selected, missing, rejected = m.inventory(files, [self.sources])
        self.assertFalse(missing or rejected)
        self.assertEqual(selected[0]["exact_candidates"], 2)
        self.assertFalse(self.destination.exists())
        m.materialize(selected, self.destination, "test")
        self.assertEqual((self.destination / "nested/item.txt").read_bytes(), b"exact")
        self.assertEqual((self.sources / "one/item.txt").read_bytes(), b"exact")

    def test_wrong_hash_and_missing_inventory_has_no_writes(self):
        (self.sources / "item.txt").write_bytes(b"wrong")
        selected, missing, rejected = m.inventory(self.req([self.item()]), [self.sources])
        self.assertFalse(selected or rejected)
        self.assertEqual(len(missing), 1)
        self.assertFalse(self.destination.exists())

    def test_symlink_file_and_directory_never_supply_inputs(self):
        target = self.root / "target"
        target.mkdir()
        (target / "item.txt").write_bytes(b"exact")
        (self.sources / "item.txt").symlink_to(target / "item.txt")
        (self.sources / "linked").symlink_to(target, target_is_directory=True)
        selected, missing, rejected = m.inventory(self.req([self.item()]), [self.sources])
        self.assertFalse(selected)
        self.assertEqual(len(missing), 1)
        self.assertEqual(len(rejected), 1)

    def test_root_or_destination_parent_symlink_rejected(self):
        link = self.root / "link"
        link.symlink_to(self.sources, target_is_directory=True)
        with self.assertRaises(OSError):
            m.inventory(self.req([self.item()]), [link])
        with self.assertRaises(OSError):
            m.destination_parent(link / "new")

    def test_changed_source_rejected_before_destination_creation(self):
        source = self.sources / "item.txt"
        source.write_bytes(b"exact")
        selected, _, _ = m.inventory(self.req([self.item()]), [self.sources])
        source.write_bytes(b"wrong")
        with self.assertRaises(ValueError):
            m.materialize(selected, self.destination, "test")
        self.assertFalse(self.destination.exists())

    def test_new_symlink_source_rejected_before_writes(self):
        source = self.sources / "item.txt"
        source.write_bytes(b"exact")
        selected, _, _ = m.inventory(self.req([self.item()]), [self.sources])
        source.unlink()
        target = self.root / "target.txt"
        target.write_bytes(b"exact")
        source.symlink_to(target)
        with self.assertRaises(OSError):
            m.materialize(selected, self.destination, "test")
        self.assertFalse(self.destination.exists())

    def test_existing_directory_and_symlink_are_never_overwritten(self):
        self.destination.mkdir()
        (self.destination / "sentinel").write_bytes(b"keep")
        with self.assertRaises(ValueError):
            m.materialize([], self.destination, "test")
        self.assertEqual((self.destination / "sentinel").read_bytes(), b"keep")
        link = self.root / "link"
        link.symlink_to(self.destination, target_is_directory=True)
        with self.assertRaises(ValueError):
            m.destination_parent(link)

    def test_requirement_traversal_duplicate_and_file_directory_conflicts(self):
        for path in ("../escape", "a/../escape", "/escape", "./item", "a//item", "a\\item"):
            with self.subTest(path=path), self.assertRaises(ValueError):
                self.req([self.item(path)])
        with self.assertRaises(ValueError):
            self.req([self.item(), self.item()])
        with self.assertRaises(ValueError):
            self.req([self.item("a"), self.item("a/b")])

    def test_requirements_wrong_hash_or_duplicate_json_keys_rejected(self):
        path = self.root / "requirements.json"
        path.write_bytes(b'{"format":1,"format":2}')
        with self.assertRaises(ValueError):
            m.requirements(path, "0" * 64)
        with self.assertRaises(ValueError):
            m.requirements(path, hashlib.sha256(path.read_bytes()).hexdigest())

    def test_same_basename_different_hashes_select_correct_sources(self):
        for name, content in (("one", b"exact"), ("two", b"other")):
            folder = self.sources / name
            folder.mkdir()
            (folder / "item.txt").write_bytes(content)
        files = self.req([self.item("a/item.txt"), self.item("b/item.txt", b"other")])
        selected, missing, _ = m.inventory(files, [self.sources])
        self.assertFalse(missing)
        m.materialize(selected, self.destination, "test")
        self.assertEqual((self.destination / "a/item.txt").read_bytes(), b"exact")
        self.assertEqual((self.destination / "b/item.txt").read_bytes(), b"other")


if __name__ == "__main__":
    unittest.main()
