#!/usr/bin/env python3
"""Verify that the reading copy differs from frozen v4 only by its date."""
from pathlib import Path
import hashlib

root = Path(__file__).resolve().parents[1]
old = (root / 'verification/v4/output/D1_bound5-v4.tex').read_bytes()
new = (root / 'paper/Diophantine_tuples_bound_five_2026-10-15.tex').read_bytes()
expected = '776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
if hashlib.sha256(old).hexdigest() != expected:
    raise SystemExit('FAIL: frozen v4 source digest')
if old.count(b'\\date{}') != 1:
    raise SystemExit('FAIL: original date declaration')
if new != old.replace(b'\\date{}', b'\\date{15 October 2026}', 1):
    raise SystemExit('FAIL: unexpected manuscript changes')
print('PASS: the sole source change is the displayed date 15 October 2026')
